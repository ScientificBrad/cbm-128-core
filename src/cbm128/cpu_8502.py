"""
MOS 8502 CPU Core Implementation for Commodore 128 (`cbm-128-core`).
Executes all documented 6502/8502 instructions, binary & BCD arithmetic (`ADC`/`SBC`),
hardware interrupts (`RESET`, `NMI`, `IRQ`, `BRK`), and integrates with the C128 MMU & Bus.
"""

from .mmu import C128MMUAndBus

FLAG_C = 0x01
FLAG_Z = 0x02
FLAG_I = 0x04
FLAG_D = 0x08
FLAG_B = 0x10
FLAG_U = 0x20
FLAG_V = 0x40
FLAG_N = 0x80

class MOS8502CPU:
    def __init__(self, bus: C128MMUAndBus):
        self.bus = bus
        self.a = 0x00
        self.x = 0x00
        self.y = 0x00
        self.sp = 0xFD
        self.pc = 0x0000
        self.p = FLAG_I | FLAG_U
        self.cycles = 0
        self.instructions_executed = 0
        self.reset_pending = True
        self.nmi_edge = False

    def reset(self):
        lo = self.bus.read8(0xFFFC, z80_mode=False)
        hi = self.bus.read8(0xFFFD, z80_mode=False)
        self.pc = (hi << 8) | lo
        self.sp = 0xFD
        self.p = FLAG_I | FLAG_U
        self.reset_pending = False
        self.cycles += 7

    def _set_nz(self, val: int) -> int:
        val &= 0xFF
        if val == 0:
            self.p |= FLAG_Z
        else:
            self.p &= ~FLAG_Z
        if val & 0x80:
            self.p |= FLAG_N
        else:
            self.p &= ~FLAG_N
        return val

    def _push8(self, val: int):
        self.bus.write8(0x0100 | self.sp, val & 0xFF, z80_mode=False)
        self.sp = (self.sp - 1) & 0xFF

    def _pop8(self) -> int:
        self.sp = (self.sp + 1) & 0xFF
        return self.bus.read8(0x0100 | self.sp, z80_mode=False)

    def _push16(self, val: int):
        self._push8((val >> 8) & 0xFF)
        self._push8(val & 0xFF)

    def _pop16(self) -> int:
        lo = self._pop8()
        hi = self._pop8()
        return (hi << 8) | lo

    def _read8(self, addr: int) -> int:
        return self.bus.read8(addr & 0xFFFF, z80_mode=False)

    def _read16(self, addr: int) -> int:
        lo = self._read8(addr)
        hi = self._read8((addr + 1) & 0xFFFF)
        return (hi << 8) | lo

    def _write8(self, addr: int, val: int):
        self.bus.write8(addr & 0xFFFF, val & 0xFF, z80_mode=False)

    def trigger_nmi(self):
        self._push16(self.pc)
        self._push8((self.p & ~FLAG_B) | FLAG_U)
        self.p |= FLAG_I
        self.pc = self._read16(0xFFFA)
        self.cycles += 7

    def trigger_irq(self):
        if (self.p & FLAG_I) == 0:
            self._push16(self.pc)
            self._push8((self.p & ~FLAG_B) | FLAG_U)
            self.p |= FLAG_I
            self.pc = self._read16(0xFFFE)
            self.cycles += 7
            return True
        return False

    # Addressing Mode Helpers
    def _addr_imm(self) -> int:
        a = self.pc
        self.pc = (self.pc + 1) & 0xFFFF
        return a

    def _addr_zp(self) -> int:
        a = self._read8(self.pc)
        self.pc = (self.pc + 1) & 0xFFFF
        return a

    def _addr_zpx(self) -> int:
        a = (self._read8(self.pc) + self.x) & 0xFF
        self.pc = (self.pc + 1) & 0xFFFF
        return a

    def _addr_zpy(self) -> int:
        a = (self._read8(self.pc) + self.y) & 0xFF
        self.pc = (self.pc + 1) & 0xFFFF
        return a

    def _addr_abs(self) -> int:
        a = self._read16(self.pc)
        self.pc = (self.pc + 2) & 0xFFFF
        return a

    def _addr_abx(self) -> int:
        a = (self._read16(self.pc) + self.x) & 0xFFFF
        self.pc = (self.pc + 2) & 0xFFFF
        return a

    def _addr_aby(self) -> int:
        a = (self._read16(self.pc) + self.y) & 0xFFFF
        self.pc = (self.pc + 2) & 0xFFFF
        return a

    def _addr_izx(self) -> int:
        zp = (self._read8(self.pc) + self.x) & 0xFF
        self.pc = (self.pc + 1) & 0xFFFF
        lo = self._read8(zp)
        hi = self._read8((zp + 1) & 0xFF)
        return (hi << 8) | lo

    def _addr_izy(self) -> int:
        zp = self._read8(self.pc)
        self.pc = (self.pc + 1) & 0xFFFF
        lo = self._read8(zp)
        hi = self._read8((zp + 1) & 0xFF)
        return (((hi << 8) | lo) + self.y) & 0xFFFF

    def _adc(self, val: int):
        cin = 1 if (self.p & FLAG_C) else 0
        if self.p & FLAG_D:
            al = (self.a & 0x0F) + (val & 0x0F) + cin
            if al > 9:
                al += 6
            ah = (self.a >> 4) + (val >> 4) + (1 if al > 15 else 0)
            res_bin = (self.a + val + cin) & 0xFF
            if res_bin == 0:
                self.p |= FLAG_Z
            else:
                self.p &= ~FLAG_Z
            res_hi = (ah << 4) | (al & 0x0F)
            if res_hi & 0x80:
                self.p |= FLAG_N
            else:
                self.p &= ~FLAG_N
            if ((~(self.a ^ val) & (self.a ^ res_hi)) & 0x80) != 0:
                self.p |= FLAG_V
            else:
                self.p &= ~FLAG_V
            if ah > 9:
                ah += 6
            if ah > 15:
                self.p |= FLAG_C
            else:
                self.p &= ~FLAG_C
            self.a = ((ah << 4) | (al & 0x0F)) & 0xFF
        else:
            s = self.a + val + cin
            if s > 0xFF:
                self.p |= FLAG_C
            else:
                self.p &= ~FLAG_C
            res = s & 0xFF
            if ((~(self.a ^ val) & (self.a ^ res)) & 0x80) != 0:
                self.p |= FLAG_V
            else:
                self.p &= ~FLAG_V
            self.a = self._set_nz(res)

    def _sbc(self, val: int):
        cin = 1 if (self.p & FLAG_C) else 0
        borrow = 1 - cin
        s_bin = self.a - val - borrow
        res_bin = s_bin & 0xFF
        if (self.p & FLAG_D):
            al = (self.a & 0x0F) - (val & 0x0F) - borrow
            if al < 0:
                al = ((al - 6) & 0x0F) - 0x10
            ah = (self.a >> 4) - (val >> 4) + (al >> 4)
            if ah < 0:
                ah = (ah - 6) & 0x0F
            if s_bin >= 0:
                self.p |= FLAG_C
            else:
                self.p &= ~FLAG_C
            if (((self.a ^ val) & (self.a ^ res_bin)) & 0x80) != 0:
                self.p |= FLAG_V
            else:
                self.p &= ~FLAG_V
            self._set_nz(res_bin)
            self.a = ((ah << 4) | (al & 0x0F)) & 0xFF
        else:
            if s_bin >= 0:
                self.p |= FLAG_C
            else:
                self.p &= ~FLAG_C
            if (((self.a ^ val) & (self.a ^ res_bin)) & 0x80) != 0:
                self.p |= FLAG_V
            else:
                self.p &= ~FLAG_V
            self.a = self._set_nz(res_bin)

    def _cmp(self, reg_val: int, mem_val: int):
        diff = reg_val - mem_val
        if diff >= 0:
            self.p |= FLAG_C
        else:
            self.p &= ~FLAG_C
        self._set_nz(diff & 0xFF)

    def _branch(self, cond: bool):
        rel = self._read8(self.pc)
        self.pc = (self.pc + 1) & 0xFFFF
        if cond:
            if rel >= 0x80:
                rel -= 0x100
            self.pc = (self.pc + rel) & 0xFFFF
            return 3
        return 2

    def step(self) -> int:
        if self.reset_pending:
            self.reset()
            return 7

        if self.bus.peripherals is not None and self.bus.peripherals.irq_pending:
            if self.trigger_irq():
                return 7

        op = self._read8(self.pc)
        self.pc = (self.pc + 1) & 0xFFFF
        self.instructions_executed += 1
        cyc = 2

        # LDA
        if op == 0xA9: self.a = self._set_nz(self._read8(self._addr_imm())); cyc = 2
        elif op == 0xA5: self.a = self._set_nz(self._read8(self._addr_zp())); cyc = 3
        elif op == 0xB5: self.a = self._set_nz(self._read8(self._addr_zpx())); cyc = 4
        elif op == 0xAD: self.a = self._set_nz(self._read8(self._addr_abs())); cyc = 4
        elif op == 0xBD: self.a = self._set_nz(self._read8(self._addr_abx())); cyc = 4
        elif op == 0xB9: self.a = self._set_nz(self._read8(self._addr_aby())); cyc = 4
        elif op == 0xA1: self.a = self._set_nz(self._read8(self._addr_izx())); cyc = 6
        elif op == 0xB1: self.a = self._set_nz(self._read8(self._addr_izy())); cyc = 5

        # LDX
        elif op == 0xA2: self.x = self._set_nz(self._read8(self._addr_imm())); cyc = 2
        elif op == 0xA6: self.x = self._set_nz(self._read8(self._addr_zp())); cyc = 3
        elif op == 0xB6: self.x = self._set_nz(self._read8(self._addr_zpy())); cyc = 4
        elif op == 0xAE: self.x = self._set_nz(self._read8(self._addr_abs())); cyc = 4
        elif op == 0xBE: self.x = self._set_nz(self._read8(self._addr_aby())); cyc = 4

        # LDY
        elif op == 0xA0: self.y = self._set_nz(self._read8(self._addr_imm())); cyc = 2
        elif op == 0xA4: self.y = self._set_nz(self._read8(self._addr_zp())); cyc = 3
        elif op == 0xB4: self.y = self._set_nz(self._read8(self._addr_zpx())); cyc = 4
        elif op == 0xAC: self.y = self._set_nz(self._read8(self._addr_abs())); cyc = 4
        elif op == 0xBC: self.y = self._set_nz(self._read8(self._addr_abx())); cyc = 4

        # STA
        elif op == 0x85: self._write8(self._addr_zp(), self.a); cyc = 3
        elif op == 0x95: self._write8(self._addr_zpx(), self.a); cyc = 4
        elif op == 0x8D: self._write8(self._addr_abs(), self.a); cyc = 4
        elif op == 0x9D: self._write8(self._addr_abx(), self.a); cyc = 5
        elif op == 0x99: self._write8(self._addr_aby(), self.a); cyc = 5
        elif op == 0x81: self._write8(self._addr_izx(), self.a); cyc = 6
        elif op == 0x91: self._write8(self._addr_izy(), self.a); cyc = 6

        # STX
        elif op == 0x86: self._write8(self._addr_zp(), self.x); cyc = 3
        elif op == 0x96: self._write8(self._addr_zpy(), self.x); cyc = 4
        elif op == 0x8E: self._write8(self._addr_abs(), self.x); cyc = 4

        # STY
        elif op == 0x84: self._write8(self._addr_zp(), self.y); cyc = 3
        elif op == 0x94: self._write8(self._addr_zpx(), self.y); cyc = 4
        elif op == 0x8C: self._write8(self._addr_abs(), self.y); cyc = 4

        # Transfers
        elif op == 0xAA: self.x = self._set_nz(self.a)
        elif op == 0xA8: self.y = self._set_nz(self.a)
        elif op == 0x8A: self.a = self._set_nz(self.x)
        elif op == 0x98: self.a = self._set_nz(self.y)
        elif op == 0xBA: self.x = self._set_nz(self.sp)
        elif op == 0x9A: self.sp = self.x

        # Stack
        elif op == 0x48: self._push8(self.a); cyc = 3
        elif op == 0x68: self.a = self._set_nz(self._pop8()); cyc = 4
        elif op == 0x08: self._push8(self.p | FLAG_B | FLAG_U); cyc = 3
        elif op == 0x28: self.p = (self._pop8() & ~FLAG_B) | FLAG_U; cyc = 4

        # Logical ORA
        elif op == 0x09: self.a = self._set_nz(self.a | self._read8(self._addr_imm())); cyc = 2
        elif op == 0x05: self.a = self._set_nz(self.a | self._read8(self._addr_zp())); cyc = 3
        elif op == 0x15: self.a = self._set_nz(self.a | self._read8(self._addr_zpx())); cyc = 4
        elif op == 0x0D: self.a = self._set_nz(self.a | self._read8(self._addr_abs())); cyc = 4
        elif op == 0x1D: self.a = self._set_nz(self.a | self._read8(self._addr_abx())); cyc = 4
        elif op == 0x19: self.a = self._set_nz(self.a | self._read8(self._addr_aby())); cyc = 4
        elif op == 0x01: self.a = self._set_nz(self.a | self._read8(self._addr_izx())); cyc = 6
        elif op == 0x11: self.a = self._set_nz(self.a | self._read8(self._addr_izy())); cyc = 5

        # Logical AND
        elif op == 0x29: self.a = self._set_nz(self.a & self._read8(self._addr_imm())); cyc = 2
        elif op == 0x25: self.a = self._set_nz(self.a & self._read8(self._addr_zp())); cyc = 3
        elif op == 0x35: self.a = self._set_nz(self.a & self._read8(self._addr_zpx())); cyc = 4
        elif op == 0x2D: self.a = self._set_nz(self.a & self._read8(self._addr_abs())); cyc = 4
        elif op == 0x3D: self.a = self._set_nz(self.a & self._read8(self._addr_abx())); cyc = 4
        elif op == 0x39: self.a = self._set_nz(self.a & self._read8(self._addr_aby())); cyc = 4
        elif op == 0x21: self.a = self._set_nz(self.a & self._read8(self._addr_izx())); cyc = 6
        elif op == 0x31: self.a = self._set_nz(self.a & self._read8(self._addr_izy())); cyc = 5

        # Logical EOR
        elif op == 0x49: self.a = self._set_nz(self.a ^ self._read8(self._addr_imm())); cyc = 2
        elif op == 0x45: self.a = self._set_nz(self.a ^ self._read8(self._addr_zp())); cyc = 3
        elif op == 0x55: self.a = self._set_nz(self.a ^ self._read8(self._addr_zpx())); cyc = 4
        elif op == 0x4D: self.a = self._set_nz(self.a ^ self._read8(self._addr_abs())); cyc = 4
        elif op == 0x5D: self.a = self._set_nz(self.a ^ self._read8(self._addr_abx())); cyc = 4
        elif op == 0x59: self.a = self._set_nz(self.a ^ self._read8(self._addr_aby())); cyc = 4
        elif op == 0x41: self.a = self._set_nz(self.a ^ self._read8(self._addr_izx())); cyc = 6
        elif op == 0x51: self.a = self._set_nz(self.a ^ self._read8(self._addr_izy())); cyc = 5

        # BIT
        elif op in (0x24, 0x2C):
            addr = self._addr_zp() if op == 0x24 else self._addr_abs()
            val = self._read8(addr)
            if (self.a & val) == 0:
                self.p |= FLAG_Z
            else:
                self.p &= ~FLAG_Z
            self.p = (self.p & ~(FLAG_N | FLAG_V)) | (val & (FLAG_N | FLAG_V))
            cyc = 3 if op == 0x24 else 4

        # ADC
        elif op == 0x69: self._adc(self._read8(self._addr_imm())); cyc = 2
        elif op == 0x65: self._adc(self._read8(self._addr_zp())); cyc = 3
        elif op == 0x75: self._adc(self._read8(self._addr_zpx())); cyc = 4
        elif op == 0x6D: self._adc(self._read8(self._addr_abs())); cyc = 4
        elif op == 0x7D: self._adc(self._read8(self._addr_abx())); cyc = 4
        elif op == 0x79: self._adc(self._read8(self._addr_aby())); cyc = 4
        elif op == 0x61: self._adc(self._read8(self._addr_izx())); cyc = 6
        elif op == 0x71: self._adc(self._read8(self._addr_izy())); cyc = 5

        # SBC
        elif op == 0xE9: self._sbc(self._read8(self._addr_imm())); cyc = 2
        elif op == 0xE5: self._sbc(self._read8(self._addr_zp())); cyc = 3
        elif op == 0xF5: self._sbc(self._read8(self._addr_zpx())); cyc = 4
        elif op == 0xED: self._sbc(self._read8(self._addr_abs())); cyc = 4
        elif op == 0xFD: self._sbc(self._read8(self._addr_abx())); cyc = 4
        elif op == 0xF9: self._sbc(self._read8(self._addr_aby())); cyc = 4
        elif op == 0xE1: self._sbc(self._read8(self._addr_izx())); cyc = 6
        elif op == 0xF1: self._sbc(self._read8(self._addr_izy())); cyc = 5

        # CMP / CPX / CPY
        elif op == 0xC9: self._cmp(self.a, self._read8(self._addr_imm())); cyc = 2
        elif op == 0xC5: self._cmp(self.a, self._read8(self._addr_zp())); cyc = 3
        elif op == 0xD5: self._cmp(self.a, self._read8(self._addr_zpx())); cyc = 4
        elif op == 0xCD: self._cmp(self.a, self._read8(self._addr_abs())); cyc = 4
        elif op == 0xDD: self._cmp(self.a, self._read8(self._addr_abx())); cyc = 4
        elif op == 0xD9: self._cmp(self.a, self._read8(self._addr_aby())); cyc = 4
        elif op == 0xC1: self._cmp(self.a, self._read8(self._addr_izx())); cyc = 6
        elif op == 0xD1: self._cmp(self.a, self._read8(self._addr_izy())); cyc = 5
        elif op == 0xE0: self._cmp(self.x, self._read8(self._addr_imm())); cyc = 2
        elif op == 0xE4: self._cmp(self.x, self._read8(self._addr_zp())); cyc = 3
        elif op == 0xEC: self._cmp(self.x, self._read8(self._addr_abs())); cyc = 4
        elif op == 0xC0: self._cmp(self.y, self._read8(self._addr_imm())); cyc = 2
        elif op == 0xC4: self._cmp(self.y, self._read8(self._addr_zp())); cyc = 3
        elif op == 0xCC: self._cmp(self.y, self._read8(self._addr_abs())); cyc = 4

        # INC / DEC / INX / DEX / INY / DEY
        elif op == 0xE8: self.x = self._set_nz((self.x + 1) & 0xFF)
        elif op == 0xCA: self.x = self._set_nz((self.x - 1) & 0xFF)
        elif op == 0xC8: self.y = self._set_nz((self.y + 1) & 0xFF)
        elif op == 0x88: self.y = self._set_nz((self.y - 1) & 0xFF)
        elif op in (0xE6, 0xF6, 0xEE, 0xFE):
            addr = self._addr_zp() if op == 0xE6 else (self._addr_zpx() if op == 0xF6 else (self._addr_abs() if op == 0xEE else self._addr_abx()))
            val = self._set_nz((self._read8(addr) + 1) & 0xFF)
            self._write8(addr, val)
            cyc = 5 if op == 0xE6 else 6
        elif op in (0xC6, 0xD6, 0xCE, 0xDE):
            addr = self._addr_zp() if op == 0xC6 else (self._addr_zpx() if op == 0xD6 else (self._addr_abs() if op == 0xCE else self._addr_abx()))
            val = self._set_nz((self._read8(addr) - 1) & 0xFF)
            self._write8(addr, val)
            cyc = 5 if op == 0xC6 else 6

        # Shifts: ASL, LSR, ROL, ROR
        elif op == 0x0A:
            if self.a & 0x80: self.p |= FLAG_C
            else: self.p &= ~FLAG_C
            self.a = self._set_nz((self.a << 1) & 0xFF)
        elif op in (0x06, 0x16, 0x0E, 0x1E):
            addr = self._addr_zp() if op == 0x06 else (self._addr_zpx() if op == 0x16 else (self._addr_abs() if op == 0x0E else self._addr_abx()))
            v = self._read8(addr)
            if v & 0x80: self.p |= FLAG_C
            else: self.p &= ~FLAG_C
            self._write8(addr, self._set_nz((v << 1) & 0xFF))
            cyc = 5 if op == 0x06 else 6
        elif op == 0x4A:
            if self.a & 0x01: self.p |= FLAG_C
            else: self.p &= ~FLAG_C
            self.a = self._set_nz(self.a >> 1)
        elif op in (0x46, 0x56, 0x4E, 0x5E):
            addr = self._addr_zp() if op == 0x46 else (self._addr_zpx() if op == 0x56 else (self._addr_abs() if op == 0x4E else self._addr_abx()))
            v = self._read8(addr)
            if v & 0x01: self.p |= FLAG_C
            else: self.p &= ~FLAG_C
            self._write8(addr, self._set_nz(v >> 1))
            cyc = 5 if op == 0x46 else 6
        elif op == 0x2A:
            c = 1 if (self.p & FLAG_C) else 0
            if self.a & 0x80: self.p |= FLAG_C
            else: self.p &= ~FLAG_C
            self.a = self._set_nz(((self.a << 1) | c) & 0xFF)
        elif op in (0x26, 0x36, 0x2E, 0x3E):
            addr = self._addr_zp() if op == 0x26 else (self._addr_zpx() if op == 0x36 else (self._addr_abs() if op == 0x2E else self._addr_abx()))
            v = self._read8(addr)
            c = 1 if (self.p & FLAG_C) else 0
            if v & 0x80: self.p |= FLAG_C
            else: self.p &= ~FLAG_C
            self._write8(addr, self._set_nz(((v << 1) | c) & 0xFF))
            cyc = 5 if op == 0x26 else 6
        elif op == 0x6A:
            c = 0x80 if (self.p & FLAG_C) else 0
            if self.a & 0x01: self.p |= FLAG_C
            else: self.p &= ~FLAG_C
            self.a = self._set_nz((self.a >> 1) | c)
        elif op in (0x66, 0x76, 0x6E, 0x7E):
            addr = self._addr_zp() if op == 0x66 else (self._addr_zpx() if op == 0x76 else (self._addr_abs() if op == 0x6E else self._addr_abx()))
            v = self._read8(addr)
            c = 0x80 if (self.p & FLAG_C) else 0
            if v & 0x01: self.p |= FLAG_C
            else: self.p &= ~FLAG_C
            self._write8(addr, self._set_nz((v >> 1) | c))
            cyc = 5 if op == 0x66 else 6

        # Branches
        elif op == 0x10: cyc = self._branch((self.p & FLAG_N) == 0)
        elif op == 0x30: cyc = self._branch((self.p & FLAG_N) != 0)
        elif op == 0x50: cyc = self._branch((self.p & FLAG_V) == 0)
        elif op == 0x70: cyc = self._branch((self.p & FLAG_V) != 0)
        elif op == 0x90: cyc = self._branch((self.p & FLAG_C) == 0)
        elif op == 0xB0: cyc = self._branch((self.p & FLAG_C) != 0)
        elif op == 0xD0: cyc = self._branch((self.p & FLAG_Z) == 0)
        elif op == 0xF0: cyc = self._branch((self.p & FLAG_Z) != 0)

        # Jumps & Calls
        elif op == 0x4C:
            self.pc = self._read16(self.pc)
            cyc = 3
        elif op == 0x6C:
            ptr = self._read16(self.pc)
            lo = self._read8(ptr)
            # 6502 page-boundary indirect jump wrap
            hi = self._read8((ptr & 0xFF00) | ((ptr + 1) & 0x00FF))
            self.pc = (hi << 8) | lo
            cyc = 5
        elif op == 0x20:
            target = self._read16(self.pc)
            self._push16((self.pc + 1) & 0xFFFF)
            self.pc = target
            cyc = 6
        elif op == 0x60:
            self.pc = (self._pop16() + 1) & 0xFFFF
            cyc = 6
        elif op == 0x40:
            self.p = (self._pop8() & ~FLAG_B) | FLAG_U
            self.pc = self._pop16()
            cyc = 6
        elif op == 0x00:
            self.pc = (self.pc + 1) & 0xFFFF
            self._push16(self.pc)
            self._push8(self.p | FLAG_B | FLAG_U)
            self.p |= FLAG_I
            self.pc = self._read16(0xFFFE)
            cyc = 7

        # Flags & NOP
        elif op == 0x18: self.p &= ~FLAG_C
        elif op == 0x38: self.p |= FLAG_C
        elif op == 0x58: self.p &= ~FLAG_I
        elif op == 0x78: self.p |= FLAG_I
        elif op == 0xB8: self.p &= ~FLAG_V
        elif op == 0xD8: self.p &= ~FLAG_D
        elif op == 0xF8: self.p |= FLAG_D
        elif op == 0xEA: cyc = 2
        else:
            # Undocumented NOPs
            cyc = 2

        self.cycles += cyc
        return cyc
