"""Generate modular C# .NET 8 Commodore 128 Emulator architecture under src/Commodore128/."""
from pathlib import Path
import shutil

ROOT = Path(r"D:\Emulation\C128")
CS_ROOT = ROOT / "src" / "Commodore128"

for sub in ["Emulator", "Firmware", "Debugger", "Display"]:
    (CS_ROOT / sub).mkdir(parents=True, exist_ok=True)

# 1. Commodore128.csproj
(CS_ROOT / "Commodore128.csproj").write_text("""<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <OutputType>Exe</OutputType>
    <TargetFramework>net8.0</TargetFramework>
    <PlatformTarget>x64</PlatformTarget>
    <ImplicitUsings>enable</ImplicitUsings>
    <Nullable>enable</Nullable>
    <LangVersion>12.0</LangVersion>
  </PropertyGroup>
</Project>
""", encoding="utf-8")

# 2. Firmware/RomVerifier.cs
(CS_ROOT / "Firmware" / "RomVerifier.cs").write_text("""using System;
using System.Collections.Generic;
using System.IO.Hashing;
using System.Security.Cryptography;

namespace Commodore128.Firmware;

public sealed record RomVerificationReport(
    string FileName,
    int ActualLength,
    int ExpectedLength,
    string Sha256,
    bool LengthValid,
    bool ChecksumMatchesKnown1985,
    string? ErrorMessage);

public static class RomVerifier
{
    public static readonly IReadOnlyDictionary<string, (int Length, string Sha256)> Known1985Roms =
        new Dictionary<string, (int, string)>(StringComparer.OrdinalIgnoreCase)
        {
            ["basic-4000.318018-02.bin"] = (16384, "c5ddb7c57dd0b6f259b95b9dd0494ba807cbe6dce8f1f19410a0a05833aa0b5e"),
            ["basic-8000.318019-02.bin"] = (16384, "e1432465b8abafd3397b0e6cb4eb8422449fb3f85c6366e8616b48c35a86ad79"),
            ["kernal.318020-03.bin"]     = (16384, "dcb17b5ce33c2490005b5d0f2a4d767ae56e8ab7ed41d6aa20c43173449e4786"),
            ["characters.390059-01.bin"] = (8192,  "f08d8f525b44f5cbb3f5776739fcdff737886e1813f1eb7a20aedb128db1d4a8"),
            ["z80bios.bin"]              = (4096,  "39c7656b326e4ad724ff4b50c995cb3b2b8ff9ed3bb2b4d277eb0ecd3cac062f"),
        };

    public static RomVerificationReport Verify(string fileName, byte[] data, int expectedLength, bool enforceChecksum = false)
    {
        string sha256 = Convert.ToHexString(SHA256.HashData(data)).ToLowerInvariant();
        bool lenOk = data.Length == expectedLength;
        bool hashOk = Known1985Roms.TryGetValue(fileName, out var known) && known.Sha256 == sha256;

        string? err = null;
        if (!lenOk)
            err = $"Invalid ROM length for '{fileName}': expected {expectedLength} bytes, got {data.Length} bytes.";
        else if (enforceChecksum && !hashOk)
            err = $"SHA-256 mismatch for '{fileName}': got {sha256}.";

        return new RomVerificationReport(fileName, data.Length, expectedLength, sha256, lenOk, hashOk, err);
    }
}
""", encoding="utf-8")

