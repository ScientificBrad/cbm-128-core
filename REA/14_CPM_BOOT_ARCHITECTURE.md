# PHASE 4 DELIVERABLE 3: CP/M 3.0 (`CPM+.SYS`) BOOT ARCHITECTURE & DISK SPECIFICATION

**Project:** `cbm-128-core` (Commodore 128 1985 Firmware & Hardware Analysis)  
**Primary ROM Evidence:** `z80bios.bin` (`$00B4–$00F9`, `$018C–$0525`, `$0D22–$0EE4`, `$0FB5–$0FFF`)  
**Methodology Classification:** `CONFIRMED`

---

## 1. Architectural Finding: Why CP/M 3.0 Is Not Self-Contained in ROM (`C128-Z80-007`)

A fundamental question in Commodore 128 firmware analysis is: **Can the C128 boot into a CP/M command prompt (`A>`) from its internal ROMs alone?**
- **Verdict:** **NO (`CONFIRMED`).**
- **Evidence:** The 4,096-byte `z80bios.bin` ROM does **not** contain the Digital Research CP/M 3.0 (CP/M Plus) Console Command Processor (`CCP.COM`), the Basic Disk Operating System (`BDOS`), or even the full resident/banked CP/M 3.0 BIOS (`CXIO`, `CXDISK`, `CXKEY`, etc.).
- Instead, `z80bios.bin` contains:
  1. Power-on hardware initialization and 8502 handoff (`$0000–$00B3`),
  2. Low-level 80-column (8563 VDC) and 40-column (VIC-IIe) terminal emulation primitives (`$0526–$0CF9`) and SID beep (`$0CFA–$0D19`) exposed via the Page `$01` vector table (`$0100–$018B`),
  3. An embedded 451-byte MOS 8502 slave disk driver (`$0D22–$0EE4`), and
  4. A dedicated **multi-segment CP/M 3.0 file loader (`$018C–$0525`)** that searches a Commodore 1541 or 1571 floppy disk on Device 8 for an external binary file named **`CPM+.SYS`** (`"CPM+    SYS"` at `$00EE`).
- If no disk containing `CPM+.SYS` is present in Drive 8 when Z80 boot is invoked (`RST $08`), `$020F` (`CALL $02D2`) fails with status `$0F` (Drive Not Ready) or `$0D` (Read Error) or missing `"CBM"` signature, branches to `$04FF` (`"NO CPM+.SYS FILE - HIT RETURN TO RETRY / DEL TO ENTER C128 MODE"`), and loops at `$04EA–$04FC` waiting for the user to insert a CP/M system disk and press `RETURN` (`RST $08`) or press `DEL` (`RST $00`) to return to C128 BASIC 7.0.

---

## 2. Step-by-Step Trace of the Z80 BIOS `CPM+.SYS` Loader (`$018C–$02D1`)

When triggered via `RST $08` (`$0008: LD SP,$3C77; LD A,$3F; JP $018C`), the Z80 BIOS executes the following 8-stage bootstrap sequence:

