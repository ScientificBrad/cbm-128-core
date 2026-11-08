"""
MOS 8722 Memory Management Unit (MMU) and System Bus Interconnect for Commodore 128.
Implements full 128 KB RAM (Bank 0 & Bank 1), 48 KB C128 System ROMs, 8 KB Character ROM,
Common RAM areas (bottom 1K/4K/8K/16K, top), Page 0/Page 1 relocation ($D507-$D50A),
Preconfiguration registers ($D501-$D504 / $FF01-$FF04), Configuration Register ($D500 / $FF00),
and Mode Configuration Register ($D505) controlling Z80 vs 8502 bus mastership and 40/80 key sense.
"""

class C128MMUAndBus:
    def __init__(self, rom_basic_lo: bytes, rom_basic_hi: bytes, rom_kernal: bytes, rom_char: bytes,
                 peripherals=None):
        assert len(rom_basic_lo) == 16384, "basic-4000 must be 16384 bytes"
        assert len(rom_basic_hi) == 16384, "basic-8000 must be 16384 bytes"
        assert len(rom_kernal) == 16384, "kernal must be 16384 bytes"
        assert len(rom_char) == 8192, "characters must be 8192 bytes"

        self.rom_basic_lo = rom_basic_lo
        self.rom_basic_hi = rom_basic_hi
        self.rom_kernal = rom_kernal
        self.rom_char = rom_char
        self.rom_z80bios = rom_kernal[0x1000:0x2000]  # Physical $D000-$DFFF of U35

        # Two 64 KB DRAM banks (128 KB total)
        self.ram = [bytearray(65536), bytearray(65536)]

        # 8502 On-chip I/O port at $0000 (DDR) and $0001 (Data)
        self.cpu_port_ddr = 0x2F
        self.cpu_port_data = 0xE3

        # MMU Registers ($D500-$D50B)
        self.cr = 0x00          # $D500 / $FF00: Configuration Register
        self.pcr = [0x00, 0x00, 0x00, 0x00]  # $D501-$D504: Preconfiguration Registers A-D
        # $D505: Mode Configuration Register
        # Bit 0: 0 = Z80 active, 1 = 8502 active (power-on default = 0 so Z80 boots first!)
        # Bits 4-5: /GAME and /EXROM sense (1 = unasserted / high -> 0x30)
        # Bit 6: 0 = C128 mode, 1 = C64 mode
        # Bit 7: 40/80 Display key sense (1 = 40-col up, 0 = 80-col down)
        self.mcr = 0xB0         # Z80 active (bit 0=0), /GAME=1, /EXROM=1, C128 mode (bit 6=0), 40-col (bit 7=1)
        self.rcr = 0x00         # $D506: RAM Configuration Register
        self.p0l = 0x00         # $D507: Page 0 pointer low
        self.p0h = 0x00         # $D508: Page 0 pointer high (bank)
        self.p1l = 0x01         # $D509: Page 1 pointer low
        self.p1h = 0x00         # $D50A: Page 1 pointer high (bank)
        self.vr = 0x20          # $D50B: MMU Version Register ($20 = 128KB (2 banks), rev 0)

        self.peripherals = peripherals

    @property
    def is_z80_active(self) -> bool:
        return (self.mcr & 0x01) == 0

    @property
    def is_c64_mode(self) -> bool:
        return (self.mcr & 0x40) != 0

    def _resolve_ram_bank_and_addr(self, addr: int) -> tuple[int, int]:
        """Resolves RAM bank (0 or 1) and physical page translation ($D506-$D50A)."""
        bank = (self.cr >> 6) & 0x01
        page = (addr >> 8) & 0xFF
        offset = addr & 0xFF

        # Page 0 and Page 1 relocation ($D507-$D50A)
        if page == 0x00:
            phys_page = self.p0l
            phys_bank = self.p0h & 0x01
            addr_phys = (phys_page << 8) | offset
            if self._is_common_ram(addr):
                phys_bank = 0
            return phys_bank, addr_phys
        elif page == 0x01:
            phys_page = self.p1l
            phys_bank = self.p1h & 0x01
            addr_phys = (phys_page << 8) | offset
            if self._is_common_ram(addr):
                phys_bank = 0
            return phys_bank, addr_phys

        if self._is_common_ram(addr):
            bank = 0
        return bank, addr

    def _is_common_ram(self, addr: int) -> bool:
        """Checks $D506 (RCR) common RAM sharing rules, plus $FFD0-$FFEF shared stub."""
        if 0xFFD0 <= addr <= 0xFFEF:
            return True
        common_mode = (self.rcr >> 2) & 0x03  # Bits 2-3: 00=none, 01=bottom, 10=top, 11=both
        if common_mode == 0:
            return False
        size_code = self.rcr & 0x03           # Bits 0-1: 00=1K, 01=4K, 10=8K, 11=16K
        sizes = (0x0400, 0x1000, 0x2000, 0x4000)
        block_size = sizes[size_code]
        if (common_mode & 0x01) and addr < block_size:
            return True
        if (common_mode & 0x02) and addr >= (0x10000 - block_size):
            return True
        return False

    def read_mmu_reg(self, reg_offset: int) -> int:
        if reg_offset == 0x00:
            return self.cr
        elif 0x01 <= reg_offset <= 0x04:
            return self.pcr[reg_offset - 1]
        elif reg_offset == 0x05:
            # Preserve hardware sense bits 4,5 (/GAME, /EXROM = 1,1 -> 0x30) and bit 7 (40/80 key)
            return (self.mcr & 0xCF) | 0x30
        elif reg_offset == 0x06:
            return self.rcr
        elif reg_offset == 0x07:
            return self.p0l
        elif reg_offset == 0x08:
            return self.p0h | 0xF0
        elif reg_offset == 0x09:
            return self.p1l
        elif reg_offset == 0x0A:
            return self.p1h | 0xF0
        elif reg_offset == 0x0B:
            return self.vr
        return 0xFF

    def write_mmu_reg(self, reg_offset: int, value: int):
        value &= 0xFF
        if reg_offset == 0x00:
            self.cr = value
        elif 0x01 <= reg_offset <= 0x04:
            self.pcr[reg_offset - 1] = value
        elif reg_offset == 0x05:
            # Bit 4 & 5 are hardware inputs (/GAME, /EXROM), keep high (0x30)
            # Bit 7 can reflect 40/80 key state
            four_eighty_bit = self.mcr & 0x80
            self.mcr = (value & 0x4F) | 0x30 | four_eighty_bit
        elif reg_offset == 0x06:
            self.rcr = value
        elif reg_offset == 0x07:
            self.p0l = value
        elif reg_offset == 0x08:
            self.p0h = value & 0x01
        elif reg_offset == 0x09:
            self.p1l = value
        elif reg_offset == 0x0A:
            self.p1h = value & 0x01

    def read8(self, addr: int, z80_mode: bool = False) -> int:
        addr &= 0xFFFF

        # 8502 On-chip I/O Port at physical $0000/$0001
        if not z80_mode and addr == 0x0000:
            return self.cpu_port_ddr
        if not z80_mode and addr == 0x0001:
            # Bit 6 of $0001 is /CAPS LOCK (1 = unpressed), Bit 4 is Cassette Sense (1 = no button)
            return (self.cpu_port_data & self.cpu_port_ddr) | (~self.cpu_port_ddr & 0x77)

        # $FF00-$FF04 MMU registers are ALWAYS visible in all memory maps
        if 0xFF00 <= addr <= 0xFF04:
            if addr == 0xFF00:
                return self.cr
            return self.pcr[addr - 0xFF01]

        # Z80 BIOS ROM mapping: when Z80 is active and in Bank 0 (ROM config, CR bit 1 == 0 or CR == 0x3E during boot),
        # Wait: let's check how Z80 BIOS maps at $0000-$0FFF!
        # Look at Z80 reset ($0000): `LD A,$3E; LD ($FF00),A; JP $003B`!
        # Notice that at $0002, the Z80 writes `$3E` (`0011 1110`: RAM at $4000-$FFFF, I/O at $D000-$DFFF, Bank 0) to `$FF00`,
        # AND THEN continues executing Z80 BIOS ROM at `$003B`!
        # Why does Z80 BIOS stay mapped at `$0000-$0FFF` when `$FF00 = $3E`?
        # Because in Z80 mode, MMU Bank 0 (`CR` bits 7-6 == `00`) ALWAYS maps the Z80 BIOS ROM at `$0000-$0FFF` for reads
        # (while writes to `$0000-$0FFF` go through to RAM Bank 0), whereas Bank 1 (`CR` bits 7-6 == `01`) maps RAM at `$0000-$0FFF`!
        if z80_mode and addr < 0x1000 and ((self.cr >> 6) & 0x01) == 0:
            return self.rom_z80bios[addr]

        # $4000-$7FFF: BASIC 7.0 Lower ROM if CR bit 1 == 0
        if 0x4000 <= addr <= 0x7FFF:
            if (self.cr & 0x02) == 0:
                return self.rom_basic_lo[addr - 0x4000]

        # $8000-$BFFF: BASIC 7.0 Upper ROM + ML Monitor if CR bits 3-2 == 00
        elif 0x8000 <= addr <= 0xBFFF:
            mid_sel = (self.cr >> 2) & 0x03
            if mid_sel == 0x00:
                return self.rom_basic_hi[addr - 0x8000]
            elif mid_sel in (0x01, 0x02):
                return 0xFF  # Unpopulated Internal/External Function ROM socket

        # $C000-$CFFF: Screen Editor ROM if CR bits 5-4 == 00
        elif 0xC000 <= addr <= 0xCFFF:
            hi_sel = (self.cr >> 4) & 0x03
            if hi_sel == 0x00:
                return self.rom_kernal[addr - 0xC000]
            elif hi_sel in (0x01, 0x02):
                return 0xFF

        # $D000-$DFFF: I/O vs Character ROM vs RAM
        elif 0xD000 <= addr <= 0xDFFF:
            # CR bit 0 == 0 selects I/O devices at $D000-$DFFF (in 8502 mode; in Z80 mode, memory reads at $D000-$DFFF hit RAM while IN/OUT instructions hit I/O)
            if not z80_mode and (self.cr & 0x01) == 0:
                return self.read_io(addr)
            hi_sel = (self.cr >> 4) & 0x03
            if hi_sel == 0x00:
                # When HI=00 (System ROM) and IO=1 (or CPU char fetch via RCR/port), Character ROM is visible!
                # Specifically, 8502 port $0001 bit 2 (/CHAREN): 0 = Character ROM visible at $D000-$DFFF
                # Or when CR bit 0 == 1 and HI == 00:
                charen_low = (self.cpu_port_data & 0x04) == 0
                if charen_low or (self.cr & 0x01) != 0:
                    # Select upper 4KB of Character ROM in C128 mode, lower 4KB in C64 mode
                    char_base = 0x0000 if self.is_c64_mode else 0x1000
                    return self.rom_char[char_base + (addr - 0xD000)]

        # $E000-$FFFF: KERNAL ROM if CR bits 5-4 == 00
        elif 0xE000 <= addr <= 0xFFFF:
            hi_sel = (self.cr >> 4) & 0x03
            if hi_sel == 0x00:
                return self.rom_kernal[addr - 0xC000]
            elif hi_sel in (0x01, 0x02):
                return 0xFF

        bank, phys_addr = self._resolve_ram_bank_and_addr(addr)
        return self.ram[bank][phys_addr]

    def write8(self, addr: int, value: int, z80_mode: bool = False):
        addr &= 0xFFFF
        value &= 0xFF

        if not z80_mode and addr == 0x0000:
            self.cpu_port_ddr = value
            self.ram[0][0x0000] = value
            return
        if not z80_mode and addr == 0x0001:
            self.cpu_port_data = value
            self.ram[0][0x0001] = value
            return

        # $FF00-$FF04 MMU registers:
        # Writing to $FF00 sets CR directly.
        # Writing ANY value to $FF01-$FF04 loads CR from Preconfig Register A-D ($D501-$D504)!
        if addr == 0xFF00:
            self.cr = value
            return
        if 0xFF01 <= addr <= 0xFF04:
            self.cr = self.pcr[addr - 0xFF01]
            return

        if not z80_mode and 0xD000 <= addr <= 0xDFFF and (self.cr & 0x01) == 0:
            self.write_io(addr, value)
            return

        # All writes to ROM-mapped regions fall through to the underlying RAM bank (standard C64/C128 behavior)
        bank, phys_addr = self._resolve_ram_bank_and_addr(addr)
        self.ram[bank][phys_addr] = value

    def read_io(self, addr: int) -> int:
        addr &= 0xFFFF
        if 0xD500 <= addr <= 0xD50B:
            return self.read_mmu_reg(addr - 0xD500)
        if self.peripherals is not None:
            return self.peripherals.read_io(addr)
        return 0xFF

    def write_io(self, addr: int, value: int):
        addr &= 0xFFFF
        value &= 0xFF
        if 0xD500 <= addr <= 0xD50B:
            self.write_mmu_reg(addr - 0xD500, value)
            return
        if self.peripherals is not None:
            self.peripherals.write_io(addr, value)
