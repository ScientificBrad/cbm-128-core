using System;
using System.Text;
using Commodore128.Emulator;

namespace Commodore128.Debugger;

public sealed class MemoryInspector
{
    private readonly MemoryBus _bus;
    public MemoryInspector(MemoryBus bus) => _bus = bus;

    public byte ReadCpuVisible(ushort addr, bool z80Mode = false) => _bus.Read8(addr, z80Mode);
    public byte ReadPhysicalRam(int bank, ushort addr) => _bus.Ram[bank & 1][addr];

    public string HexDump(ushort startAddr, int length, int? bank = null)
    {
        var sb = new StringBuilder();
        for (int off = 0; off < length; off += 16)
        {
            ushort rowAddr = (ushort)(startAddr + off);
            sb.Append($"{rowAddr:X4}: ");
            int rowLen = Math.Min(16, length - off);
            for (int i = 0; i < 16; i++)
            {
                if (i < rowLen)
                {
                    byte b = bank.HasValue ? ReadPhysicalRam(bank.Value, (ushort)(rowAddr + i)) : ReadCpuVisible((ushort)(rowAddr + i));
                    sb.Append($"{b:X2} ");
                }
                else sb.Append("   ");
            }
            sb.Append(" |");
            for (int i = 0; i < rowLen; i++)
            {
                byte b = bank.HasValue ? ReadPhysicalRam(bank.Value, (ushort)(rowAddr + i)) : ReadCpuVisible((ushort)(rowAddr + i));
                sb.Append(b is >= 32 and <= 126 ? (char)b : '.');
            }
            sb.AppendLine("|");
        }
        return sb.ToString();
    }
}