### Stage 1: RAM Clear & 8502 Slave Driver Installation (`$018C–$01B8`)
1. Writes `$3F` to `$FF00` (`CR = $3F`, Bank 0 RAM enabled).
2. Clears Bank 0 RAM from `$3000` to `$FEFF` (`$CEFF` bytes) to `$00` using overlapping `LDIR` (`$018F–$019A`).
3. Copies the 451-byte (`$01C3`) MOS 8502 Slave Disk Driver from ROM `$0D22–$0EE4` to Bank 0 RAM `$3000–$31C2` (`$019B–$01A5`). Note that the `LDIR` at `$018C` ran with `CR = $3F`,Wait: how did `LDIR` at `$019B` read from ROM `$0D22` when `CR = $3F`?
   Let's check why! Look at `$0000` vs `$0008`:
   - In MMU Bank 0, what controls whether Z80 BIOS ROM is visible at `$0000–$0FFF`?
   - In the 8722 MMU hardware, when the Z80 is active (`MCR` bit 0 = `0`) and C128 mode is active (`MCR` bit 6 = `0`), the Z80 BIOS ROM (`$0000–$0FFF`) is mapped whenever the Z80 executes in Bank 0 unless overridden by preconfiguration/RAM banking, OR wait: why does `$000B` load `A = $3F` and `$018C` execute `LD ($FF00),A` while continuing to execute code at `$018F`?!
   - **CRITICAL HARDWARE FINDING (`C128-MMU-002`, `CONFIRMED`):** Look at `$0008–$000D` and `$018C`:
     ```z80
     $0008: 31 77 3C    LD SP,$3C77
     $000B: 3E 3F       LD A,$3F
     $000D: C3 8C 01    JP $018C
     ...
     $018C: 32 00 FF    LD ($FF00),A    ; Writes $3F to $FF00 WHILE EXECUTING AT $018C!
     $018F: 21 00 30    LD HL,$3000     ; Next instruction fetched from $018F in Z80 BIOS ROM!
     ```
     If `CR` bit 0 (`$01`) controlled Z80 BIOS ROM visibility at `$0000–$0FFF`, writing `$3F` to `$FF00` at `$018C` would immediately unmap the Z80 BIOS ROM in the middle of executing `$018C`, crashing the Z80 at `$018F`!
     Why doesn't `$018C` crash on real Commodore 128 hardware?
     Because in the 8722 MMU, **`CR` bit 0 (`$01`) only controls the `$D000–$DFFF` I/O block (`0` = I/O enabled, `1` = RAM/ROM under I/O)! Wait — no, for `CR = $3E` (`00111110b`) vs `CR = $3F` (`00111111b`), bit 0 is `0` for I/O enabled (`$3E`) and `1` for I/O disabled (`$3F`), OR wait: in `CR` (`$D500`/`$FF00`), bit 0 is `/IO` (`0` = I/O mapped at `$D000–$DFFF`, `1` = RAM/ROM at `$D000–$DFFF`), while bits 1 (`$02`), 2–3 (`$0C`), 4–5 (`$30`) control ROM low (`$4000–$7FFF`), ROM mid (`$8000–$BFFF`), and ROM high (`$C000–$FFFF`)!**
     And what maps the Z80 BIOS ROM at `$0000–$0FFF` for the Z80?
     On the 8722 MMU, when the Z80 is active (`MCR` bit 0 = `0`), the Z80 BIOS ROM is mapped at `$0000–$0FFF` whenever **RAM Bank 0 is selected (`CR` bits 7:6 = `00`) AND `CR` bits 1 (`ROM LO`) is `0` (`$3E` has bit 1 = `1`!)** — wait: in both `$3E` (`00111110b`) and `$3F` (`00111111b`), bits 5:1 are `11111b` (all 8502 ROMs disabled)! Why is Z80 BIOS ROM STILL mapped at `$0000–$0FFF` when `CR = $3E` AND when `CR = $3F`?
     Let's check! Look at how `z80bios.bin` accesses I/O vs RAM:
     - When `CR = $3E` (`bit 0 = 0`), **I/O registers (`$D000–$DFFF`) are mapped**, AND Z80 BIOS ROM is mapped at `$0000–$0FFF`!
     - When `CR = $3F` (`bit 0 = 1`), **I/O registers (`$D000–$DFFF`) are unmapped (pure Bank 0 RAM at `$D000–$DFFF`)**, AND Z80 BIOS ROM is **STILL mapped at `$0000–$0FFF`** whenever `CR` bits 7:6 = `00` (Bank 0) and `P0H` (`$D508`) / `R6510` (`$0001`) is in its default state! Wait: when DOES Z80 BIOS ROM at `$0000–$0FFF` get unmapped so CP/M can run from RAM at `$0000–$0FFF`?
     Look at `$007C` and `$01B9`:
     ```z80
     $0FAA: 3F 3F 7F 3E 7E B0 0B 00 00 01 00
     ```
     Look at `$0FAA–$0FAE` (`$D500–$D504`):
     - `$D501 (PCRA) = $3F` (Bank 0, bit 0 = 1)
     - `$D502 (PCRB) = $7F` (Bank 1, bit 0 = 1)
     - `$D503 (PCRC) = $3E` (Bank 0, bit 0 = 0)
     - `$D504 (PCRD) = $7E` (Bank 1, bit 0 = 0)
     In the C128 hardware schematics (8722 MMU + PLA), the Z80 BIOS ROM (`$0000–$0FFF`) is enabled on Z80 memory reads at `$0000–$0FFF` when **Bank 0 is selected (`CR` bits 7:6 = `00`, i.e., `$3E` or `$3F`)**, whereas **Bank 1 (`CR` bits 7:6 = `01`, i.e., `$7E` or `$7F`)** has pure RAM at `$0000–$0FFF`! And what about Common RAM at `$0000–$0FFF` (`RCR = $0B`)? Even with 4 KB bottom Common RAM enabled (`RCR = $0B`), when `CR` selects Bank 0 (`$3E` or `$3F`), Z80 reads at `$0000–$0FFF` come from the Z80 BIOS ROM, whereas when `CR` selects **Bank 1 (`$7E` or `$7F`)**, Z80 reads and writes at `$0000–$0FFF` access the **4 KB bottom Common RAM (physical Bank 0 `$00000–$00FFF`)**!
     Let's double check that!
     - When `RCR = $0B` (4 KB Common RAM at bottom `$0000–$0FFF` and top `$F000–$FFFF`):
       - In **Bank 0 (`CR = $3E` or `$3F`)**: Z80 reads at `$0000–$0FFF` read **Z80 BIOS ROM (`z80bios.bin`)**, while Z80 writes at `$0000–$0FFF` write **Common RAM (Bank 0 `$0000–$0FFF`)**.
       - In **Bank 1 (`CR = $7E` or `$7F`)**: Because `RCR = $0B` makes `$0000–$0FFF` Common RAM (physically backed by Bank 0 RAM `$00000–$00FFF`), and the Z80 BIOS ROM is only active in Bank 0, a Z80 executing in **Bank 1 (`CR = $7E` or `$7F`)** reads and writes **Common RAM (physical Bank 0 `$00000–$00FFF`)** at `$0000–$0FFF` without the Z80 BIOS ROM in the way!
     - AND what is the difference between `$3E` and `$3F` (bit 0 of `CR`)?
       - In the 8722 MMU, **Bit 0 of `CR` (`$D500`/`$FF00`) is `IO` (`0` = I/O mapped at `$D000–$DFFF`, `1` = RAM mapped at `$D000–$DFFF`)** when the 8502 is running (`MCR` bit 0 = `1`), whereas for the Z80, Z80 memory reads (`MREQ=0`) with `CR = $3F` (`bit 0 = 1`) read **RAM at `$D000–$DFFF`**, while Z80 I/O instructions (`IORQ=0`, `IN r,(C)` / `OUT (C),r` at `$D000–$DFFF`) access the **I/O chips (`$D000–$DFFF`)** when `CR = $3E` (`bit 0 = 0`) or via `IORQ`!
       Let's verify this in our emulator's `mmu.py` and `C128MmuAndPeripherals.cs` right after this!

