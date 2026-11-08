"""
Complete Commodore 128 Machine Emulator (`cbm-128-core`).
Loads the original 1985 ROM set, starts the Zilog Z80A at $0000 on power-on reset,
handles the hardware MMU ($D505) handoff to the MOS 8502, executes KERNAL & BASIC 7.0
initialization, and supports interactive 40-column (VIC-IIe) and 80-column (8563 VDC) display
plus BASIC 7.0 / ML Monitor execution.
"""

import os
from .mmu import C128MMUAndBus
from .peripherals import C128Peripherals
from .cpu_8502 import MOS8502CPU
from .cpu_z80 import ZilogZ80CPU
from .debugger import RomLoader, BreakpointManager, ExecutionTracer

class Commodore128Machine:
    def __init__(self, rom_dir: str, strict_checksum: bool = False):
        loaded = RomLoader.load_from_directory(rom_dir, strict_checksum=strict_checksum)
        b4 = loaded["basic-4000.318018-02.bin"]
        b8 = loaded["basic-8000.318019-02.bin"]
        kn = loaded["kernal.318020-03.bin"]
        ch = loaded["characters.390059-01.bin"]
        self.rom_reports = loaded["reports"]

        self.mmu = C128MMUAndBus(b4, b8, kn, ch)
        self.peripherals = C128Peripherals(self.mmu)
        self.z80 = ZilogZ80CPU(self.mmu)
        self.m8502 = MOS8502CPU(self.mmu)
        self.breakpoints = BreakpointManager()
        self.tracer = ExecutionTracer()
        self.peripherals.io_tracer = self.tracer
        self.paused = False

        self.total_cycles = 0
        self.z80_steps = 0
        self.m8502_steps = 0
        self.cpu_switches = []

    def reset(self):
        self.mmu.cr = 0x00
        self.mmu.mcr = 0xB0  # Bit 0 = 0 (Z80 active on power-on), Bit 7 = 1 (40-col), /GAME=1, /EXROM=1
        self.z80.reset()
        self.m8502.reset_pending = True
        self.paused = False
        self.total_cycles = 0
        self.z80_steps = 0
        self.m8502_steps = 0
        self.cpu_switches = []

    def warm_reset_nmi(self):
        """Triggers a Warm Reset / Restore NMI on the MOS 8502."""
        self.m8502.nmi_pending = True

    def pause(self):
        self.paused = True

    def resume(self):
        self.paused = False

    def inspect_registers(self) -> dict:
        return {
            "active_cpu": "Z80" if self.mmu.is_z80_active else "8502",
            "clock_mhz": 2 if (self.peripherals.vic_regs[0x30] & 0x01) else 1,
            "mmu_cr": f"${self.mmu.cr:02X}",
            "mmu_mcr": f"${self.mmu.mcr:02X}",
            "mmu_rcr": f"${self.mmu.rcr:02X}",
            "m8502": {
                "PC": f"${self.m8502.pc:04X}",
                "A": f"${self.m8502.a:02X}",
                "X": f"${self.m8502.x:02X}",
                "Y": f"${self.m8502.y:02X}",
                "SP": f"${self.m8502.sp:02X}",
                "P": f"${self.m8502.p:02X}",
            },
            "z80": {
                "PC": f"${self.z80.pc:04X}",
                "AF": f"${(self.z80.a << 8) | self.z80.f:04X}",
                "BC": f"${self.z80.bc:04X}",
                "DE": f"${self.z80.de:04X}",
                "HL": f"${self.z80.hl:04X}",
                "SP": f"${self.z80.sp:04X}",
            },
        }

    def inspect_memory(self, start_addr: int, length: int = 16, bank: int | None = None) -> bytes:
        if bank is not None:
            b = bank & 1
            return bytes(self.mmu.ram[b][(start_addr + i) & 0xFFFF] for i in range(length))
        return bytes(self.mmu.read8((start_addr + i) & 0xFFFF, z80_mode=self.mmu.is_z80_active) for i in range(length))

    def step_instruction(self, ignore_breakpoints: bool = False) -> int:
        was_z80 = self.mmu.is_z80_active
        cur_pc = self.z80.pc if was_z80 else self.m8502.pc
        if not ignore_breakpoints and self.breakpoints.should_break_pc(cur_pc):
            self.paused = True
            return 0
        if self.tracer.enabled:
            op = self.mmu.read8(cur_pc, z80_mode=was_z80)
            self.tracer.record_step(self.total_cycles, "Z80" if was_z80 else "8502", cur_pc, op, self.mmu.cr, self.mmu.mcr)
        if was_z80:
            cyc = self.z80.step()
            self.z80_steps += 1
        else:
            # Feed queued PETSCII keystrokes when 8502 is in the interactive loop
            if self.peripherals.key_queue:
                self.peripherals.feed_kernal_key_buffer()
            cyc = self.m8502.step()
            self.m8502_steps += 1

        self.peripherals.step_cycles(cyc)
        self.total_cycles += cyc

        now_z80 = self.mmu.is_z80_active
        if was_z80 != now_z80:
            self.cpu_switches.append({
                "cycle": self.total_cycles,
                "from_cpu": "Z80" if was_z80 else "8502",
                "to_cpu": "Z80" if now_z80 else "8502",
                "z80_pc": f"${self.z80.pc:04X}",
                "m8502_pc": f"${self.m8502.pc:04X}",
                "mcr": f"${self.mmu.mcr:02X}",
                "cr": f"${self.mmu.cr:02X}"
            })
        return cyc

    def run_cycles(self, target_cycles: int):
        end_cycle = self.total_cycles + target_cycles
        while not self.paused and self.total_cycles < end_cycle:
            self.step_instruction()

    def run_until_ready(self, max_cycles: int = 5_000_000) -> bool:
        """Runs the machine from reset until 'READY.' appears on the 40-column screen."""
        end_cycle = self.total_cycles + max_cycles
        while self.total_cycles < end_cycle:
            for _ in range(1000):
                self.step_instruction()
            screen = self.peripherals.render_40col_screen_ascii()
            if any("READY." in line for line in screen):
                # Run a few more thousand cycles so cursor and input loop settle
                self.run_cycles(25000)
                return True
        return False
