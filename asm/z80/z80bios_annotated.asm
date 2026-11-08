; =============================================================================
; COMMODORE 128 Z80 BIOS (252202-01 / 318020-03 $1000-$1FFF) ANNOTATED SOURCE
; File: z80bios.bin (4,096 bytes, mapped at Z80 $0000-$0FFF in Bank 0)
; SHA-256: 39c7656b326e4ad724ff4b50c995cb3b2b8ff9ed3bb2b4d277eb0ecd3cac062f
; Release Date Stamp at $0030: "05/12/85"
;
; Architecture Note:
;   - Z80 executable routines are decoded as Zilog Z80A instructions.
;   - RST $10 (D7) and RST $18 (DF) take an inline 1-byte vector offset into
;     the Page $01 dispatch table ($0100-$0182).
;   - CALL $0526 takes an inline null-terminated string immediately following
;     the CALL instruction and returns after the null byte.
;   - Regions $0D1A-$0EF4 contain embedded MOS 8502 machine code copied by the
;     Z80 into RAM ($1100, $3000, $FFD0) for dual-processor slave execution;
;     their exact 8502 disassembly is provided in comments alongside .BYTE
;     directives so this file remains a pure, byte-exact Z80 assembly source.
; =============================================================================
    .ORG $0000

; -----------------------------------------------------------------------------
; Z80_RESET_ENTRY ($0000-$0007) [Startup & Reset | Arch: Z80 | CONFIRMED]
; Entry: Hardware Reset ($0000)
; Description: Power-on reset vector: sets MMU CR ($FF00)=$3E (Bank 0 RAM + I/O enabled + Z80 BIOS ROM at $0000-$0FFF) and jumps to Z80_COLD_START ($003B).
; Hardware Dependencies: MMU_CR ($FF00)
; -----------------------------------------------------------------------------
Z80_RESET_ENTRY:
    LD A,$3E                 ; $0000: 3E 3E
    LD ($FF00),A             ; $0002: 32 00 FF
    JP $003B                 ; $0005: C3 3B 00
; -----------------------------------------------------------------------------
; Z80_RST08_CPM_BOOT ($0008-$000F) [CP/M Bootstrap | Arch: Z80 | CONFIRMED]
; Entry: RST $08 ($0008)
; Description: Warm/Cold CP/M 3.0 bootstrap entry (invoked via RST $08 at $FFEE after 8502 handoff): sets SP=$3C77, A=$3F, and jumps to CPM_BOOT_INIT ($018C).
; Hardware Dependencies: Stack ($3C77)
; -----------------------------------------------------------------------------
Z80_RST08_CPM_BOOT:
    LD SP,$3C77              ; $0008: 31 77 3C
    LD A,$3F                 ; $000B: 3E 3F
    JP $018C                 ; $000D: C3 8C 01
; -----------------------------------------------------------------------------
; Z80_RST10_MODE_DISPATCH ($0010-$0017) [BIOS Dispatch | Arch: Z80 | CONFIRMED]
; Entry: RST $10 ($0010)
; Description: Mode-sensitive BIOS vector dispatcher: pops return PC into HL, loads inline index byte L=(HL), and jumps to $0020 (adds +2 if $FD0F 80-col flag is non-zero).
; Hardware Dependencies: RAM ($FD0F), Table ($0100)
; -----------------------------------------------------------------------------
Z80_RST10_MODE_DISPATCH:
    POP HL                   ; $0010: E1
    LD L,(HL)                ; $0011: 6E
    JP $0020                 ; $0012: C3 20 00
    NOP                      ; $0015: 00
    NOP                      ; $0016: 00
    NOP                      ; $0017: 00
; -----------------------------------------------------------------------------
; Z80_RST18_DIRECT_DISPATCH ($0018-$001F) [BIOS Dispatch | Arch: Z80 | CONFIRMED]
; Entry: RST $18 ($0018)
; Description: Direct BIOS vector dispatcher: pops return PC into HL, loads inline index byte L=(HL), and jumps to $0028 (jumps via $0100+L).
; Hardware Dependencies: Table ($0100)
; -----------------------------------------------------------------------------
Z80_RST18_DIRECT_DISPATCH:
    POP HL                   ; $0018: E1
    LD L,(HL)                ; $0019: 6E
    JP $0028                 ; $001A: C3 28 00
    NOP                      ; $001D: 00
    NOP                      ; $001E: 00
    NOP                      ; $001F: 00
; -----------------------------------------------------------------------------
; Z80_RST20_REG_MODE_DISPATCH ($0020-$0027) [BIOS Dispatch | Arch: Z80 | CONFIRMED]
; Entry: RST $20 ($0020)
; Description: Register-based mode-sensitive dispatcher: checks ($FD0F); if non-zero (80-col mode), increments L twice (L += 2) and falls through to $0028.
; Hardware Dependencies: RAM ($FD0F), Table ($0100)
; -----------------------------------------------------------------------------
Z80_RST20_REG_MODE_DISPATCH:
    LD A,($FD0F)             ; $0020: 3A 0F FD
    AND A                    ; $0023: A7
    JR Z,$0028               ; $0024: 28 02
    INC L                    ; $0026: 2C
    INC L                    ; $0027: 2C
; -----------------------------------------------------------------------------
; Z80_RST28_TABLE_JUMP ($0028-$002F) [BIOS Dispatch | Arch: Z80 | CONFIRMED]
; Entry: RST $28 ($0028)
; Description: Page $01 table lookup & indirect jump: sets H=$01, loads 16-bit target from ($0100+L) into HL, and executes JP (HL).
; Hardware Dependencies: Table ($0100-$018B)
; -----------------------------------------------------------------------------
Z80_RST28_TABLE_JUMP:
    LD H,$01                 ; $0028: 26 01
    LD A,(HL)                ; $002A: 7E
    INC HL                   ; $002B: 23
    LD H,(HL)                ; $002C: 66
    LD L,A                   ; $002D: 6F
    JP (HL)                  ; $002E: E9
    NOP                      ; $002F: 00
; -----------------------------------------------------------------------------
; Z80_ROM_DATE_STAMP ($0030-$0037) [Metadata / Data | Arch: ASCII | CONFIRMED]
; Entry: Data ($0030)
; Description: Embedded ASCII release date stamp '05/12/85' (May 12, 1985) located at RST $30 slot.
; Hardware Dependencies: None
; -----------------------------------------------------------------------------
Z80_ROM_DATE_STAMP:
; --- ROM Release Date Stamp '05/12/85' ($0030-$0037) ---
    .BYTE $30, $35, $2F, $31, $32, $2F, $38, $35 ; $0030 |05/12/85|

; -----------------------------------------------------------------------------
; Z80_RST38_IRQ_ENTRY ($0038-$003A) [Interrupts | Arch: Z80 | CONFIRMED]
; Entry: RST $38 / IM 1 ($0038)
; Description: Z80 Interrupt Mode 1 vector: jumps to RAM vector at $FDFD.
; Hardware Dependencies: RAM ($FDFD)
; -----------------------------------------------------------------------------
Z80_RST38_IRQ_ENTRY:
    JP $FDFD                 ; $0038: C3 FD FD
; -----------------------------------------------------------------------------
; Z80_COLD_START ($003B-$0058) [Startup & Reset | Arch: Z80 | CONFIRMED]
; Entry: Jump from $0005
; Description: Initializes VIC-IIe $D02F=$FF, $D030=$FC (1 MHz); writes $B0 to MMU MCR ($D505) and reads cartridge sense bits 4-5 (/GAME, /EXROM); if active low, writes $F1 to $D505 (C64 mode + 8502) and executes RST $00.
; Hardware Dependencies: VIC ($D02F, $D030), MMU_MCR ($D505)
; -----------------------------------------------------------------------------
Z80_COLD_START:
    LD BC,$D02F              ; $003B: 01 2F D0
    LD DE,$FFFC              ; $003E: 11 FC FF
    OUT (C),D                ; $0041: ED 51
    INC BC                   ; $0043: 03
    OUT (C),E                ; $0044: ED 59
    LD BC,$D505              ; $0046: 01 05 D5
    LD A,$B0                 ; $0049: 3E B0
    OUT (C),A                ; $004B: ED 79
    IN A,(C)                 ; $004D: ED 78
    CPL                      ; $004F: 2F
    AND $30                  ; $0050: E6 30
    JR Z,$0059               ; $0052: 28 05
    LD A,$F1                 ; $0054: 3E F1
    OUT (C),A                ; $0056: ED 79
    RST $00                  ; $0058: C7
; -----------------------------------------------------------------------------
; Z80_CHECK_CBM_KEY_AND_NMI ($0059-$007B) [Startup & Interrupts | Arch: Z80 | CONFIRMED]
; Entry: Fallthrough / NMI ($0066)
; Description: Configures CIA1 ($DC0F=$08, $DC0E=$08, $DC03=$00, $DC02=$FF, $DC00=$7F) and reads $DC01 bit 5 to check if C= key is held (jumps to $0054 for C64 mode if pressed). Note: $0066 (NMI vector) lands inside this sequence.
; Hardware Dependencies: CIA1 ($DC00-$DC0F), MMU_MCR ($D505)
; -----------------------------------------------------------------------------
Z80_CHECK_CBM_KEY_AND_NMI:
    LD BC,$DC0F              ; $0059: 01 0F DC
    LD A,$08                 ; $005C: 3E 08
    OUT (C),A                ; $005E: ED 79
    DEC C                    ; $0060: 0D
    OUT (C),A                ; $0061: ED 79
    LD C,$03                 ; $0063: 0E 03
    XOR A                    ; $0065: AF
    OUT (C),A                ; $0066: ED 79
    DEC C                    ; $0068: 0D
    DEC A                    ; $0069: 3D
    OUT (C),A                ; $006A: ED 79
    DEC C                    ; $006C: 0D
    DEC C                    ; $006D: 0D
    LD A,$7F                 ; $006E: 3E 7F
    OUT (C),A                ; $0070: ED 79
    INC BC                   ; $0072: 03
    IN A,(C)                 ; $0073: ED 78
    AND $20                  ; $0075: E6 20
    LD BC,$D505              ; $0077: 01 05 D5
    JR Z,$0054               ; $007A: 28 D8
; -----------------------------------------------------------------------------
; Z80_INIT_MMU_AND_HANDOFF_8502 ($007C-$00B3) [Processor Switching | Arch: Z80 | CONFIRMED]
; Entry: Fallthrough from $007A
; Description: Copies 11 MMU init bytes from $0FAA-$0FB4 to $D500-$D50A, copies 8-byte 8502 trampoline ($0D1A) to $1100, copies 31-byte dual-CPU stub ($0EE5) to $FFD0-$FFEF, sets 8502 vectors ($FFFA/$FFFC/$FFFE/$FFDD) to $1100, and jumps to $FFE0 to activate 8502.
; Hardware Dependencies: MMU ($D500-$D50A), RAM ($1100, $FFD0-$FFFF)
; -----------------------------------------------------------------------------
Z80_INIT_MMU_AND_HANDOFF_8502:
    LD HL,$0FB4              ; $007C: 21 B4 0F
    LD BC,$D50A              ; $007F: 01 0A D5
    LD D,$0B                 ; $0082: 16 0B
    LD A,(HL)                ; $0084: 7E
    OUT (C),A                ; $0085: ED 79
    DEC HL                   ; $0087: 2B
    DEC C                    ; $0088: 0D
    DEC D                    ; $0089: 15
    JR NZ,$0084              ; $008A: 20 F8
    LD HL,$0D1A              ; $008C: 21 1A 0D
    LD DE,$1100              ; $008F: 11 00 11
    LD BC,$0008              ; $0092: 01 08 00
    LDIR                     ; $0095: ED B0
    LD HL,$0EE5              ; $0097: 21 E5 0E
    LD DE,$FFD0              ; $009A: 11 D0 FF
    LD BC,$001F              ; $009D: 01 1F 00
    LDIR                     ; $00A0: ED B0
    LD HL,$1100              ; $00A2: 21 00 11
    LD ($FFFA),HL            ; $00A5: 22 FA FF
    LD ($FFFC),HL            ; $00A8: 22 FC FF
    LD ($FFFE),HL            ; $00AB: 22 FE FF
    LD ($FFDD),HL            ; $00AE: 22 DD FF
    JP $FFE0                 ; $00B1: C3 E0 FF
; -----------------------------------------------------------------------------
; CPM_SCAN_DIR_SECTOR ($00B4-$00D2) [CP/M Bootstrap | Arch: Z80 | CONFIRMED]
; Entry: CALL $00B4
; Description: Reads a 1541/1571 directory sector via $036D and scans 32-byte entries ($0020 stride) for 'CPM+    SYS' ($00EE), invoking $02FA on match.
; Hardware Dependencies: RAM ($3C06, $FD18)
; -----------------------------------------------------------------------------
CPM_SCAN_DIR_SECTOR:
    CALL $036D               ; $00B4: CD 6D 03
    LD A,($3C06)             ; $00B7: 3A 06 3C
    LD ($FD18),HL            ; $00BA: 22 18 FD
    LD DE,$00ED              ; $00BD: 11 ED 00
    PUSH AF                  ; $00C0: F5
    CALL $00D3               ; $00C1: CD D3 00
    CALL Z,$02FA             ; $00C4: CC FA 02
    POP AF                   ; $00C7: F1
    LD HL,($FD18)            ; $00C8: 2A 18 FD
    LD DE,$0020              ; $00CB: 11 20 00
    ADD HL,DE                ; $00CE: 19
    DEC A                    ; $00CF: 3D
    JR NZ,$00BA              ; $00D0: 20 E8
    RET                      ; $00D2: C9
; -----------------------------------------------------------------------------
; CPM_MATCH_FILENAME ($00D3-$00ED) [CP/M Bootstrap | Arch: Z80 | CONFIRMED]
; Entry: CALL $00D3
; Description: Compares 12 bytes (file type $00 + 11-char filename 'CPM+    SYS') masking bit 7 ($7F); extracts extent number into $3C35.
; Hardware Dependencies: RAM ($3C06, $3C35)
; -----------------------------------------------------------------------------
CPM_MATCH_FILENAME:
    LD B,$0C                 ; $00D3: 06 0C
    EX DE,HL                 ; $00D5: EB
    LD A,(DE)                ; $00D6: 1A
    AND $7F                  ; $00D7: E6 7F
    CP (HL)                  ; $00D9: BE
    RET NZ                   ; $00DA: C0
    INC HL                   ; $00DB: 23
    INC DE                   ; $00DC: 13
    DJNZ $00D6               ; $00DD: 10 F7
    LD A,($3C06)             ; $00DF: 3A 06 3C
    CP $40                   ; $00E2: FE 40
    LD A,(DE)                ; $00E4: 1A
    JR NZ,$00E8              ; $00E5: 20 01
    RRA                      ; $00E7: 1F
    LD ($3C35),A             ; $00E8: 32 35 3C
    XOR A                    ; $00EB: AF
    RET                      ; $00EC: C9
    NOP                      ; $00ED: 00
; -----------------------------------------------------------------------------
; STR_CPM_SYS_FILENAME ($00EE-$00F9) [Metadata / Data | Arch: ASCII | CONFIRMED]
; Entry: Data ($00EE)
; Description: 11-character CP/M directory filename string 'CPM+    SYS' followed by $00.
; Hardware Dependencies: None
; -----------------------------------------------------------------------------
STR_CPM_SYS_FILENAME:
; --- CP/M System Filename 'CPM+    SYS\0' ($00EE-$00F9) ---
    .BYTE $43, $50, $4D, $2B, $20, $20, $20, $20 ; $00EE |CPM+    |
    .BYTE $53, $59, $53, $00                     ; $00F6 |SYS.|

; -----------------------------------------------------------------------------
; UTIL_CMP_HL_DE ($00FA-$00FF) [Utility | Arch: Z80 | CONFIRMED]
; Entry: CALL $00FA
; Description: 16-bit unsigned comparison of HL and DE (CP D on H, then CP E on L if equal).
; Hardware Dependencies: None
; -----------------------------------------------------------------------------
UTIL_CMP_HL_DE:
    LD A,H                   ; $00FA: 7C
    CP D                     ; $00FB: BA
    RET NZ                   ; $00FC: C0
    LD A,L                   ; $00FD: 7D
    CP E                     ; $00FE: BB
    RET                      ; $00FF: C9