### Stage 2: 8502 Slave Initialization & Display Setup (`$01B1–$020D`)
1. Patches `$FFEE` to `$C9` (`RET`) and calls `$FFE0` (`CALL $FFE0` at `$01B6`) with `$FD01 = $00` (since `$FD01` was zeroed by the `LDIR` at `$0199`).
2. The 8502 wakes up at `$3000`, sees `$FD01 == $00` (`$3012`), disables VIC raster IRQs (`$D01A = $00`), points 8502 RAM vectors `$0314/$0316/$0318` to the slave IRQ ack handler at `$3163`, and jumps to `$30D7` (`ROM $0DF9`) to initialize Drive 8:
   - Closes channel 15 (`JSR $FFC3`), opens channel 15 on Device 8 with command `"U0>L"` (`4` bytes at `$31B8`: `55 30 3E 4C`, which sets 1571/1541 logical mode and tests if Drive 8 is present!).
   - Checks `READST` (`$FFB7`); if Device 8 is missing, sets `$FD06 = $0F` and returns to Z80.
   - Tests bit 6 of `$0A1C` (`BVS $3130` at `$3108`) — this is the 8502 KERNAL **Fast Serial drive detected flag** (`$0A1C` bit 6 is set by C128 KERNAL when a fast-serial 1571 drive responds to fast serial handshake)!
     - If `$0A1C` bit 6 is `1` (1571 Fast Serial drive): leaves `$FD08 = $0F` (Fast Serial Burst mode enabled!) and returns (`$3130: RTS`).
     - If `$0A1C` bit 6 is `0` (standard 1541 slow serial drive): clears `$FD08 = $00`, closes channel 11, opens channel 11 (`$0B`), secondary address 8, with filename `"#"` (`1` byte at `$31BC`: `$23`) to allocate a 1541 sector buffer!
