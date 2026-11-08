using Xunit;
using Commodore128.Emulator;

namespace Commodore128.Tests;

public class MmuAndMemoryBusTests
{
    [Fact]
    public void Mmu_Cr_ConfiguresRamBanks()
    {
        var bus = new MemoryBus(".");

        // Set to Bank 0 all RAM (Cr = $3F = 00111111)
        bus.Write8(0xFF00, 0x3F);
        Assert.Equal(0x3F, bus.Read8(0xFF00));

        // Write to $2000 in Bank 0
        bus.Write8(0x2000, 0x42);
        Assert.Equal(0x42, bus.Read8(0x2000));
        Assert.Equal(0x42, bus.Ram[0][0x2000]);
        Assert.Equal(0x00, bus.Ram[1][0x2000]);

        // Switch to Bank 1 (Cr = $7F = 01111111)
        bus.Write8(0xFF00, 0x7F);
        Assert.Equal(0x7F, bus.Read8(0xFF00));

        // Write to $2000 in Bank 1
        bus.Write8(0x2000, 0x99);
        Assert.Equal(0x99, bus.Read8(0x2000));
        Assert.Equal(0x99, bus.Ram[1][0x2000]);
        Assert.Equal(0x42, bus.Ram[0][0x2000]); // Bank 0 unchanged
    }

    [Fact]
    public void CommonRam_AlwaysMapsToBank0_AtFFD0()
    {
        var bus = new MemoryBus(".");

        // In Bank 1, addresses $FFD0-$FFEF must always read and write Bank 0 RAM
        bus.Write8(0xFF00, 0x7F); // Bank 1

        bus.Write8(0xFFD0, 0x55);
        Assert.Equal(0x55, bus.Ram[0][0xFFD0]);
        Assert.Equal(0x55, bus.Read8(0xFFD0));
    }

    [Fact]
    public void C64Mode_SuppressesMmuWritesToFF00()
    {
        var bus = new MemoryBus(".");
        bus.IsC64Mode = true;
        bus.SuppressMmuWrites = true;

        // Writing to $FF00 in C64 mode should write into underlying RAM Bank 0, not alter Cr
        bus.Cr = 0x3E;
        bus.Write8(0xFF00, 0xAA);

        Assert.Equal(0x3E, bus.Cr); // Cr unmodified
        Assert.Equal(0xAA, bus.Ram[0][0xFF00]); // Written into RAM
    }
}
