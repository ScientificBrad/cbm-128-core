using System;
using System.Diagnostics;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.Runtime.InteropServices;
using System.Threading;
using System.Windows.Forms;
using Commodore128.Emulator;

namespace Commodore128.Display;

/// <summary>
/// Native Windows GUI display window for Commodore 128 / VIC-IIe emulation.
/// Features authentic 320x200 framebuffer rendering, integer scaling (1x, 2x, 3x, 4x),
/// CRT scanline/bloom visual effects, keyboard-to-joystick mapping, live FPS, and CPU stats.
/// </summary>
public sealed class Commodore128Window : Form
{
    private readonly MemoryBus _bus;
    private readonly VicIIeRasterRenderer _rasterRenderer;
    private readonly Func<int, bool>? _stepFrameCallback;

    private readonly uint[] _frontBuffer = new uint[320 * 200];
    private readonly object _bufferLock = new();

    private Bitmap? _displayBmp;
    private Bitmap? _crtBmp;

    private int _scale = 3; // Default 3x (960x600)
    private bool _crtEffects = true;
    private bool _running = true;
    private Thread? _emuThread;

    // Stats
    private long _totalCycles;
    private int _frameCount;
    private double _fps;
    private readonly Stopwatch _fpsStopwatch = Stopwatch.StartNew();
    private readonly Stopwatch _frameTimer = new();

    public Commodore128Window(MemoryBus bus, VicIIeRasterRenderer rasterRenderer, Func<int, bool>? stepFrameCallback = null)
    {
        _bus = bus;
        _rasterRenderer = rasterRenderer;
        _stepFrameCallback = stepFrameCallback;

        // Form settings
        Text = "Commodore 128 - VIC-IIe Live Video";
        FormBorderStyle = FormBorderStyle.FixedSingle;
        MaximizeBox = false;
        StartPosition = FormStartPosition.CenterScreen;
        DoubleBuffered = true;
        BackColor = Color.Black;
        KeyPreview = true;

        UpdateWindowSize();

        // Hook raster callbacks
        _bus.OnRasterLine = rasterLine =>
        {
            _rasterRenderer.RenderScanline(rasterLine);
        };

        _bus.OnFrameComplete = () =>
        {
            lock (_bufferLock)
            {
                Array.Copy(_rasterRenderer.Framebuffer, _frontBuffer, 320 * 200);
            }
            _frameCount++;
            if (_fpsStopwatch.ElapsedMilliseconds >= 1000)
            {
                _fps = _frameCount * 1000.0 / _fpsStopwatch.ElapsedMilliseconds;
                _frameCount = 0;
                _fpsStopwatch.Restart();
            }

            try
            {
                if (IsHandleCreated && !IsDisposed)
                {
                    BeginInvoke(new Action(InvalidateDisplay));
                }
            }
            catch (ObjectDisposedException) { }
        };
    }

    private void UpdateWindowSize()
    {
        int targetW = 320 * _scale;
        int targetH = 200 * _scale;
        ClientSize = new Size(targetW, targetH);
        RebuildBitmaps();
        UpdateTitle();
    }

    private void RebuildBitmaps()
    {
        _displayBmp?.Dispose();
        _crtBmp?.Dispose();

        _displayBmp = new Bitmap(320, 200, PixelFormat.Format32bppRgb);
        int scaledW = 320 * _scale;
        int scaledH = 200 * _scale;
        _crtBmp = new Bitmap(scaledW, scaledH, PixelFormat.Format32bppRgb);
    }

    private void InvalidateDisplay()
    {
        UpdateTitle();
        Invalidate();
    }

    private void UpdateTitle()
    {
        string crtStr = _crtEffects ? "ON" : "OFF";
        string modeStr = (_bus.VicRegs[0x11] & 0x20) != 0
            ? ((_bus.VicRegs[0x16] & 0x10) != 0 ? "MC-Bitmap" : "HiRes-Bitmap")
            : ((_bus.VicRegs[0x16] & 0x10) != 0 ? "MC-Char" : "Text");

        Text = $"Commodore 128 | VIC-IIe [{modeStr}] | {_scale}x ({320 * _scale}x{200 * _scale}) | CRT: {crtStr} | FPS: {_fps:F1} | 8502 Cycles: {_totalCycles:N0} | [1-4:Scale C:CRT Space:Fire]";
    }

