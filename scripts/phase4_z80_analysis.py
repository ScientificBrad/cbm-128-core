#!/usr/bin/env python3
"""
Phase 4 Complete Z80 BIOS Disassembler, CFG Generator, and Function Inventory Builder.
Generates:
  - D:\Emulation\C128\asm\z80\z80bios_annotated.asm
  - D:\Emulation\C128\asm\z80\z80_cfg.json
  - D:\Emulation\C128\asm\z80\z80_cfg.md
  - D:\Emulation\C128\reports\z80_function_inventory.csv
And verifies 100% byte-for-byte identity against z80bios.bin.
"""
from pathlib import Path
import csv
import json
import struct
import sys

ROOT = Path(r"D:\Emulation\C128")
sys.path.insert(0, str(ROOT / "scripts"))
from generate_disassembly import decode_z80_inst, OPCODES_6502, format_6502_operand
from assemble_and_verify import assemble_z80_line, parse_hex_bytes

Z80_ROM = (ROOT / "z80bios.bin").read_bytes()

# =============================================================================
# 1. COMPLETE Z80 BIOS FUNCTION & REGION CATALOG ($0000-$0FFF)
# =============================================================================
# Format: (start, end_inclusive, symbol, category, entry_type, arch, description, hw_deps, confidence)
Z80_FUNCTIONS = [
    (0x0000, 0x0007, "Z80_RESET_ENTRY", "Startup & Reset", "Hardware Reset ($0000)", "Z80",
     "Power-on reset vector: sets MMU CR ($FF00)=$3E (Bank 0 RAM + I/O enabled + Z80 BIOS ROM at $0000-$0FFF) and jumps to Z80_COLD_START ($003B).",
     "MMU_CR ($FF00)", "CONFIRMED"),
    (0x0008, 0x000F, "Z80_RST08_CPM_BOOT", "CP/M Bootstrap", "RST $08 ($0008)", "Z80",
     "Warm/Cold CP/M 3.0 bootstrap entry (invoked via RST $08 at $FFEE after 8502 handoff): sets SP=$3C77, A=$3F, and jumps to CPM_BOOT_INIT ($018C).",
     "Stack ($3C77)", "CONFIRMED"),
    (0x0010, 0x0017, "Z80_RST10_MODE_DISPATCH", "BIOS Dispatch", "RST $10 ($0010)", "Z80",
     "Mode-sensitive BIOS vector dispatcher: pops return PC into HL, loads inline index byte L=(HL), and jumps to $0020 (adds +2 if $FD0F 80-col flag is non-zero).",
     "RAM ($FD0F), Table ($0100)", "CONFIRMED"),
    (0x0018, 0x001F, "Z80_RST18_DIRECT_DISPATCH", "BIOS Dispatch", "RST $18 ($0018)", "Z80",
     "Direct BIOS vector dispatcher: pops return PC into HL, loads inline index byte L=(HL), and jumps to $0028 (jumps via $0100+L).",
     "Table ($0100)", "CONFIRMED"),
    (0x0020, 0x0027, "Z80_RST20_REG_MODE_DISPATCH", "BIOS Dispatch", "RST $20 ($0020)", "Z80",
     "Register-based mode-sensitive dispatcher: checks ($FD0F); if non-zero (80-col mode), increments L twice (L += 2) and falls through to $0028.",
     "RAM ($FD0F), Table ($0100)", "CONFIRMED"),
    (0x0028, 0x002F, "Z80_RST28_TABLE_JUMP", "BIOS Dispatch", "RST $28 ($0028)", "Z80",
     "Page $01 table lookup & indirect jump: sets H=$01, loads 16-bit target from ($0100+L) into HL, and executes JP (HL).",
     "Table ($0100-$018B)", "CONFIRMED"),
    (0x0030, 0x0037, "Z80_ROM_DATE_STAMP", "Metadata / Data", "Data ($0030)", "ASCII",
     "Embedded ASCII release date stamp '05/12/85' (May 12, 1985) located at RST $30 slot.",
     "None", "CONFIRMED"),
    (0x0038, 0x003A, "Z80_RST38_IRQ_ENTRY", "Interrupts", "RST $38 / IM 1 ($0038)", "Z80",
     "Z80 Interrupt Mode 1 vector: jumps to RAM vector at $FDFD.",
     "RAM ($FDFD)", "CONFIRMED"),
    (0x003B, 0x0058, "Z80_COLD_START", "Startup & Reset", "Jump from $0005", "Z80",
     "Initializes VIC-IIe $D02F=$FF, $D030=$FC (1 MHz); writes $B0 to MMU MCR ($D505) and reads cartridge sense bits 4-5 (/GAME, /EXROM); if active low, writes $F1 to $D505 (C64 mode + 8502) and executes RST $00.",
     "VIC ($D02F, $D030), MMU_MCR ($D505)", "CONFIRMED"),
    (0x0059, 0x007B, "Z80_CHECK_CBM_KEY_AND_NMI", "Startup & Interrupts", "Fallthrough / NMI ($0066)", "Z80",
     "Configures CIA1 ($DC0F=$08, $DC0E=$08, $DC03=$00, $DC02=$FF, $DC00=$7F) and reads $DC01 bit 5 to check if C= key is held (jumps to $0054 for C64 mode if pressed). Note: $0066 (NMI vector) lands inside this sequence.",
     "CIA1 ($DC00-$DC0F), MMU_MCR ($D505)", "CONFIRMED"),
    (0x007C, 0x00B3, "Z80_INIT_MMU_AND_HANDOFF_8502", "Processor Switching", "Fallthrough from $007A", "Z80",
     "Copies 11 MMU init bytes from $0FAA-$0FB4 to $D500-$D50A, copies 8-byte 8502 trampoline ($0D1A) to $1100, copies 31-byte dual-CPU stub ($0EE5) to $FFD0-$FFEF, sets 8502 vectors ($FFFA/$FFFC/$FFFE/$FFDD) to $1100, and jumps to $FFE0 to activate 8502.",
     "MMU ($D500-$D50A), RAM ($1100, $FFD0-$FFFF)", "CONFIRMED"),
    (0x00B4, 0x00D2, "CPM_SCAN_DIR_SECTOR", "CP/M Bootstrap", "CALL $00B4", "Z80",
     "Reads a 1541/1571 directory sector via $036D and scans 32-byte entries ($0020 stride) for 'CPM+    SYS' ($00EE), invoking $02FA on match.",
     "RAM ($3C06, $FD18)", "CONFIRMED"),
    (0x00D3, 0x00ED, "CPM_MATCH_FILENAME", "CP/M Bootstrap", "CALL $00D3", "Z80",
     "Compares 12 bytes (file type $00 + 11-char filename 'CPM+    SYS') masking bit 7 ($7F); extracts extent number into $3C35.",
     "RAM ($3C06, $3C35)", "CONFIRMED"),
    (0x00EE, 0x00F9, "STR_CPM_SYS_FILENAME", "Metadata / Data", "Data ($00EE)", "ASCII",
     "11-character CP/M directory filename string 'CPM+    SYS' followed by $00.",
     "None", "CONFIRMED"),
    (0x00FA, 0x00FF, "UTIL_CMP_HL_DE", "Utility", "CALL $00FA", "Z80",
     "16-bit unsigned comparison of HL and DE (CP D on H, then CP E on L if equal).",
     "None", "CONFIRMED"),
    (0x0100, 0x0182, "BIOS_DISPATCH_TABLE", "BIOS Dispatch", "Table ($0100-$0182)", "DATA16",
     "66-entry 16-bit vector table indexed by RST $10 / RST $18 / RST $20 / RST $28 for 80-col (VDC) and 40-col (VIC) video, disk, and sound routines.",
     "None", "CONFIRMED"),
    (0x0183, 0x018B, "VDC_HELPER_JUMPS", "Video (80-Col VDC)", "Jump Table ($0183-$018B)", "Z80",
     "Three 3-byte direct jump vectors into 8563 VDC register access routines: JP $0933 ($0183), JP $0953 ($0186), JP $0945 ($0189).",
     "VDC ($D600-$D601)", "CONFIRMED"),
    (0x018C, 0x01F2, "CPM_BOOT_INIT", "CP/M Bootstrap", "Jump from $000D (RST $08)", "Z80",
     "Main CP/M 3.0 loader entry: clears Bank 0 RAM, copies 451-byte 8502 slave driver ($0D22-$0EE4) to $3000-$31C2, patches $FFEE=$C9 (RET), calls 8502 slave init via $FFE0, re-inits MMU ($D500-$D50A), clears $1000-$2FFF, initializes 40/80 screens, and prints 'BOOTING CP/M PLUS'.",
     "MMU ($FF00, $D500-$D50A), VDC ($D600), RAM ($3000, $FFD0)", "CONFIRMED"),
    (0x01F3, 0x0207, "STR_BOOTING_CPM_PLUS", "Metadata / Data", "Inline String ($01F3)", "ASCII",
     "Inline screen control bytes ($FF, $81, $0A) + 'BOOTING CP/M PLUS\\0' passed to inline print routine $0526.",
     "None", "CONFIRMED"),
    (0x0208, 0x023F, "CPM_FIND_SYSTEM_FILE", "CP/M Bootstrap", "Continuation at $0208", "Z80",
     "Sets VIC-IIe VMCSB ($D018)=$B6, calls $02D2 to check boot sector ('CBM'), searches directory tracks for 'CPM+    SYS' extents, copies 12-byte load header from $3400 to $3C29-$3C34.",
     "VIC ($D018), Disk Slave ($FFE0)", "CONFIRMED"),
    (0x0240, 0x02D1, "CPM_LOAD_FOUR_SEGMENTS", "CP/M Bootstrap", "Continuation at $0240", "Z80",
     "Prints 'DATA TABLES', 'COMMON CODE', 'BANKED CODE', and 'BIOS8502 CODE' while loading each segment of CPM+.SYS into RAM ($3500+, Common RAM, Bank 0, and 8502 Slave area), then jumps to CP/M cold boot entry in ($3C2D).",
     "RAM ($3C29-$3C34, $FFDD-$FFDE)", "CONFIRMED"),
    (0x02D2, 0x02F9, "CPM_READ_DISK_HEADER", "CP/M Bootstrap", "CALL $02D2", "Z80",
     "Reads physical sector 0 into $FE00 via $044F, verifies 'CBM' signature via $046B, and sets sector buffer parameters ($3C06/$3C07) for 1541 (256B) vs 1571/CP/M mode.",
     "RAM ($FD03-$FD18, $FE00)", "CONFIRMED"),
    (0x02FA, 0x0323, "CPM_SAVE_DIR_EXTENT", "CP/M Bootstrap", "CALL $02FA", "Z80",
     "Copies 16-byte CP/M directory allocation map from matched directory entry into $3C09 (extent 0) or $3C19 (extent 1); checks for >32KB error ($0480).",
     "RAM ($3C09-$3C28, $3C35)", "CONFIRMED"),
    (0x0324, 0x0343, "CPM_LOAD_DESCENDING_RECORDS", "CP/M Bootstrap", "CALL $0324", "Z80",
     "Reads CP/M 128-byte records in descending page order (used for COMMON CODE, BANKED CODE, BIOS8502 CODE segments) using header length/address pair.",
     "RAM ($3C00)", "CONFIRMED"),
    (0x0344, 0x036C, "CPM_READ_NEXT_128B_RECORD", "CP/M Bootstrap", "CALL $0344", "Z80",
     "Fetches the next 128-byte ($0080) CP/M record from the track/sector buffer at ($3C04), refilling the buffer from disk via $036D when ($3C04) reaches ($3C07).",
     "RAM ($3C00-$3C07)", "CONFIRMED"),
    (0x036D, 0x03E2, "CPM_READ_ALLOCATION_BLOCK", "CP/M Bootstrap", "CALL $036D", "Z80",
     "Reads a CP/M allocation block (1 KB or 2 KB) into $3400+ by converting block numbers to logical sectors ($FD16) and calling $03E3 + $044F (with multi-sector burst optimization if $FD08 != 0).",
     "RAM ($31BD, $3400, $FD03-$FD19)", "CONFIRMED"),
    (0x03E3, 0x044E, "DISK_LOGICAL_TO_TRACK_SECTOR", "Disk / GCR Mapping", "CALL $03E3 / Vec $50", "Z80",
     "Converts a logical CP/M sector number in ($FD16) into physical 1541/1571 Track ($FD03, tracks 1-35 or 36-70) and interleaved physical Sector ($FD04) using zone boundaries ($0165, $0085, $006C) and GCR interleave tables at $0FB5-$0FFF.",
     "RAM ($2400, $FD03, $FD04, $FD16), Table ($0FB5)", "CONFIRMED"),
    (0x044F, 0x046A, "DISK_EXEC_8502_READ_SECTOR", "Disk / Processor Switching", "CALL $044F", "Z80",
     "Sets retry count ($3C36)=3, command ($FD01)=1 (read sector), displays current Track/Sector on screen via $058C, calls $FFE0 to switch to 8502 slave ($3000) to perform IEC disk I/O, restores CR=$3F, and checks error status ($FD06).",
     "MMU ($FF00), Shared Stub ($FFE0), RAM ($FD01, $FD06)", "CONFIRMED"),
    (0x046B, 0x047F, "DISK_CHECK_CBM_SIGNATURE", "Disk / Validation", "CALL $046B / Vec $52", "Z80",
     "Checks if sector buffer at $FE00 starts with 'C','B','M' ($43,$42,$4D) and returns byte $FEFF in A.",
     "RAM ($FE00-$FEFF)", "CONFIRMED"),
    (0x0480, 0x0525, "CPM_BOOT_ERROR_HANDLERS", "CP/M Bootstrap / UI", "Jump from $0212/$0226/$0307/$0336/$0468", "Z80",
     "Displays boot error messages ('32K MAX CPM+.SYS SIZE', 'READ ERROR', 'NO CPM+.SYS FILE', 'BAD CPM+.SYS FILE', '- HIT RETURN TO RETRY / DEL TO ENTER C128 MODE') and polls CIA1 keyboard ($DC00/$DC01) for RETURN (RST $08 retry) or DEL (RST $00 C128 reset).",
     "CIA1 ($DC00-$DC01)", "CONFIRMED"),
    (0x0526, 0x058B, "VIDEO_PRINT_STRING_ENGINE", "Video (Dual 40/80)", "CALL $0526 / Vec $68-$6C", "Z80",
     "Prints null-terminated or '$'-terminated strings to BOTH 40-col (VIC) and 80-col (VDC) displays simultaneously during boot, handling control codes ($0A LF, $0D CR, $FF clear/home, $80+ positioning/attribute escapes).",
     "RST $18 Dispatch", "CONFIRMED"),
    (0x058C, 0x05BC, "VIDEO_SHOW_TRACK_SECTOR", "Video (Dual 40/80)", "CALL $058C", "Z80",
     "Formats and prints current physical Track ($FD03) and Sector ($FD04) numbers as 2-digit decimal at row 24 on both 40-col and 80-col displays during CP/M boot.",
     "RAM ($FD03, $FD04)", "CONFIRMED"),
    (0x05BD, 0x0683, "VDC_LOAD_CHARSET_AND_INIT", "Video (80-Col VDC)", "CALL $05BD / Vec $7E", "Z80",
     "Checks if 8563 VDC character generator RAM ($3004) is already initialized; if not, copies/clears VDC font and attribute regions and uploads custom CP/M character glyphs from $0F1A.",
     "VDC ($D600-$D601)", "CONFIRMED"),
    (0x0684, 0x070F, "VDC_CONSOLE_OUT_AND_CURSOR", "Video (80-Col VDC)", "Vec $00,$04,$08,$0C,$10,$14,$18", "Z80",
     "80-column (8563 VDC) character output ($0684), cursor positioning ($06AB), cursor up ($06C2), linefeed/scroll ($06D1), backspace ($06DD), cursor right ($06E8), carriage return ($06F1).",
     "VDC ($D600-$D601), RAM ($2411-$2415)", "CONFIRMED"),
    (0x0710, 0x0779, "VDC_ATTR_AND_COLOR_CONTROL", "Video (80-Col VDC)", "Vec $34,$38,$44", "Z80",
     "80-column (8563 VDC) attribute mask update ($0710), color translation ($071B using table at $0F0A), and color readback ($074E).",
     "VDC ($D600-$D601), RAM ($2415-$2417)", "CONFIRMED"),
    (0x077A, 0x083C, "VDC_LINE_AND_SCREEN_EDIT", "Video (80-Col VDC)", "Vec $1C,$20,$24,$28,$2C,$30", "Z80",
     "80-column (8563 VDC) clear to EOL ($077A), clear to EOS ($0780), insert char ($0791), delete char ($07CA), insert line ($07DC), delete line ($081E).",
     "VDC ($D600-$D601)", "CONFIRMED"),
    (0x083D, 0x0904, "VDC_BLOCK_FILL_AND_COPY", "Video (80-Col VDC)", "CALL $0841/$08B0 / Vec $7A,$7C", "Z80",
     "Hardware-accelerated 8563 VDC block fill ($083D/$0847 using VDC reg 24 bit 7=0 + reg 30 count) and block copy ($08AE/$08B0 using VDC reg 24 bit 7=1 + regs 32/33 source).",
     "VDC ($D600-$D601)", "CONFIRMED"),
    (0x0905, 0x096D, "VDC_LOWLEVEL_REG_IO", "Video (80-Col VDC)", "CALL $0945/$0953 / Vec $3C,$40", "Z80",
     "Low-level 8563 VDC register read/write primitives: $0945 selects VDC register A at $D600 and waits for bit 7 ready; $0953 sets VDC VRAM address (regs 18/19) to HL and selects data reg 31.",
     "VDC ($D600-$D601)", "CONFIRMED"),
    (0x096E, 0x0A47, "VIC_CONSOLE_OUT_AND_CURSOR", "Video (40-Col VIC)", "Vec $02,$06,$0A,$0E,$12,$16,$1A,$3E,$42", "Z80",
     "40-column (VIC-IIe) virtual 80-column window console driver: writes characters to Bank 0 buffer ($1400-$1B7F) and attributes to ($1C00-$237F), handles cursor movement and scrolling ($09F1), and syncs visible 40-col window to VIC screen ($2C00) and Color RAM ($1000 via LCRc).",
     "RAM ($1400-$2410), VIC/MMU ($FF01,$FF03)", "CONFIRMED"),
    (0x0A48, 0x0B61, "VIC_LINE_AND_SCREEN_EDIT", "Video (40-Col VIC)", "Vec $1E,$22,$26,$2A,$2E,$32", "Z80",
     "40-column (VIC-IIe) clear to EOL ($0A48), clear to EOS ($0A62), insert char ($0A8E), delete char ($0ABA), insert line ($0ADF), delete line ($0B2D).",
     "RAM ($1400-$237F)", "CONFIRMED"),
    (0x0B62, 0x0BCE, "VIC_ATTR_AND_COLOR_CONTROL", "Video (40-Col VIC)", "Vec $36,$3A,$46", "Z80",
     "40-column (VIC-IIe) attribute update ($0B62), border/background/foreground color control ($0B7B writing $D020/$D021), and color readback ($0BAE).",
     "VIC ($D020, $D021), RAM ($240D-$2410)", "CONFIRMED"),
    (0x0BCF, 0x0C7E, "VIC_WINDOW_REFRESH_DMA", "Video (40-Col VIC)", "CALL $0BCF/$0C0C/$0C4A / Vec $60-$66", "Z80",
     "Refreshes the physical 40x25 VIC-IIe screen at $2C00 and Color RAM at $1000 (mapped via MMU LCRc $FF03) from the 80x24 virtual screen buffer at $1400/$1C00 based on horizontal scroll offset ($2402).",
     "MMU ($FF01, $FF03), RAM ($1000, $1400, $1C00, $2C00)", "CONFIRMED"),
    (0x0C7F, 0x0CF9, "VIDEO_ASCII_TO_SCREENCODE_AND_MATH", "Video / Utility", "CALL $0C7F/$0CCE / Vec $70-$76", "Z80",
     "Converts ASCII characters in B to Commodore screen codes ($0C7F), computes 80-column row*80+col offset ($0CC2/$0CC7/$0CCE), and performs color table index validation ($0CE4).",
     "RAM ($240B, $2413, $FD0D)", "CONFIRMED"),
    (0x0CFA, 0x0D19, "SID_BEEP_SOUND", "Audio (SID)", "Vec $54 ($0CFA)", "Z80",
     "Programs MOS 8580/6581 SID Voice 1 registers ($D418 volume, $D405 AD, $D406 SR, $D401/$D400 freq, $D404 waveform) from parameter table at $FD10-$FD15 (initialized from $0FA0-$0FA5).",
     "SID ($D400-$D418), RAM ($FD10-$FD15)", "CONFIRMED"),
    (0x0D1A, 0x0D21, "BOOT_8502_TRAMPOLINE_PAYLOAD", "Processor Switching", "Copied to $1100 ($0D1A)", "8502",
     "8-byte MOS 8502 cold-boot trampoline copied to $1100 by Z80 at $008C: LDA #$00; STA $FF00; JMP ($FFFC) -> enters C128 8502 KERNAL at $E000.",
     "MMU_CR ($FF00), KERNAL ($FFFC)", "CONFIRMED"),
    (0x0D22, 0x0EE4, "SLAVE_8502_DISK_DRIVER_PAYLOAD", "Disk / Processor Switching", "Copied to $3000-$31C2 ($0D22)", "8502",
     "451-byte MOS 8502 slave I/O driver copied to Bank 0 RAM $3000-$31C2 by Z80 at $019B. Executes C128 KERNAL IEC / Fast Serial commands ('U1:11 0 tt ss', 'U0>', '#') when Z80 calls $FFE0, then switches back to Z80 via JMP $FFD0.",
     "KERNAL ($FF68-$FFD2), CIA1 ($DC0C-$DC0D), CIA2 ($DD00), MMU ($FF00)", "CONFIRMED"),
    (0x0EE5, 0x0EF4, "STUB_8502_SWITCH_TO_Z80", "Processor Switching", "Copied to $FFD0-$FFDF ($0EE5)", "8502",
     "16-byte MOS 8502 half of the shared RAM processor-switch stub ($FFD0-$FFDF): SEI; LDA #$3E; STA $FF00; LDA #$B0; STA $D505; NOP; JMP $3000; NOP.",
     "MMU_CR ($FF00), MMU_MCR ($D505)", "CONFIRMED"),
    (0x0EF5, 0x0F03, "STUB_Z80_SWITCH_TO_8502", "Processor Switching", "Copied to $FFE0-$FFEF ($0EF5)", "Z80",
     "15-byte Zilog Z80 half of the shared RAM processor-switch stub ($FFE0-$FFEF): DI; LD A,$3E; LD ($FF00),A; LD BC,$D505; LD A,$B1; OUT (C),A; NOP; RST $08 (patched to RET $C9 during CP/M boot).",
     "MMU_CR ($FF00), MMU_MCR ($D505)", "CONFIRMED"),
    (0x0F04, 0x0FA9, "BIOS_FONT_COLOR_AND_SID_TABLES", "Data Tables", "Data ($0F04-$0FA9)", "DATA",
     "Contains color translation table ($0F0A-$0F19), custom 8x8 character glyphs for VDC ($0F1A-$0F61), packed attribute/keyboard tables ($0F62-$0F9F), and SID beep init parameters ($0FA0-$0FA9).",
     "None", "CONFIRMED"),
    (0x0FAA, 0x0FB4, "MMU_INIT_REGISTER_TABLE", "Data Tables / MMU", "Data ($0FAA-$0FB4)", "DATA",
     "11-byte initial MMU register configuration table copied backwards from $0FB4..$0FAA into $D50A..$D500 ($D500=$3F, $D501=$3F, $D502=$7F, $D503=$3E, $D504=$7E, $D505=$B0, $D506=$0B, $D507=$00, $D508=$00, $D509=$01, $D50A=$00).",
     "MMU ($D500-$D50A)", "CONFIRMED"),
    (0x0FB5, 0x0FFF, "DISK_GCR_SECTOR_INTERLEAVE_TABLES", "Data Tables / Disk", "Data ($0FB5-$0FFF)", "DATA",
     "75-byte 1541/1571 GCR track zone sector interleave translation tables used by $03E3 (zones with 21, 19, 18, and 17 sectors per track).",
     "None", "CONFIRMED"),
]

