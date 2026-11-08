using System;
using System.IO;
using System.Text;

namespace Commodore128.Emulator;

/// <summary>
/// MOS 8722 Memory Management Unit (MMU), 128 KB RAM (Banks 0 and 1), 60 KB ROMs,
/// VIC-IIe ($D000-$D030), 8563 VDC ($D600-$D601), SID ($D400-$D41F), and Dual 6526 CIAs ($DC00/$DD00).
/// </summary>
public sealed class MemoryBus
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
    public Disk.DiskDrive1571? Drive8 { get; set; }
    public Disk.DiskDrive1571? Drive9 { get; set; }
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

    // CIA1 Time-of-Day (TOD) clock
    public int TodHours = 12;
    public int TodMinutes = 0;
    public int TodSeconds = 0;
    public int TodTenths = 0;
    public bool TodIsPm = false;
    public bool TodStopped = false;
    public bool TodLatched = false;
    public byte LatchedHours = 0x12;
    public byte LatchedMinutes = 0x00;
    public byte LatchedSeconds = 0x00;
    public byte LatchedTenths = 0x00;
    public byte TodAlarmHours = 0x00;
    public byte TodAlarmMinutes = 0x00;
    public byte TodAlarmSeconds = 0x00;
    public byte TodAlarmTenths = 0x00;
    private long _todCycleAccum = 0;

    public void InitTodFromHost()
    {
        var now = DateTime.Now;
        int h = now.Hour;
        TodIsPm = h >= 12;
        int h12 = h % 12;
        if (h12 == 0) h12 = 12;
        TodHours = h12;
        TodMinutes = now.Minute;
        TodSeconds = now.Second;
        TodTenths = now.Millisecond / 100;
        TodStopped = false;
        TodLatched = false;
        _todCycleAccum = 0;
    }

    public Func<ushort>? GetCpuPc;
    public Action<int>? OnRasterLine;
    public Action? OnFrameComplete;
    public byte Cia2Pra = 0x07, Cia2Prb = 0xFF, Cia2Ddra = 0x3F, Cia2Ddrb = 0x00;
    public byte Cia2IcrData = 0x00, Cia2IcrMask = 0x00, Cia2Cra = 0x00, Cia2Crb = 0x00;

    public byte Joystick1 = 0xFF;
    public byte Joystick2 = 0xFF;
    public bool SuppressMmuWrites = false;

    public readonly byte[] KeyMatrix = [0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF];

    public bool IsZ80Active => (Mcr & 0x01) == 0;
    private bool _c64Mode;
    public bool IsC64Mode
    {
        get => _c64Mode || ((Mcr & 0x40) != 0);
        set => _c64Mode = value;
    }
    public bool IrqPending => ((VicIrqLatch & 0x80) != 0) || ((Cia1IcrData & 0x80) != 0);
    public bool NmiPending => (Cia2IcrData & 0x80) != 0;
    public void ClearNmiEdge() => Cia2IcrData &= 0x7F;

    public MemoryBus(string? romDirectory = null)
    {
        RomBasicLo = TryLoadRom(romDirectory, "basic-4000.318018-02.bin", 16384);
        RomBasicHi = TryLoadRom(romDirectory, "basic-8000.318019-02.bin", 16384);
        RomKernal  = TryLoadRom(romDirectory, "kernal.318020-03.bin", 16384);
        RomChar    = TryLoadRom(romDirectory, "characters.390059-01.bin", 8192);
        if (RomKernal.Length >= 0x2000)
            Array.Copy(RomKernal, 0x1000, RomZ80Bios, 0, 4096);
        VicRegs[0x2F] = 0xFF;
        VicRegs[0x30] = 0xFC;
        InitTodFromHost();
    }

    private static byte[] TryLoadRom(string? dir, string filename, int fallbackSize)
    {
        if (!string.IsNullOrWhiteSpace(dir))
        {
            string p = Path.Combine(dir, filename);
            if (File.Exists(p)) return File.ReadAllBytes(p);
        }
        return new byte[fallbackSize];
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
        if (IsC64Mode || SuppressMmuWrites) return (0, addr);
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

        if (!IsC64Mode && !SuppressMmuWrites && addr >= 0xFF00 && addr <= 0xFF04)
            return addr == 0xFF00 ? Cr : Pcr[addr - 0xFF01];

        if (IsC64Mode)
        {
            bool loram = (CpuPortData & 0x01) != 0;
            bool hiram = (CpuPortData & 0x02) != 0;
            bool charen = (CpuPortData & 0x04) != 0;

            if (addr >= 0xD000 && addr <= 0xDFFF)
            {
                if (charen && (loram || hiram))
                    return ReadIo(addr);
                if (!charen && (loram || hiram))
                    return RomChar[addr - 0xD000];
                return Ram[0][addr];
            }
            if (addr >= 0xE000 && addr <= 0xFFFF && hiram)
            {
                if (addr == 0xFF84) return 0x60; // C64 IOINIT RTS
                if (addr == 0xFFD2) return 0x60; // C64 CHROUT RTS
                if (addr >= 0xEA7E && addr <= 0xEA87)
                {
                    // C64 KERNAL IRQ Return & SCNKEY:
                    // $EA7E: JMP $EA81
                    // $EA81: PLA; TAY; PLA; TAX; PLA; RTI
                    // $EA87: RTS (SCNKEY keyboard scan)
                    ReadOnlySpan<byte> rti = [0x4C, 0x81, 0xEA, 0x68, 0xA8, 0x68, 0xAA, 0x68, 0x40, 0x60];
                    return rti[addr - 0xEA7E];
                }
                if (addr >= 0xFF48 && addr <= 0xFF4F)
                {
                    // C64 KERNAL IRQ Entry: PHA; TXA; PHA; TYA; PHA; JMP ($0314)
                    ReadOnlySpan<byte> irq = [0x48, 0x8A, 0x48, 0x98, 0x48, 0x6C, 0x14, 0x03];
                    return irq[addr - 0xFF48];
                }
                if (addr == 0xFFFE) return 0x48; // IRQ vector low -> $FF48
                if (addr == 0xFFFF) return 0xFF; // IRQ vector high -> $FF48
                if (addr == 0xFFFA) return 0x47; // NMI vector low
                if (addr == 0xFFFB) return 0xFE; // NMI vector high
                return RomKernal[addr - 0xC000];
            }
            return Ram[0][addr];
        }

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
        if (!IsC64Mode && !SuppressMmuWrites)
        {
            if (addr == 0xFF00) { Cr = val; return; }
            if (addr >= 0xFF01 && addr <= 0xFF04) { Cr = Pcr[addr - 0xFF01]; return; }
        }
        if (!z80Mode && addr >= 0xD000 && addr <= 0xDFFF && (Cr & 0x01) == 0)
        {
            if (IsC64Mode)
            {
                bool charen = (CpuPortData & 0x04) != 0;
                bool loram = (CpuPortData & 0x01) != 0;
                bool hiram = (CpuPortData & 0x02) != 0;
                if (charen && (loram || hiram))
                {
                    WriteIo(addr, val);
                    return;
                }
            }
            else
            {
                WriteIo(addr, val);
                return;
            }
        }

        var (b, pa) = ResolveRam(addr);
        if (addr == 0x7108) Console.WriteLine($"[TRACE WRITE8 0x7108] val=0x{val:X2} b={b} pa=0x{pa:X4} from PC=0x{GetCpuPc?.Invoke():X4}");
        Ram[b][pa] = val;
    }

    public byte ReadIo(int addr)
    {
        addr &= 0xFFFF;
        if (addr >= 0xD500 && addr <= 0xD50B)
        {
            if (IsC64Mode || SuppressMmuWrites) return SidRegs[addr & 0x1F];
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
            if (r == 0) return (byte)(Cia1Pra & Joystick2);
            if (r == 1) return (byte)(ScanKeyboardColumns() & Joystick1);
            if (r == 4) return (byte)(Cia1Ta & 0xFF);
            if (r == 5) return (byte)((Cia1Ta >> 8) & 0xFF);
            if (r == 6) return (byte)(Cia1Tb & 0xFF);
            if (r == 7) return (byte)((Cia1Tb >> 8) & 0xFF);
            if (r == 8) // TOD 1/10th Seconds
            {
                if ((Cia1Crb & 0x80) != 0) return TodAlarmTenths;
                byte v = TodLatched ? LatchedTenths : (byte)(TodTenths & 0x0F);
                TodLatched = false; // Reading tenths releases the latch
                return v;
            }
            if (r == 9) // TOD Seconds
            {
                if ((Cia1Crb & 0x80) != 0) return TodAlarmSeconds;
                return TodLatched ? LatchedSeconds : (byte)(((TodSeconds / 10) << 4) | (TodSeconds % 10));
            }
            if (r == 10) // TOD Minutes
            {
                if ((Cia1Crb & 0x80) != 0) return TodAlarmMinutes;
                return TodLatched ? LatchedMinutes : (byte)(((TodMinutes / 10) << 4) | (TodMinutes % 10));
            }
            if (r == 11) // TOD Hours
            {
                if ((Cia1Crb & 0x80) != 0) return TodAlarmHours;
                // Reading Hours latches all TOD registers until Tenths is read
                LatchedHours = (byte)(((TodHours / 10) << 4) | (TodHours % 10) | (TodIsPm ? 0x80 : 0x00));
                LatchedMinutes = (byte)(((TodMinutes / 10) << 4) | (TodMinutes % 10));
                LatchedSeconds = (byte)(((TodSeconds / 10) << 4) | (TodSeconds % 10));
                LatchedTenths = (byte)(TodTenths & 0x0F);
                TodLatched = true;
                return LatchedHours;
            }
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
            if (IsC64Mode || SuppressMmuWrites)
            {
                if (r == 5) Mcr = (byte)((val & 0x4F) | 0x30 | (Mcr & 0x80));
                return;
            }
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
            else if (r == 6) Cia1TbLatch = (Cia1TbLatch & 0xFF00) | val;
            else if (r == 7) { Cia1TbLatch = (Cia1TbLatch & 0x00FF) | (val << 8); if ((Cia1Crb & 1) == 0) Cia1Tb = Cia1TbLatch; }
            else if (r == 8) // TOD 1/10th Seconds
            {
                if ((Cia1Crb & 0x80) != 0) TodAlarmTenths = (byte)(val & 0x0F);
                else
                {
                    TodTenths = val & 0x0F;
                    TodStopped = false; // Writing tenths starts/restarts clock ticking
                    _todCycleAccum = 0;
                }
            }
            else if (r == 9) // TOD Seconds
            {
                if ((Cia1Crb & 0x80) != 0) TodAlarmSeconds = (byte)(val & 0x7F);
                else
                {
                    int bcdS = ((val >> 4) & 0x07) * 10 + (val & 0x0F);
                    if (bcdS < 60) TodSeconds = bcdS;
                }
            }
            else if (r == 10) // TOD Minutes
            {
                if ((Cia1Crb & 0x80) != 0) TodAlarmMinutes = (byte)(val & 0x7F);
                else
                {
                    int bcdM = ((val >> 4) & 0x07) * 10 + (val & 0x0F);
                    if (bcdM < 60) TodMinutes = bcdM;
                }
            }
            else if (r == 11) // TOD Hours
            {
                if ((Cia1Crb & 0x80) != 0) TodAlarmHours = val;
                else
                {
                    TodIsPm = (val & 0x80) != 0;
                    int bcdH = ((val >> 4) & 0x01) * 10 + (val & 0x0F);
                    if (bcdH >= 1 && bcdH <= 12) TodHours = bcdH;
                    TodStopped = true; // Writing hours freezes the clock until tenths is written
                }
            }
            else if (r == 0x0C) Cia1SdrShiftsLeft = 16;
            else if (r == 0x0D)
            {
                if ((val & 0x80) != 0) Cia1IcrMask |= (byte)(val & 0x1F);
                else Cia1IcrMask &= (byte)~(val & 0x1F);
            }
            else if (r == 0x0E) { Cia1Cra = val; if ((val & 0x10) != 0) Cia1Ta = Cia1TaLatch; }
            else if (r == 0x0F) { Cia1Crb = val; if ((val & 0x10) != 0) Cia1Tb = Cia1TbLatch; }
            return;
        }
        if (addr >= 0xDD00 && addr <= 0xDDFF)
        {
            int r = addr & 0x0F;
            if (r == 0) Cia2Pra = val;
            else if (r == 2) Cia2Ddra = val;
            else if (r == 0x0D)
            {
                if ((val & 0x80) != 0) Cia2IcrMask |= (byte)(val & 0x1F);
                else Cia2IcrMask &= (byte)~(val & 0x1F);
            }
            else if (r == 0x0E) Cia2Cra = val;
            else if (r == 0x0F) Cia2Crb = val;
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
            int prevRaster = RasterY;
            RasterY = (RasterY + 1) % 312;
            if ((VicIrqEnable & 0x01) != 0 && RasterY == TargetRaster)
                VicIrqLatch |= 0x81;

            OnRasterLine?.Invoke(prevRaster);
            if (prevRaster == 311)
                OnFrameComplete?.Invoke();
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
        if ((Cia1Crb & 0x01) != 0)
        {
            Cia1Tb -= cycles;
            while (Cia1Tb <= 0)
            {
                Cia1Tb += Math.Max(1, Cia1TbLatch);
            }
        }

        // CIA1 Time-of-Day (TOD) clock: 1/10th second ticks (~100,000 cycles at 1 MHz)
        if (!TodStopped)
        {
            _todCycleAccum += cycles;
            while (_todCycleAccum >= 100_000)
            {
                _todCycleAccum -= 100_000;
                TodTenths++;
                if (TodTenths >= 10)
                {
                    TodTenths = 0;
                    TodSeconds++;
                    if (TodSeconds >= 60)
                    {
                        TodSeconds = 0;
                        TodMinutes++;
                        if (TodMinutes >= 60)
                        {
                            TodMinutes = 0;
                            if (TodHours == 11)
                            {
                                TodHours = 12;
                                TodIsPm = !TodIsPm;
                            }
                            else if (TodHours == 12)
                            {
                                TodHours = 1;
                            }
                            else
                            {
                                TodHours++;
                            }
                        }
                    }
                }

                // Check Alarm match
                byte curH = (byte)(((TodHours / 10) << 4) | (TodHours % 10) | (TodIsPm ? 0x80 : 0x00));
                byte curM = (byte)(((TodMinutes / 10) << 4) | (TodMinutes % 10));
                byte curS = (byte)(((TodSeconds / 10) << 4) | (TodSeconds % 10));
                byte curT = (byte)(TodTenths & 0x0F);
                if (curH == TodAlarmHours && curM == TodAlarmMinutes && curS == TodAlarmSeconds && curT == TodAlarmTenths)
                {
                    Cia1IcrData |= 0x04;
                    if ((Cia1IcrMask & 0x04) != 0) Cia1IcrData |= 0x80;
                }
            }
        }
    }

    public static char ScreenCodeToAscii(int sc)
    {
        int code = sc & 0x7F;
        return code switch
        {
            0 => '@',
            >= 1 and <= 26 => (char)('A' + code - 1),
            27 => '[',
            28 => '£',
            29 => ']',
            30 => '^',
            31 => '<',
            >= 32 and <= 63 => (char)code,
            >= 64 and <= 89 => (char)('a' + (code - 64)),
            >= 90 and <= 126 => '■',
            _ => ' '
        };
    }

    public (char Ch, byte ColorCode, bool Reverse) Get40ColCell(int row, int col)
    {
        int idx = row * 40 + col;
        byte rawSc = Ram[0][0x0400 + idx];
        byte color = (byte)(ColorRam[CpuPortData & 1][idx] & 0x0F);
        return (ScreenCodeToAscii(rawSc), color, (rawSc & 0x80) != 0);
    }

    public byte VicBorderColor => (byte)(VicRegs[0x20] & 0x0F);
    public byte VicBackgroundColor => (byte)(VicRegs[0x21] & 0x0F);

    public string RenderScreenRowAscii(int row)
    {
        if ((Ram[0][0x00D7] & 0x80) != 0)
        {
            int baseAddr = ((VdcRegs[12] << 8) | VdcRegs[13]) & 0xFFFF;
            var line80 = new char[80];
            for (int col = 0; col < 80; col++)
            {
                byte sc = (byte)(VdcVram[(baseAddr + row * 80 + col) & 0xFFFF] & 0x7F);
                line80[col] = sc switch
                {
                    0 => '@',
                    >= 1 and <= 26 => (char)('A' + sc - 1),
                    27 => '[',
                    28 => '\\',
                    29 => ']',
                    30 => '^',
                    31 => '_',
                    >= 32 and <= 126 => (char)sc,
                    _ => ' '
                };
            }
            return new string(line80).TrimEnd();
        }
        else
        {
            int baseAddr = GetVicScreenBase();
            bool lcMode = IsZ80Active || baseAddr != 0x0400;
            var line40 = new char[40];
            for (int c = 0; c < 40; c++)
            {
                byte raw = Ram[0][baseAddr + row * 40 + c];
                line40[c] = DecodeScreenChar(raw, lcMode);
            }
            return new string(line40).TrimEnd();
        }
    }

    public static char DecodeScreenChar(byte raw, bool lowercaseMode)
    {
        if (lowercaseMode)
        {
            return raw switch
            {
                0 => '@',
                >= 1 and <= 26 => (char)('a' + raw - 1),
                >= 32 and <= 63 => (char)raw,
                >= 65 and <= 90 => (char)raw,
                >= 97 and <= 122 => (char)raw,
                _ => ' '
            };
        }

        int sc = raw & 0x7F;
        return sc switch
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

    public int GetVicScreenBase()
    {
        int vicBank = (~Cia2Pra & 0x03) * 0x4000;
        int screenOffset = ((VicRegs[0x18] >> 4) & 0x0F) * 0x0400;
        return vicBank + screenOffset;
    }

    public string Render40ColScreenAscii()
    {
        int baseAddr = GetVicScreenBase();
        bool lcMode = IsZ80Active || baseAddr != 0x0400;
        var sb = new StringBuilder();
        for (int r = 0; r < 25; r++)
        {
            var line = new char[40];
            for (int c = 0; c < 40; c++)
            {
                byte raw = Ram[0][baseAddr + r * 40 + c];
                line[c] = DecodeScreenChar(raw, lcMode);
            }
            string s = new string(line).TrimEnd();
            if (s.Length > 0) sb.AppendLine(s);
        }
        return sb.ToString();
    }
}
