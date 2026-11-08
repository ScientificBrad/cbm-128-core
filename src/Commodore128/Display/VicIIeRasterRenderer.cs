using System;
using Commodore128.Emulator;

namespace Commodore128.Display;

/// <summary>
/// Hardware-accurate raster scanline renderer for the MOS 8564/8566 VIC-IIe.
/// Renders authentic 320x200 pixel framebuffer line-by-line in real-time,
/// supporting mid-frame raster interrupts, split-screen modes, horizontal/vertical scrolling,
/// multicolor bitmap/character modes, custom character sets, and hardware sprites.
/// </summary>
public sealed class VicIIeRasterRenderer
{
    private readonly MemoryBus _bus;
    public readonly uint[] Framebuffer = new uint[320 * 200];
    private readonly bool[] _bgTransparent = new bool[320];

    // Standard Commodore 16-colour palette in 32-bit ARGB (0xAARRGGBB)
    public static readonly uint[] PaletteArgb =
    [
        0xFF000000, // 0: Black
        0xFFFFFFFF, // 1: White
        0xFF880000, // 2: Red
        0xFFAAFFEE, // 3: Cyan
        0xFFCC44CC, // 4: Purple
        0xFF00CC55, // 5: Green
        0xFF0000AA, // 6: Blue
        0xFFEEEE77, // 7: Yellow
        0xFFDD8855, // 8: Orange
        0xFF664400, // 9: Brown
        0xFFFF7777, // 10: Light Red
        0xFF333333, // 11: Dark Grey
        0xFF777777, // 12: Medium Grey
        0xFFAAFF66, // 13: Light Green
        0xFF0088FF, // 14: Light Blue
        0xFFBBBBBB  // 15: Light Grey
    ];

    public VicIIeRasterRenderer(MemoryBus bus)
    {
        _bus = bus;
    }

    /// <summary>
    /// Reads a byte from VIC-II memory space (0..16383 within selected VIC bank).
    /// Respects Character ROM mapping in Banks 0 and 2 ($1000-$1FFF) and RAM in Banks 1 and 3.
    /// </summary>
    public byte ReadVicByte(int offsetInBank)
    {
        offsetInBank &= 0x3FFF;
        int vicBank = (~_bus.Cia2Pra & 0x03);
        int bankBase = vicBank * 0x4000;
        int addr = bankBase + offsetInBank;

        // In Bank 0 and Bank 2, offsets $1000-$1FFF map to hardware Character ROM
        if ((vicBank == 0 || vicBank == 2) && offsetInBank >= 0x1000 && offsetInBank <= 0x1FFF)
        {
            return _bus.RomChar[offsetInBank - 0x1000];
        }

        int ramBank = 0;
        if (!_bus.IsC64Mode && !_bus.SuppressMmuWrites)
        {
            ramBank = (_bus.Rcr >> 6) & 0x01;
        }

        return _bus.Ram[ramBank][addr];
    }

