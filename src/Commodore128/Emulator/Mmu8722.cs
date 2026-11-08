namespace Commodore128.Emulator;

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
