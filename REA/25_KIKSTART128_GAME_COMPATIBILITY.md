# REA REPORT 25: COMMODORE 128 COMMERCIAL GAME COMPATIBILITY & GRAPHICS ENGINE
## KIKSTART 128 (1986 SHAUN SOUTHERN / MR. CHIP SOFTWARE / MASTERTRONIC)

**Date:** 8 November 2026  
**Target:** `D:\Emulation\C128\games\KIK128.D64`  
**Executable:** `D:\Emulation\C128\releases\Commodore128.exe`  
**GUI Execution:** `Commodore128.exe --game games/KIK128.D64 --gui` (or `--interactive`)  
**Status:** COMPLETE — AUTHENTIC 320x200 HARDWARE VIDEO ENGINE & NATIVE GRAPHICAL WINDOW ONLINE

---

## 1. EXECUTIVE SUMMARY

The commercial game **Kikstart 128** (written by Shaun Southern, Mr. Chip Software, published by Mastertronic, 1986) has been upgraded from terminal-based character emulation to an authentic, hardware-accurate, pixel-based Commodore 128 display engine.

A native C# .NET 8 graphical window (`Commodore128Window`) and real-time raster scanline renderer (`VicIIeRasterRenderer`) have been implemented, rendering every pixel directly from emulated MOS 8564/8566 VIC-IIe hardware registers, memory banks, character sets, and sprite data.

All twelve core video emulation requirements and Windows display capabilities are fully implemented and validated:
1. **320 × 200 Pixel Display Resolution:** Accurate 1:1 pixel rendering into a 32-bit ARGB framebuffer.
2. **Multicolor Bitmap Rendering:** Full 160×200 double-width pixel decoding from Screen RAM (`$C000`), Bitmap RAM (`$E000`), and Color RAM (`$D800`).
3. **Multicolor Character Rendering:** Dual-mode character cell decoding with Color RAM bit 3 selecting multicolor or standard high-res.
4. **Standard Commodore 16-Colour Palette:** Authentic RGB values (0: Black, 1: White, 2: Red, 3: Cyan, 4: Purple, 5: Green, 6: Blue, 7: Yellow, 8: Orange, 9: Brown, 10: Light Red, 11: Dark Grey, 12: Medium Grey, 13: Light Green, 14: Light Blue, 15: Light Grey).
5. **Character ROM & Custom Sets:** Automatic hardware selection: Character ROM mapped in VIC Banks 0 & 2 (`$1000-$1FFF`), RAM-based custom character sets in Banks 1 & 3 (`$4800` in Bank 1 for Kikstart race track).
6. **Colour RAM Interpretation:** 4-bit nibbles decoded per 8×8 block for foreground colors, background indices, and multicolor flags.
7. **Hardware Sprites (0–7):** Full 24×21 pixel matrix decoding, X/Y coordinate registers (`$D000-$D010`), and sprite data pointers at `$03F8-$03FF`.
8. **Sprite Priority & Transparency:** True active-low priority (`$D01B` bit `i`), transparent background tracking (`_bgTransparent`), and Sprite 0 > 1 > ... > 7 visual stacking.
9. **Horizontal & Vertical Scrolling:** Sub-pixel horizontal scrolling via `$D016` bits 0–2 (`XSCROLL`), vertical fine scrolling via `$D011` bits 0–2 (`YSCROLL`), and 38/40-column border clipping.
10. **Raster Interrupts & Split-Screen Effects:** Cycle-by-cycle line-by-line raster rendering (`OnRasterLine` at each PAL scanline 51..250), supporting Kikstart's dual raster interrupts at lines 49 (`$31`, Player 1) and 120 (`$78`, Player 2 / CPU).
11. **Correct VIC Memory Bank Selection:** Real-time CIA2 Port A (`$DD00` bits 0–1 inverted) bank switching (`$0000`, `$4000`, `$8000`, `$C000`).
12. **Framebuffer Updates at Appropriate Video Timing:** Frame sync at PAL line 311 / 50 Hz, delivering smooth 50 FPS double-buffered video.

---

## 2. NATIVE WINDOWS GRAPHICAL DISPLAY FEATURES

The interactive display window provides:
* **Authentic 320 × 200 Framebuffer:** Every visible dot is generated directly by the emulated VIC-IIe chip.
* **Integer Scaling Options:**
  * **1×:** 320 × 200 (Compact)
  * **2×:** 640 × 400 (Standard)
  * **3×:** 960 × 600 (Default optimal desktop display)
  * **4×:** 1280 × 800 (Large high-DPI display)
  * *Hotkeys:* Press `1`, `2`, `3`, or `4` to instantly switch display scaling with automatic client window resizing.
* **CRT Visual Effects:**
  * Toggleable via the `C` key (defaults to ON).
  * High-performance scanline beam profile with beam gap darkening and phosphor brightness retention.
  * Nearest-neighbor pixel accuracy when CRT filter is disabled.
