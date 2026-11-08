using System;
using System.Collections.Generic;

namespace Commodore128.Emulator;

/// <summary>
/// C128 11x8 Keyboard Matrix Controller ($DC00 standard rows 0-7, $D02F extended rows 8-10, $DC01 columns 0-7).
/// Supports physical matrix key press/release, RUN/STOP, Function Keys F1-F8, and PETSCII input queuing.
/// </summary>
public sealed class KeyboardController
{
    private readonly MemoryBus _bus;
    private readonly Queue<byte> _petsciiQueue = new();

    public KeyboardController(MemoryBus bus) => _bus = bus;

    public bool HasPendingInput => _petsciiQueue.Count > 0;

    public void ClearQueue()
    {
        _petsciiQueue.Clear();
        _bus.Ram[0][0x00D0] = 0;
    }

    public void PressMatrixKey(int row, int col)
    {
        if (row is >= 0 and < 11 && col is >= 0 and < 8)
            _bus.KeyMatrix[row] &= (byte)~(1 << col);
    }

    public void ReleaseMatrixKey(int row, int col)
    {
        if (row is >= 0 and < 11 && col is >= 0 and < 8)
            _bus.KeyMatrix[row] |= (byte)(1 << col);
    }

    public void ReleaseAllKeys()
    {
        for (int i = 0; i < 11; i++) _bus.KeyMatrix[i] = 0xFF;
    }

    public void SetRunStopPressed(bool pressed)
    {
        if (pressed) PressMatrixKey(7, 7);
        else ReleaseMatrixKey(7, 7);
    }

    public void EnqueueText(string text)
    {
        foreach (char ch in text)
        {
            byte b = ch == '\n' ? (byte)0x0D : (byte)char.ToUpperInvariant(ch);
            _petsciiQueue.Enqueue(b);
        }
    }

    public void FeedKernalBuffer()
    {
        if (_petsciiQueue.Count == 0) return;
        byte ndx = _bus.Ram[0][0x00D0];
        byte xmax = _bus.Ram[0][0x0A20];
        if (xmax == 0) xmax = 10;
        while (_petsciiQueue.Count > 0 && ndx < xmax)
        {
            _bus.Ram[0][0x034A + ndx] = _petsciiQueue.Dequeue();
            ndx++;
            _bus.Ram[0][0x00D0] = ndx;
        }
    }

    public void FeedCpmBuffer()
    {
        if (_petsciiQueue.Count == 0) return;
        if (_bus.Ram[0][0x2471] == 0)
        {
            _bus.Ram[0][0x2471] = _petsciiQueue.Dequeue();
        }
    }
}
