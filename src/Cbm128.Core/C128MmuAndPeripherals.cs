using System;
using System.IO;
using System.Text;

namespace Cbm128.Core;

/// <summary>
/// MOS 8722 Memory Management Unit (MMU), 128 KB RAM (Banks 0 and 1), 60 KB ROMs,
/// VIC-IIe ($D000-$D030), 8563 VDC ($D600-$D601), SID ($D400-$D41F), and Dual 6526 CIAs ($DC00/$DD00).
/// </summary>
public sealed class C128MmuAndPeripherals
{
    public readonly byte[] RomBasicLo;
    public readonly byte[] RomBasicHi;
    public readonly byte[] RomKernal;
    public readonly byte[] RomChar;
    public readonly byte[] RomZ80Bios = new byte[4096];

    public readonly byte[][] Ram = [new byte[65536], new byte[65536]];
    public readonly byte[][] ColorRam = [new byte[1024], new byte[1024]];
    public readonly byte[] VdcVram = new byte[65536];
    public readonly byte[] VdcRegs = new byte[38];
    public readonly byte[] VicRegs = new byte[64];
    public readonly byte[] SidRegs = new byte[32];

    public byte CpuPortDdr = 0x2F;
    public byte CpuPortData = 0xE3;

    // MMU Registers ($D500-$D50B)
    public byte Cr = 0x00;
    public readonly byte[] Pcr = new byte[4];
    public byte Mcr = 0xB0; // Bit 0 = 0 (Z80 active on reset), /GAME=1, /EXROM=1, 40-col
    public byte Rcr = 0x00;
    public byte P0L = 0x00, P0H = 0x00, P1L = 0x01, P1H = 0x00;
    public byte Vr = 0x20;

    // Video & CIA state
    public int RasterY = 0;
    public int TargetRaster = 251;
    private int _rasterCycleAccum = 0;
    public byte VicIrqLatch = 0x00;
    public byte VicIrqEnable = 0x00;
    public byte VdcRegIndex = 0;

    public byte Cia1Pra = 0xFF, Cia1Prb = 0xFF, Cia1Ddra = 0xFF, Cia1Ddrb = 0x00;
    public int Cia1Ta = 0xFFFF, Cia1TaLatch = 0xFFFF, Cia1Tb = 0xFFFF, Cia1TbLatch = 0xFFFF;
    public byte Cia1IcrData = 0x00, Cia1IcrMask = 0x00, Cia1Cra = 0x00, Cia1Crb = 0x00;
    public int Cia1SdrShiftsLeft = 0;

    public byte Cia2Pra = 0x07, Cia2Prb = 0xFF, Cia2Ddra = 0x3F, Cia2Ddrb = 0x00;
    public byte Cia2IcrData = 0x00, Cia2IcrMask = 0x00, Cia2Cra = 0x00, Cia2Crb = 0x00;

    public readonly byte[] KeyMatrix = [0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF];

    public bool IsZ80Active => (Mcr & 0x01) == 0;
    public bool IsC64Mode => (Mcr & 0x40) != 0;
    public bool IrqPending => ((VicIrqLatch & 0x80) != 0) || ((Cia1IcrData & 0x80) != 0);
    public bool NmiPending => (Cia2IcrData & 0x80) != 0;
    public void ClearNmiEdge() => Cia2IcrData &= 0x7F;

    public C128MmuAndPeripherals(string romDirectory)
    {
        RomBasicLo = File.ReadAllBytes(Path.Combine(romDirectory, "basic-4000.318018-02.bin"));
        RomBasicHi = File.ReadAllBytes(Path.Combine(romDirectory, "basic-8000.318019-02.bin"));
        RomKernal  = File.ReadAllBytes(Path.Combine(romDirectory, "kernal.318020-03.bin"));
        RomChar    = File.ReadAllBytes(Path.Combine(romDirectory, "characters.390059-01.bin"));
        Array.Copy(RomKernal, 0x1000, RomZ80Bios, 0, 4096);
        VicRegs[0x2F] = 0xFF;
        VicRegs[0x30] = 0xFC;
    }

    private bool IsCommonRam(int addr)
    {
        if (addr >= 0xFFD0 && addr <= 0xFFEF) return true;
        int commonMode = (Rcr >> 2) & 0x03;
        if (commonMode == 0) return false;
        int sizeCode = Rcr & 0x03;
        int blockSize = sizeCode switch { 0 => 0x0400, 1 => 0x1000, 2 => 0x2000, _ => 0x4000 };
        if ((commonMode & 0x01) != 0 && addr < blockSize) return true;
        if ((commonMode & 0x02) != 0 && addr >= (0x10000 - blockSize)) return true;
        return false;
    }

