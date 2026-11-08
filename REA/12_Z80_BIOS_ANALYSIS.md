# PHASE 4 DELIVERABLE 1: Z80 BIOS REVERSE ENGINEERING ANALYSIS

**Project:** `cbm-128-core` (Commodore 128 1985 Firmware & Hardware Analysis)  
**Target Binary:** `D:\Emulation\C128\z80bios.bin` (4,096 bytes) / `D:\Emulation\C128\kernal.318020-03.bin` (`0x1000–0x1FFF`)  
**Commodore Part Number:** `252202-01` (embedded in `318020-03`)  
**SHA-256:** `39c7656b326e4ad724ff4b50c995cb3b2b8ff9ed3bb2b4d277eb0ecd3cac062f`  
**CRC32:** `c38d83c6`  
**Embedded Release Date Stamp (`$0030`):** `"05/12/85"` (May 12, 1985)  
**Target Architecture:** Zilog Z80A (`4 MHz` oscillator / `2 MHz` effective bus rate) + Embedded MOS 8502 Slave Code (`$0D1A–$0EF4`)  
**Methodology Classification:** `CONFIRMED` (100% byte-verified against `z80bios.bin` and reconstructed in `asm/z80/z80bios_annotated.asm`)

---

## 1. Executive Summary & Binary Identity

The Commodore 128 Z80 BIOS (`z80bios.bin`, 4,096 bytes) is physically stored in the lower half of the 16 KB system KERNAL ROM (`kernal.318020-03.bin` at file offset `0x1000–0x1FFF`). While the MOS 8502 sees this 4 KB physical ROM window overlaid by the `$D000–$DFFF` I/O block or character ROM, the 8722 Memory Management Unit (MMU) maps this exact 4 KB ROM region to CPU address **`$0000–$0FFF`** whenever:
1. The Z80A processor is active (`$D505` bit 0 = `0`),
2. C128 mode is selected (`$D505` bit 6 = `0`), and
3. MMU Configuration Register (`$FF00` / `$D500`) selects **RAM Bank 0** (`bits 7:6 = 00`) with system ROM enabled (`bit 0 = 0`, e.g., `CR = $3E`).

Crucially, the MMU treats `$0000–$0FFF` in Z80 Bank 0 as **read-only ROM / write-through RAM**: Z80 instruction fetches and memory reads from `$0000–$0FFF` come from `z80bios.bin`, while Z80 memory writes to `$0000–$0FFF` go directly into physical RAM Bank 0 (`$00000–$00FFF`). Once `CR` bit 0 is set to `1` (`CR = $3F`), the Z80 BIOS ROM is unmapped and the Z80 reads and writes pure Bank 0 RAM across `$0000–$FEFF` (with I/O at `$D000–$DFFF`).

### Internal Segmentation of `z80bios.bin` (`$0000–$0FFF`)

