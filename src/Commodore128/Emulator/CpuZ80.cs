using System.Numerics;

namespace Commodore128.Emulator;

/// <summary>
/// Zilog Z80A CPU Core Implementation for .NET 8 x64 (`Commodore128`).
/// </summary>
public sealed class CpuZ80
{
    public const byte FlagC = 0x01, FlagN = 0x02, FlagPv = 0x04, FlagH = 0x10, FlagZ = 0x40, FlagS = 0x80;

    private readonly MemoryBus _bus;
    public byte A, F, B, C, D, E, H, L;
    public byte AP, FP, BP, CP, DP, EP, HP, LP;
    public ushort Sp = 0xFFFF, Pc = 0x0000;
    public ushort PC { get => Pc; set => Pc = value; }
    public ushort Ix = 0x0000, Iy = 0x0000;
    public byte I, R;
    public bool Iff1, Iff2, Halted;
    public int Im;
    public long InstructionsExecuted;

    public CpuZ80(MemoryBus bus) => _bus = bus;

    public ushort Bc { get => (ushort)((B << 8) | C); set { B = (byte)(value >> 8); C = (byte)value; } }
    public ushort De { get => (ushort)((D << 8) | E); set { D = (byte)(value >> 8); E = (byte)value; } }
    public ushort Hl { get => (ushort)((H << 8) | L); set { H = (byte)(value >> 8); L = (byte)value; } }
    public ushort Af { get => (ushort)((A << 8) | F); set { A = (byte)(value >> 8); F = (byte)value; } }

    public void Reset() { Pc = 0x0000; Sp = 0xFFFF; Ix = 0; Iy = 0; Iff1 = Iff2 = Halted = false; Im = 0; }

    private byte Read8(int a) => _bus.Read8(a & 0xFFFF, true);
    private void Write8(int a, byte v) => _bus.Write8(a & 0xFFFF, v, true);
    private ushort Read16(int a) => (ushort)(Read8(a) | (Read8(a + 1) << 8));
    private void Write16(int a, ushort v) { Write8(a, (byte)v); Write8(a + 1, (byte)(v >> 8)); }
    private byte Fetch8() => Read8(Pc++);
    private ushort Fetch16() { byte lo = Fetch8(); byte hi = Fetch8(); return (ushort)((hi << 8) | lo); }
    private void Push16(ushort v) { Write8(--Sp, (byte)(v >> 8)); Write8(--Sp, (byte)v); }
    private ushort Pop16() { byte lo = Read8(Sp++); byte hi = Read8(Sp++); return (ushort)((hi << 8) | lo); }

    private static byte Szp(byte v)
    {
        byte fl = (BitOperations.PopCount(v) & 1) == 0 ? FlagPv : (byte)0;
        if (v == 0) fl |= FlagZ;
        if ((v & 0x80) != 0) fl |= FlagS;
        return fl;
    }

    private byte GetReg8(int idx) => idx switch { 0 => B, 1 => C, 2 => D, 3 => E, 4 => H, 5 => L, 6 => Read8(Hl), _ => A };
    private void SetReg8(int idx, byte v)
    {
        switch (idx)
        {
            case 0: B = v; break; case 1: C = v; break; case 2: D = v; break; case 3: E = v; break;
            case 4: H = v; break; case 5: L = v; break; case 6: Write8(Hl, v); break; default: A = v; break;
        }
    }

    private ushort GetReg16(int idx) => idx switch { 0 => Bc, 1 => De, 2 => Hl, _ => Sp };
    private void SetReg16(int idx, ushort v)
    {
        switch (idx) { case 0: Bc = v; break; case 1: De = v; break; case 2: Hl = v; break; default: Sp = v; break; }
    }

    private bool CheckCond(int cc) => cc switch
    {
        0 => (F & FlagZ) == 0, 1 => (F & FlagZ) != 0, 2 => (F & FlagC) == 0, 3 => (F & FlagC) != 0,
        4 => (F & FlagPv) == 0, 5 => (F & FlagPv) != 0, 6 => (F & FlagS) == 0, _ => (F & FlagS) != 0
    };

