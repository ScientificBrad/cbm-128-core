# PHASE 1 DELIVERABLE 1.2: ROM REVISION IDENTIFICATION AND HISTORICAL LINEAGE

**Project:** `cbm-128-core`  
**Target:** Commodore 128 Original 1985 Firmware Set  
**Investigation Phase:** Phase 1 — ROM Forensics and Identification  
**Evidence Location:** [`REA/EVIDENCE/PHASE1/`](file:///D:/Emulation/C128/REA/EVIDENCE/PHASE1/), [`reports/rom_checksums.json`](file:///D:/Emulation/C128/reports/rom_checksums.json)

---

## 1. Commodore Part Numbers & Revision Classification

Every file in the input set has been cross-referenced against binary internal markers, embedded date strings, checksum bytes, and Commodore historical part numbers:

| File | Commodore Part # | IC Type | Socket (Flat C128 PCB) | Firmware Revision | Release Era | Classification |
|---|---|---|---|---|---|---|
| [`basic-4000.318018-02.bin`](file:///D:/Emulation/C128/basic-4000.318018-02.bin) | **318018-02** | 23128 / 27128 (16 KB) | **U34** | Revision 02 (1985 Initial Production) | May–June 1985 | **CONFIRMED** |
| [`basic-8000.318019-02.bin`](file:///D:/Emulation/C128/basic-8000.318019-02.bin) | **318019-02** | 23128 / 27128 (16 KB) | **U33** | Revision 02 (1985 Initial Production) | May–June 1985 | **CONFIRMED** |
| [`kernal.318020-03.bin`](file:///D:/Emulation/C128/kernal.318020-03.bin) | **318020-03** | 23128 / 27128 (16 KB) | **U35** | Revision 03 (1985 Initial Production) | May 12, 1985 (`05/12/85`) | **CONFIRMED** |
| [`characters.390059-01.bin`](file:///D:/Emulation/C128/characters.390059-01.bin) | **390059-01** | 2364 / 2764 (8 KB) | **U18** | Revision 01 (US / International ASCII/PETSCII) | 1985 | **CONFIRMED** |
| [`z80bios.bin`](file:///D:/Emulation/C128/z80bios.bin) | Slice of **318020-03** | 4 KB logical extract | **U35** (`0x1000–0x1FFF`) | Revision 03 (`05/12/85`) | May 12, 1985 | **CONFIRMED** |

---

## 2. Internal Binary Evidence of Release Date & Revision

### 2.1 Embedded Build Date in Z80 BIOS / KERNAL (`05/12/85`)
- **Finding ID:** `C128-ROM-002` (**CONFIRMED**)
- At file offset `0x1030–0x1037` in [`kernal.318020-03.bin`](file:///D:/Emulation/C128/kernal.318020-03.bin) (and `0x0030–0x0037` in [`z80bios.bin`](file:///D:/Emulation/C128/z80bios.bin)), located directly at the Z80 `RST 30h` vector address (`$0030` in Z80 space, `$D030` in physical ROM), the firmware contains the exact 8-byte ASCII string:
  ```text
  30 35 2F 31 32 2F 38 35   ->  "05/12/85" (May 12, 1985)
  ```
- This confirms that `318020-03` was finalized on or immediately after **May 12, 1985**, for the initial retail launch of the Commodore 128 in mid-1985.

### 2.2 Embedded Copyright & Designer Signatures in BASIC 7.0 (`1985`)
- **Finding ID:** `C128-ROM-003` (**CONFIRMED**)
- At file offset `0x01BC` (`$41BC`) in [`basic-4000.318018-02.bin`](file:///D:/Emulation/C128/basic-4000.318018-02.bin), the startup banner declares:
  ```text
  COMMODORE BASIC V7.0 122365 BYTES FREE
    (C)1985 COMMODORE ELECTRONICS, LTD.
          (C)1977 MICROSOFT CORP.
            ALL RIGHTS RESERVED
  ```
- At file offset `0x23F5` (`$63F5`) in [`basic-4000.318018-02.bin`](file:///D:/Emulation/C128/basic-4000.318018-02.bin), the developer Easter egg string is present:
  ```text
  FRED B\rTERRY R\rMIKE I\r
  ```
- Each sub-ROM module embeds a 2-byte trailer (`0x00` revision/marker + checksum adjust byte) at the end of its logical block:
  - `basic-4000.318018-02.bin` at `$7FFE-$7FFF`: `0x00 0x4C`
  - `basic-8000.318019-02.bin` at `$BFFE-$BFFF`: `0x00 0x3A`
  - `kernal.318020-03.bin` Screen Editor block at `$CFFE-$CFFF`: `0x00 0xC3`
  - `kernal.318020-03.bin` KERNAL checksum/revision byte at `$FF80`: `0x00`

---

## 3. Applicable Motherboard Revisions & Socket Topology

The original 1985 Commodore 128 ("Flat" case, Assy #310379 /PCB #310378) provides four 28-pin system ROM sockets (`U32`, `U33`, `U34`, `U35`) plus one 24/28-pin Character ROM socket (`U18`):

| Socket | Address Decode | 1985 Multi-ROM Config (This Set) | Later Cost-Reduced Config (32 KB ROMs) |
|---|---|---|---|
| **U32** | `$C000-$FFFF` (C64 Mode) | `251913-01` (16 KB C64 BASIC+KERNAL) | `251913-01` (16 KB) |
| **U33** | `$8000-$BFFF` (C128 BASIC Hi) | **`318019-02`** (16 KB) | Empty (merged into 32 KB `U34`) |
| **U34** | `$4000-$7FFF` (or `$4000-$BFFF`) | **`318018-02`** (16 KB) | `318022-01` (1985 32 KB) or `318022-02` (1986 32 KB) |
| **U35** | `$C000-$FFFF` (C128 KERNAL/Ed/Z80) | **`318020-03`** (16 KB) | `318020-03` (1985) or `318020-04`/`05` (1986) or 32 KB in C128DCR |
| **U18** | `$D000-$DFFF` (VIC-II / CPU Char) | **`390059-01`** (8 KB) | `390059-01` (8 KB) |

---

## 4. Comparison: 1985 Revision (Target) vs. 1986 Revision (Excluded)

In accordance with Task 1.2 ("Do not mix 1985 and 1986 revisions without explicitly identifying the differences"):

| Component | 1985 Original Set (Present in Workspace) | 1986 Updated Set (Not Used) | Key Technical Differences |
|---|---|---|---|
| **BASIC 7.0 Lower** | `318018-02` (`CRC32: 2ee6e2fa`) | `318018-04` (`CRC32: c14998f5`) | 1986 R4 fixed minor BASIC 7.0 bugs (`CHAR` in 80-col mode, `PAINT`, `SPRSAV`, RS-232 buffer bugs) and updated copyright string to `(C)1986`. Our target is strictly the **1985 `-02` revision**. |
| **BASIC 7.0 Upper** | `318019-02` (`CRC32: d551fce0`) | `318019-04` (`CRC32: 6e2c91a7`) | 1986 R4 adjusted upper BASIC routines and ML Monitor offsets to pair with `318018-04` (must never be mixed with `-02` because routines jump across the `$7FFF/$8000` boundary, e.g., `$8009: JMP $7D28`). |
| **KERNAL / Editor / Z80** | `318020-03` (`CRC32: 1e94bb02`) | `318020-04` / `318020-05` | `318020-03` is the original 1985 NTSC/PAL International KERNAL (`$FF80 = 0x00`). Later `-04`/`-05` revisions patched minor IEEE/IEC serial timing and Editor bugs. |
| **Character ROM** | `390059-01` (`CRC32: 6aaaafe6`) | National variants (`315079-01` German, `325167-01` Swedish, etc.) | `390059-01` is the standard US/International 8 KB character generator containing the C64 font in the lower 4 KB (`0x0000–0x0FFF`) and the C128 modified font in the upper 4 KB (`0x1000–0x1FFF`). |

---

## 5. Cross-Image Compatibility & Inter-ROM Coupling Proof

**Finding ID:** `C128-ROM-004` (**CONFIRMED**)

Binary inspection proves that `basic-4000.318018-02.bin` (`318018-02`) and `basic-8000.318019-02.bin` (`318019-02`) are tightly coupled as a single 32 KB logical assembly (`$4000-$BFFF`):

1. **Direct Cross-ROM Jumps (`$4000` -> `$8000`):**
   - At `$4006` (offset `0x0006` in `318018-02`): `4C 4D A8` (`JMP $A84D` in `318019-02`).
   - In the keyword dispatch table (`$4701–$484A` in `318018-02`), dozens of BASIC 7.0 commands (`SPRITE`, `MOVSPR`, `PLAY`, `ENVELOPE`, `FILTER`, `GRAPHIC`, `BOX`, `CIRCLE`, `PAINT`, `CHAR`, `RENUMBER`, `MONITOR`) point directly to target addresses in `$8000–$BFFF` (`318019-02`).
2. **Direct Cross-ROM Jumps (`$8000` -> `$4000`):**
   - At `$8009` (offset `0x0009` in `318019-02`): `4C 28 7D` (`JMP $7D28` in `318018-02`).
   - Error traps throughout `318019-02` jump directly to error handlers in `318018-02` (such as `JMP $4D3C` and `JMP $4D37`).

Therefore, `318018-02` and `318019-02` **must** always be used together as an matched pair.

---

## 6. Cross-Image Verification: `z80bios.bin` vs `kernal.318020-03.bin` (Task 1.4)

**Finding ID:** `C128-ROM-005` (**CONFIRMED**)

A byte-for-byte comparison between `z80bios.bin` (4,096 bytes) and all 4 KB slices of `kernal.318020-03.bin` (16,384 bytes) was executed by [`scripts/phase1_forensics.py`](file:///D:/Emulation/C128/scripts/phase1_forensics.py) and logged in [`reports/rom_checksums.json`](file:///D:/Emulation/C128/reports/rom_checksums.json):

| KERNAL File Offset | KERNAL Physical Address | Slice CRC32 | Slice SHA-256 | Matching Bytes vs `z80bios.bin` | Differing Bytes | Exact Match? |
|---|---|---|---:|---:|---:|---|
| `0x0000–0x0FFF` | `$C000–$CFFF` (Screen Editor) | `4c2793ba` | `994e5341...6515` | 33 / 4,096 | 4,063 | `false` |
| **`0x1000–0x1FFF`** | **`$D000–$DFFF` (Z80 BIOS Slice)** | **`c38d83c6`** | **`39c7656b...062f`** | **4,096 / 4,096** | **0** | **`true` (100%)** |
| `0x2000–0x2FFF` | `$E000–$EFFF` (KERNAL Low) | `6cf3f696` | `22a2054c...67c5` | 42 / 4,096 | 4,054 | `false` |
| `0x3000–0x3FFF` | `$F000–$FFFF` (KERNAL High) | `376e1bbf` | `0d990b22...2fdb` | 57 / 4,096 | 4,039 | `false` |

### Architectural Conclusion on `z80bios.bin`:
1. `z80bios.bin` is **100% byte-for-byte identical** (`0` differing bytes, identical SHA-256 `39c7656b326e4ad724ff4b50c995cb3b2b8ff9ed3bb2b4d277eb0ecd3cac062f` and CRC32 `c38d83c6`) to file offset `0x1000–0x1FFF` of `kernal.318020-03.bin`.
2. **Hardware Mechanism:** In the Commodore 128 `U35` 16 KB system ROM (`318020-03`), when the MOS 8502 is active and system ROM is enabled at `$C000-$FFFF`, the `$D000-$DFFF` address window is decoded by the PLA/MMU to map either the I/O registers (`$D000-$DFFF`), the Character Generator ROM (`U18`), or RAM—rendering the physical `$D000-$DFFF` quarter of `U35` (`0x1000–0x1FFF`) inaccessible to the 8502!
3. Instead, when the **Zilog Z80A** processor is active and MMU Bank 0 (ROM bank) is selected, the hardware address translator remaps physical `U35` offset `0x1000–0x1FFF` (`$D000-$DFFF` on the ROM chip) down to Z80 logical address **`$0000-$0FFF`** so the Z80 can execute its power-on reset (`$0000`), `RST` vectors (`$0008-$0038`), NMI handler (`$0066`), and CP/M 3.0 bootstrap loader directly from `U35` without requiring a separate physical Z80 ROM chip.