; -----------------------------------------------------------------------------
; BIOS_DISPATCH_TABLE ($0100-$0182) [BIOS Dispatch | Arch: DATA16 | CONFIRMED]
; Entry: Table ($0100-$0182)
; Description: 66-entry 16-bit vector table indexed by RST $10 / RST $18 / RST $20 / RST $28 for 80-col (VDC) and 40-col (VIC) video, disk, and sound routines.
; Hardware Dependencies: None
; -----------------------------------------------------------------------------
BIOS_DISPATCH_TABLE:
; --- Z80 BIOS Page $01 Dispatch Vector Table (66 entries) ($0100-$0182) ---
    .BYTE $84, $06                            ; $0100: Vec $00 -> $0684
    .BYTE $6E, $09                            ; $0102: Vec $02 -> $096E
    .BYTE $AB, $06                            ; $0104: Vec $04 -> $06AB
    .BYTE $BC, $09                            ; $0106: Vec $06 -> $09BC
    .BYTE $C2, $06                            ; $0108: Vec $08 -> $06C2
    .BYTE $DD, $09                            ; $010A: Vec $0A -> $09DD
    .BYTE $D1, $06                            ; $010C: Vec $0C -> $06D1
    .BYTE $F1, $09                            ; $010E: Vec $0E -> $09F1
    .BYTE $DD, $06                            ; $0110: Vec $10 -> $06DD
    .BYTE $31, $0A                            ; $0112: Vec $12 -> $0A31
    .BYTE $E8, $06                            ; $0114: Vec $14 -> $06E8
    .BYTE $3C, $0A                            ; $0116: Vec $16 -> $0A3C
    .BYTE $F1, $06                            ; $0118: Vec $18 -> $06F1
    .BYTE $45, $0A                            ; $011A: Vec $1A -> $0A45
    .BYTE $7A, $07                            ; $011C: Vec $1C -> $077A
    .BYTE $48, $0A                            ; $011E: Vec $1E -> $0A48
    .BYTE $80, $07                            ; $0120: Vec $20 -> $0780
    .BYTE $62, $0A                            ; $0122: Vec $22 -> $0A62
    .BYTE $91, $07                            ; $0124: Vec $24 -> $0791
    .BYTE $8E, $0A                            ; $0126: Vec $26 -> $0A8E
    .BYTE $CA, $07                            ; $0128: Vec $28 -> $07CA
    .BYTE $BA, $0A                            ; $012A: Vec $2A -> $0ABA
    .BYTE $DC, $07                            ; $012C: Vec $2C -> $07DC
    .BYTE $DF, $0A                            ; $012E: Vec $2E -> $0ADF
    .BYTE $1E, $08                            ; $0130: Vec $30 -> $081E
    .BYTE $2D, $0B                            ; $0132: Vec $32 -> $0B2D
    .BYTE $1B, $07                            ; $0134: Vec $34 -> $071B
    .BYTE $7B, $0B                            ; $0136: Vec $36 -> $0B7B
    .BYTE $10, $07                            ; $0138: Vec $38 -> $0710
    .BYTE $62, $0B                            ; $013A: Vec $3A -> $0B62
    .BYTE $1C, $09                            ; $013C: Vec $3C -> $091C
    .BYTE $95, $09                            ; $013E: Vec $3E -> $0995
    .BYTE $27, $09                            ; $0140: Vec $40 -> $0927
    .BYTE $A2, $09                            ; $0142: Vec $42 -> $09A2
    .BYTE $4E, $07                            ; $0144: Vec $44 -> $074E
    .BYTE $AE, $0B                            ; $0146: Vec $46 -> $0BAE
    .BYTE $EB, $00                            ; $0148: Vec $48 -> $00EB
    .BYTE $EB, $00                            ; $014A: Vec $4A -> $00EB
    .BYTE $EB, $00                            ; $014C: Vec $4C -> $00EB
    .BYTE $EB, $00                            ; $014E: Vec $4E -> $00EB
    .BYTE $E3, $03                            ; $0150: Vec $50 -> $03E3
    .BYTE $6B, $04                            ; $0152: Vec $52 -> $046B
    .BYTE $FA, $0C                            ; $0154: Vec $54 -> $0CFA
    .BYTE $EB, $00                            ; $0156: Vec $56 -> $00EB
    .BYTE $EB, $00                            ; $0158: Vec $58 -> $00EB
    .BYTE $EB, $00                            ; $015A: Vec $5A -> $00EB
    .BYTE $EB, $00                            ; $015C: Vec $5C -> $00EB
    .BYTE $EB, $00                            ; $015E: Vec $5E -> $00EB
    .BYTE $3C, $0C                            ; $0160: Vec $60 -> $0C3C
    .BYTE $4A, $0C                            ; $0162: Vec $62 -> $0C4A
    .BYTE $CF, $0B                            ; $0164: Vec $64 -> $0BCF
    .BYTE $0C, $0C                            ; $0166: Vec $66 -> $0C0C
    .BYTE $26, $05                            ; $0168: Vec $68 -> $0526
    .BYTE $32, $05                            ; $016A: Vec $6A -> $0532
    .BYTE $2C, $05                            ; $016C: Vec $6C -> $052C
    .BYTE $EB, $00                            ; $016E: Vec $6E -> $00EB
    .BYTE $7F, $0C                            ; $0170: Vec $70 -> $0C7F
    .BYTE $C2, $0C                            ; $0172: Vec $72 -> $0CC2
    .BYTE $C7, $0C                            ; $0174: Vec $74 -> $0CC7
    .BYTE $E4, $0C                            ; $0176: Vec $76 -> $0CE4
    .BYTE $EB, $00                            ; $0178: Vec $78 -> $00EB
    .BYTE $3D, $08                            ; $017A: Vec $7A -> $083D
    .BYTE $AE, $08                            ; $017C: Vec $7C -> $08AE
    .BYTE $60, $06                            ; $017E: Vec $7E -> $0660
    .BYTE $C3, $0A                            ; $0180: Vec $80 -> $0AC3
    .BYTE $09                                ; $0182: $09

; -----------------------------------------------------------------------------
; VDC_HELPER_JUMPS ($0183-$018B) [Video (80-Col VDC) | Arch: Z80 | CONFIRMED]
; Entry: Jump Table ($0183-$018B)
; Description: Three 3-byte direct jump vectors into 8563 VDC register access routines: JP $0933 ($0183), JP $0953 ($0186), JP $0945 ($0189).
; Hardware Dependencies: VDC ($D600-$D601)
; -----------------------------------------------------------------------------
VDC_HELPER_JUMPS:
    JP $0933                 ; $0183: C3 33 09
    JP $0953                 ; $0186: C3 53 09
    JP $0945                 ; $0189: C3 45 09
; -----------------------------------------------------------------------------
; CPM_BOOT_INIT ($018C-$01F2) [CP/M Bootstrap | Arch: Z80 | CONFIRMED]
; Entry: Jump from $000D (RST $08)
; Description: Main CP/M 3.0 loader entry: clears Bank 0 RAM, copies 451-byte 8502 slave driver ($0D22-$0EE4) to $3000-$31C2, patches $FFEE=$C9 (RET), calls 8502 slave init via $FFE0, re-inits MMU ($D500-$D50A), clears $1000-$2FFF, initializes 40/80 screens, and prints 'BOOTING CP/M PLUS'.
; Hardware Dependencies: MMU ($FF00, $D500-$D50A), VDC ($D600), RAM ($3000, $FFD0)
; -----------------------------------------------------------------------------
CPM_BOOT_INIT:
    LD ($FF00),A             ; $018C: 32 00 FF
    LD HL,$3000              ; $018F: 21 00 30
    LD DE,$3001              ; $0192: 11 01 30
    LD BC,$CEFF              ; $0195: 01 FF CE
    LD (HL),L                ; $0198: 75
    LDIR                     ; $0199: ED B0
    LD HL,$0D22              ; $019B: 21 22 0D
    LD DE,$3000              ; $019E: 11 00 30
    LD BC,$01C3              ; $01A1: 01 C3 01
    LDIR                     ; $01A4: ED B0
    LD HL,$0EE5              ; $01A6: 21 E5 0E
    LD DE,$FFD0              ; $01A9: 11 D0 FF
    LD BC,$001F              ; $01AC: 01 1F 00
    LDIR                     ; $01AF: ED B0
    LD A,$C9                 ; $01B1: 3E C9
    LD ($FFEE),A             ; $01B3: 32 EE FF
    CALL $FFE0               ; $01B6: CD E0 FF
    LD HL,$0FB4              ; $01B9: 21 B4 0F
    LD BC,$D50A              ; $01BC: 01 0A D5
    LD D,$0B                 ; $01BF: 16 0B
    LD A,(HL)                ; $01C1: 7E
    OUT (C),A                ; $01C2: ED 79
    DEC HL                   ; $01C4: 2B
    DEC C                    ; $01C5: 0D
    DEC D                    ; $01C6: 15
    JR NZ,$01C1              ; $01C7: 20 F8
    LD HL,$1000              ; $01C9: 21 00 10
    LD DE,$1001              ; $01CC: 11 01 10
    LD BC,$1FFF              ; $01CF: 01 FF 1F
    LD (HL),L                ; $01D2: 75
    LDIR                     ; $01D3: ED B0
    LD A,$1A                 ; $01D5: 3E 1A
    CALL $0945               ; $01D7: CD 45 09
    LD A,$90                 ; $01DA: 3E 90
    OUT (C),A                ; $01DC: ED 79
    LD A,$83                 ; $01DE: 3E 83
    LD ($2415),A             ; $01E0: 32 15 24
    LD A,$0E                 ; $01E3: 3E 0E
    LD ($240D),A             ; $01E5: 32 0D 24
    CALL $05BD               ; $01E8: CD BD 05
    LD A,$19                 ; $01EB: 3E 19
    LD ($2408),A             ; $01ED: 32 08 24
    CALL $0526               ; $01F0: CD 26 05
; -----------------------------------------------------------------------------
; STR_BOOTING_CPM_PLUS ($01F3-$0207) [Metadata / Data | Arch: ASCII | CONFIRMED]
; Entry: Inline String ($01F3)
; Description: Inline screen control bytes ($FF, $81, $0A) + 'BOOTING CP/M PLUS\0' passed to inline print routine $0526.
; Hardware Dependencies: None
; -----------------------------------------------------------------------------
STR_BOOTING_CPM_PLUS:
; --- Inline Print String: Clear/Home + 'BOOTING CP/M PLUS\0' ($01F3-$0207) ---
    .BYTE $FF, $81, $0A, $42, $4F, $4F, $54, $49 ; $01F3 |...BOOTI|
    .BYTE $4E, $47, $20, $43, $50, $2F, $4D, $20 ; $01FB |NG CP/M |
    .BYTE $50, $4C, $55, $53, $00                ; $0203 |PLUS.|

; -----------------------------------------------------------------------------
; CPM_FIND_SYSTEM_FILE ($0208-$023F) [CP/M Bootstrap | Arch: Z80 | CONFIRMED]
; Entry: Continuation at $0208
; Description: Sets VIC-IIe VMCSB ($D018)=$B6, calls $02D2 to check boot sector ('CBM'), searches directory tracks for 'CPM+    SYS' extents, copies 12-byte load header from $3400 to $3C29-$3C34.
; Hardware Dependencies: VIC ($D018), Disk Slave ($FFE0)
; -----------------------------------------------------------------------------
CPM_FIND_SYSTEM_FILE:
    LD BC,$D018              ; $0208: 01 18 D0
    LD A,$B6                 ; $020B: 3E B6
    OUT (C),A                ; $020D: ED 79
    CALL $02D2               ; $020F: CD D2 02
    JP NZ,$04FF              ; $0212: C2 FF 04
    LD HL,$0FB2              ; $0215: 21 B2 0F
    LD ($3C02),HL            ; $0218: 22 02 3C
    CALL $00B4               ; $021B: CD B4 00
    CALL $00B4               ; $021E: CD B4 00
    LD HL,($3C09)            ; $0221: 2A 09 3C
    LD A,H                   ; $0224: 7C
    OR L                     ; $0225: B5
    JP Z,$04FF               ; $0226: CA FF 04
    LD HL,$3C09              ; $0229: 21 09 3C
    LD ($3C02),HL            ; $022C: 22 02 3C
    CALL $036D               ; $022F: CD 6D 03
    LD HL,$3400              ; $0232: 21 00 34
    LD DE,$3C29              ; $0235: 11 29 3C
    LD BC,$000C              ; $0238: 01 0C 00
    LDIR                     ; $023B: ED B0
    CALL $0526               ; $023D: CD 26 05
; -----------------------------------------------------------------------------
; CPM_LOAD_FOUR_SEGMENTS ($0240-$02D1) [CP/M Bootstrap | Arch: Z80 | CONFIRMED]
; Entry: Continuation at $0240
; Description: Prints 'DATA TABLES', 'COMMON CODE', 'BANKED CODE', and 'BIOS8502 CODE' while loading each segment of CPM+.SYS into RAM ($3500+, Common RAM, Bank 0, and 8502 Slave area), then jumps to CP/M cold boot entry in ($3C2D).
; Hardware Dependencies: RAM ($3C29-$3C34, $FFDD-$FFDE)
; -----------------------------------------------------------------------------
CPM_LOAD_FOUR_SEGMENTS:
; --- Inline Print String: Cursor Pos ($8A,$00)\0 ($0240-$0242) ---
    .BYTE $8A, $00, $00                          ; $0240 |...|

    LD HL,$3480              ; $0243: 21 80 34
    CALL $0534               ; $0246: CD 34 05
    LD HL,$3500              ; $0249: 21 00 35
    LD ($3C04),HL            ; $024C: 22 04 3C
    CALL $0526               ; $024F: CD 26 05
; --- Inline Print String: Pos ($83,$0C) + 'DATA TABLES\0' ($0252-$025F) ---
    .BYTE $83, $0C, $44, $41, $54, $41, $20, $54 ; $0252 |..DATA T|
    .BYTE $41, $42, $4C, $45, $53, $00           ; $025A |ABLES.|

    LD HL,($3C33)            ; $0260: 2A 33 3C
    LD ($FD09),HL            ; $0263: 22 09 FD
    LD HL,$3C32              ; $0266: 21 32 3C
    CALL $0331               ; $0269: CD 31 03
    LD ($FD0B),HL            ; $026C: 22 0B FD
    CALL $0344               ; $026F: CD 44 03
    LD DE,$0080              ; $0272: 11 80 00
    ADD HL,DE                ; $0275: 19
    JR NZ,$026F              ; $0276: 20 F7
    CALL $0526               ; $0278: CD 26 05
; --- Inline Print String: Pos ($84,$0C) + 'COMMON CODE\0' ($027B-$0288) ---
    .BYTE $84, $0C, $43, $4F, $4D, $4D, $4F, $4E ; $027B |..COMMON|
    .BYTE $20, $43, $4F, $44, $45, $00           ; $0283 | CODE.|

    LD HL,$3C2A              ; $0289: 21 2A 3C
    CALL $0324               ; $028C: CD 24 03
    CALL $0526               ; $028F: CD 26 05
; --- Inline Print String: Pos ($85,$0C) + 'BANKED CODE\0' ($0292-$029F) ---
    .BYTE $85, $0C, $42, $41, $4E, $4B, $45, $44 ; $0292 |..BANKED|
    .BYTE $20, $43, $4F, $44, $45, $00           ; $029A | CODE.|

    LD HL,$3C2C              ; $02A0: 21 2C 3C
    CALL $0324               ; $02A3: CD 24 03
    CALL $0526               ; $02A6: CD 26 05
; --- Inline Print String: Pos ($86,$0C) + 'BIOS8502 CODE\0' ($02A9-$02B8) ---
    .BYTE $86, $0C, $42, $49, $4F, $53, $38, $35 ; $02A9 |..BIOS85|
    .BYTE $30, $32, $20, $43, $4F, $44, $45, $00 ; $02B1 |02 CODE.|

    LD HL,$3C30              ; $02B9: 21 30 3C
    CALL $0324               ; $02BC: CD 24 03
    LD A,($3C30)             ; $02BF: 3A 30 3C
    LD B,A                   ; $02C2: 47
    LD A,($3C2F)             ; $02C3: 3A 2F 3C
    SUB B                    ; $02C6: 90
    LD ($FFDE),A             ; $02C7: 32 DE FF
    XOR A                    ; $02CA: AF
    LD ($FFDD),A             ; $02CB: 32 DD FF
    LD HL,($3C2D)            ; $02CE: 2A 2D 3C
    JP (HL)                  ; $02D1: E9
; -----------------------------------------------------------------------------
; CPM_READ_DISK_HEADER ($02D2-$02F9) [CP/M Bootstrap | Arch: Z80 | CONFIRMED]
; Entry: CALL $02D2
; Description: Reads physical sector 0 into $FE00 via $044F, verifies 'CBM' signature via $046B, and sets sector buffer parameters ($3C06/$3C07) for 1541 (256B) vs 1571/CP/M mode.
; Hardware Dependencies: RAM ($FD03-$FD18, $FE00)
; -----------------------------------------------------------------------------
CPM_READ_DISK_HEADER:
    LD HL,$FE00              ; $02D2: 21 00 FE
    LD ($FD18),HL            ; $02D5: 22 18 FD
    XOR A                    ; $02D8: AF
    LD ($FD04),A             ; $02D9: 32 04 FD
    INC A                    ; $02DC: 3C
    LD ($FD03),A             ; $02DD: 32 03 FD
    CALL $044F               ; $02E0: CD 4F 04
    CALL $046B               ; $02E3: CD 6B 04
    RET NZ                   ; $02E6: C0
    INC A                    ; $02E7: 3C
    LD HL,$3800              ; $02E8: 21 00 38
    LD A,$20                 ; $02EB: 3E 20
    JR NZ,$02F2              ; $02ED: 20 03
    LD H,$3C                 ; $02EF: 26 3C
    ADD A,A                  ; $02F1: 87
    LD ($3C07),HL            ; $02F2: 22 07 3C
    LD ($3C06),A             ; $02F5: 32 06 3C
    XOR A                    ; $02F8: AF
    RET                      ; $02F9: C9
; -----------------------------------------------------------------------------
; CPM_SAVE_DIR_EXTENT ($02FA-$0323) [CP/M Bootstrap | Arch: Z80 | CONFIRMED]
; Entry: CALL $02FA
; Description: Copies 16-byte CP/M directory allocation map from matched directory entry into $3C09 (extent 0) or $3C19 (extent 1); checks for >32KB error ($0480).
; Hardware Dependencies: RAM ($3C09-$3C28, $3C35)
; -----------------------------------------------------------------------------
CPM_SAVE_DIR_EXTENT:
    LD DE,$3C09              ; $02FA: 11 09 3C
    LD A,($3C35)             ; $02FD: 3A 35 3C
    OR A                     ; $0300: B7
    JR Z,$030A               ; $0301: 28 07
    LD DE,$3C19              ; $0303: 11 19 3C
    DEC A                    ; $0306: 3D
    JP NZ,$0480              ; $0307: C2 80 04
    LD HL,($FD18)            ; $030A: 2A 18 FD
    LD BC,$0010              ; $030D: 01 10 00
    ADD HL,BC                ; $0310: 09
    LDIR                     ; $0311: ED B0
    LD A,($3C09)             ; $0313: 3A 09 3C
    OR A                     ; $0316: B7
    RET Z                    ; $0317: C8
    LD HL,($3C18)            ; $0318: 2A 18 3C
    XOR A                    ; $031B: AF
    CP L                     ; $031C: BD
    JR Z,$0321               ; $031D: 28 02
    CP H                     ; $031F: BC
    RET Z                    ; $0320: C8
    JP $0229                 ; $0321: C3 29 02
; -----------------------------------------------------------------------------
; CPM_LOAD_DESCENDING_RECORDS ($0324-$0343) [CP/M Bootstrap | Arch: Z80 | CONFIRMED]
; Entry: CALL $0324
; Description: Reads CP/M 128-byte records in descending page order (used for COMMON CODE, BANKED CODE, BIOS8502 CODE segments) using header length/address pair.
; Hardware Dependencies: RAM ($3C00)
; -----------------------------------------------------------------------------
CPM_LOAD_DESCENDING_RECORDS:
    CALL $0331               ; $0324: CD 31 03
    LD DE,$FF80              ; $0327: 11 80 FF
    ADD HL,DE                ; $032A: 19
    CALL $0344               ; $032B: CD 44 03
    JR NZ,$0327              ; $032E: 20 F7
    RET                      ; $0330: C9
    LD E,(HL)                ; $0331: 5E
    LD D,$00                 ; $0332: 16 00
    LD A,E                   ; $0334: 7B
    OR A                     ; $0335: B7
    JP Z,$051B               ; $0336: CA 1B 05
    EX DE,HL                 ; $0339: EB
    ADD HL,HL                ; $033A: 29
    LD ($3C00),HL            ; $033B: 22 00 3C
    EX DE,HL                 ; $033E: EB
    DEC HL                   ; $033F: 2B
    LD H,(HL)                ; $0340: 66
    LD L,$00                 ; $0341: 2E 00
    RET                      ; $0343: C9
