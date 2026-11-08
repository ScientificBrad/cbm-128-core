; =============================================================================
; Commodore 128 Z80 BIOS Disassembly ($0000-$0FFF Z80 / $D000-$DFFF U35)
; Source ROM: z80bios.bin / kernal.318020-03.bin [0x1000-0x1FFF] (4096 bytes)
; Architecture: Zilog Z80A
; =============================================================================
    .ARCH Z80
    .ORG $0000

Z80_VEC_0000:
    LD A,$3E                 ; $0000: 3E 3E
    LD ($FF00),A             ; $0002: 32 00 FF
    JP $003B                 ; $0005: C3 3B 00
Z80_VEC_0008:
    LD SP,$3C77              ; $0008: 31 77 3C
    LD A,$3F                 ; $000B: 3E 3F
    JP $018C                 ; $000D: C3 8C 01
Z80_VEC_0010:
    POP HL                   ; $0010: E1
    LD L,(HL)                ; $0011: 6E
    JP $0020                 ; $0012: C3 20 00
    NOP                      ; $0015: 00
    NOP                      ; $0016: 00
    NOP                      ; $0017: 00
Z80_VEC_0018:
    POP HL                   ; $0018: E1
    LD L,(HL)                ; $0019: 6E
    JP $0028                 ; $001A: C3 28 00
    NOP                      ; $001D: 00
    NOP                      ; $001E: 00
    NOP                      ; $001F: 00
Z80_VEC_0020:
    LD A,($FD0F)             ; $0020: 3A 0F FD
    AND A                    ; $0023: A7
    JR Z,$0028               ; $0024: 28 02
    INC L                    ; $0026: 2C
    INC L                    ; $0027: 2C
Z80_VEC_0028:
    LD H,$01                 ; $0028: 26 01
    LD A,(HL)                ; $002A: 7E
    INC HL                   ; $002B: 23
    LD H,(HL)                ; $002C: 66
    LD L,A                   ; $002D: 6F
    JP (HL)                  ; $002E: E9
    NOP                      ; $002F: 00
Z80_VEC_0030:
; --- Z80 BIOS Release Date Stamp ('05/12/85') ($0030-$0037) ---
    .BYTE $30, $35, $2F, $31, $32, $2F, $38, $35 ; $0030 |05/12/85|
Z80_VEC_0038:
    JP $FDFD                 ; $0038: C3 FD FD
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
    LD BC,$DC0F              ; $0059: 01 0F DC
    LD A,$08                 ; $005C: 3E 08
    OUT (C),A                ; $005E: ED 79
    DEC C                    ; $0060: 0D
    OUT (C),A                ; $0061: ED 79
    LD C,$03                 ; $0063: 0E 03
    XOR A                    ; $0065: AF
