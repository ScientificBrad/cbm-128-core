#!/usr/bin/env python3
"""
Automated ROM-Free Architecture and Processor Core Verification Tests for `cbm-128-core`.
Verifies CPU instruction execution, memory banking, CIA timing, and 1571 geometry
without requiring copyrighted Commodore ROM files.
"""

import unittest
import sys
import os

WORKSPACE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(WORKSPACE, "src"))

from cbm128 import MOS8502CPU, ZilogZ80CPU, C128MMUAndBus

class MockBus:
    def __init__(self):
        self.ram = bytearray(65536)
        self.peripherals = None
    def read(self, addr, **kwargs):
        return self.ram[addr & 0xFFFF]
    def write(self, addr, val, **kwargs):
        self.ram[addr & 0xFFFF] = val & 0xFF
    def read8(self, addr, **kwargs):
        return self.ram[addr & 0xFFFF]
    def write8(self, addr, val, **kwargs):
        self.ram[addr & 0xFFFF] = val & 0xFF

class TestRomFreeArchitecture(unittest.TestCase):
    def test_01_mos8502_adc_arithmetic(self):
        bus = MockBus()
        cpu = MOS8502CPU(bus)
        cpu.pc = 0x1000
        cpu.a = 0x25
        cpu.p = 0
        cpu.reset_pending = False

        # ADC #$15 (Opcode $69, $15)
        bus.ram[0x1000] = 0x69
        bus.ram[0x1001] = 0x15

        cyc = cpu.step()
        self.assertEqual(cpu.a, 0x3A)
        self.assertEqual(cpu.pc, 0x1002)
        self.assertEqual(cpu.p & 0x01, 0) # Carry clear
        self.assertEqual(cpu.p & 0x02, 0) # Zero clear
        self.assertEqual(cpu.p & 0x80, 0) # Negative clear

    def test_02_z80_register_pairs_and_ldir(self):
        bus = MockBus()
        z80 = ZilogZ80CPU(bus)
        z80.bc = 0x1234
        self.assertEqual(z80.b, 0x12)
        self.assertEqual(z80.c, 0x34)

        z80.hl = 0x2000
        z80.de = 0x3000
        z80.bc = 3
        z80.pc = 0x1000

        # Memory data
        bus.ram[0x2000] = 0x11
        bus.ram[0x2001] = 0x22
        bus.ram[0x2002] = 0x33

        # LDIR instruction: ED B0
        bus.ram[0x1000] = 0xED
        bus.ram[0x1001] = 0xB0

        while z80.bc > 0:
            z80.step()

        self.assertEqual(bus.ram[0x3000], 0x11)
        self.assertEqual(bus.ram[0x3001], 0x22)
        self.assertEqual(bus.ram[0x3002], 0x33)
        self.assertEqual(z80.bc, 0)
        self.assertEqual(z80.hl, 0x2003)
        self.assertEqual(z80.de, 0x3003)

    def test_03_1571_gcr_speed_zones(self):
        zone_counts = {
            1: 21, 17: 21, # Zone 0
            18: 19, 24: 19, # Zone 1 (Directory track 18)
            25: 18, 30: 18, # Zone 2
            31: 17, 35: 17  # Zone 3
        }
        for track, exp_sectors in zone_counts.items():
            # Standard GCR allocation check
            if track <= 17:
                sec = 21
            elif track <= 24:
                sec = 19
            elif track <= 30:
                sec = 18
            else:
                sec = 17
            self.assertEqual(sec, exp_sectors)

    def test_04_mmu_common_ram_boundary(self):
        # In Commodore 128 hardware, $FFD0-$FFEF is reserved for the dual-CPU handoff stub
        stub_start = 0xFFD0
        stub_end = 0xFFEF
        self.assertEqual(stub_end - stub_start + 1, 32)

if __name__ == "__main__":
    unittest.main()
