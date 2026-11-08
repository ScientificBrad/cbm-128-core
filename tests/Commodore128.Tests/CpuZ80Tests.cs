using Xunit;
using Commodore128.Emulator;

namespace Commodore128.Tests;

public class CpuZ80Tests
{
    [Fact]
    public void Z80_Registers_PairAccess_WorksCorrectly()
    {
        var bus = new MemoryBus(".");
        var z80 = new CpuZ80(bus);

        z80.Bc = 0x1234;
        Assert.Equal(0x12, z80.B);
        Assert.Equal(0x34, z80.C);

        z80.De = 0x5678;
        Assert.Equal(0x56, z80.D);
        Assert.Equal(0x78, z80.E);

        z80.Hl = 0x9ABC;
        Assert.Equal(0x9A, z80.H);
        Assert.Equal(0xBC, z80.L);

        z80.Af = 0xDEF0;
        Assert.Equal(0xDE, z80.A);
        Assert.Equal(0xF0, z80.F);
    }

    [Fact]
    public void Z80_Ldir_TransfersBlockOfMemory()
    {
        var bus = new MemoryBus(".");
        // Set MMU to Bank 0 RAM
        bus.Cr = 0x3F;

        // Source block at $2000
        bus.Ram[0][0x2000] = 0xAA;
        bus.Ram[0][0x2001] = 0xBB;
        bus.Ram[0][0x2002] = 0xCC;

        // LDIR code at $1000: ED B0
        bus.Ram[0][0x1000] = 0xED;
        bus.Ram[0][0x1001] = 0xB0;

        var z80 = new CpuZ80(bus)
        {
            Pc = 0x1000,
            Hl = 0x2000, // Source
            De = 0x3000, // Dest
            Bc = 3       // Count: 3 bytes
        };

        // LDIR steps through each byte until BC=0
        while (z80.Bc > 0)
        {
            z80.Step();
        }

        Assert.Equal(0xAA, bus.Ram[0][0x3000]);
        Assert.Equal(0xBB, bus.Ram[0][0x3001]);
        Assert.Equal(0xCC, bus.Ram[0][0x3002]);
        Assert.Equal(0, z80.Bc);
        Assert.Equal(0x2003, z80.Hl);
        Assert.Equal(0x3003, z80.De);
    }
}