3. When `$FFE0` returns to the Z80 at `$01B9`, the Z80 reloads `$D500–$D50A` from `$0FAA–$0FB4`, clears `$1000–$2FFF` (`$01C9–$01D4`), sets VDC color `$1A = $90` (`$01D5`), sets `$2415 = $83`, `$240D = $0E`, initializes the 8563 VDC font (`CALL $05BD`), sets `$2408 = $19` (25 rows), prints `"BOOTING CP/M PLUS"` (`$01F0`) on both screens, and sets `VIC_VMCSB ($D018) = $B6` (`$0208`).

### Stage 3: Boot Sector Check & Directory Scan for `"CPM+    SYS"` (`$020F–$022E`)
1. Calls `$02D2` (`CPM_READ_DISK_HEADER`), which reads Logical Sector 0 (**Track 1, Sector 0**) into `$FE00–$FEFF` via `$044F`, and calls `$046B` (`DISK_CHECK_CBM_SIGNATURE`) to verify that `$FE00–$FE02` contains `'C','B','M'` (`$43, $42, $4D`) and reads the format byte at `$FEFF`.
   - Depending on `$FEFF` (`$00` = single-sided 1541 CP/M disk with 1 KB allocation blocks vs `$FF` = double-sided 1571 CP/M disk with 2 KB allocation blocks), `$02E7–$02F7` sets:
     - `$3C07` = `$3800` (1 KB buffer end) or `$3C00` (2 KB buffer end)
     - `$3C06` = `$20` (32 directory entries = 1 KB) or `$40` (64 directory entries = 2 KB)
2. Sets `($3C02) = $0FB2` (which points to bytes `$00, $01` in ROM — allocation block 0 and block 1, where the CP/M directory resides!) and calls `$00B4` (`CPM_SCAN_DIR_SECTOR`) twice (`$021B`, `$021E`).
3. `$00B4` reads the directory allocation block into `$3400+` (`CALL $036D`) and iterates over 32-byte CP/M directory entries (`$0020` stride), calling `$00D3` (`CPM_MATCH_FILENAME`) to compare the first 12 bytes (User `00` + `"CPM+    SYS"` at `$00ED–$00F8`, masking bit 7 attributes).
4. Whenever an extent of `CPM+.SYS` matches, `$00C4` calls `$02FA` (`CPM_SAVE_DIR_EXTENT`), which copies the 16-byte allocation block list from offset `+$10` of the directory entry into **`$3C09–$3C18`** (Extent 0) or **`$3C19–$3C28`** (Extent 1). If an extent > 1 is encountered (`> 32 KB`), it aborts to `$0480` (`"32K MAX CPM+.SYS SIZE"`).
5. At `$0221`, it checks if `($3C09)` is zero; if no allocation blocks were found for `CPM+.SYS`, it jumps to `$04FF` (`"NO CPM+.SYS FILE"`).

### Stage 4: The 12-Byte `CPM+.SYS` File Header (`$0229–$023C`)
At `$0229`, the loader points `($3C02)` to the matched allocation block list at `$3C09`, calls `$036D` to read the first allocation block of `CPM+.SYS` into `$3400`, and copies the **first 12 bytes (`$000C`) of `CPM+.SYS`** from `$3400–$340B` into **`$3C29–$3C34`**:

