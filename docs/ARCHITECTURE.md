# Commodore 128 System Architecture Specification

---

## 1. System Overview

The Commodore 128 (introduced in 1985) is one of the most complex 8-bit personal computers ever engineered. Unlike conventional single-processor architectures, the C128 incorporates two distinct microprocessors, two specialized video controllers, a custom Memory Management Unit (MMU 8722), and 128 KB of physical RAM expandable across multiple configurations and backwards-compatible operating modes (C128 Mode, C64 Mode, and CP/M Mode).

```
 +---------------------------------------------------------------------------------------+
 |                               COMMODORE 128 SYSTEM BUS                                |
 +---------------------------------------------------------------------------------------+
        |                                   |                                |
 +--------------+                    +--------------+                 +--------------+
 |   MOS 8502   |                    |  Zilog Z80A  |                 |   MMU 8722   |
 |   (1/2 MHz)  |<== Dual CPU ======>|    (4 MHz)   |<===============>| Memory Mgmt  |
 | Native C128  |    Handover Stub   |  CP/M 3.0    |                 |  128KB Banks |
 +--------------+                    +--------------+                 +--------------+
        |                                                                    |
        +-----------------------+----------------------+                     |
                                |                      |                     |
                         +--------------+       +--------------+             |
                         |   VIC-IIe    |       |   MOS 8563   |             |
                         | 40-Col Video |       | 80-Col RGBI  |             |
                         |   (320x200)  |       |  (640x200)   |             |
                         +--------------+       +--------------+             |
                                |                      |                     |
                                +----------+-----------+                     |
                                           |                                 |
                                    +--------------+                         |
                                    |     CIA 1    | <--- Keyboard Matrix /  |
                                    |    ($DC00)   |      Joystick Ports     |
                                    +--------------+                         |
                                    |     CIA 2    | <--- Fast Serial IEC /  |
                                    |    ($DD00)   |      Burst Disk Line    |
                                    +--------------+                         |
                                    |   SID 8580   | <--- 3-Voice Synthesis /|
                                    |    ($D400)   |      Filter Engine      |
                                    +--------------+                         |
                                           |                                 |
                         +-----------------+-----------------+               |
                         |                                   |               |
                  +--------------+                    +--------------+       |
                  |  RAM Bank 0  |                    |  RAM Bank 1  |       |
                  |    (64 KB)   |                    |    (64 KB)   | <-----+
                  | BASIC Source |                    | Variables/Arr|
                  +--------------+                    +--------------+
```

---

## 2. Dual-CPU Processor Architecture & Handover

### 2.1 The Two Processors
1. **MOS 8502 Microprocessor:**
   - Modified 6502/6510 core fabricated with high-density HMOS technology.
   - Dual clock frequency: 1.02 MHz (VIC-IIe active display) or 2.04 MHz (FAST mode / blanked display / 80-column VDC mode).
   - On-chip 8-bit bidirectional I/O port at `$0000-$0001` controlling cassette lines and VIC-IIe 2 MHz clock switching.
2. **Zilog Z80A Microprocessor:**
   - Standard Z80 instruction set architecture executing at 4.0 MHz host clock.
   - Operates synchronously with C128 system bus via bus stretching (effective speed ~2 MHz during active cycles).
   - Serves as the primary boot processor upon hardware cold reset, allowing instantaneous CP/M disk boot detection.

### 2.2 The Cold Reset & Handover Handshake
1. **Z80 Priority Boot:** At power-on or hardware reset, the MMU hardware forces the 8502 bus lines into tri-state (`AEC` held low) and releases the Z80 reset line.
2. **BIOS Check:** The Z80 begins execution at `$0000`, mapping the 4 KB embedded Z80 BIOS (`$1000-$1FFF` in KERNAL ROM) into its lower address space.
3. **CP/M Disk Detection:**
   - The Z80 reads Track 1, Sector 0 from Drive 8 via KERNAL `$F890`.
   - If the magic sector signature (`$C3` JMP instruction or CP/M boot record) is present, the Z80 continues execution, loads the CP/M BIOS into Bank 0 RAM, and jumps to `$018C`.
4. **Handover to 8502 (BASIC 7.0 Boot):**
   - If no CP/M boot disk is present, the Z80 writes `$01` to MMU Register `$D500` (bit 0 = 1).
   - The MMU activates the 8502 clock, pulls the Z80 into `BUSREQ` halt state, and releases the 8502.
   - The 8502 fetches its reset vector from `$FFFC-$FFFD` (pointing to `$F890`), initializing memory, CIAs, VIC-IIe, and displaying the Commodore BASIC 7.0 cold banner.