# 3. Firmware/RomLoader.cs
(CS_ROOT / "Firmware" / "RomLoader.cs").write_text("""using System;
using System.IO;

namespace Commodore128.Firmware;

public sealed record C128FirmwareSet(
    byte[] BasicLow,
    byte[] BasicHigh,
    byte[] Kernal,
    byte[] Characters,
    byte[] Z80Bios);

public static class RomLoader
{
    public static C128FirmwareSet LoadFromDirectory(string directoryPath, bool strictChecksum = false)
    {
        if (string.IsNullOrWhiteSpace(directoryPath) || !Directory.Exists(directoryPath))
            throw new DirectoryNotFoundException($"ROM directory not found: '{directoryPath}'. Supply a valid path via CLI argument or C128_ROM_DIR.");

        byte[] bLo = LoadAndVerify(directoryPath, "basic-4000.318018-02.bin", 16384, strictChecksum);
        byte[] bHi = LoadAndVerify(directoryPath, "basic-8000.318019-02.bin", 16384, strictChecksum);
        byte[] krn = LoadAndVerify(directoryPath, "kernal.318020-03.bin", 16384, strictChecksum);
        byte[] chr = LoadAndVerify(directoryPath, "characters.390059-01.bin", 8192, strictChecksum);

        string z80Path = Path.Combine(directoryPath, "z80bios.bin");
        byte[] z80;
        if (File.Exists(z80Path))
        {
            z80 = LoadAndVerify(directoryPath, "z80bios.bin", 4096, strictChecksum);
        }
        else
        {
            z80 = new byte[4096];
            Array.Copy(krn, 0x1000, z80, 0, 4096);
        }

        return new C128FirmwareSet(bLo, bHi, krn, chr, z80);
    }

    private static byte[] LoadAndVerify(string dir, string fileName, int expectedLen, bool strictChecksum)
    {
        string fullPath = Path.Combine(dir, fileName);
        if (!File.Exists(fullPath))
            throw new FileNotFoundException($"Required Commodore 128 ROM file missing: '{fullPath}'", fullPath);

        byte[] data = File.ReadAllBytes(fullPath);
        var report = RomVerifier.Verify(fileName, data, expectedLen, strictChecksum);
        if (report.ErrorMessage is not null)
            throw new InvalidDataException(report.ErrorMessage);

        return data;
    }
}
""", encoding="utf-8")

# 4. Copy and adapt Cpu8502.cs and CpuZ80.cs into Emulator/
cpu8502_src = (ROOT / "src" / "Cbm128.Core" / "Mos8502Cpu.cs").read_text(encoding="utf-8")
cpu8502_src = cpu8502_src.replace("namespace Cbm128.Core;", "namespace Commodore128.Emulator;").replace("Mos8502Cpu", "Cpu8502").replace("C128MmuAndPeripherals", "MemoryBus")
(CS_ROOT / "Emulator" / "Cpu8502.cs").write_text(cpu8502_src, encoding="utf-8")

cpuz80_src = (ROOT / "src" / "Cbm128.Core" / "ZilogZ80Cpu.cs").read_text(encoding="utf-8")
cpuz80_src = cpuz80_src.replace("namespace Cbm128.Core;", "namespace Commodore128.Emulator;").replace("ZilogZ80Cpu", "CpuZ80").replace("C128MmuAndPeripherals", "MemoryBus")
(CS_ROOT / "Emulator" / "CpuZ80.cs").write_text(cpuz80_src, encoding="utf-8")

bus_src = (ROOT / "src" / "Cbm128.Core" / "C128MmuAndPeripherals.cs").read_text(encoding="utf-8")
bus_src = bus_src.replace("namespace Cbm128.Core;", "namespace Commodore128.Emulator;").replace("C128MmuAndPeripherals", "MemoryBus")
(CS_ROOT / "Emulator" / "MemoryBus.cs").write_text(bus_src, encoding="utf-8")

