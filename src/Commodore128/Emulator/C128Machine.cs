using Commodore128.Debugger;
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
    public bool DebugMode { get; set; } = false;
    private bool _display80Col;
    public bool Display80Col
    {
        get => _display80Col;
        set
        {
            _display80Col = value;
            if (value)
                Bus.Mcr = (byte)(Bus.Mcr & ~0x80);
            else
                Bus.Mcr = (byte)(Bus.Mcr | 0x80);
        }
    }
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
        Bus.Mcr = (byte)(_display80Col ? 0x30 : 0xB0); // Z80 active on power-on, bit 7 = 40/80 switch
        CpuZ80.Reset();
        Cpu8502.ResetPending = true;
        Cpu8502.NmiPending = false;
        Bus.InitTodFromHost();
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
        ushort curPc = Bus.IsZ80Active ? CpuZ80.Pc : Cpu8502.Pc;
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
            if (Keyboard.HasPendingInput) Keyboard.FeedCpmBuffer();
            cyc = CpuZ80.Step();
        }
        else
        {
            if (Keyboard.HasPendingInput) Keyboard.FeedKernalBuffer();
            if (Bus.Drive8 != null)
            {
                if (Cpu8502.Pc == 0xF890)
                {
                    Bus.Ram[0][0x00BF] = Cpu8502.A;
                    Bus.Ram[0][0x00BA] = (byte)Cpu8502.X;
                    Bus.Ram[0][0x009F] = 0;
                    Bus.Drive8.ReadSectorInto(1, 0, Bus.Ram[0], 0x0B00);
                    Cpu8502.Pc = 0xF8F9;
                }
                else if (Cpu8502.Pc == 0x3000)
                {
                    byte cmd = Bus.Ram[0][0xFD01];
                    if (cmd == 0x00)
                    {
                        Bus.Ram[0][0xFD06] = 0x00;
                        Bus.Ram[0][0xFD08] = (byte)(Bus.Drive8.IsD71 ? 0x0F : 0x00);
                        Cpu8502.Pc = 0xFFD0;
                    }
                    else if (cmd == 0x01)
                    {
                        int trk = Bus.Ram[0][0xFD03];
                        int sec = Bus.Ram[0][0xFD04];
                        int buf = Bus.Ram[0][0xFD18] | (Bus.Ram[0][0xFD19] << 8);
                        int count = Bus.Ram[0][0x31BD];
                        if (count <= 0) count = 1;
                        for (int s = 0; s < count; s++)
                        {
                            Bus.Drive8.ReadSectorInto(trk, sec + s, Bus.Ram[0], buf + s * 256);
                        }
                        Bus.Ram[0][0xFD06] = 0x00;
                        Cpu8502.Pc = 0xFFD0;
                    }
                }
                else if (Cpu8502.Pc == 0x2600)
                {
                    byte cmd = Bus.Ram[0][0xFD01];
                    byte dev = Bus.Ram[0][0xFD02];
                    int t = Bus.Ram[0][0xFD03];
                    int s = Bus.Ram[0][0xFD04];
                    int cnt = Bus.Ram[0][0xFD05];
                    int b = Bus.Ram[0][0xFD18] | (Bus.Ram[0][0xFD19] << 8);
                    int bk1A = Bus.Ram[0][0xFD1A];
                    int bk1E = Bus.Ram[0][0xFD1E];
                    var drive = ((dev & 0x02) != 0 || dev == 9) && Bus.Drive9 != null ? Bus.Drive9 : Bus.Drive8;
                    if (DebugMode) Console.WriteLine($"[Hook 0x2600] cmd={cmd} dev={dev} trk={t} sec={s} cnt={cnt} buf=0x{b:X4} bank1A={bk1A} bank1E={bk1E}");
                    if (cmd == 0x00)
                    {
                        Bus.Ram[0][0xFD06] = 0x00;
                        Cpu8502.Pc = 0xFFD6;
                    }
                    else if (cmd == 0x01)
                    {
                        int trk = Bus.Ram[0][0xFD03];
                        int sec = Bus.Ram[0][0xFD04];
                        drive.ReadSectorInto(trk, sec, Bus.Ram[0], 0xFE00);
                        Bus.Ram[0][0xFD06] = 0x00;
                        Cpu8502.Pc = 0xFFD6;
                    }
                    else if (cmd == 0x02)
                    {
                        int trk = Bus.Ram[0][0xFD03];
                        int sec = Bus.Ram[0][0xFD04];
                        int buf = Bus.Ram[0][0xFD18] | (Bus.Ram[0][0xFD19] << 8);
                        int bank = Bus.Ram[0][0xFD1A] & 1;
                        drive.WriteSector(trk, sec, Bus.Ram[bank], buf);
                        Bus.Ram[0][0xFD06] = 0x00;
                        Cpu8502.Pc = 0xFFD6;
                    }
                    else
                    {
                        Bus.Ram[0][0xFD06] = 0x00;
                        Cpu8502.Pc = 0xFFD6;
                    }
                }
            }

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