; -----------------------------------------------------------------------------
; CPM_READ_NEXT_128B_RECORD ($0344-$036C) [CP/M Bootstrap | Arch: Z80 | CONFIRMED]
; Entry: CALL $0344
; Description: Fetches the next 128-byte ($0080) CP/M record from the track/sector buffer at ($3C04), refilling the buffer from disk via $036D when ($3C04) reaches ($3C07).
; Hardware Dependencies: RAM ($3C00-$3C07)
; -----------------------------------------------------------------------------
CPM_READ_NEXT_128B_RECORD:
    PUSH HL                  ; $0344: E5
    LD HL,($3C07)            ; $0345: 2A 07 3C
    EX DE,HL                 ; $0348: EB
    LD HL,($3C04)            ; $0349: 2A 04 3C
    CALL $00FA               ; $034C: CD FA 00
    CALL Z,$036D             ; $034F: CC 6D 03
    EX DE,HL                 ; $0352: EB
    LD HL,$0080              ; $0353: 21 80 00
    ADD HL,DE                ; $0356: 19
    LD ($3C04),HL            ; $0357: 22 04 3C
    POP HL                   ; $035A: E1
    PUSH HL                  ; $035B: E5
    EX DE,HL                 ; $035C: EB
    LD BC,$0080              ; $035D: 01 80 00
    LDIR                     ; $0360: ED B0
    LD HL,($3C00)            ; $0362: 2A 00 3C
    DEC HL                   ; $0365: 2B
    LD ($3C00),HL            ; $0366: 22 00 3C
    LD A,L                   ; $0369: 7D
    OR H                     ; $036A: B4
    POP HL                   ; $036B: E1
    RET                      ; $036C: C9
; -----------------------------------------------------------------------------
; CPM_READ_ALLOCATION_BLOCK ($036D-$03E2) [CP/M Bootstrap | Arch: Z80 | CONFIRMED]
; Entry: CALL $036D
; Description: Reads a CP/M allocation block (1 KB or 2 KB) into $3400+ by converting block numbers to logical sectors ($FD16) and calling $03E3 + $044F (with multi-sector burst optimization if $FD08 != 0).
; Hardware Dependencies: RAM ($31BD, $3400, $FD03-$FD19)
; -----------------------------------------------------------------------------
CPM_READ_ALLOCATION_BLOCK:
    LD HL,$3400              ; $036D: 21 00 34
    LD ($FD18),HL            ; $0370: 22 18 FD
    PUSH HL                  ; $0373: E5
    LD HL,($3C02)            ; $0374: 2A 02 3C
    LD D,$00                 ; $0377: 16 00
    LD E,(HL)                ; $0379: 5E
    INC HL                   ; $037A: 23
    LD ($3C02),HL            ; $037B: 22 02 3C
    EX DE,HL                 ; $037E: EB
    ADD HL,HL                ; $037F: 29
    ADD HL,HL                ; $0380: 29
    LD A,($3C06)             ; $0381: 3A 06 3C
    RRCA                     ; $0384: 0F
    RRCA                     ; $0385: 0F
    RRCA                     ; $0386: 0F
    CP $04                   ; $0387: FE 04
    JR Z,$038C               ; $0389: 28 01
    ADD HL,HL                ; $038B: 29
    LD ($FD16),HL            ; $038C: 22 16 FD
    DEC A                    ; $038F: 3D
    LD ($FD05),A             ; $0390: 32 05 FD
    PUSH AF                  ; $0393: F5
    LD A,$01                 ; $0394: 3E 01
    LD ($31BD),A             ; $0396: 32 BD 31
    CALL $03E3               ; $0399: CD E3 03
    LD HL,($FD16)            ; $039C: 2A 16 FD
    INC HL                   ; $039F: 23
    LD ($FD16),HL            ; $03A0: 22 16 FD
    POP AF                   ; $03A3: F1
    JR Z,$03D0               ; $03A4: 28 2A
    LD A,($FD08)             ; $03A6: 3A 08 FD
    AND A                    ; $03A9: A7
    JR Z,$03D0               ; $03AA: 28 24
    LD HL,($FD03)            ; $03AC: 2A 03 FD
    PUSH HL                  ; $03AF: E5
    CALL $03E3               ; $03B0: CD E3 03
    POP HL                   ; $03B3: E1
    LD A,($FD03)             ; $03B4: 3A 03 FD
    CP L                     ; $03B7: BD
    JR NZ,$03CD              ; $03B8: 20 13
    PUSH HL                  ; $03BA: E5
    LD HL,($FD16)            ; $03BB: 2A 16 FD
    INC HL                   ; $03BE: 23
    LD ($FD16),HL            ; $03BF: 22 16 FD
    LD HL,$31BD              ; $03C2: 21 BD 31
    INC (HL)                 ; $03C5: 34
    LD HL,$FD05              ; $03C6: 21 05 FD
    DEC (HL)                 ; $03C9: 35
    JR NZ,$03B0              ; $03CA: 20 E4
    POP HL                   ; $03CC: E1
    LD ($FD03),HL            ; $03CD: 22 03 FD
    CALL $044F               ; $03D0: CD 4F 04
    LD HL,$FD19              ; $03D3: 21 19 FD
    LD A,($31BD)             ; $03D6: 3A BD 31
    ADD A,(HL)               ; $03D9: 86
    LD (HL),A                ; $03DA: 77
    LD A,($FD05)             ; $03DB: 3A 05 FD
    AND A                    ; $03DE: A7
    JR NZ,$038F              ; $03DF: 20 AE
    POP HL                   ; $03E1: E1
    RET                      ; $03E2: C9
; -----------------------------------------------------------------------------
; DISK_LOGICAL_TO_TRACK_SECTOR ($03E3-$044E) [Disk / GCR Mapping | Arch: Z80 | CONFIRMED]
; Entry: CALL $03E3 / Vec $50
; Description: Converts a logical CP/M sector number in ($FD16) into physical 1541/1571 Track ($FD03, tracks 1-35 or 36-70) and interleaved physical Sector ($FD04) using zone boundaries ($0165, $0085, $006C) and GCR interleave tables at $0FB5-$0FFF.
; Hardware Dependencies: RAM ($2400, $FD03, $FD04, $FD16), Table ($0FB5)
; -----------------------------------------------------------------------------
DISK_LOGICAL_TO_TRACK_SECTOR:
    LD A,$23                 ; $03E3: 3E 23
    LD ($2400),A             ; $03E5: 32 00 24
    LD HL,($FD16)            ; $03E8: 2A 16 FD
    LD DE,$02A8              ; $03EB: 11 A8 02
    OR A                     ; $03EE: B7
    SBC HL,DE                ; $03EF: ED 52
    JR NC,$03F8              ; $03F1: 30 05
    XOR A                    ; $03F3: AF
    LD ($2400),A             ; $03F4: 32 00 24
    ADD HL,DE                ; $03F7: 19
    INC HL                   ; $03F8: 23
    INC HL                   ; $03F9: 23
    LD DE,$0165              ; $03FA: 11 65 01
    LD BC,$1500              ; $03FD: 01 00 15
    OR A                     ; $0400: B7
    SBC HL,DE                ; $0401: ED 52
    JR C,$0420               ; $0403: 38 1B
    INC HL                   ; $0405: 23
    LD DE,$0085              ; $0406: 11 85 00
    LD BC,$1311              ; $0409: 01 11 13
    SBC HL,DE                ; $040C: ED 52
    JR C,$0420               ; $040E: 38 10
    LD DE,$006C              ; $0410: 11 6C 00
    LD BC,$1218              ; $0413: 01 18 12
    SBC HL,DE                ; $0416: ED 52
    JR C,$0420               ; $0418: 38 06
    LD DE,$0000              ; $041A: 11 00 00
    LD BC,$111E              ; $041D: 01 1E 11
    ADD HL,DE                ; $0420: 19
    LD D,$00                 ; $0421: 16 00
    LD E,B                   ; $0423: 58
    OR A                     ; $0424: B7
    INC C                    ; $0425: 0C
    SBC HL,DE                ; $0426: ED 52
    JR NC,$0425              ; $0428: 30 FB
    ADD HL,DE                ; $042A: 19
    LD A,($2400)             ; $042B: 3A 00 24
    ADD A,C                  ; $042E: 81
    LD ($FD03),A             ; $042F: 32 03 FD
    PUSH HL                  ; $0432: E5
    LD HL,$0FB5              ; $0433: 21 B5 0F
    LD BC,$0015              ; $0436: 01 15 00
    LD A,E                   ; $0439: 7B
    CP C                     ; $043A: B9
    JR Z,$0447               ; $043B: 28 0A
    ADD HL,BC                ; $043D: 09
    DEC BC                   ; $043E: 0B
    DEC BC                   ; $043F: 0B
    CP C                     ; $0440: B9
    JR Z,$0447               ; $0441: 28 04
    ADD HL,BC                ; $0443: 09
    DEC BC                   ; $0444: 0B
    JR $0440                 ; $0445: 18 F9
    POP BC                   ; $0447: C1
    ADD HL,BC                ; $0448: 09
    LD A,(HL)                ; $0449: 7E
    LD ($FD04),A             ; $044A: 32 04 FD
    INC A                    ; $044D: 3C
    RET                      ; $044E: C9
; -----------------------------------------------------------------------------
; DISK_EXEC_8502_READ_SECTOR ($044F-$046A) [Disk / Processor Switching | Arch: Z80 | CONFIRMED]
; Entry: CALL $044F
; Description: Sets retry count ($3C36)=3, command ($FD01)=1 (read sector), displays current Track/Sector on screen via $058C, calls $FFE0 to switch to 8502 slave ($3000) to perform IEC disk I/O, restores CR=$3F, and checks error status ($FD06).
; Hardware Dependencies: MMU ($FF00), Shared Stub ($FFE0), RAM ($FD01, $FD06)
; -----------------------------------------------------------------------------
DISK_EXEC_8502_READ_SECTOR:
    LD A,$03                 ; $044F: 3E 03
    LD ($3C36),A             ; $0451: 32 36 3C
    LD A,$01                 ; $0454: 3E 01
    LD ($FD01),A             ; $0456: 32 01 FD
    CALL $058C               ; $0459: CD 8C 05
    CALL $FFE0               ; $045C: CD E0 FF
    LD A,$3F                 ; $045F: 3E 3F
    LD ($FF00),A             ; $0461: 32 00 FF
    LD A,($FD06)             ; $0464: 3A 06 FD
    OR A                     ; $0467: B7
    JR NZ,$049C              ; $0468: 20 32
    RET                      ; $046A: C9
; -----------------------------------------------------------------------------
; DISK_CHECK_CBM_SIGNATURE ($046B-$047F) [Disk / Validation | Arch: Z80 | CONFIRMED]
; Entry: CALL $046B / Vec $52
; Description: Checks if sector buffer at $FE00 starts with 'C','B','M' ($43,$42,$4D) and returns byte $FEFF in A.
; Hardware Dependencies: RAM ($FE00-$FEFF)
; -----------------------------------------------------------------------------
DISK_CHECK_CBM_SIGNATURE:
    LD HL,$FE00              ; $046B: 21 00 FE
    LD A,(HL)                ; $046E: 7E
    CP $43                   ; $046F: FE 43
    RET NZ                   ; $0471: C0
    INC L                    ; $0472: 2C
    LD A,(HL)                ; $0473: 7E
    CP $42                   ; $0474: FE 42
    RET NZ                   ; $0476: C0
    INC L                    ; $0477: 2C
    LD A,(HL)                ; $0478: 7E
    CP $4D                   ; $0479: FE 4D
    RET NZ                   ; $047B: C0
    LD L,$FF                 ; $047C: 2E FF
    LD A,(HL)                ; $047E: 7E
    RET                      ; $047F: C9
; -----------------------------------------------------------------------------
; CPM_BOOT_ERROR_HANDLERS ($0480-$0525) [CP/M Bootstrap / UI | Arch: Z80 | CONFIRMED]
; Entry: Jump from $0212/$0226/$0307/$0336/$0468
; Description: Displays boot error messages ('32K MAX CPM+.SYS SIZE', 'READ ERROR', 'NO CPM+.SYS FILE', 'BAD CPM+.SYS FILE', '- HIT RETURN TO RETRY / DEL TO ENTER C128 MODE') and polls CIA1 keyboard ($DC00/$DC01) for RETURN (RST $08 retry) or DEL (RST $00 C128 reset).
; Hardware Dependencies: CIA1 ($DC00-$DC01)
; -----------------------------------------------------------------------------
CPM_BOOT_ERROR_HANDLERS:
    CALL $0526               ; $0480: CD 26 05
; --- Inline Print String: Pos ($93,$05) + '32K MAX CPM+.SYS SIZE\0' ($0483-$049A) ---
    .BYTE $93, $05, $33, $32, $4B, $20, $4D, $41 ; $0483 |..32K MA|
    .BYTE $58, $20, $43, $50, $4D, $2B, $2E, $53 ; $048B |X CPM+.S|
    .BYTE $59, $53, $20, $53, $49, $5A, $45, $00 ; $0493 |YS SIZE.|

    RST $08                  ; $049B: CF
    INC A                    ; $049C: 3C
    JR Z,$049B               ; $049D: 28 FC
    LD A,($3C36)             ; $049F: 3A 36 3C
    DEC A                    ; $04A2: 3D
    LD ($3C36),A             ; $04A3: 32 36 3C
    JR NZ,$0454              ; $04A6: 20 AC
    CALL $0526               ; $04A8: CD 26 05
; --- Inline Print String: Pos ($93,$05) + 'READ ERROR\0' ($04AB-$04B7) ---
    .BYTE $93, $05, $52, $45, $41, $44, $20, $45 ; $04AB |..READ E|
    .BYTE $52, $52, $4F, $52, $00                ; $04B3 |RROR.|

    CALL $0526               ; $04B8: CD 26 05
; --- Inline Print String: ' - HIT RETURN TO RETRY' + Pos ($94,$0F) + 'DEL TO ENTER C128 MODE\0' ($04BB-$04E9) ---
    .BYTE $20, $2D, $20, $48, $49, $54, $20, $52 ; $04BB | - HIT R|
    .BYTE $45, $54, $55, $52, $4E, $20, $54, $4F ; $04C3 |ETURN TO|
    .BYTE $20, $52, $45, $54, $52, $59, $94, $0F ; $04CB | RETRY..|
    .BYTE $44, $45, $4C, $20, $54, $4F, $20, $45 ; $04D3 |DEL TO E|
    .BYTE $4E, $54, $45, $52, $20, $43, $31, $32 ; $04DB |NTER C12|
    .BYTE $38, $20, $4D, $4F, $44, $45, $00      ; $04E3 |8 MODE.|

    LD BC,$DC00              ; $04EA: 01 00 DC
    LD A,$FE                 ; $04ED: 3E FE
    OUT (C),A                ; $04EF: ED 79
    INC C                    ; $04F1: 0C
    IN A,(C)                 ; $04F2: ED 78
    AND $02                  ; $04F4: E6 02
    JR Z,$049B               ; $04F6: 28 A3
    IN A,(C)                 ; $04F8: ED 78
    AND $01                  ; $04FA: E6 01
    JR NZ,$04EA              ; $04FC: 20 EC
    RST $00                  ; $04FE: C7
    CALL $0526               ; $04FF: CD 26 05
; --- Inline Print String: Pos ($93,$05) + 'NO\0' ($0502-$0506) ---
    .BYTE $93, $05, $4E, $4F, $00                ; $0502 |..NO.|

    CALL $0526               ; $0507: CD 26 05
; --- Inline Print String: ' CPM+.SYS FILE\0' ($050A-$0518) ---
    .BYTE $20, $43, $50, $4D, $2B, $2E, $53, $59 ; $050A | CPM+.SY|
    .BYTE $53, $20, $46, $49, $4C, $45, $00      ; $0512 |S FILE.|

    JR $04B8                 ; $0519: 18 9D
    CALL $0526               ; $051B: CD 26 05
; --- Inline Print String: Pos ($93,$05) + 'BAD\0' ($051E-$0523) ---
    .BYTE $93, $05, $42, $41, $44, $00           ; $051E |..BAD.|

    JR $0507                 ; $0524: 18 E1
; -----------------------------------------------------------------------------
; VIDEO_PRINT_STRING_ENGINE ($0526-$058B) [Video (Dual 40/80) | Arch: Z80 | CONFIRMED]
; Entry: CALL $0526 / Vec $68-$6C
; Description: Prints null-terminated or '$'-terminated strings to BOTH 40-col (VIC) and 80-col (VDC) displays simultaneously during boot, handling control codes ($0A LF, $0D CR, $FF clear/home, $80+ positioning/attribute escapes).
; Hardware Dependencies: RST $18 Dispatch
; -----------------------------------------------------------------------------
VIDEO_PRINT_STRING_ENGINE:
    EX (SP),HL               ; $0526: E3
    CALL $0534               ; $0527: CD 34 05
    EX (SP),HL               ; $052A: E3
    RET                      ; $052B: C9
    LD HL,$FFFF              ; $052C: 21 FF FF
    LD ($2404),HL            ; $052F: 22 04 24
    PUSH DE                  ; $0532: D5
    POP HL                   ; $0533: E1
    LD D,(HL)                ; $0534: 56
    INC HL                   ; $0535: 23
    LD A,($2405)             ; $0536: 3A 05 24
    AND A                    ; $0539: A7
    JR Z,$0541               ; $053A: 28 05
    XOR D                    ; $053C: AA
    LD ($2405),A             ; $053D: 32 05 24
    LD D,A                   ; $0540: 57
    LD A,D                   ; $0541: 7A
    OR A                     ; $0542: B7
    RET Z                    ; $0543: C8
    CP $24                   ; $0544: FE 24
    RET Z                    ; $0546: C8
    PUSH HL                  ; $0547: E5
    LD HL,$0533              ; $0548: 21 33 05
    PUSH HL                  ; $054B: E5
    CP $0A                   ; $054C: FE 0A
    RET Z                    ; $054E: C8
    CP $0D                   ; $054F: FE 0D
    JR NZ,$055E              ; $0551: 20 0B
    CALL $0A45               ; $0553: CD 45 0A
    CALL $06F1               ; $0556: CD F1 06
    CALL $09F1               ; $0559: CD F1 09
    RST $18                  ; $055C: DF
    .BYTE $0C                                ; $055D: 0C (RST $18 Vec $0C -> $06D1)
    CP $FF                   ; $055E: FE FF
    JR NZ,$0579              ; $0560: 20 17
    LD DE,$1800              ; $0562: 11 00 18
    CALL $0585               ; $0565: CD 85 05
    CALL $0A48               ; $0568: CD 48 0A
    CALL $077A               ; $056B: CD 7A 07
    LD DE,$0000              ; $056E: 11 00 00
    CALL $0585               ; $0571: CD 85 05
    CALL $0A62               ; $0574: CD 62 0A
    RST $18                  ; $0577: DF
    .BYTE $20                                ; $0578: 20 (RST $18 Vec $20 -> $0780)
    AND $80                  ; $0579: E6 80
    JR Z,$05B6               ; $057B: 28 39
    POP BC                   ; $057D: C1
    POP HL                   ; $057E: E1
    LD E,(HL)                ; $057F: 5E
    INC HL                   ; $0580: 23
    PUSH HL                  ; $0581: E5
    PUSH BC                  ; $0582: C5
    RES 7,D                  ; $0583: CB BA
    PUSH DE                  ; $0585: D5
    CALL $09BC               ; $0586: CD BC 09
    POP DE                   ; $0589: D1
    RST $18                  ; $058A: DF
    .BYTE $04                                ; $058B: 04 (RST $18 Vec $04 -> $06AB)