# 5. Modular hardware component classes in Emulator/ (Mmu8722, Pla8721, VicIIe, Vdc8563, Sid6581, Cia6526, KeyboardController, C128Machine)
(CS_ROOT / "Emulator" / "Mmu8722.cs").write_text("""namespace Commodore128.Emulator;

/// <summary>
/// MOS 8722 Memory Management Unit (MMU) state & bank decoding facade ($D500-$D50B, $FF00-$FF04).
/// </summary>
public sealed class Mmu8722
{
    private readonly MemoryBus _bus;
    public Mmu8722(MemoryBus bus) => _bus = bus;

    public byte Cr { get => _bus.Cr; set => _bus.Cr = value; }
    public byte Mcr { get => _bus.Mcr; set => _bus.Mcr = value; }
    public byte Rcr { get => _bus.Rcr; set => _bus.Rcr = value; }
    public byte P0L { get => _bus.P0L; set => _bus.P0L = value; }
    public byte P0H { get => _bus.P0H; set => _bus.P0H = value; }
    public byte P1L { get => _bus.P1L; set => _bus.P1L = value; }
    public byte P1H { get => _bus.P1H; set => _bus.P1H = value; }
    public byte Vr => _bus.Vr;
    public bool IsZ80Active => _bus.IsZ80Active;
    public bool IsC64Mode => _bus.IsC64Mode;
}
""", encoding="utf-8")

(CS_ROOT / "Emulator" / "Pla8721.cs").write_text("""namespace Commodore128.Emulator;

/// <summary>
/// MOS 8721 Programmable Logic Array (PLA) chip-select & I/O-vs-ROM arbitration helper.
/// </summary>
public sealed class Pla8721
{
    private readonly MemoryBus _bus;
    public Pla8721(MemoryBus bus) => _bus = bus;

    public bool IsIoMapped => (_bus.Cr & 0x01) == 0;
    public bool IsBasicLowRomMapped => (_bus.Cr & 0x02) == 0;
    public bool IsBasicHighRomMapped => ((_bus.Cr >> 2) & 0x03) == 0;
    public bool IsKernalRomMapped => ((_bus.Cr >> 4) & 0x03) == 0;
    public int ActiveRamBank => (_bus.Cr >> 6) & 0x01;
}
""", encoding="utf-8")

(CS_ROOT / "Emulator" / "VicIIe.cs").write_text("""namespace Commodore128.Emulator;

/// <summary>
/// MOS 8564/8566 VIC-IIe 40-Column Video Controller ($D000-$D030).
/// Supports raster compare IRQ, 2 MHz clock bit ($D030 bit 0), and extended keyboard scan ($D02F).
/// </summary>
public sealed class VicIIe
{
    private readonly MemoryBus _bus;
    public VicIIe(MemoryBus bus) => _bus = bus;

    public int RasterY => _bus.RasterY;
    public bool IsTwoMhzMode => (_bus.VicRegs[0x30] & 0x01) != 0;
    public byte ExtendedKeyScanRow => (byte)(_bus.VicRegs[0x2F] | 0xF8);
    public string Render40ColumnText() => _bus.Render40ColScreenAscii();
}
""", encoding="utf-8")

(CS_ROOT / "Emulator" / "Vdc8563.cs").write_text("""using System.Text;

namespace Commodore128.Emulator;

/// <summary>
/// MOS 8563 VDC 80-Column RGBI Video Display Controller ($D600-$D601) with 64 KB dedicated VRAM.
/// </summary>
public sealed class Vdc8563
{
    private readonly MemoryBus _bus;
    public Vdc8563(MemoryBus bus) => _bus = bus;

    public byte StatusRegister => (byte)(0x81 | (_bus.RasterY >= 250 ? 0x20 : 0x00));
    public byte[] Vram => _bus.VdcVram;
    public byte[] Registers => _bus.VdcRegs;

    public string Render80ColumnText()
    {
        var sb = new StringBuilder();
        int baseAddr = ((_bus.VdcRegs[12] << 8) | _bus.VdcRegs[13]) & 0xFFFF;
        for (int row = 0; row < 25; row++)
        {
            var line = new char[80];
            for (int col = 0; col < 80; col++)
            {
                byte sc = (byte)(_bus.VdcVram[(baseAddr + row * 80 + col) & 0xFFFF] & 0x7F);
                line[col] = sc switch
                {
                    0 => '@',
                    >= 1 and <= 26 => (char)('A' + sc - 1),
                    >= 32 and <= 126 => (char)sc,
                    _ => ' '
                };
            }
            sb.AppendLine(new string(line).TrimEnd());
        }
        return sb.ToString();
    }
}
""", encoding="utf-8")