### 2.3 The Processor Switching Stub (`$FFD0-$FFEF`)
Because processor handover can occur while user programs execute in RAM, Commodore hardware reserves the top 32 bytes of page `$FF` (`$FFD0-$FFEF`) as common memory accessible by both CPUs regardless of MMU bank configuration:
```assembly
; Handover Stub located at $FFD0 in Common RAM:
FFD0: 8D 00 D5     STA $D500        ; Toggle active CPU in MMU
FFD3: EA           NOP              ; Bus settling cycle
FFD4: 4C 00 01     JMP $0100        ; Jump to destination in new CPU space
```

---

## 3. Memory Management Unit (MMU 8722)

The MMU 8722 translates the 16-bit processor address bus ($0000-$FFFF) into an expanded 18-bit physical address space, supporting up to 256 KB of RAM and 128 KB of ROM.

### 3.1 RAM Banking (Bank 0 vs Bank 1)
- **Bank 0 (64 KB):** Primary system RAM. Contains BASIC 7.0 program text, system workspace (`$0000-$03FF`), video matrices, and KERNAL workspace.
- **Bank 1 (64 KB):** Extended RAM. BASIC 7.0 automatically places all scalar variables, arrays, and string data in Bank 1, giving the user `122,365 BYTES FREE` for BASIC code without memory contention.

### 3.2 Common RAM Configuration
The MMU Register `$D506` (`RAMCR`) configures shared RAM windows between Bank 0 and Bank 1:
- **Bottom Common RAM:** Page 0, or `$0000-$03FF` (1 KB), or `$0000-$0FFF` (4 KB), or `$0000-$3FFF` (16 KB).
- **Top Common RAM:** `$FF00-$FFFF` (256 B), or `$F000-$FFFF` (4 KB), or `$C000-$FFFF` (16 KB).
This ensures operating system zero page pointers and CPU interrupt vectors are instantly shared between banks without copying.

### 3.3 MMU Register Map
| Address | Register Name | Description |
| :--- | :--- | :--- |
| `$D500 / $FF00` | `CR` | Configuration Register (Bank select, ROM enable, I/O space) |
| `$D501 / $FF01` | `PCR 0` | Preconfiguration Register 0 (Loadable via single write to $FF01) |
| `$D502 / $FF02` | `PCR 1` | Preconfiguration Register 1 |
| `$D503 / $FF03` | `PCR 2` | Preconfiguration Register 2 |
| `$D504 / $FF04` | `PCR 3` | Preconfiguration Register 3 |
| `$D505` | `MCR` | Mode Configuration Register (40/80 Col switch, C64 Mode bit) |
| `$D506` | `RCR` | RAM Configuration Register (Common RAM top/bottom sizing) |
| `$D507 / $D508`| `P0L / P0H` | Page 0 Relocation Pointer (Low/High byte) |
| `$D509 / $D50A`| `P1L / P1H` | Page 1 Relocation Pointer (Low/High byte - Stack relocation) |

---

## 4. Video Subsystem: Dual Displays

### 4.1 MOS 8564 / 8566 VIC-IIe (40-Column Display)
- 320 × 200 standard resolution (40 columns × 25 rows text mode).
- 16-color Commodore palette.
- Supports Standard Character, Extended Background Character, Multicolor Character, Standard Bitmap, and Multicolor Bitmap modes.
- 8 hardware sprites with multicolor and expansion capabilities.
- Programmable raster beam interrupt generator (`$D011 / $D012`).

### 4.2 MOS 8563 VDC (80-Column Display)
- High-resolution 640 × 200 (or 640 × 400 interlaced) RGBI digital video controller.
- Dedicated 16 KB (expandable to 64 KB) internal video RAM completely isolated from system RAM.
- Indirect register addressing via Status/Address register (`$D600`) and Data register (`$D601`) with 37 internal registers.
- High-density 8 × 8 or 8 × 16 pixel character generation with hardware underline, reverse video, and blinking.

---

## 5. Input/Output & Peripheral Controllers

### 5.1 Dual CIA 6526 / 8521 Chips
- **CIA 1 (`$DC00`):** Manages the 8 × 8 keyboard matrix, extended C128 keypad, cursor keys, joyports 1 & 2, and 60 Hz TOD clock.
- **CIA 2 (`$DD00`):** Manages VIC-IIe 16 KB video bank selection (bits 0-1), RS-232 serial communications, and the fast serial IEC burst protocol for 1571/1581 drives.
- **Time of Day (TOD) Clock:** Accurate 24-hour real-time clock featuring tenths of seconds, seconds, minutes, and hours stored in packed BCD format with hardware latching upon read/write.

### 5.2 SID 6581 / 8580 Sound Generator
- 3 independent programmable audio oscillators covering 9 octaves (0.1 Hz to 4 kHz).
- 4 waveforms per oscillator: Sawtooth, Triangle, Pulse with PWM, and pseudo-random Noise.
- Multi-mode analog filter with Low-Pass, Band-Pass, and High-Pass outputs.
