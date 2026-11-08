using System.Collections.Generic;

namespace Commodore128.Debugger;

public sealed record TraceEvent(
    long Cycle,
    string Cpu,
    ushort Pc,
    byte Opcode,
    byte Cr,
    byte Mcr);

public sealed class ExecutionTracer
{
    private readonly List<TraceEvent> _events = new();
    public bool Enabled { get; set; }
    public int MaxEvents { get; set; } = 10000;
    public IReadOnlyList<TraceEvent> Events => _events;

    public void Record(long cycle, string cpu, ushort pc, byte opcode, byte cr, byte mcr)
    {
        if (!Enabled) return;
        if (_events.Count >= MaxEvents) _events.RemoveAt(0);
        _events.Add(new TraceEvent(cycle, cpu, pc, opcode, cr, mcr));
    }

    public void Clear() => _events.Clear();
}