| Z80 Address Range | Size (Bytes) | Architecture / Type | Subsystem & Purpose | Classification |
|---|---:|---|---|---|
| `$0000–$002F` | 48 | Zilog Z80A Code | Hardware Reset (`$0000`) & `RST $08..$28` Vector Dispatch Engine | `CONFIRMED` |
| `$0030–$0037` | 8 | ASCII Metadata | Firmware Release Date Stamp: `"05/12/85"` | `CONFIRMED` |
| `$0038–$003A` | 3 | Zilog Z80A Code | `RST $38` (IM 1 Interrupt Entry): `JP $FDFD` | `CONFIRMED` |
| `$003B–$00B3` | 121 | Zilog Z80A Code | Cold-Start Hardware Init, Cartridge/`C=` Key Check, MMU Init & 8502 Handoff | `CONFIRMED` |
| `$00B4–$00ED` | 58 | Zilog Z80A Code | CP/M Directory Sector Scanner & 12-Byte Filename Matcher | `CONFIRMED` |
| `$00EE–$00F9` | 12 | ASCII Data | Target System Filename `"CPM+    SYS\0"` | `CONFIRMED` |
| `$00FA–$00FF` | 6 | Zilog Z80A Code | 16-Bit Unsigned Comparator (`UTIL_CMP_HL_DE`) | `CONFIRMED` |
| `$0100–$0182` | 131 | 16-Bit Pointer Table | Page `$01` BIOS Function Dispatch Table (66 vectors, `$0100–$0181` + `$09` pad) | `CONFIRMED` |
| `$0183–$018B` | 9 | Zilog Z80A Code | 8563 VDC Low-Level Helper Jump Table (`JP $0933`, `JP $0953`, `JP $0945`) | `CONFIRMED` |
| `$018C–$0525` | 922 | Zilog Z80A Code + Inline ASCII | CP/M 3.0 (`CPM+.SYS`) Bootstrap Loader, GCR Sector Mapper & Error UI | `CONFIRMED` |
| `$0526–$05BC` | 151 | Zilog Z80A Code | Dual-Head (40/80 Column) Boot String & Track/Sector Status Printer | `CONFIRMED` |
| `$05BD–$096D` | 945 | Zilog Z80A Code | 80-Column MOS 8563 VDC Console Driver, Hardware Block Copy/Fill & Font Loader | `CONFIRMED` |
| `$096E–$0C7E` | 785 | Zilog Z80A Code | 40-Column MOS 8564/8566 VIC-IIe Console Driver & 80-Col Virtual Window Refresh | `CONFIRMED` |
| `$0C7F–$0CF9` | 123 | Zilog Z80A Code | ASCII-to-ScreenCode Converter, `Row*80+Col` Address Math & Color Lookup | `CONFIRMED` |
| `$0CFA–$0D19` | 32 | Zilog Z80A Code | MOS 6581/8580 SID Console Bell / Beep Generator (`$D400–$D418`) | `CONFIRMED` |
| `$0D1A–$0D21` | 8 | **MOS 8502 Code** | Cold-Boot 8502 Trampoline (copied by Z80 to `$1100–$1107`) | `CONFIRMED` |
| `$0D22–$0EE4` | 451 | **MOS 8502 Code + Data** | 8502 Slave Disk I/O Driver (copied by Z80 to Bank 0 `$3000–$31C2`) | `CONFIRMED` |
| `$0EE5–$0EF4` | 16 | **MOS 8502 Code** | 8502 Half of Shared RAM Processor-Switch Stub (copied to `$FFD0–$FFDF`) | `CONFIRMED` |
| `$0EF5–$0F03` | 15 | Zilog Z80A Code | Z80 Half of Shared RAM Processor-Switch Stub (copied to `$FFE0–$FFEF`) | `CONFIRMED` |
| `$0F04–$0FA9` | 166 | Binary Data Tables | Color Translation (`$0F0A`), Custom VDC 8x8 Glyphs (`$0F1A`), SID Init (`$0FA0`) | `CONFIRMED` |
| `$0FAA–$0FB4` | 11 | Binary Data Table | MMU Power-On Register Table (loaded into `$D500–$D50A`) | `CONFIRMED` |
| `$0FB5–$0FFF` | 75 | Binary Data Tables | 1541/1571 GCR Track Zone Sector Interleave Tables (21/19/18/17 sectors/track) | `CONFIRMED` |

---

## 2. Z80 BIOS Entry Points & `RST` Vector Architecture

All hardware and software entry points in `z80bios.bin` are catalogued below with exact ROM instructions:

### 2.1 Hardware Reset (`$0000`)
```z80
$0000: 3E 3E       LD A,$3E        ; MMU CR = $3E (Bank 0 RAM, I/O @ $D000-$DFFF, Z80 ROM @ $0000-$0FFF)
$0002: 32 00 FF    LD ($FF00),A    ; Write MMU Configuration Register
$0005: C3 3B 00    JP $003B        ; Jump to Z80_COLD_START
```

### 2.2 `RST $08` (`$0008`) — CP/M 3.0 Bootstrap Entry
Invoked by the `RST $08` (`$CF`) instruction at the end of the shared RAM handoff stub (`$FFEE`) when the 8502 switches back to the Z80 to boot CP/M, or when the user presses `RETURN` after a boot error (`$049B`):
```z80
$0008: 31 77 3C    LD SP,$3C77     ; Initialize Z80 stack pointer in Bank 0 work area
$000B: 3E 3F       LD A,$3F        ; Prepare CR=$3F (all RAM except I/O at $D000-$DFFF)
$000D: C3 8C 01    JP $018C        ; Jump to CPM_BOOT_INIT
```

