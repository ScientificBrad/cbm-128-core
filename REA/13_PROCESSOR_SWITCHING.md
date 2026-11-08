# PHASE 4 DELIVERABLE 2: DUAL-PROCESSOR SWITCHING & CO-PROCESSOR ARCHITECTURE

**Project:** `cbm-128-core` (Project 002: Commodore 128 1985 Firmware & Hardware Analysis)  
**Target Hardware:** MOS 8722 MMU (`$D505` Mode Configuration Register), Zilog Z80A, MOS 8502  
**Primary ROM Evidence:** `z80bios.bin` (`$0000–$00B3`, `$018C–$01B8`, `$044F–$046A`, `$0D1A–$0F03`) & `kernal.318020-03.bin` (`$E242–$E26A`, `$F890–$F9FB`, `$FF3D–$FF46`)  
**Methodology Classification:** `CONFIRMED`

---

## 1. Hardware Bus Arbitration & MMU `$D505` (`MCR`)

On the Commodore 128 motherboard, **both** the Zilog Z80A and the MOS 8502 are connected to the system address, data, and control buses, but **only one processor is clocked and granted bus ownership at any instant**. Processor selection is governed by **Bit 0 (`Z80EN`)** of the 8722 MMU Mode Configuration Register at **`$D505`** (`MMU_MCR`):

| `$D505` Bit | Name | Direction | Value = `0` | Value = `1` |
|---:|---|---|---|---|
| **Bit 7** | `40/80` | Read-Only | `40/80 DISPLAY` key pressed (80-col) | `40/80 DISPLAY` key released (40-col) |
| **Bit 6** | `OSMODE` | Read/Write | **C128 Native Mode** (MMU active) | **C64 Compatibility Mode** (MMU locked) |
| **Bit 5** | `/EXROM` | Read/Write* | Cartridge `/EXROM` asserted (active low) | Cartridge `/EXROM` deasserted (high) |
| **Bit 4** | `/GAME` | Read/Write* | Cartridge `/GAME` asserted (active low) | Cartridge `/GAME` deasserted (high) |
| **Bit 3** | `FSDIR` | Read/Write | Fast Serial bus direction = Input | Fast Serial bus direction = Output |
| **Bits 2:1** | Reserved | Unused | Always `00` | — |
| **Bit 0** | `Z80EN` | Read/Write | **Zilog Z80A Active** (8502 halted via `AEC`) | **MOS 8502 Active** (Z80 halted via `/BUSREQ`) |

### Why the Z80 Always Starts First on Hardware Reset (`C128-Z80-001`)
1. On power-on or hardware `/RESET`, the 8722 MMU clears all internal registers (`$D500–$D50A`) to `$00`.
2. Because `$D505` bit 0 resets to `0` (`Z80EN = 0`) and bit 6 resets to `0` (`C128 mode`), the **Zilog Z80A is always the active boot processor** on every Commodore 128 power-up or reset, while the MOS 8502 is held off the bus.
3. This hardware design solves a critical problem: in C64 mode (`$D505` bit 6 = `1`), the MMU's `$D500–$D50B` registers disappear from the `$D500` I/O space so C64 software cannot accidentally corrupt C128 banking. By waking the Z80 first in C128 mode (`$D505 = $00`), the Z80 firmware can inspect the hardware cartridge sense lines (`/GAME` and `/EXROM` on `$D505` bits 4–5) and the Commodore (`C=`) key on CIA1 (`$DC00/$DC01`) **before** deciding whether to lock the MMU into C64 mode (`$D505 = $F1` or `$F7`) or initialize C128 mode (`$D505 = $B1`).

---

## 2. The Shared RAM Processor-Switch Stub (`$FFD0–$FFEF`)

Because the Z80 BIOS ROM (`$0000–$0FFF`) and the 8502 KERNAL ROM (`$E000–$FFFF`) occupy different memory spaces and banking configurations, any processor switch must occur inside **Common RAM** visible to both CPUs at the exact same address.

