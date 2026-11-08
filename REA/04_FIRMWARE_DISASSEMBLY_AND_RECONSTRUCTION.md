# PHASE 2 & 3 DELIVERABLE: FIRMWARE DISASSEMBLY, EXECUTION FLOWS AND BYTE-FOR-BYTE RECONSTRUCTION

**Project:** `cbm-128-core`  
**Target:** Commodore 128 Original 1985 Firmware Set  
**Disassembly Sources:** [`disassembly/`](file:///D:/Emulation/C128/disassembly/)  
**Reconstructible Assembly Sources:** [`reconstruction/src/`](file:///D:/Emulation/C128/reconstruction/src/)  
**Verification Report:** [`reports/reconstruction_verification.json`](file:///D:/Emulation/C128/reports/reconstruction_verification.json)

---

## 1. Complete Disassembly & Reconstructible Source Inventory

All five ROM images (61,440 bytes total) have been disassembled into complete, human-readable assembly listings and independently assemblable source files:

| ROM Image | Disassembly / Source File | Lines | Architecture | Address Range | Verification Status |
|---|---|---:|---|---|---|
| [`basic-4000.318018-02.bin`](file:///D:/Emulation/C128/basic-4000.318018-02.bin) | [`basic_4000_318018_02.asm`](file:///D:/Emulation/C128/reconstruction/src/basic_4000_318018_02.asm) | 7,041 | MOS 8502 | `$4000–$7FFF` | **CONFIRMED (0 diffs)** |
| [`basic-8000.318019-02.bin`](file:///D:/Emulation/C128/basic-8000.318019-02.bin) | [`basic_8000_318019_02.asm`](file:///D:/Emulation/C128/reconstruction/src/basic_8000_318019_02.asm) | 6,850 | MOS 8502 | `$8000–$BFFF` | **CONFIRMED (0 diffs)** |
| [`kernal.318020-03.bin`](file:///D:/Emulation/C128/kernal.318020-03.bin) | [`kernal_c000_318020_03.asm`](file:///D:/Emulation/C128/reconstruction/src/kernal_c000_318020_03.asm) | 5,929 | MOS 8502 + Z80 | `$C000–$FFFF` | **CONFIRMED (0 diffs)** |
| [`z80bios.bin`](file:///D:/Emulation/C128/z80bios.bin) | [`z80bios_0000.asm`](file:///D:/Emulation/C128/reconstruction/src/z80bios_0000.asm) | 2,240 | Zilog Z80A | `$0000–$0FFF` | **CONFIRMED (0 diffs)** |
| [`characters.390059-01.bin`](file:///D:/Emulation/C128/characters.390059-01.bin) | [`characters_390059_01.asm`](file:///D:/Emulation/C128/reconstruction/src/characters_390059_01.asm) | 1,038 | 8×8 Bitmap | `$0000–$1FFF` | **CONFIRMED (0 diffs)** |

### 1.1 Byte-for-Byte Reconstruction Verification Ledger

Reassembling all five source files via `python scripts/assemble_and_verify.py` into `reconstruction/build/` yields 100% identical binaries:

| Target Binary | Original Bytes | Rebuilt Bytes | Byte Diffs | Original & Rebuilt CRC32 | Original & Rebuilt SHA-256 |
|---|---:|---:|---:|---|---|
| `basic-4000.318018-02.bin` | 16,384 | 16,384 | **0** | `2ee6e2fa` | `c5ddb7c57dd0b6f259b95b9dd0494ba807cbe6dce8f1f19410a0a05833aa0b5e` |
| `basic-8000.318019-02.bin` | 16,384 | 16,384 | **0** | `d551fce0` | `e1432465b8abafd3397b0e6cb4eb8422449fb3f85c6366e8616b48c35a86ad79` |
| `kernal.318020-03.bin` | 16,384 | 16,384 | **0** | `1e94bb02` | `dcb17b5ce33c2490005b5d0f2a4d767ae56e8ab7ed41d6aa20c43173449e4786` |
| `characters.390059-01.bin` | 8,192 | 8,192 | **0** | `6aaaafe6` | `f08d8f525b44f5cbb3f5776739fcdff737886e1813f1eb7a20aedb128db1d4a8` |
| `z80bios.bin` | 4,096 | 4,096 | **0** | `c38d83c6` | `39c7656b326e4ad724ff4b50c995cb3b2b8ff9ed3bb2b4d277eb0ecd3cac062f` |

---

## 2. Documented Firmware Execution Flows

### 2.1 Dual-CPU Power-On Reset & Z80 -> 8502 Handoff (`C128-Z80-001` — CONFIRMED)

On hardware power-up or reset, the MOS 8722 MMU initializes its Mode Configuration Register (`$D505` = `0xB0`, Bit 0 = `0`), selecting the **Zilog Z80A** as the first active processor at `$0000` (mapped from `U35` `$D000-$DFFF`):

```mermaid
sequenceDiagram
    participant HW as Hardware Reset (MMU $D505 bit 0 = 0)
    participant Z80 as Zilog Z80A ($0000-$0FFF BIOS)
    participant RAM as Shared RAM Stub ($FFD0-$FFEF)
    participant M8502 as MOS 8502 ($FFFC -> $FF3D -> $E000)
    participant BASIC as BASIC 7.0 ($4000 / $4023)

    HW->>Z80: Reset at PC=$0000
    Z80->>Z80: $0000: LD A,$3E -> LD ($FF00),A -> JP $003B
    Z80->>Z80: $003B: Clear VIC $D02F/$D030 ($FF/$FC)
    Z80->>Z80: $0046: Write $B0 to MMU MCR ($D505), read /GAME & /EXROM (bits 4-5)
    Z80->>Z80: $0059-$007A: Scan CIA1 $DC00/$DC01 for Commodore (C=) key
    Note over Z80: If C= key held or C64 cart grounded:<br/>OUT ($D505),$F1 (C64 mode + 8502)
    Z80->>Z80: $007C-$008B: Initialize MMU $D50A..$D500 from table at $0FAA-$0FB4
    Z80->>RAM: $0097: LDIR 31 bytes from $0EE5 to $FFD0-$FFEF
    Z80->>RAM: $00B1: JP $FFE0 (inside dual-CPU stub in shared RAM)
    RAM->>RAM: $FFE0 (Z80): DI; LD A,$3E; LD ($FF00),A; LD BC,$D505; LD A,$B1; OUT (C),A
    RAM->>M8502: MMU MCR ($D505) bit 0 = 1 -> Halts Z80, releases 8502!
    M8502->>M8502: Hardware Reset fetches $FFFC/$FFFD -> $FF3D
    M8502->>M8502: $FF3D: LDA #$00; STA $FF00; JMP $E000
    M8502->>M8502: $E000: Init MMU ($D500-$D50A), Copy RAM thunks ($02A2), IOINIT ($E109)
    M8502->>M8502: $E031: RAMTAS ($E093), RESTOR ($E056), Editor CINT ($C000)
    M8502->>BASIC: $E045: JMP ($0A00) -> $4000 (BASIC 7.0 Cold Start)
    BASIC->>BASIC: $4023: Init BASIC 7.0, Print Banner ($41BC), Auto-Boot ($F890), READY. ($4D37)
```

#### Exact Byte-Level Mechanics of the `$FFD0–$FFEF` Dual-CPU Handoff Stub:
1. At `$0097` in `z80bios.bin`, the Z80 executes `LD HL,$0EE5; LD DE,$FFD0; LD BC,$001F; LDIR`, copying 31 bytes into common RAM at `$FFD0–$FFEF`:
   - **`$FFD0–$FFDF` (8502-side switch-to-Z80 routine):**
     ```assembly
     $FFD0: 78        SEI
     $FFD1: A9 3E     LDA #$3E
     $FFD3: 8D 00 FF  STA $FF00      ; Map I/O at $D000-$DFFF, RAM everywhere else
     $FFD6: A9 B0     LDA #$B0       ; Bit 0 = 0 (Select Z80)
     $FFD8: 8D 05 D5  STA $D505      ; Switch bus master to Z80!
     $FFDB: EA        NOP            ; Pipeline flush cycle
     $FFDC: 4C 00 00  JMP ($FFDD)    ; Self-modified return target ($1100 on boot)
     ```
   - **`$FFE0–$FFEF` (Z80-side switch-to-8502 routine):**
     ```assembly
     $FFE0: F3        DI
     $FFE1: 3E 3E     LD A,$3E
     $FFE3: 32 00 FF  LD ($FF00),A
     $FFE6: 01 05 D5  LD BC,$D505
     $FFE9: 3E B1     LD A,$B1       ; Bit 0 = 1 (Select 8502)
     $FFEB: ED 79     OUT (C),A      ; Switch bus master to 8502!
     $FFED: 00        NOP
     $FFEE: CF        RST $08        ; When Z80 is later re-enabled by 8502, resumes at RST $08!
     ```
2. Before jumping to `$FFE0`, the Z80 writes `$1100` into `$FFFA`, `$FFFC`, `$FFFE` (in RAM) and `$FFDD` (`$00A2–$00B0`), and copies an 8-byte 8502 trampoline from `$0D1A` to `$1100` (`LDA #$00; STA $FF00; JMP $E000`). Whether the 8502 takes its hardware reset vector from ROM (`$FFFC -> $FF3D`) or resumes from `$FFD0`, it immediately writes `$00` to `$FF00` and jumps to `$E000` (`KERNAL_RESET_START`).

---

### 2.2 MOS 8502 KERNAL Initialization (`$E000–$E265` — `C128-KERNAL-002` — CONFIRMED)

1. **`$E000–$E017` (MMU Register Programming):**
   - `LDX #$FF; SEI; TXS; CLD; LDA #$00; STA $FF00` (Selects Bank 15: all system ROMs + I/O active, RAM Bank 0).
   - Loops `X = $0A` down to `$00`, copying 11 bytes from `$E04B–$E055` (`00 00 00 00 00 BF 04 00 00 01 00`) into `$D500–$D50A`:
     - `$D500 (CR)   = $00` (Bank 15 configuration)
     - `$D501 (PCRA) = $00` (Preconfig A: Bank 15)
     - `$D502 (PCRB) = $00`
     - `$D503 (PCRC) = $00`
     - `$D504 (PCRD) = $00`
     - `$D505 (MCR)  = $BF` (8502 active, C128 mode, fast serial dir)
     - `$D506 (RCR)  = $04` (4 KB common RAM at bottom `$0000-$0FFF` only)
     - `$D507-$D50A  = $00, $00, $01, $00` (Page 0 at `$0000`, Page 1 at `$0100`)
2. **`$E0CD–$E104` (RAM Vector & Far-Call Thunk Installation):**
   - Copies the hardware interrupt entry stubs (`$FF05–$FF44` and `$FFFA–$FFFF`) into the underlying RAM of both banks so interrupts work even when ROM is banked out.
   - Copies 90 bytes (`$F800–$F859`) to **`$02A2–$02FB`** (low-RAM cross-bank `INDFET`, `INDSTA`, `INDCMP`, `JSRFAR`, `JMPFAR` routines) and 13 bytes (`$F85A–$F866`) to **`$03F0–$03FC`**.
3. **`$E109–$E1EF` (`IOINIT`):**
   - Disables and clears CIA1 (`$DC0D`) and CIA2 (`$DD0D`) interrupts; configures keyboard matrix ports (`$DC02 = $FF`, `$DC03 = $00`) and IEC serial / VIC bank ports (`$DD00 = $07`, `$DD02 = $3F`).
   - Configures the 8502 on-chip I/O port (`$01 = $E3`, `$00 = $2F`).
   - Initializes VIC-IIe registers (`$D000–$D02E`) from the table at `$E2C8`, clears 2 MHz mode (`$D030 = $00`), and calls `ED_JINIT80` (`$C027` -> `$CE0C`) to initialize the 8563 VDC 80-column display and copy the 8 KB Character ROM into dedicated VDC VRAM if not yet initialized (`$0A04` bit 7).
   - Zeroes the SID chip (`$D400–$D418`) and enables VIC-IIe raster IRQ (`$D01A = $01`) as the C128's 60 Hz/50 Hz system timer interrupt source!
4. **`$E093–$E0CC` (`RAMTAS`):**
   - Clears Zero Page `$0002–$00FF`, sets top-of-memory pointers (`MEMTOP = $FF00`, `MEMBOT = $1C00`), sets the cold-start jump vector at `$0A00/$0A01` to **`$4000`** (BASIC 7.0 Cold Start), and writes the warm-init magic byte **`$A5`** to **`$0A02`**.
5. **`$E056` (`RESTOR`) & `$C000` (`CINT`):**
   - Copies the 32 bytes of default indirect vectors from `$E073–$E092` into `$0314–$0333` (`CINV = $FA65`, `CBINV = $B003`, `NMINV = $FA40`, `IOPEN = $EF88`, etc.).
   - Calls `$C000` (`ED_JCINT`) to initialize the 40/80-column Screen Editor, window bounds, function keys, and clear the active screen.
6. **`$E03A–$E047` (Mode Dispatch):**
   - Enables interrupts (`CLI`) and jumps through `($0A00)` -> **`$4000`** (`BASIC_COLD_ENTRY`).

---

### 2.3 BASIC 7.0 Cold Start (`$4000 -> $4023` — `C128-BASIC-003` — CONFIRMED)

1. **`$4000: JMP $4023`** (`BASIC_COLD_START`):
   - Initializes BASIC indirect vectors (`$0300–$030B`: `IERROR=$4D3F`, `IMAIN=$4D37`, `ICRNCH=$430A`, `IQPLOP=$5156`, `IGONE=$4F93`, `IEVAL=$5823`).
   - Copies the `CHRGET` routine to Zero Page (`$0380` in C128) and initializes Bank 0 program text space (`$1C01–$FF00`) and Bank 1 variable storage (`$0400–$FF00`), yielding `122365 BYTES FREE`.
   - Prints the sign-on banner from `$41BC`:
     ```text
     COMMODORE BASIC V7.0 122365 BYTES FREE
       (C)1985 COMMODORE ELECTRONICS, LTD.
             (C)1977 MICROSOFT CORP.
               ALL RIGHTS RESERVED
     ```
   - Calls `PHOENIX` (`$FF56` -> `$F867`) and `BOOT_CALL` (`$FF53` -> `$F890`) to check for function ROMs or auto-boot disk sector, then enters the `READY.` direct-mode interpreter loop at **`$4D37`**.
