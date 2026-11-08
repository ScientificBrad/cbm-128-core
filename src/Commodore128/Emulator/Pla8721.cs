namespace Commodore128.Emulator;

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
