using System.Text;

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