; -----------------------------------------------------------------------------
; VIDEO_SHOW_TRACK_SECTOR ($058C-$05BC) [Video (Dual 40/80) | Arch: Z80 | CONFIRMED]
; Entry: CALL $058C
; Description: Formats and prints current physical Track ($FD03) and Sector ($FD04) numbers as 2-digit decimal at row 24 on both 40-col and 80-col displays during CP/M boot.
; Hardware Dependencies: RAM ($FD03, $FD04)
; -----------------------------------------------------------------------------
VIDEO_SHOW_TRACK_SECTOR:
    LD DE,$184A              ; $058C: 11 4A 18
    CALL $06AB               ; $058F: CD AB 06
    LD DE,$1822              ; $0592: 11 22 18
    CALL $09BC               ; $0595: CD BC 09
    LD A,($FD03)             ; $0598: 3A 03 FD
    CALL $05A6               ; $059B: CD A6 05
    LD D,$20                 ; $059E: 16 20
    CALL $05B6               ; $05A0: CD B6 05
    LD A,($FD04)             ; $05A3: 3A 04 FD
    LD B,$2F                 ; $05A6: 06 2F
    INC B                    ; $05A8: 04
    SUB $0A                  ; $05A9: D6 0A
    JR NC,$05A8              ; $05AB: 30 FB
    ADD A,$3A                ; $05AD: C6 3A
    PUSH AF                  ; $05AF: F5
    LD A,B                   ; $05B0: 78
    CALL $05B5               ; $05B1: CD B5 05
    POP AF                   ; $05B4: F1
    LD D,A                   ; $05B5: 57
    PUSH DE                  ; $05B6: D5
    CALL $096E               ; $05B7: CD 6E 09
    POP DE                   ; $05BA: D1
    RST $18                  ; $05BB: DF
    .BYTE $00                                ; $05BC: 00 (RST $18 Vec $00 -> $0684)
; -----------------------------------------------------------------------------
; VDC_LOAD_CHARSET_AND_INIT ($05BD-$0683) [Video (80-Col VDC) | Arch: Z80 | CONFIRMED]
; Entry: CALL $05BD / Vec $7E
; Description: Checks if 8563 VDC character generator RAM ($3004) is already initialized; if not, copies/clears VDC font and attribute regions and uploads custom CP/M character glyphs from $0F1A.
; Hardware Dependencies: VDC ($D600-$D601)
; -----------------------------------------------------------------------------
VDC_LOAD_CHARSET_AND_INIT:
    LD HL,$3004              ; $05BD: 21 04 30
    CALL $093D               ; $05C0: CD 3D 09
    INC B                    ; $05C3: 04
    DEC B                    ; $05C4: 05
    RET Z                    ; $05C5: C8
    LD HL,$3800              ; $05C6: 21 00 38
    LD BC,$0400              ; $05C9: 01 00 04
    LD D,$00                 ; $05CC: 16 00
    CALL $0847               ; $05CE: CD 47 08
    LD HL,$37A0              ; $05D1: 21 A0 37
    LD DE,$38A0              ; $05D4: 11 A0 38
    LD BC,$0008              ; $05D7: 01 08 00
    CALL $08B0               ; $05DA: CD B0 08
    LD HL,$3690              ; $05DD: 21 90 36
    LD DE,$3890              ; $05E0: 11 90 38
    LD BC,$0008              ; $05E3: 01 08 00
    CALL $08B0               ; $05E6: CD B0 08
    LD HL,$35E0              ; $05E9: 21 E0 35
    LD DE,$38E0              ; $05EC: 11 E0 38
    LD BC,$0018              ; $05EF: 01 18 00
    CALL $08B0               ; $05F2: CD B0 08
    LD HL,$3010              ; $05F5: 21 10 30
    LD DE,$3610              ; $05F8: 11 10 36
    LD BC,$0198              ; $05FB: 01 98 01
    CALL $08B0               ; $05FE: CD B0 08
    LD HL,$3000              ; $0601: 21 00 30
    LD BC,$0200              ; $0604: 01 00 02
    LD D,$00                 ; $0607: 16 00
    CALL $0847               ; $0609: CD 47 08
    LD HL,$2000              ; $060C: 21 00 20
    LD DE,$3400              ; $060F: 11 00 34
    LD BC,$0008              ; $0612: 01 08 00
    CALL $08B0               ; $0615: CD B0 08
    LD HL,$21B0              ; $0618: 21 B0 21
    LD DE,$35B0              ; $061B: 11 B0 35
    LD BC,$0028              ; $061E: 01 28 00
    CALL $08B0               ; $0621: CD B0 08
    LD HL,$21C0              ; $0624: 21 C0 21
    LD DE,$3800              ; $0627: 11 00 38
    LD BC,$0008              ; $062A: 01 08 00
    CALL $08B0               ; $062D: CD B0 08
    LD HL,$21E0              ; $0630: 21 E0 21
    LD DE,$3810              ; $0633: 11 10 38
    LD BC,$0018              ; $0636: 01 18 00
    CALL $08B0               ; $0639: CD B0 08
    LD HL,$2400              ; $063C: 21 00 24
    LD DE,$3C00              ; $063F: 11 00 3C
    LD BC,$03F8              ; $0642: 01 F8 03
    CALL $08B0               ; $0645: CD B0 08
    LD DE,$0F1A              ; $0648: 11 1A 0F
    LD HL,$35C0              ; $064B: 21 C0 35
    CALL $0670               ; $064E: CD 70 06
    LD HL,$35E0              ; $0651: 21 E0 35
    LD B,$03                 ; $0654: 06 03
    CALL $0662               ; $0656: CD 62 06
    LD HL,$37B0              ; $0659: 21 B0 37
    LD B,$05                 ; $065C: 06 05
    JR $0662                 ; $065E: 18 02
    POP HL                   ; $0660: E1
    EX (SP),HL               ; $0661: E3
    PUSH BC                  ; $0662: C5
    PUSH HL                  ; $0663: E5
    CALL $0670               ; $0664: CD 70 06
    POP HL                   ; $0667: E1
    LD BC,$0010              ; $0668: 01 10 00
    ADD HL,BC                ; $066B: 09
    POP BC                   ; $066C: C1
    DJNZ $0662               ; $066D: 10 F3
    RET                      ; $066F: C9
    CALL $0953               ; $0670: CD 53 09
    LD H,$08                 ; $0673: 26 08
    LD A,(DE)                ; $0675: 1A
    OUT (C),A                ; $0676: ED 79
    DEC C                    ; $0678: 0D
    INC DE                   ; $0679: 13
    IN A,(C)                 ; $067A: ED 78
    RLA                      ; $067C: 17
    JR NC,$067A              ; $067D: 30 FB
    INC C                    ; $067F: 0C
    DEC H                    ; $0680: 25
    JR NZ,$0675              ; $0681: 20 F2
    RET                      ; $0683: C9
; -----------------------------------------------------------------------------
; VDC_CONSOLE_OUT_AND_CURSOR ($0684-$070F) [Video (80-Col VDC) | Arch: Z80 | CONFIRMED]
; Entry: Vec $00,$04,$08,$0C,$10,$14,$18
; Description: 80-column (8563 VDC) character output ($0684), cursor positioning ($06AB), cursor up ($06C2), linefeed/scroll ($06D1), backspace ($06DD), cursor right ($06E8), carriage return ($06F1).
; Hardware Dependencies: VDC ($D600-$D601), RAM ($2411-$2415)
; -----------------------------------------------------------------------------
VDC_CONSOLE_OUT_AND_CURSOR:
    LD HL,($2411)            ; $0684: 2A 11 24
    CALL $0907               ; $0687: CD 07 09
    LD A,($2413)             ; $068A: 3A 13 24
    CP $4F                   ; $068D: FE 4F
    JR Z,$06CD               ; $068F: 28 3C
    INC A                    ; $0691: 3C
    LD ($2413),A             ; $0692: 32 13 24
    LD HL,($2411)            ; $0695: 2A 11 24
    INC HL                   ; $0698: 23
    LD ($2411),HL            ; $0699: 22 11 24
    LD A,$0E                 ; $069C: 3E 0E
    CALL $0945               ; $069E: CD 45 09
    OUT (C),H                ; $06A1: ED 61
    LD A,$0F                 ; $06A3: 3E 0F
    CALL $0945               ; $06A5: CD 45 09
    OUT (C),L                ; $06A8: ED 69
    RET                      ; $06AA: C9
    LD A,D                   ; $06AB: 7A
    CP $19                   ; $06AC: FE 19
    RET NC                   ; $06AE: D0
    LD A,E                   ; $06AF: 7B
    CP $50                   ; $06B0: FE 50
    RET NC                   ; $06B2: D0
    EX DE,HL                 ; $06B3: EB
    LD ($2413),HL            ; $06B4: 22 13 24
    LD HL,($2413)            ; $06B7: 2A 13 24
    CALL $0CCE               ; $06BA: CD CE 0C
    LD ($2411),HL            ; $06BD: 22 11 24
    JR $069C                 ; $06C0: 18 DA
    LD A,($2414)             ; $06C2: 3A 14 24
    OR A                     ; $06C5: B7
    RET Z                    ; $06C6: C8
    DEC A                    ; $06C7: 3D
    LD ($2414),A             ; $06C8: 32 14 24
    JR $06B7                 ; $06CB: 18 EA
    XOR A                    ; $06CD: AF
    LD ($2413),A             ; $06CE: 32 13 24
    LD A,($2414)             ; $06D1: 3A 14 24
    CP $17                   ; $06D4: FE 17
    JR Z,$06F9               ; $06D6: 28 21
    JR NC,$06F4              ; $06D8: 30 1A
    INC A                    ; $06DA: 3C
    JR $06C8                 ; $06DB: 18 EB
    LD A,($2413)             ; $06DD: 3A 13 24
    OR A                     ; $06E0: B7
    RET Z                    ; $06E1: C8
    DEC A                    ; $06E2: 3D
    LD ($2413),A             ; $06E3: 32 13 24
    JR $06B7                 ; $06E6: 18 CF
    LD A,($2413)             ; $06E8: 3A 13 24
    INC A                    ; $06EB: 3C
    CP $50                   ; $06EC: FE 50
    JR NZ,$06E3              ; $06EE: 20 F3
    RET                      ; $06F0: C9
    XOR A                    ; $06F1: AF
    JR $06E3                 ; $06F2: 18 EF
    LD A,$17                 ; $06F4: 3E 17
    LD ($2414),A             ; $06F6: 32 14 24
    LD HL,$0050              ; $06F9: 21 50 00
    LD DE,$0000              ; $06FC: 11 00 00
    LD BC,$0730              ; $06FF: 01 30 07
    CALL $08B0               ; $0702: CD B0 08
    LD HL,$0730              ; $0705: 21 30 07
    LD BC,$0050              ; $0708: 01 50 00
    CALL $0841               ; $070B: CD 41 08
    JR $06B7                 ; $070E: 18 A7
; -----------------------------------------------------------------------------
; VDC_ATTR_AND_COLOR_CONTROL ($0710-$0779) [Video (80-Col VDC) | Arch: Z80 | CONFIRMED]
; Entry: Vec $34,$38,$44
; Description: 80-column (8563 VDC) attribute mask update ($0710), color translation ($071B using table at $0F0A), and color readback ($074E).
; Hardware Dependencies: VDC ($D600-$D601), RAM ($2415-$2417)
; -----------------------------------------------------------------------------
VDC_ATTR_AND_COLOR_CONTROL:
    LD A,($2415)             ; $0710: 3A 15 24
    CPL                      ; $0713: 2F
    OR B                     ; $0714: B0
    CPL                      ; $0715: 2F
    OR C                     ; $0716: B1
    LD ($2415),A             ; $0717: 32 15 24
    RET                      ; $071A: C9
    LD A,B                   ; $071B: 78
    SUB $20                  ; $071C: D6 20
    CP $20                   ; $071E: FE 20
    JR C,$072C               ; $0720: 38 0A
    LD C,$20                 ; $0722: 0E 20
    CALL $0CE5               ; $0724: CD E5 0C
    RET C                    ; $0727: D8
    LD A,(HL)                ; $0728: 7E
    AND $0F                  ; $0729: E6 0F
    ADD A,B                  ; $072B: 80
    LD ($2400),A             ; $072C: 32 00 24
    LD C,$20                 ; $072F: 0E 20
    ADD A,$30                ; $0731: C6 30
    LD HL,$0F0A              ; $0733: 21 0A 0F
    CALL $0CE8               ; $0736: CD E8 0C
    LD A,(HL)                ; $0739: 7E
    ADD A,B                  ; $073A: 80
    CP $10                   ; $073B: FE 10
    JR C,$075A               ; $073D: 38 1B
    AND $0F                  ; $073F: E6 0F
    LD ($2416),A             ; $0741: 32 16 24
    PUSH AF                  ; $0744: F5
    LD A,$1A                 ; $0745: 3E 1A
    CALL $0945               ; $0747: CD 45 09
    POP AF                   ; $074A: F1
    OUT (C),A                ; $074B: ED 79
    RET                      ; $074D: C9
    LD A,($2416)             ; $074E: 3A 16 24
    LD B,A                   ; $0751: 47
    LD A,($2415)             ; $0752: 3A 15 24
    LD D,A                   ; $0755: 57
    LD A,($2417)             ; $0756: 3A 17 24
    RET                      ; $0759: C9
    LD B,A                   ; $075A: 47
    LD A,($2415)             ; $075B: 3A 15 24
    AND $F0                  ; $075E: E6 F0
    OR B                     ; $0760: B0
    LD ($2415),A             ; $0761: 32 15 24
    LD A,($2400)             ; $0764: 3A 00 24
    LD ($2417),A             ; $0767: 32 17 24
    LD HL,($2411)            ; $076A: 2A 11 24
    LD DE,$0800              ; $076D: 11 00 08
    ADD HL,DE                ; $0770: 19
    CALL $0953               ; $0771: CD 53 09
    LD A,($2415)             ; $0774: 3A 15 24
    OUT (C),A                ; $0777: ED 79
    RET                      ; $0779: C9
; -----------------------------------------------------------------------------
; VDC_LINE_AND_SCREEN_EDIT ($077A-$083C) [Video (80-Col VDC) | Arch: Z80 | CONFIRMED]
; Entry: Vec $1C,$20,$24,$28,$2C,$30
; Description: 80-column (8563 VDC) clear to EOL ($077A), clear to EOS ($0780), insert char ($0791), delete char ($07CA), insert line ($07DC), delete line ($081E).
; Hardware Dependencies: VDC ($D600-$D601)
; -----------------------------------------------------------------------------
VDC_LINE_AND_SCREEN_EDIT:
    CALL $0CC7               ; $077A: CD C7 0C
    INC BC                   ; $077D: 03
    JR $078E                 ; $077E: 18 0E
    CALL $0CC7               ; $0780: CD C7 0C
    EX DE,HL                 ; $0783: EB
    LD HL,$0780              ; $0784: 21 80 07
    XOR A                    ; $0787: AF
    SBC HL,DE                ; $0788: ED 52
    RET M                    ; $078A: F8
    LD B,H                   ; $078B: 44
    LD C,L                   ; $078C: 4D
    EX DE,HL                 ; $078D: EB
    JP $0841                 ; $078E: C3 41 08
    CALL $0CC7               ; $0791: CD C7 0C
    LD HL,$004F              ; $0794: 21 4F 00
    ADD HL,DE                ; $0797: 19
    DEC A                    ; $0798: 3D
    JR Z,$07C7               ; $0799: 28 2C
    LD D,H                   ; $079B: 54
    LD E,L                   ; $079C: 5D
    DEC HL                   ; $079D: 2B
    PUSH BC                  ; $079E: C5
    PUSH HL                  ; $079F: E5
    PUSH DE                  ; $07A0: D5
    CALL $07AD               ; $07A1: CD AD 07
    LD BC,$0800              ; $07A4: 01 00 08
    POP HL                   ; $07A7: E1
    ADD HL,BC                ; $07A8: 09
    EX DE,HL                 ; $07A9: EB
    POP HL                   ; $07AA: E1
    ADD HL,BC                ; $07AB: 09
    POP BC                   ; $07AC: C1
    PUSH BC                  ; $07AD: C5
    CALL $0953               ; $07AE: CD 53 09
    IN A,(C)                 ; $07B1: ED 78
    EX DE,HL                 ; $07B3: EB
    PUSH AF                  ; $07B4: F5
    CALL $0953               ; $07B5: CD 53 09
    POP AF                   ; $07B8: F1
    OUT (C),A                ; $07B9: ED 79
    EX DE,HL                 ; $07BB: EB
    POP BC                   ; $07BC: C1
    DEC HL                   ; $07BD: 2B
    DEC DE                   ; $07BE: 1B
    DEC BC                   ; $07BF: 0B
    LD A,B                   ; $07C0: 78
    OR C                     ; $07C1: B1
    JR NZ,$07AD              ; $07C2: 20 E9
    LD HL,($2411)            ; $07C4: 2A 11 24
    JP $0905                 ; $07C7: C3 05 09
    CALL $0CC7               ; $07CA: CD C7 0C
    PUSH DE                  ; $07CD: D5
    LD D,H                   ; $07CE: 54
    LD E,L                   ; $07CF: 5D
    INC HL                   ; $07D0: 23
    CALL $08B0               ; $07D1: CD B0 08
    POP HL                   ; $07D4: E1
    LD DE,$004F              ; $07D5: 11 4F 00
    ADD HL,DE                ; $07D8: 19
    JP $0905                 ; $07D9: C3 05 09
    LD DE,$0F62              ; $07DC: 11 62 0F
    LD A,$17                 ; $07DF: 3E 17
    LD HL,($2413)            ; $07E1: 2A 13 24
    CP H                     ; $07E4: BC
    JP Z,$0705               ; $07E5: CA 05 07
    JR C,$0804               ; $07E8: 38 1A
    LD HL,$06E0              ; $07EA: 21 E0 06
    LD DE,$0730              ; $07ED: 11 30 07
    LD B,$18                 ; $07F0: 06 18
    CALL $080A               ; $07F2: CD 0A 08
    LD A,($2414)             ; $07F5: 3A 14 24
    CP B                     ; $07F8: B8
    JR NZ,$07F2              ; $07F9: 20 F7
    CALL $0CC7               ; $07FB: CD C7 0C
    EX DE,HL                 ; $07FE: EB
    LD BC,$0050              ; $07FF: 01 50 00
    JR $0841                 ; $0802: 18 3D
    INC A                    ; $0804: 3C
    CP L                     ; $0805: BD
    RET NZ                   ; $0806: C0
    JP $052C                 ; $0807: C3 2C 05
    PUSH BC                  ; $080A: C5
    PUSH HL                  ; $080B: E5
    PUSH DE                  ; $080C: D5
    LD BC,$0050              ; $080D: 01 50 00
    CALL $08B0               ; $0810: CD B0 08
    LD BC,$FFB0              ; $0813: 01 B0 FF
    POP HL                   ; $0816: E1
    ADD HL,BC                ; $0817: 09
    EX DE,HL                 ; $0818: EB
    POP HL                   ; $0819: E1
    ADD HL,BC                ; $081A: 09
    POP BC                   ; $081B: C1
    DEC B                    ; $081C: 05
    RET                      ; $081D: C9
    LD A,($2414)             ; $081E: 3A 14 24
    CP $18                   ; $0821: FE 18
    RET NC                   ; $0823: D0
    CALL $0CC7               ; $0824: CD C7 0C
    LD HL,$0050              ; $0827: 21 50 00
    ADD HL,DE                ; $082A: 19
    EX DE,HL                 ; $082B: EB
    PUSH HL                  ; $082C: E5
    LD HL,$0780              ; $082D: 21 80 07
    XOR A                    ; $0830: AF
    SBC HL,DE                ; $0831: ED 52
    LD B,H                   ; $0833: 44
    LD C,L                   ; $0834: 4D
    POP HL                   ; $0835: E1
    EX DE,HL                 ; $0836: EB
    CALL $08B0               ; $0837: CD B0 08
    JP $0705                 ; $083A: C3 05 07
