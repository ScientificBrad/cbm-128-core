"""
Zilog Z80A CPU Core Implementation for Commodore 128 (`cbm-128-core`).
Executes the original C128 Z80 BIOS (`z80bios.bin` / `kernal.318020-03.bin` $D000-$DFFF mapped at $0000-$0FFF),
handles 16-bit I/O port addressing (`IN r,(C)` / `OUT (C),r` at $D000-$DFFF), block transfers (`LDIR`/`LDDR`),
`RST` vectors, and bus handoff to the MOS 8502 via MMU Mode Configuration Register ($D505).
"""

from .mmu import C128MMUAndBus

ZFLAG_C  = 0x01
ZFLAG_N  = 0x02
ZFLAG_PV = 0x04
ZFLAG_H  = 0x10
ZFLAG_Z  = 0x40
ZFLAG_S  = 0x80

class ZilogZ80CPU:
    def __init__(self, bus: C128MMUAndBus):
        self.bus = bus
        self.a = 0x00
        self.f = 0x00
        self.b = 0x00
        self.c = 0x00
        self.d = 0x00
        self.e = 0x00
        self.h = 0x00
        self.l = 0x00
        self.a_p = 0x00
        self.f_p = 0x00
        self.b_p = 0x00
        self.c_p = 0x00
        self.d_p = 0x00
        self.e_p = 0x00
        self.h_p = 0x00
        self.l_p = 0x00
        self.ix = 0x0000
        self.iy = 0x0000
        self.sp = 0xFFFF
        self.pc = 0x0000
        self.i = 0x00
        self.r = 0x00
        self.iff1 = False
        self.iff2 = False
        self.im = 0
        self.halted = False
        self.cycles = 0
        self.instructions_executed = 0

    def reset(self):
        self.pc = 0x0000
        self.sp = 0xFFFF
        self.iff1 = False
        self.iff2 = False
        self.im = 0
        self.halted = False

    # 16-bit Register Pair Properties
    @property
    def bc(self) -> int: return (self.b << 8) | self.c
    @bc.setter
    def bc(self, v: int): self.b = (v >> 8) & 0xFF; self.c = v & 0xFF

    @property
    def de(self) -> int: return (self.d << 8) | self.e
    @de.setter
    def de(self, v: int): self.d = (v >> 8) & 0xFF; self.e = v & 0xFF

    @property
    def hl(self) -> int: return (self.h << 8) | self.l
    @hl.setter
    def hl(self, v: int): self.h = (v >> 8) & 0xFF; self.l = v & 0xFF

    @property
    def af(self) -> int: return (self.a << 8) | self.f
    @af.setter
    def af(self, v: int): self.a = (v >> 8) & 0xFF; self.f = v & 0xFF

    def _read8(self, addr: int) -> int:
        return self.bus.read8(addr & 0xFFFF, z80_mode=True)

    def _write8(self, addr: int, val: int):
        self.bus.write8(addr & 0xFFFF, val & 0xFF, z80_mode=True)

    def _read16(self, addr: int) -> int:
        lo = self._read8(addr)
        hi = self._read8((addr + 1) & 0xFFFF)
        return (hi << 8) | lo

    def _write16(self, addr: int, val: int):
        self._write8(addr, val & 0xFF)
        self._write8((addr + 1) & 0xFFFF, (val >> 8) & 0xFF)

    def _fetch8(self) -> int:
        v = self._read8(self.pc)
        self.pc = (self.pc + 1) & 0xFFFF
        return v

    def _fetch16(self) -> int:
        lo = self._fetch8()
        hi = self._fetch8()
        return (hi << 8) | lo

    def _push16(self, val: int):
        self.sp = (self.sp - 1) & 0xFFFF
        self._write8(self.sp, (val >> 8) & 0xFF)
        self.sp = (self.sp - 1) & 0xFFFF
        self._write8(self.sp, val & 0xFF)

    def _pop16(self) -> int:
        lo = self._read8(self.sp)
        self.sp = (self.sp + 1) & 0xFFFF
        hi = self._read8(self.sp)
        self.sp = (self.sp + 1) & 0xFFFF
        return (hi << 8) | lo

    def _parity(self, v: int) -> int:
        return ZFLAG_PV if (bin(v & 0xFF).count("1") % 2 == 0) else 0

    def _szp(self, v: int) -> int:
        v &= 0xFF
        fl = self._parity(v)
        if v == 0:
            fl |= ZFLAG_Z
        if v & 0x80:
            fl |= ZFLAG_S
        return fl

    def _get_reg8(self, idx: int) -> int:
        if idx == 0: return self.b
        if idx == 1: return self.c
        if idx == 2: return self.d
        if idx == 3: return self.e
        if idx == 4: return self.h
        if idx == 5: return self.l
        if idx == 6: return self._read8(self.hl)
        return self.a

    def _set_reg8(self, idx: int, val: int):
        val &= 0xFF
        if idx == 0: self.b = val
        elif idx == 1: self.c = val
        elif idx == 2: self.d = val
        elif idx == 3: self.e = val
        elif idx == 4: self.h = val
        elif idx == 5: self.l = val
        elif idx == 6: self._write8(self.hl, val)
        else: self.a = val

    def _get_reg16(self, idx: int) -> int:
        if idx == 0: return self.bc
        if idx == 1: return self.de
        if idx == 2: return self.hl
        return self.sp

    def _set_reg16(self, idx: int, val: int):
        val &= 0xFFFF
        if idx == 0: self.bc = val
        elif idx == 1: self.de = val
        elif idx == 2: self.hl = val
        else: self.sp = val

    def _check_cond(self, cc: int) -> bool:
        if cc == 0: return (self.f & ZFLAG_Z) == 0
        if cc == 1: return (self.f & ZFLAG_Z) != 0
        if cc == 2: return (self.f & ZFLAG_C) == 0
        if cc == 3: return (self.f & ZFLAG_C) != 0
        if cc == 4: return (self.f & ZFLAG_PV) == 0
        if cc == 5: return (self.f & ZFLAG_PV) != 0
        if cc == 6: return (self.f & ZFLAG_S) == 0
        return (self.f & ZFLAG_S) != 0

    def _alu8(self, op_idx: int, val: int):
        val &= 0xFF
        c_in = 1 if (self.f & ZFLAG_C) else 0
        if op_idx in (0, 1):  # ADD, ADC
            add_c = c_in if op_idx == 1 else 0
            res = self.a + val + add_c
            r8 = res & 0xFF
            fl = (ZFLAG_S if (r8 & 0x80) else 0) | (ZFLAG_Z if r8 == 0 else 0)
            if ((self.a & 0x0F) + (val & 0x0F) + add_c) > 0x0F:
                fl |= ZFLAG_H
            if ((~(self.a ^ val) & (self.a ^ r8)) & 0x80) != 0:
                fl |= ZFLAG_PV
            if res > 0xFF:
                fl |= ZFLAG_C
            self.a = r8
            self.f = fl
        elif op_idx in (2, 3, 7):  # SUB, SBC, CP
            sub_c = c_in if op_idx == 3 else 0
            res = self.a - val - sub_c
            r8 = res & 0xFF
            fl = ZFLAG_N | (ZFLAG_S if (r8 & 0x80) else 0) | (ZFLAG_Z if r8 == 0 else 0)
            if ((self.a & 0x0F) - (val & 0x0F) - sub_c) < 0:
                fl |= ZFLAG_H
            if (((self.a ^ val) & (self.a ^ r8)) & 0x80) != 0:
                fl |= ZFLAG_PV
            if res < 0:
                fl |= ZFLAG_C
            if op_idx != 7:
                self.a = r8
            self.f = fl
        elif op_idx == 4:  # AND
            self.a &= val
            self.f = self._szp(self.a) | ZFLAG_H
        elif op_idx == 5:  # XOR
            self.a ^= val
            self.f = self._szp(self.a)
        elif op_idx == 6:  # OR
            self.a |= val
            self.f = self._szp(self.a)

    def step(self) -> int:
        if self.halted:
            self.cycles += 4
            return 4

        op = self._fetch8()
        self.instructions_executed += 1
        self.r = ((self.r + 1) & 0x7F) | (self.r & 0x80)
        cyc = 4

        if op == 0x00:  # NOP
            pass
        elif op == 0x08:  # EX AF,AF'
            self.a, self.a_p = self.a_p, self.a
            self.f, self.f_p = self.f_p, self.f
        elif op == 0xD9:  # EXX
            self.b, self.b_p = self.b_p, self.b
            self.c, self.c_p = self.c_p, self.c
            self.d, self.d_p = self.d_p, self.d
            self.e, self.e_p = self.e_p, self.e
            self.h, self.h_p = self.h_p, self.h
            self.l, self.l_p = self.l_p, self.l
        elif op == 0xEB:  # EX DE,HL
            self.de, self.hl = self.hl, self.de
        elif op == 0xE3:  # EX (SP),HL
            v = self._read16(self.sp)
            self._write16(self.sp, self.hl)
            self.hl = v
            cyc = 19
        elif op == 0xF9:  # LD SP,HL
            self.sp = self.hl
            cyc = 6
        elif op == 0xF3:  # DI
            self.iff1 = False
            self.iff2 = False
        elif op == 0xFB:  # EI
            self.iff1 = True
            self.iff2 = True
        elif op == 0x76:  # HALT
            self.halted = True
        elif op == 0x2F:  # CPL
            self.a ^= 0xFF
            self.f |= (ZFLAG_H | ZFLAG_N)
        elif op == 0x37:  # SCF
            self.f = (self.f & (ZFLAG_S | ZFLAG_Z | ZFLAG_PV)) | ZFLAG_C
        elif op == 0x3F:  # CCF
            c = 1 if (self.f & ZFLAG_C) else 0
            self.f = (self.f & (ZFLAG_S | ZFLAG_Z | ZFLAG_PV)) | (0 if c else ZFLAG_C)
        elif op == 0x07:  # RLCA
            c = (self.a >> 7) & 1
            self.a = ((self.a << 1) | c) & 0xFF
            self.f = (self.f & (ZFLAG_S | ZFLAG_Z | ZFLAG_PV)) | c
        elif op == 0x0F:  # RRCA
            c = self.a & 1
            self.a = ((self.a >> 1) | (c << 7)) & 0xFF
            self.f = (self.f & (ZFLAG_S | ZFLAG_Z | ZFLAG_PV)) | c
        elif op == 0x17:  # RLA
            old_c = 1 if (self.f & ZFLAG_C) else 0
            new_c = (self.a >> 7) & 1
            self.a = ((self.a << 1) | old_c) & 0xFF
            self.f = (self.f & (ZFLAG_S | ZFLAG_Z | ZFLAG_PV)) | new_c
        elif op == 0x1F:  # RRA
            old_c = 0x80 if (self.f & ZFLAG_C) else 0
            new_c = self.a & 1
            self.a = ((self.a >> 1) | old_c) & 0xFF
            self.f = (self.f & (ZFLAG_S | ZFLAG_Z | ZFLAG_PV)) | new_c

        # 8-bit Load Group: LD r,r'
        elif 0x40 <= op <= 0x7F:
            dst = (op >> 3) & 7
            src = op & 7
            self._set_reg8(dst, self._get_reg8(src))
            cyc = 7 if (dst == 6 or src == 6) else 4

        # 8-bit Immediate Load: LD r,n
        elif (op & 0xC7) == 0x06:
            dst = (op >> 3) & 7
            self._set_reg8(dst, self._fetch8())
            cyc = 10 if dst == 6 else 7

        # LD A,(BC)/(DE)/(nn) & LD (BC)/(DE)/(nn),A
        elif op == 0x0A: self.a = self._read8(self.bc); cyc = 7
        elif op == 0x1A: self.a = self._read8(self.de); cyc = 7
        elif op == 0x3A: self.a = self._read8(self._fetch16()); cyc = 13
        elif op == 0x02: self._write8(self.bc, self.a); cyc = 7
        elif op == 0x12: self._write8(self.de, self.a); cyc = 7
        elif op == 0x32: self._write8(self._fetch16(), self.a); cyc = 13

        # 16-bit Load Immediate: LD rr,nn
        elif (op & 0xCF) == 0x01:
            self._set_reg16((op >> 4) & 3, self._fetch16())
            cyc = 10
        elif op == 0x2A:  # LD HL,(nn)
            self.hl = self._read16(self._fetch16())
            cyc = 16
        elif op == 0x22:  # LD (nn),HL
            self._write16(self._fetch16(), self.hl)
            cyc = 16

        # PUSH / POP
        elif (op & 0xCF) == 0xC5:
            idx = (op >> 4) & 3
            val = self.af if idx == 3 else self._get_reg16(idx)
            self._push16(val)
            cyc = 11
        elif (op & 0xCF) == 0xC1:
            idx = (op >> 4) & 3
            val = self._pop16()
            if idx == 3: self.af = val
            else: self._set_reg16(idx, val)
            cyc = 10

        # 8-bit ALU register & immediate
        elif 0x80 <= op <= 0xBF:
            self._alu8((op >> 3) & 7, self._get_reg8(op & 7))
            cyc = 7 if (op & 7) == 6 else 4
        elif (op & 0xC7) == 0xC6:
            self._alu8((op >> 3) & 7, self._fetch8())
            cyc = 7

        # 8-bit INC / DEC
        elif (op & 0xC7) == 0x04:
            r = (op >> 3) & 7
            v = (self._get_reg8(r) + 1) & 0xFF
            self._set_reg8(r, v)
            self.f = (self.f & ZFLAG_C) | (ZFLAG_Z if v == 0 else 0) | (ZFLAG_S if (v & 0x80) else 0) | (ZFLAG_PV if v == 0x80 else 0) | (ZFLAG_H if (v & 0x0F) == 0 else 0)
        elif (op & 0xC7) == 0x05:
            r = (op >> 3) & 7
            v = (self._get_reg8(r) - 1) & 0xFF
            self._set_reg8(r, v)
            self.f = (self.f & ZFLAG_C) | ZFLAG_N | (ZFLAG_Z if v == 0 else 0) | (ZFLAG_S if (v & 0x80) else 0) | (ZFLAG_PV if v == 0x7F else 0) | (ZFLAG_H if (v & 0x0F) == 0x0F else 0)

        # 16-bit INC / DEC / ADD HL,rr
        elif (op & 0xCF) == 0x03:
            rr = (op >> 4) & 3
            self._set_reg16(rr, (self._get_reg16(rr) + 1) & 0xFFFF)
            cyc = 6
        elif (op & 0xCF) == 0x0B:
            rr = (op >> 4) & 3
            self._set_reg16(rr, (self._get_reg16(rr) - 1) & 0xFFFF)
            cyc = 6
        elif (op & 0xCF) == 0x09:
            rr = (op >> 4) & 3
            s = self.hl + self._get_reg16(rr)
            self.f = (self.f & (ZFLAG_S | ZFLAG_Z | ZFLAG_PV)) | (ZFLAG_C if s > 0xFFFF else 0)
            self.hl = s & 0xFFFF
            cyc = 11

        # Jumps, Calls, Returns, Restarts
        elif op == 0xC3:
            self.pc = self._fetch16()
            cyc = 10
        elif (op & 0xC7) == 0xC2:
            target = self._fetch16()
            if self._check_cond((op >> 3) & 7):
                self.pc = target
            cyc = 10
        elif op == 0xE9:
            self.pc = self.hl
            cyc = 4
        elif op == 0x18:
            rel = self._fetch8()
            if rel >= 0x80: rel -= 0x100
            self.pc = (self.pc + rel) & 0xFFFF
            cyc = 12
        elif op in (0x20, 0x28, 0x30, 0x38):
            rel = self._fetch8()
            if self._check_cond((op - 0x20) >> 3):
                if rel >= 0x80: rel -= 0x100
                self.pc = (self.pc + rel) & 0xFFFF
                cyc = 12
            else:
                cyc = 7
        elif op == 0x10:  # DJNZ
            rel = self._fetch8()
            self.b = (self.b - 1) & 0xFF
            if self.b != 0:
                if rel >= 0x80: rel -= 0x100
                self.pc = (self.pc + rel) & 0xFFFF
                cyc = 13
            else:
                cyc = 8
        elif op == 0xCD:  # CALL nn
            target = self._fetch16()
            self._push16(self.pc)
            self.pc = target
            cyc = 17
        elif (op & 0xC7) == 0xC4:  # CALL cc,nn
            target = self._fetch16()
            if self._check_cond((op >> 3) & 7):
                self._push16(self.pc)
                self.pc = target
                cyc = 17
            else:
                cyc = 10
        elif op == 0xC9:  # RET
            self.pc = self._pop16()
            cyc = 10
        elif (op & 0xC7) == 0xC0:  # RET cc
            if self._check_cond((op >> 3) & 7):
                self.pc = self._pop16()
                cyc = 11
            else:
                cyc = 5
        elif (op & 0xC7) == 0xC7:  # RST p
            self._push16(self.pc)
            self.pc = op & 0x38
            cyc = 11

        # Port I/O: IN A,(n) / OUT (n),A
        elif op == 0xDB:
            port = (self.a << 8) | self._fetch8()
            self.a = self.bus.read_io(port)
            cyc = 11
        elif op == 0xD3:
            port = (self.a << 8) | self._fetch8()
            self.bus.write_io(port, self.a)
            cyc = 11

        # CB Prefix (Bit / Shift Operations)
        elif op == 0xCB:
            b1 = self._fetch8()
            r = b1 & 7
            bit = (b1 >> 3) & 7
            top = b1 >> 6
            v = self._get_reg8(r)
            if top == 0:
                if bit == 0:   # RLC
                    c = (v >> 7) & 1; v = ((v << 1) | c) & 0xFF
                elif bit == 1: # RRC
                    c = v & 1; v = ((v >> 1) | (c << 7)) & 0xFF
                elif bit == 2: # RL
                    old_c = 1 if (self.f & ZFLAG_C) else 0; c = (v >> 7) & 1; v = ((v << 1) | old_c) & 0xFF
                elif bit == 3: # RR
                    old_c = 0x80 if (self.f & ZFLAG_C) else 0; c = v & 1; v = ((v >> 1) | old_c) & 0xFF
                elif bit == 4: # SLA
                    c = (v >> 7) & 1; v = (v << 1) & 0xFF
                elif bit == 5: # SRA
                    c = v & 1; v = ((v >> 1) | (v & 0x80)) & 0xFF
                elif bit == 6: # SLL
                    c = (v >> 7) & 1; v = ((v << 1) | 1) & 0xFF
                else:          # SRL
                    c = v & 1; v = (v >> 1) & 0xFF
                self._set_reg8(r, v)
                self.f = self._szp(v) | c
            elif top == 1:  # BIT
                z = ZFLAG_Z if (v & (1 << bit)) == 0 else 0
                self.f = (self.f & ZFLAG_C) | ZFLAG_H | z
            elif top == 2:  # RES
                self._set_reg8(r, v & ~(1 << bit))
            else:           # SET
                self._set_reg8(r, v | (1 << bit))
            cyc = 8

        # ED Prefix (Extended Instructions: IN r,(C), OUT (C),r, LDIR, LDDR, LD (nn),rr, etc.)
        elif op == 0xED:
            b1 = self._fetch8()
            if (b1 & 0xC7) == 0x40:  # IN r,(C)
                r = (b1 >> 3) & 7
                v = self.bus.read_io(self.bc)
                if r != 6:
                    self._set_reg8(r, v)
                self.f = (self.f & ZFLAG_C) | self._szp(v)
                cyc = 12
            elif (b1 & 0xC7) == 0x41:  # OUT (C),r
                r = (b1 >> 3) & 7
                v = 0 if r == 6 else self._get_reg8(r)
                self.bus.write_io(self.bc, v)
                cyc = 12
            elif (b1 & 0xCF) == 0x43:  # LD (nn),rr
                addr = self._fetch16()
                self._write16(addr, self._get_reg16((b1 >> 4) & 3))
                cyc = 20
            elif (b1 & 0xCF) == 0x4B:  # LD rr,(nn)
                addr = self._fetch16()
                self._set_reg16((b1 >> 4) & 3, self._read16(addr))
                cyc = 20
            elif (b1 & 0xCF) == 0x42:  # SBC HL,rr
                rr = self._get_reg16((b1 >> 4) & 3)
                c = 1 if (self.f & ZFLAG_C) else 0
                res = self.hl - rr - c
                self.hl = res & 0xFFFF
                self.f = ZFLAG_N | (ZFLAG_Z if self.hl == 0 else 0) | (ZFLAG_S if (self.hl & 0x8000) else 0) | (ZFLAG_C if res < 0 else 0)
                cyc = 15
            elif (b1 & 0xCF) == 0x4A:  # ADC HL,rr
                rr = self._get_reg16((b1 >> 4) & 3)
                c = 1 if (self.f & ZFLAG_C) else 0
                res = self.hl + rr + c
                self.hl = res & 0xFFFF
                self.f = (ZFLAG_Z if self.hl == 0 else 0) | (ZFLAG_S if (self.hl & 0x8000) else 0) | (ZFLAG_C if res > 0xFFFF else 0)
                cyc = 15
            elif b1 in (0xA0, 0xB0):  # LDI / LDIR
                v = self._read8(self.hl)
                self._write8(self.de, v)
                self.hl = (self.hl + 1) & 0xFFFF
                self.de = (self.de + 1) & 0xFFFF
                self.bc = (self.bc - 1) & 0xFFFF
                if b1 == 0xB0 and self.bc != 0:
                    self.pc = (self.pc - 2) & 0xFFFF
                    self.f = (self.f & (ZFLAG_S | ZFLAG_Z | ZFLAG_C)) | ZFLAG_PV
                    cyc = 21
                else:
                    self.f = (self.f & (ZFLAG_S | ZFLAG_Z | ZFLAG_C)) | (ZFLAG_PV if self.bc != 0 else 0)
                    cyc = 16
            elif b1 in (0xA8, 0xB8):  # LDD / LDDR
                v = self._read8(self.hl)
                self._write8(self.de, v)
                self.hl = (self.hl - 1) & 0xFFFF
                self.de = (self.de - 1) & 0xFFFF
                self.bc = (self.bc - 1) & 0xFFFF
                if b1 == 0xB8 and self.bc != 0:
                    self.pc = (self.pc - 2) & 0xFFFF
                    self.f = (self.f & (ZFLAG_S | ZFLAG_Z | ZFLAG_C)) | ZFLAG_PV
                    cyc = 21
                else:
                    self.f = (self.f & (ZFLAG_S | ZFLAG_Z | ZFLAG_C)) | (ZFLAG_PV if self.bc != 0 else 0)
                    cyc = 16
            elif b1 == 0x44:  # NEG
                v = self.a
                self.a = 0
                self._alu8(2, v)
                cyc = 8
            elif b1 in (0x45, 0x4D):  # RETN / RETI
                self.iff1 = self.iff2
                self.pc = self._pop16()
                cyc = 14
            elif b1 == 0x46: self.im = 0; cyc = 8
            elif b1 == 0x56: self.im = 1; cyc = 8
            elif b1 == 0x5E: self.im = 2; cyc = 8
            elif b1 == 0x47: self.i = self.a; cyc = 9
            elif b1 == 0x4F: self.r = self.a; cyc = 9
            elif b1 == 0x57: self.a = self.i; cyc = 9
            elif b1 == 0x5F: self.a = self.r; cyc = 9

        self.cycles += cyc
        return cyc