    private void Alu8(int op, byte val)
    {
        int cin = (F & FlagC) != 0 ? 1 : 0;
        if (op == 0 || op == 1)
        {
            int addC = op == 1 ? cin : 0;
            int res = A + val + addC;
            byte r8 = (byte)res;
            byte fl = (byte)((r8 == 0 ? FlagZ : 0) | ((r8 & 0x80) != 0 ? FlagS : 0));
            if (((A & 0x0F) + (val & 0x0F) + addC) > 0x0F) fl |= FlagH;
            if (((~(A ^ val) & (A ^ r8)) & 0x80) != 0) fl |= FlagPv;
            if (res > 0xFF) fl |= FlagC;
            A = r8; F = fl;
        }
        else if (op == 2 || op == 3 || op == 7)
        {
            int subC = op == 3 ? cin : 0;
            int res = A - val - subC;
            byte r8 = (byte)res;
            byte fl = (byte)(FlagN | (r8 == 0 ? FlagZ : 0) | ((r8 & 0x80) != 0 ? FlagS : 0));
            if (((A & 0x0F) - (val & 0x0F) - subC) < 0) fl |= FlagH;
            if ((((A ^ val) & (A ^ r8)) & 0x80) != 0) fl |= FlagPv;
            if (res < 0) fl |= FlagC;
            if (op != 7) A = r8;
            F = fl;
        }
        else if (op == 4) { A &= val; F = (byte)(Szp(A) | FlagH); }
        else if (op == 5) { A ^= val; F = Szp(A); }
        else if (op == 6) { A |= val; F = Szp(A); }
    }

