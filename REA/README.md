# Reverse Engineering Archive (REA)

This directory contains reverse engineering evidence, architectural analyses, disassembly ledgers, and compatibility findings generated during the reconstruction of the Commodore 128 system.

---

## Technical Reports Index

| Report ID | Title | Focus & Core Discoveries |
| :--- | :--- | :--- |
| [01_ROM_INVENTORY.md](01_ROM_INVENTORY.md) | ROM Physical Inventory | Physical chip count, 23128/2364 pinouts, packaging, SHA-256 and MD5 cryptographic hashes. |
| [02_ROM_IDENTIFICATION.md](02_ROM_IDENTIFICATION.md) | ROM Identification & Parts | Commodore part numbers (318018-02, 318019-02, 318020-03, 390059-01) and historical revisions. |
| [03_ROM_MEMORY_LAYOUT.md](03_ROM_MEMORY_LAYOUT.md) | ROM Memory Layout | 128 KB physical RAM mapping, Bank 0 / Bank 1, Common RAM windows, and I/O page translation. |
| [04_FIRMWARE_DISASSEMBLY_AND_RECONSTRUCTION.md](04_FIRMWARE_DISASSEMBLY_AND_RECONSTRUCTION.md) | Firmware Disassembly Ledger | Complete decompilation analysis of 61 KB firmware and vector call graphs. |
| [05_TECHNICAL_REPORT_AND_FINDINGS_LEDGER.md](05_TECHNICAL_REPORT_AND_FINDINGS_LEDGER.md) | Technical Findings Ledger | Detailed architectural findings, MMU register behaviours, and hardware race condition resolutions. |
| [12_Z80_BIOS_ANALYSIS.md](12_Z80_BIOS_ANALYSIS.md) | Z80 BIOS Analysis | In-depth examination of the 4 KB embedded Z80 BIOS at `$1000-$1FFF` in KERNAL. |
| [13_PROCESSOR_SWITCHING.md](13_PROCESSOR_SWITCHING.md) | Processor Switching Engine | Hardware interlock between MOS 8502 and Zilog Z80A via MMU `$FF00` and `$FFD0-$FFEF` stub. |
| [14_CPM_BOOT_ARCHITECTURE.md](14_CPM_BOOT_ARCHITECTURE.md) | CP/M 3.0 Boot Architecture | KERNAL `$F890` boot sector read, sector relocation to `$0100`, handover to Z80, and CP/M system load. |
| [15_BASIC7_ARCHITECTURE.md](15_BASIC7_ARCHITECTURE.md) | BASIC 7.0 Architecture | Dual-bank tokenized interpreter, Bank 0 code space, Bank 1 variable storage (`122,365 BYTES FREE`). |
| [16_BASIC_TOKEN_TABLE.md](16_BASIC_TOKEN_TABLE.md) | BASIC 7.0 Token Table | Exhaustive opcode token map ($80-$FF, two-byte escape sequences $FE/$FD) for all commands. |
| [17_BASIC_COMMAND_MAP.md](17_BASIC_COMMAND_MAP.md) | BASIC 7.0 Command Map | Syntax definitions and jump vectors for GRAPHICS, COLOR, SOUND, PLAY, RECORD, and DISK. |
| [18_MACHINE_LANGUAGE_MONITOR.md](18_MACHINE_LANGUAGE_MONITOR.md) | Machine Language Monitor | Built-in C128 monitor (`MONITOR`), register displays, memory dumping, bank switching syntax. |
| [19_1571_DISK_ARCHITECTURE.md](19_1571_DISK_ARCHITECTURE.md) | 1571 Fast Disk Architecture | Fast serial burst protocol, double-sided D71 MFM/GCR tracking, BAM structure, and hardware hooks. |
| [19_ROM_RECONSTRUCTION.md](19_ROM_RECONSTRUCTION.md) | Clean ROM Reconstruction | Source reconstruction and reassembly pipelines producing bit-identical binary images. |
| [20_BINARY_COMPARISON.md](20_BINARY_COMPARISON.md) | Binary Comparison Ledger | Byte-for-byte binary diffs validating clean reassembly against original Commodore factory masks. |
| [21_EMULATOR_ARCHITECTURE_AND_MILESTONES.md](21_EMULATOR_ARCHITECTURE_AND_MILESTONES.md) | Milestones & Architecture | Phase 1 through Phase 8 verification timeline from cold reset to Matrix rain demonstration. |
| [23_CPM_DISK_COMPATIBILITY.md](23_CPM_DISK_COMPATIBILITY.md) | CP/M Disk Compatibility | Comparative boot analysis across Dec 1985, May 1987, and system utility D64 images. |
| [24_CPM_DATE_TIME_ARCHITECTURE.md](24_CPM_DATE_TIME_ARCHITECTURE.md) | CP/M Date & Time Subsystem | CIA 6526 / 8521 Time of Day (TOD) registers, BCD encoding, 50/60 Hz prescaling, and DATE.COM fix. |
| [25_KIKSTART128_GAME_COMPATIBILITY.md](25_KIKSTART128_GAME_COMPATIBILITY.md) | Kikstart 128 Game Compatibility | Commercial game execution analysis, C128 memory mode configuration, split-screen race engine. |

---

## Evidence Directory

- `EVIDENCE/`: Contains raw disassembly tables, memory dumps, bus traces, and cycle execution profiles collected during native hardware and emulation runs.