# Exact sub-ranges within Z80 code that are inline data/strings or dispatch tables
INLINE_DATA_RANGES = {
    (0x0030, 0x0037): ("ASCII", "ROM Release Date Stamp '05/12/85'"),
    (0x00EE, 0x00F9): ("ASCII", "CP/M System Filename 'CPM+    SYS\\0'"),
    (0x0100, 0x0182): ("WORD_TABLE", "Z80 BIOS Page $01 Dispatch Vector Table (66 entries)"),
    (0x01F3, 0x0207): ("ASCII", "Inline Print String: Clear/Home + 'BOOTING CP/M PLUS\\0'"),
    (0x0240, 0x0242): ("ASCII", "Inline Print String: Cursor Pos ($8A,$00)\\0"),
    (0x0252, 0x025F): ("ASCII", "Inline Print String: Pos ($83,$0C) + 'DATA TABLES\\0'"),
    (0x027B, 0x0288): ("ASCII", "Inline Print String: Pos ($84,$0C) + 'COMMON CODE\\0'"),
    (0x0292, 0x029F): ("ASCII", "Inline Print String: Pos ($85,$0C) + 'BANKED CODE\\0'"),
    (0x02A9, 0x02B8): ("ASCII", "Inline Print String: Pos ($86,$0C) + 'BIOS8502 CODE\\0'"),
    (0x0483, 0x049A): ("ASCII", "Inline Print String: Pos ($93,$05) + '32K MAX CPM+.SYS SIZE\\0'"),
    (0x04AB, 0x04B7): ("ASCII", "Inline Print String: Pos ($93,$05) + 'READ ERROR\\0'"),
    (0x04BB, 0x04E9): ("ASCII", "Inline Print String: ' - HIT RETURN TO RETRY' + Pos ($94,$0F) + 'DEL TO ENTER C128 MODE\\0'"),
    (0x0502, 0x0506): ("ASCII", "Inline Print String: Pos ($93,$05) + 'NO\\0'"),
    (0x050A, 0x0518): ("ASCII", "Inline Print String: ' CPM+.SYS FILE\\0'"),
    (0x051E, 0x0523): ("ASCII", "Inline Print String: Pos ($93,$05) + 'BAD\\0'"),
    (0x0D1A, 0x0D21): ("8502_CODE_1100", "Embedded MOS 8502 Cold-Boot Trampoline (copied to $1100-$1107)"),
    (0x0D22, 0x0ECD): ("8502_CODE_3000", "Embedded MOS 8502 Slave Disk I/O Driver (copied to $3000-$31AB)"),
    (0x0ECE, 0x0EE4): ("8502_DATA_31AC", "Embedded MOS 8502 Slave Command Strings ('\\rU1:11 0 tt ss\\r', 'U0>L\\0#', 'U0')"),
    (0x0EE5, 0x0EF4): ("8502_CODE_FFD0", "Embedded MOS 8502 Shared Handoff Stub (copied to $FFD0-$FFDF)"),
    (0x0F04, 0x0FA9): ("BYTE_TABLE", "VDC Color Translation, Custom 8x8 Glyphs, and SID Init Tables"),
    (0x0FAA, 0x0FB4): ("BYTE_TABLE", "MMU Initial Register Values ($D500-$D50A)"),
    (0x0FB5, 0x0FFF): ("BYTE_TABLE", "1541/1571 GCR Sector Interleave Tables (Zones 1-4)"),
}