Both the Z80 BIOS (at `$0EE5–$0F03` in `z80bios.bin`) and the 8502 KERNAL (at `$E295–$E2B3` in `kernal.318020-03.bin`) contain copies of the **31-byte Dual-CPU Handoff Stub**, which is copied into Common RAM at **`$FFD0–$FFEF`**:

```text
Address Range: $FFD0-$FFEF (31 bytes in Common RAM Bank 0)
  $FFD0-$FFDF (16 bytes): Executed by MOS 8502 to switch to Z80 (and resume when switched back)
  $FFE0-$FFEF (15 bytes): Executed by Zilog Z80A to switch to 8502 (and resume when switched back)
```

### 2.1 Byte-by-Byte Disassembly of `$FFD0–$FFEF` (Copied from `z80bios.bin` `$0EE5–$0F03`)

#### Part A: MOS 8502 Half (`$FFD0–$FFDF`)
| RAM Address | ROM Offset | Hex Bytes | 8502 Instruction | Execution Role |
|---|---|---|---|:---|
| `$FFD0` | `$0EE5` | `78` | `SEI` | Disable 8502 maskable interrupts prior to bus release. |
| `$FFD1` | `$0EE6` | `A9 3E` | `LDA #$3E` | Prepare MMU `CR = $3E` (Bank 0 RAM, I/O enabled, Z80 ROM enabled). |
| `$FFD3` | `$0EE8` | `8D 00 FF` | `STA $FF00` | Write MMU Configuration Register (`CR`). |
| `$FFD6` | `$0EEB` | `A9 B0` | `LDA #$B0` | `MCR = $B0` (`bit 0 = 0` -> **Enable Z80, Halt 8502**). |
| `$FFD8` | `$0EED` | `8D 05 D5` | `STA $D505` | **BUS HANDOVER TO Z80!** 8502 freezes after this write cycle. |
| `$FFDB` | `$0EF0` | `EA` | `NOP` | **8502 RESUME POINT:** Prefetch/pipeline cushion when Z80 sets `$D505` bit 0 = `1`. |
| `$FFDC` | `$0EF1` | `4C 00 30` | `JMP $3000` | Patched dynamically! Set to `JMP $1100` on cold boot (`$00AE`), `JMP $3000` for CP/M 8502 Slave (`$01A6`), or `JMP $xx00` for `BIOS8502 CODE` (`$02C7`). |
| `$FFDF` | `$0EF4` | `EA` | `NOP` | Alignment padding byte before `$FFE0`. |

#### Part B: Zilog Z80A Half (`$FFE0–$FFEF`)
| RAM Address | ROM Offset | Hex Bytes | Z80 Instruction | Execution Role |
|---|---|---|---|:---|
| `$FFE0` | `$0EF5` | `F3` | `DI` | Disable Z80 maskable interrupts prior to bus release. |
| `$FFE1` | `$0EF6` | `3E 3E` | `LD A,$3E` | Prepare MMU `CR = $3E` (Bank 0 RAM, I/O enabled). |
| `$FFE3` | `$0EF8` | `32 00 FF` | `LD ($FF00),A` | Write MMU Configuration Register (`CR`). |
| `$FFE6` | `$0EFB` | `01 05 D5` | `LD BC,$D505` | Point `BC` to MMU Mode Configuration Register (`$D505`). |
| `$FFE9` | `$0EFE` | `3E B1` | `LD A,$B1` | `MCR = $B1` (`bit 0 = 1` -> **Enable 8502, Halt Z80**). |
| `$FFEB` | `$0F00` | `ED 79` | `OUT (C),A` | **BUS HANDOVER TO 8502!** Z80 freezes with PC at `$FFED`. |
| `$FFED` | `$0F02` | `00` | `NOP` | **Z80 RESUME POINT:** Pipeline cushion when 8502 writes `$B0` to `$D505`. |
| `$FFEE` | `$0F03` | `CF` | `RST $08` | On initial cold handoff back from 8502 `BOOT_CALL`, executes `RST $08` (`-> $0008 -> $018C` CP/M loader). During CP/M boot (`$01B1`), patched to **`$C9` (`RET`)** so `CALL $FFE0` returns to the Z80 caller! |

