# Phase 6 Deliverable 20: Independent Binary Comparison & Reconstruction Coverage Report

**Classification:** `CONFIRMED`  
**Verification Script:** [`asm/verify_roms.py`](file:///D:/Emulation/C128/asm/verify_roms.py)  
**Machine-Readable Reports:** [`reports/reconstruction_results.json`](file:///D:/Emulation/C128/reports/reconstruction_results.json), [`reports/reconstruction_coverage.json`](file:///D:/Emulation/C128/reports/reconstruction_coverage.json)

---

## 1. Automated Bit-Exact Verification Results

Every reconstructed assembly source file in `asm/` was assembled into `reconstruction/build/` by [`asm/build_roms.py`](file:///D:/Emulation/C128/asm/build_roms.py) and compared byte-for-byte against the original read-only ROM images in `D:\Emulation\C128\` by [`asm/verify_roms.py`](file:///D:/Emulation/C128/asm/verify_roms.py):

| ROM Image | Source File | Origin | Expected / Rebuilt Size | Original & Rebuilt CRC32 | Original & Rebuilt SHA-256 | Byte Diffs | First Diff | Result |
|---|---|---|---:|---|---|---:|---|---|
| `basic-4000.318018-02.bin` | [`asm/8502/basic_low.asm`](file:///D:/Emulation/C128/asm/8502/basic_low.asm) | `$4000` | `16,384 / 16,384 B` | `2ee6e2fa` | `c5ddb7c57dd0b6f259b95b9dd0494ba807cbe6dce8f1f19410a0a05833aa0b5e` | **0** | `None` | **PASS** |
| `basic-8000.318019-02.bin` | [`asm/8502/basic_high.asm`](file:///D:/Emulation/C128/asm/8502/basic_high.asm) | `$8000` | `16,384 / 16,384 B` | `d551fce0` | `e1432465b8abafd3397b0e6cb4eb8422449fb3f85c6366e8616b48c35a86ad79` | **0** | `None` | **PASS** |
| `kernal.318020-03.bin` | [`asm/8502/kernal.asm`](file:///D:/Emulation/C128/asm/8502/kernal.asm) | `$C000` | `16,384 / 16,384 B` | `1e94bb02` | `dcb17b5ce33c2490005b5d0f2a4d767ae56e8ab7ed41d6aa20c43173449e4786` | **0** | `None` | **PASS** |
| `z80bios.bin` | [`asm/z80/z80bios.asm`](file:///D:/Emulation/C128/asm/z80/z80bios.asm) | `$0000` | `4,096 / 4,096 B` | `c38d83c6` | `39c7656b326e4ad724ff4b50c995cb3b2b8ff9ed3bb2b4d277eb0ecd3cac062f` | **0** | `None` | **PASS** |
| `characters.390059-01.bin` | [`asm/character_rom/characters.asm`](file:///D:/Emulation/C128/asm/character_rom/characters.asm) | `$0000` | `8,192 / 8,192 B` | `6aaaafe6` | `f08d8f525b44f5cbb3f5776739fcdff737886e1813f1eb7a20aedb128db1d4a8` | **0** | `None` | **PASS** |
| **TOTAL (5 ROMs)** | — | — | **61,440 / 61,440 B** | — | — | **0** | **`None`** | **PASS** |

---

## 2. Instruction vs. Identified Data vs. Unresolved Byte Breakdown

In accordance with the Phase 6 reporting requirements, the table below separates **decoded CPU instructions**, **identified data (tables, strings, font glyphs, vectors, and verified `$FF` padding)**, and **unresolved bytes** (`[UNRESOLVED]` `.BYTE` fallbacks):

| ROM Image | Total Bytes | Decoded Instructions (Bytes / %) | Identified Tables & Strings (Bytes / %) | Verified `$FF` Padding (Bytes / %) | Combined Identified Data (Bytes / %) | Unresolved Bytes (Bytes / %) | Byte-Identical? |
|---|---:|---:|---:|---:|---:|---:|---|
| **`basic-4000.318018-02.bin`** | 16,384 | **13,925 B (84.99%)** *(6,294 insts)* | 2,017 B (12.31%) | 382 B (2.33%) | **2,399 B (14.64%)** | **60 B (0.37%)** | **YES (`0` diffs)** |
| **`basic-8000.318019-02.bin`** | 16,384 | **13,414 B (81.87%)** *(5,882 insts)* | 574 B (3.50%) | 2,265 B (13.82%) | **2,839 B (17.33%)** | **131 B (0.80%)** | **YES (`0` diffs)** |
| **`kernal.318020-03.bin`** | 16,384 | **10,335 B (63.08%)** *(4,679 insts)* | 4,987 B (30.44%) | 985 B (6.01%) | **5,972 B (36.45%)** | **77 B (0.47%)** | **YES (`0` diffs)** |
| **`z80bios.bin`** | 4,096 | **3,022 B (73.78%)** *(1,334 insts)* | 1,074 B (26.22%) | 0 B (0.00%) | **1,074 B (26.22%)** | **0 B (0.00%)** | **YES (`0` diffs)** |
| **`characters.390059-01.bin`** | 8,192 | **0 B (0.00%)** *(pure font ROM)* | 8,192 B (100.00%) | 0 B (0.00%) | **8,192 B (100.00%)** | **0 B (0.00%)** | **YES (`0` diffs)** |
| **OVERALL (All 5 ROMs)** | **61,440** | **40,696 B (66.24%)** *(18,189 insts)* | **16,844 B (27.42%)** | **3,632 B (5.91%)** | **20,476 B (33.33%)** | **268 B (0.44%)** | **YES (`0` diffs)** |

> [!NOTE]
> **Executive Summary of C128 Executable Code ROMs (Excluding 8 KB Character Font ROM):**
> Across the 53,248 bytes of executable firmware (`basic-4000`, `basic-8000`, `kernal`, and `z80bios`):
> - **76.43% (40,696 bytes)** are decoded CPU instructions (`18,189` instructions).
> - **23.07% (12,284 bytes)** are identified tables, strings, vectors, embedded cross-CPU payloads (`$D000–$DFFF` Z80 BIOS in `U35` and `$0D1A–$0EF4` 8502 slave routines in `z80bios.bin`), and `$FF` padding.
> - **0.50% (268 bytes)** are preserved as `[UNRESOLVED]` `.BYTE` directives where inline data bytes or small uncatalogued lookup tables appear between subroutines.

---

## 3. Detailed Inventory of Preserved Data, Padding & Vectors

### 3.1 `basic-4000.318018-02.bin` (`asm/8502/basic_low.asm`)
- **Identified Data Tables & Strings (`2,017` bytes):**
  - `$4189–$418C`: MMU `PCRA–PCRD` initialization bytes (`$3F, $7F, $01, $41`).
  - `$41B8–$424F`: Startup sign-on banner and copyright strings.
  - `$4251–$4278`: Default VIC-IIe, SID, and sprite initialization tables.
  - `$4417–$4608`: Primary keyword token table (126 tokens, `$80–$FD`).
  - `$4609–$46C8`: Extended `$FE` statement keyword table (37 tokens, `$FE $02–$26`).
  - `$46C9–$46FB`: Extended `$CE` function keyword table (9 tokens, `$CE $02–$0A`).
  - `$46FC–$47D7`: Statement dispatch vector table (`STMDSP`, 110 `RTS-1` vectors).
  - `$47D8–$4827`: Function dispatch vector table (`FUNDSP`, 40 direct vectors).
  - `$4828–$4845`: Operator precedence & vector table (`OPTAB`, 10 entries).
  - `$484B–$4A81`: Error message string table (41 messages, codes `$01–$29`).
  - `$4D1F–$4D36`, `$5288–$528E`, `$56AA–$56B1`: Prompt & error status strings (`READY.`, `BREAK`, `REDO FROM START`).
  - `$63F5–$640A`: Embedded designer credits (`FRED B / TERRY R / MIKE I`).
  - `$6BC4–$6BC8`, `$6CB3–$6CBA`, `$6DD9–$6DE2`, `$6FE4–$7045`: Graphics, sprite bitmask, and `PLAY`/`ENVELOPE` lookup tables.
  - `$7FFE–$7FFF`: ROM revision and checksum trailer (`$52 $17`).
- **Verified Unused Padding (`382` bytes):**
  - `$4021–$4022` (2 bytes `$FF`) and `$7E82–$7FFD` (380 bytes `$FF`).

### 3.2 `basic-8000.318019-02.bin` (`asm/8502/basic_high.asm`)
- **Identified Data Tables & Strings (`574` bytes):**
  - `$81F3–$8202`, `$823D–$824C`, `$835B–$8360`: VDC color translation, `JOY` direction decode, and `RSPRITE` register offset tables.
  - `$8E13–$8E31`, `$8F8A–$8FC0`, `$9028–$907A`, `$9100–$912A`: 5-byte floating-point polynomial series constants (`FOUT`, `LOG`, `SQR`, `EXP`, `SIN`, `COS`, `ATN`).
  - `$9F25–$9F4E`, `$A3B8–$A3BE`: Bitmapped graphics and DOS command parameter mask tables.
  - `$B00C–$B013`, `$B03D–$B045`, `$B053–$B06F`, `$B0BF–$B0C1`, `$B1CC–$B1CF`, `$B20E–$B210`, `$B3C7–$B3CD`, `$B536–$B53A`, `$B5B1–$B5B4`: ML Monitor inline `J_PRIMM` strings.
  - `$B0E6–$B119`: ML Monitor 22-command lookup table and 15-entry `RTS-1` vector table.
  - `$B714–$B7A0`, `$B88A–$B891`: ML Monitor 8502 addressing mode, 5-bit packed mnemonic, and multi-radix tables.
  - `$BFFE–$BFFF`: ROM revision and checksum trailer (`$02 $AF`).
- **Verified Unused Padding (`2,265` bytes):**
  - `$AA6E–$AE62` (1,013 bytes `$FF`), `$AFA8–$AFFF` (88 bytes `$FF`), and `$BB72–$BFFD` (1,164 bytes `$FF`).

### 3.3 `kernal.318020-03.bin` (`asm/8502/kernal.asm`)
- **Identified Data Tables, Embedded Z80 BIOS & Vectors (`4,987` bytes):**
  - `$C030–$C065`, `$CBD3–$CC33`, `$CE5C–$CEF4`: Screen Editor line address tables, escape sequence tables, 8563 VDC register initialization table, and default function key strings.
  - `$CFFE–$CFFF`: Screen Editor revision and checksum trailer.
  - `$D000–$DFFF` (4,096 bytes): Embedded Z80 BIOS binary image inside physical ROM `U35` (identically reconstructed as native Z80 code in [`asm/z80/z80bios.asm`](file:///D:/Emulation/C128/asm/z80/z80bios.asm)).
  - `$E04B–$E055`, `$F6AD–$F718`, `$F7F0–$F7FF`, `$FA80–$FC3A`: KERNAL MMU init table, I/O status messages, `GETCFG` bank table, and keyboard matrix decode tables.
  - `$FF80`: KERNAL release revision byte (`$00`).
  - `$FFFA–$FFFF`: MOS 8502 hardware interrupt vectors (`NMI = $FF05`, `RESET = $FF3D`, `IRQ/BRK = $FF17`).
- **Verified Unused Padding & Hardware Overlay Slots (`985` bytes):**
  - `$CEF5–$CFFD` (265 bytes `$FF`), `$FC3B–$FEFF` (709 bytes `$FF`), `$FF00–$FF04` (5 bytes `$FF` underlying the MMU `$FF00–$FF04` hardware registers), `$FF45–$FF46` (2 bytes `$FF`), and `$FFF6–$FFF9` (4 bytes `$FF`).
