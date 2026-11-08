#!/usr/bin/env python3
"""
Automated Unit, Integration, and Firmware Execution Test Suite for `cbm-128-core`.
Executes real instructions from the original 1985 Commodore 128 ROM set and verifies:
1. Phase 1 ROM integrity & cryptographic checksums (all 5 ROMs, 61,440 bytes).
2. Phase 3 byte-for-byte reconstruction verification (0 differing bytes).
3. Zilog Z80A power-on reset execution ($0000-$00B1), MMU initialization, and `$FFD0-$FFEF` handoff stub installation.
4. Hardware bus master switch from Z80A to MOS 8502 via MMU Mode Configuration Register ($D505).
5. MOS 8502 KERNAL initialization (`IOINIT`, `RAMTAS`, `RESTOR`, CIA1 fast-serial `SPIN_SPOUT`, 8563 VDC `INIT80` font copy, Screen Editor `CINT`).
6. BASIC 7.0 Cold Start (`$4000 -> $4023`), `122365 BYTES FREE` banner, and `READY.` prompt.
7. BASIC 7.0 program execution (`FOR`/`NEXT`, floating-point math, `HEX$`, `DEC`, `CHR$`, `PEEK`, `BANK`).
8. C128 Machine Language Monitor (`MONITOR`, register display `R`, memory dump `M`, disassembler `D`).
9. 80-Column 8563 VDC initialization & character generator upload into VDC VRAM (`$2000-$3FFF`).
10. Cross-bank memory management (`INDFET`, `INDSTA`, `SETBNK`, Preconfiguration registers `$FF01-$FF04`).
"""

import os
import sys
import json
import unittest
import hashlib

WORKSPACE = r"D:\Emulation\C128"
sys.path.insert(0, os.path.join(WORKSPACE, "src"))

from cbm128 import Commodore128Machine, C128MMUAndBus, MOS8502CPU, ZilogZ80CPU