---

## 3. Complete Dual-Processor Startup & Handover Trace

The Commodore 128 uses a multi-stage co-processor handshake between the Z80A and the 8502. Below is the exact instruction-level trace across all four scenarios.

### Scenario A: Cold Boot to C128 BASIC 7.0 (Z80 -> 8502)
1. **Z80 Reset (`$0000–$0052`):**
   - Z80 starts at `$0000`, writes `$3E` to `$FF00`, and jumps to `$003B`.
   - Writes `$FF` to `$D02F` and `$FC` to `$D030` (1 MHz clock).
   - Writes `$B0` to `$D505` and reads back `$D505` (`IN A,(C); CPL; AND $30`). Neither `/GAME` nor `/EXROM` is low.
2. **Z80 Checks `C=` Key (`$0059–$007A`):**
   - Initializes CIA1 (`$DC0F=$08, $DC0E=$08, $DC03=$00, $DC02=$FF, $DC00=$7F`) and reads `$DC01` (`AND $20`). Bit 5 is `1` (`C=` key not pressed).
3. **Z80 Prepares MMU & 8502 Cold-Boot Trampoline (`$007C–$00B0`):**
   - Loops 11 times copying `$0FB4..$0FAA` into `$D50A..$D500`.
   - `LDIR` copies 8 bytes from ROM `$0D1A–$0D21` to Bank 0 RAM `$1100–$1107`:
     ```6502
     $1100: A9 00       LDA #$00        ; Enable KERNAL/BASIC ROMs + I/O ($D500/$FF00 = $00)
     $1102: 8D 00 FF    STA $FF00
     $1105: 6C FC FF    JMP ($FFFC)     ; Indirect jump through KERNAL Reset Vector ($FF3D -> $E000)
     ```
   - `LDIR` copies 31 bytes from ROM `$0EE5–$0F03` to `$FFD0–$FFEF`.
   - Stores `$1100` into `$FFFA` (RAM NMI vector), `$FFFC` (RAM Reset vector), `$FFFE` (RAM IRQ vector), and **`$FFDD`** (patching `JMP $3000` at `$FFDC` to **`JMP $1100`**!).
4. **Z80 Transfers Bus to 8502 (`$00B1 -> $FFE0–$FFEB`):**
   - Z80 jumps to `$FFE0`, executes `DI; LD A,$3E; LD ($FF00),A; LD BC,$D505; LD A,$B1; OUT (C),A`.
   - Writing `$B1` to `$D505` halts the Z80 (with Z80 `PC` frozen at `$FFED`) and starts the MOS 8502!
5. **8502 Wakes Up & Enters C128 KERNAL (`$FFFC / $FFDB -> $1100 -> $E000`):**
   - If the 8502 is coming out of initial power-on reset, it fetches its hardware reset vector from `$FFFC` (which is RAM `$1100` because `CR = $3E` maps RAM at `$E000–$FFFF`!). If the 8502 was previously halted at `$FFD8`, it resumes at `$FFDB` (`NOP; JMP $1100`). Either way, the 8502 lands at **`$1100`**!
   - At `$1100`, the 8502 executes `LDA #$00; STA $FF00` (which maps the 8502 KERNAL ROM at `$C000–$FFFF`), and executes `JMP ($FFFC)` — which now reads the **KERNAL ROM** reset vector at `$FFFC` (`$FF3D -> JMP $E000`)!

---