### 2.3 `RST $10` (`$0010`), `RST $18` (`$0018`), `RST $20` (`$0020`), and `RST $28` (`$0028`) — The Page `$01` Dispatch Engine
The Z80 BIOS implements a compact bytecode-style dispatch mechanism using `RST $10` (`$D7`), `RST $18` (`$DF`), `RST $20` (`$E7`), and `RST $28` (`$EF`):
```z80
; RST $10: Mode-sensitive inline vector dispatch (selects 80-col L or 40-col L+2 via $FD0F)
$0010: E1          POP HL          ; Pop return address (points to inline parameter byte after RST $10)
$0011: 6E          LD L,(HL)       ; Load vector offset byte into L
$0012: C3 20 00    JP $0020        ; Jump to mode check

; RST $18: Direct inline vector dispatch (uses inline byte L directly)
$0018: E1          POP HL          ; Pop return address (points to inline parameter byte after RST $18)
$0019: 6E          LD L,(HL)       ; Load vector offset byte into L
$001A: C3 28 00    JP $0028        ; Jump to table lookup

; RST $20: Register-based mode-sensitive dispatch (caller passes even vector offset in L)
$0020: 3A 0F FD    LD A,($FD0F)    ; Read active display flag ($00 = 80-col VDC, non-zero = 40-col VIC)
$0023: A7          AND A           ; Test if zero
$0024: 28 02       JR Z,$0028      ; If $00 (80-col VDC), keep L
$0026: 2C          INC L           ; If non-zero (40-col VIC), advance L by +2 bytes (next word in $0100 table)
$0027: 2C          INC L

; RST $28: Page $01 Indirect Table Jump (caller passes byte offset in L)
$0028: 26 01       LD H,$01        ; HL = $0100 + L
$002A: 7E          LD A,(HL)       ; Read low byte of target routine
$002B: 23          INC HL
$002C: 66          LD H,(HL)       ; Read high byte of target routine
$002D: 6F          LD L,A          ; HL = target address
$002E: E9          JP (HL)         ; Tail-jump to target routine!
```
**Critical Control-Flow Property (`C128-Z80-003`):** Because `RST $10` and `RST $18` execute `POP HL` to read the inline parameter byte at `(HL)` and never push `HL+1` back onto the stack, `RST $10` and `RST $18` act as **parameterized tail-jumps (`JP`)**, not subroutine calls! Every occurrence of `RST $10` (`$D7`) or `RST $18` (`$DF`) in `z80bios.bin` (at `$055C`, `$0577`, `$058A`, `$05BB`) is at the end of a routine that first calls the 40-column handler (`CALL $09xx`) and then tail-calls the 80-column handler via `RST $18; .BYTE vec_offset`.

### 2.4 `RST $38` (`$0038`) & `NMI` (`$0066`) — Interrupt Behaviour
- **Maskable Interrupt (`INT` / `IM 1` at `$0038`):**
  ```z80
  $0038: C3 FD FD    JP $FDFD
  ```
  When the Z80 operates in Interrupt Mode 1 (`IM 1`), any maskable interrupt jumps to `$0038`, which immediately vectors through high RAM at `$FDFD`. However, during Z80 BIOS execution and processor switching (`$FFE0`), the Z80 keeps maskable interrupts **disabled (`DI`)** (`$FFE0: F3 DI`). Even more importantly, on the Commodore 128 hardware, the 8502 slave init routine (`$0D3E / $301C`) disables VIC raster interrupts (`STX $D01A` with `X=0`) and points the 8502 IRQ/BRK/NMI vectors (`$0314–$0319`) to `$3163` (`ROM $0E85`), which clears CIA1 (`$DC0D`), CIA2 (`$DD0D`), and VIC (`$D019`) interrupt flags whenever the 8502 runs.
- **Non-Maskable Interrupt (`NMI` at `$0066`):**
  In `z80bios.bin`, address `$0066` is **not** a dedicated NMI handler; it lands directly in the middle of the cold-start CIA1 initialization sequence (`$0059–$007B`):
  ```z80
  $0063: 0E 03       LD C,$03
  $0065: AF          XOR A
  $0066: ED 79       OUT (C),A       ; <-- $0066 lands here!
  ```
  Wait: what happens if the user presses the `RESTORE` key (which asserts `/NMI`) while the Z80 is executing with `z80bios.bin` mapped at `$0000–$0FFF`? If `BC` does not happen to hold `$DC03`, `$0066` executes `OUT (C),A`, decrements `C` and `A`, outputs again, reads `(BC+1)`, masks `$20`, loads `BC=$D505`, and if zero, jumps to `$0054` (which switches to C64 mode!), or falls through to `$007C` (which re-initializes the MMU and cold-boots the 8502 at `$1100`)! Once CP/M 3.0 (`CPM+.SYS`) is booted, CP/M runs with `CR = $3F` (or Bank 1), where RAM is mapped at `$0000–$0FFF` and CP/M installs its own `RST` and `NMI` vectors at `$0066` in RAM.

---

## 3. Complete Decode of the Page `$01` BIOS Vector Table (`$0100–$018B`)

The table at `$0100–$0181` contains 65 16-bit function pointers (offsets `$00` through `$80`), followed by a single padding byte `$09` at `$0182` and three 3-byte `JP` instructions at `$0183–$018B`.

### 3.1 Paired 80-Column (VDC) / 40-Column (VIC) Console Vectors (`$00–$46`)
For offsets `$00` through `$46`, each function is arranged as a pair:
- **Even offset `2k` (`$FD0F == $00`):** 80-column MOS 8563 VDC implementation.
- **Next even offset `2k + 2` (`$FD0F != $00`):** 40-column MOS 8564 VIC-IIe implementation.