def build_annotated_z80_asm():
    asm_dir = ROOT / "asm" / "z80"
    asm_dir.mkdir(parents=True, exist_ok=True)

    func_by_start = {f[0]: f for f in Z80_FUNCTIONS}
    data_by_start = {rng[0]: (rng[1], kind, desc) for rng, (kind, desc) in INLINE_DATA_RANGES.items()}

    lines = [
        "; =============================================================================",
        "; COMMODORE 128 Z80 BIOS (252202-01 / 318020-03 $1000-$1FFF) ANNOTATED SOURCE",
        "; File: z80bios.bin (4,096 bytes, mapped at Z80 $0000-$0FFF in Bank 0)",
        "; SHA-256: 39c7656b326e4ad724ff4b50c995cb3b2b8ff9ed3bb2b4d277eb0ecd3cac062f",
        "; Release Date Stamp at $0030: \"05/12/85\"",
        ";",
        "; Architecture Note:",
        ";   - Z80 executable routines are decoded as Zilog Z80A instructions.",
        ";   - RST $10 (D7) and RST $18 (DF) take an inline 1-byte vector offset into",
        ";     the Page $01 dispatch table ($0100-$0182).",
        ";   - CALL $0526 takes an inline null-terminated string immediately following",
        ";     the CALL instruction and returns after the null byte.",
        ";   - Regions $0D1A-$0EF4 contain embedded MOS 8502 machine code copied by the",
        ";     Z80 into RAM ($1100, $3000, $FFD0) for dual-processor slave execution;",
        ";     their exact 8502 disassembly is provided in comments alongside .BYTE",
        ";     directives so this file remains a pure, byte-exact Z80 assembly source.",
        "; =============================================================================",
        "    .ORG $0000",
        ""
    ]

    cfg_nodes = []
    pc = 0x0000
    while pc < 0x1000:
        if pc in func_by_start:
            f = func_by_start[pc]
            lines.append("; -----------------------------------------------------------------------------")
            lines.append(f"; {f[2]} (${f[0]:04X}-${f[1]:04X}) [{f[3]} | Arch: {f[5]} | {f[8]}]")
            lines.append(f"; Entry: {f[4]}")
            lines.append(f"; Description: {f[6]}")
            lines.append(f"; Hardware Dependencies: {f[7]}")
            lines.append("; -----------------------------------------------------------------------------")
            lines.append(f"{f[2]}:")

        if pc in data_by_start:
            end_addr, kind, desc = data_by_start[pc]
            lines.append(f"; --- {desc} (${pc:04X}-${end_addr:04X}) ---")
            if kind == "WORD_TABLE":
                while pc + 1 <= end_addr:
                    val16 = struct.unpack_from("<H", Z80_ROM, pc)[0]
                    lo, hi = Z80_ROM[pc], Z80_ROM[pc+1]
                    vec_idx = pc - 0x0100
                    lines.append(f"    .BYTE ${lo:02X}, ${hi:02X}                            ; ${pc:04X}: Vec ${vec_idx:02X} -> ${val16:04X}")
                    pc += 2
                if pc <= end_addr:
                    b = Z80_ROM[pc]
                    lines.append(f"    .BYTE ${b:02X}                                ; ${pc:04X}: ${b:02X}")
                    pc += 1
            elif kind.startswith("8502_CODE_"):
                cpu_base = int(kind.split("_")[-1], 16)
                cur = pc
                while cur <= end_addr:
                    cpu_addr = cpu_base + (cur - pc)
                    op = Z80_ROM[cur]
                    if op in OPCODES_6502 and cur + OPCODES_6502[op][2] - 1 <= end_addr:
                        mnem, mode, length = OPCODES_6502[op]
                        raw_b = Z80_ROM[cur:cur+length]
                        op_str = format_6502_operand(mode, raw_b, cpu_addr)
                        m_str = f"{mnem} {op_str}".strip()
                    else:
                        length = 1
                        raw_b = Z80_ROM[cur:cur+1]
                        m_str = f".BYTE ${op:02X}"
                    b_str = ", ".join(f"${b:02X}" for b in raw_b)
                    lines.append(f"    .BYTE {b_str:<18}               ; ${cur:04X} [8502 @ ${cpu_addr:04X}]: {m_str}")
                    cur += length
                pc = end_addr + 1
            else:
                # Emit 8 bytes per line with ASCII preview
                while pc <= end_addr:
                    chunk = Z80_ROM[pc:min(pc+8, end_addr+1)]
                    b_str = ", ".join(f"${b:02X}" for b in chunk)
                    asc = "".join(chr(b) if 32 <= b <= 126 else "." for b in chunk)
                    lines.append(f"    .BYTE {b_str:<38} ; ${pc:04X} |{asc}|")
                    pc += len(chunk)
            lines.append("")
            continue

        # Otherwise decode Z80 instruction, stopping before the next data range
        next_data = min([s for s in data_by_start if s > pc] + [0x1000])
        res = decode_z80_inst(Z80_ROM, pc, next_data)
        if res is None:
            b = Z80_ROM[pc]
            lines.append(f"    .BYTE ${b:02X}                                ; ${pc:04X}: {b:02X}")
            pc += 1
            continue

        mnem, length = res
        raw_bytes = Z80_ROM[pc:pc+length]
        raw_hex = " ".join(f"{b:02X}" for b in raw_bytes)
        lines.append(f"    {mnem:<24} ; ${pc:04X}: {raw_hex}")

        # Record CFG edge if branch/call/jump/rst/ret
        inst_pc = pc
        pc += length

        # Handle inline parameter byte after RST $10 (D7) or RST $18 (DF)
        if raw_bytes[0] in (0xD7, 0xDF) and length == 1 and pc < next_data:
            param = Z80_ROM[pc]
            t40 = struct.unpack_from("<H", Z80_ROM, 0x0100 + param)[0] if 0x0100 + param + 1 < 0x1000 else 0
            t80 = struct.unpack_from("<H", Z80_ROM, 0x0100 + param + 2)[0] if 0x0100 + param + 3 < 0x1000 else 0
            if raw_bytes[0] == 0xD7:
                lines.append(f"    .BYTE ${param:02X}                                ; ${pc:04X}: {param:02X} (RST $10 Vec ${param:02X} -> 40c:${t40:04X} / 80c:${t80:04X})")
                cfg_nodes.append({"from": f"${inst_pc:04X}", "type": "RST_10_DISPATCH", "param": f"${param:02X}", "targets": [f"${t40:04X}", f"${t80:04X}"]})
            else:
                lines.append(f"    .BYTE ${param:02X}                                ; ${pc:04X}: {param:02X} (RST $18 Vec ${param:02X} -> ${t40:04X})")
                cfg_nodes.append({"from": f"${inst_pc:04X}", "type": "RST_18_DISPATCH", "param": f"${param:02X}", "targets": [f"${t40:04X}"]})
            pc += 1
        elif mnem.startswith(("JP ", "JR ", "CALL ", "DJNZ ", "RST ")):
            cfg_nodes.append({"from": f"${inst_pc:04X}", "type": mnem.split()[0], "inst": mnem})

    asm_path = asm_dir / "z80bios_annotated.asm"
    asm_text = "\n".join(lines) + "\n"
    asm_path.write_text(asm_text, encoding="utf-8")

    # Verify byte-for-byte reconstruction from z80bios_annotated.asm
    rebuilt = bytearray()
    for line in lines:
        code_part = line.split(";")[0].strip()
        if not code_part or code_part.endswith(":") or code_part.startswith(".ORG"):
            continue
        if code_part.startswith(".BYTE"):
            rebuilt.extend(parse_hex_bytes(code_part[5:].strip()))
        else:
            kind, payload = assemble_z80_line(code_part, len(rebuilt))
            if kind == "BYTES":
                rebuilt.extend(payload)

    assert bytes(rebuilt) == Z80_ROM, f"Mismatch! Rebuilt {len(rebuilt)} bytes vs {len(Z80_ROM)}"
    print(f"Verified z80bios_annotated.asm -> 4,096 bytes, 0 byte differences vs z80bios.bin!")

    # Write CFG JSON & Markdown
    cfg_json_path = asm_dir / "z80_cfg.json"
    cfg_data = {
        "rom": "z80bios.bin",
        "sha256": "39c7656b326e4ad724ff4b50c995cb3b2b8ff9ed3bb2b4d277eb0ecd3cac062f",
        "entry_points": [
            {"address": "$0000", "name": "Z80_RESET_ENTRY", "trigger": "Hardware Power-On / Reset"},
            {"address": "$0008", "name": "Z80_RST08_CPM_BOOT", "trigger": "RST $08 from $FFEE Shared Stub"},
            {"address": "$0010", "name": "Z80_RST10_MODE_DISPATCH", "trigger": "RST $10 + inline byte (40/80 mode dispatch)"},
            {"address": "$0018", "name": "Z80_RST18_DIRECT_DISPATCH", "trigger": "RST $18 + inline byte (direct Page $01 dispatch)"},
            {"address": "$0020", "name": "Z80_RST20_REG_MODE_DISPATCH", "trigger": "RST $20 (register L mode dispatch)"},
            {"address": "$0028", "name": "Z80_RST28_TABLE_JUMP", "trigger": "RST $28 (register L Page $01 jump)"},
            {"address": "$0038", "name": "Z80_RST38_IRQ_ENTRY", "trigger": "Z80 IM 1 Maskable Interrupt -> JP $FDFD"},
            {"address": "$0066", "name": "Z80_NMI_ENTRY", "trigger": "Z80 Non-Maskable Interrupt"},
            {"address": "$FFE0", "name": "STUB_Z80_SWITCH_TO_8502", "trigger": "Shared RAM Processor Switch Stub (copied from $0EF5)"},
        ],
        "dispatch_table_0100": [
            {
                "offset": f"${off - 0x0100:02X}",
                "rom_address": f"${off:04X}",
                "target": f"${struct.unpack_from('<H', Z80_ROM, off)[0]:04X}"
            }
            for off in range(0x0100, 0x0182, 2)
        ],
        "control_flow_edges": cfg_nodes,
    }
    cfg_json_path.write_text(json.dumps(cfg_data, indent=2), encoding="utf-8")

    # Write CSV Function Inventory
    csv_path = ROOT / "reports" / "z80_function_inventory.csv"
    with csv_path.open("w", newline="", encoding="utf-8") as f:
        writer = csv.writer(f)
        writer.writerow([
            "start_addr", "end_addr", "size_bytes", "symbol", "category",
            "entry_type", "architecture", "hardware_dependencies", "confidence", "description"
        ])
        for start, end, sym, cat, entry, arch, desc, hw, conf in Z80_FUNCTIONS:
            writer.writerow([
                f"${start:04X}", f"${end:04X}", end - start + 1, sym, cat,
                entry, arch, hw, conf, desc
            ])
    print(f"Wrote {len(Z80_FUNCTIONS)} entries to {csv_path}")

if __name__ == "__main__":
    build_annotated_z80_asm()
