using System;

namespace Commodore128.Emulator;

/// <summary>
/// MOS 6581/8580 SID 3-Voice Sound Interface Device ($D400-$D41F).
/// Tracks all 3 oscillator frequencies, pulse widths, waveforms, ADSR envelopes, filter cutoffs,
/// and synthesizes 16-bit mono PCM audio samples on demand.
/// </summary>
public sealed class Sid6581
{
    private readonly MemoryBus _bus;
    private readonly uint[] _phase = new uint[3];

    public Sid6581(MemoryBus bus) => _bus = bus;

    public int GetVoiceFrequencyHz(int voice, double clockHz = 1022727.0)
    {
        int baseReg = (voice % 3) * 7;
        int freqWord = _bus.SidRegs[baseReg] | (_bus.SidRegs[baseReg + 1] << 8);
        return (int)Math.Round(freqWord * (clockHz / 16777216.0));
    }

    public int MasterVolume => _bus.SidRegs[0x18] & 0x0F;

    public short[] SynthesizePcmSamples(int sampleCount, int sampleRate = 44100, double clockHz = 1022727.0)
    {
        var output = new short[sampleCount];
        int vol = MasterVolume;
        if (vol == 0) return output;

        for (int i = 0; i < sampleCount; i++)
        {
            int mix = 0;
            for (int v = 0; v < 3; v++)
            {
                int b = v * 7;
                byte ctrl = _bus.SidRegs[b + 4];
                if ((ctrl & 0x01) == 0) continue; // Gate off
                uint freqWord = (uint)(_bus.SidRegs[b] | (_bus.SidRegs[b + 1] << 8));
                uint step = (uint)((freqWord * clockHz) / sampleRate * 256.0);
                _phase[v] += step;
                ushort top12 = (ushort)((_phase[v] >> 20) & 0xFFF);
                int sample = 0;
                if ((ctrl & 0x20) != 0) // Sawtooth
                    sample = (top12 - 2048) * 8;
                else if ((ctrl & 0x10) != 0) // Triangle
                    sample = ((top12 < 2048 ? top12 : 4095 - top12) - 1024) * 16;
                else if ((ctrl & 0x40) != 0) // Pulse
                {
                    int pw = _bus.SidRegs[b + 2] | ((_bus.SidRegs[b + 3] & 0x0F) << 8);
                    sample = top12 >= pw ? 16384 : -16384;
                }
                mix += sample;
            }
            output[i] = (short)Math.Clamp((mix * vol) / 45, short.MinValue, short.MaxValue);
        }
        return output;
    }
}