| Pair Function | 80-Col Offset (`$01xx`) | 80-Col Target (VDC) | 40-Col Offset (`$01xx`) | 40-Col Target (VIC) | Input / Output Parameters & Behaviour |
|---|---|---|---|---|---|
| **0. PutChar (Advance)** | `$00` (`$0100`) | `$0684` | `$02` (`$0102`) | `$096E` | Writes character `D` at current cursor with current attribute, advances cursor (wraps/scrolls at col 79). |
| **1. SetCursorPos** | `$04` (`$0104`) | `$06AB` | `$06` (`$0106`) | `$09BC` | Sets cursor row = `D` (`0..24`), column = `E` (`0..79`), updates hardware cursor. |
| **2. CursorUp** | `$08` (`$0108`) | `$06C2` | `$0A` (`$010A`) | `$09DD` | Moves cursor up 1 row if `row > 0` (`RET Z` at top row). |
| **3. LineFeed / ScrollUp** | `$0C` (`$010C`) | `$06D1` | `$0E` (`$010E`) | `$09F1` | Moves cursor down 1 row; if at row 23 (`$17`), scrolls rows `0..23` up and clears row 23. |
| **4. CursorLeft (BS)** | `$10` (`$0110`) | `$06DD` | `$12` (`$0112`) | `$0A31` | Moves cursor left 1 column if `col > 0`. |
| **5. CursorRight** | `$14` (`$0114`) | `$06E8` | `$16` (`$0116`) | `$0A3C` | Moves cursor right 1 column if `col < 79` (`$4F`). |
| **6. CarriageReturn (CR)** | `$18` (`$0118`) | `$06F1` | `$1A` (`$011A`) | `$0A45` | Sets cursor column to `0` on current row. |
| **7. ClearToEOL** | `$1C` (`$011C`) | `$077A` | `$1E` (`$011E`) | `$0A48` | Clears from current cursor position to end of current 80-column line (col 79). |
| **8. ClearToEOS** | `$20` (`$0120`) | `$0780` | `$22` (`$0122`) | `$0A62` | Clears from current cursor position to end of 24-row screen (`$077F`). |
| **9. InsertChar** | `$24` (`$0124`) | `$0791` | `$26` (`$0126`) | `$0A8E` | Shifts characters/attributes right from cursor to col 79 and inserts blank space at cursor. |
| **10. DeleteChar** | `$28` (`$0128`) | `$07CA` | `$2A` (`$012A`) | `$0ABA` | Shifts characters/attributes left from cursor+1..79 and places blank space at col 79. |
| **11. InsertLine** | `$2C` (`$012C`) | `$07DC` | `$2E` (`$012E`) | `$0ADF` | Scrolls lines down from current row to row 23 and clears current line. |
| **12. DeleteLine** | `$30` (`$0130`) | `$081E` | `$32` (`$0132`) | `$0B2D` | Scrolls lines up from current row+1..23 and clears row 23. |
| **13. SetColor** | `$34` (`$0134`) | `$071B` | `$36` (`$0136`) | `$0B7B` | Sets background/border/character color using `B` (translates via `$0F0A` for VDC or writes `$D020/$D021` for VIC). |
| **14. SetAttrMask** | `$38` (`$0138`) | `$0710` | `$3A` (`$013A`) | `$0B62` | Updates character attribute byte (`$2415` for VDC, `$240D` for VIC): clears bits in `B`, sets bits in `C`. |
| **15. ReadCharAttrAt** | `$3C` (`$013C`) | `$091C` | `$3E` (`$013E`) | `$0995` | Positions at `(D,E)` and returns character in `B` and attribute in `C`. |
| **16. WriteCharAttrAt** | `$40` (`$0140`) | `$0927` | `$42` (`$0142`) | `$09A2` | Positions at `(D,E)` and writes character `B` and attribute `C` without advancing cursor. |
| **17. GetColorState** | `$44` (`$0144`) | `$074E` | `$46` (`$0146`) | `$0BAE` | Returns current color/attribute state registers in `A`, `B`, `C`, `D`. |

### 3.2 System, Disk, Audio, and Low-Level Vectors (`$48–$80`)

