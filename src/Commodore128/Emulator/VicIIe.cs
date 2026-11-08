namespace Commodore128.Emulator;

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
