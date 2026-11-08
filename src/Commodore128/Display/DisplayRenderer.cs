using Commodore128.Emulator;

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
