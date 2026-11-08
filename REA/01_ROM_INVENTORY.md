# PHASE 1 DELIVERABLE 1.1: ROM FORENSICS AND BINARY INVENTORY

**Project:** `cbm-128-core`  
**Target:** Commodore 128 Original 1985 Firmware Set  
**Investigation Phase:** Phase 1 — ROM Forensics and Identification  
**Evidence Location:** [`REA/EVIDENCE/PHASE1/`](file:///D:/Emulation/C128/REA/EVIDENCE/PHASE1/), [`reports/rom_checksums.json`](file:///D:/Emulation/C128/reports/rom_checksums.json), [`reports/rom_inventory.csv`](file:///D:/Emulation/C128/reports/rom_inventory.csv)

---

## 1. Immutable Binary Inventory Summary

All five source ROM images in `D:\Emulation\C128` have been verified strictly read-only. Every file matches its expected byte length, totalling **61,440 bytes** (60 KB).

| Filename | Part Number | Bytes | Expected | CPU Address | CRC32 | MD5 (Historical) | SHA-1 | SHA-256 |
|---|---|---:|---:|---|---|---|---|---|
| [`basic-4000.318018-02.bin`](file:///D:/Emulation/C128/basic-4000.318018-02.bin) | `318018-02` | 16,384 | 16,384 | `$4000-$7FFF` | `2ee6e2fa` | `0e51e2cccc9e7028ed48a45d402402f9` | `60e1491e1d5782e3cf109f518eb73427609badc6` | `c5ddb7c57dd0b6f259b95b9dd0494ba807cbe6dce8f1f19410a0a05833aa0b5e` |
| [`basic-8000.318019-02.bin`](file:///D:/Emulation/C128/basic-8000.318019-02.bin) | `318019-02` | 16,384 | 16,384 | `$8000-$BFFF` | `d551fce0` | `788a59e0cf22cc8421f1ea59f199b6f9` | `4d223883e866645328f86a904b221464682edc4f` | `e1432465b8abafd3397b0e6cb4eb8422449fb3f85c6366e8616b48c35a86ad79` |
| [`kernal.318020-03.bin`](file:///D:/Emulation/C128/kernal.318020-03.bin) | `318020-03` | 16,384 | 16,384 | `$C000-$FFFF` | `1e94bb02` | `25a0f37e843e3643fce21fb6fd65bd4d` | `e80ffbafae068cc0e42698ec5c5c39af46ac612a` | `dcb17b5ce33c2490005b5d0f2a4d767ae56e8ab7ed41d6aa20c43173449e4786` |
| [`characters.390059-01.bin`](file:///D:/Emulation/C128/characters.390059-01.bin) | `390059-01` | 8,192 | 8,192 | `$D000-$DFFF` (Banked) | `6aaaafe6` | `46b3cb2140f244c0ed1150c819e7bdc4` | `29ed066d513f2d5c09ff26d9166ba23c2afb2b3f` | `f08d8f525b44f5cbb3f5776739fcdff737886e1813f1eb7a20aedb128db1d4a8` |
| [`z80bios.bin`](file:///D:/Emulation/C128/z80bios.bin) | Embedded in `318020-03` | 4,096 | 4,096 | `$0000-$0FFF` (Z80) | `c38d83c6` | `894dad6f8fc898dd4c1174163ed1838a` | `38662a024f1de2f4417a5f9df4898a9985503e06` | `39c7656b326e4ad724ff4b50c995cb3b2b8ff9ed3bb2b4d277eb0ecd3cac062f` |

---

## 2. Statistical & Entropy Distribution Analysis

| ROM Image | 16-bit Sum | 32-bit Sum | Overall Shannon Entropy (bits/byte) | Unique Byte Values | `0xFF` Count | `0x00` Count | `0xAA` Count |
|---|---|---|---:|---:|---:|---:|---:|
| `basic-4000.318018-02.bin` | `0xF640` | `0x001AF640` | **7.1564** | 256 / 256 | 514 (3.14%) | 265 (1.62%) | 82 (0.50%) |
| `basic-8000.318019-02.bin` | `0xA080` | `0x0020A080` | **6.6711** | 256 / 256 | 2,486 (15.17%) | 374 (2.28%) | 78 (0.48%) |
| `kernal.318020-03.bin` | `0x51C4` | `0x001E51C4` | **7.0689** | 256 / 256 | 1,205 (7.35%) | 577 (3.52%) | 81 (0.49%) |
| `characters.390059-01.bin` | `0xEFF4` | `0x000FEFF4` | **4.8195** | 78 / 256 | 1,211 (14.78%) | 1,211 (14.78%) | 0 (0.00%) |
| `z80bios.bin` | `0xBA09` | `0x0005BA09` | **6.8669** | 235 / 256 | 67 (1.64%) | 231 (5.64%) | 4 (0.10%) |

### 2.1 1 KB Block-Level Entropy Profile

Full 1 KB block profiles are stored in [`REA/EVIDENCE/PHASE1/forensics_raw.json`](file:///D:/Emulation/C128/REA/EVIDENCE/PHASE1/forensics_raw.json). Key observations:

1. **`basic-4000.318018-02.bin` (`$4000-$7FFF`)**:
   - Blocks `$4400-$4BFF` exhibit high ASCII concentration (`H = 5.95–6.75`) corresponding to the BASIC 7.0 keyword token tables (`$4417-$4700`), dispatch address tables (`$4701-$484A`), and error message tables (`$484B-$4A84`).
   - Blocks `$4C00-$7BFF` maintain uniform 8502 machine-code entropy (`H = 7.01–7.28`).
   - Block `$7C00-$7FFF` drops to `H = 5.4272` due to a 380-byte `0xFF` padding region (`$7E82-$7FFD`) followed by a 2-byte factory ROM checksum/trailer (`0x00 0x4C` at `$7FFE-$7FFF`).

2. **`basic-8000.318019-02.bin` (`$8000-$BFFF`)**:
   - Blocks `$8000-$A7FF` contain dense 8502 code and floating-point math tables (`H = 6.95–7.23`).
   - Block `$A800-$ABFF` drops to `H = 4.5446` and `$AC00-$AFFF` drops to `H = 3.5512` due to two large unallocated `0xFF` padding regions between the end of BASIC 7.0 upper routines and the Machine Language Monitor at `$B000`.
   - Blocks `$B000-$B7FF` contain the C128 Machine Language Monitor (`H = 6.99–7.12`).
   - Block `$B800-$BBFF` drops to `H = 6.4533` and `$BC00-$BFFF` drops to `H = 0.0250` due to 1,164 bytes of `0xFF` padding (`$BB72-$BFFD`) before the 2-byte trailer (`0x00 0x3A` at `$BFFE-$BFFF`).

3. **`kernal.318020-03.bin` (`$C000-$FFFF`)**:
   - `$C000-$CFFF` (Screen Editor, 4 KB): `H = 6.92–7.18` in `$C000-$CEFF`, dropping in `$CC00-$CFFF` (`H = 5.8624`) due to 265 bytes of `0xFF` padding (`$CEF5-$CFFD`) and a 2-byte Editor ROM trailer (`0x00 0xC3` at `$CFFE-$CFFF`).
   - `$D000-$DFFF` (Z80 BIOS physical ROM slice, 4 KB): `H = 6.66–6.92`, containing Z80 executable code, CP/M 3.0 boot messages, and sector interleave tables.
   - `$E000-$FBFF` (8502 KERNAL services): `H = 6.95–7.27`.
   - `$FC00-$FFFF`: Drops to `H = 3.0457` due to 714 bytes of `0xFF` padding (`$FC3B-$FF04`) preceding the hardware interrupt stubs (`$FF05-$FF46`), extended KERNAL jump table (`$FF47-$FF7F`), checksum byte (`$FF80 = 0x00`), standard KERNAL jump table (`$FF81-$FFF5`), system vectors (`$FFF6-$FFF9`), and 6502/8502 hardware vectors (`$FFFA-$FFFF`).

4. **`characters.390059-01.bin` (`8192 bytes`)**:
   - Contains only **78 unique byte values** across all 8,192 bytes because 8x8 character bitmap rows favour symmetric/aligned horizontal bit patterns.
   - Exact symmetry between `0x00` count (1,211 bytes) and `0xFF` count (1,211 bytes) is **CONFIRMED** as a mathematical consequence of the second half of every 2 KB font set (`char 128..255`, 1,024 bytes per quarter) being the bitwise complement (`XOR 0xFF`) of the first half (`char 0..127`), with only minor exceptions in the C128 lowercase set.

---

## 3. Blank Padding and Repeated Byte Regions

All contiguous repeated-byte runs of length >= 16 bytes across all five ROMs ([`REA/EVIDENCE/PHASE1/segmentation_analysis.json`](file:///D:/Emulation/C128/REA/EVIDENCE/PHASE1/segmentation_analysis.json)):

| ROM Image | Fill Byte | File Offset Range | CPU Address Range | Length (Bytes) | Structural Role |
|---|---|---|---|---:|---|
| `basic-4000.318018-02.bin` | `0xFF` | `0x3E82–0x3FFD` | `$7E82–$7FFD` | 380 | End-of-ROM unused space before `$7FFE-$7FFF` checksum trailer (`00 4C`) |
| `basic-8000.318019-02.bin` | `0xFF` | `0x2A6E–0x2E62` | `$AA6E–$AE62` | 1,013 | Unused gap between BASIC 7.0 upper code and `$AE63` helper/trampoline block |
| `basic-8000.318019-02.bin` | `0xFF` | `0x2FA8–0x2FFF` | `$AFA8–$AFFF` | 88 | Alignment padding immediately before `$B000` ML Monitor |
| `basic-8000.318019-02.bin` | `0xFF` | `0x3B72–0x3FFD` | `$BB72–$BFFD` | 1,164 | End-of-ROM unused space after ML Monitor before `$BFFE-$BFFF` trailer (`00 3A`) |
| `kernal.318020-03.bin` | `0xFF` | `0x0EF5–0x0FFD` | `$CEF5–$CFFD` | 265 | End-of-Screen-Editor unused space before `$CFFE-$CFFF` trailer (`00 C3`) |
| `kernal.318020-03.bin` | `0x00` | `0x22C7–0x22D7` | `$E2C7–$E2D7` | 17 | Zero-filled table/padding inside KERNAL serial/I/O section |
| `kernal.318020-03.bin` | `0xFF` | `0x3C3B–0x3F04` | `$FC3B–$FF04` | 714 | Unused space between KERNAL routines and `$FF05` NMI entry stub |
| `characters.390059-01.bin` | — | None >= 16 B | — | 0 | Maximum single-byte run is 11 bytes (`0x00` / `0xFF` at glyph boundaries) |
| `z80bios.bin` | — | None >= 16 B | — | 0 | Maximum single-byte run is 10 bytes (`0x00` at `0x005C–0x0065` before Z80 NMI `$0066`) |

---

## 4. Extracted Printable Strings & Embedded Signatures

Complete string extractions are stored in [`REA/EVIDENCE/PHASE1/tables_and_strings.json`](file:///D:/Emulation/C128/REA/EVIDENCE/PHASE1/tables_and_strings.json). Key forensic strings and developer Easter eggs verified directly from the ROM bytes:

### 4.1 `basic-4000.318018-02.bin`
- **Startup Banner (`0x01BC / $41BC`, 148 bytes):**
  ```text
  \r@ COMMODORE BASIC V7.0 122365 BYTES FREE\r@   (C)1985 COMMODORE ELECTRONICS, LTD.\r@         (C)1977 MICROSOFT CORP.\r@           ALL RIGHTS RESERVED\r
  ```
- **Embedded Developer Credits (`0x23F5 / $63F5`, 21 bytes):**
  ```text
  FRED B\rTERRY R\rMIKE I\r
  ```
  *(Corresponds to C128 system designers Fred Bowen, Terry Ryan, and Mike盛/Mike I. embedded in BASIC 7.0 lower ROM!)*
- **Interactive Prompts & Messages:**
  - `0x0D2D / $4D2D`: `\rREADY.\r`
  - `0x0DA8 / $4DA8`: ` ERROR`
  - `0x1767 / $5767`: `?REDO FROM START\r`
  - `0x17B9 / $57B9`: `?EXTRA IGNORED\r`
  - `0x3662 / $7662`: `` `COPY FROM? ``
  - `0x366E / $766E`: `SPRITE NUMBER?  `
- **High-Bit Terminated Keyword & Error Tables:**
  - `$4417–$4608`: 126 standard BASIC 7.0 single-byte tokens (`END` through `WHILE`).
  - `$4609–$46C8`: 37 `0xCE`-prefixed/extended command tokens (`BANK` through `SLOW`).
  - `$46C9–$4700`: 9 `0xFE`-prefixed/extended function tokens (`POT`, `BUMP`, `PEN`, `RSPPOS`, `RSPRITE`, `RSPCOLOR`, `XOR`, `RWINDOW`, `POINTER`).
  - `$484B–$4A84`: 41 BASIC 7.0 error messages (`TOO MANY FILES` through `FILE READ`).

### 4.2 `basic-8000.318019-02.bin`
- `0x0E29 / $8E29`: ` IN `
- `0x115A / $915A`: `\rOK\r`
- `0x27E8 / $A7E8`: `ARE YOU SURE?`
- `0x300C / $B00C`: `\rBREAK`
- `0x303D / $B03D`: `\rMONITOR`
- `0x3053 / $B053`: `\r    PC  SR AC XR YR SP\r; `
- `0x30E6 / $B0E6`: `ACDFGHJMRTX@.>;$+&%LSV` (ML Monitor command dispatch table characters)

### 4.3 `kernal.318020-03.bin` & `z80bios.bin`
- **Default Function Key Definitions (`0x0EB2 / $CEB2`):**
  - `GRAPHIC`, `DLOAD"`, `DIRECTORY\r`, `SCNCLR\r`, `DSAVE"`, `RUN\r`, `LIST\r`, `MONITOR\r`, `D"*`, `RUN\r`, `HELP\r`
- **Z80 BIOS Embedded Date Stamp (`0x1030 / $D030` in KERNAL, `0x0030` in `z80bios.bin`):**
  - `05/12/85` (ASCII bytes `30 35 2F 31 32 2F 38 35` located right at Z80 `RST 30h` vector `$0030`!)
- **Z80 BIOS CP/M 3.0 Loader Strings (`$D0EE–$D50A` in KERNAL / `$00EE–$050A` in `z80bios.bin`):**
  - `0x00EE`: `CPM+    SYS`
  - `0x01F6`: `BOOTING CP/M PLUS`
  - `0x0254`: `DATA TABLES`
  - `0x027D`: `COMMON CODE`
  - `0x0294`: `BANKED CODE`
  - `0x02AB`: `BIOS8502 CODE`
  - `0x0485`: `32K MAX CPM+.SYS SIZE`
  - `0x04AD`: `READ ERROR`
  - `0x04BB`: ` - HIT RETURN TO RETRY`
  - `0x04D3`: `DEL TO ENTER C128 MODE`
  - `0x050A`: ` CPM+.SYS FILE`
- **KERNAL Tape, Disk & Auto-Boot Messages (`$F6AD–$F932`):**
  - `$F6B0`: `\rI/O ERROR `
  - `$F6BC`: `\rSEARCHING`
  - `$F6CB`: `\rPRESS PLAY ON TAP` (`E` with bit 7 set: `0xC5`)
  - `$F6DE`: `PRESS RECORD & PLAY ON TAP` (`E` with bit 7 set: `0xC5`)
  - `$F6F9`: `\rLOADIN` (`G` with bit 7 set: `0xC7`)
  - `$F701`: `\rSAVING`
  - `$F709`: `\rVERIFYIN` (`G` with bit 7 set: `0xC7`)
  - `$F713`: `\rFOUND`
  - `$F90B`: `\rBOOTING `
  - `$F92F`: `...\r`
- **KERNAL Keyboard Matrix Decode Tables (`$FA80–$FC3A`):**
  - Unshifted, Shifted, Commodore-key, Control-key, Caps-Lock, and Keypad/Extended key matrix translation tables.
