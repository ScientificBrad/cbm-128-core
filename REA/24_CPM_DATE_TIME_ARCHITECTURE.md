# REA 24: Commodore 128 CP/M 3.0 Date & Time Architecture & CIA1 TOD Repair

**Date:** 2026-11-08  
**Project:** Commodore 128 Reverse Engineering & Emulation (`D:\Emulation\C128`)  
**Executable:** `D:\Emulation\C128\releases\Commodore128.exe` (.NET 8 Windows x64)

---

## 1. Executive Summary

When running `B:DATE` from the companion utilities disk, the Commodore 128 CP/M 3.0 environment previously reported:
```text
Fri 12/06/85 97:??:??
```
The date portion (`Fri 12/06/85` on the 1985 disk, or `Thu 05/28/87` on the 1987 disk) was decoded correctly from the BIOS date words, but the time portion was corrupted with an impossible hour (`97`) and unrecognised minutes/seconds (`??:??`).

Through disassembly and tracing of `CPM+.SYS`, the exact hardware execution path was uncovered:
1. `DATE.COM` invokes **BDOS Function 105 (Get Date and Time)**.
2. BDOS delegates directly to **BIOS Function 26 (`TIME`)**, located at jump vector `$F04E` (which jumps to routine `$F41A`).
3. Routine `$F41A` queries the physical **MOS 6526 CIA1 Time-of-Day (TOD)** clock registers at ports **`$DC08-$DC0B`**.
4. In the emulator, registers `$DC08-$DC0B` were previously unmapped in `MemoryBus.cs`, returning `0xFF` on all reads.
5. In routine `$F41A`, the raw byte read from `$DC0B` (`0xFF`) was processed by the 12-hour AM/PM to 24-hour BCD algorithm:
   - `AND $7F` $\rightarrow$ `0x7F`
   - `ADD A, $12` $\rightarrow$ `0x91`
   - `DAA` (Decimal Adjust Accumulator) $\rightarrow$ `0x97` (Hours = 97)
   - Reads of `$DC0A` (Minutes) and `$DC09` (Seconds) returned `0xFF` (which exceed valid BCD limits 00–59), prompting `DATE.COM` to display `??:??`.

By implementing complete hardware-accurate **MOS 6526 CIA1 Time-of-Day (TOD)** clock emulation—including BCD counting, read-latching on Hours, unlatching on Tenths, clock freeze on Hours write, clock start on Tenths write, and host time synchronization on power-on—the original `DATE.COM` utility now displays authentic, continuously ticking date and time across all disk images.

---

## 2. CP/M Plus 3.0 Date and Time Architecture

### BDOS Interface
- **BDOS Function 104 (`C=0x68`) — Set Date and Time:**
  - Input: `DE` points to a 5-byte Date/Time record.
  - Updates the internal system date words and calls BIOS Function 26 (`TIME` with `C=0xFF` / `C=1`).
- **BDOS Function 105 (`C=0x69`) — Get Date and Time:**
  - Input: `DE` points to a 5-byte destination buffer.
  - Calls BIOS Function 26 (`TIME` with `C=0`) and copies the 5-byte structure.

### 5-Byte Date/Time Record Structure
| Offset | Field | Format | Range / Definition |
|---|---|---|---|
| `+0` | Date (Low Byte) | 16-bit Integer (LE) | Days since 1 January 1978 (Day 1 = 1978-01-01) |
| `+1` | Date (High Byte) | 16-bit Integer (LE) | High byte of day counter |
| `+2` | Hours | 8-bit BCD | `00` to `23` (24-hour format) |
| `+3` | Minutes | 8-bit BCD | `00` to `59` |
| `+4` | Seconds | 8-bit BCD | `00` to `59` |

---

## 3. Disassembly of C128 CP/M BIOS `TIME` Service (`$F41A`)

The BIOS jump table at `$F000` has 33 vectors of 3 bytes each. Entry 26 (`$F000 + 26*3 = $F04E`) contains:
```assembly
F04E: C3 1A F4      JP $F41A            ; BIOS Function 26: TIME
```

