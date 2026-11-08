namespace Commodore128.Emulator;

/// <summary>
/// MOS 8502 CPU Core Implementation for .NET 8 x64 (`Commodore128`).
/// </summary>
public sealed class Cpu8502
{
    public const byte FlagC = 0x01, FlagZ = 0x02, FlagI = 0x04, FlagD = 0x08;
    public const byte FlagB = 0x10, FlagU = 0x20, FlagV = 0x40, FlagN = 0x80;

    private readonly MemoryBus _bus;
    public byte A, X, Y, Sp = 0xFD, P = FlagI | FlagU;
    public ushort Pc;
    public ushort PC { get => Pc; set => Pc = value; }
    public bool ResetPending = true;
    public bool NmiPending = false;
    public long InstructionsExecuted;

    public Cpu8502(MemoryBus bus) => _bus = bus;

    private byte Read8(int addr) => _bus.Read8(addr & 0xFFFF, false);
    private ushort Read16(int addr) => (ushort)(Read8(addr) | (Read8((addr + 1) & 0xFFFF) << 8));
    private void Write8(int addr, byte val) => _bus.Write8(addr & 0xFFFF, val, false);

    private void Push8(byte v) { Write8(0x0100 | Sp, v); Sp--; }
    private byte Pop8() { Sp++; return Read8(0x0100 | Sp); }
    private void Push16(ushort v) { Push8((byte)(v >> 8)); Push8((byte)v); }
    private ushort Pop16() { byte lo = Pop8(); byte hi = Pop8(); return (ushort)((hi << 8) | lo); }

    private byte SetNz(byte v)
    {
        if (v == 0) P |= FlagZ; else P &= unchecked((byte)~FlagZ);
        if ((v & 0x80) != 0) P |= FlagN; else P &= unchecked((byte)~FlagN);
        return v;
    }

    private int Imm() => Pc++;
    private int Zp() => Read8(Pc++);
    private int Zpx() => (Read8(Pc++) + X) & 0xFF;
    private int Zpy() => (Read8(Pc++) + Y) & 0xFF;
    private int Abs() { ushort a = Read16(Pc); Pc += 2; return a; }
    private int Abx() { ushort a = Read16(Pc); Pc += 2; return (a + X) & 0xFFFF; }
    private int Aby() { ushort a = Read16(Pc); Pc += 2; return (a + Y) & 0xFFFF; }
    private int Izx() { int zp = (Read8(Pc++) + X) & 0xFF; return Read8(zp) | (Read8((zp + 1) & 0xFF) << 8); }
    private int Izy() { int zp = Read8(Pc++); return ((Read8(zp) | (Read8((zp + 1) & 0xFF) << 8)) + Y) & 0xFFFF; }

    private void Adc(byte val)
    {
        int cin = (P & FlagC) != 0 ? 1 : 0;
        if ((P & FlagD) != 0)
        {
            int al = (A & 0x0F) + (val & 0x0F) + cin;
            if (al > 9) al += 6;
            int ah = (A >> 4) + (val >> 4) + (al > 15 ? 1 : 0);
            if (((A + val + cin) & 0xFF) == 0) P |= FlagZ; else P &= unchecked((byte)~FlagZ);
            byte r = (byte)((ah << 4) | (al & 0x0F));
            if ((r & 0x80) != 0) P |= FlagN; else P &= unchecked((byte)~FlagN);
            if (((~(A ^ val) & (A ^ r)) & 0x80) != 0) P |= FlagV; else P &= unchecked((byte)~FlagV);
            if (ah > 9) ah += 6;
            if (ah > 15) P |= FlagC; else P &= unchecked((byte)~FlagC);
            A = (byte)((ah << 4) | (al & 0x0F));
        }
        else
        {
            int s = A + val + cin;
            if (s > 0xFF) P |= FlagC; else P &= unchecked((byte)~FlagC);
            byte r = (byte)s;
            if (((~(A ^ val) & (A ^ r)) & 0x80) != 0) P |= FlagV; else P &= unchecked((byte)~FlagV);
            A = SetNz(r);
        }
    }