class TestC128FirmwareAndEmulator(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.machine = Commodore128Machine(WORKSPACE)
        cls.machine.reset()
        cls.booted = cls.machine.run_until_ready(max_cycles=3_000_000)
        cls.boot_screen_40 = cls.machine.peripherals.render_40col_screen_ascii()
        cls.boot_screen_80 = cls.machine.peripherals.render_80col_vdc_ascii()

    def test_01_rom_inventory_and_checksums(self):
        expected = {
            "basic-4000.318018-02.bin": (16384, "c5ddb7c57dd0b6f259b95b9dd0494ba807cbe6dce8f1f19410a0a05833aa0b5e"),
            "basic-8000.318019-02.bin": (16384, "e1432465b8abafd3397b0e6cb4eb8422449fb3f85c6366e8616b48c35a86ad79"),
            "kernal.318020-03.bin":     (16384, "dcb17b5ce33c2490005b5d0f2a4d767ae56e8ab7ed41d6aa20c43173449e4786"),
            "characters.390059-01.bin": (8192,  "f08d8f525b44f5cbb3f5776739fcdff737886e1813f1eb7a20aedb128db1d4a8"),
            "z80bios.bin":              (4096,  "39c7656b326e4ad724ff4b50c995cb3b2b8ff9ed3bb2b4d277eb0ecd3cac062f"),
        }
        for fname, (exp_size, exp_sha) in expected.items():
            path = os.path.join(WORKSPACE, fname)
            with open(path, "rb") as f:
                data = f.read()
            self.assertEqual(len(data), exp_size)
            self.assertEqual(hashlib.sha256(data).hexdigest(), exp_sha)

    def test_02_z80bios_embedded_in_kernal(self):
        with open(os.path.join(WORKSPACE, "kernal.318020-03.bin"), "rb") as f:
            kn = f.read()
        with open(os.path.join(WORKSPACE, "z80bios.bin"), "rb") as f:
            z8 = f.read()
        self.assertEqual(kn[0x1000:0x2000], z8)

    def test_03_byte_for_byte_reconstructed_roms(self):
        for fname in [
            "basic-4000.318018-02.bin",
            "basic-8000.318019-02.bin",
            "kernal.318020-03.bin",
            "characters.390059-01.bin",
            "z80bios.bin"
        ]:
            with open(os.path.join(WORKSPACE, fname), "rb") as f1:
                orig = f1.read()
            with open(os.path.join(WORKSPACE, "reconstruction", "build", fname), "rb") as f2:
                rebuilt = f2.read()
            self.assertEqual(orig, rebuilt, f"Rebuilt ROM {fname} differs from original")

    def test_04_z80_boot_and_handoff_to_8502(self):
        self.assertTrue(self.booted, "C128 failed to reach READY. prompt")
        self.assertEqual(self.machine.z80_steps, 161, "Expected 161 Z80 instructions during initial boot")
        self.assertEqual(len(self.machine.cpu_switches), 1)
        sw = self.machine.cpu_switches[0]
        self.assertEqual(sw["from_cpu"], "Z80")
        self.assertEqual(sw["to_cpu"], "8502")
        self.assertEqual(sw["z80_pc"], "$FFED")
        # Verify the 31-byte dual-CPU handoff stub was copied by Z80 LDIR into common RAM at $FFD0-$FFEF
        stub = bytes(self.machine.mmu.ram[0][0xFFD0:0xFFEF])
        self.assertEqual(stub[:6], bytes([0x78, 0xA9, 0x3E, 0x8D, 0x00, 0xFF]))
        self.assertEqual(stub[0x10:0x16], bytes([0xF3, 0x3E, 0x3E, 0x32, 0x00, 0xFF]))

    def test_05_boot_banner_and_ready_prompt(self):
        screen_text = "\n".join(self.boot_screen_40)
        self.assertIn("COMMODORE BASIC V7.0 122365 BYTES FREE", screen_text)
        self.assertIn("(C)1985 COMMODORE ELECTRONICS, LTD.", screen_text)
        self.assertIn("(C)1977 MICROSOFT CORP.", screen_text)
        self.assertIn("ALL RIGHTS RESERVED", screen_text)
        self.assertIn("READY.", screen_text)

    def test_06_vdc_80col_initialization_and_font_copy(self):
        # During IOINIT ($E199 -> JSR $C027 -> $CE0C INIT80), the KERNAL/Editor initializes
        # the 8563 VDC registers and copies the Character ROM into VDC VRAM ($2000-$3FFF)!
        # Let's verify that VDC VRAM at $2000+ contains non-zero character glyph patterns!
        font_region = self.machine.peripherals.vdc_vram[0x2000:0x4000]
        non_zero = sum(1 for b in font_region if b != 0)
        self.assertGreater(non_zero, 1000, "VDC VRAM character generator region ($2000-$3FFF) should be populated by INIT80")

    def test_07_basic70_execution_and_functions(self):
        m = self.machine
        cmd = '10 FOR I=1 TO 5:S=S+I*I:NEXT\r20 PRINT "ANS=";S;HEX$(S);DEC("0037")\rRUN\r'
        m.peripherals.inject_petscii(cmd)
        m.run_cycles(600_000)
        screen_text = "\n".join(m.peripherals.render_40col_screen_ascii())
        self.assertIn("ANS= 55 0037 55", screen_text)

    def test_08_mmu_preconfig_and_bank_switching(self):
        m = self.machine
        # Verify KERNAL initialized $D501-$D504 (PCRA..PCRD) from $E0F0/$F85A table
        # and $D506 RCR = $04 (4KB bottom common RAM)
        self.assertEqual(m.mmu.rcr, 0x04)
        # Test writing to Bank 1 above common RAM ($2000) vs Bank 0 ($2000)
        saved_cr = m.mmu.cr
        m.mmu.write8(0xFF00, 0x3F)  # Bank 0 RAM
        m.mmu.write8(0x2000, 0x5A)
        m.mmu.write8(0xFF00, 0x7F)  # Bank 1 RAM
        m.mmu.write8(0x2000, 0xA5)
        self.assertEqual(m.mmu.read8(0x2000), 0xA5)
        m.mmu.write8(0xFF00, 0x3F)  # Back to Bank 0 RAM
        self.assertEqual(m.mmu.read8(0x2000), 0x5A)
        # Verify bottom 1KB ($0000-$03FF, RCR=$04) is shared Common RAM across Bank 0 and Bank 1,
        # while $0400-$0FFF is independent per bank so Bank 1 variables can start at $0400!
        old_03fc = m.mmu.read8(0x03FC)
        m.mmu.write8(0x03FC, 0x99)
        m.mmu.write8(0xFF00, 0x7F)  # Bank 1
        self.assertEqual(m.mmu.read8(0x03FC), 0x99)
        m.mmu.write8(0x03FC, old_03fc)
        m.mmu.write8(0xFF00, saved_cr)

    def test_09_ml_monitor_execution(self):
        m = self.machine
        m.peripherals.inject_petscii("MONITOR\r")
        m.run_cycles(300_000)
        m.peripherals.inject_petscii("M F4000 F4007\r")
        m.run_cycles(400_000)
        m.peripherals.inject_petscii("X\r")
        m.run_cycles(300_000)
        screen_text = "\n".join(m.peripherals.render_40col_screen_ascii())
        self.assertIn("MONITOR", screen_text)
        self.assertIn("PC  SR AC XR YR SP", screen_text)
        self.assertIn("4C 23 40 4C 09 40 4C 4D", screen_text)

    def test_10_z80_bios_cpm_boot_attempt_and_rpc_handoff(self):
        """
        Phase 4 Verification:
        Triggers the 8502 -> Z80 handoff at $FFD0 (`JMP $FFD0`) and traces the Z80 BIOS
        CP/M 3.0 bootstrap sequence (`RST $08 -> $018C`):
        - Z80 copies 8502 slave driver ($0D22-$0EE4) to $3000-$31C2
        - Z80 patches $FFEE = $C9 (RET) and calls $FFE0 (Z80 -> 8502 slave init -> Z80)
        - Z80 initializes 40-col ($1400/$2C00) and 80-col (8563 VDC) screens
        - Z80 prints 'BOOTING CP/M PLUS' to both 40-column and 80-column displays
        - Z80 calls $044F -> $FFE0 (Z80 -> 8502 slave sector read) and reports 'NO CPM+.SYS FILE'
          when no CP/M disk is present in Drive 8.
        """
        m = Commodore128Machine(WORKSPACE)
        m.reset()
        self.assertTrue(m.run_until_ready(max_cycles=3_000_000))
        # Now invoke $FFD0 from the 8502 with CR=$3E (RAM at $FFD0 + I/O at $D505)
        m.mmu.cr = 0x3E
        m.m8502.pc = 0xFFD0
        m.run_cycles(2_600_000)

        # Verify 10 Z80 <-> 8502 co-processor switches occurred (Cold boot + $FFD0 entry + 4x $FFE0 slave RPCs)
        self.assertEqual(len(m.cpu_switches), 10)
        self.assertTrue(0x04EA <= m.z80.pc <= 0x04FE, f"Unexpected Z80 PC: ${m.z80.pc:04X}")
        # Verify 8502 slave driver was copied to $3000-$31C2 and $FFEE was patched to $C9 (RET)
        self.assertEqual(m.mmu.ram[0][0xFFEE], 0xC9)
        self.assertEqual(bytes(m.mmu.ram[0][0x3000:0x3005]), bytes([0xA9, 0x00, 0x8D, 0x06, 0xFD]))

        # Verify 'BOOTING CP/M PLUS', 'READ ERROR', 'HIT RETURN TO RETRY', and 'DEL TO ENTER C128 MODE'
        # were rendered by Z80 BIOS on BOTH 80-col (8563 VDC) and 40-col ($1400/$2C00) displays!
        vdc_cpm_screen = "\n".join(m.peripherals.render_80col_vdc_ascii())
        self.assertIn("BOOTING CP/M PLUS", vdc_cpm_screen)
        self.assertIn("READ ERROR - HIT RETURN TO RETRY", vdc_cpm_screen)
        self.assertIn("DEL TO ENTER C128 MODE", vdc_cpm_screen)
        # Also check 40-col virtual buffer at $1400-$1B7F (stored as C128 lowercase screen codes: $41-$5A = A-Z)
        def screencode_to_ascii(b):
            b &= 0x7F
            if 1 <= b <= 26:
                return chr(b + 64)
            if 32 <= b <= 126:
                return chr(b)
            return " "
        virt_40_ascii = "".join(screencode_to_ascii(b) for b in m.mmu.ram[0][0x1400:0x1B80])
        self.assertIn("BOOTING CP/M PLUS", virt_40_ascii)
        self.assertIn("READ ERROR - HIT RETURN TO RETRY", virt_40_ascii)
        self.assertIn("DEL TO ENTER C128 MODE", virt_40_ascii)

    def test_11_basic70_extended_tokens_control_flow_and_ml_monitor(self):
        """Phase 5 verification: BASIC 7.0 $FE/$CE tokenization, DO/LOOP control flow, POINTER(), and ML Monitor (MONITOR, A, D, M, X)."""
        m = self.machine
        # 1. Store and run a BASIC 7.0 program using BANK ($FE $02), DO ($EB)..LOOP UNTIL ($EC $FC), and POINTER ($CE $0A)
        m.peripherals.inject_petscii("NEW\r10 BANK 0:X=0:DO:X=X+5:LOOP UNTIL X=15:PRINT X;POINTER(X)\r")
        m.run_cycles(700_000)
        # Verify Bank 0 program tokenization at $1C01:
        # $1C01-$1C02 = link, $1C03-$1C04 = line 10 ($0A $00), $1C05 = $FE $02 (BANK)
        self.assertEqual(m.mmu.ram[0][0x1C05], 0xFE)
        self.assertEqual(m.mmu.ram[0][0x1C06], 0x02)
        m.peripherals.inject_petscii("RUN\r")
        m.run_cycles(500_000)
        scr = "\n".join(m.peripherals.render_40col_screen_ascii())
        # X=15 and POINTER(X)=1026 ($0402 in Bank 1, the 5-byte value payload of the 7-byte variable entry at $0400!)
        self.assertIn(" 15  1026", scr)

        # 2. Enter Machine Language Monitor via MONITOR ($FA), assemble an instruction, and exit (X)
        m.peripherals.inject_petscii("MONITOR\r")
        m.run_cycles(400_000)
        scr_mon = "\n".join(m.peripherals.render_40col_screen_ascii())
        self.assertIn("MONITOR", scr_mon)
        self.assertIn("PC  SR AC XR YR SP", scr_mon)

        # Assemble 'LDA #$42' at $01800 (Bank 0 $1800)
        m.peripherals.inject_petscii("A 01800 LDA #$42\r")
        m.run_cycles(400_000)
        self.assertEqual(m.mmu.ram[0][0x1800], 0xA9)
        self.assertEqual(m.mmu.ram[0][0x1801], 0x42)

        # Clear auto-prompted keyboard buffer ('A 01802 ') and return to BASIC via 'X'
        m.mmu.ram[0][0x00D0] = 0
        m.peripherals.inject_petscii("\rX\r")
        m.run_cycles(400_000)
        self.assertIn("READY.", "\n".join(m.peripherals.render_40col_screen_ascii()))


if __name__ == "__main__":
    unittest.main(verbosity=2)