; -----------------------------------------------------------------------------
; VDC_BLOCK_FILL_AND_COPY ($083D-$0904) [Video (80-Col VDC) | Arch: Z80 | CONFIRMED]
; Entry: CALL $0841/$08B0 / Vec $7A,$7C
; Description: Hardware-accelerated 8563 VDC block fill ($083D/$0847 using VDC reg 24 bit 7=0 + reg 30 count) and block copy ($08AE/$08B0 using VDC reg 24 bit 7=1 + regs 32/33 source).
; Hardware Dependencies: VDC ($D600-$D601)
; -----------------------------------------------------------------------------
VDC_BLOCK_FILL_AND_COPY:
    POP HL                   ; $083D: E1
    EX (SP),HL               ; $083E: E3
    JR $0847                 ; $083F: 18 06
    LD A,($2415)             ; $0841: 3A 15 24
    LD E,A                   ; $0844: 5F
    LD D,$20                 ; $0845: 16 20
    LD A,B                   ; $0847: 78
    AND A                    ; $0848: A7
    JR Z,$0858               ; $0849: 28 0D
    PUSH HL                  ; $084B: E5
    PUSH DE                  ; $084C: D5
    PUSH BC                  ; $084D: C5
    XOR A                    ; $084E: AF
    CALL $085B               ; $084F: CD 5B 08
    POP BC                   ; $0852: C1
    POP DE                   ; $0853: D1
    POP HL                   ; $0854: E1
    INC H                    ; $0855: 24
    DJNZ $084B               ; $0856: 10 F3
    LD A,C                   ; $0858: 79
    AND A                    ; $0859: A7
    RET Z                    ; $085A: C8
    PUSH AF                  ; $085B: F5
    PUSH HL                  ; $085C: E5
    PUSH DE                  ; $085D: D5
    CALL $086C               ; $085E: CD 6C 08
    POP DE                   ; $0861: D1
    LD BC,$0800              ; $0862: 01 00 08
    POP HL                   ; $0865: E1
    ADD HL,BC                ; $0866: 09
    CALL $08FE               ; $0867: CD FE 08
    POP AF                   ; $086A: F1
    LD D,E                   ; $086B: 53
    PUSH AF                  ; $086C: F5
    CALL $0953               ; $086D: CD 53 09
    OUT (C),D                ; $0870: ED 51
    POP AF                   ; $0872: F1
    DEC A                    ; $0873: 3D
    RET Z                    ; $0874: C8
    PUSH AF                  ; $0875: F5
    LD A,$18                 ; $0876: 3E 18
    CALL $0945               ; $0878: CD 45 09
    IN A,(C)                 ; $087B: ED 78
    AND $7F                  ; $087D: E6 7F
    OUT (C),A                ; $087F: ED 79
    LD A,$1E                 ; $0881: 3E 1E
    CALL $0945               ; $0883: CD 45 09
    POP AF                   ; $0886: F1
    OUT (C),A                ; $0887: ED 79
    LD B,$00                 ; $0889: 06 00
    LD C,A                   ; $088B: 4F
    INC BC                   ; $088C: 03
    ADD HL,BC                ; $088D: 09
    PUSH DE                  ; $088E: D5
    PUSH HL                  ; $088F: E5
    LD A,$12                 ; $0890: 3E 12
    CALL $0945               ; $0892: CD 45 09
    IN H,(C)                 ; $0895: ED 60
    LD A,$13                 ; $0897: 3E 13
    CALL $0945               ; $0899: CD 45 09
    IN L,(C)                 ; $089C: ED 68
    POP DE                   ; $089E: D1
    POP BC                   ; $089F: C1
    CALL $00FA               ; $08A0: CD FA 00
    RET NC                   ; $08A3: D0
    PUSH BC                  ; $08A4: C5
    CALL $0953               ; $08A5: CD 53 09
    POP BC                   ; $08A8: C1
    OUT (C),B                ; $08A9: ED 41
    INC HL                   ; $08AB: 23
    JR $08A0                 ; $08AC: 18 F2
    POP HL                   ; $08AE: E1
    EX (SP),HL               ; $08AF: E3
    LD A,B                   ; $08B0: 78
    AND A                    ; $08B1: A7
    JR Z,$08C2               ; $08B2: 28 0E
    PUSH HL                  ; $08B4: E5
    PUSH DE                  ; $08B5: D5
    PUSH BC                  ; $08B6: C5
    XOR A                    ; $08B7: AF
    CALL $08C5               ; $08B8: CD C5 08
    POP BC                   ; $08BB: C1
    POP DE                   ; $08BC: D1
    POP HL                   ; $08BD: E1
    INC H                    ; $08BE: 24
    INC D                    ; $08BF: 14
    DJNZ $08B4               ; $08C0: 10 F2
    LD A,C                   ; $08C2: 79
    AND A                    ; $08C3: A7
    RET Z                    ; $08C4: C8
    EX DE,HL                 ; $08C5: EB
    PUSH AF                  ; $08C6: F5
    PUSH HL                  ; $08C7: E5
    PUSH DE                  ; $08C8: D5
    CALL $08D8               ; $08C9: CD D8 08
    LD BC,$0800              ; $08CC: 01 00 08
    POP HL                   ; $08CF: E1
    ADD HL,BC                ; $08D0: 09
    EX DE,HL                 ; $08D1: EB
    POP HL                   ; $08D2: E1
    ADD HL,BC                ; $08D3: 09
    CALL $08FE               ; $08D4: CD FE 08
    POP AF                   ; $08D7: F1
    PUSH AF                  ; $08D8: F5
    CALL $0953               ; $08D9: CD 53 09
    LD A,$18                 ; $08DC: 3E 18
    CALL $0945               ; $08DE: CD 45 09
    IN A,(C)                 ; $08E1: ED 78
    OR $80                   ; $08E3: F6 80
    OUT (C),A                ; $08E5: ED 79
    LD A,$20                 ; $08E7: 3E 20
    CALL $0945               ; $08E9: CD 45 09
    OUT (C),D                ; $08EC: ED 51
    LD A,$21                 ; $08EE: 3E 21
    CALL $0945               ; $08F0: CD 45 09
    OUT (C),E                ; $08F3: ED 59
    LD A,$1E                 ; $08F5: 3E 1E
    CALL $0945               ; $08F7: CD 45 09
    POP AF                   ; $08FA: F1
    OUT (C),A                ; $08FB: ED 79
    RET                      ; $08FD: C9
    LD A,H                   ; $08FE: 7C
    CP $20                   ; $08FF: FE 20
    RET C                    ; $0901: D8
    POP AF                   ; $0902: F1
    POP AF                   ; $0903: F1
    RET                      ; $0904: C9
; -----------------------------------------------------------------------------
; VDC_LOWLEVEL_REG_IO ($0905-$096D) [Video (80-Col VDC) | Arch: Z80 | CONFIRMED]
; Entry: CALL $0945/$0953 / Vec $3C,$40
; Description: Low-level 8563 VDC register read/write primitives: $0945 selects VDC register A at $D600 and waits for bit 7 ready; $0953 sets VDC VRAM address (regs 18/19) to HL and selects data reg 31.
; Hardware Dependencies: VDC ($D600-$D601)
; -----------------------------------------------------------------------------
VDC_LOWLEVEL_REG_IO:
    LD D,$20                 ; $0905: 16 20
    LD A,($2415)             ; $0907: 3A 15 24
    PUSH HL                  ; $090A: E5
    PUSH DE                  ; $090B: D5
    LD DE,$0800              ; $090C: 11 00 08
    ADD HL,DE                ; $090F: 19
    LD D,A                   ; $0910: 57
    CALL $0916               ; $0911: CD 16 09
    POP DE                   ; $0914: D1
    POP HL                   ; $0915: E1
    CALL $0953               ; $0916: CD 53 09
    OUT (C),D                ; $0919: ED 51
    RET                      ; $091B: C9
    CALL $06AB               ; $091C: CD AB 06
    LD HL,($2411)            ; $091F: 2A 11 24
    CALL $0933               ; $0922: CD 33 09
    LD C,A                   ; $0925: 4F
    RET                      ; $0926: C9
    PUSH BC                  ; $0927: C5
    CALL $06AB               ; $0928: CD AB 06
    LD HL,($2411)            ; $092B: 2A 11 24
    POP BC                   ; $092E: C1
    LD D,B                   ; $092F: 50
    LD A,C                   ; $0930: 79
    JR $090A                 ; $0931: 18 D7
    PUSH HL                  ; $0933: E5
    LD DE,$0800              ; $0934: 11 00 08
    ADD HL,DE                ; $0937: 19
    CALL $093D               ; $0938: CD 3D 09
    LD A,B                   ; $093B: 78
    POP HL                   ; $093C: E1
    PUSH AF                  ; $093D: F5
    CALL $0953               ; $093E: CD 53 09
    POP AF                   ; $0941: F1
    IN B,(C)                 ; $0942: ED 40
    RET                      ; $0944: C9
    PUSH AF                  ; $0945: F5
    LD BC,$D600              ; $0946: 01 00 D6
    IN A,(C)                 ; $0949: ED 78
    RLA                      ; $094B: 17
    JR NC,$0949              ; $094C: 30 FB
    POP AF                   ; $094E: F1
    OUT (C),A                ; $094F: ED 79
    INC C                    ; $0951: 0C
    RET                      ; $0952: C9
    LD A,$12                 ; $0953: 3E 12
    CALL $0945               ; $0955: CD 45 09
    OUT (C),H                ; $0958: ED 61
    LD A,$13                 ; $095A: 3E 13
    CALL $0945               ; $095C: CD 45 09
    OUT (C),L                ; $095F: ED 69
    LD A,$1F                 ; $0961: 3E 1F
    CALL $0945               ; $0963: CD 45 09
    DEC C                    ; $0966: 0D
    IN A,(C)                 ; $0967: ED 78
    RLA                      ; $0969: 17
    JR NC,$0967              ; $096A: 30 FB
    INC C                    ; $096C: 0C
    RET                      ; $096D: C9
; -----------------------------------------------------------------------------
; VIC_CONSOLE_OUT_AND_CURSOR ($096E-$0A47) [Video (40-Col VIC) | Arch: Z80 | CONFIRMED]
; Entry: Vec $02,$06,$0A,$0E,$12,$16,$1A,$3E,$42
; Description: 40-column (VIC-IIe) virtual 80-column window console driver: writes characters to Bank 0 buffer ($1400-$1B7F) and attributes to ($1C00-$237F), handles cursor movement and scrolling ($09F1), and syncs visible 40-col window to VIC screen ($2C00) and Color RAM ($1000 via LCRc).
; Hardware Dependencies: RAM ($1400-$2410), VIC/MMU ($FF01,$FF03)
; -----------------------------------------------------------------------------
VIC_CONSOLE_OUT_AND_CURSOR:
    LD B,D                   ; $096E: 42
    CALL $0C7F               ; $096F: CD 7F 0C
    LD HL,($2409)            ; $0972: 2A 09 24
    LD B,A                   ; $0975: 47
    LD A,($2410)             ; $0976: 3A 10 24
    OR B                     ; $0979: B0
    LD (HL),A                ; $097A: 77
    INC HL                   ; $097B: 23
    LD ($2409),HL            ; $097C: 22 09 24
    LD DE,$07FF              ; $097F: 11 FF 07
    ADD HL,DE                ; $0982: 19
    LD A,($240D)             ; $0983: 3A 0D 24
    LD (HL),A                ; $0986: 77
    LD A,($240B)             ; $0987: 3A 0B 24
    CP $4F                   ; $098A: FE 4F
    JR Z,$09ED               ; $098C: 28 5F
    INC A                    ; $098E: 3C
    LD ($240B),A             ; $098F: 32 0B 24
    JP $0C4A                 ; $0992: C3 4A 0C
    CALL $09C1               ; $0995: CD C1 09
    LD HL,($2409)            ; $0998: 2A 09 24
    LD B,(HL)                ; $099B: 46
    LD DE,$0800              ; $099C: 11 00 08
    ADD HL,DE                ; $099F: 19
    LD C,(HL)                ; $09A0: 4E
    RET                      ; $09A1: C9
    PUSH BC                  ; $09A2: C5
    CALL $09C1               ; $09A3: CD C1 09
    POP BC                   ; $09A6: C1
    LD HL,($2409)            ; $09A7: 2A 09 24
    LD A,B                   ; $09AA: 78
    AND $7F                  ; $09AB: E6 7F
    BIT 6,C                  ; $09AD: CB 71
    JR Z,$09B3               ; $09AF: 28 02
    ADD A,$80                ; $09B1: C6 80
    LD (HL),A                ; $09B3: 77
    LD DE,$0800              ; $09B4: 11 00 08
    ADD HL,DE                ; $09B7: 19
    LD (HL),C                ; $09B8: 71
    JP $0C4A                 ; $09B9: C3 4A 0C
    LD HL,$2404              ; $09BC: 21 04 24
    SET 6,(HL)               ; $09BF: CB F6
    LD A,D                   ; $09C1: 7A
    CP $19                   ; $09C2: FE 19
    RET NC                   ; $09C4: D0
    LD A,E                   ; $09C5: 7B
    CP $50                   ; $09C6: FE 50
    RET NC                   ; $09C8: D0
    EX DE,HL                 ; $09C9: EB
    LD ($240B),HL            ; $09CA: 22 0B 24
    LD HL,($240B)            ; $09CD: 2A 0B 24
    CALL $0CCE               ; $09D0: CD CE 0C
    LD DE,$1400              ; $09D3: 11 00 14
    ADD HL,DE                ; $09D6: 19
    LD ($2409),HL            ; $09D7: 22 09 24
    JP $0C4A                 ; $09DA: C3 4A 0C
    LD A,($240C)             ; $09DD: 3A 0C 24
    OR A                     ; $09E0: B7
    RET Z                    ; $09E1: C8
    DEC A                    ; $09E2: 3D
    LD ($240C),A             ; $09E3: 32 0C 24
    LD HL,$2404              ; $09E6: 21 04 24
    SET 6,(HL)               ; $09E9: CB F6
    JR $09CD                 ; $09EB: 18 E0
    XOR A                    ; $09ED: AF
    LD ($240B),A             ; $09EE: 32 0B 24
    LD A,($240C)             ; $09F1: 3A 0C 24
    CP $17                   ; $09F4: FE 17
    JR Z,$0A02               ; $09F6: 28 0A
    JR NC,$09FD              ; $09F8: 30 03
    INC A                    ; $09FA: 3C
    JR $09E3                 ; $09FB: 18 E6
    LD A,$17                 ; $09FD: 3E 17
    LD ($240C),A             ; $09FF: 32 0C 24
    LD HL,$1450              ; $0A02: 21 50 14
    LD DE,$1400              ; $0A05: 11 00 14
    LD BC,$0730              ; $0A08: 01 30 07
    LDIR                     ; $0A0B: ED B0
    EX DE,HL                 ; $0A0D: EB
    LD DE,$1B31              ; $0A0E: 11 31 1B
    LD BC,$004F              ; $0A11: 01 4F 00
    CALL $0B24               ; $0A14: CD 24 0B
    LD HL,$1C50              ; $0A17: 21 50 1C
    LD DE,$1C00              ; $0A1A: 11 00 1C
    LD BC,$0730              ; $0A1D: 01 30 07
    LDIR                     ; $0A20: ED B0
    EX DE,HL                 ; $0A22: EB
    LD DE,$2331              ; $0A23: 11 31 23
    LD BC,$004F              ; $0A26: 01 4F 00
    LD A,($240D)             ; $0A29: 3A 0D 24
    LD (HL),A                ; $0A2C: 77
    LDIR                     ; $0A2D: ED B0
    JR $09E6                 ; $0A2F: 18 B5
    LD A,($240B)             ; $0A31: 3A 0B 24
    OR A                     ; $0A34: B7
    RET Z                    ; $0A35: C8
    DEC A                    ; $0A36: 3D
    LD ($240B),A             ; $0A37: 32 0B 24
    JR $09CD                 ; $0A3A: 18 91
    LD A,($240B)             ; $0A3C: 3A 0B 24
    INC A                    ; $0A3F: 3C
    CP $50                   ; $0A40: FE 50
    JR NZ,$0A37              ; $0A42: 20 F3
    RET                      ; $0A44: C9
    XOR A                    ; $0A45: AF
    JR $0A37                 ; $0A46: 18 EF
