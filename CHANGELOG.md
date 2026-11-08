# Changelog

All notable changes to **Commodore 128 Dual-CPU Reverse Engineering & Emulation** will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [0.1.0] - 2026-11-08

### Added
- **Dual-CPU Execution Core:**
  - Cycle-accurate MOS 8502 CPU emulation (1 MHz / 2 MHz fast mode support, full 6502/6510 instruction set, on-chip I/O port).
  - High-performance Zilog Z80A CPU emulation (4 MHz clock, 16-bit register pairs, extended instruction prefixes CB/DD/ED/FD, block copy instructions).
  - Hardware processor handover engine via MMU `$FF00` and `$FFD0-$FFEF` common memory stub.
- **Memory Management Unit (MMU 8722):**
  - Full 128 KB physical RAM support across Bank 0 and Bank 1.
  - Dynamically configurable Common RAM windows (Top and Bottom pages).
  - Preconfiguration registers (`$FF01-$FF04`) and Mode Configuration Register (`$D505`).
  - Zero Page and Stack relocation support (`$D507-$D50A`).
- **Video Subsystem (Dual Displays):**
  - Complete MOS 8564/8566 VIC-IIe 40-column rendering pipeline (320 × 200, 16-color palette, multicolor bitmap mode, sprites, raster interrupts).
  - MOS 8563 VDC 80-column RGBI display controller with indirect register addressing.
- **Input/Output & Timing:**
  - Dual MOS 6526 / 8521 Complex Interface Adapters (CIA 1 & CIA 2).
  - Hardware-accurate Time of Day (TOD) clock with 60 Hz prescaler, register latching on `$DC0B`, and BCD timekeeping.
  - Fast Serial IEC burst transfer protocol emulation for 1571 disk drives.
  - Basic 3-voice SID 6581/8580 sound support.
- **Operating System & Software Verification:**
  - 100% genuine Commodore BASIC 7.0 cold boot (`122,365 BYTES FREE`, Bank 1 variable isolation).
  - Digital rain Matrix demonstration executing interactively in BASIC 7.0 (80+ million simulated cycles).
  - Genuine CP/M Plus 3.0 cold boot from D64 floppy disk images.
  - Resolved CP/M `B:DATE` timekeeping bug via CIA 1 TOD latching repair.
  - Commercial game execution: Native *Kikstart 128* (1986) load, decompression, multicolor title screen, and split-screen race engine at `$5CC4`.
- **Automated Verification Harness:**
  - 13 xUnit C# unit tests validating instruction arithmetic, register pairs, banking, CIA timers, and 1571 GCR zones.
  - 23 Python integration and milestone tests.
  - Clean-room fallback memory architecture enabling 100% ROM-free CI builds.
- **Documentation Suite & Whitepaper:**
  - 25 Reverse Engineering Archive (REA) technical reports.
  - Comprehensive documentation in `docs/` (`ARCHITECTURE`, `VIDEO_ENGINE`, `BUILDING`, `TESTING`, `REVERSE_ENGINEERING`, `ROM_VERIFICATION`, `CPM_COMPATIBILITY`, `GAME_COMPATIBILITY`).
  - Automated ReportLab whitepaper compilation: `Commodore_128_Dual_CPU_Reconstruction_Report.pdf`.