### Scenario B: Cold Boot Direct to C64 Mode (Cartridge or `C=` Key Held)
1. **Detection by Z80 (`$004D–$0058` or `$0075–$007A`):**
   - If `/GAME` or `/EXROM` is asserted low on the expansion port (`$0050: AND $30 != 0`) OR the user holds the `C=` key (`$0075: AND $20 == 0`), the Z80 branches to `$0054`:
     ```z80
     $0054: 3E F1       LD A,$F1        ; Bit 6=1 (C64 mode), Bits 5:4=11, Bit 3=0, Bit 0=1 (8502 active)
     $0056: ED 79       OUT (C),A       ; Write $F1 to $D505 -> Lock C64 mode & switch to 8502!
     $0058: C7          RST $00         ; Z80 pipeline cushion
     ```
2. **Detection by 8502 KERNAL (`$E242–$E26A`):**
   - Even after switching to the 8502 in C128 mode, the 8502 KERNAL `RESET` routine calls `$E242`, which checks `LDA $D505; AND #$30; CMP #$30` and scans the `C=` key (`$E26B`), or is invoked via the `GO 64` command (`$FF4D -> $E24B`).
   - `$E24B` sets processor port `$0001 = $E3`, `$0000 = $2F`, copies a 6-byte stub from `$E263–$E26A` to zero page `$0002–$0007`:
     ```6502
     $0002: A9 F7       LDA #$F7        ; C64 mode + 8502 active
     $0004: 8D 05 D5    STA $D505       ; Lock MMU into C64 mode
     $0007: 6C FC FF    JMP ($FFFC)     ; Jump through C64 KERNAL Reset Vector ($FCE2)
     ```

---

### Scenario C: 8502 `BOOT_CALL` (`$F890`) Handoff Back to Z80 for CP/M (`C128-Z80-005`)
How does the Commodore 128 boot a CP/M 3.0 disk?
1. During normal C128 startup, after initializing the screen and BASIC, the 8502 calls KERNAL `BOOT_CALL` (`$FF53 -> $F890` with `X = 8`, `A = $D505` value).
2. At `$F890–$F8FA`, the 8502 opens channel 15 (`#0`) and sends `"U1:13 0 1 0"` to Drive 8 to read **Track 1, Sector 0** into Bank 0 RAM at **`$0B00–$0BFF`**.
3. At `$F8FB–$F906`, the 8502 checks the first 3 bytes at `$0B00–$0B02` against `"CBM"` (`$43, $42, $4D` at `$E2C4`).
4. What is in Track 1, Sector 0 of a Commodore 128 **CP/M 3.0 System Disk**?
   - Bytes `$00–$02`: `43 42 4D` (`"CBM"` signature)
   - Bytes `$03–$06`: `00 00 00 00` (Load address `$0000`, bank `$00`, `0` additional boot sectors to load)
   - Bytes `$07–$08`: `00` (Empty system name string — so it prints `"BOOTING ..."`), followed by `00` (no filename to `LOAD`)
   - Bytes `$09+`: **6502 machine code executed by `JSR $02CD` (`JMP $0B09`) at `$F986`!**
   - And what is the 6502 machine code at `$0B09` on a C128 CP/M boot sector (or when `BOOT` is executed on a CP/M disk)? It simply executes **`JMP $FFD0`** (or `JSR $E242`), entering the 8502 half of the shared RAM stub (`$FFD0: SEI; LDA #$3E; STA $FF00; LDA #$B0; STA $D505`)!
5. When the 8502 executes `STA $D505` (`$B0`) at `$FFD8`, the 8502 halts and the **Z80 resumes at `$FFED` (`NOP`) -> `$FFEE` (`RST $08`)**!
6. `RST $08` (`$0008`) sets `SP = $3C77`, `A = $3F`, and jumps to **`$018C` (`CPM_BOOT_INIT`)**, launching the Z80 BIOS CP/M 3.0 loader!

---

