using Xunit;
using Commodore128.Display;
using Commodore128.Emulator;

namespace Commodore128.Tests;

public class VicIIeRendererTests
{
    [Fact]
    public void Palette_Has16UniqueCommodoreColors()
    {
        Assert.Equal(16, VicIIeRasterRenderer.PaletteArgb.Length);

        // Black is color 0
        Assert.Equal(0xFF000000u, VicIIeRasterRenderer.PaletteArgb[0]);
        // White is color 1
        Assert.Equal(0xFFFFFFFFu, VicIIeRasterRenderer.PaletteArgb[1]);
        // Light Blue is color 14
        Assert.Equal(0xFF0088FFu, VicIIeRasterRenderer.PaletteArgb[14]);
    }

    [Fact]
    public void RasterRenderer_Produces320x200Framebuffer()
    {
        var bus = new MemoryBus(".");
        var renderer = new VicIIeRasterRenderer(bus);

        // Configure default VIC-II text mode: $D011 = $1B (DEN=1, RSEL=1, BMM=0)
        bus.VicRegs[0x11] = 0x1B;
        bus.VicRegs[0x16] = 0x08; // 40 cols, no MCM
        bus.VicRegs[0x18] = 0x14; // Screen at $0400, Chars at $1000
        bus.VicRegs[0x20] = 0x00; // Border Black
        bus.VicRegs[0x21] = 0x06; // Background Blue

        // Render full frame (raster lines 51..250)
        renderer.RenderFullFrame();

        Assert.Equal(320 * 200, renderer.Framebuffer.Length);
        // Verify background color is populated
        uint expectedBg = VicIIeRasterRenderer.PaletteArgb[6]; // Blue
        Assert.Equal(expectedBg, renderer.Framebuffer[0]);
    }
}
