================================================================================
COMMODORE 128 DUAL-CPU EMULATOR (v0.1.0)
Commodore 128 Reconstruction & Architecture Verification
================================================================================

An independent, clean-room reconstruction and architectural emulation of the
Commodore 128 personal computer (1985).

Features:
- Dual-CPU execution: MOS 8502 (1/2 MHz) and Zilog Z80A (4 MHz)
- MMU 8722 128 KB memory banking and common RAM windows
- Dual display controllers: VIC-IIe (40-column) and MOS 8563 VDC (80-column)
- Commodore 1571 fast floppy drive support (D64 / D71)
- Genuine Commodore BASIC 7.0 (122,365 bytes free)
- Genuine CP/M Plus 3.0 execution
- Commercial game compatibility (Kikstart 128)

--------------------------------------------------------------------------------
1. REQUIRED ROM IMAGES (NOT INCLUDED)
--------------------------------------------------------------------------------
In accordance with copyright law, proprietary Commodore firmware binaries are
not bundled with this release. To run the emulator, place genuine dumps of the
following ROM files into the same directory as Commodore128.exe or in a 'roms/'
subfolder:

- basic-4000.318018-02.bin   (16,384 bytes, Bank 0: $4000-$7FFF)
- basic-8000.318019-02.bin   (16,384 bytes, Bank 0: $8000-$BFFF)
- kernal.318020-03.bin       (16,384 bytes, Bank 0: $C000-$FFFF)
- characters.390059-01.bin   (8,192 bytes,  Bank 0/1: $D000-$DFFF)
- z80bios.bin                (4,096 bytes,  Extracted from KERNAL $1000-$1FFF)

--------------------------------------------------------------------------------
2. QUICK START
--------------------------------------------------------------------------------
- Interactive BASIC 7.0 session:
    Commodore128.exe -i

- Run the Matrix Digital Rain demonstration:
    Commodore128.exe --load MATRIX.BAS --demo matrix

- Boot CP/M Plus 3.0 from floppy disk (Drive 8):
    Commodore128.exe --disk cpm_1985.d64 --cpm

- Load and run a commercial game:
    Commodore128.exe --disk KIK128.D64

--------------------------------------------------------------------------------
3. LICENSE & LEGAL
--------------------------------------------------------------------------------
Software released under the MIT License.
(c) 2026 ScientificBrad Research & Digital Preservation.
Commodore, C128, C64, VIC-II, and SID are trademarks of their respective owners.
See LICENSE and THIRD_PARTY_NOTICES.md for complete details.
================================================================================