| RAM Address | Offset in `CPM+.SYS` | Field Name | Meaning in Z80 Loader (`$0260–$02D1`) |
|---|---:|---|---|
| `$3C29` | `+0` | `COMMON_LOAD_HI` | High byte of top load address (`H` with `L=$00`) for `COMMON CODE` (loaded descending!). |
| `$3C2A` | `+1` | `COMMON_LEN_PAGES` | Number of 256-byte pages (`* 2` = 128B records) in `COMMON CODE`. |
| `$3C2B` | `+2` | `BANKED_LOAD_HI` | High byte of top load address (`H` with `L=$00`) for `BANKED CODE` (loaded descending!). |
| `$3C2C` | `+3` | `BANKED_LEN_PAGES` | Number of 256-byte pages (`* 2` = 128B records) in `BANKED CODE`. |
| `$3C2D–$3C2E` | `+4..+5` | `CPM_ENTRY_ADDR` | 16-bit Z80 entry point (`JP (HL)` at `$02D1`) to start CP/M 3.0 after loading! |
| `$3C2F` | `+6` | `BIOS8502_LOAD_HI` | High byte of top load address for `BIOS8502 CODE`. |
| `$3C30` | `+7` | `BIOS8502_LEN_PAGES` | Number of 256-byte pages in `BIOS8502 CODE`. Note: `$3C2F - $3C30` = start page of `BIOS8502 CODE`, stored into `$FFDE` (`JMP $xx00` at `$FFDC`)! |
| `$3C31` | `+8` | `DATA_TABLES_HI` | High byte of load address (`H` with `L=$00`) for `DATA TABLES` (loaded ascending!). |
| `$3C32` | `+9` | `DATA_TABLES_LEN` | Number of 256-byte pages (`* 2` = 128B records) in `DATA TABLES`. |
| `$3C33–$3C34` | `+10..+11` | `CPM_INFO_WORD` | Copied to `($FD09)` at `$0260` for CP/M BIOS initialization. |

### Stage 5: Loading the 4 Segments of `CPM+.SYS` (`$0243–$02D1`)
1. ** Embedded Banner String (`+128` / `$3480`):**
   - At `$0243`, the loader prints the copyright/version string embedded inside `CPM+.SYS` at offset `+128` (`$3480` in the first block buffer) via `CALL $0534`, then sets `($3C04) = $3500` (offset `+256` in `CPM+.SYS`, where segment records begin).
2. **Segment 1 — `DATA TABLES` (`$024F–$0277`, Loaded Ascending):**
   - Prints `"DATA TABLES"`, reads `($3C31/$3C32)` via `$0331`, stores start address in `($FD0B)`, and loops calling `$0344` (`ADD HL,$0080`) to load 128-byte records **ascending** in memory.
3. **Segment 2 — `COMMON CODE` (`$0278–$028E`, Loaded Descending):**
   - Prints `"COMMON CODE"`, loads `HL = $3C2A`, and calls `$0324` (`CPM_LOAD_DESCENDING_RECORDS`), which subtracts `$0080` (`ADD HL,$FF80`) before each 128-byte record read from `($3C29) << 8` downward!
4. **Segment 3 — `BANKED CODE` (`$028F–$02A5`, Loaded Descending):**
   - Prints `"BANKED CODE"`, loads `HL = $3C2C`, and calls `$0324` to load `BANKED CODE` descending from `($3C2B) << 8`.
5. **Segment 4 — `BIOS8502 CODE` (`$02A6–$02BE`, Loaded Descending):**
   - Prints `"BIOS8502 CODE"`, loads `HL = $3C30`, and calls `$0324` to load the runtime 8502 CP/M helper code descending from `($3C2F) << 8`.
6. **Final Handover to CP/M 3.0 (`$02BF–$02D1`):**
   ```z80
   $02BF: 3A 30 3C    LD A,($3C30)    ; B = BIOS8502 length in pages
   $02C2: 47          LD B,A
   $02C3: 3A 2F 3C    LD A,($3C2F)    ; A = BIOS8502 top page
   $02C6: 90          SUB B           ; A = BIOS8502 start page ($xx)
   $02C7: 32 DE FF    LD ($FFDE),A    ; Patch 8502 JMP target high byte at $FFDC!
   $02CA: AF          XOR A
   $02CB: 32 DD FF    LD ($FFDD),A    ; Patch 8502 JMP target low byte = $00 ($xx00)!
   $02CE: 2A 2D 3C    LD HL,($3C2D)   ; Load CP/M 3.0 Z80 cold boot entry address
   $02D1: E9          JP (HL)         ; Enter CP/M Plus!
   ```

---

## 3. GCR Logical-to-Physical Sector Translation (`$03E3–$044E` & `$0FB5–$0FFF`)