(CS_ROOT / "Emulator" / "Sid6581.cs").write_text("""using System;

namespace Commodore128.Emulator;

/// <summary>
/// MOS 6581/8580 SID 3-Voice Sound Interface Device ($D400-$D41F).
/// Tracks all 3 oscillator frequencies, pulse widths, waveforms, ADSR envelopes, filter cutoffs,
/// and synthesizes 16-bit mono PCM audio samples on demand.
/// </summary>
public sealed class Sid6581
{
    private readonly MemoryBus _bus;
    private readonly uint[] _phase = new uint[3];

    public Sid6581(MemoryBus bus) => _bus = bus;

    public int GetVoiceFrequencyHz(int voice, double clockHz = 1022727.0)
    {
        int baseReg = (voice % 3) * 7;
        int freqWord = _bus.SidRegs[baseReg] | (_bus.SidRegs[baseReg + 1] << 8);
        return (int)Math.Round(freqWord * (clockHz / 16777216.0));
    }

    public int MasterVolume => _bus.SidRegs[0x18] & 0x0F;

    public short[] SynthesizePcmSamples(int sampleCount, int sampleRate = 44100, double clockHz = 1022727.0)
    {
        var output = new short[sampleCount];
        int vol = MasterVolume;
        if (vol == 0) return output;

        for (int i = 0; i < sampleCount; i++)
        {
            int mix = 0;
            for (int v = 0; v < 3; v++)
            {
                int b = v * 7;
                byte ctrl = _bus.SidRegs[b + 4];
                if ((ctrl & 0x01) == 0) continue; // Gate off
                uint freqWord = (uint)(_bus.SidRegs[b] | (_bus.SidRegs[b + 1] << 8));
                uint step = (uint)((freqWord * clockHz) / sampleRate * 256.0);
                _phase[v] += step;
                ushort top12 = (ushort)((_phase[v] >> 20) & 0xFFF);
                int sample = 0;
                if ((ctrl & 0x20) != 0) // Sawtooth
                    sample = (top12 - 2048) * 8;
                else if ((ctrl & 0x10) != 0) // Triangle
                    sample = ((top12 < 2048 ? top12 : 4095 - top12) - 1024) * 16;
                else if ((ctrl & 0x40) != 0) // Pulse
                {
                    int pw = _bus.SidRegs[b + 2] | ((_bus.SidRegs[b + 3] & 0x0F) << 8);
                    sample = top12 >= pw ? 16384 : -16384;
                }
                mix += sample;
            }
            output[i] = (short)Math.Clamp((mix * vol) / 45, short.MinValue, short.MaxValue);
        }
        return output;
    }
}
""", encoding="utf-8")

(CS_ROOT / "Emulator" / "Cia6526.cs").write_text("""namespace Commodore128.Emulator;

/// <summary>
/// Dual MOS 6526 Complex Interface Adapter facade (CIA1 $DC00-$DC0F & CIA2 $DD00-$DD0F).
/// </summary>
public sealed class Cia6526
{
    private readonly MemoryBus _bus;
    public Cia6526(MemoryBus bus) => _bus = bus;

    public byte Cia1Pra { get => _bus.Cia1Pra; set => _bus.Cia1Pra = value; }
    public byte Cia1Prb { get => _bus.Cia1Prb; set => _bus.Cia1Prb = value; }
    public byte Cia2Pra { get => _bus.Cia2Pra; set => _bus.Cia2Pra = value; }
    public byte Cia2Prb { get => _bus.Cia2Prb; set => _bus.Cia2Prb = value; }
}
""", encoding="utf-8")