Z80_VEC_0066:
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
; --- CP/M 3.0 System Filename ('CPM+    SYS') ($00EE-$00F8) ---
    .BYTE $43, $50, $4D, $2B, $20, $20, $20, $20 ; $00EE |CPM+    |
    .BYTE $53, $59, $53                          ; $00F6 |SYS|
    NOP                      ; $00F9: 00
    LD A,H                   ; $00FA: 7C
    CP D                     ; $00FB: BA
    RET NZ                   ; $00FC: C0
    LD A,L                   ; $00FD: 7D
    CP E                     ; $00FE: BB
    RET                      ; $00FF: C9
    ADD A,H                  ; $0100: 84
    LD B,$6E                 ; $0101: 06 6E
    ADD HL,BC                ; $0103: 09
    XOR E                    ; $0104: AB
    LD B,$BC                 ; $0105: 06 BC
    ADD HL,BC                ; $0107: 09
    JP NZ,$DD06              ; $0108: C2 06 DD
    ADD HL,BC                ; $010B: 09
    POP DE                   ; $010C: D1
    LD B,$F1                 ; $010D: 06 F1
    ADD HL,BC                ; $010F: 09
    .BYTE $DD                                ; $0110: DD
    LD B,$31                 ; $0111: 06 31
    LD A,(BC)                ; $0113: 0A
    RET PE                   ; $0114: E8
    LD B,$3C                 ; $0115: 06 3C
    LD A,(BC)                ; $0117: 0A
    POP AF                   ; $0118: F1
    LD B,$45                 ; $0119: 06 45
    LD A,(BC)                ; $011B: 0A
    LD A,D                   ; $011C: 7A
    RLCA                     ; $011D: 07
    LD C,B                   ; $011E: 48
    LD A,(BC)                ; $011F: 0A
    ADD A,B                  ; $0120: 80
    RLCA                     ; $0121: 07
    LD H,D                   ; $0122: 62
    LD A,(BC)                ; $0123: 0A
    SUB C                    ; $0124: 91
    RLCA                     ; $0125: 07
    ADC A,(HL)               ; $0126: 8E
    LD A,(BC)                ; $0127: 0A
    JP Z,$BA07               ; $0128: CA 07 BA
    LD A,(BC)                ; $012B: 0A
    CALL C,$DF07             ; $012C: DC 07 DF
    LD A,(BC)                ; $012F: 0A
    LD E,$08                 ; $0130: 1E 08
    DEC L                    ; $0132: 2D
    DEC BC                   ; $0133: 0B
    DEC DE                   ; $0134: 1B
    RLCA                     ; $0135: 07
    LD A,E                   ; $0136: 7B
    DEC BC                   ; $0137: 0B
    DJNZ $0141               ; $0138: 10 07
    LD H,D                   ; $013A: 62
    DEC BC                   ; $013B: 0B
    INC E                    ; $013C: 1C
    ADD HL,BC                ; $013D: 09
    SUB L                    ; $013E: 95
    ADD HL,BC                ; $013F: 09
    DAA                      ; $0140: 27
    ADD HL,BC                ; $0141: 09
    AND D                    ; $0142: A2
    ADD HL,BC                ; $0143: 09
    LD C,(HL)                ; $0144: 4E
    RLCA                     ; $0145: 07
    XOR (HL)                 ; $0146: AE
    DEC BC                   ; $0147: 0B
    EX DE,HL                 ; $0148: EB
    NOP                      ; $0149: 00
    EX DE,HL                 ; $014A: EB
    NOP                      ; $014B: 00
    EX DE,HL                 ; $014C: EB
    NOP                      ; $014D: 00
    EX DE,HL                 ; $014E: EB
    NOP                      ; $014F: 00
    EX (SP),HL               ; $0150: E3
    INC BC                   ; $0151: 03
    LD L,E                   ; $0152: 6B
    INC B                    ; $0153: 04
    JP M,$EB0C               ; $0154: FA 0C EB
    NOP                      ; $0157: 00
    EX DE,HL                 ; $0158: EB
    NOP                      ; $0159: 00
    EX DE,HL                 ; $015A: EB
    NOP                      ; $015B: 00
    EX DE,HL                 ; $015C: EB
    NOP                      ; $015D: 00
    EX DE,HL                 ; $015E: EB
    NOP                      ; $015F: 00
    INC A                    ; $0160: 3C
    INC C                    ; $0161: 0C
    LD C,D                   ; $0162: 4A
    INC C                    ; $0163: 0C
    RST $08                  ; $0164: CF
    DEC BC                   ; $0165: 0B
    INC C                    ; $0166: 0C
    INC C                    ; $0167: 0C
    LD H,$05                 ; $0168: 26 05
    LD ($2C05),A             ; $016A: 32 05 2C
    DEC B                    ; $016D: 05
    EX DE,HL                 ; $016E: EB
    NOP                      ; $016F: 00
    LD A,A                   ; $0170: 7F
    INC C                    ; $0171: 0C
    JP NZ,$C70C              ; $0172: C2 0C C7
    INC C                    ; $0175: 0C
    CALL PO,$EB0C            ; $0176: E4 0C EB
    NOP                      ; $0179: 00
    DEC A                    ; $017A: 3D
    EX AF,AF'                ; $017B: 08
    XOR (HL)                 ; $017C: AE
    EX AF,AF'                ; $017D: 08
    LD H,B                   ; $017E: 60
    LD B,$C3                 ; $017F: 06 C3
    LD A,(BC)                ; $0181: 0A
    ADD HL,BC                ; $0182: 09
    JP $0933                 ; $0183: C3 33 09
    JP $0953                 ; $0186: C3 53 09
    JP $0945                 ; $0189: C3 45 09
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
    RST $38                  ; $01F3: FF
    ADD A,C                  ; $01F4: 81
    LD A,(BC)                ; $01F5: 0A
; --- Boot Banner ('BOOTING CP/M PLUS') ($01F6-$0206) ---
    .BYTE $42, $4F, $4F, $54, $49, $4E, $47, $20 ; $01F6 |BOOTING |
    .BYTE $43, $50, $2F, $4D, $20, $50, $4C, $55 ; $01FE |CP/M PLU|
    .BYTE $53                                    ; $0206 |S|
    NOP                      ; $0207: 00
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
    ADC A,D                  ; $0240: 8A
    NOP                      ; $0241: 00
    NOP                      ; $0242: 00
    LD HL,$3480              ; $0243: 21 80 34
    CALL $0534               ; $0246: CD 34 05
    LD HL,$3500              ; $0249: 21 00 35
    LD ($3C04),HL            ; $024C: 22 04 3C
    CALL $0526               ; $024F: CD 26 05
    ADD A,E                  ; $0252: 83
    INC C                    ; $0253: 0C
