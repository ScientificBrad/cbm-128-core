using System;
using Xunit;
using Commodore128.Emulator;

namespace Commodore128.Tests;

public class Cpu8502Tests
{
    [Fact]
    public void Adc_Immediate_ComputesSumAndFlagsCorrectly()
    {
        var bus = new MemoryBus("."); // Can use dummy or real
        // Initialize simple RAM
        bus.Ram[0][0x1000] = 0x69; // ADC #$15
        bus.Ram[0][0x1001] = 0x15;

        var cpu = new Cpu8502(bus)
        {
            ResetPending = false,
            Pc = 0x1000,
            A = 0x20,
            P = 0x00
        };

        cpu.Step();

        Assert.Equal(0x35, cpu.A);
        Assert.Equal(0x1002, cpu.Pc);
        Assert.False((cpu.P & Cpu8502.FlagC) != 0);
        Assert.False((cpu.P & Cpu8502.FlagZ) != 0);
        Assert.False((cpu.P & Cpu8502.FlagN) != 0);
    }

    [Fact]
    public void NmiVector_PushesPcAndPWithProperFlags()
    {
        var bus = new MemoryBus();
        bus.Write8(0xFF00, 0x3F); // Bank 0 all RAM

        bus.Ram[0][0xFFFA] = 0x00;
        bus.Ram[0][0xFFFB] = 0x30; // NMI -> $3000

        var cpu = new Cpu8502(bus)
        {
            ResetPending = false,
            Pc = 0x2050,
            Sp = 0xFD,
            P = Cpu8502.FlagU | Cpu8502.FlagC, // $21
            NmiPending = true
        };

        int cyc = cpu.Step(); // NMI interrupt sequence: 7 cycles

        Assert.Equal(7, cyc);
        Assert.Equal(0x3000, cpu.Pc);
        Assert.Equal(0xFA, cpu.Sp);
        Assert.True((cpu.P & Cpu8502.FlagI) != 0); // Interrupt flag set on NMI

        // Check stack frame
        byte pushedP = bus.Ram[0][0x01FB];
        ushort pushedPc = (ushort)(bus.Ram[0][0x01FC] | (bus.Ram[0][0x01FD] << 8));
        Assert.Equal(0x2050, pushedPc);
        Assert.Equal(0, pushedP & Cpu8502.FlagB); // Break flag must be 0 for hardware NMI
        Assert.NotEqual(0, pushedP & Cpu8502.FlagU); // Unused bit 5 must be 1
    }
}