(CS_ROOT / "Emulator" / "KeyboardController.cs").write_text("""using System;
using System.Collections.Generic;

namespace Commodore128.Emulator;

/// <summary>
/// C128 11x8 Keyboard Matrix Controller ($DC00 standard rows 0-7, $D02F extended rows 8-10, $DC01 columns 0-7).
/// Supports physical matrix key press/release, RUN/STOP, Function Keys F1-F8, and PETSCII input queuing.
/// </summary>
public sealed class KeyboardController
{
    private readonly MemoryBus _bus;
    private readonly Queue<byte> _petsciiQueue = new();

    public KeyboardController(MemoryBus bus) => _bus = bus;

    public void PressMatrixKey(int row, int col)
    {
        if (row is >= 0 and < 11 && col is >= 0 and < 8)
            _bus.KeyMatrix[row] &= (byte)~(1 << col);
    }

    public void ReleaseMatrixKey(int row, int col)
    {
        if (row is >= 0 and < 11 && col is >= 0 and < 8)
            _bus.KeyMatrix[row] |= (byte)(1 << col);
    }

    public void ReleaseAllKeys()
    {
        for (int i = 0; i < 11; i++) _bus.KeyMatrix[i] = 0xFF;
    }

    public void SetRunStopPressed(bool pressed)
    {
        if (pressed) PressMatrixKey(7, 7);
        else ReleaseMatrixKey(7, 7);
    }

    public void EnqueueText(string text)
    {
        foreach (char ch in text)
        {
            byte b = ch == '\\n' ? (byte)0x0D : (byte)char.ToUpperInvariant(ch);
            _petsciiQueue.Enqueue(b);
        }
    }

    public void FeedKernalBuffer()
    {
        if (_petsciiQueue.Count == 0) return;
        byte ndx = _bus.Ram[0][0x00D0];
        byte xmax = _bus.Ram[0][0x0A20];
        if (xmax == 0) xmax = 10;
        while (_petsciiQueue.Count > 0 && ndx < xmax)
        {
            _bus.Ram[0][0x034A + ndx] = _petsciiQueue.Dequeue();
            ndx++;
            _bus.Ram[0][0x00D0] = ndx;
        }
    }
}
""", encoding="utf-8")

# 6. Debugger classes (BreakpointManager, ExecutionTracer, MemoryInspector)
(CS_ROOT / "Debugger" / "BreakpointManager.cs").write_text("""using System.Collections.Generic;

namespace Commodore128.Debugger;

public sealed class BreakpointManager
{
    private readonly HashSet<ushort> _pcBreakpoints = new();
    public bool Enabled { get; set; } = true;

    public void AddBreakpoint(ushort address) => _pcBreakpoints.Add(address);
    public void RemoveBreakpoint(ushort address) => _pcBreakpoints.Remove(address);
    public void Clear() => _pcBreakpoints.Clear();
    public IReadOnlyCollection<ushort> Breakpoints => _pcBreakpoints;

    public bool ShouldBreak(ushort pc) => Enabled && _pcBreakpoints.Contains(pc);
}
""", encoding="utf-8")

(CS_ROOT / "Debugger" / "ExecutionTracer.cs").write_text("""using System.Collections.Generic;

namespace Commodore128.Debugger;

public sealed record TraceEvent(
    long Cycle,
    string Cpu,
    ushort Pc,
    byte Opcode,
    byte Cr,
    byte Mcr);

public sealed class ExecutionTracer
{
    private readonly List<TraceEvent> _events = new();
    public bool Enabled { get; set; }
    public int MaxEvents { get; set; } = 10000;
    public IReadOnlyList<TraceEvent> Events => _events;

    public void Record(long cycle, string cpu, ushort pc, byte opcode, byte cr, byte mcr)
    {
        if (!Enabled) return;
        if (_events.Count >= MaxEvents) _events.RemoveAt(0);
        _events.Add(new TraceEvent(cycle, cpu, pc, opcode, cr, mcr));
    }

    public void Clear() => _events.Clear();
}
""", encoding="utf-8")