    private (int bank, int physAddr) ResolveRam(int addr)
    {
        int bank = (Cr >> 6) & 0x01;
        int page = (addr >> 8) & 0xFF;
        int offset = addr & 0xFF;
        if (page == 0x00)
            return (IsCommonRam(addr) ? 0 : (P0H & 1), (P0L << 8) | offset);
        if (page == 0x01)
            return (IsCommonRam(addr) ? 0 : (P1H & 1), (P1L << 8) | offset);
        if (IsCommonRam(addr)) bank = 0;
        return (bank, addr);
    }

    public byte Read8(int addr, bool z80Mode = false)
    {
        addr &= 0xFFFF;
        if (!z80Mode && addr == 0x0000) return CpuPortDdr;
        if (!z80Mode && addr == 0x0001) return (byte)((CpuPortData & CpuPortDdr) | (~CpuPortDdr & 0x77));

        if (addr >= 0xFF00 && addr <= 0xFF04)
            return addr == 0xFF00 ? Cr : Pcr[addr - 0xFF01];

        if (z80Mode && addr < 0x1000 && ((Cr >> 6) & 0x01) == 0)
            return RomZ80Bios[addr];

        if (addr >= 0x4000 && addr <= 0x7FFF && (Cr & 0x02) == 0)
            return RomBasicLo[addr - 0x4000];

        if (addr >= 0x8000 && addr <= 0xBFFF)
        {
            int mid = (Cr >> 2) & 0x03;
            if (mid == 0) return RomBasicHi[addr - 0x8000];
            if (mid == 1 || mid == 2) return 0xFF;
        }
        else if (addr >= 0xC000 && addr <= 0xCFFF)
        {
            int hi = (Cr >> 4) & 0x03;
            if (hi == 0) return RomKernal[addr - 0xC000];
            if (hi == 1 || hi == 2) return 0xFF;
        }
        else if (addr >= 0xD000 && addr <= 0xDFFF)
        {
            if (!z80Mode && (Cr & 0x01) == 0) return ReadIo(addr);
            int hi = (Cr >> 4) & 0x03;
            if (hi == 0 && (((CpuPortData & 0x04) == 0) || ((Cr & 0x01) != 0)))
                return RomChar[(IsC64Mode ? 0x0000 : 0x1000) + (addr - 0xD000)];
        }
        else if (addr >= 0xE000 && addr <= 0xFFFF)
        {
            int hi = (Cr >> 4) & 0x03;
            if (hi == 0) return RomKernal[addr - 0xC000];
            if (hi == 1 || hi == 2) return 0xFF;
        }

        var (b, pa) = ResolveRam(addr);
        return Ram[b][pa];
    }

    public void Write8(int addr, byte val, bool z80Mode = false)
    {
        addr &= 0xFFFF;
        if (!z80Mode && addr == 0x0000) { CpuPortDdr = val; Ram[0][0] = val; return; }
        if (!z80Mode && addr == 0x0001) { CpuPortData = val; Ram[0][1] = val; return; }
        if (addr == 0xFF00) { Cr = val; return; }
        if (addr >= 0xFF01 && addr <= 0xFF04) { Cr = Pcr[addr - 0xFF01]; return; }
        if (!z80Mode && addr >= 0xD000 && addr <= 0xDFFF && (Cr & 0x01) == 0) { WriteIo(addr, val); return; }

        var (b, pa) = ResolveRam(addr);
        Ram[b][pa] = val;
    }