; -----------------------------------------------------------------------------
; VIC_LINE_AND_SCREEN_EDIT ($0A48-$0B61) [Video (40-Col VIC) | Arch: Z80 | CONFIRMED]
; Entry: Vec $1E,$22,$26,$2A,$2E,$32
; Description: 40-column (VIC-IIe) clear to EOL ($0A48), clear to EOS ($0A62), insert char ($0A8E), delete char ($0ABA), insert line ($0ADF), delete line ($0B2D).
; Hardware Dependencies: RAM ($1400-$237F)
; -----------------------------------------------------------------------------
VIC_LINE_AND_SCREEN_EDIT:
    LD HL,$0BCF              ; $0A48: 21 CF 0B
    PUSH HL                  ; $0A4B: E5
    CALL $0CC2               ; $0A4C: CD C2 0C
    LD DE,$1400              ; $0A4F: 11 00 14
    ADD HL,DE                ; $0A52: 19
    CALL $0AB3               ; $0A53: CD B3 0A
    LD A,C                   ; $0A56: 79
    AND A                    ; $0A57: A7
    RET Z                    ; $0A58: C8
    PUSH BC                  ; $0A59: C5
    PUSH HL                  ; $0A5A: E5
    LD D,H                   ; $0A5B: 54
    LD E,L                   ; $0A5C: 5D
    INC DE                   ; $0A5D: 13
    LDIR                     ; $0A5E: ED B0
    JR $0A7E                 ; $0A60: 18 1C
    LD HL,$0C0C              ; $0A62: 21 0C 0C
    PUSH HL                  ; $0A65: E5
    LD DE,$1B7F              ; $0A66: 11 7F 1B
    LD HL,($2409)            ; $0A69: 2A 09 24
    EX DE,HL                 ; $0A6C: EB
    XOR A                    ; $0A6D: AF
    SBC HL,DE                ; $0A6E: ED 52
    RET M                    ; $0A70: F8
    EX DE,HL                 ; $0A71: EB
    JR Z,$0AB3               ; $0A72: 28 3F
    LD B,D                   ; $0A74: 42
    LD C,E                   ; $0A75: 4B
    LD D,H                   ; $0A76: 54
    LD E,L                   ; $0A77: 5D
    INC DE                   ; $0A78: 13
    PUSH BC                  ; $0A79: C5
    PUSH HL                  ; $0A7A: E5
    CALL $0B24               ; $0A7B: CD 24 0B
    LD BC,$0800              ; $0A7E: 01 00 08
    POP HL                   ; $0A81: E1
    ADD HL,BC                ; $0A82: 09
    POP BC                   ; $0A83: C1
    LD D,H                   ; $0A84: 54
    LD E,L                   ; $0A85: 5D
    INC DE                   ; $0A86: 13
    LD A,($240D)             ; $0A87: 3A 0D 24
    LD (HL),A                ; $0A8A: 77
    LDIR                     ; $0A8B: ED B0
    RET                      ; $0A8D: C9
    LD HL,$0BCF              ; $0A8E: 21 CF 0B
    PUSH HL                  ; $0A91: E5
    CALL $0CC2               ; $0A92: CD C2 0C
    LD HL,$144F              ; $0A95: 21 4F 14
    ADD HL,DE                ; $0A98: 19
    DEC A                    ; $0A99: 3D
    JR Z,$0AB3               ; $0A9A: 28 17
    LD D,H                   ; $0A9C: 54
    LD E,L                   ; $0A9D: 5D
    DEC HL                   ; $0A9E: 2B
    PUSH BC                  ; $0A9F: C5
    PUSH DE                  ; $0AA0: D5
    LDDR                     ; $0AA1: ED B8
    EX DE,HL                 ; $0AA3: EB
    CALL $0AB3               ; $0AA4: CD B3 0A
    POP HL                   ; $0AA7: E1
    LD BC,$0800              ; $0AA8: 01 00 08
    ADD HL,BC                ; $0AAB: 09
    POP BC                   ; $0AAC: C1
    LD D,H                   ; $0AAD: 54
    LD E,L                   ; $0AAE: 5D
    DEC HL                   ; $0AAF: 2B
    LDDR                     ; $0AB0: ED B8
    RET                      ; $0AB2: C9
    LD A,($2410)             ; $0AB3: 3A 10 24
    ADD A,$20                ; $0AB6: C6 20
    LD (HL),A                ; $0AB8: 77
    RET                      ; $0AB9: C9
    LD HL,$0BCF              ; $0ABA: 21 CF 0B
    PUSH HL                  ; $0ABD: E5
    CALL $0CC2               ; $0ABE: CD C2 0C
    LD DE,$1400              ; $0AC1: 11 00 14
    ADD HL,DE                ; $0AC4: 19
    DEC A                    ; $0AC5: 3D
    JR Z,$0AB3               ; $0AC6: 28 EB
    LD D,H                   ; $0AC8: 54
    LD E,L                   ; $0AC9: 5D
    PUSH BC                  ; $0ACA: C5
    PUSH HL                  ; $0ACB: E5
    INC HL                   ; $0ACC: 23
    LDIR                     ; $0ACD: ED B0
    EX DE,HL                 ; $0ACF: EB
    CALL $0AB3               ; $0AD0: CD B3 0A
    POP HL                   ; $0AD3: E1
    LD BC,$0801              ; $0AD4: 01 01 08
    ADD HL,BC                ; $0AD7: 09
    POP BC                   ; $0AD8: C1
    LD D,H                   ; $0AD9: 54
    LD E,L                   ; $0ADA: 5D
    INC HL                   ; $0ADB: 23
    LDIR                     ; $0ADC: ED B0
    RET                      ; $0ADE: C9
    LD HL,$0C0C              ; $0ADF: 21 0C 0C
    PUSH HL                  ; $0AE2: E5
    LD A,($240C)             ; $0AE3: 3A 0C 24
    CP $17                   ; $0AE6: FE 17
    JR Z,$0B1B               ; $0AE8: 28 31
    RET NC                   ; $0AEA: D0
    CALL $0CC2               ; $0AEB: CD C2 0C
    LD HL,$1400              ; $0AEE: 21 00 14
    ADD HL,DE                ; $0AF1: 19
    PUSH HL                  ; $0AF2: E5
    LD DE,$0050              ; $0AF3: 11 50 00
    ADD HL,DE                ; $0AF6: 19
    EX DE,HL                 ; $0AF7: EB
    LD HL,$1B80              ; $0AF8: 21 80 1B
    XOR A                    ; $0AFB: AF
    SBC HL,DE                ; $0AFC: ED 52
    LD B,H                   ; $0AFE: 44
    LD C,L                   ; $0AFF: 4D
    LD HL,$1B2F              ; $0B00: 21 2F 1B
    LD DE,$1B7F              ; $0B03: 11 7F 1B
    PUSH BC                  ; $0B06: C5
    LDDR                     ; $0B07: ED B8
    POP BC                   ; $0B09: C1
    LD HL,$232F              ; $0B0A: 21 2F 23
    LD DE,$237F              ; $0B0D: 11 7F 23
    LDDR                     ; $0B10: ED B8
    POP HL                   ; $0B12: E1
    LD D,H                   ; $0B13: 54
    LD E,L                   ; $0B14: 5D
    INC DE                   ; $0B15: 13
    LD BC,$004F              ; $0B16: 01 4F 00
    JR $0B24                 ; $0B19: 18 09
    LD HL,$1B30              ; $0B1B: 21 30 1B
    LD DE,$1B31              ; $0B1E: 11 31 1B
    LD BC,$004F              ; $0B21: 01 4F 00
    LD A,($2410)             ; $0B24: 3A 10 24
    ADD A,$20                ; $0B27: C6 20
    LD (HL),A                ; $0B29: 77
    LDIR                     ; $0B2A: ED B0
    RET                      ; $0B2C: C9
    LD HL,$0C0C              ; $0B2D: 21 0C 0C
    PUSH HL                  ; $0B30: E5
    LD A,($240C)             ; $0B31: 3A 0C 24
    CP $17                   ; $0B34: FE 17
    JR Z,$0B1B               ; $0B36: 28 E3
    RET NC                   ; $0B38: D0
    CALL $0CC2               ; $0B39: CD C2 0C
    LD HL,$1400              ; $0B3C: 21 00 14
    ADD HL,DE                ; $0B3F: 19
    PUSH HL                  ; $0B40: E5
    LD DE,$0050              ; $0B41: 11 50 00
    ADD HL,DE                ; $0B44: 19
    EX DE,HL                 ; $0B45: EB
    LD HL,$1B80              ; $0B46: 21 80 1B
    XOR A                    ; $0B49: AF
    SBC HL,DE                ; $0B4A: ED 52
    LD B,H                   ; $0B4C: 44
    LD C,L                   ; $0B4D: 4D
    EX DE,HL                 ; $0B4E: EB
    POP DE                   ; $0B4F: D1
    PUSH BC                  ; $0B50: C5
    PUSH HL                  ; $0B51: E5
    PUSH DE                  ; $0B52: D5
    LDIR                     ; $0B53: ED B0
    LD BC,$0800              ; $0B55: 01 00 08
    POP HL                   ; $0B58: E1
    ADD HL,BC                ; $0B59: 09
    EX DE,HL                 ; $0B5A: EB
    POP HL                   ; $0B5B: E1
    ADD HL,BC                ; $0B5C: 09
    POP BC                   ; $0B5D: C1
    LDIR                     ; $0B5E: ED B0
    JR $0B1B                 ; $0B60: 18 B9
; -----------------------------------------------------------------------------
; VIC_ATTR_AND_COLOR_CONTROL ($0B62-$0BCE) [Video (40-Col VIC) | Arch: Z80 | CONFIRMED]
; Entry: Vec $36,$3A,$46
; Description: 40-column (VIC-IIe) attribute update ($0B62), border/background/foreground color control ($0B7B writing $D020/$D021), and color readback ($0BAE).
; Hardware Dependencies: VIC ($D020, $D021), RAM ($240D-$2410)
; -----------------------------------------------------------------------------
VIC_ATTR_AND_COLOR_CONTROL:
    LD A,B                   ; $0B62: 78
    AND $70                  ; $0B63: E6 70
    LD B,A                   ; $0B65: 47
    LD A,C                   ; $0B66: 79
    AND $70                  ; $0B67: E6 70
    LD C,A                   ; $0B69: 4F
    LD A,($240D)             ; $0B6A: 3A 0D 24
    CPL                      ; $0B6D: 2F
    OR B                     ; $0B6E: B0
    CPL                      ; $0B6F: 2F
    OR C                     ; $0B70: B1
    LD ($240D),A             ; $0B71: 32 0D 24
    RLA                      ; $0B74: 17
    AND $80                  ; $0B75: E6 80
    LD ($2410),A             ; $0B77: 32 10 24
    RET                      ; $0B7A: C9
    LD A,B                   ; $0B7B: 78
    SUB $20                  ; $0B7C: D6 20
    CP $30                   ; $0B7E: FE 30
    JR C,$0B90               ; $0B80: 38 0E
    LD C,$30                 ; $0B82: 0E 30
    CALL $0CE5               ; $0B84: CD E5 0C
    RET C                    ; $0B87: D8
    LD A,(HL)                ; $0B88: 7E
    RRCA                     ; $0B89: 0F
    RRCA                     ; $0B8A: 0F
    RRCA                     ; $0B8B: 0F
    RRCA                     ; $0B8C: 0F
    AND $0F                  ; $0B8D: E6 0F
    ADD A,B                  ; $0B8F: 80
    CP $10                   ; $0B90: FE 10
    JR C,$0BBD               ; $0B92: 38 29
    CP $20                   ; $0B94: FE 20
    JR C,$0BA3               ; $0B96: 38 0B
    AND $0F                  ; $0B98: E6 0F
    LD ($240F),A             ; $0B9A: 32 0F 24
    LD BC,$D020              ; $0B9D: 01 20 D0
    OUT (C),A                ; $0BA0: ED 79
    RET                      ; $0BA2: C9
    AND $0F                  ; $0BA3: E6 0F
    LD ($240E),A             ; $0BA5: 32 0E 24
    LD BC,$D021              ; $0BA8: 01 21 D0
    OUT (C),A                ; $0BAB: ED 79
    RET                      ; $0BAD: C9
    LD A,($240E)             ; $0BAE: 3A 0E 24
    LD B,A                   ; $0BB1: 47
    LD A,($240F)             ; $0BB2: 3A 0F 24
    LD C,A                   ; $0BB5: 4F
    LD A,($240D)             ; $0BB6: 3A 0D 24
    LD D,A                   ; $0BB9: 57
    AND $0F                  ; $0BBA: E6 0F
    RET                      ; $0BBC: C9
    LD B,A                   ; $0BBD: 47
    LD A,($240D)             ; $0BBE: 3A 0D 24
    AND $F0                  ; $0BC1: E6 F0
    OR B                     ; $0BC3: B0
    LD ($240D),A             ; $0BC4: 32 0D 24
    LD HL,($2409)            ; $0BC7: 2A 09 24
    LD DE,$0800              ; $0BCA: 11 00 08
    ADD HL,DE                ; $0BCD: 19
    LD (HL),A                ; $0BCE: 77
; -----------------------------------------------------------------------------
; VIC_WINDOW_REFRESH_DMA ($0BCF-$0C7E) [Video (40-Col VIC) | Arch: Z80 | CONFIRMED]
; Entry: CALL $0BCF/$0C0C/$0C4A / Vec $60-$66
; Description: Refreshes the physical 40x25 VIC-IIe screen at $2C00 and Color RAM at $1000 (mapped via MMU LCRc $FF03) from the 80x24 virtual screen buffer at $1400/$1C00 based on horizontal scroll offset ($2402).
; Hardware Dependencies: MMU ($FF01, $FF03), RAM ($1000, $1400, $1C00, $2C00)
; -----------------------------------------------------------------------------
VIC_WINDOW_REFRESH_DMA:
    LD A,($2404)             ; $0BCF: 3A 04 24
    LD B,A                   ; $0BD2: 47
    OR A                     ; $0BD3: B7
    CALL M,$0C3C             ; $0BD4: FC 3C 0C
    LD A,($2402)             ; $0BD7: 3A 02 24
    CP B                     ; $0BDA: B8
    LD ($2404),A             ; $0BDB: 32 04 24
    JR NZ,$0C0C              ; $0BDE: 20 2C
    CALL $0CC2               ; $0BE0: CD C2 0C
    LD HL,$1400              ; $0BE3: 21 00 14
    ADD HL,DE                ; $0BE6: 19
    EX DE,HL                 ; $0BE7: EB
    LD HL,($2402)            ; $0BE8: 2A 02 24
    ADD HL,DE                ; $0BEB: 19
    PUSH HL                  ; $0BEC: E5
    LD A,($240C)             ; $0BED: 3A 0C 24
    LD L,A                   ; $0BF0: 6F
    CALL $0C70               ; $0BF1: CD 70 0C
    EX DE,HL                 ; $0BF4: EB
    POP HL                   ; $0BF5: E1
    PUSH HL                  ; $0BF6: E5
    PUSH DE                  ; $0BF7: D5
    LD A,$01                 ; $0BF8: 3E 01
    CALL $0C27               ; $0BFA: CD 27 0C
    POP HL                   ; $0BFD: E1
    LD BC,$E400              ; $0BFE: 01 00 E4
    ADD HL,BC                ; $0C01: 09
    EX DE,HL                 ; $0C02: EB
    POP HL                   ; $0C03: E1
    LD BC,$0800              ; $0C04: 01 00 08
    ADD HL,BC                ; $0C07: 09
    LD A,$01                 ; $0C08: 3E 01
    JR $0C27                 ; $0C0A: 18 1B
    LD HL,($2402)            ; $0C0C: 2A 02 24
    LD A,($2408)             ; $0C0F: 3A 08 24
    PUSH HL                  ; $0C12: E5
    PUSH AF                  ; $0C13: F5
    LD DE,$1400              ; $0C14: 11 00 14
    ADD HL,DE                ; $0C17: 19
    LD DE,$2C00              ; $0C18: 11 00 2C
    CALL $0C27               ; $0C1B: CD 27 0C
    POP AF                   ; $0C1E: F1
    POP HL                   ; $0C1F: E1
    LD DE,$1C00              ; $0C20: 11 00 1C
    ADD HL,DE                ; $0C23: 19
    LD DE,$1000              ; $0C24: 11 00 10
    LD ($FF03),A             ; $0C27: 32 03 FF
    LD BC,$0028              ; $0C2A: 01 28 00
    LDIR                     ; $0C2D: ED B0
    PUSH DE                  ; $0C2F: D5
    LD DE,$0028              ; $0C30: 11 28 00
    ADD HL,DE                ; $0C33: 19
    POP DE                   ; $0C34: D1
    DEC A                    ; $0C35: 3D
    JR NZ,$0C2A              ; $0C36: 20 F2
    LD ($FF01),A             ; $0C38: 32 01 FF
    RET                      ; $0C3B: C9
    LD A,($240B)             ; $0C3C: 3A 0B 24
    SUB $20                  ; $0C3F: D6 20
    JR NC,$0C44              ; $0C41: 30 01
    XOR A                    ; $0C43: AF
    AND $F8                  ; $0C44: E6 F8
    LD ($2402),A             ; $0C46: 32 02 24
    RET                      ; $0C49: C9
    CALL $0C69               ; $0C4A: CD 69 0C
    CALL $0BCF               ; $0C4D: CD CF 0B
    LD A,($2402)             ; $0C50: 3A 02 24
    LD B,A                   ; $0C53: 47
    LD HL,($240B)            ; $0C54: 2A 0B 24
    LD A,L                   ; $0C57: 7D
    SUB B                    ; $0C58: 90
    JR C,$0C69               ; $0C59: 38 0E
    CP $28                   ; $0C5B: FE 28
    JR NC,$0C69              ; $0C5D: 30 0A
    LD C,A                   ; $0C5F: 4F
    LD B,$00                 ; $0C60: 06 00
    LD L,H                   ; $0C62: 6C
    CALL $0C70               ; $0C63: CD 70 0C
    ADD HL,BC                ; $0C66: 09
    JR $0C6C                 ; $0C67: 18 03
    LD HL,$0000              ; $0C69: 21 00 00
    LD ($2406),HL            ; $0C6C: 22 06 24
    RET                      ; $0C6F: C9
    LD H,$00                 ; $0C70: 26 00
    ADD HL,HL                ; $0C72: 29
    ADD HL,HL                ; $0C73: 29
    ADD HL,HL                ; $0C74: 29
    LD D,H                   ; $0C75: 54
    LD E,L                   ; $0C76: 5D
    ADD HL,HL                ; $0C77: 29
    ADD HL,HL                ; $0C78: 29
    ADD HL,DE                ; $0C79: 19
    LD DE,$2C00              ; $0C7A: 11 00 2C
    ADD HL,DE                ; $0C7D: 19
    RET                      ; $0C7E: C9