* **Keyboard-to-Joystick Controls:**
  * **Arrow Keys / WASD:** Directional controls (Right = Accelerate, Left = Brake/Steer, Up = Lean Back/Wheelie, Down = Lean Forward).
  * **Space / Z / Left Ctrl:** Joystick 1 Fire / Jump.
  * **F1:** Select player options (1 Player vs CPU, 2 Player).
  * **F7:** Launch game / enter player name prompt.
  * **Enter / Return:** Select course set / accept typed name.
  * **1 – 8:** Course selection keys.
  * **A – Z:** Interactive character typing in the player name prompt.
* **Live Performance & Emulation Stats:**
  * Live status dynamically updated in the window title bar:
    `Commodore 128 | VIC-IIe [MC-Char] | 3x (960x600) | CRT: ON | FPS: 50.1 | 8502 Cycles: 14,203,110`

---

## 3. GRAPHICS DECODING ARCHITECTURE & VERIFIED SCREENSHOTS

### 3.1 Title Screen (Multicolor Bitmap Mode)
* **Configuration:** `$D011 = 0x3B` (`BMM=1`, `RSEL=1`, `DEN=1`), `$D016 = 0x18` (`MCM=1`, `CSEL=1`), CIA2 `$DD00 = 0xD4` (VIC Bank 3 `$C000-$FFFF`), Screen RAM at `$C000`, Bitmap RAM at `$E000-$FFFF`, Color RAM at `$D800`.
* **Verified Screenshot:** [kikstart_title.png](file:///D:/Emulation/C128/screenshots/kikstart_title.png)  
  Renders Shaun Southern's full original artwork of the motorcycle jumping over the ramp, the KIKSTART logo, background clouds, and foreground hills.

### 3.2 Race Track (Split-Screen Multicolor Character & Sprite Mode)
* **Configuration:** `$D011 = 0x1B` (`BMM=0`, `MCM=0`), `$D016 = 0xD0..0xD7` (`MCM=1`, fine horizontal scroll), CIA2 `$DD00 = 0xD6` (VIC Bank 1 `$4000-$7FFF`), Screen RAM at `$4400`, Custom Character Set at `$4800`.
* **Dual Viewport Raster Splits:**
  * Top Viewport (Player 1): Configured by raster IRQ at line 49 (`$31`), Light Blue sky (`$D021 = 0x0E`), ramp tiles, obstacle tiles, scoreboard, and Player 1 motorcycle sprite.
  * Bottom Viewport (Player 2 / CPU): Configured by raster IRQ at line 120 (`$78`), Blue sky (`$D021 = 0x06`), ramp tiles, obstacle tiles, scoreboard, and Player 2 motorcycle sprite.
* **Hardware Sprites (0–7):** Active coordinates and sprite pointers (`$47F8-$47FF`) smoothly tracked in real time.
* **Verified Screenshot:** [kikstart_race.png](file:///D:/Emulation/C128/screenshots/kikstart_race.png)  
  Displays the split-screen track with both riders, ramp obstacles, water hazards, timer `003:18`, and mid-air wheelie jump!

---

## 4. COMMAND-LINE USAGE

```powershell
# Launch interactive graphical window for live play (3x scale, CRT effects enabled)
.\releases\Commodore128.exe --game games/KIK128.D64 --gui

# Automated milestone verification with real-time scanline rendering & screenshot export
.\releases\Commodore128.exe --game games/KIK128.D64

# Run emulator verification suite
.\releases\Commodore128.exe --verify

# Boot genuine CP/M 3.0 via Z80
.\releases\Commodore128.exe --cpm

# Run Matrix digital rain demo
.\releases\Commodore128.exe --demo matrix --frames 30
```

---

## 5. REGRESSION & VERIFICATION MATRIX

| Test Suite / Capability | Target | Status |
|---|---|---|
| **C# Emulator Verification** | `--verify` (NMI, BASIC 7.0 cold boot, math, Bank 1 pointers, VDC 80-col, MATRIX.BAS) | **ALL 6 PASSED** |
| **Python Reference Tests** | `pytest tests` | **19 of 19 PASSED** |
| **CP/M 3.0 Boot** | `--cpm` (Z80 bootstrap, disk filesystem, DIR command) | **PASSED** |
| **Kikstart 128 Milestones 1–9** | `--game games/KIK128.D64` (All 9 milestones verified) | **ALL 9 PASSED** |
| **Pixel Graphics Output** | `screenshots/kikstart_title.png` & `screenshots/kikstart_race.png` | **AUTHENTIC PIXEL OUTPUT VERIFIED** |
| **Standalone GUI Window** | `Commodore128Window` (1x..4x scale, CRT, joystick, FPS stats) | **OPERATIONAL** |
