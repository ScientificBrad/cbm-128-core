# Commodore 128 Video Subsystem & Rendering Engine

---

## 1. Dual-Display Architecture

The Commodore 128 is unique among 8-bit computers in providing two completely separate, simultaneously active video display controllers:

1. **MOS 8564 / 8566 VIC-IIe (Video Interface Chip IIe):**
   - Drives the 40-column composite video and RF output port.
   - Primary display controller for Commodore BASIC 7.0 graphics commands, games, and C64 software.
   - Internal 16-color palette, hardware sprites, and raster beam interrupts.
2. **MOS 8563 VDC (Video Display Controller):**
   - Drives the 80-column RGBI digital monitor port.
   - Primary display controller for business software and Commodore CP/M Plus 3.0.
   - Completely independent 16 KB (or 64 KB) internal video RAM accessed via indirect register addressing.

---

## 2. VIC-IIe Technical Specification

### 2.1 Resolution & Addressing
- **Active Display Matrix:** 320 × 200 pixels (40 characters horizontally × 25 characters vertically, 8 × 8 pixels per character).
- **Physical Border Areas:** Left/Right borders (38 pixels each) and Top/Bottom borders (51 scanlines each) giving a full PAL/NTSC raster frame.
- **Video Bank Selection:** Configured by CIA 2 Port A (`$DD00` bits 0-1):
  - Bank 0: `$0000-$3FFF` (Default)
  - Bank 1: `$4000-$7FFF`
  - Bank 2: `$8000-$BFFF`
  - Bank 3: `$C000-$FFFF`

### 2.2 Standard Commodore 16-Color Palette
The VIC-IIe generates 16 distinct colors based on luminance and chrominance phases:

| Index | Color Name | Hex Code | sRGB Tuple |
| :---: | :--- | :---: | :--- |
| `0` | Black | `#000000` | `rgb(0, 0, 0)` |
| `1` | White | `#FFFFFF` | `rgb(255, 255, 255)` |
| `2` | Red | `#880000` | `rgb(136, 0, 0)` |
| `3` | Cyan | `#AAFFEE` | `rgb(170, 255, 238)` |
| `4` | Purple / Violet | `#CC44CC` | `rgb(204, 68, 204)` |
| `5` | Green | `#00CC55` | `rgb(0, 204, 85)` |
| `6` | Blue | `#0000AA` | `rgb(0, 0, 170)` |
| `7` | Yellow | `#EEEE77` | `rgb(238, 238, 119)` |
| `8` | Orange | `#DD8855` | `rgb(221, 136, 85)` |
| `9` | Brown | `#664400` | `rgb(102, 68, 0)` |
| `10` | Light Red | `#FF7777` | `rgb(255, 119, 119)` |
| `11` | Dark Gray | `#333333` | `rgb(51, 51, 51)` |
| `12` | Medium Gray | `#777777` | `rgb(119, 119, 119)` |
| `13` | Light Green | `#AAFF66` | `rgb(170, 255, 102)` |
| `14` | Light Blue | `#0088FF` | `rgb(0, 136, 255)` |
| `15` | Light Gray | `#BBBBBB` | `rgb(187, 187, 187)` |

---

## 3. Graphics Modes & Framebuffer Rendering

The emulator implements pixel-accurate decoding across all native VIC-IIe display modes:

### 3.1 Standard Character Mode (`BMM=0, ECM=0, MCM=0`)
- Reads 8-bit character codes from Screen Memory (default `$0400`).
- Fetches 8 × 8 1-bit glyph slices from Character ROM (`$D000`) or user RAM.
- `0` bit maps to Background Color (`$D021`).
- `1` bit maps to Color RAM (`$D800`) low nibble for the corresponding character position.

### 3.2 Multicolor Character Mode (`BMM=0, ECM=0, MCM=1`)
- Allows 4 simultaneous colors within an 8 × 8 character cell.
- Bit pairs decode as:
  - `00`: Background Color 0 (`$D021`)
  - `01`: Background Color 1 (`$D022`)
  - `10`: Background Color 2 (`$D023`)
  - `11`: Color RAM (`$D800`) color (bits 0-2).

### 3.3 High-Resolution Bitmap Mode (`BMM=1, MCM=0`)
- Full 320 × 200 individual pixel addressability.
- 8,000 bytes of bitmap data fetched from RAM.
- Each 8 × 8 pixel cell has two colors determined by the screen RAM byte:
  - Upper nibble: Foreground color (bit = 1)
  - Lower nibble: Background color (bit = 0)

### 3.4 Multicolor Bitmap Mode (`BMM=1, MCM=1`)
- Used by commercial games including **Kikstart 128** for title screens and split-screen race tracks.
- Effective resolution: 160 × 200 double-width pixels.
- 4 colors per 8 × 8 cell decoded from:
  - `00`: Background Color 0 (`$D021`)
  - `01`: Screen RAM high nibble
  - `10`: Screen RAM low nibble
  - `11`: Color RAM (`$D800`) low nibble

---

## 4. Hardware Sprites & Raster Interrupts

### 4.1 Sprite Engine
- 8 hardware sprites (`Sprite 0` to `Sprite 7`).
- Dimensions: 24 pixels wide × 21 pixels high (63 bytes per sprite shape).
- Features independent X/Y coordinate positioning (with 9-bit horizontal coordinate register `$D010`), X/Y 2x expansion registers (`$D01D`, `$D017`), multicolor sprite modes, and background/sprite priority registers (`$D01B`).
- Hardware collision detection between sprite-to-sprite (`$D01E`) and sprite-to-background (`$D01F`).

### 4.2 Raster Interrupts & Split-Screen Display
The VIC-IIe raster counter tracks the vertical scanline of the cathode-ray tube beam:
- Registers `$D011` (bit 7) and `$D012` configure the target raster interrupt line.
- When the beam reaches the designated line, an IRQ interrupt triggers on the MOS 8502 CPU.
- Games like *Kikstart 128* use this capability to create mid-frame display splits, altering background colors, scroll offsets, and character base registers between Player 1 and Player 2 viewports.

---

## 5. MOS 8563 VDC (80-Column Display)

The VDC operates as an independent co-processor:
- Communicates through two I/O ports:
  - `$D600`: Register Index and Status Register (bit 7 indicates VDC ready / not busy).
  - `$D601`: Register Data Read/Write Port.
- 37 internal registers govern horizontal display width (80 chars), vertical display height (25 lines), sync timing, cursor positioning, and block copy memory transfers.
- In CP/M 3.0 mode, the VDC generates crisp 80-column terminal output with full ANSI sequence support.