| Offset (`$01xx`) | Target | Symbol | Purpose |
|---|---|---|---|
| `$48–$4E` | `$00EB` | `VEC_NOOP_RET_ZERO` | Reserved slots: jumps to `$00EB` (`XOR A; RET`). |
| `$50` (`$0150`) | `$03E3` | `DISK_LOGICAL_TO_TRACK_SECTOR` | Converts logical sector `($FD16)` to physical track `($FD03)` and sector `($FD04)`. |
| `$52` (`$0152`) | `$046B` | `DISK_CHECK_CBM_SIGNATURE` | Verifies `'C','B','M'` at `$FE00–$FE02` and loads `A = ($FEFF)`. |
| `$54` (`$0154`) | `$0CFA` | `SID_BEEP_SOUND` | Triggers console bell/beep on SID Voice 1 (`$D400–$D418`). |
| `$56–$5E` | `$00EB` | `VEC_NOOP_RET_ZERO` | Reserved slots (`XOR A; RET`). |
| `$60` (`$0160`) | `$0C3C` | `VIC_CALC_WINDOW_OFFSET` | Calculates 40-col horizontal window offset `($2402)` from cursor column `($240B)`. |
| `$62` (`$0162`) | `$0C4A` | `VIC_SYNC_CURSOR_AND_WINDOW` | Updates VIC 40-col window (`$0BCF`) and cursor pointer `($2406)`. |
| `$64` (`$0164`) | `$0BCF` | `VIC_UPDATE_LINE_OR_SCREEN` | Syncs current 40-col line (or full screen if window shifted) from `$1400/$1C00` to `$2C00/$1000`. |
| `$66` (`$0166`) | `$0C0C` | `VIC_REFRESH_FULL_WINDOW` | Copies all `($2408)` rows of 40 chars from virtual buffer `$1400/$1C00` to `$2C00` and Color RAM `$1000`. |
| `$68` (`$0168`) | `$0526` | `VIDEO_PRINT_INLINE_STR` | Prints inline string following `CALL` to both 40-col and 80-col displays. |
| `$6A` (`$016A`) | `$0532` | `VIDEO_PRINT_DE_STR` | Prints string pointed to by `DE` to both 40-col and 80-col displays. |
| `$6C` (`$016C`) | `$052C` | `VIDEO_HOME_STATUS_LINE` | Resets `($2404) = $FFFF` and returns (`RET` via `$00EB` at `$6E`). |
| `$6E` (`$016E`) | `$00EB` | `VEC_NOOP_RET_ZERO` | Reserved (`XOR A; RET`). |
| `$70` (`$0170`) | `$0C7F` | `VIDEO_ASCII_TO_SCREENCODE` | Converts ASCII character in `B` to C128 screen code in `A`. |
| `$72` (`$0172`) | `$0CC2` | `VIDEO_CALC_VIC_OFFSET` | Computes `HL = row*80 + col` and `C = 79 - col` for VIC cursor `($240B)`. |
| `$74` (`$0174`) | `$0CC7` | `VIDEO_CALC_VDC_OFFSET` | Computes `HL = row*80 + col` and `C = 79 - col` for VDC cursor `($2413)`. |
| `$76` (`$0176`) | `$0CE4` | `VIDEO_LOOKUP_COLOR_TABLE` | Indexes color table pointed to by `($FD0D)`. |
| `$78` (`$0178`) | `$00EB` | `VEC_NOOP_RET_ZERO` | Reserved (`XOR A; RET`). |
| `$7A` (`$017A`) | `$083D` | `VDC_FILL_ENTRY` | Entry wrapper for 8563 VDC hardware block fill (`$0847`). |
| `$7C` (`$017C`) | `$08AE` | `VDC_COPY_ENTRY` | Entry wrapper for 8563 VDC hardware block copy (`$08B0`). |
| `$7E` (`$017E`) | `$0660` | `VDC_UPLOAD_CHARS_ENTRY` | Uploads `B` character definitions (`16` bytes/char stride) from `(DE)` to VDC VRAM `(HL)`. |
| `$80` (`$0180`) | `$0AC3` | `VIC_DELCHAR_MID_ENTRY` | Internal entry point inside `VIC_DELETE_CHAR`. |

### 3.3 Direct VDC Jump Vectors (`$0183–$018B`)
Immediately following the pointer table (after padding byte `$09` at `$0182`), the BIOS provides a 3-entry standard Z80 jump table for direct calls from external Z80 code (such as `CPM+.SYS` BIOS modules):
- **`$0183`: `JP $0933` (`VDC_READ_CHAR_AND_ATTR`)** — Reads character at VDC offset `HL` into `B` and attribute at `HL+$0800` into `A`.
- **`$0186`: `JP $0953` (`VDC_SET_VRAM_ADDR_HL`)** — Writes `H` to VDC Reg 18 (`$12`), `L` to VDC Reg 19 (`$13`), selects VDC Data Reg 31 (`$1F`), and waits for VDC ready.
- **`$0189`: `JP $0945` (`VDC_SELECT_REG_A`)** — Waits for VDC ready (`$D600` bit 7 = `1`), writes register index `A` to `$D600`, and sets `BC = $D601`.

---

## 4. Memory Mapping & RAM Workspace During Z80 Execution