    public int Step()
    {
        if (Halted) return 4;
        byte op = Fetch8();
        InstructionsExecuted++;
        R = (byte)(((R + 1) & 0x7F) | (R & 0x80));

        if (op == 0x00) return 4;
        if (op == 0x08) { (A, AP) = (AP, A); (F, FP) = (FP, F); return 4; }
        if (op == 0xD9) { (B, BP) = (BP, B); (C, CP) = (CP, C); (D, DP) = (DP, D); (E, EP) = (EP, E); (H, HP) = (HP, H); (L, LP) = (LP, L); return 4; }
        if (op == 0xEB) { (De, Hl) = (Hl, De); return 4; }
        if (op == 0xE3) { ushort v = Read16(Sp); Write16(Sp, Hl); Hl = v; return 19; }
        if (op == 0xF9) { Sp = Hl; return 6; }
        if (op == 0xF3) { Iff1 = Iff2 = false; return 4; }
        if (op == 0xFB) { Iff1 = Iff2 = true; return 4; }
        if (op == 0x76) { Halted = true; return 4; }
        if (op == 0x27)
        {
            int a = A;
            if ((F & FlagN) == 0)
            {
                if ((F & FlagH) != 0 || (a & 0x0F) > 9) a += 6;
                if ((F & FlagC) != 0 || a > 0x9F) { a += 0x60; F |= FlagC; }
            }
            else
            {
                if ((F & FlagH) != 0) a = (a - 6) & 0xFF;
                if ((F & FlagC) != 0) a -= 0x60;
            }
            A = (byte)a;
            F = (byte)((F & (FlagC | FlagN)) | Szp(A));
            return 4;
        }
        if (op == 0x2F) { A ^= 0xFF; F |= FlagH | FlagN; return 4; }
        if (op == 0x37) { F = (byte)((F & (FlagS | FlagZ | FlagPv)) | FlagC); return 4; }
        if (op == 0x3F) { F = (byte)((F & (FlagS | FlagZ | FlagPv)) | ((F & FlagC) != 0 ? 0 : FlagC)); return 4; }
        if (op == 0x07) { int c = (A >> 7) & 1; A = (byte)((A << 1) | c); F = (byte)((F & (FlagS | FlagZ | FlagPv)) | c); return 4; }
        if (op == 0x0F) { int c = A & 1; A = (byte)((A >> 1) | (c << 7)); F = (byte)((F & (FlagS | FlagZ | FlagPv)) | c); return 4; }
        if (op == 0x17) { int oc = (F & FlagC) != 0 ? 1 : 0; int nc = (A >> 7) & 1; A = (byte)((A << 1) | oc); F = (byte)((F & (FlagS | FlagZ | FlagPv)) | nc); return 4; }
        if (op == 0x1F) { int oc = (F & FlagC) != 0 ? 0x80 : 0; int nc = A & 1; A = (byte)((A >> 1) | oc); F = (byte)((F & (FlagS | FlagZ | FlagPv)) | nc); return 4; }

        if (op >= 0x40 && op <= 0x7F) { SetReg8((op >> 3) & 7, GetReg8(op & 7)); return 7; }
        if ((op & 0xC7) == 0x06) { SetReg8((op >> 3) & 7, Fetch8()); return 7; }
        if (op == 0x0A) { A = Read8(Bc); return 7; }
        if (op == 0x1A) { A = Read8(De); return 7; }
        if (op == 0x3A) { A = Read8(Fetch16()); return 13; }
        if (op == 0x02) { Write8(Bc, A); return 7; }
        if (op == 0x12) { Write8(De, A); return 7; }
        if (op == 0x32) { Write8(Fetch16(), A); return 13; }
        if ((op & 0xCF) == 0x01) { SetReg16((op >> 4) & 3, Fetch16()); return 10; }
        if (op == 0x2A) { Hl = Read16(Fetch16()); return 16; }
        if (op == 0x22) { Write16(Fetch16(), Hl); return 16; }

        if ((op & 0xCF) == 0xC5) { int idx = (op >> 4) & 3; Push16(idx == 3 ? Af : GetReg16(idx)); return 11; }
        if ((op & 0xCF) == 0xC1) { int idx = (op >> 4) & 3; ushort v = Pop16(); if (idx == 3) Af = v; else SetReg16(idx, v); return 10; }

        if (op >= 0x80 && op <= 0xBF) { Alu8((op >> 3) & 7, GetReg8(op & 7)); return 4; }
        if ((op & 0xC7) == 0xC6) { Alu8((op >> 3) & 7, Fetch8()); return 7; }

        if ((op & 0xC7) == 0x04)
        {
            int r = (op >> 3) & 7; byte v = (byte)(GetReg8(r) + 1); SetReg8(r, v);
            F = (byte)((F & FlagC) | (v == 0 ? FlagZ : 0) | ((v & 0x80) != 0 ? FlagS : 0) | (v == 0x80 ? FlagPv : 0) | ((v & 0x0F) == 0 ? FlagH : 0));
            return 4;
        }
        if ((op & 0xC7) == 0x05)
        {
            int r = (op >> 3) & 7; byte v = (byte)(GetReg8(r) - 1); SetReg8(r, v);
            F = (byte)((F & FlagC) | FlagN | (v == 0 ? FlagZ : 0) | ((v & 0x80) != 0 ? FlagS : 0) | (v == 0x7F ? FlagPv : 0) | ((v & 0x0F) == 0x0F ? FlagH : 0));
            return 4;
        }

        if ((op & 0xCF) == 0x03) { int rr = (op >> 4) & 3; SetReg16(rr, (ushort)(GetReg16(rr) + 1)); return 6; }
        if ((op & 0xCF) == 0x0B) { int rr = (op >> 4) & 3; SetReg16(rr, (ushort)(GetReg16(rr) - 1)); return 6; }
        if ((op & 0xCF) == 0x09)
        {
            int s = Hl + GetReg16((op >> 4) & 3);
            F = (byte)((F & (FlagS | FlagZ | FlagPv)) | (s > 0xFFFF ? FlagC : 0));
            Hl = (ushort)s; return 11;
        }

        if (op == 0xC3) { Pc = Fetch16(); return 10; }
        if ((op & 0xC7) == 0xC2) { ushort t = Fetch16(); if (CheckCond((op >> 3) & 7)) Pc = t; return 10; }
        if (op == 0xE9) { Pc = Hl; return 4; }
        if (op == 0x18) { sbyte rel = (sbyte)Fetch8(); Pc = (ushort)(Pc + rel); return 12; }
        if (op == 0x20 || op == 0x28 || op == 0x30 || op == 0x38)
        {
            sbyte rel = (sbyte)Fetch8();
            if (CheckCond((op - 0x20) >> 3)) { Pc = (ushort)(Pc + rel); return 12; }
            return 7;
        }
        if (op == 0x10) { sbyte rel = (sbyte)Fetch8(); if (--B != 0) { Pc = (ushort)(Pc + rel); return 13; } return 8; }
        if (op == 0xCD) { ushort t = Fetch16(); Push16(Pc); Pc = t; return 17; }
        if ((op & 0xC7) == 0xC4) { ushort t = Fetch16(); if (CheckCond((op >> 3) & 7)) { Push16(Pc); Pc = t; return 17; } return 10; }
        if (op == 0xC9) { Pc = Pop16(); return 10; }
        if ((op & 0xC7) == 0xC0) { if (CheckCond((op >> 3) & 7)) { Pc = Pop16(); return 11; } return 5; }
        if ((op & 0xC7) == 0xC7) { Push16(Pc); Pc = (ushort)(op & 0x38); return 11; }

        if (op == 0xDB) { A = _bus.ReadIo((A << 8) | Fetch8()); return 11; }
        if (op == 0xD3) { _bus.WriteIo((A << 8) | Fetch8(), A); return 11; }

        if (op == 0xCB)
        {
            byte b1 = Fetch8(); int r = b1 & 7; int bit = (b1 >> 3) & 7; int top = b1 >> 6;
            byte v = GetReg8(r);
            if (top == 0)
            {
                int c;
                switch (bit)
                {
                    case 0: c = (v >> 7) & 1; v = (byte)((v << 1) | c); break;
                    case 1: c = v & 1; v = (byte)((v >> 1) | (c << 7)); break;
                    case 2: { int oc = (F & FlagC) != 0 ? 1 : 0; c = (v >> 7) & 1; v = (byte)((v << 1) | oc); break; }
                    case 3: { int oc = (F & FlagC) != 0 ? 0x80 : 0; c = v & 1; v = (byte)((v >> 1) | oc); break; }
                    case 4: c = (v >> 7) & 1; v = (byte)(v << 1); break;
                    case 5: c = v & 1; v = (byte)((v >> 1) | (v & 0x80)); break;
                    case 6: c = (v >> 7) & 1; v = (byte)((v << 1) | 1); break;
                    default: c = v & 1; v = (byte)(v >> 1); break;
                }
                SetReg8(r, v);
                F = (byte)(Szp(v) | c);
            }
            else if (top == 1) F = (byte)((F & FlagC) | FlagH | ((v & (1 << bit)) == 0 ? FlagZ : 0));
            else if (top == 2) SetReg8(r, (byte)(v & ~(1 << bit)));
            else if (top == 3) SetReg8(r, (byte)(v | (1 << bit)));
            return 8;
        }

        if (op == 0xED)
        {
            byte b1 = Fetch8();
            if ((b1 & 0xC7) == 0x40) { int r = (b1 >> 3) & 7; byte v = _bus.ReadIo(Bc); if (r != 6) SetReg8(r, v); F = (byte)((F & FlagC) | Szp(v)); return 12; }
            if ((b1 & 0xC7) == 0x41) { int r = (b1 >> 3) & 7; _bus.WriteIo(Bc, r == 6 ? (byte)0 : GetReg8(r)); return 12; }
            if ((b1 & 0xCF) == 0x43) { Write16(Fetch16(), GetReg16((b1 >> 4) & 3)); return 20; }
            if ((b1 & 0xCF) == 0x4B) { SetReg16((b1 >> 4) & 3, Read16(Fetch16())); return 20; }
            if ((b1 & 0xCF) == 0x42)
            {
                ushort rr = GetReg16((b1 >> 4) & 3);
                int c = (F & FlagC) != 0 ? 1 : 0;
                int res = Hl - rr - c;
                Hl = (ushort)res;
                F = (byte)(FlagN | (Hl == 0 ? FlagZ : 0) | ((Hl & 0x8000) != 0 ? FlagS : 0) | (res < 0 ? FlagC : 0));
                return 15;
            }
            if ((b1 & 0xCF) == 0x4A)
            {
                ushort rr = GetReg16((b1 >> 4) & 3);
                int c = (F & FlagC) != 0 ? 1 : 0;
                int res = Hl + rr + c;
                Hl = (ushort)res;
                F = (byte)((Hl == 0 ? FlagZ : 0) | ((Hl & 0x8000) != 0 ? FlagS : 0) | (res > 0xFFFF ? FlagC : 0));
                return 15;
            }
            if (b1 == 0xA0 || b1 == 0xB0)
            {
                Write8(De++, Read8(Hl++)); Bc--;
                if (b1 == 0xB0 && Bc != 0) { Pc -= 2; F = (byte)((F & (FlagS | FlagZ | FlagC)) | FlagPv); return 21; }
                F = (byte)((F & (FlagS | FlagZ | FlagC)) | (Bc != 0 ? FlagPv : 0));
                return 16;
            }
            if (b1 == 0xA8 || b1 == 0xB8)
            {
                Write8(De--, Read8(Hl--)); Bc--;
                if (b1 == 0xB8 && Bc != 0) { Pc -= 2; F = (byte)((F & (FlagS | FlagZ | FlagC)) | FlagPv); return 21; }
                F = (byte)((F & (FlagS | FlagZ | FlagC)) | (Bc != 0 ? FlagPv : 0));
                return 16;
            }
            if (b1 == 0xA1 || b1 == 0xB1)
            {
                byte v = Read8(Hl++);
                int res = A - v;
                Bc--;
                F = (byte)(FlagN | (res == 0 ? FlagZ : 0) | ((res & 0x80) != 0 ? FlagS : 0) | (Bc != 0 ? FlagPv : 0) | (F & FlagC));
                if (((A & 0x0F) - (v & 0x0F)) < 0) F |= FlagH;
                if (b1 == 0xB1 && Bc != 0 && res != 0) { Pc -= 2; return 21; }
                return 16;
            }
            if (b1 == 0xA9 || b1 == 0xB9)
            {
                byte v = Read8(Hl--);
                int res = A - v;
                Bc--;
                F = (byte)(FlagN | (res == 0 ? FlagZ : 0) | ((res & 0x80) != 0 ? FlagS : 0) | (Bc != 0 ? FlagPv : 0) | (F & FlagC));
                if (((A & 0x0F) - (v & 0x0F)) < 0) F |= FlagH;
                if (b1 == 0xB9 && Bc != 0 && res != 0) { Pc -= 2; return 21; }
                return 16;
            }
            if (b1 == 0xA2 || b1 == 0xB2)
            {
                byte v = _bus.ReadIo(Bc); Write8(Hl++, v); B--;
                F = (byte)(FlagN | (B == 0 ? FlagZ : 0));
                if (b1 == 0xB2 && B != 0) { Pc -= 2; return 21; }
                return 16;
            }
            if (b1 == 0xA3 || b1 == 0xB3)
            {
                byte v = Read8(Hl++); _bus.WriteIo(Bc, v); B--;
                F = (byte)(FlagN | (B == 0 ? FlagZ : 0));
                if (b1 == 0xB3 && B != 0) { Pc -= 2; return 21; }
                return 16;
            }
            if (b1 == 0x6F)
            {
                byte v = Read8(Hl); byte lowA = (byte)(A & 0x0F);
                A = (byte)((A & 0xF0) | (v >> 4));
                Write8(Hl, (byte)((v << 4) | lowA));
                F = (byte)((F & FlagC) | Szp(A));
                return 18;
            }
            if (b1 == 0x67)
            {
                byte v = Read8(Hl); byte lowA = (byte)(A & 0x0F);
                A = (byte)((A & 0xF0) | (v & 0x0F));
                Write8(Hl, (byte)((v >> 4) | (lowA << 4)));
                F = (byte)((F & FlagC) | Szp(A));
                return 18;
            }
            if (b1 == 0x44) { byte v = A; A = 0; Alu8(2, v); return 8; }
            if (b1 == 0x45 || b1 == 0x4D) { Iff1 = Iff2; Pc = Pop16(); return 14; }
            if (b1 == 0x46) { Im = 0; return 8; }
            if (b1 == 0x56) { Im = 1; return 8; }
            if (b1 == 0x5E) { Im = 2; return 8; }
            if (b1 == 0x47) { I = A; return 9; }
            if (b1 == 0x4F) { R = A; return 9; }
            if (b1 == 0x57) { A = I; return 9; }
            if (b1 == 0x5F) { A = R; return 9; }
        }

        if (op == 0xDD) return StepIndexed(false);
        if (op == 0xFD) return StepIndexed(true);

        return 4;
    }