    public byte ReadIo(int addr)
    {
        addr &= 0xFFFF;
        if (addr >= 0xD500 && addr <= 0xD50B)
        {
            int r = addr - 0xD500;
            return r switch
            {
                0 => Cr,
                >= 1 and <= 4 => Pcr[r - 1],
                5 => (byte)((Mcr & 0xCF) | 0x30),
                6 => Rcr,
                7 => P0L,
                8 => (byte)(P0H | 0xF0),
                9 => P1L,
                10 => (byte)(P1H | 0xF0),
                11 => Vr,
                _ => 0xFF
            };
        }
        if (addr >= 0xD000 && addr <= 0xD3FF)
        {
            int reg = addr & 0x3F;
            return reg switch
            {
                0x11 => (byte)((VicRegs[0x11] & 0x7F) | ((RasterY & 0x100) != 0 ? 0x80 : 0x00)),
                0x12 => (byte)(RasterY & 0xFF),
                0x19 => (byte)(VicIrqLatch | 0x70),
                0x1A => (byte)(VicIrqEnable | 0xF0),
                0x2F => (byte)(VicRegs[0x2F] | 0xF8),
                0x30 => (byte)(VicRegs[0x30] | 0xFC),
                > 0x30 => 0xFF,
                _ => VicRegs[reg]
            };
        }
        if (addr >= 0xD400 && addr <= 0xD4FF)
        {
            int reg = addr & 0x1F;
            if (reg == 0x19 || reg == 0x1A) return 0xFF;
            return SidRegs[reg];
        }
        if (addr >= 0xD600 && addr <= 0xD6FF)
        {
            if ((addr & 1) == 0) return (byte)(0x81 | (RasterY >= 250 ? 0x20 : 0x00));
            int r = VdcRegIndex & 0x3F;
            if (r == 31)
            {
                int va = ((VdcRegs[18] << 8) | VdcRegs[19]) & 0xFFFF;
                byte v = VdcVram[va];
                va = (va + 1) & 0xFFFF;
                VdcRegs[18] = (byte)(va >> 8);
                VdcRegs[19] = (byte)va;
                return v;
            }
            return r < VdcRegs.Length ? VdcRegs[r] : (byte)0xFF;
        }
        if (addr >= 0xD800 && addr <= 0xDBFF)
            return (byte)(ColorRam[CpuPortData & 1][addr - 0xD800] | 0xF0);
        if (addr >= 0xDC00 && addr <= 0xDCFF)
        {
            int r = addr & 0x0F;
            if (r == 0) return Cia1Pra;
            if (r == 1) return ScanKeyboardColumns();
            if (r == 0x0D) { byte v = Cia1IcrData; Cia1IcrData = 0; return v; }
            if (r == 0x0E) return Cia1Cra;
            if (r == 0x0F) return Cia1Crb;
            return 0xFF;
        }
        if (addr >= 0xDD00 && addr <= 0xDDFF)
        {
            int r = addr & 0x0F;
            if (r == 0) return (byte)((Cia2Pra & 0x3F) | 0xC0);
            if (r == 0x0D) { byte v = Cia2IcrData; Cia2IcrData = 0; return v; }
            return 0xFF;
        }
        return 0xFF;
    }

    public void WriteIo(int addr, byte val)
    {
        addr &= 0xFFFF;
        if (addr >= 0xD500 && addr <= 0xD50B)
        {
            int r = addr - 0xD500;
            if (r == 0) Cr = val;
            else if (r >= 1 && r <= 4) Pcr[r - 1] = val;
            else if (r == 5) Mcr = (byte)((val & 0x4F) | 0x30 | (Mcr & 0x80));
            else if (r == 6) Rcr = val;
            else if (r == 7) P0L = val;
            else if (r == 8) P0H = (byte)(val & 1);
            else if (r == 9) P1L = val;
            else if (r == 10) P1H = (byte)(val & 1);
            return;
        }
        if (addr >= 0xD000 && addr <= 0xD3FF)
        {
            int r = addr & 0x3F;
            if (r == 0x11) { VicRegs[0x11] = val; TargetRaster = (TargetRaster & 0xFF) | ((val & 0x80) << 1); }
            else if (r == 0x12) { VicRegs[0x12] = val; TargetRaster = (TargetRaster & 0x100) | val; }
            else if (r == 0x19)
            {
                VicIrqLatch &= (byte)~(val & 0x0F);
                if ((VicIrqLatch & VicIrqEnable & 0x0F) == 0) VicIrqLatch &= 0x7F;
            }
            else if (r == 0x1A)
            {
                VicIrqEnable = (byte)(val & 0x0F);
                if ((VicIrqLatch & VicIrqEnable & 0x0F) != 0) VicIrqLatch |= 0x80;
                else VicIrqLatch &= 0x7F;
            }
            else VicRegs[r] = val;
            return;
        }
        if (addr >= 0xD400 && addr <= 0xD4FF)
        {
            SidRegs[addr & 0x1F] = val;
            return;
        }
        if (addr >= 0xD600 && addr <= 0xD6FF)
        {
            if ((addr & 1) == 0) VdcRegIndex = (byte)(val & 0x3F);
            else
            {
                int r = VdcRegIndex & 0x3F;
                if (r < VdcRegs.Length) VdcRegs[r] = val;
                if (r == 31)
                {
                    int va = ((VdcRegs[18] << 8) | VdcRegs[19]) & 0xFFFF;
                    VdcVram[va] = val;
                    va = (va + 1) & 0xFFFF;
                    VdcRegs[18] = (byte)(va >> 8);
                    VdcRegs[19] = (byte)va;
                }
                else if (r == 30) ExecuteVdcBlockOp();
            }
            return;
        }
        if (addr >= 0xD800 && addr <= 0xDBFF)
        {
            ColorRam[CpuPortData & 1][addr - 0xD800] = (byte)(val & 0x0F);
            return;
        }
        if (addr >= 0xDC00 && addr <= 0xDCFF)
        {
            int r = addr & 0x0F;
            if (r == 0) Cia1Pra = val;
            else if (r == 2) Cia1Ddra = val;
            else if (r == 4) Cia1TaLatch = (Cia1TaLatch & 0xFF00) | val;
            else if (r == 5) { Cia1TaLatch = (Cia1TaLatch & 0x00FF) | (val << 8); if ((Cia1Cra & 1) == 0) Cia1Ta = Cia1TaLatch; }
            else if (r == 0x0C) Cia1SdrShiftsLeft = 16;
            else if (r == 0x0D)
            {
                if ((val & 0x80) != 0) Cia1IcrMask |= (byte)(val & 0x1F);
                else Cia1IcrMask &= (byte)~(val & 0x1F);
            }
            else if (r == 0x0E) { Cia1Cra = val; if ((val & 0x10) != 0) Cia1Ta = Cia1TaLatch; }
            else if (r == 0x0F) Cia1Crb = val;
        }
    }