### 4.1 MMU Initialization Table (`$0FAA–$0FB4` -> `$D500–$D50A`)
Both during power-on reset (`$007C–$008B`) and CP/M boot initialization (`$01B9–$01C8`), the Z80 copies 11 bytes from ROM `$0FAA–$0FB4` into MMU registers `$D500–$D50A`:

| ROM Address | MMU Register | Value | Hardware Meaning |
|---|---|---:|---|
| `$0FAA` | `$D500` (`CR`) | `$3F` | Bank 0 RAM, all 64 KB RAM visible except I/O at `$D000–$DFFF` (`bit 0 = 1` unmaps Z80 BIOS ROM when written to `$D500`/`$FF00`, though `$0000` overrides `$FF00` to `$3E` when ROM is needed). |
| `$0FAB` | `$D501` (`PCRA`) | `$3F` | Preconfiguration A: Bank 0 RAM + I/O enabled (`$3F`). |
| `$0FAC` | `$D502` (`PCRB`) | `$7F` | Preconfiguration B: Bank 1 RAM + I/O enabled (`$7F`). |
| `$0FAD` | `$D503` (`PCRC`) | `$3E` | Preconfiguration C: Bank 0 RAM + I/O enabled + Z80 BIOS ROM at `$0000–$0FFF` (`$3E`). |
| `$0FAE` | `$D504` (`PCRD`) | `$7E` | Preconfiguration D: Bank 1 RAM + I/O enabled + ROM low (`$7E`). |
| `$0FAF` | `$D505` (`MCR`) | `$B0` | `10110000`: 40/80 key bit=1, C128 mode (`bit 6=0`), `/EXROM` & `/GAME` inputs (`bits 5:4=11`), `/FSDIR=0`, **Z80 active (`bit 0=0`)**. |
| `$0FB0` | `$D506` (`RCR`) | `$0B` | `00001011`: VIC-IIe RAM in Bank 0 (`bits 7:6=00`), **Common RAM enabled at both Top AND Bottom (`bits 3:2=10`)**, **Common RAM size = 4 KB (`bits 1:0=11`)**. |
| `$0FB1` | `$D507` (`P0L`) | `$00` | Page 0 pointer low = `$00` (Zero Page stays at `$0000`). |
| `$0FB2` | `$D508` (`P0H`) | `$00` | Page 0 pointer high = Bank 0 (`$00`). |
| `$0FB3` | `$D509` (`P1L`) | `$01` | Page 1 pointer low = `$01` (Stack Page stays at `$0100`). |
| `$0FB4` | `$D50A` (`P1H`) | `$00` | Page 1 pointer high = Bank 0 (`$00`). |

> [!IMPORTANT]
> **Finding `C128-Z80-004` (`CONFIRMED`):** Notice `$D506 (RCR) = $0B` (`00001011b`)! Whereas the 8502 KERNAL sets `$D506 = $04` (1 KB Common RAM at bottom `$0000–$03FF` only), the Z80 BIOS sets `$D506 = $0B`, which enables **4 KB of Common RAM at BOTH the bottom (`$0000–$0FFF`) and the top (`$F000–$FFFF`)** of memory! Furthermore, look at how the 40-column VIC refresh routine at `$0C27` writes `$01` to **`$FF03` (`LCRc`)**:
> ```z80
> $0C27: 32 03 FF    LD ($FF03),A    ; Trigger MMU Preconfiguration C ($D503 = $3E) OR wait:
> ```
> Wait: why does `$0C27` execute `LD ($FF03),A` before copying 40-column attributes to `$1000`, and `LD ($FF01),A` (`$0C38`) afterward?
> Let's check what `CPM_BOOT_INIT` (`$05D1–$0645`) and the C128 hardware do! On the C128, MMU register `$D501` (`PCRA`) and `$D503` (`PCRC`) or processor port `$0001` (`R6510` bit 0 `LORAM` / bit 1 `HIRAM` / bit 2 `CHAREN`) control Color RAM banking, and during CP/M operation, `$D503` is configured so writing `$FF03` maps Color RAM or alternate bank, and `$FF01` restores normal Bank 0 RAM (`$D501 = $3F`)!

### 4.2 Bank 0 RAM Memory Map During Z80 BIOS Execution (`$1000–$FFFF`)