; -----------------------------------------------------------------------------
; VIDEO_ASCII_TO_SCREENCODE_AND_MATH ($0C7F-$0CF9) [Video / Utility | Arch: Z80 | CONFIRMED]
; Entry: CALL $0C7F/$0CCE / Vec $70-$76
; Description: Converts ASCII characters in B to Commodore screen codes ($0C7F), computes 80-column row*80+col offset ($0CC2/$0CC7/$0CCE), and performs color table index validation ($0CE4).
; Hardware Dependencies: RAM ($240B, $2413, $FD0D)
; -----------------------------------------------------------------------------
VIDEO_ASCII_TO_SCREENCODE_AND_MATH:
    LD A,B                   ; $0C7F: 78
    CP $40                   ; $0C80: FE 40
    JR Z,$0CC0               ; $0C82: 28 3C
    RET C                    ; $0C84: D8
    CP $5B                   ; $0C85: FE 5B
    RET C                    ; $0C87: D8
    SUB $40                  ; $0C88: D6 40
    CP $20                   ; $0C8A: FE 20
    JR Z,$0CA7               ; $0C8C: 28 19
    JR C,$0CB3               ; $0C8E: 38 23
    SUB $20                  ; $0C90: D6 20
    CP $1B                   ; $0C92: FE 1B
    RET C                    ; $0C94: D8
    CP $1B                   ; $0C95: FE 1B
    JR Z,$0CAA               ; $0C97: 28 11
    CP $1C                   ; $0C99: FE 1C
    JR Z,$0CAD               ; $0C9B: 28 10
    CP $1D                   ; $0C9D: FE 1D
    JR Z,$0CB0               ; $0C9F: 28 0F
    CP $1E                   ; $0CA1: FE 1E
    RET NZ                   ; $0CA3: C0
    LD A,$40                 ; $0CA4: 3E 40
    RET                      ; $0CA6: C9
    LD A,$7E                 ; $0CA7: 3E 7E
    RET                      ; $0CA9: C9
    LD A,$73                 ; $0CAA: 3E 73
    RET                      ; $0CAC: C9
    LD A,$5D                 ; $0CAD: 3E 5D
    RET                      ; $0CAF: C9
    LD A,$6B                 ; $0CB0: 3E 6B
    RET                      ; $0CB2: C9
    CP $1C                   ; $0CB3: FE 1C
    JR Z,$0CBD               ; $0CB5: 28 06
    CP $1F                   ; $0CB7: FE 1F
    RET NZ                   ; $0CB9: C0
    LD A,$64                 ; $0CBA: 3E 64
    RET                      ; $0CBC: C9
    LD A,$7F                 ; $0CBD: 3E 7F
    RET                      ; $0CBF: C9
    XOR A                    ; $0CC0: AF
    RET                      ; $0CC1: C9
    LD HL,($240B)            ; $0CC2: 2A 0B 24
    JR $0CCA                 ; $0CC5: 18 03
    LD HL,($2413)            ; $0CC7: 2A 13 24
    LD A,$4F                 ; $0CCA: 3E 4F
    SUB L                    ; $0CCC: 95
    LD C,A                   ; $0CCD: 4F
    LD B,L                   ; $0CCE: 45
    LD L,H                   ; $0CCF: 6C
    LD H,$00                 ; $0CD0: 26 00
    ADD HL,HL                ; $0CD2: 29
    ADD HL,HL                ; $0CD3: 29
    ADD HL,HL                ; $0CD4: 29
    ADD HL,HL                ; $0CD5: 29
    LD D,H                   ; $0CD6: 54
    LD E,L                   ; $0CD7: 5D
    ADD HL,HL                ; $0CD8: 29
    ADD HL,HL                ; $0CD9: 29
    ADD HL,DE                ; $0CDA: 19
    EX DE,HL                 ; $0CDB: EB
    LD L,B                   ; $0CDC: 68
    LD H,$00                 ; $0CDD: 26 00
    ADD HL,DE                ; $0CDF: 19
    LD B,$00                 ; $0CE0: 06 00
    INC A                    ; $0CE2: 3C
    RET                      ; $0CE3: C9
    LD A,B                   ; $0CE4: 78
    LD HL,($FD0D)            ; $0CE5: 2A 0D FD
    SUB $30                  ; $0CE8: D6 30
    RET C                    ; $0CEA: D8
    CP C                     ; $0CEB: B9
    CCF                      ; $0CEC: 3F
    RET C                    ; $0CED: D8
    LD B,A                   ; $0CEE: 47
    AND $0F                  ; $0CEF: E6 0F
    LD E,A                   ; $0CF1: 5F
    LD D,$00                 ; $0CF2: 16 00
    ADD HL,DE                ; $0CF4: 19
    LD A,B                   ; $0CF5: 78
    AND $30                  ; $0CF6: E6 30
    LD B,A                   ; $0CF8: 47
    RET                      ; $0CF9: C9
; -----------------------------------------------------------------------------
; SID_BEEP_SOUND ($0CFA-$0D19) [Audio (SID) | Arch: Z80 | CONFIRMED]
; Entry: Vec $54 ($0CFA)
; Description: Programs MOS 8580/6581 SID Voice 1 registers ($D418 volume, $D405 AD, $D406 SR, $D401/$D400 freq, $D404 waveform) from parameter table at $FD10-$FD15 (initialized from $0FA0-$0FA5).
; Hardware Dependencies: SID ($D400-$D418), RAM ($FD10-$FD15)
; -----------------------------------------------------------------------------
SID_BEEP_SOUND:
    LD BC,$D418              ; $0CFA: 01 18 D4
    LD HL,($FD10)            ; $0CFD: 2A 10 FD
    OUT (C),H                ; $0D00: ED 61
    LD C,$05                 ; $0D02: 0E 05
    OUT (C),L                ; $0D04: ED 69
    LD HL,($FD12)            ; $0D06: 2A 12 FD
    INC C                    ; $0D09: 0C
    OUT (C),H                ; $0D0A: ED 61
    LD C,$01                 ; $0D0C: 0E 01
    OUT (C),L                ; $0D0E: ED 69
    LD HL,($FD14)            ; $0D10: 2A 14 FD
    LD C,$04                 ; $0D13: 0E 04
    OUT (C),H                ; $0D15: ED 61
    OUT (C),L                ; $0D17: ED 69
    RET                      ; $0D19: C9
; -----------------------------------------------------------------------------
; BOOT_8502_TRAMPOLINE_PAYLOAD ($0D1A-$0D21) [Processor Switching | Arch: 8502 | CONFIRMED]
; Entry: Copied to $1100 ($0D1A)
; Description: 8-byte MOS 8502 cold-boot trampoline copied to $1100 by Z80 at $008C: LDA #$00; STA $FF00; JMP ($FFFC) -> enters C128 8502 KERNAL at $E000.
; Hardware Dependencies: MMU_CR ($FF00), KERNAL ($FFFC)
; -----------------------------------------------------------------------------
BOOT_8502_TRAMPOLINE_PAYLOAD:
; --- Embedded MOS 8502 Cold-Boot Trampoline (copied to $1100-$1107) ($0D1A-$0D21) ---
    .BYTE $A9, $00                         ; $0D1A [8502 @ $1100]: LDA #$00
    .BYTE $8D, $00, $FF                    ; $0D1C [8502 @ $1102]: STA $FF00 ; MMU_CR_TOP
    .BYTE $6C, $FC, $FF                    ; $0D1F [8502 @ $1105]: JMP ($FFFC) ; HW_VEC_RESET

; -----------------------------------------------------------------------------
; SLAVE_8502_DISK_DRIVER_PAYLOAD ($0D22-$0EE4) [Disk / Processor Switching | Arch: 8502 | CONFIRMED]
; Entry: Copied to $3000-$31C2 ($0D22)
; Description: 451-byte MOS 8502 slave I/O driver copied to Bank 0 RAM $3000-$31C2 by Z80 at $019B. Executes C128 KERNAL IEC / Fast Serial commands ('U1:11 0 tt ss', 'U0>', '#') when Z80 calls $FFE0, then switches back to Z80 via JMP $FFD0.
; Hardware Dependencies: KERNAL ($FF68-$FFD2), CIA1 ($DC0C-$DC0D), CIA2 ($DD00), MMU ($FF00)
; -----------------------------------------------------------------------------
SLAVE_8502_DISK_DRIVER_PAYLOAD:
; --- Embedded MOS 8502 Slave Disk I/O Driver (copied to $3000-$31AB) ($0D22-$0ECD) ---
    .BYTE $A9, $00                         ; $0D22 [8502 @ $3000]: LDA #$00
    .BYTE $8D, $06, $FD                    ; $0D24 [8502 @ $3002]: STA $FD06
    .BYTE $20, $11, $30                    ; $0D27 [8502 @ $3005]: JSR $3011
    .BYTE $78                              ; $0D2A [8502 @ $3008]: SEI
    .BYTE $A9, $3E                         ; $0D2B [8502 @ $3009]: LDA #$3E
    .BYTE $8D, $00, $FF                    ; $0D2D [8502 @ $300B]: STA $FF00 ; MMU_CR_TOP
    .BYTE $4C, $D0, $FF                    ; $0D30 [8502 @ $300E]: JMP $FFD0
    .BYTE $D8                              ; $0D33 [8502 @ $3011]: CLD
    .BYTE $AD, $01, $FD                    ; $0D34 [8502 @ $3012]: LDA $FD01
    .BYTE $D0, $21                         ; $0D37 [8502 @ $3015]: BNE $3038
    .BYTE $A2, $00                         ; $0D39 [8502 @ $3017]: LDX #$00
    .BYTE $8E, $00, $FF                    ; $0D3B [8502 @ $3019]: STX $FF00 ; MMU_CR_TOP
    .BYTE $8E, $1A, $D0                    ; $0D3E [8502 @ $301C]: STX $D01A ; VIC_IRQMSK
    .BYTE $A2, $63                         ; $0D41 [8502 @ $301F]: LDX #$63
    .BYTE $A0, $31                         ; $0D43 [8502 @ $3021]: LDY #$31
    .BYTE $8E, $14, $03                    ; $0D45 [8502 @ $3023]: STX $0314 ; CINV
    .BYTE $8C, $15, $03                    ; $0D48 [8502 @ $3026]: STY $0315
    .BYTE $8E, $16, $03                    ; $0D4B [8502 @ $3029]: STX $0316 ; CBINV
    .BYTE $8C, $17, $03                    ; $0D4E [8502 @ $302C]: STY $0317
    .BYTE $8E, $18, $03                    ; $0D51 [8502 @ $302F]: STX $0318 ; NMINV
    .BYTE $8C, $19, $03                    ; $0D54 [8502 @ $3032]: STY $0319
    .BYTE $4C, $D7, $30                    ; $0D57 [8502 @ $3035]: JMP $30D7
    .BYTE $AD, $18, $FD                    ; $0D5A [8502 @ $3038]: LDA $FD18
    .BYTE $85, $20                         ; $0D5D [8502 @ $303B]: STA $20
    .BYTE $AD, $19, $FD                    ; $0D5F [8502 @ $303D]: LDA $FD19
    .BYTE $85, $21                         ; $0D62 [8502 @ $3040]: STA $21
    .BYTE $AD, $03, $FD                    ; $0D64 [8502 @ $3042]: LDA $FD03
    .BYTE $8D, $BF, $31                    ; $0D67 [8502 @ $3045]: STA $31BF
    .BYTE $20, $78, $31                    ; $0D6A [8502 @ $3048]: JSR $3178
    .BYTE $8E, $B1, $31                    ; $0D6D [8502 @ $304B]: STX $31B1
    .BYTE $8D, $B0, $31                    ; $0D70 [8502 @ $304E]: STA $31B0
    .BYTE $AD, $04, $FD                    ; $0D73 [8502 @ $3051]: LDA $FD04
    .BYTE $8D, $BE, $31                    ; $0D76 [8502 @ $3054]: STA $31BE
    .BYTE $20, $78, $31                    ; $0D79 [8502 @ $3057]: JSR $3178
    .BYTE $8E, $AE, $31                    ; $0D7C [8502 @ $305A]: STX $31AE
    .BYTE $8D, $AD, $31                    ; $0D7F [8502 @ $305D]: STA $31AD
    .BYTE $AD, $08, $FD                    ; $0D82 [8502 @ $3060]: LDA $FD08
    .BYTE $D0, $2B                         ; $0D85 [8502 @ $3063]: BNE $3090
    .BYTE $8D, $00, $FF                    ; $0D87 [8502 @ $3065]: STA $FF00 ; MMU_CR_TOP
    .BYTE $A2, $0B                         ; $0D8A [8502 @ $3068]: LDX #$0B
    .BYTE $20, $C6, $FF                    ; $0D8C [8502 @ $306A]: JSR $FFC6 ; J_CHKIN
    .BYTE $B0, $16                         ; $0D8F [8502 @ $306D]: BCS $3085
    .BYTE $20, $CC, $FF                    ; $0D91 [8502 @ $306F]: JSR $FFCC ; J_CLRCH
    .BYTE $20, $31, $31                    ; $0D94 [8502 @ $3072]: JSR $3131
    .BYTE $20, $99, $31                    ; $0D97 [8502 @ $3075]: JSR $3199
    .BYTE $A0, $00                         ; $0D9A [8502 @ $3078]: LDY #$00
    .BYTE $20, $CF, $FF                    ; $0D9C [8502 @ $307A]: JSR $FFCF ; J_BASIN
    .BYTE $91, $20                         ; $0D9F [8502 @ $307D]: STA ($20),Y
    .BYTE $C8                              ; $0DA1 [8502 @ $307F]: INY
    .BYTE $D0, $F8                         ; $0DA2 [8502 @ $3080]: BNE $307A
    .BYTE $4C, $CC, $FF                    ; $0DA4 [8502 @ $3082]: JMP $FFCC ; J_CLRCH
    .BYTE $A9, $FF                         ; $0DA7 [8502 @ $3085]: LDA #$FF
    .BYTE $2C, $A9, $0D                    ; $0DA9 [8502 @ $3087]: BIT $0DA9
    .BYTE $8D, $06, $FD                    ; $0DAC [8502 @ $308A]: STA $FD06
    .BYTE $4C, $08, $30                    ; $0DAF [8502 @ $308D]: JMP $3008
    .BYTE $A9, $00                         ; $0DB2 [8502 @ $3090]: LDA #$00
    .BYTE $8D, $00, $FF                    ; $0DB4 [8502 @ $3092]: STA $FF00 ; MMU_CR_TOP
    .BYTE $A2, $0F                         ; $0DB7 [8502 @ $3095]: LDX #$0F
    .BYTE $20, $C9, $FF                    ; $0DB9 [8502 @ $3097]: JSR $FFC9 ; J_CHKOUT
    .BYTE $B0, $EC                         ; $0DBC [8502 @ $309A]: BCS $3088
    .BYTE $A0, $06                         ; $0DBE [8502 @ $309C]: LDY #$06
    .BYTE $B9, $BC, $31                    ; $0DC0 [8502 @ $309E]: LDA $31BC,Y
    .BYTE $20, $D2, $FF                    ; $0DC3 [8502 @ $30A1]: JSR $FFD2 ; J_BSOUT
    .BYTE $88                              ; $0DC6 [8502 @ $30A4]: DEY
    .BYTE $D0, $F7                         ; $0DC7 [8502 @ $30A5]: BNE $309E
    .BYTE $20, $CC, $FF                    ; $0DC9 [8502 @ $30A7]: JSR $FFCC ; J_CLRCH
    .BYTE $2C, $0D, $DC                    ; $0DCC [8502 @ $30AA]: BIT $DC0D ; CIA1_ICR
    .BYTE $AE, $BD, $31                    ; $0DCF [8502 @ $30AD]: LDX $31BD
    .BYTE $20, $4F, $31                    ; $0DD2 [8502 @ $30B0]: JSR $314F
    .BYTE $29, $0E                         ; $0DD5 [8502 @ $30B3]: AND #$0E
    .BYTE $D0, $D1                         ; $0DD7 [8502 @ $30B5]: BNE $3088
    .BYTE $A0, $00                         ; $0DD9 [8502 @ $30B7]: LDY #$00
    .BYTE $20, $4F, $31                    ; $0DDB [8502 @ $30B9]: JSR $314F
    .BYTE $91, $20                         ; $0DDE [8502 @ $30BC]: STA ($20),Y
    .BYTE $C8                              ; $0DE0 [8502 @ $30BE]: INY
    .BYTE $D0, $F8                         ; $0DE1 [8502 @ $30BF]: BNE $30B9
    .BYTE $E6, $21                         ; $0DE3 [8502 @ $30C1]: INC $21
    .BYTE $CA                              ; $0DE5 [8502 @ $30C3]: DEX
    .BYTE $D0, $EA                         ; $0DE6 [8502 @ $30C4]: BNE $30B0
    .BYTE $AD, $00, $DD                    ; $0DE8 [8502 @ $30C6]: LDA $DD00 ; CIA2_PRA
    .BYTE $29, $EF                         ; $0DEB [8502 @ $30C9]: AND #$EF
    .BYTE $8D, $00, $DD                    ; $0DED [8502 @ $30CB]: STA $DD00 ; CIA2_PRA
    .BYTE $60                              ; $0DF0 [8502 @ $30CE]: RTS
    .BYTE $A9, $0F                         ; $0DF1 [8502 @ $30CF]: LDA #$0F
    .BYTE $8D, $06, $FD                    ; $0DF3 [8502 @ $30D1]: STA $FD06
    .BYTE $4C, $08, $30                    ; $0DF6 [8502 @ $30D4]: JMP $3008
    .BYTE $A9, $0F                         ; $0DF9 [8502 @ $30D7]: LDA #$0F
    .BYTE $18                              ; $0DFB [8502 @ $30D9]: CLC
    .BYTE $20, $C3, $FF                    ; $0DFC [8502 @ $30DA]: JSR $FFC3 ; J_CLOSE
    .BYTE $A9, $0F                         ; $0DFF [8502 @ $30DD]: LDA #$0F
    .BYTE $8D, $08, $FD                    ; $0E01 [8502 @ $30DF]: STA $FD08
    .BYTE $A2, $08                         ; $0E04 [8502 @ $30E2]: LDX #$08
    .BYTE $A8                              ; $0E06 [8502 @ $30E4]: TAY
    .BYTE $20, $BA, $FF                    ; $0E07 [8502 @ $30E5]: JSR $FFBA ; J_SETLFS
    .BYTE $A9, $00                         ; $0E0A [8502 @ $30E8]: LDA #$00
    .BYTE $8D, $1C, $0A                    ; $0E0C [8502 @ $30EA]: STA $0A1C
    .BYTE $AA                              ; $0E0F [8502 @ $30ED]: TAX
    .BYTE $20, $68, $FF                    ; $0E10 [8502 @ $30EE]: JSR $FF68 ; J_SETBNK
    .BYTE $A9, $04                         ; $0E13 [8502 @ $30F1]: LDA #$04
    .BYTE $A2, $B8                         ; $0E15 [8502 @ $30F3]: LDX #$B8
    .BYTE $A0, $31                         ; $0E17 [8502 @ $30F5]: LDY #$31
    .BYTE $20, $BD, $FF                    ; $0E19 [8502 @ $30F7]: JSR $FFBD ; J_SETNAM
    .BYTE $20, $C0, $FF                    ; $0E1C [8502 @ $30FA]: JSR $FFC0 ; J_OPEN
    .BYTE $B0, $D0                         ; $0E1F [8502 @ $30FD]: BCS $30CF
    .BYTE $20, $B7, $FF                    ; $0E21 [8502 @ $30FF]: JSR $FFB7 ; J_READST
    .BYTE $2A                              ; $0E24 [8502 @ $3102]: ROL A
    .BYTE $B0, $CA                         ; $0E25 [8502 @ $3103]: BCS $30CF
    .BYTE $2C, $1C, $0A                    ; $0E27 [8502 @ $3105]: BIT $0A1C
    .BYTE $70, $26                         ; $0E2A [8502 @ $3108]: BVS $3130
    .BYTE $A9, $0B                         ; $0E2C [8502 @ $310A]: LDA #$0B
    .BYTE $18                              ; $0E2E [8502 @ $310C]: CLC
    .BYTE $20, $C3, $FF                    ; $0E2F [8502 @ $310D]: JSR $FFC3 ; J_CLOSE
    .BYTE $A9, $0B                         ; $0E32 [8502 @ $3110]: LDA #$0B
    .BYTE $A2, $08                         ; $0E34 [8502 @ $3112]: LDX #$08
    .BYTE $A0, $08                         ; $0E36 [8502 @ $3114]: LDY #$08
    .BYTE $20, $BA, $FF                    ; $0E38 [8502 @ $3116]: JSR $FFBA ; J_SETLFS
    .BYTE $A9, $00                         ; $0E3B [8502 @ $3119]: LDA #$00
    .BYTE $8D, $08, $FD                    ; $0E3D [8502 @ $311B]: STA $FD08
    .BYTE $AA                              ; $0E40 [8502 @ $311E]: TAX
    .BYTE $20, $68, $FF                    ; $0E41 [8502 @ $311F]: JSR $FF68 ; J_SETBNK
    .BYTE $A9, $01                         ; $0E44 [8502 @ $3122]: LDA #$01
    .BYTE $A2, $BC                         ; $0E46 [8502 @ $3124]: LDX #$BC
    .BYTE $A0, $31                         ; $0E48 [8502 @ $3126]: LDY #$31
    .BYTE $20, $BD, $FF                    ; $0E4A [8502 @ $3128]: JSR $FFBD ; J_SETNAM
    .BYTE $20, $C0, $FF                    ; $0E4D [8502 @ $312B]: JSR $FFC0 ; J_OPEN
    .BYTE $B0, $9F                         ; $0E50 [8502 @ $312E]: BCS $30CF
    .BYTE $60                              ; $0E52 [8502 @ $3130]: RTS
    .BYTE $20, $A4, $31                    ; $0E53 [8502 @ $3131]: JSR $31A4
    .BYTE $A0, $0D                         ; $0E56 [8502 @ $3134]: LDY #$0D
    .BYTE $B9, $AB, $31                    ; $0E58 [8502 @ $3136]: LDA $31AB,Y
    .BYTE $20, $D2, $FF                    ; $0E5B [8502 @ $3139]: JSR $FFD2 ; J_BSOUT
    .BYTE $88                              ; $0E5E [8502 @ $313C]: DEY
    .BYTE $D0, $F7                         ; $0E5F [8502 @ $313D]: BNE $3136
    .BYTE $20, $CC, $FF                    ; $0E61 [8502 @ $313F]: JSR $FFCC ; J_CLRCH
    .BYTE $20, $89, $31                    ; $0E64 [8502 @ $3142]: JSR $3189
    .BYTE $F0, $05                         ; $0E67 [8502 @ $3145]: BEQ $314C
    .BYTE $A9, $0D                         ; $0E69 [8502 @ $3147]: LDA #$0D
    .BYTE $8D, $06, $FD                    ; $0E6B [8502 @ $3149]: STA $FD06
    .BYTE $4C, $CC, $FF                    ; $0E6E [8502 @ $314C]: JMP $FFCC ; J_CLRCH
    .BYTE $78                              ; $0E71 [8502 @ $314F]: SEI
    .BYTE $AD, $00, $DD                    ; $0E72 [8502 @ $3150]: LDA $DD00 ; CIA2_PRA
    .BYTE $49, $10                         ; $0E75 [8502 @ $3153]: EOR #$10
    .BYTE $8D, $00, $DD                    ; $0E77 [8502 @ $3155]: STA $DD00 ; CIA2_PRA
    .BYTE $A9, $08                         ; $0E7A [8502 @ $3158]: LDA #$08
    .BYTE $2C, $0D, $DC                    ; $0E7C [8502 @ $315A]: BIT $DC0D ; CIA1_ICR
    .BYTE $F0, $FB                         ; $0E7F [8502 @ $315D]: BEQ $315A
    .BYTE $AD, $0C, $DC                    ; $0E81 [8502 @ $315F]: LDA $DC0C
    .BYTE $60                              ; $0E84 [8502 @ $3162]: RTS
    .BYTE $AD, $0D, $DC                    ; $0E85 [8502 @ $3163]: LDA $DC0D ; CIA1_ICR
    .BYTE $AD, $0D, $DD                    ; $0E88 [8502 @ $3166]: LDA $DD0D ; CIA2_ICR
    .BYTE $A9, $0F                         ; $0E8B [8502 @ $3169]: LDA #$0F
    .BYTE $8D, $19, $D0                    ; $0E8D [8502 @ $316B]: STA $D019 ; VIC_VICIRQ
    .BYTE $68                              ; $0E90 [8502 @ $316E]: PLA
    .BYTE $8D, $00, $FF                    ; $0E91 [8502 @ $316F]: STA $FF00 ; MMU_CR_TOP
    .BYTE $68                              ; $0E94 [8502 @ $3172]: PLA
    .BYTE $A8                              ; $0E95 [8502 @ $3173]: TAY
    .BYTE $68                              ; $0E96 [8502 @ $3174]: PLA
    .BYTE $AA                              ; $0E97 [8502 @ $3175]: TAX
    .BYTE $68                              ; $0E98 [8502 @ $3176]: PLA
    .BYTE $40                              ; $0E99 [8502 @ $3177]: RTI
    .BYTE $D8                              ; $0E9A [8502 @ $3178]: CLD
    .BYTE $A2, $30                         ; $0E9B [8502 @ $3179]: LDX #$30
    .BYTE $38                              ; $0E9D [8502 @ $317B]: SEC
    .BYTE $E9, $0A                         ; $0E9E [8502 @ $317C]: SBC #$0A
    .BYTE $90, $03                         ; $0EA0 [8502 @ $317E]: BCC $3183
    .BYTE $E8                              ; $0EA2 [8502 @ $3180]: INX
    .BYTE $B0, $F9                         ; $0EA3 [8502 @ $3181]: BCS $317C
    .BYTE $69, $3A                         ; $0EA5 [8502 @ $3183]: ADC #$3A
    .BYTE $60                              ; $0EA7 [8502 @ $3185]: RTS
    .BYTE $20, $D7, $30                    ; $0EA8 [8502 @ $3186]: JSR $30D7
    .BYTE $A2, $0F                         ; $0EAB [8502 @ $3189]: LDX #$0F
    .BYTE $20, $C6, $FF                    ; $0EAD [8502 @ $318B]: JSR $FFC6 ; J_CHKIN
    .BYTE $B0, $F6                         ; $0EB0 [8502 @ $318E]: BCS $3186
    .BYTE $20, $CF, $FF                    ; $0EB2 [8502 @ $3190]: JSR $FFCF ; J_BASIN
    .BYTE $C9, $30                         ; $0EB5 [8502 @ $3193]: CMP #$30
    .BYTE $60                              ; $0EB7 [8502 @ $3195]: RTS
    .BYTE $20, $0A, $31                    ; $0EB8 [8502 @ $3196]: JSR $310A
    .BYTE $A2, $0B                         ; $0EBB [8502 @ $3199]: LDX #$0B
    .BYTE $20, $C6, $FF                    ; $0EBD [8502 @ $319B]: JSR $FFC6 ; J_CHKIN
    .BYTE $B0, $F6                         ; $0EC0 [8502 @ $319E]: BCS $3196
    .BYTE $60                              ; $0EC2 [8502 @ $31A0]: RTS
    .BYTE $20, $D7, $30                    ; $0EC3 [8502 @ $31A1]: JSR $30D7
    .BYTE $A2, $0F                         ; $0EC6 [8502 @ $31A4]: LDX #$0F
    .BYTE $20, $C9, $FF                    ; $0EC8 [8502 @ $31A6]: JSR $FFC9 ; J_CHKOUT
    .BYTE $B0, $F6                         ; $0ECB [8502 @ $31A9]: BCS $31A1
    .BYTE $60                              ; $0ECD [8502 @ $31AB]: RTS

