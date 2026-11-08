using Commodore128.Emulator;

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
        _bus.IsZ80Active
            ? ((_bus.Mcr & 0x80) == 0 ? ActiveDisplayMode.Vdc80Column : ActiveDisplayMode.Vic40Column)
            : ((_bus.Ram[0][0x00D7] & 0x80) != 0 ? ActiveDisplayMode.Vdc80Column : ActiveDisplayMode.Vic40Column);

    public string RenderActiveScreen() =>
        CurrentMode == ActiveDisplayMode.Vdc80Column ? Renderer.Render80Column() : Renderer.Render40Column();
}
