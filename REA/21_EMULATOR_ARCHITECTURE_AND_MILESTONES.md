# PHASE 7: COMMODORE 128 EMULATOR ARCHITECTURE AND MILESTONE VERIFICATION

**Project:** `cbm-128-core` (Project 002: Commodore 128 Complete ROM Reverse Engineering & Emulator Development)  
**Target Firmware:** 1985 Commodore 128 System ROM Set (`basic-4000.318018-02.bin`, `basic-8000.318019-02.bin`, `kernal.318020-03.bin`, `characters.390059-01.bin`, `z80bios.bin`)  
**Architectures:** MOS 8502 (1.02 MHz / 2.04 MHz) & Zilog Z80A (4 MHz / 2 MHz effective)  
**Implementation Targets:**
1. **C# .NET 8 Modular Architecture (`src/Commodore128/`)**: Complete 19-file modular `.NET 8` Windows x64 codebase matching the reference Commodore 128 hardware subsystems.
2. **Python Executable Core & Verification Engine (`src/cbm128/`)**: Cycle-stepped dual-CPU execution engine running automated hardware and firmware regression suites (`tests/test_cbm128.py` and `tests/test_phase7_milestones.py`).

---

## 1. Executive Summary & Architectural Principles

The `cbm-128-core` emulator is engineered from first-principles reverse engineering of the original 1985 Commodore 128 firmware rather than adapted from a flat-64 KB C64 model. Every displayed character, startup banner, BASIC calculation, and monitor disassembly produced by the emulator arises from **genuine instruction-by-instruction execution of the original ROM binaries**.

Key architectural distinctions from the Commodore 64 / 4064 (`cbm-4064-core`) include:
1. **Z80A Cold-Boot Primary Master (`MCR` `$D505 = $00` at reset):** On power-up, the Zilog Z80A—not the MOS 8502—owns the bus, executing 161 instructions from `z80bios.bin` (`$0000–$0FFF`), copying the `$FFE0–$FFF7` bus-switch trampoline into Bank 0 RAM, and executing `OUT ($D505), A` (`$ED $79` with `A = $B1`) at `$FFEB` to wake the MOS 8502.
2. **8722 MMU & 8721 PLA Banked Memory Hierarchy:** A 128 KB RAM subsystem split into Bank 0 (`64 KB`, BASIC program text, variables Lookup/Common RAM), Bank 1 (`64 KB`, BASIC variables, arrays, strings), configurable Common RAM (`1 KB / 4 KB / 8 KB / 16 KB` via `$D506`), Zero-Page/Stack Page relocation (`$D507–$D50A`), and global Load Configuration traps (`$FF00–$FF04`).
3. **Dual Video Subsystem (40-Column VIC-IIe 8564 + 80-Column VDC 8563):** Simultaneous emulation of the memory-mapped 40-column VIC-IIe (`$D000–$D030`, including `$D02F` extended keyboard matrix row select and `$D030` 2 MHz clock control) and the register-indirect 80-column 8563 VDC (`$D600/$D601` + 16 KB/64 KB dedicated VRAM with hardware Block Copy and Block Fill acceleration via R18/R19/R24/R31/R32/R33).
4. **11×8 Hardware Keyboard Matrix (`SCNKEY` at `$C55D`):** Full 88-key matrix combining the 8 standard C64 rows driven on CIA1 Port A (`$DC00`) with the 3 extended C128 rows (numeric keypad, `HELP`, `ESC`, `ALT`, `TAB`, `LINEFEED`, `ENTER`, top-row cursor keys, `40/80 DISPLAY`, `CAPS LOCK`) driven on VIC-IIe `$D02F` bits `0–2`.

---

## 2. Modular Repository Layout

### 2.1 C# .NET 8 Solution (`src/Commodore128/`)