; --- CP/M 3.0 Loader Section Strings ($0254-$02BE) ---
    .BYTE $44, $41, $54, $41, $20, $54, $41, $42 ; $0254 |DATA TAB|
    .BYTE $4C, $45, $53, $00, $2A, $33, $3C, $22 ; $025C |LES.*3<"|
    .BYTE $09, $FD, $21, $32, $3C, $CD, $31, $03 ; $0264 |..!2<.1.|
    .BYTE $22, $0B, $FD, $CD, $44, $03, $11, $80 ; $026C |"...D...|
    .BYTE $00, $19, $20, $F7, $CD, $26, $05, $84 ; $0274 |.. ..&..|
    .BYTE $0C, $43, $4F, $4D, $4D, $4F, $4E, $20 ; $027C |.COMMON |
    .BYTE $43, $4F, $44, $45, $00, $21, $2A, $3C ; $0284 |CODE.!*<|
    .BYTE $CD, $24, $03, $CD, $26, $05, $85, $0C ; $028C |.$..&...|
    .BYTE $42, $41, $4E, $4B, $45, $44, $20, $43 ; $0294 |BANKED C|
    .BYTE $4F, $44, $45, $00, $21, $2C, $3C, $CD ; $029C |ODE.!,<.|
    .BYTE $24, $03, $CD, $26, $05, $86, $0C, $42 ; $02A4 |$..&...B|
    .BYTE $49, $4F, $53, $38, $35, $30, $32, $20 ; $02AC |IOS8502 |
    .BYTE $43, $4F, $44, $45, $00, $21, $30, $3C ; $02B4 |CODE.!0<|
    .BYTE $CD, $24, $03                          ; $02BC |.$.|
    LD A,($3C30)             ; $02BF: 3A 30 3C
    LD B,A                   ; $02C2: 47
    LD A,($3C2F)             ; $02C3: 3A 2F 3C
    SUB B                    ; $02C6: 90
    LD ($FFDE),A             ; $02C7: 32 DE FF
    XOR A                    ; $02CA: AF
    LD ($FFDD),A             ; $02CB: 32 DD FF
    LD HL,($3C2D)            ; $02CE: 2A 2D 3C
    JP (HL)                  ; $02D1: E9
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
    CALL $0526               ; $0480: CD 26 05
    SUB E                    ; $0483: 93
    DEC B                    ; $0484: 05
