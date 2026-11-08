# Reverse Engineering Analysis & Firmware Decomposition
**Project 002: Commodore 128 Dual-CPU Reconstruction**  
**Author:** ScientificBrad Research & Digital Preservation

---

## 1. Methodology & Analysis Framework

Project 002 undertook a full reverse engineering and architectural reconstruction of the Commodore 128 firmware set. The investigation employed a three-tiered methodology:
1. **Static Binary Decomposition:** Disassembly and symbol recovery across all four physical mask ROM chips using automated pattern matchers and control flow graph analyzers.
2. **Dynamic Trace Reconstruction:** Executing firmware subroutines within step-accurate CPU emulators, capturing register states, MMU transitions, and bus activity.
3. **Round-Trip Clean Reassembly:** Reconstructing complete, comment-annotated assembly source code in `asm/` and re-assembling them to verify byte-for-byte binary parity.

---

## 2. Firmware Chipset Breakdown (60 KB Address Space)

```
       MOS 8502 MEMORY MAP (BANK 0)            PHYSICAL ROM CHIPS
+---------------------------------------+  =============================
| $FFFF                                 |
|         KERNAL Operating System       |  Chip 3: 318020-03 (16 KB)
|                (16 KB)                |  Includes embedded 4 KB
| $C000                                 |  Z80 BIOS at offset $1000
+---------------------------------------+  -----------------------------
| $BFFF                                 |
|         BASIC 7.0 High ROM            |  Chip 2: 318019-02 (16 KB)
|                (16 KB)                |  Extended Sound, Graphics,
| $8000                                 |  and Fast Disk Statements
+---------------------------------------+  -----------------------------
| $7FFF                                 |
|         BASIC 7.0 Low ROM             |  Chip 1: 318018-02 (16 KB)
|                (16 KB)                |  Core Tokenizer, Parser,
| $4000                                 |  and Expression Evaluator
+---------------------------------------+  =============================
| $3FFF                                 |
|            System RAM                 |
|              (16 KB)                  |
| $0000                                 |
+---------------------------------------+
```

### 2.1 BASIC Low ROM (`318018-02`, 16,384 bytes)
- **Mapping:** `$4000-$7FFF` (Bank 0).
- **Functionality:** Implements the core Commodore BASIC interpreter derived from Microsoft BASIC, modified for dual-bank operation:
  - Token scanner and syntax parser (`$4200-$4A00`).
  - Expression evaluator, floating point math routines, and numeric conversion (`$4A00-$6800`).
  - Standard BASIC statements (`FOR`, `GOTO`, `GOSUB`, `IF`, `PRINT`, `INPUT`).
  - Bank 1 variable vectoring logic ensuring user variable storage is routed to Bank 1 while program text resides in Bank 0.

### 2.2 BASIC High ROM (`318019-02`, 16,384 bytes)
- **Mapping:** `$8000-$BFFF` (Bank 0).
- **Functionality:** Provides 48 advanced BASIC 7.0 statements and functions:
  - **Graphics Engine:** `GRAPHICS`, `BOX`, `CIRCLE`, `DRAW`, `PAINT`, `CHAR`, `SSHAPE`, `GSHAPE`, `SCALE`.
  - **Audio Engine:** `SOUND`, `ENVELOPE`, `VOL`, `PLAY` (with musical score parsing).
  - **Fast Disk Commands:** `DIRECTORY`, `DLOAD`, `DSAVE`, `DVERIFY`, `COPY`, `RENAME`, `SCRATCH`, `COLLECT`, `HEADER`, `RECORD`.
  - **Hardware Control:** `BANK`, `FAST`, `SLOW`, `CONFIG`, `SLEEP`, `RREG`.

### 2.3 KERNAL ROM (`318020-03`, 16,384 bytes)
- **Mapping:** `$C000-$FFFF` (Bank 0).
- **Functionality:** Hardware abstraction layer and operating system core:
  - **Cold Reset (`$F890 / $FF80`):** Configures MMU `$D500`, tests RAM, initializes CIA 1 and CIA 2, clears screen, sets VIC-IIe registers.
  - **Fast Serial Burst Protocol (`$EE40`):** Hardware handshake routines utilizing CIA 2 serial shift registers to achieve 4 KB/sec transfer rates with 1571 drives.
  - **Screen Editor:** Handles keyboard matrix polling, cursor flashing, color control, and 40/80-column switching.
  - **Embedded Z80 BIOS:** Bytes `$1000-$1FFF` within the KERNAL chip contain the complete 4,096-byte Z80 bootstrap BIOS. When the Z80 is active, this slice is mapped to `$0000-$0FFF`.

### 2.4 Character Generator ROM (`390059-01`, 8,192 bytes)
- **Mapping:** `$D000-$DFFF` (accessible when character ROM is banked into view).
- **Functionality:** 1,024 8 × 8 character glyph matrices:
  - Set 1: Uppercase text and PETSCII graphical symbols.
  - Set 2: Lowercase and uppercase text with European accent marks.
  - Dual font variations optimized for both 40-column VIC-IIe and 80-column VDC screens.

---

## 3. Disassembly & Reconstruction Pipeline

The complete disassembly was verified using `asm/verify_roms.py` and `asm/build_roms.py`. Re-assembly of the disassembled source listings reproduces the exact factory ROM images byte-for-byte, confirming zero missing opcodes or misidentified data tables.
