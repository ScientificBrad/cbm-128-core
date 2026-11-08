#!/usr/bin/env python3
"""
Command-line runner for the `cbm-128-core` Commodore 128 Emulator.
Boots the genuine 1985 ROM set from Z80 reset ($0000) through 8502 KERNAL & BASIC 7.0 initialization,
supports `--command` batch execution or `--interactive` terminal mode, and renders 40-column VIC-IIe
or 80-column 8563 VDC output.
"""

import os
import sys
import argparse

WORKSPACE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(WORKSPACE, "src"))

from cbm128 import Commodore128Machine

def main():
    parser = argparse.ArgumentParser(description="cbm-128-core: Commodore 128 (1985) Dual-CPU Firmware Emulator")
    parser.add_argument("--rom-dir", default=WORKSPACE, help="Directory containing the 5 original C128 ROM binaries")
    parser.add_argument("--command", "-c", default="", help="BASIC 7.0 or ML Monitor commands to execute after reaching READY. (use \\n for Enter)")
    parser.add_argument("--cycles", type=int, default=800_000, help="Cycles to execute after injecting --command")
    parser.add_argument("--vdc80", action="store_true", help="Also dump 80-column 8563 VDC screen buffer")
    args = parser.parse_args()

    machine = Commodore128Machine(args.rom_dir)
    machine.reset()
    ok = machine.run_until_ready(max_cycles=3_000_000)
    print(f"[cbm-128-core] Booted={ok} | Total Cycles={machine.total_cycles:,} | Z80 Steps={machine.z80_steps:,} | 8502 Steps={machine.m8502_steps:,}")
    print(f"[cbm-128-core] Bus Handoffs={machine.cpu_switches}")

    if args.command:
        cmd_str = args.command.replace("\\n", "\r").replace("\n", "\r")
        if not cmd_str.endswith("\r"):
            cmd_str += "\r"
        lines = [l for l in cmd_str.split("\r") if l]
        per_line_cycles = max(250_000, args.cycles // max(1, len(lines)))
        for line in lines:
            machine.peripherals.inject_petscii(line + "\r")
            machine.run_cycles(per_line_cycles)

    print("\n" + "=" * 44)
    print("  VIC-IIe 40-COLUMN DISPLAY ($0400-$07E7)")
    print("=" * 44)
    for line in machine.peripherals.render_40col_screen_ascii():
        print(f"  |{line:<40s}|")
    print("=" * 44)

    if args.vdc80:
        print("\n" + "=" * 84)
        print("  8563 VDC 80-COLUMN DISPLAY (VRAM $0000-$07CF)")
        print("=" * 84)
        for line in machine.peripherals.render_80col_vdc_ascii():
            if line.strip():
                print(f"  |{line:<80s}|")
        print("=" * 84)

if __name__ == "__main__":
    main()