    private void Sbc(byte val)
    {
        int borrow = (P & FlagC) != 0 ? 0 : 1;
        int sBin = A - val - borrow;
        byte rBin = (byte)sBin;
        if ((P & FlagD) != 0)
        {
            int al = (A & 0x0F) - (val & 0x0F) - borrow;
            if (al < 0) al = ((al - 6) & 0x0F) - 0x10;
            int ah = (A >> 4) - (val >> 4) + (al >> 4);
            if (ah < 0) ah = (ah - 6) & 0x0F;
            if (sBin >= 0) P |= FlagC; else P &= unchecked((byte)~FlagC);
            if ((((A ^ val) & (A ^ rBin)) & 0x80) != 0) P |= FlagV; else P &= unchecked((byte)~FlagV);
            SetNz(rBin);
            A = (byte)((ah << 4) | (al & 0x0F));
        }
        else
        {
            if (sBin >= 0) P |= FlagC; else P &= unchecked((byte)~FlagC);
            if ((((A ^ val) & (A ^ rBin)) & 0x80) != 0) P |= FlagV; else P &= unchecked((byte)~FlagV);
            A = SetNz(rBin);
        }
    }

    private void Cmp(byte reg, byte mem)
    {
        int d = reg - mem;
        if (d >= 0) P |= FlagC; else P &= unchecked((byte)~FlagC);
        SetNz((byte)d);
    }

    private int Branch(bool cond)
    {
        sbyte rel = (sbyte)Read8(Pc++);
        if (!cond) return 2;
        Pc = (ushort)(Pc + rel);
        return 3;
    }

    public void TriggerNmi()
    {
        Console.WriteLine($"[NMI TRIGGERED] at PC=0x{Pc:X4} SP=0x{Sp:X2}");
        Push16(Pc);
        Push8((byte)((P & ~FlagB) | FlagU));
        P |= FlagI;
        Pc = Read16(0xFFFA);
        NmiPending = false;
        _bus.ClearNmiEdge();
    }

