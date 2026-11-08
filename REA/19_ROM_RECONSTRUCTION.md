# Phase 6 Deliverable 19: Bit-Exact ROM Reconstruction Architecture & Methodology

**Classification:** `CONFIRMED`  
**Target Firmware Set:** Commodore 128 Original 1985 Firmware (61,440 bytes across 5 ROM images)  
**Build & Verification Scripts:** [`asm/build_roms.py`](file:///D:/Emulation/C128/asm/build_roms.py), [`asm/verify_roms.py`](file:///D:/Emulation/C128/asm/verify_roms.py)

---

## 1. Reconstruction Objective & Methodological Rigor

A genuine firmware reconstruction must assemble actual CPU mnemonics, operands, relative branch displacements, origin directives, and structured data tables back into the exact binary images burned into the original mask ROMs — **without** simply dumping the entire binary as `.BYTE` arrays, and **without** misclassifying undecoded data bytes as fake instructions.

### 1.1 Repository Layout (`asm/`)
All five reconstructed assembly sources and their reproducible build/verification toolchain reside in `D:\Emulation\C128\asm\`:

```text
asm/
├── 8502/
│   ├── basic_low.asm        (16,384 B -> basic-4000.318018-02.bin, .ORG $4000)
│   ├── basic_high.asm       (16,384 B -> basic-8000.318019-02.bin, .ORG $8000)
│   └── kernal.asm           (16,384 B -> kernal.318020-03.bin,     .ORG $C000)
│
├── z80/
│   ├── z80bios.asm          ( 4,096 B -> z80bios.bin,              .ORG $0000)
│   ├── z80bios_annotated.asm
│   ├── z80_cfg.json
│   └── z80_cfg.md
│
├── character_rom/
│   └── characters.asm       ( 8,192 B -> characters.390059-01.bin, .ORG $0000)
│
├── build_roms.py            (Deterministic MOS 8502 + Zilog Z80A assembler)
└── verify_roms.py           (Independent cryptographic & byte-by-byte verifier)
```

---

## 2. Instruction Encoding Fidelity & Disambiguation

### 2.1 MOS 8502 Addressing Mode Disambiguation (`.W` Forced 16-Bit Absolute)
In the original Commodore 128 BASIC and KERNAL ROMs (originally assembled on Commodore's BSO / HCD65 cross-assembler), several instructions reference zero-page addresses (`$0000–$00FF`) using **3-byte 16-bit absolute opcodes** rather than 2-byte zero-page opcodes. This occurs in two primary scenarios:
1. **`BIT $00A9` / `BIT $00A0` (`2C A9 00` / `2C A0 00`) Skip Idiom:** Used throughout Microsoft/Commodore BASIC (`$4C88`, `$5606`, `$58B6`, `$B233`, etc.) to skip a 2-byte `LDA #$xx` or `LDY #$xx` instruction without branching. Had a naive assembler encoded `BIT $A9` as 2-byte zero-page `24 A9`, the ROM would shift by 1 byte and corrupt all subsequent addresses!
2. **Indexed Zero-Page Accesses (`LDA $0002,Y` `B9 02 00`, `STA $005D,Y` `99 5D 00`):** The 6502/8502 instruction set has no `STA zp,Y` (`zpy` only exists for `LDX`/`STX`), and only supports `aby` (`99 lo hi` / `B9 lo hi`) for general `A`-register `,Y` indexing.

To preserve 100% instruction encoding fidelity without falling back to `.BYTE` directives for valid instructions:
- [`asm/8502/basic_low.asm`](file:///D:/Emulation/C128/asm/8502/basic_low.asm), [`asm/8502/basic_high.asm`](file:///D:/Emulation/C128/asm/8502/basic_high.asm), and [`asm/8502/kernal.asm`](file:///D:/Emulation/C128/asm/8502/kernal.asm) emit explicit `.W` width suffixes (e.g., `BIT.W $00A0`, `LDA.W $0002,Y`, `ORA.W $00A1,X`) whenever a 3-byte absolute/indexed instruction targets an address `< $0100`.
- [`asm/build_roms.py`](file:///D:/Emulation/C128/asm/build_roms.py) parses the `.W` suffix (`force_abs = True`) and emits the exact 3-byte `abs` / `abx` / `aby` opcode.

### 2.2 Relative Branch Reconstruction (`8502` and `Z80`)
- All 8502 relative branches (`BPL`, `BMI`, `BVC`, `BVS`, `BCC`, `BCS`, `BNE`, `BEQ`) and Z80 relative branches (`JR`, `JR Z`, `JR NZ`, `JR C`, `JR NC`, `DJNZ`) are written in assembly source using their **16-bit target address** (e.g., `BNE $43BE`, `JR NZ,$0054`).
- During assembly, [`asm/build_roms.py`](file:///D:/Emulation/C128/asm/build_roms.py) dynamically computes the signed 8-bit displacement `(target - (PC + 2)) & 0xFF` from the current `.ORG`-tracked program counter `PC`.

### 2.3 Zilog Z80A & Dual-Processor Payload Handling (`asm/z80/z80bios.asm`)
- All Z80 executable routines (`$0000–$0D19`, `$0EF5–$0F03`) are represented as native Zilog Z80A mnemonics (`LD`, `OUT (C),r`, `IN r,(C)`, `LDIR`, `CPIR`, `EX AF,AF'`, `EXX`, `RST $08..$38`, `BIT/RES/SET`, etc.).
- Inline 1-byte parameters immediately following `RST $10` (`$D7`) and `RST $18` (`$DF`) are preserved as documented `.BYTE $xx` directives with target annotations (`40c:$xxxx / 80c:$xxxx`).
- Embedded **MOS 8502 slave payloads** inside the Z80 BIOS ROM (`$0D1A–$0D21` cold-boot trampoline, `$0D22–$0EE4` 8502 slave disk driver, and `$0EE5–$0EF4` 8502 half of the `$FFD0` shared handoff stub) are preserved as `.BYTE` directives in `z80bios.asm` with their full decoded MOS 8502 instructions documented in the right-hand comments (`; [8502 @ $3000]: ...`), respecting the strict architectural rule never to decode 8502 machine code as Z80 instructions.

---

## 3. Reproducible Windows Build & Verification Instructions

From `D:\Emulation\C128`, execute:

```powershell
# 1. Assemble all 5 ROM images from asm/ into reconstruction/build/
python asm/build_roms.py

# 2. Independently verify lengths, SHA-256, CRC32, byte-by-byte diffs, and coverage
python asm/verify_roms.py
```

---

## 4. Limitations & Unresolved Byte Accounting

As required by the Phase 6 specification (*"A byte-identical build does not automatically establish that every function has been understood. Report separately: percentage of bytes represented by decoded instructions, percentage represented by identified data, percentage preserved as unresolved bytes"*):
- Across all **61,440 bytes** of the 5 ROMs:
  - **40,696 bytes (66.24%)** are assembled directly from **decoded CPU instructions** (MOS 8502 and Zilog Z80A mnemonics).
  - **20,476 bytes (33.33%)** are **identified data tables, strings, font glyphs, embedded cross-CPU payloads, hardware vectors, and verified `$FF` unused ROM padding**.
  - **268 bytes (0.44%)** across the three 8502 ROMs (`60` bytes in `basic_low.asm`, `131` bytes in `basic_high.asm`, and `77` bytes in `kernal.asm`) are single-byte inline data/parameter bytes or small embedded lookup constants scattered between subroutines that did not match documented 8502 instruction boundaries and are explicitly marked `[UNRESOLVED]` as `.BYTE $xx` directives for future semantic annotation.