| Module / File | Hardware / Software Responsibility |
|---|---|
| [`Commodore128.csproj`](file:///D:/Emulation/C128/src/Commodore128/Commodore128.csproj) | .NET 8 Windows x64 project configuration |
| [`Program.cs`](file:///D:/Emulation/C128/src/Commodore128/Program.cs) | CLI entry point (`--roms`, `--headless-test`, `--cols 40\|80`, interactive loop) |
| [`Emulator/C128Machine.cs`](file:///D:/Emulation/C128/src/Commodore128/Emulator/C128Machine.cs) | Top-level C128 motherboard orchestrator, power-on/warm reset, pause/resume/step |
| [`Emulator/Cpu8502.cs`](file:///D:/Emulation/C128/src/Commodore128/Emulator/Cpu8502.cs) | MOS 8502 CPU core (151 opcodes, binary/BCD `ADC`/`SBC`, `$00/$01` port, 1/2 MHz clock) |
| [`Emulator/CpuZ80.cs`](file:///D:/Emulation/C128/src/Commodore128/Emulator/CpuZ80.cs) | Zilog Z80A CPU core (main/alt registers, `CB`/`DD`/`ED`/`FD`, `LDIR`/`LDDR`, 16-bit I/O) |
| [`Emulator/MemoryBus.cs`](file:///D:/Emulation/C128/src/Commodore128/Emulator/MemoryBus.cs) | Unified 128 KB RAM + 60 KB ROM + `$D000–$DFFF` I/O interconnect and write-through bus |
| [`Emulator/Mmu8722.cs`](file:///D:/Emulation/C128/src/Commodore128/Emulator/Mmu8722.cs) | MOS 8722 MMU (`$D500–$D50B`, `$FF00–$FF04` `CR`/`PCRA–D`, Common RAM, `P0H`/`P1H`) |
| [`Emulator/Pla8721.cs`](file:///D:/Emulation/C128/src/Commodore128/Emulator/Pla8721.cs) | MOS 8721 PLA decode logic (`LORAM`/`HIRAM`/`CHAREN` + MMU `CR` + Z80 `/Z80EN` decode) |
| [`Emulator/VicIIe.cs`](file:///D:/Emulation/C128/src/Commodore128/Emulator/VicIIe.cs) | MOS 8564/8566 VIC-IIe 40-col video, raster IRQs, `$D02F` keypad strobe, `$D030` 2 MHz bit |
| [`Emulator/Vdc8563.cs`](file:///D:/Emulation/C128/src/Commodore128/Emulator/Vdc8563.cs) | MOS 8563 VDC 80-col RGBI controller (`$D600` status, `$D601` R0–R37, 64 KB VRAM, blitter) |
| [`Emulator/Sid6581.cs`](file:///D:/Emulation/C128/src/Commodore128/Emulator/Sid6581.cs) | MOS 6581/8580 SID 3-voice phase accumulator + ADSR + 16-bit signed PCM synthesizer |
| [`Emulator/Cia6526.cs`](file:///D:/Emulation/C128/src/Commodore128/Emulator/Cia6526.cs) | Dual MOS 6526 CIAs (`$DC00` keyboard/IRQ timers, `$DD00` VIC bank/IEC serial/NMI timers) |
| [`Emulator/KeyboardController.cs`](file:///D:/Emulation/C128/src/Commodore128/Emulator/KeyboardController.cs) | 11×8 hardware keyboard matrix (`$DC00` + `$D02F` -> `$DC01`) & PETSCII queue injector |
| [`Firmware/RomLoader.cs`](file:///D:/Emulation/C128/src/Commodore128/Firmware/RomLoader.cs) | Configurable user ROM path loader with filename resolution |
| [`Firmware/RomVerifier.cs`](file:///D:/Emulation/C128/src/Commodore128/Firmware/RomVerifier.cs) | Exact byte-length, CRC32, and SHA-256 cryptographic ROM image verifier |
| [`Debugger/ExecutionTracer.cs`](file:///D:/Emulation/C128/src/Commodore128/Debugger/ExecutionTracer.cs) | Ring-buffer instruction & hardware I/O access tracer |
| [`Debugger/BreakpointManager.cs`](file:///D:/Emulation/C128/src/Commodore128/Debugger/BreakpointManager.cs) | PC execution breakpoints and `$D000–$DFFF` I/O read/write watchpoints |
| [`Debugger/MemoryInspector.cs`](file:///D:/Emulation/C128/src/Commodore128/Debugger/MemoryInspector.cs) | Non-destructive Bank 0, Bank 1, CPU-visible, and VDC VRAM hex/ASCII inspector |
| [`Display/DisplayRenderer.cs`](file:///D:/Emulation/C128/src/Commodore128/Display/DisplayRenderer.cs) | PETSCII / screen-code to ASCII text and RGBA32 framebuffer renderer |
| [`Display/ScreenController.cs`](file:///D:/Emulation/C128/src/Commodore128/Display/ScreenController.cs) | 40/80-column display mode switcher |

### 2.2 Python Executable Core (`src/cbm128/`)

| Module / File | Responsibility |
|---|---|
| [`src/cbm128/machine.py`](file:///D:/Emulation/C128/src/cbm128/machine.py) | `Commodore128Machine` dual-CPU scheduler, reset/NMI, pause/resume/step, inspection |
| [`src/cbm128/cpu_8502.py`](file:///D:/Emulation/C128/src/cbm128/cpu_8502.py) | `MOS8502CPU` instruction set, BCD math, interrupt entry, cycle accounting |
| [`src/cbm128/cpu_z80.py`](file:///D:/Emulation/C128/src/cbm128/cpu_z80.py) | `ZilogZ80CPU` instruction set, `EX AF,AF'`/`EXX`, `LDIR`/`LDDR`, 16-bit I/O ports |
| [`src/cbm128/mmu.py`](file:///D:/Emulation/C128/src/cbm128/mmu.py) | `C128MMUAndBus` 128 KB RAM, ROM overlays, `$D500–$D50B`, `$FF00–$FF04` |
| [`src/cbm128/peripherals.py`](file:///D:/Emulation/C128/src/cbm128/peripherals.py) | `C128Peripherals` VIC-IIe, 8563 VDC, CIA1/2, 11×8 keyboard matrix, SID PCM audio |
| [`src/cbm128/debugger.py`](file:///D:/Emulation/C128/src/cbm128/debugger.py) | `RomLoader`, `RomVerifier`, `BreakpointManager`, `ExecutionTracer`, `C128_KEY_COORDS` |

---

## 3. System Interaction & Dual-CPU Handoff Flow

```mermaid
sequenceDiagram
    participant Reset as Power-On Reset
    participant Z80 as Zilog Z80A ($0000)
    participant MMU as 8722 MMU ($D500-$D50B / $FF00-$FF04)
    participant M8502 as MOS 8502 ($FFFC -> $E000)
    participant VDC as 8563 VDC ($D600/$D601)
    participant VIC as 8564 VIC-IIe ($D000-$D030)

    Reset->>MMU: MCR ($D505) = $00 (Z80 Active, C128 Mode)
    Reset->>Z80: PC = $0000 (z80bios.bin)
    Z80->>Z80: JP $0040 -> Clear CR ($FF00), SP=$FFDF
    Z80->>MMU: LDIR $0065 -> $FFE0 (18-byte handoff stub in Common RAM)
    Z80->>MMU: OUT ($D500), $3E -> JP $FFE0 -> OUT ($D505), $B1 ($ED $79)
    MMU->>M8502: Bit 0 of MCR = 1 -> Z80 Bus Hold, 8502 Reset Vector ($FFFC = $E000)
    M8502->>MMU: Configure PCRA-PCRD ($D501-$D504 = $3F, $7F, $01, $41) & RCR ($D506 = $04)
    M8502->>VDC: Initialize R0-R37 ($E1DC) & Upload 8 KB Char ROM to VRAM $2000-$3FFF
    M8502->>VIC: Initialize 40-col screen ($0400), 60 Hz raster IRQ ($D012/$D01A)
    M8502->>M8502: JSR $4000 (BASIC 7.0 Cold Start) -> Print Banner & "READY."
```

---

## 4. Hardware Subsystem Implementation Details

### 4.1 MOS 8502 CPU (`Cpu8502.cs` / `cpu_8502.py`)
- **Registers & Flags:** 8-bit `A`, `X`, `Y`, `SP` (`$0100–$01FF` relocated via MMU `P1H/P1L`), 16-bit `PC`, status flags `N V 1 B D I Z C`.
- **On-Chip I/O Port (`$0000` `DDR`, `$0001` `PR`):** Implemented directly ahead of RAM/MMU decoding with default pull-ups (`$07` for `LORAM`, `HIRAM`, `CHAREN`), feeding the 8721 PLA when MMU `CR` selects I/O or ROM overlays.
- **Binary & Decimal (`SED`) Arithmetic:** Exact 6502/8502 `ADC` (`$69/$65/$75/$6D/$7D/$79/$61/$71`) and `SBC` (`$E9/$E5/$F5/$ED/$FD/$F9/$E1/$F1`) both in binary mode (signed overflow `V` and carry `C`) and BCD mode (`D=1` nibble adjustment).
- **2 MHz Fast Mode (`$D030` Bit 0):** Tracks VIC-IIe `$D030` bit 0 (`1 = 2.04 MHz`, `0 = 1.02 MHz`), used by BASIC 7.0 `FAST` and `SLOW` commands.

### 4.2 Zilog Z80A CPU (`CpuZ80.cs` / `cpu_z80.py`)
- **Register File:** Main set (`AF`, `BC`, `DE`, `HL`), alternate set (`AF'`, `BC'`, `DE'`, `HL'` swapped via `EX AF,AF'` `$08` and `EXX` `$D9`), index registers (`IX`, `IY`), `SP`, `PC`, `I`, `R`, `IFF1`/`IFF2`, `IM`.
- **Prefix Groups & Block Instructions:** Full support for `$CB` bit manipulation (`BIT`, `RES`, `SET`, rotates/shifts), `$ED` extended instructions (`LDIR` `$ED $B0`, `LDDR` `$ED $B8`, `CPIR` `$ED $B1`, `IN r,(C)` `$ED $40–$78`, `OUT (C),r` `$ED $41–$79`, `SBC HL,rr`, `ADC HL,rr`, `IM 0/1/2`), and `$DD`/`$FD` (`IX`/`IY` indexed displacements).
- **16-Bit I/O Bus Mapping:** In the C128 hardware design, Z80 `IN r,(C)` and `OUT (C),r` place the full 16-bit `BC` register onto the address bus (`A0–A15`) with `/IO` asserted, accessing `$D000–$DFFF` peripheral registers (`$D500–$D50B` MMU, `$D600–$D601` VDC, `$DC00–$DDFF` CIAs) even when Z80 memory space maps RAM or BIOS ROM.

### 4.3 8722 MMU & 128 KB Banked Memory (`Mmu8722.cs` / `MemoryBus.cs` / `mmu.py`)
- **Physical Storage:** Two independent 64 KB RAM banks (`Bank 0` and `Bank 1`), 4 KB `z80bios.bin`, 16 KB `basic-4000`, 16 KB `basic-8000`, 16 KB `kernal` (`$C000–$FFFF`), 8 KB `characters`, and 1 KB Color RAM (`2 × 1 KB` nybble banks).
- **Global Load Registers (`$FF00–$FF04`):** Always visible in every memory configuration:
  - Write `$FF00` -> sets `CR` (`$D500`) directly.
  - Write `$FF01–$FF04` (`LCRA–LCRD`) -> copies preconfiguration register `PCRA–PCRD` (`$D501–$D504`) into `CR`.
- **Underlying RAM Write-Through:** Any CPU write to `$4000–$FFFF` when ROM overlays are enabled writes through to the currently selected physical RAM bank (`Bank 0` or `Bank 1`), while writes to `$D000–$DFFF` when `CR` bit 0 is `0` route to I/O chips.

### 4.4 Dual Video: 40-Column VIC-IIe & 80-Column 8563 VDC (`VicIIe.cs` / `Vdc8563.cs` / `peripherals.py`)
- **40-Column VIC-IIe (`$D000–$D030`):** Renders the live 40×25 screen matrix at Bank 0 `$0400–$07E7` (or relocation offset via `$D018` / `$0A2C`) and Color RAM at `$D800–$DBE7`, driving 60 Hz raster interrupts (`$D012`/`$D019`/`$D01A`) that run the KERNAL `SCNKEY` and `UDTIM` routines.
- **80-Column 8563 VDC (`$D600/$D601`):** Emulates indirect register addressing (`$D600` bit 7 `STATUS_READY = 1`, bit 5 `VBLANK` toggling), 64 KB dedicated VRAM, auto-incrementing VRAM read/write pointers (`R18`/`R19` + `R31`), and hardware block fill/copy (`R24` bit 7 + `R32`/`R33` + `R30` byte count). Renders the live 80×25 screen matrix from VRAM `$0000–$07CF` and attribute RAM from `$0800–$0FCF`.

### 4.5 11×8 Keyboard Matrix & SID Audio Synthesis (`KeyboardController.cs` / `Sid6581.cs` / `peripherals.py`)
- **11×8 Keyboard Matrix:** Maps all 88 C128 keys (`Rows 0–7` on `$DC00` + `Rows 8–10` on `$D02F` bits `0–2`, read on `$DC01`). Verified by pressing physical matrix keys (`A` at Row 1 Col 2, `RETURN` at Row 0 Col 1) and allowing the unpatched KERNAL `SCNKEY` (`$C55D`) IRQ handler to decode them via the `$FA80` ROM lookup tables and deposit them into the `$034A` keyboard queue.
- **SID 6581/8580 Synthesis (`$D400–$D41F`):** Implements all 29 SID registers plus 3-voice 24-bit phase accumulators (Triangle, Sawtooth, Pulse with 12-bit PW, LFSR Noise), ADSR envelope scaling, and master volume (`$D418` bits `0–3`), generating signed 16-bit 44.1 kHz PCM audio samples (`SynthesizePcmSamples` / `synthesize_sid_pcm`). Includes a documented approximation note: analog multi-mode resonant filter (`$D415–$D417`) registers are latched in hardware state while PCM synthesis outputs the direct digital oscillator/ADSR mix.

---

## 5. Emulator Milestones Verification Ledger (M1–M10)

All 10 required Phase 7 milestones are verified by automated execution in [`tests/test_phase7_milestones.py`](file:///D:/Emulation/C128/tests/test_phase7_milestones.py), which writes structured machine-readable evidence to [`reports/phase7_milestone_verification.json`](file:///D:/Emulation/C128/reports/phase7_milestone_verification.json).

| Milestone | Requirement | Verification Test & Observed Evidence | Status |
|---|---|---|---|
| **M1** | MOS 8502 instruction tests pass | `test_M01_mos8502_independent_instruction_and_port_tests`: Standalone 8502 executes binary `ADC` (`$15+$2B=$40`), BCD `ADC` (`$18+$28=$46`), `DEX`/`BNE` loop (`sum=100`), `JSR`/`RTS`, `BRK` vector (`$2000`), and CPU port `$00/$01` (`$35`). | **PASS** |
| **M2** | Z80 instruction tests pass | `test_M02_zilog_z80_independent_instruction_and_block_tests`: Standalone Z80A executes `EX AF,AF'` (`A'=$AA`), `LDIR` (`$ED $B0` copies `DE AD BE EF`), `SET 7,B`/`BIT 7,B`, and `OUT ($D505),$B1` processor handoff. | **PASS** |
| **M3** | RAM banking and MMU tests pass | `test_M03_ram_banking_and_mmu_overlays`: Verifies ROM read at `$4000` (`$4C`), write-through to Bank 0 RAM under ROM (`$99` read via `$FF01`), independent Bank 1 RAM at `$4000` (`$77` via `$FF02`), and shared Common RAM (`$0380 = $E6`). | **PASS** |
| **M4** | Original reset sequence executes | `test_M04_M05_M06_reset_firmware_init_and_basic70_startup`: Cold boot executes 161 Z80 BIOS instructions (`1,824` cycles) and switches from Z80 (`PC=$FFED`) to 8502 (`MCR=$B1`, `CR=$3E`). | **PASS** |
| **M5** | Firmware initialization progresses without hardcoded shortcuts | `test_M04_M05_M06_reset_firmware_init_and_basic70_startup`: 8502 KERNAL sets `PCRA–D` (`$3F, $7F, $01, $41`) and uploads `3,495` non-zero Character ROM bytes into 8563 VDC VRAM `$2000–$3FFF`. | **PASS** |
| **M6** | BASIC 7.0 startup screen appears from actual emulated execution | `test_M04_M05_M06_reset_firmware_init_and_basic70_startup`: Live Bank 0 screen RAM (`$0400–$07E7`) contains `COMMODORE BASIC V7.0 122365 BYTES FREE` and `READY.`. | **PASS** |
| **M7** | User can enter `PRINT 2+2` and receive `4` | `test_M07_print_2_plus_2_equals_4`: Entering `PRINT 2+2` executes BASIC 7.0 floating-point addition and renders `4` and `READY.` to screen memory. | **PASS** |
| **M8** | BASIC programs execute | `test_M08_basic_programs_and_sid_audio_synthesis`: Multi-line program (`10 VOL 15:SOUND 1,4096,2` / `20 T=0:FOR K=1 TO 10:T=T+K:NEXT K` / `30 PRINT "SUM=";T;"BANK1=";POINTER(T)`) outputs `SUM= 55 BANK1= 1026`, sets SID `$D418=15`, `$D400/$D401=4096`, and synthesizes PCM audio (`peak=5400`). | **PASS** |
| **M9** | Keyboard and display behaviour support practical interactive use | `test_M09_hardware_keyboard_matrix_scan_and_dual_40_80_display`: Physical matrix keypress (`A` at Row 1 Col 2) is scanned by KERNAL `SCNKEY` (`$C55D`) over 60 Hz IRQs; `GRAPHIC 5` switches to 80-column VDC and renders `VDC 80-COL ACTIVE:  81` in VDC VRAM. | **PASS** |
| **M10** | Debugger can trace execution and hardware accesses | `test_M10_debugger_execution_control_and_rom_validation`: PC breakpoint at `$C262` (`BASIN`) halts CPU cleanly; single-step records 10 instruction/I/O trace events; `RomLoader`/`RomVerifier` rejects corrupted ROM lengths with `RomValidationError`. | **PASS** |