    /// <summary>
    /// Renders a single raster scanline.
    /// In PAL Commodore systems, active display covers raster lines 51 to 250 (y = 0 to 199).
    /// </summary>
    public void RenderScanline(int rasterY)
    {
        if (rasterY < 51 || rasterY > 250) return;
        int y = rasterY - 51; // 0..199
        int rowOffset = y * 320;

        uint borderColor = PaletteArgb[_bus.VicRegs[0x20] & 0x0F];
        bool displayEnable = (_bus.VicRegs[0x11] & 0x10) != 0;
        if (!displayEnable)
        {
            for (int x = 0; x < 320; x++)
            {
                Framebuffer[rowOffset + x] = borderColor;
                _bgTransparent[x] = false;
            }
            return;
        }

        // 24-row vs 25-row mode
        bool rsel25 = (_bus.VicRegs[0x11] & 0x08) != 0;
        if (!rsel25 && (y < 4 || y >= 196))
        {
            for (int x = 0; x < 320; x++)
            {
                Framebuffer[rowOffset + x] = borderColor;
                _bgTransparent[x] = false;
            }
            return;
        }

        // Vertical scroll (bits 0-2 of $D011)
        int yScroll = _bus.VicRegs[0x11] & 0x07;
        int adjustedY = y + 3 - yScroll;
        if (adjustedY < 0 || adjustedY >= 200)
        {
            for (int x = 0; x < 320; x++)
            {
                Framebuffer[rowOffset + x] = borderColor;
                _bgTransparent[x] = false;
            }
            return;
        }

        int charRow = adjustedY / 8;
        int charY = adjustedY % 8;

        // Horizontal scroll & column select
        int xScroll = _bus.VicRegs[0x16] & 0x07;
        bool csel40 = (_bus.VicRegs[0x16] & 0x08) != 0;

        // Graphics mode bits
        bool bmm = (_bus.VicRegs[0x11] & 0x20) != 0; // Bitmap Mode
        bool mcm = (_bus.VicRegs[0x16] & 0x10) != 0; // Multi-Color Mode
        bool ecm = (_bus.VicRegs[0x11] & 0x40) != 0; // Extended Color Mode

        // Memory pointers from $D018
        int screenOffset = ((_bus.VicRegs[0x18] >> 4) & 0x0F) * 0x0400;
        int charOffset = ((_bus.VicRegs[0x18] >> 1) & 0x07) * 0x0800;
        int bitmapOffset = (_bus.VicRegs[0x18] & 0x08) != 0 ? 0x2000 : 0x0000;

        uint bg0Color = PaletteArgb[_bus.VicRegs[0x21] & 0x0F];
        uint bg1Color = PaletteArgb[_bus.VicRegs[0x22] & 0x0F];
        uint bg2Color = PaletteArgb[_bus.VicRegs[0x23] & 0x0F];
        uint bg3Color = PaletteArgb[_bus.VicRegs[0x24] & 0x0F];

        // 1. Render Background & Character / Bitmap layer
        for (int x = 0; x < 320; x++)
        {
            // 38-column mode border check
            if (!csel40 && (x < 8 || x >= 312))
            {
                Framebuffer[rowOffset + x] = borderColor;
                _bgTransparent[x] = false;
                continue;
            }

            int fetchX = x - xScroll;
            if (fetchX < 0 || fetchX >= 320)
            {
                Framebuffer[rowOffset + x] = bg0Color;
                _bgTransparent[x] = true;
                continue;
            }

            int col = fetchX / 8;
            int charPixelX = fetchX % 8;
            int cellIndex = charRow * 40 + col;
            byte colorRamVal = (byte)(_bus.ColorRam[0][cellIndex] & 0x0F);

            if (bmm)
            {
                // Bitmap Modes
                byte screenByte = ReadVicByte(screenOffset + cellIndex);
                byte bitmapByte = ReadVicByte(bitmapOffset + cellIndex * 8 + charY);

                if (mcm)
                {
                    // Multicolor Bitmap Mode (320x200, 160x200 double pixels)
                    int bitPair = (bitmapByte >> (6 - (charPixelX / 2) * 2)) & 0x03;
                    uint pixelColor = bitPair switch
                    {
                        0 => bg0Color,
                        1 => PaletteArgb[(screenByte >> 4) & 0x0F],
                        2 => PaletteArgb[screenByte & 0x0F],
                        _ => PaletteArgb[colorRamVal]
                    };
                    Framebuffer[rowOffset + x] = pixelColor;
                    _bgTransparent[x] = (bitPair == 0);
                }
                else
                {
                    // Standard High-Res Bitmap Mode
                    int bit = (bitmapByte >> (7 - charPixelX)) & 1;
                    byte colorIdx = (bit != 0) ? (byte)((screenByte >> 4) & 0x0F) : (byte)(screenByte & 0x0F);
                    Framebuffer[rowOffset + x] = PaletteArgb[colorIdx];
                    _bgTransparent[x] = (bit == 0);
                }
            }
            else
            {
                // Character Modes
                byte rawChar = ReadVicByte(screenOffset + cellIndex);

                if (mcm)
                {
                    // Multicolor Character Mode
                    if ((colorRamVal & 0x08) != 0)
                    {
                        // Multicolor character cell
                        byte charByte = ReadVicByte(charOffset + rawChar * 8 + charY);
                        int bitPair = (charByte >> (6 - (charPixelX / 2) * 2)) & 0x03;
                        uint pixelColor = bitPair switch
                        {
                            0 => bg0Color,
                            1 => bg1Color,
                            2 => bg2Color,
                            _ => PaletteArgb[colorRamVal & 0x07]
                        };
                        Framebuffer[rowOffset + x] = pixelColor;
                        _bgTransparent[x] = (bitPair == 0);
                    }
                    else
                    {
                        // High-res character cell in multicolor mode
                        byte charByte = ReadVicByte(charOffset + rawChar * 8 + charY);
                        int bit = (charByte >> (7 - charPixelX)) & 1;
                        uint pixelColor = (bit != 0) ? PaletteArgb[colorRamVal & 0x07] : bg0Color;
                        Framebuffer[rowOffset + x] = pixelColor;
                        _bgTransparent[x] = (bit == 0);
                    }
                }
                else if (ecm)
                {
                    // Extended Color Mode
                    int charCode = rawChar & 0x3F;
                    int bgSelect = (rawChar >> 6) & 0x03;
                    byte charByte = ReadVicByte(charOffset + charCode * 8 + charY);
                    int bit = (charByte >> (7 - charPixelX)) & 1;
                    uint bgSelColor = bgSelect switch { 0 => bg0Color, 1 => bg1Color, 2 => bg2Color, _ => bg3Color };
                    uint pixelColor = (bit != 0) ? PaletteArgb[colorRamVal & 0x07] : bgSelColor;
                    Framebuffer[rowOffset + x] = pixelColor;
                    _bgTransparent[x] = (bit == 0);
                }
                else
                {
                    // Standard Character Mode
                    int charCode = rawChar & 0x7F;
                    bool reverse = (rawChar & 0x80) != 0;
                    byte charByte = ReadVicByte(charOffset + charCode * 8 + charY);
                    int bit = (charByte >> (7 - charPixelX)) & 1;
                    if (reverse) bit ^= 1;
                    uint pixelColor = (bit != 0) ? PaletteArgb[colorRamVal] : bg0Color;
                    Framebuffer[rowOffset + x] = pixelColor;
                    _bgTransparent[x] = (bit == 0);
                }
            }
        }

        // 2. Render Hardware Sprites (0 to 7)
        byte sprEnable = _bus.VicRegs[0x15];
        if (sprEnable != 0)
        {
            // Reverse loop (7 down to 0): Sprite 0 has highest visual priority over other sprites
            for (int i = 7; i >= 0; i--)
            {
                if ((sprEnable & (1 << i)) == 0) continue;

                int sprY = _bus.VicRegs[i * 2 + 1];
                bool expY = (_bus.VicRegs[0x17] & (1 << i)) != 0;
                int sprH = expY ? 42 : 21;
                int relY = rasterY - sprY;
                if (relY < 0 || relY >= sprH) continue;
                int sprRow = expY ? (relY / 2) : relY;

                int sprX = _bus.VicRegs[i * 2] | (((_bus.VicRegs[0x10] >> i) & 1) << 8);
                bool expX = (_bus.VicRegs[0x1D] & (1 << i)) != 0;
                int sprW = expX ? 48 : 24;
                bool isMc = (_bus.VicRegs[0x1C] & (1 << i)) != 0;
                bool behindBg = (_bus.VicRegs[0x1B] & (1 << i)) != 0;

                uint sprColor = PaletteArgb[_bus.VicRegs[0x27 + i] & 0x0F];
                uint mcColor1 = PaletteArgb[_bus.VicRegs[0x25] & 0x0F];
                uint mcColor2 = PaletteArgb[_bus.VicRegs[0x26] & 0x0F];

                byte sprPtr = ReadVicByte(screenOffset + 1016 + i);
                int sprDataBase = sprPtr * 64 + sprRow * 3;
                byte b0 = ReadVicByte(sprDataBase);
                byte b1 = ReadVicByte(sprDataBase + 1);
                byte b2 = ReadVicByte(sprDataBase + 2);
                uint sprData = ((uint)b0 << 16) | ((uint)b1 << 8) | b2;
                if (sprData == 0) continue;

                int screenLeft = sprX - 24; // In PAL, screen X=0 corresponds to VIC-II X=24
                for (int sx = 0; sx < sprW; sx++)
                {
                    int px = screenLeft + sx;
                    if (px < 0 || px >= 320) continue;

                    int dotX = expX ? (sx / 2) : sx;
                    uint pixelColor;

                    if (isMc)
                    {
                        int pairIdx = dotX / 2; // 0..11
                        int shift = 22 - pairIdx * 2;
                        int pair = (int)((sprData >> shift) & 0x03);
                        if (pair == 0) continue;
                        pixelColor = pair switch
                        {
                            1 => mcColor1,
                            2 => sprColor,
                            _ => mcColor2
                        };
                    }
                    else
                    {
                        int shift = 23 - dotX;
                        if (((sprData >> shift) & 1) == 0) continue;
                        pixelColor = sprColor;
                    }

                    // Background priority check
                    if (behindBg && !_bgTransparent[px]) continue;

                    Framebuffer[rowOffset + px] = pixelColor;
                }
            }
        }
    }

    /// <summary>
    /// Renders an entire frame (all scanlines 51..250) on demand.
    /// </summary>
    public void RenderFullFrame()
    {
        for (int r = 51; r <= 250; r++)
        {
            RenderScanline(r);
        }
    }
}