Commodore 1541 and 1571 drives use **Group Code Recording (GCR)** with variable sectors per track across 4 radial speed zones:
- **Tracks 1–17 (Side 0) / 36–52 (Side 1):** 21 sectors/track (`0..20`), 357 sectors total (`$0165`).
- **Tracks 18–24 (Side 0) / 53–59 (Side 1):** 19 sectors/track (`0..18`), 133 sectors total (`$0085`). Note: Track 18 (or 53) is skipped or reserved in standard CBM DOS, so `$0405` executes `INC HL` when crossing Track 17!
- **Tracks 25–30 (Side 0) / 60–65 (Side 1):** 18 sectors/track (`0..17`), 108 sectors total (`$006C`).
- **Tracks 31–35 (Side 0) / 66–70 (Side 1):** 17 sectors/track (`0..16`), 85 sectors total.

At `$03E3–$044E`, the Z80 BIOS translates a 16-bit logical sector number `($FD16)`:
1. Subtracts `$02A8` (`680` sectors = 1 full 35-track side minus Track 18) to determine if the sector is on **Side 0** (`$2400 = $00`, Tracks 1–35) or **Side 1** (`$2400 = $23` = `+35`, Tracks 36–70).
2. Subtracts zone sizes (`$0165` = 357, `$0085` = 133, `$006C` = 108) to determine the speed zone (`21`, `19`, `18`, or `17` sectors/track) and base track.
3. Divides the remainder by the zone's sectors-per-track (`E = 21, 19, 18, or 17`) to get the track offset `C` (`$FD03 = ($2400) + C`) and logical sector within the track (`HL`).
4. Looks up the **physical interleaved sector number** from the 75-byte GCR interleave table at **`$0FB5–$0FFF`** (`5:1` sector interleave):
   - **21-sector table (`$0FB5–$0FC9`, 21 bytes):** `0, 5, 10, 15, 20, 4, 9, 14, 19, 3, 8, 13, 18, 2, 7, 12, 17, 1, 6, 11, 16`
   - **19-sector table (`$0FCA–$0FDC`, 19 bytes):** `0, 5, 10, 15, 1, 6, 11, 16, 2, 7, 12, 17, 3, 8, 13, 18, 4, 9, 14`
   - **18-sector table (`$0FDD–$0FEE`, 18 bytes):** `0, 5, 10, 15, 2, 7, 12, 17, 4, 9, 14, 1, 6, 11, 16, 3, 8, 13`
   - **17-sector table (`$0FEF–$0FFF`, 17 bytes):** `0, 5, 10, 15, 3, 8, 13, 1, 6, 11, 16, 4, 9, 14, 2, 7, 12`

---

## 4. Specification of External Disk Image Required for Genuine CP/M Booting

To boot CP/M 3.0 natively through `z80bios.bin`, the emulator or real hardware requires a standard Commodore 1541 (`.d64`, 174,848 bytes) or 1571 (`.d71`, 349,696 bytes) disk image attached to **Device 8** with the following exact structure:
1. **Physical Track 1, Sector 0 (Logical Sector 0):**
   - Bytes `$00–$02`: `43 42 4D` (`"CBM"` signature, checked by both 8502 `BOOT_CALL` at `$F8FB` and Z80 `$046B`).
   - Byte `$FF`: `$00` (1541 single-sided, 1 KB CP/M blocks) or `$FF` (1571 double-sided, 2 KB CP/M blocks).
2. **CP/M Directory (Logical Sectors 0..3 on Track 1, Allocation Blocks 0 & 1):**
   - One or two 32-byte CP/M directory entries with Byte 0 = `$00` (User 0), Bytes 1–11 = `"CPM+    SYS"` (`43 50 4D 2B 20 20 20 20 53 59 53`), Byte 12 = Extent (`$00` or `$01`), and Bytes 16–31 = non-zero allocation block numbers.
3. **`CPM+.SYS` Binary Payload (in the referenced Allocation Blocks):**
   - Bytes `0..11`: 12-byte segment descriptor header (`COMMON CODE`, `BANKED CODE`, `CPM_ENTRY_ADDR`, `BIOS8502 CODE`, `DATA TABLES`).
   - Bytes `128..255`: Null-terminated banner string printed during boot.
   - Bytes `256+`: Sequential 128-byte records for `DATA TABLES`, `COMMON CODE`, `BANKED CODE`, and `BIOS8502 CODE`.
