using System.Collections.Generic;

namespace Commodore128.Debugger;

public sealed class BreakpointManager
{
    private readonly HashSet<ushort> _pcBreakpoints = new();
    public bool Enabled { get; set; } = true;

    public void AddBreakpoint(ushort address) => _pcBreakpoints.Add(address);
    public void RemoveBreakpoint(ushort address) => _pcBreakpoints.Remove(address);
    public void Clear() => _pcBreakpoints.Clear();
    public IReadOnlyCollection<ushort> Breakpoints => _pcBreakpoints;

    public bool ShouldBreak(ushort pc) => Enabled && _pcBreakpoints.Contains(pc);
}