; --- CP/M 3.0 Loader Error Messages ($0485-$0518) ---
    .BYTE $33, $32, $4B, $20, $4D, $41, $58, $20 ; $0485 |32K MAX |
    .BYTE $43, $50, $4D, $2B, $2E, $53, $59, $53 ; $048D |CPM+.SYS|
    .BYTE $20, $53, $49, $5A, $45, $00, $CF, $3C ; $0495 | SIZE..<|
    .BYTE $28, $FC, $3A, $36, $3C, $3D, $32, $36 ; $049D |(.:6<=26|
    .BYTE $3C, $20, $AC, $CD, $26, $05, $93, $05 ; $04A5 |< ..&...|
    .BYTE $52, $45, $41, $44, $20, $45, $52, $52 ; $04AD |READ ERR|
    .BYTE $4F, $52, $00, $CD, $26, $05, $20, $2D ; $04B5 |OR..&. -|
    .BYTE $20, $48, $49, $54, $20, $52, $45, $54 ; $04BD | HIT RET|
    .BYTE $55, $52, $4E, $20, $54, $4F, $20, $52 ; $04C5 |URN TO R|
    .BYTE $45, $54, $52, $59, $94, $0F, $44, $45 ; $04CD |ETRY..DE|
    .BYTE $4C, $20, $54, $4F, $20, $45, $4E, $54 ; $04D5 |L TO ENT|
    .BYTE $45, $52, $20, $43, $31, $32, $38, $20 ; $04DD |ER C128 |
    .BYTE $4D, $4F, $44, $45, $00, $01, $00, $DC ; $04E5 |MODE....|
    .BYTE $3E, $FE, $ED, $79, $0C, $ED, $78, $E6 ; $04ED |>..y..x.|
    .BYTE $02, $28, $A3, $ED, $78, $E6, $01, $20 ; $04F5 |.(..x.. |
    .BYTE $EC, $C7, $CD, $26, $05, $93, $05, $4E ; $04FD |...&...N|
    .BYTE $4F, $00, $CD, $26, $05, $20, $43, $50 ; $0505 |O..&. CP|
    .BYTE $4D, $2B, $2E, $53, $59, $53, $20, $46 ; $050D |M+.SYS F|
    .BYTE $49, $4C, $45, $00                     ; $0515 |ILE.|
    JR $04B8                 ; $0519: 18 9D
    CALL $0526               ; $051B: CD 26 05
    SUB E                    ; $051E: 93
    DEC B                    ; $051F: 05
    LD B,D                   ; $0520: 42
    LD B,C                   ; $0521: 41
    LD B,H                   ; $0522: 44
    NOP                      ; $0523: 00
    JR $0507                 ; $0524: 18 E1
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
    INC C                    ; $055D: 0C
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
    JR NZ,$0560              ; $0578: 20 E6
    ADD A,B                  ; $057A: 80
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
    INC B                    ; $058B: 04
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
    NOP                      ; $05BC: 00
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
    XOR C                    ; $0D1A: A9
    NOP                      ; $0D1B: 00
    ADC A,L                  ; $0D1C: 8D
    NOP                      ; $0D1D: 00
    RST $38                  ; $0D1E: FF
    LD L,H                   ; $0D1F: 6C
    CALL M,$A9FF             ; $0D20: FC FF A9
    NOP                      ; $0D23: 00
    ADC A,L                  ; $0D24: 8D
    LD B,$FD                 ; $0D25: 06 FD
    JR NZ,$0D3A              ; $0D27: 20 11
    JR NC,$0DA3              ; $0D29: 30 78
    XOR C                    ; $0D2B: A9
    LD A,$8D                 ; $0D2C: 3E 8D
    NOP                      ; $0D2E: 00
    RST $38                  ; $0D2F: FF
    LD C,H                   ; $0D30: 4C
    RET NC                   ; $0D31: D0
    RST $38                  ; $0D32: FF
    RET C                    ; $0D33: D8
    XOR L                    ; $0D34: AD
    LD BC,$D0FD              ; $0D35: 01 FD D0
    LD HL,$00A2              ; $0D38: 21 A2 00
    ADC A,(HL)               ; $0D3B: 8E
    NOP                      ; $0D3C: 00
    RST $38                  ; $0D3D: FF
    ADC A,(HL)               ; $0D3E: 8E
    LD A,(DE)                ; $0D3F: 1A
    RET NC                   ; $0D40: D0
    AND D                    ; $0D41: A2
    LD H,E                   ; $0D42: 63
    AND B                    ; $0D43: A0
    LD SP,$148E              ; $0D44: 31 8E 14
    INC BC                   ; $0D47: 03
    ADC A,H                  ; $0D48: 8C
    DEC D                    ; $0D49: 15
    INC BC                   ; $0D4A: 03
    ADC A,(HL)               ; $0D4B: 8E
    LD D,$03                 ; $0D4C: 16 03
    ADC A,H                  ; $0D4E: 8C
    RLA                      ; $0D4F: 17
    INC BC                   ; $0D50: 03
    ADC A,(HL)               ; $0D51: 8E
    JR $0D57                 ; $0D52: 18 03
    ADC A,H                  ; $0D54: 8C
    ADD HL,DE                ; $0D55: 19
    INC BC                   ; $0D56: 03
    LD C,H                   ; $0D57: 4C
    RST $10                  ; $0D58: D7
    JR NC,$0D08              ; $0D59: 30 AD
    JR $0D5A                 ; $0D5B: 18 FD
    ADD A,L                  ; $0D5D: 85
    JR NZ,$0D0D              ; $0D5E: 20 AD
    ADD HL,DE                ; $0D60: 19
    .BYTE $FD                                ; $0D61: FD
    ADD A,L                  ; $0D62: 85
    LD HL,$03AD              ; $0D63: 21 AD 03
    .BYTE $FD                                ; $0D66: FD
    ADC A,L                  ; $0D67: 8D
    CP A                     ; $0D68: BF
    LD SP,$7820              ; $0D69: 31 20 78
    LD SP,$B18E              ; $0D6C: 31 8E B1
    LD SP,$B08D              ; $0D6F: 31 8D B0
    LD SP,$04AD              ; $0D72: 31 AD 04
    .BYTE $FD                                ; $0D75: FD
    ADC A,L                  ; $0D76: 8D
    CP (HL)                  ; $0D77: BE
    LD SP,$7820              ; $0D78: 31 20 78
    LD SP,$AE8E              ; $0D7B: 31 8E AE
    LD SP,$AD8D              ; $0D7E: 31 8D AD
    LD SP,$08AD              ; $0D81: 31 AD 08
    .BYTE $FD                                ; $0D84: FD
    RET NC                   ; $0D85: D0
    DEC HL                   ; $0D86: 2B
    ADC A,L                  ; $0D87: 8D
    NOP                      ; $0D88: 00
    RST $38                  ; $0D89: FF
    AND D                    ; $0D8A: A2
    DEC BC                   ; $0D8B: 0B
    JR NZ,$0D54              ; $0D8C: 20 C6
    RST $38                  ; $0D8E: FF
    OR B                     ; $0D8F: B0
    LD D,$20                 ; $0D90: 16 20
    CALL Z,$20FF             ; $0D92: CC FF 20
    LD SP,$2031              ; $0D95: 31 31 20
    SBC A,C                  ; $0D98: 99
    LD SP,$00A0              ; $0D99: 31 A0 00
    JR NZ,$0D6D              ; $0D9C: 20 CF
    RST $38                  ; $0D9E: FF
    SUB C                    ; $0D9F: 91
    JR NZ,$0D6A              ; $0DA0: 20 C8
    RET NC                   ; $0DA2: D0
    RET M                    ; $0DA3: F8
    LD C,H                   ; $0DA4: 4C
    CALL Z,$A9FF             ; $0DA5: CC FF A9
    RST $38                  ; $0DA8: FF
    INC L                    ; $0DA9: 2C
    XOR C                    ; $0DAA: A9
    DEC C                    ; $0DAB: 0D
    ADC A,L                  ; $0DAC: 8D
    LD B,$FD                 ; $0DAD: 06 FD
    LD C,H                   ; $0DAF: 4C
    EX AF,AF'                ; $0DB0: 08
    JR NC,$0D5C              ; $0DB1: 30 A9
    NOP                      ; $0DB3: 00
    ADC A,L                  ; $0DB4: 8D
    NOP                      ; $0DB5: 00
    RST $38                  ; $0DB6: FF
    AND D                    ; $0DB7: A2
    RRCA                     ; $0DB8: 0F
    JR NZ,$0D84              ; $0DB9: 20 C9
    RST $38                  ; $0DBB: FF
    OR B                     ; $0DBC: B0
    CALL PE,$06A0            ; $0DBD: EC A0 06
    CP C                     ; $0DC0: B9
    CP H                     ; $0DC1: BC
    LD SP,$D220              ; $0DC2: 31 20 D2
    RST $38                  ; $0DC5: FF
    ADC A,B                  ; $0DC6: 88
    RET NC                   ; $0DC7: D0
    RST $30                  ; $0DC8: F7
    JR NZ,$0D97              ; $0DC9: 20 CC
    RST $38                  ; $0DCB: FF
    INC L                    ; $0DCC: 2C
    DEC C                    ; $0DCD: 0D
    CALL C,$BDAE             ; $0DCE: DC AE BD
    LD SP,$4F20              ; $0DD1: 31 20 4F
    LD SP,$0E29              ; $0DD4: 31 29 0E
    RET NC                   ; $0DD7: D0
    POP DE                   ; $0DD8: D1
    AND B                    ; $0DD9: A0
    NOP                      ; $0DDA: 00
    JR NZ,$0E2C              ; $0DDB: 20 4F
    LD SP,$2091              ; $0DDD: 31 91 20
    RET Z                    ; $0DE0: C8
    RET NC                   ; $0DE1: D0
    RET M                    ; $0DE2: F8
    AND $21                  ; $0DE3: E6 21
    JP Z,$EAD0               ; $0DE5: CA D0 EA
    XOR L                    ; $0DE8: AD
    NOP                      ; $0DE9: 00
    .BYTE $DD                                ; $0DEA: DD
    ADD HL,HL                ; $0DEB: 29
    RST $28                  ; $0DEC: EF
    ADC A,L                  ; $0DED: 8D
    NOP                      ; $0DEE: 00
    .BYTE $DD                                ; $0DEF: DD
    LD H,B                   ; $0DF0: 60
    XOR C                    ; $0DF1: A9
    RRCA                     ; $0DF2: 0F
    ADC A,L                  ; $0DF3: 8D
    LD B,$FD                 ; $0DF4: 06 FD
    LD C,H                   ; $0DF6: 4C
    EX AF,AF'                ; $0DF7: 08
    JR NC,$0DA3              ; $0DF8: 30 A9
    RRCA                     ; $0DFA: 0F
    JR $0E1D                 ; $0DFB: 18 20
    JP $A9FF                 ; $0DFD: C3 FF A9
    RRCA                     ; $0E00: 0F
    ADC A,L                  ; $0E01: 8D
    EX AF,AF'                ; $0E02: 08
    .BYTE $FD                                ; $0E03: FD
    AND D                    ; $0E04: A2
    EX AF,AF'                ; $0E05: 08
    XOR B                    ; $0E06: A8
    JR NZ,$0DC3              ; $0E07: 20 BA
    RST $38                  ; $0E09: FF
    XOR C                    ; $0E0A: A9
    NOP                      ; $0E0B: 00
    ADC A,L                  ; $0E0C: 8D
    INC E                    ; $0E0D: 1C
    LD A,(BC)                ; $0E0E: 0A
    XOR D                    ; $0E0F: AA
    JR NZ,$0E7A              ; $0E10: 20 68
    RST $38                  ; $0E12: FF
    XOR C                    ; $0E13: A9
    INC B                    ; $0E14: 04
    AND D                    ; $0E15: A2
    CP B                     ; $0E16: B8
    AND B                    ; $0E17: A0
    LD SP,$BD20              ; $0E18: 31 20 BD
    RST $38                  ; $0E1B: FF
    JR NZ,$0DDE              ; $0E1C: 20 C0
    RST $38                  ; $0E1E: FF
    OR B                     ; $0E1F: B0
    RET NC                   ; $0E20: D0
    JR NZ,$0DDA              ; $0E21: 20 B7
    RST $38                  ; $0E23: FF
    LD HL,($CAB0)            ; $0E24: 2A B0 CA
    INC L                    ; $0E27: 2C
    INC E                    ; $0E28: 1C
    LD A,(BC)                ; $0E29: 0A
    LD (HL),B                ; $0E2A: 70
    LD H,$A9                 ; $0E2B: 26 A9
    DEC BC                   ; $0E2D: 0B
    JR $0E50                 ; $0E2E: 18 20
    JP $A9FF                 ; $0E30: C3 FF A9
    DEC BC                   ; $0E33: 0B
    AND D                    ; $0E34: A2
    EX AF,AF'                ; $0E35: 08
    AND B                    ; $0E36: A0
    EX AF,AF'                ; $0E37: 08
    JR NZ,$0DF4              ; $0E38: 20 BA
    RST $38                  ; $0E3A: FF
    XOR C                    ; $0E3B: A9
    NOP                      ; $0E3C: 00
    ADC A,L                  ; $0E3D: 8D
    EX AF,AF'                ; $0E3E: 08
    .BYTE $FD                                ; $0E3F: FD
    XOR D                    ; $0E40: AA
    JR NZ,$0EAB              ; $0E41: 20 68
    RST $38                  ; $0E43: FF
    XOR C                    ; $0E44: A9
    LD BC,$BCA2              ; $0E45: 01 A2 BC
    AND B                    ; $0E48: A0
    LD SP,$BD20              ; $0E49: 31 20 BD
    RST $38                  ; $0E4C: FF
    JR NZ,$0E0F              ; $0E4D: 20 C0
    RST $38                  ; $0E4F: FF
    OR B                     ; $0E50: B0
    SBC A,A                  ; $0E51: 9F
    LD H,B                   ; $0E52: 60
    JR NZ,$0DF9              ; $0E53: 20 A4
    LD SP,$0DA0              ; $0E55: 31 A0 0D
    CP C                     ; $0E58: B9
    XOR E                    ; $0E59: AB
    LD SP,$D220              ; $0E5A: 31 20 D2
    RST $38                  ; $0E5D: FF
    ADC A,B                  ; $0E5E: 88
    RET NC                   ; $0E5F: D0
    RST $30                  ; $0E60: F7
    JR NZ,$0E2F              ; $0E61: 20 CC
    RST $38                  ; $0E63: FF
    JR NZ,$0DEF              ; $0E64: 20 89
    LD SP,$05F0              ; $0E66: 31 F0 05
    XOR C                    ; $0E69: A9
    DEC C                    ; $0E6A: 0D
    ADC A,L                  ; $0E6B: 8D
    LD B,$FD                 ; $0E6C: 06 FD
    LD C,H                   ; $0E6E: 4C
    CALL Z,$78FF             ; $0E6F: CC FF 78
    XOR L                    ; $0E72: AD
    NOP                      ; $0E73: 00
    .BYTE $DD                                ; $0E74: DD
    LD C,C                   ; $0E75: 49
    DJNZ $0E05               ; $0E76: 10 8D
    NOP                      ; $0E78: 00
    .BYTE $DD                                ; $0E79: DD
    XOR C                    ; $0E7A: A9
    EX AF,AF'                ; $0E7B: 08
    INC L                    ; $0E7C: 2C
    DEC C                    ; $0E7D: 0D
    CALL C,$FBF0             ; $0E7E: DC F0 FB
    XOR L                    ; $0E81: AD
    INC C                    ; $0E82: 0C
    CALL C,$AD60             ; $0E83: DC 60 AD
    DEC C                    ; $0E86: 0D
    CALL C,$0DAD             ; $0E87: DC AD 0D
    .BYTE $DD                                ; $0E8A: DD
    XOR C                    ; $0E8B: A9
    RRCA                     ; $0E8C: 0F
    ADC A,L                  ; $0E8D: 8D
    ADD HL,DE                ; $0E8E: 19
    RET NC                   ; $0E8F: D0
    LD L,B                   ; $0E90: 68
    ADC A,L                  ; $0E91: 8D
    NOP                      ; $0E92: 00
    RST $38                  ; $0E93: FF
    LD L,B                   ; $0E94: 68
    XOR B                    ; $0E95: A8
    LD L,B                   ; $0E96: 68
    XOR D                    ; $0E97: AA
    LD L,B                   ; $0E98: 68
    LD B,B                   ; $0E99: 40
    RET C                    ; $0E9A: D8
    AND D                    ; $0E9B: A2
    JR NC,$0ED6              ; $0E9C: 30 38
    JP (HL)                  ; $0E9E: E9
    LD A,(BC)                ; $0E9F: 0A
    SUB B                    ; $0EA0: 90
    INC BC                   ; $0EA1: 03
    RET PE                   ; $0EA2: E8
    OR B                     ; $0EA3: B0
    LD SP,HL                 ; $0EA4: F9
    LD L,C                   ; $0EA5: 69
    LD A,($2060)             ; $0EA6: 3A 60 20
    RST $10                  ; $0EA9: D7
    JR NC,$0E4E              ; $0EAA: 30 A2
    RRCA                     ; $0EAC: 0F
    JR NZ,$0E75              ; $0EAD: 20 C6
    RST $38                  ; $0EAF: FF
    OR B                     ; $0EB0: B0
    OR $20                   ; $0EB1: F6 20
    RST $08                  ; $0EB3: CF
    RST $38                  ; $0EB4: FF
    RET                      ; $0EB5: C9
    JR NC,$0F18              ; $0EB6: 30 60
    JR NZ,$0EC4              ; $0EB8: 20 0A
    LD SP,$0BA2              ; $0EBA: 31 A2 0B
    JR NZ,$0E85              ; $0EBD: 20 C6
    RST $38                  ; $0EBF: FF
    OR B                     ; $0EC0: B0
    OR $60                   ; $0EC1: F6 60
    JR NZ,$0E9C              ; $0EC3: 20 D7
    JR NC,$0E69              ; $0EC5: 30 A2
    RRCA                     ; $0EC7: 0F
    JR NZ,$0E93              ; $0EC8: 20 C9
    RST $38                  ; $0ECA: FF
    OR B                     ; $0ECB: B0
    OR $60                   ; $0ECC: F6 60
    DEC C                    ; $0ECE: 0D
    LD (HL),E                ; $0ECF: 73
    LD (HL),E                ; $0ED0: 73
    JR NZ,$0F47              ; $0ED1: 20 74
    LD (HL),H                ; $0ED3: 74
    JR NZ,$0F06              ; $0ED4: 20 30
    JR NZ,$0F10              ; $0ED6: 20 38
    LD A,($5531)             ; $0ED8: 3A 31 55
    JR NC,$0F29              ; $0EDB: 30 4C
    NOP                      ; $0EDD: 00
    INC HL                   ; $0EDE: 23
    LD BC,$0000              ; $0EDF: 01 00 00
    NOP                      ; $0EE2: 00
    JR NC,$0F3A              ; $0EE3: 30 55
    LD A,B                   ; $0EE5: 78
    XOR C                    ; $0EE6: A9
    LD A,$8D                 ; $0EE7: 3E 8D
    NOP                      ; $0EE9: 00
    RST $38                  ; $0EEA: FF
    XOR C                    ; $0EEB: A9
    OR B                     ; $0EEC: B0
    ADC A,L                  ; $0EED: 8D
    DEC B                    ; $0EEE: 05
    PUSH DE                  ; $0EEF: D5
    JP PE,$004C              ; $0EF0: EA 4C 00
    JR NC,$0EDF              ; $0EF3: 30 EA
    DI                       ; $0EF5: F3
    LD A,$3E                 ; $0EF6: 3E 3E
    LD ($FF00),A             ; $0EF8: 32 00 FF
    LD BC,$D505              ; $0EFB: 01 05 D5
    LD A,$B1                 ; $0EFE: 3E B1
    OUT (C),A                ; $0F00: ED 79
    NOP                      ; $0F02: 00
    RST $08                  ; $0F03: CF
    SBC A,(HL)               ; $0F04: 9E
    RST $38                  ; $0F05: FF
    CP L                     ; $0F06: BD
    LD E,B                   ; $0F07: 58
    LD L,A                   ; $0F08: 6F
    ADC A,$00                ; $0F09: CE 00
    RRCA                     ; $0F0B: 0F
    EX AF,AF'                ; $0F0C: 08
    RLCA                     ; $0F0D: 07
    DEC BC                   ; $0F0E: 0B
    INC B                    ; $0F0F: 04
    LD (BC),A                ; $0F10: 02
    DEC C                    ; $0F11: 0D
    LD A,(BC)                ; $0F12: 0A
    INC C                    ; $0F13: 0C
    ADD HL,BC                ; $0F14: 09
    LD B,$01                 ; $0F15: 06 01
    DEC B                    ; $0F17: 05
    INC BC                   ; $0F18: 03
    LD C,$00                 ; $0F19: 0E 00
    LD H,B                   ; $0F1B: 60
    JR NC,$0F36              ; $0F1C: 30 18
    INC C                    ; $0F1E: 0C
    LD B,$03                 ; $0F1F: 06 03
    NOP                      ; $0F21: 00
    JR $0F60                 ; $0F22: 18 3C
    LD H,(HL)                ; $0F24: 66
    NOP                      ; $0F25: 00
    NOP                      ; $0F26: 00
    NOP                      ; $0F27: 00
    NOP                      ; $0F28: 00
    NOP                      ; $0F29: 00
    NOP                      ; $0F2A: 00
    NOP                      ; $0F2B: 00
    NOP                      ; $0F2C: 00
    NOP                      ; $0F2D: 00
    NOP                      ; $0F2E: 00
    NOP                      ; $0F2F: 00
    LD A,A                   ; $0F30: 7F
    NOP                      ; $0F31: 00
    LD H,B                   ; $0F32: 60
    JR NC,$0F4D              ; $0F33: 30 18
    NOP                      ; $0F35: 00
    NOP                      ; $0F36: 00
    NOP                      ; $0F37: 00
    NOP                      ; $0F38: 00
    NOP                      ; $0F39: 00
    INC E                    ; $0F3A: 1C
    JR NC,$0F6D              ; $0F3B: 30 30
    LD H,B                   ; $0F3D: 60
    JR NC,$0F70              ; $0F3E: 30 30
    INC E                    ; $0F40: 1C
    NOP                      ; $0F41: 00
    JR $0F5C                 ; $0F42: 18 18
    JR $0F5E                 ; $0F44: 18 18
    JR $0F60                 ; $0F46: 18 18
    JR $0F4A                 ; $0F48: 18 00
    JR C,$0F58               ; $0F4A: 38 0C
    INC C                    ; $0F4C: 0C
    LD B,$0C                 ; $0F4D: 06 0C
    INC C                    ; $0F4F: 0C
    JR C,$0F52               ; $0F50: 38 00
    NOP                      ; $0F52: 00
    DEC DE                   ; $0F53: 1B
    LD HL,($0066)            ; $0F54: 2A 66 00
    NOP                      ; $0F57: 00
    NOP                      ; $0F58: 00
    NOP                      ; $0F59: 00
    NOP                      ; $0F5A: 00
    NOP                      ; $0F5B: 00
    NOP                      ; $0F5C: 00
    NOP                      ; $0F5D: 00
    NOP                      ; $0F5E: 00
    LD B,C                   ; $0F5F: 41
    LD A,A                   ; $0F60: 7F
    NOP                      ; $0F61: 00
    NOP                      ; $0F62: 00
    JP P,$395B               ; $0F63: F2 5B 39
    LD BC,$654E              ; $0F66: 01 4E 65
    SCF                      ; $0F69: 37
    LD B,$03                 ; $0F6A: 06 03
    LD E,$07                 ; $0F6C: 1E 07
    DEC BC                   ; $0F6E: 0B
    LD L,B                   ; $0F6F: 68
    LD C,E                   ; $0F70: 4B
    INC (HL)                 ; $0F71: 34
    RLA                      ; $0F72: 17
    LD BC,$6244              ; $0F73: 01 44 62
    DEC L                    ; $0F76: 2D
    JR $0F8B                 ; $0F77: 18 12
    DEC BC                   ; $0F79: 0B
    LD H,E                   ; $0F7A: 63
    LD E,C                   ; $0F7B: 59
    LD SP,$0017              ; $0F7C: 31 17 00
    DEC BC                   ; $0F7F: 0B
    LD E,C                   ; $0F80: 59
    LD (HL),D                ; $0F81: 72
    DEC HL                   ; $0F82: 2B
    JR $0F94                 ; $0F83: 18 0F
    LD H,E                   ; $0F85: 63
    NOP                      ; $0F86: 00
    LD C,A                   ; $0F87: 4F
    DEC HL                   ; $0F88: 2B
    DEC B                    ; $0F89: 05
    LD C,H                   ; $0F8A: 4C
    LD L,B                   ; $0F8B: 68
    DEC L                    ; $0F8C: 2D
    RLA                      ; $0F8D: 17
    LD D,$69                 ; $0F8E: 16 69
    LD C,C                   ; $0F90: 49
    DEC H                    ; $0F91: 25
    RLA                      ; $0F92: 17
    INC DE                   ; $0F93: 13
    LD B,L                   ; $0F94: 45
    LD L,B                   ; $0F95: 68
    ADD HL,HL                ; $0F96: 29
    JR $0FB0                 ; $0F97: 18 17
    RLCA                     ; $0F99: 07
    INC C                    ; $0F9A: 0C
    LD L,B                   ; $0F9B: 68
    LD C,E                   ; $0F9C: 4B
    INC (HL)                 ; $0F9D: 34
    INC DE                   ; $0F9E: 13
    RRCA                     ; $0F9F: 0F
    DEC B                    ; $0FA0: 05
    LD C,E                   ; $0FA1: 4B
    LD (HL),B                ; $0FA2: 70
    LD SP,$0D0D              ; $0FA3: 31 0D 0D
    EX AF,AF'                ; $0FA6: 08
    EX AF,AF'                ; $0FA7: 08
    LD L,H                   ; $0FA8: 6C
    DEC C                    ; $0FA9: 0D
    CCF                      ; $0FAA: 3F
    CCF                      ; $0FAB: 3F
    LD A,A                   ; $0FAC: 7F
    LD A,$7E                 ; $0FAD: 3E 7E
    OR B                     ; $0FAF: B0
    DEC BC                   ; $0FB0: 0B
    NOP                      ; $0FB1: 00
    NOP                      ; $0FB2: 00
    LD BC,$0000              ; $0FB3: 01 00 00
    DEC B                    ; $0FB6: 05
    LD A,(BC)                ; $0FB7: 0A
    RRCA                     ; $0FB8: 0F
    INC D                    ; $0FB9: 14
    INC B                    ; $0FBA: 04
    ADD HL,BC                ; $0FBB: 09
    LD C,$13                 ; $0FBC: 0E 13
    INC BC                   ; $0FBE: 03
    EX AF,AF'                ; $0FBF: 08
; --- GCR Disk Sector Interleave Tables ($0FC0-$0FFF) ---
    .BYTE $0D, $12, $02, $07, $0C, $11, $01, $06 ; $0FC0 |........|
    .BYTE $0B, $10, $00, $05, $0A, $0F, $01, $06 ; $0FC8 |........|
    .BYTE $0B, $10, $02, $07, $0C, $11, $03, $08 ; $0FD0 |........|
    .BYTE $0D, $12, $04, $09, $0E, $00, $05, $0A ; $0FD8 |........|
    .BYTE $0F, $02, $07, $0C, $11, $04, $09, $0E ; $0FE0 |........|
    .BYTE $01, $06, $0B, $10, $03, $08, $0D, $00 ; $0FE8 |........|
    .BYTE $05, $0A, $0F, $03, $08, $0D, $01, $06 ; $0FF0 |........|
    .BYTE $0B, $10, $04, $09, $0E, $02, $07, $0C ; $0FF8 |........|