    private int StepIndexed(bool isIy)
    {
        byte subOp = Fetch8();
        ref ushort ir = ref isIy ? ref Iy : ref Ix;

        // 0x09, 0x19, 0x29, 0x39: ADD IR, rr
        if ((subOp & 0xCF) == 0x09)
        {
            int r = (subOp >> 4) & 3;
            ushort val = r == 2 ? ir : GetReg16(r);
            int s = ir + val;
            F = (byte)((F & (FlagS | FlagZ | FlagPv)) | (s > 0xFFFF ? FlagC : 0));
            ir = (ushort)s;
            return 15;
        }

        if (subOp == 0x21) { ir = Fetch16(); return 14; }
        if (subOp == 0x22) { Write16(Fetch16(), ir); return 20; }
        if (subOp == 0x2A) { ir = Read16(Fetch16()); return 20; }
        if (subOp == 0x23) { ir++; return 10; }
        if (subOp == 0x2B) { ir--; return 10; }
        if (subOp == 0xE1) { ir = Pop16(); return 14; }
        if (subOp == 0xE5) { Push16(ir); return 15; }
        if (subOp == 0xE3) { ushort v = Read16(Sp); Write16(Sp, ir); ir = v; return 23; }
        if (subOp == 0xE9) { Pc = ir; return 8; }
        if (subOp == 0xF9) { Sp = ir; return 10; }

        // INC (IR+d), DEC (IR+d)
        if (subOp == 0x34)
        {
            sbyte d = (sbyte)Fetch8();
            ushort ea = (ushort)(ir + d);
            byte v = (byte)(Read8(ea) + 1);
            Write8(ea, v);
            F = (byte)((F & FlagC) | (v == 0 ? FlagZ : 0) | ((v & 0x80) != 0 ? FlagS : 0) | (v == 0x80 ? FlagPv : 0) | ((v & 0x0F) == 0 ? FlagH : 0));
            return 23;
        }
        if (subOp == 0x35)
        {
            sbyte d = (sbyte)Fetch8();
            ushort ea = (ushort)(ir + d);
            byte v = (byte)(Read8(ea) - 1);
            Write8(ea, v);
            F = (byte)((F & FlagC) | FlagN | (v == 0 ? FlagZ : 0) | ((v & 0x80) != 0 ? FlagS : 0) | (v == 0x7F ? FlagPv : 0) | ((v & 0x0F) == 0x0F ? FlagH : 0));
            return 23;
        }
        if (subOp == 0x36)
        {
            sbyte d = (sbyte)Fetch8();
            byte n = Fetch8();
            Write8((ushort)(ir + d), n);
            return 19;
        }

        // LD r, (IR+d) and LD (IR+d), r
        if (subOp >= 0x40 && subOp <= 0x7F && subOp != 0x76)
        {
            int dst = (subOp >> 3) & 7;
            int src = subOp & 7;
            if (src == 6)
            {
                sbyte d = (sbyte)Fetch8();
                SetReg8(dst, Read8((ushort)(ir + d)));
                return 19;
            }
            if (dst == 6)
            {
                sbyte d = (sbyte)Fetch8();
                Write8((ushort)(ir + d), GetReg8(src));
                return 19;
            }
            SetReg8(dst, GetReg8(src));
            return 7;
        }

        // ALU A, (IR+d)
        if (subOp >= 0x80 && subOp <= 0xBF)
        {
            int src = subOp & 7;
            if (src == 6)
            {
                sbyte d = (sbyte)Fetch8();
                Alu8((subOp >> 3) & 7, Read8((ushort)(ir + d)));
                return 19;
            }
            Alu8((subOp >> 3) & 7, GetReg8(src));
            return 4;
        }

        // 0xDD 0xCB d opcode: bit operations on (IR+d)
        if (subOp == 0xCB)
        {
            sbyte d = (sbyte)Fetch8();
            byte b1 = Fetch8();
            ushort ea = (ushort)(ir + d);
            byte v = Read8(ea);
            int bit = (b1 >> 3) & 7;
            int top = b1 >> 6;
            if (top == 0)
            {
                int c;
                switch (bit)
                {
                    case 0: c = (v >> 7) & 1; v = (byte)((v << 1) | c); break;
                    case 1: c = v & 1; v = (byte)((v >> 1) | (c << 7)); break;
                    case 2: { int oc = (F & FlagC) != 0 ? 1 : 0; c = (v >> 7) & 1; v = (byte)((v << 1) | oc); break; }
                    case 3: { int oc = (F & FlagC) != 0 ? 0x80 : 0; c = v & 1; v = (byte)((v >> 1) | oc); break; }
                    case 4: c = (v >> 7) & 1; v = (byte)(v << 1); break;
                    case 5: c = v & 1; v = (byte)((v >> 1) | (v & 0x80)); break;
                    case 6: c = (v >> 7) & 1; v = (byte)((v << 1) | 1); break;
                    default: c = v & 1; v = (byte)(v >> 1); break;
                }
                Write8(ea, v);
                F = (byte)(Szp(v) | c);
                return 23;
            }
            if (top == 1)
            {
                F = (byte)((F & FlagC) | FlagH | ((v & (1 << bit)) == 0 ? FlagZ : 0));
                return 20;
            }
            if (top == 2)
            {
                Write8(ea, (byte)(v & ~(1 << bit)));
                return 23;
            }
            if (top == 3)
            {
                Write8(ea, (byte)(v | (1 << bit)));
                return 23;
            }
        }

        Pc--;
        return 4;
    }
}