### Complete Disassembly of Routine `$F41A`:
```assembly
; =========================================================================
; C128 CP/M BIOS Routine $F41A: GET / SET TIME
; Input: C = 0 for GET TIME, C = 1 (or 0xFF) for SET TIME
; =========================================================================
F41A: 0C            INC C               ; C was 0 (now 1) for GET; C was 0xFF (now 0) for SET
F41B: 01 0B DC      LD BC, $DC0B        ; BC = CIA1 TOD Hours Register ($DC0B)
F41E: 28 42         JR Z, $F462         ; If Z set (was SET TIME), branch to $F462

; -------------------------------------------------------------------------
; GET TIME HANDLER
; -------------------------------------------------------------------------
F420: ED 78         IN A, (C)           ; Read CIA1 $DC0B (Hours BCD 1..12, Bit 7 = PM)
                                        ; Note: Reading $DC0B latches Tenths, Secs, Mins!
F422: F2 32 F4      JP P, $F432         ; If bit 7 == 0 (AM), jump to $F432
F425: E6 7F         AND $7F             ; Clear PM bit
F427: C6 12         ADD A, $12          ; Add 12 hours in BCD
F429: 27            DAA                 ; BCD decimal adjust
F42A: FE 24         CP $24              ; 12 PM + 12 = 24?
F42C: 20 09         JR NZ, $F437        ; If not 24, hour is valid (13..23)
F42E: 3E 12         LD A, $12           ; 12 PM stays 12
F430: 18 05         JR $F437
F432: FE 12         CP $12              ; 12 AM?
F434: 20 01         JR NZ, $F437        ; If 1..11 AM, keep hour
F436: AF            XOR A               ; 12 AM converts to 00 hours!
F437: 32 F6 EF      LD ($EFF6), A       ; Store 24-hr BCD Hours into Common RAM ($EFF6)
F43A: 47            LD B, A             ; B = current hour
F43B: 3A 61 F4      LD A, ($F461)       ; Load previous hour from ($F461)
F43E: 4F            LD C, A             ; C = previous hour
F43F: 78            LD A, B
F440: 32 61 F4      LD ($F461), A       ; Update ($F461) with current hour
F443: B9            CP C                ; Compare current hour with previous hour
F444: 30 09         JR NC, $F44F        ; If current >= previous, no midnight rollover

; Midnight Rollover: Advance Date by 1 Day
F446: E5            PUSH HL
F447: 2A F4 EF      LD HL, ($EFF4)      ; Load 16-bit Date Word (days since 1978-01-01)
F44A: 23            INC HL              ; Increment day counter
F44B: 22 F4 EF      LD ($EFF4), HL      ; Save updated day counter
F44E: E1            POP HL

; Read Minutes, Seconds, and Tenths
F44F: 01 0A DC      LD BC, $DC0A        ; BC = CIA1 TOD Minutes Register ($DC0A)
F452: ED 78         IN A, (C)           ; Read Minutes BCD (00..59)
F454: 32 F7 EF      LD ($EFF7), A       ; Store BCD Minutes into ($EFF7)
F457: 0D            DEC C               ; BC = CIA1 TOD Seconds Register ($DC09)
F458: ED 78         IN A, (C)           ; Read Seconds BCD (00..59)
F45A: 32 F8 EF      LD ($EFF8), A       ; Store BCD Seconds into ($EFF8)
F45D: 0D            DEC C               ; BC = CIA1 TOD Tenths Register ($DC08)
F45E: ED 78         IN A, (C)           ; Read Tenths BCD (0..9)
                                        ; Note: Reading $DC08 releases TOD latch!
F460: C9            RET

; -------------------------------------------------------------------------
; SET TIME HANDLER ($F462)
; -------------------------------------------------------------------------
F462: 3A F6 EF      LD A, ($EFF6)       ; Load requested 24-hr BCD hours
F465: 32 61 F4      LD ($F461), A
F468: FE 12         CP $12              ; 12 PM?
F46A: 28 10         JR Z, $F47C         ; -> $92
F46C: A7            AND A               ; 00 (Midnight)?
F46D: 20 04         JR NZ, $F473
F46F: 3E 12         LD A, $12           ; 12 AM
F471: 18 09         JR $F47C
F473: FE 12         CP $12
F475: 38 05         JR C, $F47C         ; < 12 -> AM
F477: D6 12         SUB $12             ; > 12 -> Subtract 12
F479: 27            DAA
F47A: F6 80         OR $80              ; Set PM flag (bit 7)
F47C: ED 79         OUT (C), A          ; Write Hours to CIA1 $DC0B (freezes TOD clock!)
F47E: 0D            DEC C               ; BC = $DC0A
F47F: 3A F7 EF      LD A, ($EFF7)       ; Load requested BCD Minutes
F482: ED 79         OUT (C), A          ; Write Minutes to CIA1 $DC0A
F484: 0D            DEC C               ; BC = $DC09
F485: 3A F8 EF      LD A, ($EFF8)       ; Load requested BCD Seconds
F488: ED 79         OUT (C), A          ; Write Seconds to CIA1 $DC09
F48A: 0D            DEC C               ; BC = $DC08
F48B: AF            XOR A               ; Tenths = 0
F48C: ED 79         OUT (C), A          ; Write Tenths to CIA1 $DC08 (restarts TOD clock!)
F48E: C9            RET
```

---

## 4. Origin of the `Fri 12/06/85 97:??:??` Defect

### Why Did the Hour Become `97`?
When the emulator returned unmapped bus float (`0xFF`) for CIA1 register `$DC0B`:
1. `IN A, ($DC0B)` loaded `A = 0xFF`.
2. Bit 7 was `1`, so `JP P` did not take the branch (treated as PM).
3. `AND $7F` produced `A = 0x7F`.
4. `ADD A, $12` performed binary addition: `0x7F + 0x12 = 0x91`.
5. `DAA` executed on `0x91`: with lower nibble `1` and upper nibble `9` with auxiliary flag set, `DAA` added `6` to the lower nibble, yielding **`0x97`**.
6. `$EFF6` received `0x97` ($97$ in BCD).

