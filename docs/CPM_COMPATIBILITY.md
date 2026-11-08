# CP/M Plus 3.0 Compatibility & Execution Architecture
**Project 002: Commodore 128 Dual-CPU Reconstruction**  
**Author:** ScientificBrad Research & Digital Preservation

---

## 1. Commodore CP/M 3.0 Architecture

The Commodore 128 is unique in shipping with a built-in Zilog Z80A coprocessor specifically designed to run Digital Research's **CP/M Plus (Version 3.0)**. CP/M on the C128 utilizes banked memory, providing a large Transient Program Area (~58 KB TPA) while executing BDOS and BIOS routines in alternative banks.

```
            CP/M PLUS 3.0 BOOT SEQUENCE & PROCESSOR HANDOVER
            =================================================

    [Power-On / Reset]
           |
           v
    +--------------------------------------------------------+
    | Zilog Z80A starts at $0000                             |
    | Maps 4 KB embedded Z80 BIOS into lower address space    |
    +--------------------------------------------------------+
           |
           v
    +--------------------------------------------------------+
    | Z80 invokes MOS 8502 helper at $F890                   |
    | Reads Track 1, Sector 0 from floppy drive into $0100   |
    +--------------------------------------------------------+
           |
           v
    +--------------------------------------------------------+
    | Does sector contain CP/M boot signature ($C3 JMP)?     |
    +--------------------------------------------------------+
         /         \
       YES          NO
       /             \
      v               v
+------------------+  +---------------------------------------------+
| Boot CP/M 3.0    |  | Handover to 8502 via MMU $D500 bit 0 = 1    |
| Jump to $018C    |  | Reset vector $FFFC -> Boot Commodore BASIC  |
| Load CPM+.SYS    |  | Display "COMMODORE BASIC V7.0" banner       |
| Launch CCP.COM   |  +---------------------------------------------+
| Display Prompt   |
| "A>"             |
+------------------+
```

---

## 2. Boot Milestone & Verification

Our reconstruction successfully executes the entire CP/M Plus 3.0 boot sequence from genuine `.d64` floppy disk images:

- **Cold Boot Handshake:** Complete KERNAL `$F890` disk sector fetch and transfer to `$018C`.
- **System Loader:** Relocates `CPM+.SYS` and Console Command Processor (`CCP.COM`) to `$F000`.
- **Operating System Online:** CP/M 3.0 operational banner displayed at approximately 15.7 million emulated cycles:
  ```text
  CP/M 3.0 On the Commodore 128 8 DEC 85
            40 column display

  A>DIR
  A: CPM+     SYS : CCP      COM : HELP     HLP
  A: KEYFIG   HLP : FORMAT   COM : COPYSYS  COM
  A>
  ```
- **Dual Display Verification:** CP/M commands function flawlessly in both 40-column mode (VIC-IIe) and 80-column mode (MOS 8563 VDC).

---

## 3. Floppy Disk Compatibility Ledger

Three historical CP/M disk revisions were tested:

| Disk Image | Release Date | Disk Geometry | Status | Verification Summary |
| :--- | :--- | :--- | :---: | :--- |
| `cpm_1985.d64` | 08-DEC-1985 | 35 Tracks, D64 | **PASS** | Boots CP/M 3.0, executes `DIR`, runs CCP internal commands. |
| `cpm_1987.d64` | 28-MAY-1987 | 35 Tracks, D64 | **PASS** | Updated BIOS release, supports fast burst disk I/O. |
| `cpm.utilities.d64` | Archival Dump | 35 Tracks, D64 | **PASS** | Executes `COPYSYS.COM`, `FORMAT.COM`, and `DATE.COM`. |

---

## 4. CP/M Date & Time Subsystem Repair

### 4.1 The Bug
When running the genuine CP/M `DATE` utility from disk:
```text
A>B:DATE
Fri 12/06/85 97:??:??
```
The date decoded accurately from the disk directory timestamps, but the time field reported an invalid hour (`97`) and question marks for minutes and seconds.

### 4.2 Root Cause Analysis
CP/M 3.0 queries the C128 hardware real-time clock via the Z80 BIOS `TIME` vector, which reads CIA 1 Time of Day (TOD) registers at `$DC08-$DC0B`:
- `$DC08`: Tenths of a second (BCD 0-9)
- `$DC09`: Seconds (BCD 0-59)
- `$DC0A`: Minutes (BCD 0-59)
- `$DC0B`: Hours (BCD 1-12 with AM/PM bit 7)

Investigation of the CIA emulation revealed two defects:
1. **Unlatched Multi-Byte Read:** The MOS 6526 / 8521 CIA specification requires that reading `$DC0B` (Hours) latches the remaining TOD registers, freezing their contents until `$DC08` (Tenths) is read. Without this latching mechanism, registers updated asynchronously during the BIOS read loop, returning corrupted transitional values.
2. **BCD Bit Masking & 50/60 Hz Prescaler:** The CIA 1 Control Register B (`$DC0F` bit 7) selects 50 Hz or 60 Hz TOD clock input. The emulator lacked proper BCD bit masking, causing the AM/PM flag and unlatched registers to overflow into invalid BCD values like `$97`.

### 4.3 Hardware Repair
We corrected the CIA 1 TOD emulation:
- Implemented register latching on `$DC0B` read and release on `$DC08` read.
- Added strict BCD validation and 60 Hz timer cycle integration.
- Corrected AM/PM flag interpretation.

**Repaired Output:**
```text
A>B:DATE
Fri 12/06/85 09:14:22
A>
```
The genuine Commodore CP/M DATE utility now displays valid, advancing time.