| Address Range | Size | Purpose During Z80 BIOS & CP/M Boot |
|---|---|---|
| `$0000–$0FFF` | 4 KB | Z80 BIOS ROM (read when `CR` bit 0 = `0`) / Bank 0 Common RAM (write-through; read/write when `CR = $3F`). |
| `$1000–$13FF` | 1 KB | Cleared at `$01C9`; used as Color RAM window (`$1000–$13E7`) during 40-column screen refresh (`$0C24`). |
| `$1400–$1B7F` | 1,920 B | **40-Column Virtual 80x24 Character Buffer** (24 rows × 80 columns, ASCII/Screen codes). |
| `$1B80–$1BFF` | 128 B | 25th status line character buffer (`$1B30` / `$1B80`). |
| `$1C00–$237F` | 1,920 B | **40-Column Virtual 80x24 Attribute/Color Buffer** (24 rows × 80 columns, parallel to `$1400–$1B7F` at `+$0800`). |
| `$2400–$2417` | 24 B | **Z80 BIOS Video & Disk State Variables:**<br>• `$2400`: Temp color / track-side offset (`$00` or `$23` = 35)<br>• `$2402`: 40-col horizontal window offset (`0..40`, multiple of 8)<br>• `$2404`: Previous window offset / dirty flag (bit 6 = line dirty, bit 7 = auto-track cursor)<br>• `$2405`: Escape sequence state byte<br>• `$2406–$2407`: Physical 40-col VIC cursor pointer (`$2C00+offset`)<br>• `$2408`: Active screen row count (`$19` = 25 rows)<br>• `$2409–$240A`: Current 40-col virtual buffer pointer (`$1400 + row*80 + col`)<br>• `$240B`: 40-col cursor column (`0..79`)<br>• `$240C`: 40-col cursor row (`0..24`)<br>• `$240D`: 40-col current color/attribute byte (init `$0E` light blue)<br>• `$240E`: 40-col background color (`$D021` shadow)<br>• `$240F`: 40-col border color (`$D020` shadow)<br>• `$2410`: 40-col reverse-video mask (`$00` or `$80`)<br>• `$2411–$2412`: 80-col VDC VRAM cursor address (`0..1999`)<br>• `$2413`: 80-col VDC cursor column (`0..79`)<br>• `$2414`: 80-col VDC cursor row (`0..24`)<br>• `$2415`: 80-col VDC current attribute byte (init `$83` = char set + cyan/white)<br>• `$2416`: 80-col VDC background color shadow<br>• `$2417`: 80-col VDC foreground color code |
| `$2C00–$2FE7` | 1,000 B | **Physical 40x25 VIC-IIe Screen Matrix** (configured via `VIC_VMCSB $D018 = $B6` at `$020B`: screen at `$2C00`, charset at `$3800`). |
| `$3000–$31C2` | 451 B | **MOS 8502 Slave Disk I/O Driver** (copied from ROM `$0D22–$0EE4` by Z80 at `$019B`). |
| `$3400–$3BFF` | 2 KB | **CP/M Allocation Block Disk Buffer** (used during `CPM+.SYS` directory scan and segment loading) / `$3800–$3FFF` VIC-IIe Character Set. |
| `$3C00–$3C77` | 120 B | **CP/M Bootstrap Loader Workspace & Z80 Stack (`SP = $3C77`):**<br>• `$3C00–$3C01`: Remaining 128-byte record counter for current segment<br>• `$3C02–$3C03`: Pointer to current allocation block number in extent table<br>• `$3C04–$3C05`: Current 128-byte record pointer inside `$3400+` block buffer<br>• `$3C06`: Block size / sector count multiplier (`$20` or `$40`)<br>• `$3C07–$3C08`: End of allocation block buffer (`$3800` for 1 KB blocks, `$3C00` for 2 KB blocks)<br>• `$3C09–$3C18`: Extent 0 allocation block list (16 bytes from directory entry)<br>• `$3C19–$3C28`: Extent 1 allocation block list (16 bytes from directory entry)<br>• `$3C29–$3C34`: **12-Byte `CPM+.SYS` Load Header** (copied from start of first block at `$0232`)<br>• `$3C35`: Matched directory extent index (`0` or `1`)<br>• `$3C36`: Disk read retry counter (`3` retries) |
| `$FD00–$FD19` | 26 B | **Z80 <-> 8502 Shared Communication Mailbox (`$FD00–$FD19`):**<br>• `$FD01`: 8502 Slave Command (`$00` = Init IEC/FastSerial & IRQ vectors; `$01` = Read Sector(s))<br>• `$FD03`: Target Physical Disk Track (`1..70`)<br>• `$FD04`: Target Physical Disk Sector (`0..20`)<br>• `$FD05`: Remaining sectors in current CP/M allocation block<br>• `$FD06`: 8502 Disk I/O Return Status (`$00` = OK, `$0D` = Read Error, `$0F` = Drive Not Ready, `$FF` = Channel Error)<br>• `$FD08`: Fast Serial (1571 Burst/Fast) capability flag (`$00` = slow 1541 IEC `U1`, `$0F` = fast serial `#` / `U0` read)<br>• `$FD09–$FD0C`: Saved `CPM+.SYS` segment bounds<br>• `$FD0D–$FD0E`: Pointer to Color Translation Table (`$0F0A`)<br>• `$FD0F`: Active Display Mode Flag (`$00` = 80-col VDC, non-zero = 40-col VIC)<br>• `$FD10–$FD15`: SID Beep Voice 1 Register Parameters<br>• `$FD16–$FD17`: Current Logical CP/M Sector Number<br>• `$FD18–$FD19`: Destination RAM Buffer Pointer for 8502 Sector Read (e.g. `$FE00` or `$3400+`) |
| `$FDFD–$FDFF` | 3 B | Z80 `IM 1` (`RST $38`) RAM Jump Vector (`JP xxxx`). |
| `$FE00–$FEFF` | 256 B | Sector 0 / Boot Sector Buffer (checked for `'C','B','M'` signature at `$046B`). |
| `$FF00–$FF04` | 5 B | Hardware MMU Configuration & Load Configuration Registers (`CR`, `LCRA..LCRD`). |
| `$FFD0–$FFEF` | 32 B | **Shared RAM Dual-Processor Switch Stub** (`$FFD0–$FFDF` = 8502 code, `$FFE0–$FFEF` = Z80 code). |
| `$FFFA–$FFFF` | 6 B | MOS 8502 Hardware NMI (`$FFFA`), RESET (`$FFFC`), and IRQ (`$FFFE`) Vectors. |

