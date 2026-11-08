namespace Commodore128.Emulator;

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