    protected override void OnPaint(PaintEventArgs e)
    {
        base.OnPaint(e);

        if (_displayBmp == null) return;

        // Copy frontbuffer to GDI+ bitmap
        BitmapData bmpData = _displayBmp.LockBits(
            new Rectangle(0, 0, 320, 200),
            ImageLockMode.WriteOnly,
            PixelFormat.Format32bppRgb);

        unsafe
        {
            lock (_bufferLock)
            {
                fixed (uint* pSrc = _frontBuffer)
                {
                    Buffer.MemoryCopy(pSrc, (void*)bmpData.Scan0, 320 * 200 * sizeof(uint), 320 * 200 * sizeof(uint));
                }
            }
        }
        _displayBmp.UnlockBits(bmpData);

        e.Graphics.InterpolationMode = InterpolationMode.NearestNeighbor;
        e.Graphics.PixelOffsetMode = PixelOffsetMode.Half;

        int destW = 320 * _scale;
        int destH = 200 * _scale;

        if (_crtEffects && _scale > 1 && _crtBmp != null)
        {
            // Apply authentic scanline beam gap and subtle CRT phosphor dimming
            RenderCrtEffect(_displayBmp, _crtBmp, _scale);
            e.Graphics.DrawImage(_crtBmp, 0, 0, destW, destH);
        }
        else
        {
            // Crisp integer-scaled pixels
            e.Graphics.DrawImage(_displayBmp, new Rectangle(0, 0, destW, destH), 0, 0, 320, 200, GraphicsUnit.Pixel);
        }
    }

    private static void RenderCrtEffect(Bitmap src, Bitmap dest, int scale)
    {
        BitmapData srcData = src.LockBits(new Rectangle(0, 0, 320, 200), ImageLockMode.ReadOnly, PixelFormat.Format32bppRgb);
        BitmapData destData = dest.LockBits(new Rectangle(0, 0, 320 * scale, 200 * scale), ImageLockMode.WriteOnly, PixelFormat.Format32bppRgb);

        unsafe
        {
            uint* pSrc = (uint*)srcData.Scan0;
            uint* pDest = (uint*)destData.Scan0;
            int destStride = destData.Stride / 4;

            for (int y = 0; y < 200; y++)
            {
                int destYBase = y * scale;
                for (int x = 0; x < 320; x++)
                {
                    uint color = pSrc[y * 320 + x];
                    uint r = (color >> 16) & 0xFF;
                    uint g = (color >> 8) & 0xFF;
                    uint b = color & 0xFF;

                    // Scanline profile: full brightness on top rows, dimmed on bottom scanline beam gap
                    uint brightColor = (0xFFu << 24) | (r << 16) | (g << 8) | b;
                    uint dimR = (r * 68) / 100;
                    uint dimG = (g * 68) / 100;
                    uint dimB = (b * 68) / 100;
                    uint scanlineColor = (0xFFu << 24) | (dimR << 16) | (dimG << 8) | dimB;

                    int destXBase = x * scale;
                    for (int dy = 0; dy < scale; dy++)
                    {
                        uint c = (dy == scale - 1) ? scanlineColor : brightColor;
                        uint* linePtr = pDest + (destYBase + dy) * destStride + destXBase;
                        for (int dx = 0; dx < scale; dx++)
                        {
                            linePtr[dx] = c;
                        }
                    }
                }
            }
        }

        src.UnlockBits(srcData);
        dest.UnlockBits(destData);
    }