    private byte ScanKeyboardColumns()
    {
        byte res = 0xFF;
        byte pra = (byte)(Cia1Pra | ~Cia1Ddra);
        byte ext = (byte)(VicRegs[0x2F] | 0xF8);
        for (int row = 0; row < 8; row++)
            if ((pra & (1 << row)) == 0) res &= KeyMatrix[row];
        for (int er = 0; er < 3; er++)
            if ((ext & (1 << er)) == 0) res &= KeyMatrix[8 + er];
        return res;
    }

    private void ExecuteVdcBlockOp()
    {
        int count = VdcRegs[30] == 0 ? 256 : VdcRegs[30];
        int dest = ((VdcRegs[18] << 8) | VdcRegs[19]) & 0xFFFF;
        if ((VdcRegs[24] & 0x80) != 0)
        {
            int src = ((VdcRegs[32] << 8) | VdcRegs[33]) & 0xFFFF;
            for (int i = 0; i < count; i++)
            {
                VdcVram[dest] = VdcVram[src];
                dest = (dest + 1) & 0xFFFF;
                src = (src + 1) & 0xFFFF;
            }
            VdcRegs[32] = (byte)(src >> 8);
            VdcRegs[33] = (byte)src;
        }
        else
        {
            byte fill = VdcRegs[31];
            for (int i = 0; i < count; i++)
            {
                VdcVram[dest] = fill;
                dest = (dest + 1) & 0xFFFF;
            }
        }
        VdcRegs[18] = (byte)(dest >> 8);
        VdcRegs[19] = (byte)dest;
    }

    public void StepCycles(int cycles)
    {
        _rasterCycleAccum += cycles;
        while (_rasterCycleAccum >= 63)
        {
            _rasterCycleAccum -= 63;
            RasterY = (RasterY + 1) % 312;
            if ((VicIrqEnable & 0x01) != 0 && RasterY == TargetRaster)
                VicIrqLatch |= 0x81;
        }
        if ((Cia1Cra & 0x01) != 0)
        {
            Cia1Ta -= cycles;
            while (Cia1Ta <= 0)
            {
                Cia1IcrData |= 0x01;
                if ((Cia1IcrMask & 0x01) != 0) Cia1IcrData |= 0x80;
                if ((Cia1Cra & 0x40) != 0 && Cia1SdrShiftsLeft > 0)
                {
                    Cia1SdrShiftsLeft--;
                    if (Cia1SdrShiftsLeft == 0)
                    {
                        Cia1IcrData |= 0x08;
                        if ((Cia1IcrMask & 0x08) != 0) Cia1IcrData |= 0x80;
                    }
                }
                if ((Cia1Cra & 0x08) != 0) { Cia1Cra &= 0xFE; Cia1Ta = Math.Max(1, Cia1TaLatch); break; }
                Cia1Ta += Math.Max(1, Cia1TaLatch);
            }
        }
    }

    public string Render40ColScreenAscii()
    {
        var sb = new StringBuilder();
        for (int r = 0; r < 25; r++)
        {
            var line = new char[40];
            for (int c = 0; c < 40; c++)
            {
                int sc = Ram[0][0x0400 + r * 40 + c] & 0x7F;
                line[c] = sc switch
                {
                    0 => '@',
                    >= 1 and <= 26 => (char)('A' + sc - 1),
                    27 => '[',
                    28 => '\\',
                    29 => ']',
                    30 => '^',
                    31 => '_',
                    >= 32 and <= 63 => (char)sc,
                    _ => ' '
                };
            }
            string s = new string(line).TrimEnd();
            if (s.Length > 0) sb.AppendLine(s);
        }
        return sb.ToString();
    }
}
