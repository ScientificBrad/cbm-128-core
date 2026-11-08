using System;
using System.Text;
using Commodore128.Emulator;

namespace Commodore128.Display;

/// <summary>
/// Real-time ANSI dirty-cell renderer for the 40x25 MOS 8564/8566 VIC-IIe display.
/// Reads directly from emulated screen memory ($0400-$07E7), colour RAM ($D800-$DBE7),
/// and VIC-IIe border/background registers ($D020/$D021) without clearing the whole terminal.
/// </summary>
public sealed class LiveConsoleRenderer
{
    private readonly MemoryBus _bus;
    private readonly ushort[] _prevCells = new ushort[1000];
    private byte _prevBg = 0xFF;
    private byte _prevBorder = 0xFF;
    private bool _frameDrawn;
    private readonly StringBuilder _sb = new(8192);

    /// <summary>
    /// Explicit override for screen base address (e.g. $4400 for Kikstart race). If negative, calculated from VIC registers.
    /// </summary>
    public int ScreenBase { get; set; } = -1;

    // Original Commodore 128 VIC-IIe 16-colour palette (R, G, B)
    private static readonly (byte R, byte G, byte B)[] VicPalette =
    [
        (0, 0, 0),       // 0: Black
        (255, 255, 255), // 1: White (Leading Matrix characters)
        (136, 0, 0),     // 2: Red
        (170, 255, 238), // 3: Cyan
        (204, 68, 204),  // 4: Purple
        (0, 204, 85),    // 5: Green (Trailing Matrix characters)
        (0, 0, 170),     // 6: Blue
        (238, 238, 119), // 7: Yellow
        (221, 136, 85),  // 8: Orange
        (102, 68, 0),    // 9: Brown
        (255, 119, 119), // 10: Light Red
        (51, 51, 51),    // 11: Dark Grey
        (119, 119, 119), // 12: Medium Grey
        (170, 255, 102), // 13: Light Green (Immediate Matrix trail)
        (0, 136, 255),   // 14: Light Blue
        (187, 187, 187)  // 15: Light Grey
    ];

    public LiveConsoleRenderer(MemoryBus bus)
    {
        _bus = bus;
        Invalidate();
    }

    public void Invalidate()
    {
        Array.Fill(_prevCells, (ushort)0xFFFF);
        _prevBg = 0xFF;
        _prevBorder = 0xFF;
        _frameDrawn = false;
    }

    private static void AppendFgColor(StringBuilder sb, byte colorCode)
    {
        var (r, g, b) = VicPalette[colorCode & 0x0F];
        sb.Append($"\x1b[38;2;{r};{g};{b}m");
    }

    private static void AppendBgColor(StringBuilder sb, byte colorCode)
    {
        var (r, g, b) = VicPalette[colorCode & 0x0F];
        sb.Append($"\x1b[48;2;{r};{g};{b}m");
    }

    public void InitializeTerminal()
    {
        Console.OutputEncoding = Encoding.UTF8;
        Console.Write("\x1b[?25l\x1b[2J\x1b[H");
        Invalidate();
    }

    public void RestoreTerminal()
    {
        Console.Write("\x1b[0m\x1b[28;1H\x1b[?25h");
        Console.WriteLine();
    }

    public void RenderFrame(long totalCycles)
    {
        _sb.Clear();

        byte bg = _bus.VicBackgroundColor;
        byte border = _bus.VicBorderColor;
        bool fullRedraw = !_frameDrawn || bg != _prevBg || border != _prevBorder;

        if (fullRedraw)
        {
            _prevBg = bg;
            _prevBorder = border;
            _frameDrawn = true;

            // Top border (Row 1, Columns 1..42)
            _sb.Append("\x1b[1;1H");
            AppendBgColor(_sb, border);
            _sb.Append("\x1b[38;2;0;204;85m");
            _sb.Append("  COMMODORE 128 VIC-IIE 40x25 LIVE VIDEO  ");

            // Left and Right borders for rows 2..26
            for (int r = 0; r < 25; r++)
            {
                _sb.Append($"\x1b[{r + 2};1H ");
                _sb.Append($"\x1b[{r + 2};42H ");
            }

            // Bottom border (Row 27, Columns 1..42)
            _sb.Append("\x1b[27;1H");
            _sb.Append(new string(' ', 42));
            Array.Fill(_prevCells, (ushort)0xFFFF);
        }

        byte activeFg = 0xFF;
        byte activeBg = 0xFF;
        int curTermRow = -1;
        int curTermCol = -1;

        int screenBase = ScreenBase >= 0 ? ScreenBase :
                         (_bus.VicRegs[0x18] != 0 ? (((~_bus.Cia2Pra) & 0x03) * 0x4000 + ((_bus.VicRegs[0x18] >> 4) & 0x0F) * 0x0400) : 0x0400);

        for (int r = 0; r < 25; r++)
        {
            for (int c = 0; c < 40; c++)
            {
                int idx = r * 40 + c;
                byte rawSc = _bus.Ram[0][screenBase + idx];
                byte color = (byte)(_bus.ColorRam[_bus.CpuPortData & 1][idx] & 0x0F);
                ushort packed = (ushort)((color << 8) | rawSc);

                if (_prevCells[idx] == packed)
                    continue;

                _prevCells[idx] = packed;

                int targetRow = r + 2;
                int targetCol = c + 2;
                if (curTermRow != targetRow || curTermCol != targetCol)
                {
                    _sb.Append($"\x1b[{targetRow};{targetCol}H");
                    curTermRow = targetRow;
                    curTermCol = targetCol;
                }

                bool reverse = (rawSc & 0x80) != 0;
                char ch = MemoryBus.ScreenCodeToAscii(rawSc);

                // For space characters (screen code 32, unreversed), foreground colour doesn't affect appearance
                byte cellFg = reverse ? bg : color;
                byte cellBg = reverse ? color : bg;

                if (cellBg != activeBg)
                {
                    AppendBgColor(_sb, cellBg);
                    activeBg = cellBg;
                }
                if (ch != ' ' && cellFg != activeFg)
                {
                    AppendFgColor(_sb, cellFg);
                    activeFg = cellFg;
                }

                _sb.Append(ch);
                curTermCol++;
            }
        }

        // Status line at Row 28
        _sb.Append($"\x1b[28;1H\x1b[48;2;0;0;0m\x1b[38;2;119;119;119m[8502 Cycles: {totalCycles,11:N0}] [ESC: Exit] [Arrows/Space: Controls] [F1/F7: Options]");

        if (_sb.Length > 0)
        {
            Console.Write(_sb.ToString());
        }
    }
}