### Why Did Minutes and Seconds Display as `??:??`?
When `$DC0A` and `$DC09` returned `0xFF`:
1. The BCD tens digit was `F` ($15$) and units digit was `F` ($15$), both exceeding valid BCD digits ($0$–$5$ and $0$–$9$).
2. In `DATE.COM`, an internal validator checks `if (tens > 5 || units > 9) print("??")`.
3. Thus, minutes and seconds were formatted as `??:??`.

### Why Did the Date Show `Fri 12/06/85`?
During cold boot of the 1985 system disk (`cpm_1985.d64`), `CPM+.SYS` at file offset `0x2DA8` executes:
```assembly
21 51 0B        LD HL, $0B51        ; 2897 decimal
22 F4 EF        LD ($EFF4), HL      ; Store initial date word
```
`$0B51` ($2897$ days) represents **Friday, 6 December 1985** ($1978\text{-}01\text{-}01 + 2896\text{ days}$).  
Similarly, the 1987 system disk (`cpm_1987.d64`) at file offset `0x3CAE` executes:
```assembly
21 6B 0D        LD HL, $0D6B        ; 3435 decimal
22 F4 EF        LD ($EFF4), HL
```
`$0D6B` ($3435$ days) represents **Thursday, 28 May 1987** ($1978\text{-}01\text{-}01 + 3434\text{ days}$).

---

## 5. MOS 6526 CIA1 Time-of-Day Hardware Emulation

The emulator now provides authentic MOS 6526 CIA Time-of-Day clock emulation in `MemoryBus.cs`:

### 1. Register Mapping
- **`$DC08` (Register 8):** TOD Tenths of seconds (BCD `0`..`9`). Reading releases latches; writing restarts the clock.
- **`$DC09` (Register 9):** TOD Seconds (BCD `00`..`59`).
- **`$DC0A` (Register 10):** TOD Minutes (BCD `00`..`59`).
- **`$DC0B` (Register 11):** TOD Hours (BCD `01`..`12`, bit 7 = PM flag). Reading latches all registers; writing freezes clock until Tenths is written.

### 2. Dual Register Latching
- When reading `$DC0B`, `LatchedHours`, `LatchedMinutes`, `LatchedSeconds`, and `LatchedTenths` are snapshotted. Internal timekeeping continues in the background, but reads return the latched values until `$DC08` is read.
- When writing `$DC0B`, `TodStopped` is set to `true`, preventing time progression during multi-byte clock configuration until `$DC08` is written.

### 3. Ticking and Rollover
- In `StepCycles(int cycles)`, cycles accumulate into `_todCycleAccum`. Every $100,000$ cycles ($\frac{1}{10}\text{ s}$ at $1\text{ MHz}$), `TodTenths` increments, cascading accurately through seconds, minutes, and 12-hour AM/PM transitions.
- On power-on, `InitTodFromHost()` synchronizes the CIA1 TOD clock with the host system time (`DateTime.Now`).

---

## 6. Empirical Verification Logs

### Test 1: Baseline Boot & Time Read on 1985 Disk
```powershell
.\releases\Commodore128.exe --roms "D:\Emulation\C128" --cpm --disk ".\disks\cpm_1985.d64" --disk2 ".\disks\cpm.utilities.d64" --exec "B:DATE"
```
**Output:**
```text
CP/M 3.0 On the Commodore 128 8 DEC 85
          40 column display
A>B:DATE
Fri 12/06/85 15:23:49
A>
                                R B02 20
```
$\rightarrow$ Valid date and valid host-synchronized 24-hour time displayed.

---

### Test 2: Baseline Boot & Time Read on 1987 Revision
```powershell
.\releases\Commodore128.exe --roms "D:\Emulation\C128" --cpm --disk ".\disks\cpm_1987.d64" --disk2 ".\disks\cpm.utilities.d64" --exec "B:DATE"
```
**Output:**
```text
CP/M 3.0 On the Commodore 128 28 MAY 87
          40 column display
A>B:DATE
Thu 05/28/87 15:24:01
A>
                                R B02 20
```
$\rightarrow$ Valid date (`Thu 05/28/87`) and clock progressing naturally ($15:24:01$).

---

### Test 3: Setting Date and Time Interactively (`DATE MM/DD/YY HH:MM:SS`)
```powershell
.\releases\Commodore128.exe --roms "D:\Emulation\C128" --cpm --disk ".\disks\cpm_1985.d64" --disk2 ".\disks\cpm.utilities.d64" --exec "B:DATE 11/08/88 10:30:00\r \rB:DATE"
```
**Output:**
```text
CP/M 3.0 On the Commodore 128 8 DEC 85
          40 column display
A>B:DATE 11/08/88 10:30:00
Strike key to set time
A>
A>B:DATE
Tue 11/08/88 10:30:50
A>
                                R B02 20
```
$\rightarrow$ BDOS Function 104 and BIOS `$F462` wrote the date to `$EFF4` and programmed the CIA1 TOD registers. The subsequent `B:DATE` read back `Tue 11/08/88 10:30:50`, showing $50\text{ s}$ of elapsed execution time.