    protected override void OnKeyDown(KeyEventArgs e)
    {
        base.OnKeyDown(e);

        // Scaling options: 1, 2, 3, 4
        if (e.KeyCode == Keys.D1 || e.KeyCode == Keys.NumPad1) { _scale = 1; UpdateWindowSize(); return; }
        if (e.KeyCode == Keys.D2 || e.KeyCode == Keys.NumPad2) { _scale = 2; UpdateWindowSize(); return; }
        if (e.KeyCode == Keys.D3 || e.KeyCode == Keys.NumPad3) { _scale = 3; UpdateWindowSize(); return; }
        if (e.KeyCode == Keys.D4 || e.KeyCode == Keys.NumPad4) { _scale = 4; UpdateWindowSize(); return; }

        // CRT effect toggle: C
        if (e.KeyCode == Keys.C)
        {
            _crtEffects = !_crtEffects;
            UpdateTitle();
            Invalidate();
            return;
        }

        // Joystick 1 Controls
        if (e.KeyCode == Keys.Up || e.KeyCode == Keys.W) _bus.Joystick1 &= 0xFE; // Up / Wheelie
        if (e.KeyCode == Keys.Down || e.KeyCode == Keys.S) _bus.Joystick1 &= 0xFD; // Down / Lean
        if (e.KeyCode == Keys.Left || e.KeyCode == Keys.A) _bus.Joystick1 &= 0xFB; // Left / Brake
        if (e.KeyCode == Keys.Right || e.KeyCode == Keys.D) _bus.Joystick1 &= 0xF7; // Right / Accel
        if (e.KeyCode == Keys.Space || e.KeyCode == Keys.Z || e.KeyCode == Keys.ControlKey)
        {
            _bus.Joystick1 &= 0xEF; // Fire / Jump
        }

        // Keyboard Matrix Register $CB
        byte matrixCode = e.KeyCode switch
        {
            Keys.F1 => 0x04,
            Keys.F3 => 0x05,
            Keys.F5 => 0x06,
            Keys.F7 => 0x03,
            Keys.Enter => 0x01,
            Keys.D1 => 0x38,
            Keys.D2 => 0x3B,
            Keys.D3 => 0x08,
            Keys.D4 => 0x0B,
            Keys.D5 => 0x10,
            Keys.D6 => 0x13,
            Keys.D7 => 0x18,
            Keys.D8 => 0x1B,
            Keys.A => 0x0A,
            Keys.B => 0x1C,
            Keys.C => 0x14,
            Keys.D => 0x12,
            Keys.E => 0x0E,
            Keys.F => 0x15,
            Keys.G => 0x16,
            Keys.H => 0x1D,
            Keys.I => 0x21,
            Keys.J => 0x22,
            Keys.K => 0x25,
            Keys.L => 0x26,
            Keys.M => 0x24,
            Keys.N => 0x27,
            Keys.O => 0x29,
            Keys.P => 0x2A,
            Keys.Q => 0x3E,
            Keys.R => 0x11,
            Keys.S => 0x0D,
            Keys.T => 0x19,
            Keys.U => 0x1E,
            Keys.V => 0x1F,
            Keys.W => 0x09,
            Keys.X => 0x17,
            Keys.Y => 0x1A,
            _ => 0xFF
        };

        if (matrixCode != 0xFF)
        {
            _bus.Ram[0][0x00CB] = matrixCode;
        }
    }

    protected override void OnKeyUp(KeyEventArgs e)
    {
        base.OnKeyUp(e);

        if (e.KeyCode == Keys.Up || e.KeyCode == Keys.W) _bus.Joystick1 |= 0x01;
        if (e.KeyCode == Keys.Down || e.KeyCode == Keys.S) _bus.Joystick1 |= 0x02;
        if (e.KeyCode == Keys.Left || e.KeyCode == Keys.A) _bus.Joystick1 |= 0x04;
        if (e.KeyCode == Keys.Right || e.KeyCode == Keys.D) _bus.Joystick1 |= 0x08;
        if (e.KeyCode == Keys.Space || e.KeyCode == Keys.Z || e.KeyCode == Keys.ControlKey)
        {
            _bus.Joystick1 |= 0x10;
        }

        // Release keyboard matrix code
        _bus.Ram[0][0x00CB] = 0x40; // 64 = No key pressed
    }

    protected override void OnFormClosing(FormClosingEventArgs e)
    {
        _running = false;
        base.OnFormClosing(e);
    }

    public void StartEmulationThread()
    {
        _running = true;
        _emuThread = new Thread(EmulationLoop)
        {
            IsBackground = true,
            Priority = ThreadPriority.AboveNormal
        };
        _emuThread.Start();
    }

    private void EmulationLoop()
    {
        // Target: PAL 50.0 Hz (19,704 cycles per frame at 0.985 MHz)
        const int cyclesPerFrame = 19704;
        const double msPerFrame = 20.0;

        _frameTimer.Start();

        while (_running)
        {
            long startMs = _frameTimer.ElapsedMilliseconds;

            if (_stepFrameCallback != null)
            {
                if (!_stepFrameCallback(cyclesPerFrame))
                    break;
            }

            _totalCycles += cyclesPerFrame;

            long elapsedMs = _frameTimer.ElapsedMilliseconds - startMs;
            int sleepMs = (int)(msPerFrame - elapsedMs);
            if (sleepMs > 0)
            {
                Thread.Sleep(sleepMs);
            }
            else
            {
                Thread.Yield();
            }
        }
    }
}