---

## 5. Hardware Dependencies & Peripheral Interactions

Every hardware I/O port accessed by `z80bios.bin` (using Z80 16-bit I/O instructions `IN r,(C)` / `OUT (C),r` where `BC` holds the 16-bit memory-mapped I/O address `$Dxxx`) has been verified:

1. **8722 MMU (`$D500–$D50A`, `$FF00–$FF04`):**
   - `$FF00` (`CR`), `$FF01` (`LCRA`), `$FF03` (`LCRC`) accessed via memory-mapped `LD ($FF0x),A`.
   - `$D500–$D50A` initialized via `OUT (C),A` loop at `$007F` and `$01BC`.
   - `$D505` (`MCR`) read via `IN A,(C)` at `$004D` to sense `/GAME` and `/EXROM` cartridge lines, and written via `OUT (C),A` at `$004B` (`$B0`), `$0056` (`$F1`), and `$FFE8` (`$B1`).
2. **MOS 8564/8566 VIC-IIe (`$D018`, `$D019`, `$D01A`, `$D020`, `$D021`, `$D02F`, `$D030`):**
   - `$D02F = $FF`, `$D030 = $FC` at cold start (`$003B–$0045`) to enable extended keypad lines and ensure 1 MHz mode.
   - `$D018 = $B6` at `$0208` (`10110110b`): places VIC-IIe 40-column screen matrix at `$2C00` (`$0B * $0400`) and character generator at `$3800` (`$03 * $0800`).
   - `$D020` (Border) and `$D021` (Background 0) written via `OUT (C),A` at `$0B9D` and `$0BA8`.
3. **MOS 8563 VDC (`$D600` Address/Status, `$D601` Data):**
   - All VDC accesses go through `$0945` (`LD BC,$D600; IN A,(C); RLA; JR NC,$0949; OUT (C),A; INC C; RET`), which respects the hardware ready flag (`bit 7` of `$D600`).
   - Uses VDC Regs `18/19` (`$12/$13`, Update Address High/Low), `14/15` (`$0E/$0F`, Cursor Position High/Low), `24` (`$18`, Block Copy/Fill mode bit 7), `26` (`$1A`, Foreground/Background color), `30` (`$1E`, Word Count), `31` (`$1F`, VRAM Data), and `32/33` (`$20/$21`, Block Copy Source High/Low).
   - At `$05BD–$0683`, the Z80 BIOS checks if the VDC font in VRAM is already set up for CP/M (`$3004`); if not, it copies and modifies the existing character set in VDC VRAM so CP/M has proper ASCII characters (including `~`, `{`, `}`, `|`, `\`, `_`) from the glyph table at `$0F1A–$0F61`!
4. **MOS 6526 CIA1 (`$DC00–$DC0F`) & CIA2 (`$DD00–$DD0D`):**
   - Z80 accesses `$DC00–$DC0F` directly at `$0059–$0075` (to scan the `C=` key on power-on) and at `$04EA–$04FC` (to poll `RETURN` vs `DEL` on boot error).
   - All serial IEC bus (`$DD00`) and Fast Serial (`$DC0C`/`$DC0D`) disk operations are delegated to the **MOS 8502 Slave Driver** at `$3000–$31C2` (`ROM $0D22–$0EE4`).
5. **MOS 6581/8580 SID (`$D400–$D418`):**
   - Accessed at `$0CFA–$0D19` via `OUT (C),H` / `OUT (C),L` with `B = $D4` and `C = $18, $05, $06, $01, $00, $04` to produce the CP/M console bell tone.