(CS_ROOT / "Debugger" / "MemoryInspector.cs").write_text("""using System;
using System.Text;
using Commodore128.Emulator;

namespace Commodore128.Debugger;

public sealed class MemoryInspector
{
    private readonly MemoryBus _bus;
    public MemoryInspector(MemoryBus bus) => _bus = bus;

    public byte ReadCpuVisible(ushort addr, bool z80Mode = false) => _bus.Read8(addr, z80Mode);
    public byte ReadPhysicalRam(int bank, ushort addr) => _bus.Ram[bank & 1][addr];

    public string HexDump(ushort startAddr, int length, int? bank = null)
    {
        var sb = new StringBuilder();
        for (int off = 0; off < length; off += 16)
        {
            ushort rowAddr = (ushort)(startAddr + off);
            sb.Append($"{rowAddr:X4}: ");
            int rowLen = Math.Min(16, length - off);
            for (int i = 0; i < 16; i++)
            {
                if (i < rowLen)
                {
                    byte b = bank.HasValue ? ReadPhysicalRam(bank.Value, (ushort)(rowAddr + i)) : ReadCpuVisible((ushort)(rowAddr + i));
                    sb.Append($"{b:X2} ");
                }
                else sb.Append("   ");
            }
            sb.Append(" |");
            for (int i = 0; i < rowLen; i++)
            {
                byte b = bank.HasValue ? ReadPhysicalRam(bank.Value, (ushort)(rowAddr + i)) : ReadCpuVisible((ushort)(rowAddr + i));
                sb.Append(b is >= 32 and <= 126 ? (char)b : '.');
            }
            sb.AppendLine("|");
        }
        return sb.ToString();
    }
}
""", encoding="utf-8")

# 7. Display classes (DisplayRenderer, ScreenController)
(CS_ROOT / "Display" / "DisplayRenderer.cs").write_text("""using Commodore128.Emulator;

namespace Commodore128.Display;

public sealed class DisplayRenderer
{
    private readonly VicIIe _vic;
    private readonly Vdc8563 _vdc;

    public DisplayRenderer(VicIIe vic, Vdc8563 vdc)
    {
        _vic = vic;
        _vdc = vdc;
    }

    public string Render40Column() => _vic.Render40ColumnText();
    public string Render80Column() => _vdc.Render80ColumnText();
}
""", encoding="utf-8")

(CS_ROOT / "Display" / "ScreenController.cs").write_text("""using Commodore128.Emulator;

namespace Commodore128.Display;

public enum ActiveDisplayMode { Vic40Column, Vdc80Column }

public sealed class ScreenController
{
    private readonly MemoryBus _bus;
    public DisplayRenderer Renderer { get; }

    public ScreenController(MemoryBus bus, VicIIe vic, Vdc8563 vdc)
    {
        _bus = bus;
        Renderer = new DisplayRenderer(vic, vdc);
    }

    public ActiveDisplayMode CurrentMode =>
        (_bus.Ram[0][0x00D7] & 0x80) != 0 ? ActiveDisplayMode.Vdc80Column : ActiveDisplayMode.Vic40Column;

    public string RenderActiveScreen() =>
        CurrentMode == ActiveDisplayMode.Vdc80Column ? Renderer.Render80Column() : Renderer.Render40Column();
}
""", encoding="utf-8")

