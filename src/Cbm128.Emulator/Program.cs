using System;
using System.Collections.Generic;
using Cbm128.Core;

namespace Cbm128.Emulator;

public static class Program
{
    public static int Main(string[] args)
    {
        string romDir = args.Length > 0 ? args[0] : @"D:\Emulation\C128";
        var bus = new C128MmuAndPeripherals(romDir);
        var z80 = new ZilogZ80Cpu(bus);
        var m8502 = new Mos8502Cpu(bus);

        long totalCycles = 0;
        while (totalCycles < 3_000_000)
        {
            for (int i = 0; i < 1000; i++)
            {
                int cyc = bus.IsZ80Active ? z80.Step() : m8502.Step();
                bus.StepCycles(cyc);
                totalCycles += cyc;
            }
            string screen = bus.Render40ColScreenAscii();
            if (screen.Contains("READY."))
            {
                Console.WriteLine($"[cbm-128-core .NET 8] Booted to READY. in {totalCycles} cycles (Z80 steps: {z80.InstructionsExecuted}, 8502 steps: {m8502.InstructionsExecuted})");
                Console.WriteLine(screen);
                return 0;
            }
        }
        Console.Error.WriteLine("Timeout waiting for READY.");
        return 1;
    }
}