; --- Embedded MOS 8502 Slave Command Strings ('\rU1:11 0 tt ss\r', 'U0>L\0#', 'U0') ($0ECE-$0EE4) ---
    .BYTE $0D, $73, $73, $20, $74, $74, $20, $30 ; $0ECE |.ss tt 0|
    .BYTE $20, $38, $3A, $31, $55, $30, $4C, $00 ; $0ED6 | 8:1U0L.|
    .BYTE $23, $01, $00, $00, $00, $30, $55      ; $0EDE |#....0U|

; -----------------------------------------------------------------------------
; STUB_8502_SWITCH_TO_Z80 ($0EE5-$0EF4) [Processor Switching | Arch: 8502 | CONFIRMED]
; Entry: Copied to $FFD0-$FFDF ($0EE5)
; Description: 16-byte MOS 8502 half of the shared RAM processor-switch stub ($FFD0-$FFDF): SEI; LDA #$3E; STA $FF00; LDA #$B0; STA $D505; NOP; JMP $3000; NOP.
; Hardware Dependencies: MMU_CR ($FF00), MMU_MCR ($D505)
; -----------------------------------------------------------------------------
STUB_8502_SWITCH_TO_Z80:
; --- Embedded MOS 8502 Shared Handoff Stub (copied to $FFD0-$FFDF) ($0EE5-$0EF4) ---
    .BYTE $78                              ; $0EE5 [8502 @ $FFD0]: SEI
    .BYTE $A9, $3E                         ; $0EE6 [8502 @ $FFD1]: LDA #$3E
    .BYTE $8D, $00, $FF                    ; $0EE8 [8502 @ $FFD3]: STA $FF00 ; MMU_CR_TOP
    .BYTE $A9, $B0                         ; $0EEB [8502 @ $FFD6]: LDA #$B0
    .BYTE $8D, $05, $D5                    ; $0EED [8502 @ $FFD8]: STA $D505 ; MMU_MCR
    .BYTE $EA                              ; $0EF0 [8502 @ $FFDB]: NOP
    .BYTE $4C, $00, $30                    ; $0EF1 [8502 @ $FFDC]: JMP $3000
    .BYTE $EA                              ; $0EF4 [8502 @ $FFDF]: NOP

; -----------------------------------------------------------------------------
; STUB_Z80_SWITCH_TO_8502 ($0EF5-$0F03) [Processor Switching | Arch: Z80 | CONFIRMED]
; Entry: Copied to $FFE0-$FFEF ($0EF5)
; Description: 15-byte Zilog Z80 half of the shared RAM processor-switch stub ($FFE0-$FFEF): DI; LD A,$3E; LD ($FF00),A; LD BC,$D505; LD A,$B1; OUT (C),A; NOP; RST $08 (patched to RET $C9 during CP/M boot).
; Hardware Dependencies: MMU_CR ($FF00), MMU_MCR ($D505)
; -----------------------------------------------------------------------------
STUB_Z80_SWITCH_TO_8502:
    DI                       ; $0EF5: F3
    LD A,$3E                 ; $0EF6: 3E 3E
    LD ($FF00),A             ; $0EF8: 32 00 FF
    LD BC,$D505              ; $0EFB: 01 05 D5
    LD A,$B1                 ; $0EFE: 3E B1
    OUT (C),A                ; $0F00: ED 79
    NOP                      ; $0F02: 00
    RST $08                  ; $0F03: CF
; -----------------------------------------------------------------------------
; BIOS_FONT_COLOR_AND_SID_TABLES ($0F04-$0FA9) [Data Tables | Arch: DATA | CONFIRMED]
; Entry: Data ($0F04-$0FA9)
; Description: Contains color translation table ($0F0A-$0F19), custom 8x8 character glyphs for VDC ($0F1A-$0F61), packed attribute/keyboard tables ($0F62-$0F9F), and SID beep init parameters ($0FA0-$0FA9).
; Hardware Dependencies: None
; -----------------------------------------------------------------------------
BIOS_FONT_COLOR_AND_SID_TABLES:
; --- VDC Color Translation, Custom 8x8 Glyphs, and SID Init Tables ($0F04-$0FA9) ---
    .BYTE $9E, $FF, $BD, $58, $6F, $CE, $00, $0F ; $0F04 |...Xo...|
    .BYTE $08, $07, $0B, $04, $02, $0D, $0A, $0C ; $0F0C |........|
    .BYTE $09, $06, $01, $05, $03, $0E, $00, $60 ; $0F14 |.......`|
    .BYTE $30, $18, $0C, $06, $03, $00, $18, $3C ; $0F1C |0......<|
    .BYTE $66, $00, $00, $00, $00, $00, $00, $00 ; $0F24 |f.......|
    .BYTE $00, $00, $00, $00, $7F, $00, $60, $30 ; $0F2C |......`0|
    .BYTE $18, $00, $00, $00, $00, $00, $1C, $30 ; $0F34 |.......0|
    .BYTE $30, $60, $30, $30, $1C, $00, $18, $18 ; $0F3C |0`00....|
    .BYTE $18, $18, $18, $18, $18, $00, $38, $0C ; $0F44 |......8.|
    .BYTE $0C, $06, $0C, $0C, $38, $00, $00, $1B ; $0F4C |....8...|
    .BYTE $2A, $66, $00, $00, $00, $00, $00, $00 ; $0F54 |*f......|
    .BYTE $00, $00, $00, $41, $7F, $00, $00, $F2 ; $0F5C |...A....|
    .BYTE $5B, $39, $01, $4E, $65, $37, $06, $03 ; $0F64 |[9.Ne7..|
    .BYTE $1E, $07, $0B, $68, $4B, $34, $17, $01 ; $0F6C |...hK4..|
    .BYTE $44, $62, $2D, $18, $12, $0B, $63, $59 ; $0F74 |Db-...cY|
    .BYTE $31, $17, $00, $0B, $59, $72, $2B, $18 ; $0F7C |1...Yr+.|
    .BYTE $0F, $63, $00, $4F, $2B, $05, $4C, $68 ; $0F84 |.c.O+.Lh|
    .BYTE $2D, $17, $16, $69, $49, $25, $17, $13 ; $0F8C |-..iI%..|
    .BYTE $45, $68, $29, $18, $17, $07, $0C, $68 ; $0F94 |Eh)....h|
    .BYTE $4B, $34, $13, $0F, $05, $4B, $70, $31 ; $0F9C |K4...Kp1|
    .BYTE $0D, $0D, $08, $08, $6C, $0D           ; $0FA4 |....l.|

; -----------------------------------------------------------------------------
; MMU_INIT_REGISTER_TABLE ($0FAA-$0FB4) [Data Tables / MMU | Arch: DATA | CONFIRMED]
; Entry: Data ($0FAA-$0FB4)
; Description: 11-byte initial MMU register configuration table copied backwards from $0FB4..$0FAA into $D50A..$D500 ($D500=$3F, $D501=$3F, $D502=$7F, $D503=$3E, $D504=$7E, $D505=$B0, $D506=$0B, $D507=$00, $D508=$00, $D509=$01, $D50A=$00).
; Hardware Dependencies: MMU ($D500-$D50A)
; -----------------------------------------------------------------------------
MMU_INIT_REGISTER_TABLE:
; --- MMU Initial Register Values ($D500-$D50A) ($0FAA-$0FB4) ---
    .BYTE $3F, $3F, $7F, $3E, $7E, $B0, $0B, $00 ; $0FAA |??.>~...|
    .BYTE $00, $01, $00                          ; $0FB2 |...|

; -----------------------------------------------------------------------------
; DISK_GCR_SECTOR_INTERLEAVE_TABLES ($0FB5-$0FFF) [Data Tables / Disk | Arch: DATA | CONFIRMED]
; Entry: Data ($0FB5-$0FFF)
; Description: 75-byte 1541/1571 GCR track zone sector interleave translation tables used by $03E3 (zones with 21, 19, 18, and 17 sectors per track).
; Hardware Dependencies: None
; -----------------------------------------------------------------------------
DISK_GCR_SECTOR_INTERLEAVE_TABLES:
; --- 1541/1571 GCR Sector Interleave Tables (Zones 1-4) ($0FB5-$0FFF) ---
    .BYTE $00, $05, $0A, $0F, $14, $04, $09, $0E ; $0FB5 |........|
    .BYTE $13, $03, $08, $0D, $12, $02, $07, $0C ; $0FBD |........|
    .BYTE $11, $01, $06, $0B, $10, $00, $05, $0A ; $0FC5 |........|
    .BYTE $0F, $01, $06, $0B, $10, $02, $07, $0C ; $0FCD |........|
    .BYTE $11, $03, $08, $0D, $12, $04, $09, $0E ; $0FD5 |........|
    .BYTE $00, $05, $0A, $0F, $02, $07, $0C, $11 ; $0FDD |........|
    .BYTE $04, $09, $0E, $01, $06, $0B, $10, $03 ; $0FE5 |........|
    .BYTE $08, $0D, $00, $05, $0A, $0F, $03, $08 ; $0FED |........|
    .BYTE $0D, $01, $06, $0B, $10, $04, $09, $0E ; $0FF5 |........|
    .BYTE $02, $07, $0C                          ; $0FFD |...|

