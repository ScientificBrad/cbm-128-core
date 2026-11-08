"""
Hardware Peripheral Subsystem for Commodore 128:
- MOS 8564/8566 VIC-IIe ($D000-$D030): 40-column video, raster counter, raster IRQ, extended keyboard scan ($D02F), 2 MHz clock control ($D030)
- MOS 6581/8580 SID ($D400-$D41F): 3-voice sound synthesizer & A/D paddle registers
- MOS 8563 VDC ($D600-$D601): 80-column RGBI video controller with 16 KB dedicated VRAM and block copy/fill engine
- Color RAM ($D800-$DBFF): 1 KB 4-bit color nybble RAM (2 banks/processor/VIC selectable)
- MOS 6526 CIA1 ($DC00-$DC0F): 8x8 standard + 3x8 extended keyboard matrix scanner, joystick ports, Interval Timers A & B, TOD clock
- MOS 6526 CIA2 ($DD00-$DD0F): IEC Serial Bus lines, VIC-IIe 16 KB bank select, RS-232 user port, NMI generation
"""

from .mmu import C128MMUAndBus

class C128Peripherals:
    def __init__(self, mmu: C128MMUAndBus):
        self.mmu = mmu
        mmu.peripherals = self

        # 1 KB Color RAM ($D800-$DBFF) - C128 actually has 2x 1KB Color RAM banks controlled by $0001 bit 0/1
        self.color_ram = [bytearray(1024), bytearray(1024)]

        # VIC-IIe Registers ($D000-$D030)
        self.vic_regs = bytearray(0x40)
        self.vic_regs[0x2F] = 0xFF  # Extended keyboard row select ($D02F)
        self.vic_regs[0x30] = 0xFC  # 2 MHz clock & test bit ($D030)
        self.raster_y = 0
        self.raster_cycle_accum = 0
        self.vic_irq_latch = 0x00   # $D019
        self.vic_irq_enable = 0x00  # $D01A

        # 8563 VDC ($D600-$D601) + 16 KB (or 64 KB) Dedicated VRAM
        self.vdc_reg_index = 0
        self.vdc_regs = bytearray(38)
        self.vdc_vram = bytearray(65536)
        self.vdc_status = 0x80      # Bit 7 = STATUS ready (1 = ready!), Bits 0-2 = silicon version (1 = 8563 R7A)

        # 6581/8580 SID ($D400-$D41F)
        self.sid_regs = bytearray(0x20)
        self.sid_phase = [0, 0, 0]
        self.io_tracer = None

        # CIA1 ($DC00-$DC0F) and CIA2 ($DD00-$DD0F)
        self.cia1_pra = 0xFF
        self.cia1_prb = 0xFF
        self.cia1_ddra = 0xFF
        self.cia1_ddrb = 0x00
        self.cia1_ta = 0xFFFF
        self.cia1_ta_latch = 0xFFFF
        self.cia1_tb = 0xFFFF
        self.cia1_tb_latch = 0xFFFF
        self.cia1_icr_data = 0x00
        self.cia1_icr_mask = 0x00
        self.cia1_cra = 0x00
        self.cia1_crb = 0x00
        self.cia1_tod = bytearray(4)
        self.cia1_sdr_shifts_left = 0

        self.cia2_pra = 0x07
        self.cia2_prb = 0xFF
        self.cia2_ddra = 0x3F
        self.cia2_ddrb = 0x00
        self.cia2_ta = 0xFFFF
        self.cia2_ta_latch = 0xFFFF
        self.cia2_tb = 0xFFFF
        self.cia2_tb_latch = 0xFFFF
        self.cia2_icr_data = 0x00
        self.cia2_icr_mask = 0x00
        self.cia2_cra = 0x00
        self.cia2_crb = 0x00
        self.cia2_tod = bytearray(4)

        # Keyboard Matrix:
        # 8 standard rows ($DC00 bits 0-7) + 3 extended rows ($D02F bits 0-2), each 8 columns ($DC01 bits 0-7)
        # Value 1 = key released, 0 = key pressed (active low)
        self.key_matrix = [0xFF] * 11
        # Shift / Control / C= modifier state or queued PETSCII keystrokes for injection
        self.key_queue = []

    @property
    def irq_pending(self) -> bool:
        vic_irq = (self.vic_irq_latch & 0x80) != 0
        cia1_irq = (self.cia1_icr_data & 0x80) != 0
        return vic_irq or cia1_irq

    @property
    def nmi_pending(self) -> bool:
        return (self.cia2_icr_data & 0x80) != 0

    def press_matrix_key(self, row: int, col: int):
        if 0 <= row < 11 and 0 <= col < 8:
            self.key_matrix[row] &= ~(1 << col)

    def release_matrix_key(self, row: int, col: int):
        if 0 <= row < 11 and 0 <= col < 8:
            self.key_matrix[row] |= (1 << col)

    def release_all_keys(self):
        for i in range(11):
            self.key_matrix[i] = 0xFF

    def press_named_key(self, key_name: str):
        """Presses a key (e.g. 'A', '1', 'RETURN', 'F1', 'STOP', 'HELP') on the physical 11x8 keyboard matrix."""
        from .debugger import C128_KEY_COORDS
        k = key_name.upper() if len(key_name) == 1 else key_name
        if k in C128_KEY_COORDS:
            row, col, shift = C128_KEY_COORDS[k]
            if shift:
                self.press_matrix_key(1, 7)  # Left Shift
            self.press_matrix_key(row, col)

    def release_named_key(self, key_name: str):
        from .debugger import C128_KEY_COORDS
        k = key_name.upper() if len(key_name) == 1 else key_name
        if k in C128_KEY_COORDS:
            row, col, shift = C128_KEY_COORDS[k]
            self.release_matrix_key(row, col)
            if shift:
                self.release_matrix_key(1, 7)

    def synthesize_sid_pcm(self, num_samples: int = 256, sample_rate: int = 44100, clock_hz: float = 1022727.0) -> list[int]:
        """Synthesizes 16-bit signed PCM audio samples from the live 3-voice SID registers ($D400-$D418)."""
        vol = self.sid_regs[0x18] & 0x0F
        if vol == 0:
            return [0] * num_samples
        out = []
        for _ in range(num_samples):
            mix = 0
            for v in range(3):
                b = v * 7
                ctrl = self.sid_regs[b + 4]
                if (ctrl & 0x01) == 0:
                    continue
                freq_word = self.sid_regs[b] | (self.sid_regs[b + 1] << 8)
                step = int((freq_word * clock_hz / sample_rate) * 256.0)
                self.sid_phase[v] = (self.sid_phase[v] + step) & 0xFFFFFFFF
                top12 = (self.sid_phase[v] >> 20) & 0xFFF
                if ctrl & 0x20:  # Sawtooth
                    s = (top12 - 2048) * 8
                elif ctrl & 0x10:  # Triangle
                    tri = top12 if top12 < 2048 else (4095 - top12)
                    s = (tri - 1024) * 16
                elif ctrl & 0x40:  # Pulse
                    pw = self.sid_regs[b + 2] | ((self.sid_regs[b + 3] & 0x0F) << 8)
                    s = 16384 if top12 >= pw else -16384
                else:
                    s = 0
                mix += s
            sample = max(-32768, min(32767, int((mix * vol) // 45)))
            out.append(sample)
        return out

    def inject_petscii(self, text: str):
        """Queues PETSCII characters into the C128 KERNAL keyboard buffer ($034A-$0353, count at $D0)."""
        for ch in text:
            c = ord(ch)
            if ch == "\n":
                c = 0x0D
            elif "a" <= ch <= "z":
                c = ord(ch.upper())
            self.key_queue.append(c)

    def feed_kernal_key_buffer(self):
        """Feeds queued characters directly into the C128 KERNAL keyboard buffer when ready ($D0 < $0A20)."""
        if not self.key_queue:
            return
        # C128 KERNAL keyboard buffer count is at Zero Page $D0 (NDX), max size at $0A20 (XMAX, default 10),
        # and the 10-byte circular/FIFO buffer is at $034A-$0353!
        ndx = self.mmu.ram[0][0x00D0]
        xmax = self.mmu.ram[0][0x0A20] or 10
        while self.key_queue and ndx < xmax:
            ch = self.key_queue.pop(0)
            self.mmu.ram[0][0x034A + ndx] = ch & 0xFF
            ndx += 1
            self.mmu.ram[0][0x00D0] = ndx

    def step_cycles(self, cycles: int):
        # 1. Advance VIC-IIe Raster Counter (63 cycles per scanline, 312 scanlines PAL / 263 NTSC)
        self.raster_cycle_accum += cycles
        while self.raster_cycle_accum >= 63:
            self.raster_cycle_accum -= 63
            self.raster_y = (self.raster_y + 1) % 312
            # Update $D012 and bit 7 of $D011
            self.vic_regs[0x12] = self.raster_y & 0xFF
            if self.raster_y & 0x100:
                self.vic_regs[0x11] |= 0x80
            else:
                self.vic_regs[0x11] &= 0x7F

            # Check Raster IRQ target
            target_raster = self.vic_regs[0x12]  # Wait: need stored target raster!
            if self.raster_y == getattr(self, "_target_raster", 0x1000):
                self.vic_irq_latch |= 0x01
                if self.vic_irq_enable & 0x01:
                    self.vic_irq_latch |= 0x80

            # Also trigger raster compare if _target_raster not explicitly set and $D01A bit 0 enabled at vblank line 251
            if (self.vic_irq_enable & 0x01) and self.raster_y == getattr(self, "_target_raster", 251):
                self.vic_irq_latch |= 0x81

        # 2. Advance CIA1 Timer A & Timer B
        if self.cia1_cra & 0x01:
            self.cia1_ta -= cycles
            while self.cia1_ta <= 0:
                self.cia1_icr_data |= 0x01
                if self.cia1_icr_mask & 0x01:
                    self.cia1_icr_data |= 0x80
                # If SPMODE = 1 ($DC0E bit 6) and serial shift register is shifting out:
                if (self.cia1_cra & 0x40) and self.cia1_sdr_shifts_left > 0:
                    self.cia1_sdr_shifts_left -= 1
                    if self.cia1_sdr_shifts_left == 0:
                        self.cia1_icr_data |= 0x08  # SDR transmit complete!
                        if self.cia1_icr_mask & 0x08:
                            self.cia1_icr_data |= 0x80
                if self.cia1_cra & 0x08:  # One-shot
                    self.cia1_cra &= ~0x01
                    self.cia1_ta = max(1, self.cia1_ta_latch)
                    break
                self.cia1_ta += max(1, self.cia1_ta_latch)

        if self.cia1_crb & 0x01:
            self.cia1_tb -= cycles
            if self.cia1_tb <= 0:
                self.cia1_icr_data |= 0x02
                if self.cia1_icr_mask & 0x02:
                    self.cia1_icr_data |= 0x80
                if self.cia1_crb & 0x08:
                    self.cia1_crb &= ~0x01
                self.cia1_tb = max(1, self.cia1_tb_latch)

    def _scan_keyboard_columns(self) -> int:
        """Evaluates active-low keyboard matrix columns ($DC01) from $DC00 (rows 0-7) and $D02F (rows 8-10)."""
        result = 0xFF
        pra_out = self.cia1_pra | (~self.cia1_ddra & 0xFF)
        ext_out = self.vic_regs[0x2F] | 0xF8

        for row in range(8):
            if (pra_out & (1 << row)) == 0:
                result &= self.key_matrix[row]
        for ext_row in range(3):
            if (ext_out & (1 << ext_row)) == 0:
                result &= self.key_matrix[8 + ext_row]
        return result

    def _vdc_execute_block_op(self):
        """Executes 8563 VDC block copy or block fill when Register 30 (Word Count) is written."""
        count = self.vdc_regs[30]
        if count == 0:
            count = 256
        dest = ((self.vdc_regs[18] << 8) | self.vdc_regs[19]) & 0xFFFF
        is_copy = (self.vdc_regs[24] & 0x80) != 0
        if is_copy:
            src = ((self.vdc_regs[32] << 8) | self.vdc_regs[33]) & 0xFFFF
            for _ in range(count):
                self.vdc_vram[dest & 0xFFFF] = self.vdc_vram[src & 0xFFFF]
                dest = (dest + 1) & 0xFFFF
                src = (src + 1) & 0xFFFF
            self.vdc_regs[32] = (src >> 8) & 0xFF
            self.vdc_regs[33] = src & 0xFF
        else:
            fill_byte = self.vdc_regs[31]
            for _ in range(count):
                self.vdc_vram[dest & 0xFFFF] = fill_byte
                dest = (dest + 1) & 0xFFFF
        self.vdc_regs[18] = (dest >> 8) & 0xFF
        self.vdc_regs[19] = dest & 0xFF

    def read_io(self, addr: int) -> int:
        # $D000-$D3FF: VIC-IIe (mirrored every 64 bytes)
        if 0xD000 <= addr <= 0xD3FF:
            reg = addr & 0x3F
            if reg == 0x11:
                return (self.vic_regs[0x11] & 0x7F) | (0x80 if (self.raster_y & 0x100) else 0x00)
            if reg == 0x12:
                return self.raster_y & 0xFF
            if reg == 0x19:
                return self.vic_irq_latch | 0x70
            if reg == 0x1A:
                return self.vic_irq_enable | 0xF0
            if reg == 0x2F:
                return self.vic_regs[0x2F] | 0xF8
            if reg == 0x30:
                return self.vic_regs[0x30] | 0xFC
            if reg > 0x30:
                return 0xFF
            return self.vic_regs[reg]

        # $D400-$D4FF: SID
        if 0xD400 <= addr <= 0xD4FF:
            reg = addr & 0x1F
            if reg in (0x19, 0x1A):
                return 0xFF  # POTX / POTY
            return self.sid_regs[reg]

        # $D600-$D6FF: 8563 VDC
        if 0xD600 <= addr <= 0xD6FF:
            if (addr & 1) == 0:
                # $D600: VDC Status Register (Bit 7 = 1 Ready, Bit 5 = VBlank)
                vblank = 0x20 if self.raster_y >= 250 else 0x00
                return 0x81 | vblank
            else:
                # $D601: VDC Data Register
                r = self.vdc_reg_index & 0x3F
                if r == 31:
                    vram_addr = ((self.vdc_regs[18] << 8) | self.vdc_regs[19]) & 0xFFFF
                    val = self.vdc_vram[vram_addr]
                    vram_addr = (vram_addr + 1) & 0xFFFF
                    self.vdc_regs[18] = (vram_addr >> 8) & 0xFF
                    self.vdc_regs[19] = vram_addr & 0xFF
                    return val
                if r < len(self.vdc_regs):
                    return self.vdc_regs[r]
                return 0xFF

        # $D800-$DBFF: 1 KB Color RAM
        if 0xD800 <= addr <= 0xDBFF:
            cbank = self.mmu.cpu_port_data & 0x01
            return self.color_ram[cbank][addr - 0xD800] | 0xF0

        # $DC00-$DCFF: CIA 1
        if 0xDC00 <= addr <= 0xDCFF:
            reg = addr & 0x0F
            if reg == 0x00:
                return self.cia1_pra
            if reg == 0x01:
                return self._scan_keyboard_columns()
            if reg == 0x02:
                return self.cia1_ddra
            if reg == 0x03:
                return self.cia1_ddrb
            if reg == 0x04:
                return self.cia1_ta & 0xFF
            if reg == 0x05:
                return (self.cia1_ta >> 8) & 0xFF
            if reg == 0x06:
                return self.cia1_tb & 0xFF
            if reg == 0x07:
                return (self.cia1_tb >> 8) & 0xFF
            if 0x08 <= reg <= 0x0B:
                return self.cia1_tod[reg - 8]
            if reg == 0x0D:
                val = self.cia1_icr_data
                self.cia1_icr_data = 0x00
                return val
            if reg == 0x0E:
                return self.cia1_cra
            if reg == 0x0F:
                return self.cia1_crb
            return 0xFF

        # $DD00-$DDFF: CIA 2 (IEC Serial Bus & VIC Bank)
        if 0xDD00 <= addr <= 0xDDFF:
            reg = addr & 0x0F
            if reg == 0x00:
                # Bits 6 & 7 are IEC Serial CLK IN and DATA IN: return high (1 = idle / no device holding low)
                return (self.cia2_pra & 0x3F) | 0xC0
            if reg == 0x01:
                return self.cia2_prb
            if reg == 0x02:
                return self.cia2_ddra
            if reg == 0x03:
                return self.cia2_ddrb
            if reg == 0x04:
                return self.cia2_ta & 0xFF
            if reg == 0x05:
                return (self.cia2_ta >> 8) & 0xFF
            if reg == 0x06:
                return self.cia2_tb & 0xFF
            if reg == 0x07:
                return (self.cia2_tb >> 8) & 0xFF
            if 0x08 <= reg <= 0x0B:
                return self.cia2_tod[reg - 8]
            if reg == 0x0D:
                val = self.cia2_icr_data
                self.cia2_icr_data = 0x00
                return val
            if reg == 0x0E:
                return self.cia2_cra
            if reg == 0x0F:
                return self.cia2_crb
            return 0xFF

        return 0xFF

    def write_io(self, addr: int, value: int):
        value &= 0xFF
        if self.io_tracer is not None and self.io_tracer.enabled:
            self.io_tracer.record_io(0, "IO_WRITE", addr, value)
        # $D000-$D3FF: VIC-IIe
        if 0xD000 <= addr <= 0xD3FF:
            reg = addr & 0x3F
            if reg == 0x11:
                self.vic_regs[0x11] = value
                low8 = getattr(self, "_target_raster", 0) & 0xFF
                self._target_raster = low8 | ((value & 0x80) << 1)
            elif reg == 0x12:
                self.vic_regs[0x12] = value
                hi1 = getattr(self, "_target_raster", 0) & 0x100
                self._target_raster = hi1 | value
            elif reg == 0x19:
                # Writing 1s clears corresponding interrupt latch bits!
                self.vic_irq_latch &= ~(value & 0x0F)
                if (self.vic_irq_latch & self.vic_irq_enable & 0x0F) == 0:
                    self.vic_irq_latch &= 0x7F
            elif reg == 0x1A:
                self.vic_irq_enable = value & 0x0F
                if (self.vic_irq_latch & self.vic_irq_enable & 0x0F) != 0:
                    self.vic_irq_latch |= 0x80
                else:
                    self.vic_irq_latch &= 0x7F
            else:
                self.vic_regs[reg] = value
            return

        # $D400-$D4FF: SID
        if 0xD400 <= addr <= 0xD4FF:
            self.sid_regs[addr & 0x1F] = value
            return

        # $D600-$D6FF: 8563 VDC
        if 0xD600 <= addr <= 0xD6FF:
            if (addr & 1) == 0:
                self.vdc_reg_index = value & 0x3F
            else:
                r = self.vdc_reg_index & 0x3F
                if r < len(self.vdc_regs):
                    self.vdc_regs[r] = value
                if r == 31:
                    vram_addr = ((self.vdc_regs[18] << 8) | self.vdc_regs[19]) & 0xFFFF
                    self.vdc_vram[vram_addr] = value
                    vram_addr = (vram_addr + 1) & 0xFFFF
                    self.vdc_regs[18] = (vram_addr >> 8) & 0xFF
                    self.vdc_regs[19] = vram_addr & 0xFF
                elif r == 30:
                    self._vdc_execute_block_op()
            return

        # $D800-$DBFF: Color RAM
        if 0xD800 <= addr <= 0xDBFF:
            cbank = self.mmu.cpu_port_data & 0x01
            self.color_ram[cbank][addr - 0xD800] = value & 0x0F
            return

        # $DC00-$DCFF: CIA 1
        if 0xDC00 <= addr <= 0xDCFF:
            reg = addr & 0x0F
            if reg == 0x00:
                self.cia1_pra = value
            elif reg == 0x01:
                self.cia1_prb = value
            elif reg == 0x02:
                self.cia1_ddra = value
            elif reg == 0x03:
                self.cia1_ddrb = value
            elif reg == 0x04:
                self.cia1_ta_latch = (self.cia1_ta_latch & 0xFF00) | value
            elif reg == 0x05:
                self.cia1_ta_latch = (self.cia1_ta_latch & 0x00FF) | (value << 8)
                if (self.cia1_cra & 0x01) == 0:
                    self.cia1_ta = self.cia1_ta_latch
            elif reg == 0x06:
                self.cia1_tb_latch = (self.cia1_tb_latch & 0xFF00) | value
            elif reg == 0x07:
                self.cia1_tb_latch = (self.cia1_tb_latch & 0x00FF) | (value << 8)
                if (self.cia1_crb & 0x01) == 0:
                    self.cia1_tb = self.cia1_tb_latch
            elif 0x08 <= reg <= 0x0B:
                self.cia1_tod[reg - 8] = value
            elif reg == 0x0C:
                # Writing to $DC0C (SDR) loads 8 bits (16 Timer A half-cycle underflows) to shift out
                self.cia1_sdr_shifts_left = 16
            elif reg == 0x0D:
                if value & 0x80:
                    self.cia1_icr_mask |= (value & 0x1F)
                else:
                    self.cia1_icr_mask &= ~(value & 0x1F)
            elif reg == 0x0E:
                self.cia1_cra = value
                if value & 0x10:
                    self.cia1_ta = self.cia1_ta_latch
            elif reg == 0x0F:
                self.cia1_crb = value
                if value & 0x10:
                    self.cia1_tb = self.cia1_tb_latch
            return

        # $DD00-$DDFF: CIA 2
        if 0xDD00 <= addr <= 0xDDFF:
            reg = addr & 0x0F
            if reg == 0x00:
                self.cia2_pra = value
            elif reg == 0x01:
                self.cia2_prb = value
            elif reg == 0x02:
                self.cia2_ddra = value
            elif reg == 0x03:
                self.cia2_ddrb = value
            elif reg == 0x04:
                self.cia2_ta_latch = (self.cia2_ta_latch & 0xFF00) | value
            elif reg == 0x05:
                self.cia2_ta_latch = (self.cia2_ta_latch & 0x00FF) | (value << 8)
            elif reg == 0x06:
                self.cia2_tb_latch = (self.cia2_tb_latch & 0xFF00) | value
            elif reg == 0x07:
                self.cia2_tb_latch = (self.cia2_tb_latch & 0x00FF) | (value << 8)
            elif 0x08 <= reg <= 0x0B:
                self.cia2_tod[reg - 8] = value
            elif reg == 0x0D:
                if value & 0x80:
                    self.cia2_icr_mask |= (value & 0x1F)
                else:
                    self.cia2_icr_mask &= ~(value & 0x1F)
            elif reg == 0x0E:
                self.cia2_cra = value
            elif reg == 0x0F:
                self.cia2_crb = value
            return

    def render_40col_screen_ascii(self) -> list[str]:
        """Reads the 40x25 VIC-IIe screen matrix at $0400-$07E7 in RAM Bank 0 and converts screen codes to ASCII."""
        lines = []
        for row in range(25):
            row_chars = []
            for col in range(40):
                sc = self.mmu.ram[0][0x0400 + row * 40 + col] & 0x7F
                if sc == 0:
                    ch = "@"
                elif 1 <= sc <= 26:
                    ch = chr(ord("A") + sc - 1)
                elif sc == 27:
                    ch = "["
                elif sc == 28:
                    ch = "\\"
                elif sc == 29:
                    ch = "]"
                elif sc == 30:
                    ch = "^"
                elif sc == 31:
                    ch = "_"
                elif 32 <= sc <= 63:
                    ch = chr(sc)
                else:
                    ch = " "
                row_chars.append(ch)
            lines.append("".join(row_chars).rstrip())
        return lines

    def render_80col_vdc_ascii(self) -> list[str]:
        """Reads the 80x25 8563 VDC screen matrix from VDC VRAM ($0000-$07CF) and converts screen codes or ASCII."""
        lines = []
        base = ((self.vdc_regs[12] << 8) | self.vdc_regs[13]) & 0xFFFF
        for row in range(25):
            row_chars = []
            for col in range(80):
                sc = self.vdc_vram[(base + row * 80 + col) & 0xFFFF] & 0x7F
                if sc == 0:
                    ch = "@"
                elif 1 <= sc <= 26:
                    ch = chr(ord("A") + sc - 1)
                elif 32 <= sc <= 126:
                    ch = chr(sc)
                else:
                    ch = " "
                row_chars.append(ch)
            lines.append("".join(row_chars).rstrip())
        return lines