    public int Step()
    {
        if (ResetPending)
        {
            Pc = Read16(0xFFFC);
            Sp = 0xFD;
            P = FlagI | FlagU;
            ResetPending = false;
            return 7;
        }
        if (NmiPending || _bus.NmiPending)
        {
            TriggerNmi();
            return 7;
        }
        if (_bus.IrqPending && (P & FlagI) == 0)
        {
            Push16(Pc);
            Push8((byte)((P & ~FlagB) | FlagU));
            P |= FlagI;
            Pc = Read16(0xFFFE);
            return 7;
        }

        byte op = Read8(Pc++);
        InstructionsExecuted++;
        switch (op)
        {
            case 0xA9: A = SetNz(Read8(Imm())); return 2;
            case 0xA5: A = SetNz(Read8(Zp())); return 3;
            case 0xB5: A = SetNz(Read8(Zpx())); return 4;
            case 0xAD: A = SetNz(Read8(Abs())); return 4;
            case 0xBD: A = SetNz(Read8(Abx())); return 4;
            case 0xB9: A = SetNz(Read8(Aby())); return 4;
            case 0xA1: A = SetNz(Read8(Izx())); return 6;
            case 0xB1: A = SetNz(Read8(Izy())); return 5;

            case 0xA2: X = SetNz(Read8(Imm())); return 2;
            case 0xA6: X = SetNz(Read8(Zp())); return 3;
            case 0xB6: X = SetNz(Read8(Zpy())); return 4;
            case 0xAE: X = SetNz(Read8(Abs())); return 4;
            case 0xBE: X = SetNz(Read8(Aby())); return 4;

            case 0xA0: Y = SetNz(Read8(Imm())); return 2;
            case 0xA4: Y = SetNz(Read8(Zp())); return 3;
            case 0xB4: Y = SetNz(Read8(Zpx())); return 4;
            case 0xAC: Y = SetNz(Read8(Abs())); return 4;
            case 0xBC: Y = SetNz(Read8(Abx())); return 4;

            case 0x85: Write8(Zp(), A); return 3;
            case 0x95: Write8(Zpx(), A); return 4;
            case 0x8D: Write8(Abs(), A); return 4;
            case 0x9D: Write8(Abx(), A); return 5;
            case 0x99: Write8(Aby(), A); return 5;
            case 0x81: Write8(Izx(), A); return 6;
            case 0x91: Write8(Izy(), A); return 6;

            case 0x86: Write8(Zp(), X); return 3;
            case 0x96: Write8(Zpy(), X); return 4;
            case 0x8E: Write8(Abs(), X); return 4;

            case 0x84: Write8(Zp(), Y); return 3;
            case 0x94: Write8(Zpx(), Y); return 4;
            case 0x8C: Write8(Abs(), Y); return 4;

            case 0xAA: X = SetNz(A); return 2;
            case 0xA8: Y = SetNz(A); return 2;
            case 0x8A: A = SetNz(X); return 2;
            case 0x98: A = SetNz(Y); return 2;
            case 0xBA: X = SetNz(Sp); return 2;
            case 0x9A: Sp = X; return 2;

            case 0x48: Push8(A); return 3;
            case 0x68: A = SetNz(Pop8()); return 4;
            case 0x08: Push8((byte)(P | FlagB | FlagU)); return 3;
            case 0x28: P = (byte)((Pop8() & ~FlagB) | FlagU); return 4;

            case 0x09: A = SetNz((byte)(A | Read8(Imm()))); return 2;
            case 0x05: A = SetNz((byte)(A | Read8(Zp()))); return 3;
            case 0x15: A = SetNz((byte)(A | Read8(Zpx()))); return 4;
            case 0x0D: A = SetNz((byte)(A | Read8(Abs()))); return 4;
            case 0x1D: A = SetNz((byte)(A | Read8(Abx()))); return 4;
            case 0x19: A = SetNz((byte)(A | Read8(Aby()))); return 4;
            case 0x01: A = SetNz((byte)(A | Read8(Izx()))); return 6;
            case 0x11: A = SetNz((byte)(A | Read8(Izy()))); return 5;

            case 0x29: A = SetNz((byte)(A & Read8(Imm()))); return 2;
            case 0x25: A = SetNz((byte)(A & Read8(Zp()))); return 3;
            case 0x35: A = SetNz((byte)(A & Read8(Zpx()))); return 4;
            case 0x2D: A = SetNz((byte)(A & Read8(Abs()))); return 4;
            case 0x3D: A = SetNz((byte)(A & Read8(Abx()))); return 4;
            case 0x39: A = SetNz((byte)(A & Read8(Aby()))); return 4;
            case 0x21: A = SetNz((byte)(A & Read8(Izx()))); return 6;
            case 0x31: A = SetNz((byte)(A & Read8(Izy()))); return 5;

            case 0x49: A = SetNz((byte)(A ^ Read8(Imm()))); return 2;
            case 0x45: A = SetNz((byte)(A ^ Read8(Zp()))); return 3;
            case 0x55: A = SetNz((byte)(A ^ Read8(Zpx()))); return 4;
            case 0x4D: A = SetNz((byte)(A ^ Read8(Abs()))); return 4;
            case 0x5D: A = SetNz((byte)(A ^ Read8(Abx()))); return 4;
            case 0x59: A = SetNz((byte)(A ^ Read8(Aby()))); return 4;
            case 0x41: A = SetNz((byte)(A ^ Read8(Izx()))); return 6;
            case 0x51: A = SetNz((byte)(A ^ Read8(Izy()))); return 5;

            case 0x24:
            case 0x2C:
            {
                byte v = Read8(op == 0x24 ? Zp() : Abs());
                if ((A & v) == 0) P |= FlagZ; else P &= unchecked((byte)~FlagZ);
                P = (byte)((P & ~(FlagN | FlagV)) | (v & (FlagN | FlagV)));
                return op == 0x24 ? 3 : 4;
            }

            case 0x69: Adc(Read8(Imm())); return 2;
            case 0x65: Adc(Read8(Zp())); return 3;
            case 0x75: Adc(Read8(Zpx())); return 4;
            case 0x6D: Adc(Read8(Abs())); return 4;
            case 0x7D: Adc(Read8(Abx())); return 4;
            case 0x79: Adc(Read8(Aby())); return 4;
            case 0x61: Adc(Read8(Izx())); return 6;
            case 0x71: Adc(Read8(Izy())); return 5;

            case 0xE9: Sbc(Read8(Imm())); return 2;
            case 0xE5: Sbc(Read8(Zp())); return 3;
            case 0xF5: Sbc(Read8(Zpx())); return 4;
            case 0xED: Sbc(Read8(Abs())); return 4;
            case 0xFD: Sbc(Read8(Abx())); return 4;
            case 0xF9: Sbc(Read8(Aby())); return 4;
            case 0xE1: Sbc(Read8(Izx())); return 6;
            case 0xF1: Sbc(Read8(Izy())); return 5;

            case 0xC9: Cmp(A, Read8(Imm())); return 2;
            case 0xC5: Cmp(A, Read8(Zp())); return 3;
            case 0xD5: Cmp(A, Read8(Zpx())); return 4;
            case 0xCD: Cmp(A, Read8(Abs())); return 4;
            case 0xDD: Cmp(A, Read8(Abx())); return 4;
            case 0xD9: Cmp(A, Read8(Aby())); return 4;
            case 0xC1: Cmp(A, Read8(Izx())); return 6;
            case 0xD1: Cmp(A, Read8(Izy())); return 5;
            case 0xE0: Cmp(X, Read8(Imm())); return 2;
            case 0xE4: Cmp(X, Read8(Zp())); return 3;
            case 0xEC: Cmp(X, Read8(Abs())); return 4;
            case 0xC0: Cmp(Y, Read8(Imm())); return 2;
            case 0xC4: Cmp(Y, Read8(Zp())); return 3;
            case 0xCC: Cmp(Y, Read8(Abs())); return 4;

            case 0xE8: X = SetNz((byte)(X + 1)); return 2;
            case 0xCA: X = SetNz((byte)(X - 1)); return 2;
            case 0xC8: Y = SetNz((byte)(Y + 1)); return 2;
            case 0x88: Y = SetNz((byte)(Y - 1)); return 2;

            case 0xE6: case 0xF6: case 0xEE: case 0xFE:
            {
                int a = op == 0xE6 ? Zp() : op == 0xF6 ? Zpx() : op == 0xEE ? Abs() : Abx();
                Write8(a, SetNz((byte)(Read8(a) + 1)));
                return op == 0xE6 ? 5 : 6;
            }
            case 0xC6: case 0xD6: case 0xCE: case 0xDE:
            {
                int a = op == 0xC6 ? Zp() : op == 0xD6 ? Zpx() : op == 0xCE ? Abs() : Abx();
                Write8(a, SetNz((byte)(Read8(a) - 1)));
                return op == 0xC6 ? 5 : 6;
            }

            case 0x0A:
                if ((A & 0x80) != 0) P |= FlagC; else P &= unchecked((byte)~FlagC);
                A = SetNz((byte)(A << 1)); return 2;
            case 0x06: case 0x16: case 0x0E: case 0x1E:
            {
                int a = op == 0x06 ? Zp() : op == 0x16 ? Zpx() : op == 0x0E ? Abs() : Abx();
                byte v = Read8(a);
                if ((v & 0x80) != 0) P |= FlagC; else P &= unchecked((byte)~FlagC);
                Write8(a, SetNz((byte)(v << 1))); return 6;
            }
            case 0x4A:
                if ((A & 0x01) != 0) P |= FlagC; else P &= unchecked((byte)~FlagC);
                A = SetNz((byte)(A >> 1)); return 2;
            case 0x46: case 0x56: case 0x4E: case 0x5E:
            {
                int a = op == 0x46 ? Zp() : op == 0x56 ? Zpx() : op == 0x4E ? Abs() : Abx();
                byte v = Read8(a);
                if ((v & 0x01) != 0) P |= FlagC; else P &= unchecked((byte)~FlagC);
                Write8(a, SetNz((byte)(v >> 1))); return 6;
            }
            case 0x2A:
            {
                int c = (P & FlagC) != 0 ? 1 : 0;
                if ((A & 0x80) != 0) P |= FlagC; else P &= unchecked((byte)~FlagC);
                A = SetNz((byte)((A << 1) | c)); return 2;
            }
            case 0x26: case 0x36: case 0x2E: case 0x3E:
            {
                int a = op == 0x26 ? Zp() : op == 0x36 ? Zpx() : op == 0x2E ? Abs() : Abx();
                byte v = Read8(a); int c = (P & FlagC) != 0 ? 1 : 0;
                if ((v & 0x80) != 0) P |= FlagC; else P &= unchecked((byte)~FlagC);
                Write8(a, SetNz((byte)((v << 1) | c))); return 6;
            }
            case 0x6A:
            {
                int c = (P & FlagC) != 0 ? 0x80 : 0;
                if ((A & 0x01) != 0) P |= FlagC; else P &= unchecked((byte)~FlagC);
                A = SetNz((byte)((A >> 1) | c)); return 2;
            }
            case 0x66: case 0x76: case 0x6E: case 0x7E:
            {
                int a = op == 0x66 ? Zp() : op == 0x76 ? Zpx() : op == 0x6E ? Abs() : Abx();
                byte v = Read8(a); int c = (P & FlagC) != 0 ? 0x80 : 0;
                if ((v & 0x01) != 0) P |= FlagC; else P &= unchecked((byte)~FlagC);
                Write8(a, SetNz((byte)((v >> 1) | c))); return 6;
            }

            case 0x10: return Branch((P & FlagN) == 0);
            case 0x30: return Branch((P & FlagN) != 0);
            case 0x50: return Branch((P & FlagV) == 0);
            case 0x70: return Branch((P & FlagV) != 0);
            case 0x90: return Branch((P & FlagC) == 0);
            case 0xB0: return Branch((P & FlagC) != 0);
            case 0xD0: return Branch((P & FlagZ) == 0);
            case 0xF0: return Branch((P & FlagZ) != 0);

            case 0x4C: Pc = Read16(Pc); return 3;
            case 0x6C:
            {
                ushort ptr = Read16(Pc);
                byte lo = Read8(ptr);
                byte hi = Read8((ptr & 0xFF00) | ((ptr + 1) & 0x00FF));
                Pc = (ushort)((hi << 8) | lo);
                return 5;
            }
            case 0x20:
            {
                ushort target = Read16(Pc);
                Push16((ushort)(Pc + 1));
                Pc = target;
                return 6;
            }
            case 0x60: Pc = (ushort)(Pop16() + 1); return 6;
            case 0x40: P = (byte)((Pop8() & ~FlagB) | FlagU); Pc = Pop16(); return 6;
            case 0x00:
                Pc++;
                Push16(Pc);
                Push8((byte)(P | FlagB | FlagU));
                P |= FlagI;
                Pc = Read16(0xFFFE);
                return 7;

            case 0x18: P &= unchecked((byte)~FlagC); return 2;
            case 0x38: P |= FlagC; return 2;
            case 0x58: P &= unchecked((byte)~FlagI); return 2;
            case 0x78: P |= FlagI; return 2;
            case 0xB8: P &= unchecked((byte)~FlagV); return 2;
            case 0xD8: P &= unchecked((byte)~FlagD); return 2;
            case 0xF8: P |= FlagD; return 2;
            default: return 2;
        }
    }
}