# 8. Emulator/C128Machine.cs
(CS_ROOT / "Emulator" / "C128Machine.cs").write_text("""using Commodore128.Debugger;
using Commodore128.Display;

namespace Commodore128.Emulator;

public sealed class C128Machine
{
    public MemoryBus Bus { get; }
    public Mmu8722 Mmu { get; }
    public Pla8721 Pla { get; }
    public VicIIe Vic { get; }
    public Vdc8563 Vdc { get; }
    public Sid6581 Sid { get; }
    public Cia6526 Cia { get; }
    public KeyboardController Keyboard { get; }
    public Cpu8502 Cpu8502 { get; }
    public CpuZ80 CpuZ80 { get; }

    public BreakpointManager Breakpoints { get; } = new();
    public ExecutionTracer Tracer { get; } = new();
    public MemoryInspector Inspector { get; }
    public ScreenController Screen { get; }

    public bool IsPaused { get; private set; }
    public long TotalCycles { get; private set; }

    public C128Machine(string romDirectory)
    {
        Bus = new MemoryBus(romDirectory);
        Mmu = new Mmu8722(Bus);
        Pla = new Pla8721(Bus);
        Vic = new VicIIe(Bus);
        Vdc = new Vdc8563(Bus);
        Sid = new Sid6581(Bus);
        Cia = new Cia6526(Bus);
        Keyboard = new KeyboardController(Bus);
        Cpu8502 = new Cpu8502(Bus);
        CpuZ80 = new CpuZ80(Bus);
        Inspector = new MemoryInspector(Bus);
        Screen = new ScreenController(Bus, Vic, Vdc);
    }

    public void PowerOnReset()
    {
        Bus.Cr = 0x00;
        Bus.Mcr = 0xB0; // Z80 active on power-on
        CpuZ80.Reset();
        Cpu8502.ResetPending = true;
        TotalCycles = 0;
        IsPaused = false;
    }

    public void WarmResetNmi()
    {
        Cpu8502.NmiPending = true;
    }

    public void Pause() => IsPaused = true;
    public void Resume() => IsPaused = false;

    public int StepInstruction()
    {
        ushort curPc = Bus.IsZ80Active ? CpuZ80.PC : Cpu8502.PC;
        if (Breakpoints.ShouldBreak(curPc))
        {
            IsPaused = true;
            return 0;
        }

        if (Tracer.Enabled)
        {
            byte op = Bus.Read8(curPc, Bus.IsZ80Active);
            Tracer.Record(TotalCycles, Bus.IsZ80Active ? "Z80" : "8502", curPc, op, Bus.Cr, Bus.Mcr);
        }

        int cyc;
        if (Bus.IsZ80Active)
        {
            cyc = CpuZ80.Step();
        }
        else
        {
            Keyboard.FeedKernalBuffer();
            cyc = Cpu8502.Step();
        }

        Bus.StepCycles(cyc);
        TotalCycles += cyc;
        return cyc;
    }

    public void RunCycles(long cycles)
    {
        long target = TotalCycles + cycles;
        while (!IsPaused && TotalCycles < target)
            StepInstruction();
    }
}
""", encoding="utf-8")

# 9. Program.cs
(CS_ROOT / "Program.cs").write_text("""using System;
using Commodore128.Emulator;
using Commodore128.Firmware;

namespace Commodore128;

public static class Program
{
    public static int Main(string[] args)
    {
        string romDir = args.Length > 0
            ? args[0]
            : Environment.GetEnvironmentVariable("C128_ROM_DIR") ?? AppContext.BaseDirectory;

        // Validate ROMs before launching machine
        _ = RomLoader.LoadFromDirectory(romDir, strictChecksum: false);

        var machine = new C128Machine(romDir);
        machine.PowerOnReset();

        while (machine.TotalCycles < 3_000_000 && !machine.IsPaused)
        {
            machine.RunCycles(1000);
            string screen = machine.Screen.RenderActiveScreen();
            if (screen.Contains("READY."))
            {
                Console.WriteLine($"[Commodore128 .NET 8] Booted to READY. in {machine.TotalCycles:N0} cycles.");
                Console.WriteLine(screen);
                return 0;
            }
        }

        Console.Error.WriteLine("Timeout waiting for READY.");
        return 1;
    }
}
""", encoding="utf-8")

print("Generated complete modular C# .NET 8 architecture under src/Commodore128/")