### Scenario D: Z80 Master / 8502 Slave RPC During CP/M Disk I/O (`C128-Z80-006`)
Why does `z80bios.bin` contain **451 bytes of MOS 8502 machine code** at `$0D22–$0EE4`?
- On the Commodore 128 hardware, the IEC serial bus (`$DD00`) and Fast Serial shift register (`$DC0C/$DC0D`) require precise cycle timing and already have complete protocol routines (`OPEN`, `CLOSE`, `CHKIN`, `CHKOUT`, `BASIN`, `BSOUT`, `SETLFS`, `SETNAM`, `SETBNK`, `READST`) in the **8502 KERNAL ROM (`$E000–$FFFF`)**.
- Rather than duplicating the entire Commodore IEC serial bus stack in Z80 assembly inside the 4 KB `z80bios.bin` ROM, the Z80 BIOS treats the **MOS 8502 as an I/O slave co-processor**!
- Here is how the Z80 Master / 8502 Slave RPC works step by step:
  1. **Installation (`$019B–$01B8`):**
     - Z80 copies the 451-byte 8502 slave driver from Z80 BIOS ROM `$0D22–$0EE4` into Bank 0 RAM at **`$3000–$31C2`**.
     - Z80 re-copies the 31-byte handoff stub from `$0EE5–$0F03` to **`$FFD0–$FFEF`** (where `$FFDC` already has `4C 00 30` = **`JMP $3000`**!).
     - Z80 patches byte **`$FFEE`** in the shared stub from `$CF` (`RST $08`) to **`$C9` (`RET`)**:
       ```z80
       $01B1: 3E C9       LD A,$C9        ; Opcode for Z80 RET
       $01B3: 32 EE FF    LD ($FFEE),A    ; Replace RST $08 at $FFEE with RET!
       $01B6: CD E0 FF    CALL $FFE0      ; Call 8502 slave to initialize ($FD01 = $00)!
       ```
  2. **RPC Call (`CALL $FFE0` from `$01B6` or `$045C`):**
     - Z80 writes parameters into the shared mailbox at `$FD01–$FD19` (`$FD01` = command `$00` init or `$01` read sector; `$FD03` = track; `$FD04` = sector; `$FD18–$FD19` = RAM buffer address).
     - Z80 executes `CALL $FFE0`.
     - At `$FFE0`, the Z80 writes `$B1` to `$D505`, halting itself with its return address on the Z80 stack.
  3. **8502 Slave Execution (`$FFDB -> $3000–$31C2`):**
     - The 8502 wakes up at `$FFDB` (`NOP`) and executes `JMP $3000`.
     - At `$3000` (`ROM $0D22`):
       ```6502
       $3000: A9 00       LDA #$00
       $3002: 8D 06 FD    STA $FD06       ; Clear error status byte ($FD06 = 0)
       $3005: 20 11 30    JSR $3011       ; Execute requested slave command!
       $3008: 78          SEI             ; Done! Prepare to return to Z80
       $3009: A9 3E       LDA #$3E
       $300B: 8D 00 FF    STA $FF00       ; Restore CR = $3E (Z80 BIOS ROM visible)
       $300E: 4C D0 FF    JMP $FFD0       ; Switch back to Z80 via $FFD0!
       ```
  4. **Return to Z80 (`$FFD0 -> $FFED -> $FFEE`):**
     - At `$FFD0`, the 8502 writes `$B0` to `$D505`, halting itself at `$FFDB`.
     - The Z80 wakes up at `$FFED` (`NOP`), executes **`$FFEE: RET` (`$C9`)**, and returns directly to the instruction after `CALL $FFE0` (`$01B9` or `$045F`)!
     - At `$045F`, the Z80 sets `CR = $3F` (`LD A,$3F; LD ($FF00),A`) and inspects `($FD06)` to check if the 8502 disk operation succeeded (`$00`) or failed (`$0D` / `$0F` / `$FF`).
