using Xunit;
using Commodore128.Emulator;

namespace Commodore128.Tests;

public class CiaTimerAndTodTests
{
    [Fact]
    public void Cia1_TimerA_UnderflowGeneratesInterrupt()
    {
        var bus = new MemoryBus(".");

        // Set Timer A latch to 10 ($DC04 = 10, $DC05 = 0)
        bus.Write8(0xDC04, 10);
        bus.Write8(0xDC05, 0);

        // Enable Timer A interrupt in ICR ($DC0D = 0x81: set bit 7 and bit 0)
        bus.Write8(0xDC0D, 0x81);

        // Start Timer A in CRA ($DC0E = 0x01)
        bus.Write8(0xDC0E, 0x01);

        // Step 5 cycles: timer decreases, no underflow yet
        bus.StepCycles(5);
        Assert.False((bus.Cia1IcrData & 0x80) != 0);

        // Step 10 more cycles: timer underflows
        bus.StepCycles(10);
        Assert.True((bus.Cia1IcrData & 0x80) != 0, "Timer A underflow should assert ICR bit 7");
        Assert.True((bus.Cia1IcrData & 0x01) != 0, "Timer A underflow should assert ICR bit 0");
    }

    [Fact]
    public void Cia1_TodClock_CountsTenthsAndRollsOver()
    {
        var bus = new MemoryBus(".")
        {
            TodHours = 12,
            TodMinutes = 0,
            TodSeconds = 59,
            TodTenths = 9,
            TodIsPm = false,
            TodStopped = false
        };

        // Advance 100,000 cycles (~1/10th second at 1 MHz)
        bus.StepCycles(100_000);

        // Tenths should roll over to 0, Seconds to 0, Minutes to 1
        Assert.Equal(0, bus.TodTenths);
        Assert.Equal(0, bus.TodSeconds);
        Assert.Equal(1, bus.TodMinutes);
        Assert.Equal(12, bus.TodHours);
    }
}
