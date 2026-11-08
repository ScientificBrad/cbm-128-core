; =============================================================================
; Commodore 128 System ROM: Editor, Z80 BIOS & KERNAL (318020-03)
; Source ROM: kernal.318020-03.bin (16384 bytes, $C000-$FFFF)
; Architecture: MOS 8502
; Phase 6 Bit-Exact Reconstructible Assembly Source
; =============================================================================
    .ORG $C000

ED_JCINT:
    JMP   $C07B              ; $C000: 4C 7B C0 (ED_CINT_IMPL)
ED_JDISPLY:
    JMP   $CC34              ; $C003: 4C 34 CC (ED_DISPLY_IMPL)
ED_JLP2:
    JMP   $C234              ; $C006: 4C 34 C2 (ED_LP2_IMPL)
ED_JLOOP5:
    JMP   $C29B              ; $C009: 4C 9B C2 (ED_LOOP5_IMPL)
ED_JPRT:
    JMP   $C72D              ; $C00C: 4C 2D C7 (ED_PRT_IMPL)
ED_JSCRORG:
    JMP   $CC5B              ; $C00F: 4C 5B CC (ED_SCRORG_IMPL)
ED_JSCNKEY:
    JMP   $C55D              ; $C012: 4C 5D C5 (ED_SCNKEY_IMPL)
ED_JREPEAT:
    JMP   $C651              ; $C015: 4C 51 C6 (ED_REPEAT_IMPL)
ED_JPLOT:
    JMP   $CC6A              ; $C018: 4C 6A CC (ED_PLOT_IMPL)
ED_JCURSOR:
    JMP   $CD57              ; $C01B: 4C 57 CD (ED_CURSOR_IMPL)
ED_JESCAPE:
    JMP   $C9C1              ; $C01E: 4C C1 C9 (ED_ESCAPE_IMPL)
ED_JKEYSET:
    JMP   $CCA2              ; $C021: 4C A2 CC (ED_KEYSET_IMPL)
ED_JIRQ:
    JMP   $C194              ; $C024: 4C 94 C1 (ED_IRQ_IMPL)
ED_JINIT80:
    JMP   $CE0C              ; $C027: 4C 0C CE (ED_INIT80_IMPL)
ED_JSWAPPER:
    JMP   $CD2E              ; $C02A: 4C 2E CD (ED_SWAPPER_IMPL)
ED_JWINDOW:
    JMP   $CA1B              ; $C02D: 4C 1B CA (ED_WINDOW_IMPL)
; --- [DATA] Screen Editor Line Address & Default Tab Tables ($C030-$C065) ---
    .BYTE $FF, $FF, $FF, $00, $28, $50, $78, $A0 ; $C030 [IDENTIFIED_DATA] |....(Px.|
    .BYTE $C8, $F0, $18, $40, $68, $90, $B8, $E0 ; $C038 [IDENTIFIED_DATA] |...@h...|
    .BYTE $08, $30, $58, $80, $A8, $D0, $F8, $20 ; $C040 [IDENTIFIED_DATA] |.0X.... |
    .BYTE $48, $70, $98, $C0, $04, $04, $04, $04 ; $C048 [IDENTIFIED_DATA] |Hp......|
    .BYTE $04, $04, $04, $05, $05, $05, $05, $05 ; $C050 [IDENTIFIED_DATA] |........|
    .BYTE $05, $06, $06, $06, $06, $06, $06, $06 ; $C058 [IDENTIFIED_DATA] |........|
    .BYTE $07, $07, $07, $07, $07, $B9           ; $C060 [IDENTIFIED_DATA] |......|
    .BYTE $C7                                ; $C066: C7 [UNRESOLVED]
    ORA   $C8                ; $C067: 05 C8   
    CMP   ($C9,X)            ; $C069: C1 C9   
    SBC   ($C5,X)            ; $C06B: E1 C5   
    LDA   $80C6              ; $C06D: AD C6 80
    .BYTE $FA                                ; $C070: FA [UNRESOLVED]
    CMP   $32FA,Y            ; $C071: D9 FA 32
    .BYTE $FB                                ; $C074: FB [UNRESOLVED]
    .BYTE $8B                                ; $C075: 8B [UNRESOLVED]
    .BYTE $FB                                ; $C076: FB [UNRESOLVED]
    .BYTE $80                                ; $C077: 80 [UNRESOLVED]
    .BYTE $FA                                ; $C078: FA [UNRESOLVED]
    CPX   $FB                ; $C079: E4 FB   
ED_CINT_IMPL:
    LDA   #$03               ; $C07B: A9 03   
    ORA   $DD00              ; $C07D: 0D 00 DD (CIA2_PRA)
    STA   $DD00              ; $C080: 8D 00 DD (CIA2_PRA)
    LDA   #$FB               ; $C083: A9 FB   
    AND   $01                ; $C085: 25 01   
    ORA   #$02               ; $C087: 09 02   
    STA   $01                ; $C089: 85 01   
    JSR   $FFCC              ; $C08B: 20 CC FF (J_CLRCH)
    LDA   #$00               ; $C08E: A9 00   
    STA   $D418              ; $C090: 8D 18 D4
    STA   $D8                ; $C093: 85 D8   
    STA   $D7                ; $C095: 85 D7   
    STA   $D0                ; $C097: 85 D0   
    STA   $D1                ; $C099: 85 D1   
    STA   $D6                ; $C09B: 85 D6   
    STA   $0A21              ; $C09D: 8D 21 0A
    STA   $0A26              ; $C0A0: 8D 26 0A
    STA   $D9                ; $C0A3: 85 D9   
    STA   $0A2E              ; $C0A5: 8D 2E 0A
    LDA   #$14               ; $C0A8: A9 14   
    STA   $0A2C              ; $C0AA: 8D 2C 0A
    LDA   #$78               ; $C0AD: A9 78   
    STA   $0A2D              ; $C0AF: 8D 2D 0A
    LDA   #$08               ; $C0B2: A9 08   
    STA   $0A2F              ; $C0B4: 8D 2F 0A
    LDA   $C04C              ; $C0B7: AD 4C C0
    STA   $0A3B              ; $C0BA: 8D 3B 0A
    LDA   #$0A               ; $C0BD: A9 0A   
    STA   $0A20              ; $C0BF: 8D 20 0A
    STA   $0A28              ; $C0C2: 8D 28 0A
    STA   $0A27              ; $C0C5: 8D 27 0A
    STA   $0A24              ; $C0C8: 8D 24 0A
    LDA   #$04               ; $C0CB: A9 04   
    STA   $0A23              ; $C0CD: 8D 23 0A
    JSR   $C983              ; $C0D0: 20 83 C9
    STA   $0A22              ; $C0D3: 8D 22 0A
    ORA   $D505              ; $C0D6: 0D 05 D5 (MMU_MCR)
    STA   $D505              ; $C0D9: 8D 05 D5 (MMU_MCR)
    LDA   #$60               ; $C0DC: A9 60   
    STA   $0A2B              ; $C0DE: 8D 2B 0A
    LDA   #$D0               ; $C0E1: A9 D0   
    STA   $0A34              ; $C0E3: 8D 34 0A
    LDX   #$1A               ; $C0E6: A2 1A   
    LDA   $CE74,X            ; $C0E8: BD 74 CE
    STA   $E0,X              ; $C0EB: 95 E0   
    LDA   $CE8E,X            ; $C0ED: BD 8E CE
    STA   $0A40,X            ; $C0F0: 9D 40 0A
    DEX                      ; $C0F3: CA      
    BPL   $C0E8              ; $C0F4: 10 F2   
    LDX   #$09               ; $C0F6: A2 09   
    LDA   $C065,X            ; $C0F8: BD 65 C0
    STA   $0334,X            ; $C0FB: 9D 34 03
    DEX                      ; $C0FE: CA      
    BPL   $C0F8              ; $C0FF: 10 F7   
    BIT   $0A04              ; $C101: 2C 04 0A
    BVS   $C124              ; $C104: 70 1E   
    LDX   #$0B               ; $C106: A2 0B   
    LDA   $C06F,X            ; $C108: BD 6F C0
    STA   $033E,X            ; $C10B: 9D 3E 03
    DEX                      ; $C10E: CA      
    BPL   $C108              ; $C10F: 10 F7   
    LDX   #$4C               ; $C111: A2 4C   
    LDA   $CEA8,X            ; $C113: BD A8 CE
    STA   $1000,X            ; $C116: 9D 00 10
    DEX                      ; $C119: CA      
    BPL   $C113              ; $C11A: 10 F7   
    LDA   #$40               ; $C11C: A9 40   
    ORA   $0A04              ; $C11E: 0D 04 0A
    STA   $0A04              ; $C121: 8D 04 0A
    JSR   $CD2E              ; $C124: 20 2E CD (ED_SWAPPER_IMPL)
    JSR   $C983              ; $C127: 20 83 C9
    JSR   $CA24              ; $C12A: 20 24 CA
    JSR   $C142              ; $C12D: 20 42 C1
    JSR   $CD2E              ; $C130: 20 2E CD (ED_SWAPPER_IMPL)
    JSR   $CA24              ; $C133: 20 24 CA
    JSR   $C142              ; $C136: 20 42 C1
    BIT   $D505              ; $C139: 2C 05 D5 (MMU_MCR)
    BMI   $C141              ; $C13C: 30 03   
    JSR   $CD2E              ; $C13E: 20 2E CD (ED_SWAPPER_IMPL)
    RTS                      ; $C141: 60      
    JSR   $C150              ; $C142: 20 50 C1
    JSR   $C15E              ; $C145: 20 5E C1
    JSR   $C4A5              ; $C148: 20 A5 C4
    CPX   $E4                ; $C14B: E4 E4   
    INX                      ; $C14D: E8      
    BCC   $C145              ; $C14E: 90 F5   
    LDX   $E5                ; $C150: A6 E5   
    STX   $EB                ; $C152: 86 EB   
    STX   $E8                ; $C154: 86 E8   
    LDY   $E6                ; $C156: A4 E6   
    STY   $EC                ; $C158: 84 EC   
    STY   $E9                ; $C15A: 84 E9   
    LDX   $EB                ; $C15C: A6 EB   
    LDA   $C033,X            ; $C15E: BD 33 C0
    BIT   $D7                ; $C161: 24 D7   
    BPL   $C166              ; $C163: 10 01   
    ASL   A                  ; $C165: 0A      
    STA   $E0                ; $C166: 85 E0   
    LDA   $C04C,X            ; $C168: BD 4C C0
    AND   #$03               ; $C16B: 29 03   
    BIT   $D7                ; $C16D: 24 D7   
    BPL   $C177              ; $C16F: 10 06   
    ROL   A                  ; $C171: 2A      
    ORA   $0A2E              ; $C172: 0D 2E 0A
    BCC   $C17A              ; $C175: 90 03   
    ORA   $0A3B              ; $C177: 0D 3B 0A
    STA   $E1                ; $C17A: 85 E1   
    LDA   $E0                ; $C17C: A5 E0   
    STA   $E2                ; $C17E: 85 E2   
    LDA   $E1                ; $C180: A5 E1   
    BIT   $D7                ; $C182: 24 D7   
    BPL   $C18D              ; $C184: 10 07   
    AND   #$07               ; $C186: 29 07   
    ORA   $0A2F              ; $C188: 0D 2F 0A
    BNE   $C191              ; $C18B: D0 04   
    AND   #$03               ; $C18D: 29 03   
    ORA   #$D8               ; $C18F: 09 D8   
    STA   $E3                ; $C191: 85 E3   
    RTS                      ; $C193: 60      
ED_IRQ_IMPL:
    SEC                      ; $C194: 38      
    LDA   $D019              ; $C195: AD 19 D0 (VIC_VICIRQ)
    AND   #$01               ; $C198: 29 01   
    BEQ   $C1A3              ; $C19A: F0 07   
    STA   $D019              ; $C19C: 8D 19 D0 (VIC_VICIRQ)
    LDA   $D8                ; $C19F: A5 D8   
    CMP   #$FF               ; $C1A1: C9 FF   
    BEQ   $C214              ; $C1A3: F0 6F   
    BIT   $D011              ; $C1A5: 2C 11 D0 (VIC_SCROLY)
    BMI   $C1AE              ; $C1A8: 30 04   
    AND   #$40               ; $C1AA: 29 40   
    BNE   $C1DF              ; $C1AC: D0 31   
    SEC                      ; $C1AE: 38      
    LDA   $D8                ; $C1AF: A5 D8   
    BEQ   $C1DF              ; $C1B1: F0 2C   
    BIT   $D8                ; $C1B3: 24 D8   
    BVC   $C1BD              ; $C1B5: 50 06   
    LDA   $0A34              ; $C1B7: AD 34 0A
    STA   $D012              ; $C1BA: 8D 12 D0 (VIC_RASTER)
    LDA   $01                ; $C1BD: A5 01   
    AND   #$FD               ; $C1BF: 29 FD   
    ORA   #$04               ; $C1C1: 09 04   
    PHA                      ; $C1C3: 48      
    LDA   $0A2D              ; $C1C4: AD 2D 0A
    PHA                      ; $C1C7: 48      
    LDA   $D011              ; $C1C8: AD 11 D0 (VIC_SCROLY)
    AND   #$7F               ; $C1CB: 29 7F   
    ORA   #$20               ; $C1CD: 09 20   
    TAY                      ; $C1CF: A8      
    LDA   $D016              ; $C1D0: AD 16 D0 (VIC_SCROLX)
    BIT   $D8                ; $C1D3: 24 D8   
    BMI   $C1DA              ; $C1D5: 30 03   
    AND   #$EF               ; $C1D7: 29 EF   
    BIT   $1009              ; $C1D9: 2C 09 10
    TAX                      ; $C1DC: AA      
    BNE   $C207              ; $C1DD: D0 28   
    LDA   #$FF               ; $C1DF: A9 FF   
    STA   $D012              ; $C1E1: 8D 12 D0 (VIC_RASTER)
    LDA   $01                ; $C1E4: A5 01   
    ORA   #$02               ; $C1E6: 09 02   
    AND   #$FB               ; $C1E8: 29 FB   
    ORA   $D9                ; $C1EA: 05 D9   
    PHA                      ; $C1EC: 48      
    LDA   $0A2C              ; $C1ED: AD 2C 0A
    PHA                      ; $C1F0: 48      
    LDA   $D011              ; $C1F1: AD 11 D0 (VIC_SCROLY)
    AND   #$5F               ; $C1F4: 29 5F   
    TAY                      ; $C1F6: A8      
    LDA   $D016              ; $C1F7: AD 16 D0 (VIC_SCROLX)
    AND   #$EF               ; $C1FA: 29 EF   
    TAX                      ; $C1FC: AA      
    BCS   $C207              ; $C1FD: B0 08   
    LDX   #$07               ; $C1FF: A2 07   
    DEX                      ; $C201: CA      
    BNE   $C201              ; $C202: D0 FD   
    NOP                      ; $C204: EA      
    NOP                      ; $C205: EA      
    TAX                      ; $C206: AA      
    PLA                      ; $C207: 68      
    STA   $D018              ; $C208: 8D 18 D0 (VIC_VMCSB)
    PLA                      ; $C20B: 68      
    STA   $01                ; $C20C: 85 01   
    STY   $D011              ; $C20E: 8C 11 D0 (VIC_SCROLY)
    STX   $D016              ; $C211: 8E 16 D0 (VIC_SCROLX)
    BCS   $C229              ; $C214: B0 13   
    LDA   $D030              ; $C216: AD 30 D0 (VIC_CLK2MHZ)
    AND   #$01               ; $C219: 29 01   
    BEQ   $C229              ; $C21B: F0 0C   
    LDA   $D8                ; $C21D: A5 D8   
    AND   #$40               ; $C21F: 29 40   
    BEQ   $C229              ; $C221: F0 06   
    LDA   $D011              ; $C223: AD 11 D0 (VIC_SCROLY)
    BPL   $C229              ; $C226: 10 01   
    SEC                      ; $C228: 38      
    CLI                      ; $C229: 58      
    BCC   $C233              ; $C22A: 90 07   
    JSR   $C55D              ; $C22C: 20 5D C5 (ED_SCNKEY_IMPL)
    JSR   $C6E7              ; $C22F: 20 E7 C6
    SEC                      ; $C232: 38      
    RTS                      ; $C233: 60      
ED_LP2_IMPL:
    LDX   $D1                ; $C234: A6 D1   
    BEQ   $C244              ; $C236: F0 0C   
    LDY   $D2                ; $C238: A4 D2   
    LDA   $100A,Y            ; $C23A: B9 0A 10
    DEC   $D1                ; $C23D: C6 D1   
    INC   $D2                ; $C23F: E6 D2   
    CLI                      ; $C241: 58      
    CLC                      ; $C242: 18      
    RTS                      ; $C243: 60      
    LDY   $034A              ; $C244: AC 4A 03
    LDA   $034B,X            ; $C247: BD 4B 03
    STA   $034A,X            ; $C24A: 9D 4A 03
    INX                      ; $C24D: E8      
    CPX   $D0                ; $C24E: E4 D0   
    BNE   $C247              ; $C250: D0 F5   
    DEC   $D0                ; $C252: C6 D0   
    TYA                      ; $C254: 98      
    CLI                      ; $C255: 58      
    CLC                      ; $C256: 18      
    RTS                      ; $C257: 60      
    JSR   $C72D              ; $C258: 20 2D C7 (ED_PRT_IMPL)
    JSR   $CD6F              ; $C25B: 20 6F CD
    LDA   $D0                ; $C25E: A5 D0   
    ORA   $D1                ; $C260: 05 D1   
    BEQ   $C25E              ; $C262: F0 FA   
    JSR   $CD9F              ; $C264: 20 9F CD
    JSR   $C234              ; $C267: 20 34 C2 (ED_LP2_IMPL)
    CMP   #$0D               ; $C26A: C9 0D   
    BNE   $C258              ; $C26C: D0 EA   
    STA   $D6                ; $C26E: 85 D6   
    LDA   #$00               ; $C270: A9 00   
    STA   $F4                ; $C272: 85 F4   
    JSR   $CBC3              ; $C274: 20 C3 CB
    STX   $0A30              ; $C277: 8E 30 0A
    JSR   $CBB5              ; $C27A: 20 B5 CB
    LDY   $E6                ; $C27D: A4 E6   
    LDA   $E8                ; $C27F: A5 E8   
    BMI   $C296              ; $C281: 30 13   
    CMP   $EB                ; $C283: C5 EB   
    BCC   $C296              ; $C285: 90 0F   
    LDY   $E9                ; $C287: A4 E9   
    CMP   $0A30              ; $C289: CD 30 0A
    BNE   $C292              ; $C28C: D0 04   
    CPY   $EA                ; $C28E: C4 EA   
    BEQ   $C294              ; $C290: F0 02   
    BCS   $C2A5              ; $C292: B0 11   
    STA   $EB                ; $C294: 85 EB   
    STY   $EC                ; $C296: 84 EC   
    JMP   $C2BC              ; $C298: 4C BC C2
ED_LOOP5_IMPL:
    TYA                      ; $C29B: 98      
    PHA                      ; $C29C: 48      
    TXA                      ; $C29D: 8A      
    PHA                      ; $C29E: 48      
    LDA   $D6                ; $C29F: A5 D6   
    BEQ   $C25B              ; $C2A1: F0 B8   
    BPL   $C2BC              ; $C2A3: 10 17   
    LDA   #$00               ; $C2A5: A9 00   
    STA   $D6                ; $C2A7: 85 D6   
    LDA   #$0D               ; $C2A9: A9 0D   
    LDX   #$03               ; $C2AB: A2 03   
    CPX   $99                ; $C2AD: E4 99   
    BEQ   $C2B5              ; $C2AF: F0 04   
    CPX   $9A                ; $C2B1: E4 9A   
    BEQ   $C2B8              ; $C2B3: F0 03   
    JSR   $C72D              ; $C2B5: 20 2D C7 (ED_PRT_IMPL)
    LDA   #$0D               ; $C2B8: A9 0D   
    BNE   $C2F5              ; $C2BA: D0 39   
    JSR   $C15C              ; $C2BC: 20 5C C1
    JSR   $CB58              ; $C2BF: 20 58 CB
    STA   $EF                ; $C2C2: 85 EF   
    AND   #$3F               ; $C2C4: 29 3F   
    ASL   $EF                ; $C2C6: 06 EF   
    BIT   $EF                ; $C2C8: 24 EF   
    BPL   $C2CE              ; $C2CA: 10 02   
    ORA   #$80               ; $C2CC: 09 80   
    BCC   $C2D4              ; $C2CE: 90 04   
    LDX   $F4                ; $C2D0: A6 F4   
    BNE   $C2D8              ; $C2D2: D0 04   
    BVS   $C2D8              ; $C2D4: 70 02   
    ORA   #$40               ; $C2D6: 09 40   
    JSR   $C2FF              ; $C2D8: 20 FF C2
    LDY   $EB                ; $C2DB: A4 EB   
    CPY   $0A30              ; $C2DD: CC 30 0A
    BCC   $C2EC              ; $C2E0: 90 0A   
    LDY   $EC                ; $C2E2: A4 EC   
    CPY   $EA                ; $C2E4: C4 EA   
    BCC   $C2EC              ; $C2E6: 90 04   
    ROR   $D6                ; $C2E8: 66 D6   
    BMI   $C2EF              ; $C2EA: 30 03   
    JSR   $CBED              ; $C2EC: 20 ED CB
    CMP   #$DE               ; $C2EF: C9 DE   
    BNE   $C2F5              ; $C2F1: D0 02   
    LDA   #$FF               ; $C2F3: A9 FF   
    STA   $EF                ; $C2F5: 85 EF   
    PLA                      ; $C2F7: 68      
    TAX                      ; $C2F8: AA      
    PLA                      ; $C2F9: 68      
    TAY                      ; $C2FA: A8      
    LDA   $EF                ; $C2FB: A5 EF   
    CLC                      ; $C2FD: 18      
    RTS                      ; $C2FE: 60      
    CMP   #$22               ; $C2FF: C9 22   
    BNE   $C30B              ; $C301: D0 08   
    LDA   $F4                ; $C303: A5 F4   
    EOR   #$01               ; $C305: 49 01   
    STA   $F4                ; $C307: 85 F4   
    LDA   #$22               ; $C309: A9 22   
    RTS                      ; $C30B: 60      
    LDA   $EF                ; $C30C: A5 EF   
    STA   $F0                ; $C30E: 85 F0   
    JSR   $CD57              ; $C310: 20 57 CD (ED_CURSOR_IMPL)
    LDA   $F5                ; $C313: A5 F5   
    BEQ   $C319              ; $C315: F0 02   
    LSR   $F4                ; $C317: 46 F4   
    PLA                      ; $C319: 68      
    TAY                      ; $C31A: A8      
    PLA                      ; $C31B: 68      
    TAX                      ; $C31C: AA      
    PLA                      ; $C31D: 68      
    CLC                      ; $C31E: 18      
    RTS                      ; $C31F: 60      
    ORA   #$40               ; $C320: 09 40   
    LDX   $F3                ; $C322: A6 F3   
    BEQ   $C328              ; $C324: F0 02   
    ORA   #$80               ; $C326: 09 80   
    LDX   $F5                ; $C328: A6 F5   
    BEQ   $C32E              ; $C32A: F0 02   
    DEC   $F5                ; $C32C: C6 F5   
    BIT   $F6                ; $C32E: 24 F6   
    BPL   $C33B              ; $C330: 10 09   
    PHA                      ; $C332: 48      
    JSR   $C8E3              ; $C333: 20 E3 C8
    LDX   #$00               ; $C336: A2 00   
    STX   $F5                ; $C338: 86 F5   
    PLA                      ; $C33A: 68      
    JSR   $CC2F              ; $C33B: 20 2F CC
    CPY   $E7                ; $C33E: C4 E7   
    BCC   $C34C              ; $C340: 90 0A   
    LDX   $EB                ; $C342: A6 EB   
    CPX   $E4                ; $C344: E4 E4   
    BCC   $C34C              ; $C346: 90 04   
    BIT   $F8                ; $C348: 24 F8   
    BMI   $C362              ; $C34A: 30 16   
    JSR   $C15C              ; $C34C: 20 5C C1
    JSR   $CBED              ; $C34F: 20 ED CB
    BCC   $C362              ; $C352: 90 0E   
    JSR   $CB74              ; $C354: 20 74 CB
    BCS   $C361              ; $C357: B0 08   
    SEC                      ; $C359: 38      
    BIT   $F8                ; $C35A: 24 F8   
    BVS   $C362              ; $C35C: 70 04   
    JSR   $C37C              ; $C35E: 20 7C C3
    CLC                      ; $C361: 18      
    RTS                      ; $C362: 60      
    LDX   $EB                ; $C363: A6 EB   
    CPX   $E4                ; $C365: E4 E4   
    BCC   $C377              ; $C367: 90 0E   
    BIT   $F8                ; $C369: 24 F8   
    BPL   $C373              ; $C36B: 10 06   
    LDA   $E5                ; $C36D: A5 E5   
    STA   $EB                ; $C36F: 85 EB   
    BCS   $C379              ; $C371: B0 06   
    JSR   $C3A6              ; $C373: 20 A6 C3
    CLC                      ; $C376: 18      
    INC   $EB                ; $C377: E6 EB   
    JMP   $C15C              ; $C379: 4C 5C C1
    LDX   $E8                ; $C37C: A6 E8   
    BMI   $C386              ; $C37E: 30 06   
    CPX   $EB                ; $C380: E4 EB   
    BCC   $C386              ; $C382: 90 02   
    INC   $E8                ; $C384: E6 E8   
    LDX   $E4                ; $C386: A6 E4   
    JSR   $C15E              ; $C388: 20 5E C1
    LDY   $E6                ; $C38B: A4 E6   
    CPX   $EB                ; $C38D: E4 EB   
    BEQ   $C3A0              ; $C38F: F0 0F   
    DEX                      ; $C391: CA      
    JSR   $CB76              ; $C392: 20 76 CB
    INX                      ; $C395: E8      
    JSR   $CB83              ; $C396: 20 83 CB
    DEX                      ; $C399: CA      
    JSR   $C40D              ; $C39A: 20 0D C4
    JMP   $C388              ; $C39D: 4C 88 C3
    JSR   $C4A5              ; $C3A0: 20 A5 C4
    JMP   $CB93              ; $C3A3: 4C 93 CB
    LDX   $E5                ; $C3A6: A6 E5   
    INX                      ; $C3A8: E8      
    JSR   $CB76              ; $C3A9: 20 76 CB
    BCC   $C3B8              ; $C3AC: 90 0A   
    CPX   $E4                ; $C3AE: E4 E4   
    BCC   $C3A8              ; $C3B0: 90 F6   
    LDX   $E5                ; $C3B2: A6 E5   
    INX                      ; $C3B4: E8      
    JSR   $CB85              ; $C3B5: 20 85 CB
    DEC   $EB                ; $C3B8: C6 EB   
    BIT   $E8                ; $C3BA: 24 E8   
    BMI   $C3C0              ; $C3BC: 30 02   
    DEC   $E8                ; $C3BE: C6 E8   
    LDX   $E5                ; $C3C0: A6 E5   
    CPX   $DF                ; $C3C2: E4 DF   
    BCS   $C3C8              ; $C3C4: B0 02   
    DEC   $DF                ; $C3C6: C6 DF   
    JSR   $C3DC              ; $C3C8: 20 DC C3
    LDX   $E5                ; $C3CB: A6 E5   
    JSR   $CB76              ; $C3CD: 20 76 CB
    PHP                      ; $C3D0: 08      
    JSR   $CB85              ; $C3D1: 20 85 CB
    PLP                      ; $C3D4: 28      
    BCC   $C3DB              ; $C3D5: 90 04   
    BIT   $F8                ; $C3D7: 24 F8   
    BMI   $C3A6              ; $C3D9: 30 CB   
    RTS                      ; $C3DB: 60      
    JSR   $C15E              ; $C3DC: 20 5E C1
    LDY   $E6                ; $C3DF: A4 E6   
    CPX   $E4                ; $C3E1: E4 E4   
    BCS   $C3F4              ; $C3E3: B0 0F   
    INX                      ; $C3E5: E8      
    JSR   $CB76              ; $C3E6: 20 76 CB
    DEX                      ; $C3E9: CA      
    JSR   $CB83              ; $C3EA: 20 83 CB
    INX                      ; $C3ED: E8      
    JSR   $C40D              ; $C3EE: 20 0D C4
    JMP   $C3DC              ; $C3F1: 4C DC C3
    JSR   $C4A5              ; $C3F4: 20 A5 C4
    LDA   #$7F               ; $C3F7: A9 7F   
    STA   $DC00              ; $C3F9: 8D 00 DC (CIA1_PRA)
    LDA   $DC01              ; $C3FC: AD 01 DC (CIA1_PRB)
    CMP   #$DF               ; $C3FF: C9 DF   
    BNE   $C40C              ; $C401: D0 09   
    LDY   #$00               ; $C403: A0 00   
    NOP                      ; $C405: EA      
    DEX                      ; $C406: CA      
    BNE   $C405              ; $C407: D0 FC   
    DEY                      ; $C409: 88      
    BNE   $C405              ; $C40A: D0 F9   
    RTS                      ; $C40C: 60      
    BIT   $D7                ; $C40D: 24 D7   
    BMI   $C436              ; $C40F: 30 25   
    LDA   $C033,X            ; $C411: BD 33 C0
    STA   $DC                ; $C414: 85 DC   
    STA   $DA                ; $C416: 85 DA   
    LDA   $C04C,X            ; $C418: BD 4C C0
    AND   #$03               ; $C41B: 29 03   
    ORA   $0A3B              ; $C41D: 0D 3B 0A
    STA   $DB                ; $C420: 85 DB   
    AND   #$03               ; $C422: 29 03   
    ORA   #$D8               ; $C424: 09 D8   
    STA   $DD                ; $C426: 85 DD   
    LDA   ($DA),Y            ; $C428: B1 DA   
    STA   ($E0),Y            ; $C42A: 91 E0   
    LDA   ($DC),Y            ; $C42C: B1 DC   
    STA   ($E2),Y            ; $C42E: 91 E2   
    CPY   $E7                ; $C430: C4 E7   
    INY                      ; $C432: C8      
    BCC   $C428              ; $C433: 90 F3   
    RTS                      ; $C435: 60      
    STX   $0A31              ; $C436: 8E 31 0A
    STY   $0A32              ; $C439: 8C 32 0A
    LDX   #$18               ; $C43C: A2 18   
    JSR   $CDDA              ; $C43E: 20 DA CD
    ORA   #$80               ; $C441: 09 80   
    JSR   $CDCC              ; $C443: 20 CC CD
    JSR   $CDE6              ; $C446: 20 E6 CD
    LDX   $0A31              ; $C449: AE 31 0A
    LDA   $C033,X            ; $C44C: BD 33 C0
    ASL   A                  ; $C44F: 0A      
    STA   $DA                ; $C450: 85 DA   
    LDA   $C04C,X            ; $C452: BD 4C C0
    AND   #$03               ; $C455: 29 03   
    ROL   A                  ; $C457: 2A      
    ORA   $0A2E              ; $C458: 0D 2E 0A
    STA   $DB                ; $C45B: 85 DB   
    LDX   #$20               ; $C45D: A2 20   
    CLC                      ; $C45F: 18      
    TYA                      ; $C460: 98      
    ADC   $DA                ; $C461: 65 DA   
    STA   $DA                ; $C463: 85 DA   
    LDA   #$00               ; $C465: A9 00   
    ADC   $DB                ; $C467: 65 DB   
    STA   $DB                ; $C469: 85 DB   
    JSR   $CDCC              ; $C46B: 20 CC CD
    INX                      ; $C46E: E8      
    LDA   $DA                ; $C46F: A5 DA   
    JSR   $CDCC              ; $C471: 20 CC CD
    SEC                      ; $C474: 38      
    LDX   $E7                ; $C475: A6 E7   
    INX                      ; $C477: E8      
    TXA                      ; $C478: 8A      
    SBC   $0A32              ; $C479: ED 32 0A
    STA   $0A32              ; $C47C: 8D 32 0A
    LDX   #$1E               ; $C47F: A2 1E   
    JSR   $CDCC              ; $C481: 20 CC CD
    LDX   #$20               ; $C484: A2 20   
    LDA   $DB                ; $C486: A5 DB   
    AND   #$07               ; $C488: 29 07   
    ORA   $0A2F              ; $C48A: 0D 2F 0A
    JSR   $CDCC              ; $C48D: 20 CC CD
    INX                      ; $C490: E8      
    LDA   $DA                ; $C491: A5 DA   
    JSR   $CDCC              ; $C493: 20 CC CD
    JSR   $CDF9              ; $C496: 20 F9 CD
    LDA   $0A32              ; $C499: AD 32 0A
    LDX   #$1E               ; $C49C: A2 1E   
    JSR   $CDCC              ; $C49E: 20 CC CD
    LDX   $0A31              ; $C4A1: AE 31 0A
    RTS                      ; $C4A4: 60      
    LDY   $E6                ; $C4A5: A4 E6   
    JSR   $CB85              ; $C4A7: 20 85 CB
    JSR   $C15E              ; $C4AA: 20 5E C1
    BIT   $D7                ; $C4AD: 24 D7   
    BMI   $C4C0              ; $C4AF: 30 0F   
    DEY                      ; $C4B1: 88      
    INY                      ; $C4B2: C8      
    LDA   #$20               ; $C4B3: A9 20   
    STA   ($E0),Y            ; $C4B5: 91 E0   
    LDA   $F1                ; $C4B7: A5 F1   
    STA   ($E2),Y            ; $C4B9: 91 E2   
    CPY   $E7                ; $C4BB: C4 E7   
    BNE   $C4B2              ; $C4BD: D0 F3   
    RTS                      ; $C4BF: 60      
    STX   $0A31              ; $C4C0: 8E 31 0A
    STY   $0A32              ; $C4C3: 8C 32 0A
    LDX   #$18               ; $C4C6: A2 18   
    JSR   $CDDA              ; $C4C8: 20 DA CD
    AND   #$7F               ; $C4CB: 29 7F   
    JSR   $CDCC              ; $C4CD: 20 CC CD
    LDX   #$12               ; $C4D0: A2 12   
    CLC                      ; $C4D2: 18      
    TYA                      ; $C4D3: 98      
    ADC   $E0                ; $C4D4: 65 E0   
    PHA                      ; $C4D6: 48      
    STA   $0A3C              ; $C4D7: 8D 3C 0A
    LDA   #$00               ; $C4DA: A9 00   
    ADC   $E1                ; $C4DC: 65 E1   
    STA   $0A3D              ; $C4DE: 8D 3D 0A
    JSR   $CDCC              ; $C4E1: 20 CC CD
    INX                      ; $C4E4: E8      
    PLA                      ; $C4E5: 68      
    JSR   $CDCC              ; $C4E6: 20 CC CD
    LDA   #$20               ; $C4E9: A9 20   
    JSR   $CDCA              ; $C4EB: 20 CA CD
    SEC                      ; $C4EE: 38      
    LDA   $E7                ; $C4EF: A5 E7   
    SBC   $0A32              ; $C4F1: ED 32 0A
    PHA                      ; $C4F4: 48      
    BEQ   $C50B              ; $C4F5: F0 14   
    TAX                      ; $C4F7: AA      
    SEC                      ; $C4F8: 38      
    ADC   $0A3C              ; $C4F9: 6D 3C 0A
    STA   $0A3C              ; $C4FC: 8D 3C 0A
    LDA   #$00               ; $C4FF: A9 00   
    ADC   $0A3D              ; $C501: 6D 3D 0A
    STA   $0A3D              ; $C504: 8D 3D 0A
    TXA                      ; $C507: 8A      
    JSR   $C53E              ; $C508: 20 3E C5
    LDX   #$12               ; $C50B: A2 12   
    CLC                      ; $C50D: 18      
    TYA                      ; $C50E: 98      
    ADC   $E2                ; $C50F: 65 E2   
    PHA                      ; $C511: 48      
    LDA   #$00               ; $C512: A9 00   
    ADC   $E3                ; $C514: 65 E3   
    JSR   $CDCC              ; $C516: 20 CC CD
    INX                      ; $C519: E8      
    PLA                      ; $C51A: 68      
    JSR   $CDCC              ; $C51B: 20 CC CD
    LDA   $0A3D              ; $C51E: AD 3D 0A
    AND   #$07               ; $C521: 29 07   
    ORA   $0A2F              ; $C523: 0D 2F 0A
    STA   $0A3D              ; $C526: 8D 3D 0A
    LDA   $F1                ; $C529: A5 F1   
    AND   #$8F               ; $C52B: 29 8F   
    JSR   $CDCA              ; $C52D: 20 CA CD
    PLA                      ; $C530: 68      
    BEQ   $C536              ; $C531: F0 03   
    JSR   $C53E              ; $C533: 20 3E C5
    LDX   $0A31              ; $C536: AE 31 0A
    LDY   $E7                ; $C539: A4 E7   
    RTS                      ; $C53B: 60      
    LDA   #$01               ; $C53C: A9 01   
    LDX   #$1E               ; $C53E: A2 1E   
    JSR   $CDCC              ; $C540: 20 CC CD
    BIT   $D600              ; $C543: 2C 00 D6 (VDC_ADDR_STATUS)
    BPL   $C543              ; $C546: 10 FB   
    LDX   #$12               ; $C548: A2 12   
    JSR   $CDDA              ; $C54A: 20 DA CD
    CMP   $0A3D              ; $C54D: CD 3D 0A
    BCC   $C53C              ; $C550: 90 EA   
    LDX   #$13               ; $C552: A2 13   
    JSR   $CDDA              ; $C554: 20 DA CD
    CMP   $0A3C              ; $C557: CD 3C 0A
    BCC   $C53C              ; $C55A: 90 E0   
    RTS                      ; $C55C: 60      
ED_SCNKEY_IMPL:
    LDA   $01                ; $C55D: A5 01   
    AND   #$40               ; $C55F: 29 40   
    EOR   #$40               ; $C561: 49 40   
    LSR   A                  ; $C563: 4A      
    LSR   A                  ; $C564: 4A      
    STA   $D3                ; $C565: 85 D3   
    LDY   #$58               ; $C567: A0 58   
    STY   $D4                ; $C569: 84 D4   
    LDA   #$00               ; $C56B: A9 00   
    STA   $DC00              ; $C56D: 8D 00 DC (CIA1_PRA)
    STA   $D02F              ; $C570: 8D 2F D0 (VIC_KEYREG)
    LDX   $DC01              ; $C573: AE 01 DC (CIA1_PRB)
    CPX   #$FF               ; $C576: E0 FF   
    BNE   $C57D              ; $C578: D0 03   
    JMP   $C697              ; $C57A: 4C 97 C6
    TAY                      ; $C57D: A8      
    LDA   $033E              ; $C57E: AD 3E 03
    STA   $CC                ; $C581: 85 CC   
    LDA   $033F              ; $C583: AD 3F 03
    STA   $CD                ; $C586: 85 CD   
    LDA   #$FF               ; $C588: A9 FF   
    STA   $D02F              ; $C58A: 8D 2F D0 (VIC_KEYREG)
    ROL   A                  ; $C58D: 2A      
    BIT   $D3                ; $C58E: 24 D3   
    BMI   $C597              ; $C590: 30 05   
    STA   $DC00              ; $C592: 8D 00 DC (CIA1_PRA)
    BPL   $C59A              ; $C595: 10 03   
    STA   $D02F              ; $C597: 8D 2F D0 (VIC_KEYREG)
    LDX   #$08               ; $C59A: A2 08   
    PHA                      ; $C59C: 48      
    LDA   $DC01              ; $C59D: AD 01 DC (CIA1_PRB)
    CMP   $DC01              ; $C5A0: CD 01 DC (CIA1_PRB)
    BNE   $C59D              ; $C5A3: D0 F8   
    LSR   A                  ; $C5A5: 4A      
    BCS   $C5BF              ; $C5A6: B0 17   
    PHA                      ; $C5A8: 48      
    LDA   ($CC),Y            ; $C5A9: B1 CC   
    CMP   #$08               ; $C5AB: C9 08   
    BEQ   $C5B7              ; $C5AD: F0 08   
    CMP   #$05               ; $C5AF: C9 05   
    BCS   $C5BC              ; $C5B1: B0 09   
    CMP   #$03               ; $C5B3: C9 03   
    BEQ   $C5BC              ; $C5B5: F0 05   
    ORA   $D3                ; $C5B7: 05 D3   
    STA   $D3                ; $C5B9: 85 D3   
    BIT   $D484              ; $C5BB: 2C 84 D4
    PLA                      ; $C5BE: 68      
    INY                      ; $C5BF: C8      
    DEX                      ; $C5C0: CA      
    BNE   $C5A5              ; $C5C1: D0 E2   
    CPY   #$59               ; $C5C3: C0 59   
    BCS   $C5D7              ; $C5C5: B0 10   
    PLA                      ; $C5C7: 68      
    SEC                      ; $C5C8: 38      
    ROL   A                  ; $C5C9: 2A      
    BCS   $C58E              ; $C5CA: B0 C2   
    STA   $DC00              ; $C5CC: 8D 00 DC (CIA1_PRA)
    ROL   $D3                ; $C5CF: 26 D3   
    SEC                      ; $C5D1: 38      
    ROR   $D3                ; $C5D2: 66 D3   
    ROL   A                  ; $C5D4: 2A      
    BNE   $C58E              ; $C5D5: D0 B7   
    ASL   $D3                ; $C5D7: 06 D3   
    LSR   $D3                ; $C5D9: 46 D3   
    PLA                      ; $C5DB: 68      
    LDA   $D4                ; $C5DC: A5 D4   
    JMP   ($033A)            ; $C5DE: 6C 3A 03
    CMP   #$57               ; $C5E1: C9 57   
    BNE   $C5F8              ; $C5E3: D0 13   
    BIT   $F7                ; $C5E5: 24 F7   
    BVS   $C643              ; $C5E7: 70 5A   
    LDA   $0A25              ; $C5E9: AD 25 0A
    BNE   $C643              ; $C5EC: D0 55   
    LDA   #$0D               ; $C5EE: A9 0D   
    EOR   $0A21              ; $C5F0: 4D 21 0A
    STA   $0A21              ; $C5F3: 8D 21 0A
    BVC   $C628              ; $C5F6: 50 30   
    LDA   $D3                ; $C5F8: A5 D3   
    BEQ   $C651              ; $C5FA: F0 55    (ED_REPEAT_IMPL)
    CMP   #$10               ; $C5FC: C9 10   
    BEQ   $C644              ; $C5FE: F0 44   
    CMP   #$08               ; $C600: C9 08   
    BEQ   $C646              ; $C602: F0 42   
    AND   #$07               ; $C604: 29 07   
    CMP   #$03               ; $C606: C9 03   
    BNE   $C62F              ; $C608: D0 25   
    LDA   $F7                ; $C60A: A5 F7   
    BMI   $C651              ; $C60C: 30 43    (ED_REPEAT_IMPL)
    LDA   $0A25              ; $C60E: AD 25 0A
    BNE   $C651              ; $C611: D0 3E    (ED_REPEAT_IMPL)
    BIT   $D7                ; $C613: 24 D7   
    BPL   $C620              ; $C615: 10 09   
    LDA   $F1                ; $C617: A5 F1   
    EOR   #$80               ; $C619: 49 80   
    STA   $F1                ; $C61B: 85 F1   
    JMP   $C628              ; $C61D: 4C 28 C6
    LDA   $0A2C              ; $C620: AD 2C 0A
    EOR   #$02               ; $C623: 49 02   
    STA   $0A2C              ; $C625: 8D 2C 0A
    LDA   #$08               ; $C628: A9 08   
    STA   $0A25              ; $C62A: 8D 25 0A
    BNE   $C651              ; $C62D: D0 22    (ED_REPEAT_IMPL)
    ASL   A                  ; $C62F: 0A      
    CMP   #$08               ; $C630: C9 08   
    BCC   $C646              ; $C632: 90 12   
    LDA   #$06               ; $C634: A9 06   
    LDX   $D4                ; $C636: A6 D4   
    CPX   #$0D               ; $C638: E0 0D   
    BNE   $C646              ; $C63A: D0 0A   
    BIT   $F7                ; $C63C: 24 F7   
    BVS   $C646              ; $C63E: 70 06   
    STX   $0A21              ; $C640: 8E 21 0A
    RTS                      ; $C643: 60      
    LDA   #$0A               ; $C644: A9 0A   
    TAX                      ; $C646: AA      
    LDA   $033E,X            ; $C647: BD 3E 03
    STA   $CC                ; $C64A: 85 CC   
    LDA   $033F,X            ; $C64C: BD 3F 03
    STA   $CD                ; $C64F: 85 CD   
ED_REPEAT_IMPL:
    LDY   $D4                ; $C651: A4 D4   
    LDA   ($CC),Y            ; $C653: B1 CC   
    TAX                      ; $C655: AA      
    CPY   $D5                ; $C656: C4 D5   
    BEQ   $C661              ; $C658: F0 07   
    LDY   #$10               ; $C65A: A0 10   
    STY   $0A24              ; $C65C: 8C 24 0A
    BNE   $C697              ; $C65F: D0 36   
    AND   #$7F               ; $C661: 29 7F   
    BIT   $0A22              ; $C663: 2C 22 0A
    BMI   $C67E              ; $C666: 30 16   
    BVS   $C6C4              ; $C668: 70 5A   
    CMP   #$7F               ; $C66A: C9 7F   
    BEQ   $C697              ; $C66C: F0 29   
    CMP   #$14               ; $C66E: C9 14   
    BEQ   $C67E              ; $C670: F0 0C   
    CMP   #$20               ; $C672: C9 20   
    BEQ   $C67E              ; $C674: F0 08   
    CMP   #$1D               ; $C676: C9 1D   
    BEQ   $C67E              ; $C678: F0 04   
    CMP   #$11               ; $C67A: C9 11   
    BNE   $C6C4              ; $C67C: D0 46   
    LDY   $0A24              ; $C67E: AC 24 0A
    BEQ   $C688              ; $C681: F0 05   
    DEC   $0A24              ; $C683: CE 24 0A
    BNE   $C6C4              ; $C686: D0 3C   
    DEC   $0A23              ; $C688: CE 23 0A
    BNE   $C6C4              ; $C68B: D0 37   
    LDY   #$04               ; $C68D: A0 04   
    STY   $0A23              ; $C68F: 8C 23 0A
    LDY   $D0                ; $C692: A4 D0   
    DEY                      ; $C694: 88      
    BPL   $C6C4              ; $C695: 10 2D   
    LSR   $0A25              ; $C697: 4E 25 0A
    LDY   $D4                ; $C69A: A4 D4   
    STY   $D5                ; $C69C: 84 D5   
    CPX   #$FF               ; $C69E: E0 FF   
    BEQ   $C6C4              ; $C6A0: F0 22   
    LDA   #$00               ; $C6A2: A9 00   
    STA   $0A21              ; $C6A4: 8D 21 0A
    TXA                      ; $C6A7: 8A      
    LDX   $D3                ; $C6A8: A6 D3   
    JMP   ($033C)            ; $C6AA: 6C 3C 03
    LDX   #$09               ; $C6AD: A2 09   
    CMP   $C6DD,X            ; $C6AF: DD DD C6
    BEQ   $C6CA              ; $C6B2: F0 16   
    DEX                      ; $C6B4: CA      
    BPL   $C6AF              ; $C6B5: 10 F8   
    LDX   $D0                ; $C6B7: A6 D0   
    CPX   $0A20              ; $C6B9: EC 20 0A
    BCS   $C6C4              ; $C6BC: B0 06   
    STA   $034A,X            ; $C6BE: 9D 4A 03
    INX                      ; $C6C1: E8      
    STX   $D0                ; $C6C2: 86 D0   
    LDA   #$7F               ; $C6C4: A9 7F   
    STA   $DC00              ; $C6C6: 8D 00 DC (CIA1_PRA)
    RTS                      ; $C6C9: 60      
    LDA   $1000,X            ; $C6CA: BD 00 10
    STA   $D1                ; $C6CD: 85 D1   
    LDA   #$00               ; $C6CF: A9 00   
    DEX                      ; $C6D1: CA      
    BMI   $C6DA              ; $C6D2: 30 06   
    CLC                      ; $C6D4: 18      
    ADC   $1000,X            ; $C6D5: 7D 00 10
    BCC   $C6D1              ; $C6D8: 90 F7   
    STA   $D2                ; $C6DA: 85 D2   
    RTS                      ; $C6DC: 60      
    STA   $89                ; $C6DD: 85 89   
    STX   $8A                ; $C6DF: 86 8A   
    .BYTE $87                                ; $C6E1: 87 [UNRESOLVED]
    .BYTE $8B                                ; $C6E2: 8B [UNRESOLVED]
    DEY                      ; $C6E3: 88      
    STY   $8483              ; $C6E4: 8C 83 84
    BIT   $D7                ; $C6E7: 24 D7   
    BMI   $C72C              ; $C6E9: 30 41   
    LDA   $0A27              ; $C6EB: AD 27 0A
    BNE   $C72C              ; $C6EE: D0 3C   
    DEC   $0A28              ; $C6F0: CE 28 0A
    BNE   $C72C              ; $C6F3: D0 37   
    LDA   $0A26              ; $C6F5: AD 26 0A
    AND   #$C0               ; $C6F8: 29 C0   
    CMP   #$C0               ; $C6FA: C9 C0   
    BEQ   $C72C              ; $C6FC: F0 2E   
    LDA   #$14               ; $C6FE: A9 14   
    STA   $0A28              ; $C700: 8D 28 0A
    LDY   $EC                ; $C703: A4 EC   
    LDX   $0A2A              ; $C705: AE 2A 0A
    LDA   ($E0),Y            ; $C708: B1 E0   
    BIT   $0A26              ; $C70A: 2C 26 0A
    BMI   $C71F              ; $C70D: 30 10   
    STA   $0A29              ; $C70F: 8D 29 0A
    JSR   $C17C              ; $C712: 20 7C C1
    LDA   ($E2),Y            ; $C715: B1 E2   
    STA   $0A2A              ; $C717: 8D 2A 0A
    LDX   $F1                ; $C71A: A6 F1   
    LDA   $0A29              ; $C71C: AD 29 0A
    EOR   #$80               ; $C71F: 49 80   
    JSR   $CC40              ; $C721: 20 40 CC
    LDA   $0A26              ; $C724: AD 26 0A
    EOR   #$80               ; $C727: 49 80   
    STA   $0A26              ; $C729: 8D 26 0A
    RTS                      ; $C72C: 60      
ED_PRT_IMPL:
    STA   $EF                ; $C72D: 85 EF   
    PHA                      ; $C72F: 48      
    TXA                      ; $C730: 8A      
    PHA                      ; $C731: 48      
    TYA                      ; $C732: 98      
    PHA                      ; $C733: 48      
    LDA   $0A21              ; $C734: AD 21 0A
    BNE   $C734              ; $C737: D0 FB   
    STA   $D6                ; $C739: 85 D6   
    LDA   #$C3               ; $C73B: A9 C3   
    PHA                      ; $C73D: 48      
    LDA   #$0B               ; $C73E: A9 0B   
    PHA                      ; $C740: 48      
    LDY   $EC                ; $C741: A4 EC   
    LDA   $EF                ; $C743: A5 EF   
    CMP   #$0D               ; $C745: C9 0D   
    BEQ   $C76F              ; $C747: F0 26   
    CMP   #$8D               ; $C749: C9 8D   
    BEQ   $C76F              ; $C74B: F0 22   
    LDX   $F0                ; $C74D: A6 F0   
    CPX   #$1B               ; $C74F: E0 1B   
    BNE   $C756              ; $C751: D0 03   
    JMP   $C9BE              ; $C753: 4C BE C9
    TAX                      ; $C756: AA      
    BPL   $C75C              ; $C757: 10 03   
    JMP   $C802              ; $C759: 4C 02 C8
    CMP   #$20               ; $C75C: C9 20   
    BCC   $C7B6              ; $C75E: 90 56   
    CMP   #$60               ; $C760: C9 60   
    BCC   $C767              ; $C762: 90 03   
    AND   #$DF               ; $C764: 29 DF   
    BIT   $3F29              ; $C766: 2C 29 3F
    JSR   $C2FF              ; $C769: 20 FF C2
    JMP   $C322              ; $C76C: 4C 22 C3
    JSR   $CBC3              ; $C76F: 20 C3 CB
    INX                      ; $C772: E8      
    JSR   $CB85              ; $C773: 20 85 CB
    LDY   $E6                ; $C776: A4 E6   
    STY   $EC                ; $C778: 84 EC   
    JSR   $C363              ; $C77A: 20 63 C3
    LDA   $F1                ; $C77D: A5 F1   
    AND   #$CF               ; $C77F: 29 CF   
    STA   $F1                ; $C781: 85 F1   
    LDA   #$00               ; $C783: A9 00   
    STA   $F5                ; $C785: 85 F5   
    STA   $F3                ; $C787: 85 F3   
    STA   $F4                ; $C789: 85 F4   
    RTS                      ; $C78B: 60      
    .BYTE $02                                ; $C78C: 02 [UNRESOLVED]
    .BYTE $07                                ; $C78D: 07 [UNRESOLVED]
    ORA   #$0A               ; $C78E: 09 0A   
    .BYTE $0B                                ; $C790: 0B [UNRESOLVED]
    .BYTE $0C                                ; $C791: 0C [UNRESOLVED]
    ASL   $110F              ; $C792: 0E 0F 11
    .BYTE $12                                ; $C795: 12 [UNRESOLVED]
    .BYTE $13                                ; $C796: 13 [UNRESOLVED]
    .BYTE $14                                ; $C797: 14 [UNRESOLVED]
    CLC                      ; $C798: 18      
    ORA   $C8C6,X            ; $C799: 1D C6 C8
    STA   $4EC9              ; $C79C: 8D C9 4E
    CMP   #$B0               ; $C79F: C9 B0   
    CMP   #$A5               ; $C7A1: C9 A5   
    INY                      ; $C7A3: C8      
    .BYTE $AB                                ; $C7A4: AB [UNRESOLVED]
    INY                      ; $C7A5: C8      
    .BYTE $7F                                ; $C7A6: 7F [UNRESOLVED]
    INY                      ; $C7A7: C8      
    .BYTE $D4                                ; $C7A8: D4 [UNRESOLVED]
    INY                      ; $C7A9: C8      
    EOR   $C1C8,Y            ; $C7AA: 59 C8 C1
    INY                      ; $C7AD: C8      
    .BYTE $B2                                ; $C7AE: B2 [UNRESOLVED]
    INY                      ; $C7AF: C8      
    .BYTE $1A                                ; $C7B0: 1A [UNRESOLVED]
    CMP   #$60               ; $C7B1: C9 60   
    CMP   #$53               ; $C7B3: C9 53   
    INY                      ; $C7B5: C8      
    JMP   ($0334)            ; $C7B6: 6C 34 03
    CMP   #$1B               ; $C7B9: C9 1B   
    BEQ   $C7F5              ; $C7BB: F0 38   
    LDX   $F5                ; $C7BD: A6 F5   
    BNE   $C7C9              ; $C7BF: D0 08   
    CMP   #$14               ; $C7C1: C9 14   
    BEQ   $C7D0              ; $C7C3: F0 0B   
    LDX   $F4                ; $C7C5: A6 F4   
    BEQ   $C7D0              ; $C7C7: F0 07   
    LDX   #$00               ; $C7C9: A2 00   
    STX   $EF                ; $C7CB: 86 EF   
    JMP   $C326              ; $C7CD: 4C 26 C3
    LDX   #$0D               ; $C7D0: A2 0D   
    CMP   $C78C,X            ; $C7D2: DD 8C C7
    BEQ   $C7F6              ; $C7D5: F0 1F   
    DEX                      ; $C7D7: CA      
    BPL   $C7D2              ; $C7D8: 10 F8   
    LDX   #$0F               ; $C7DA: A2 0F   
    CMP   $CE4C,X            ; $C7DC: DD 4C CE
    BEQ   $C7E5              ; $C7DF: F0 04   
    DEX                      ; $C7E1: CA      
    BPL   $C7DC              ; $C7E2: 10 F8   
    RTS                      ; $C7E4: 60      
    BIT   $D7                ; $C7E5: 24 D7   
    BMI   $C7EC              ; $C7E7: 30 03   
    STX   $F1                ; $C7E9: 86 F1   
    RTS                      ; $C7EB: 60      
    LDA   $F1                ; $C7EC: A5 F1   
    AND   #$F0               ; $C7EE: 29 F0   
    ORA   $CE5C,X            ; $C7F0: 1D 5C CE
    STA   $F1                ; $C7F3: 85 F1   
    RTS                      ; $C7F5: 60      
    TXA                      ; $C7F6: 8A      
    ASL   A                  ; $C7F7: 0A      
    TAX                      ; $C7F8: AA      
    LDA   $C79B,X            ; $C7F9: BD 9B C7
    PHA                      ; $C7FC: 48      
    LDA   $C79A,X            ; $C7FD: BD 9A C7
    PHA                      ; $C800: 48      
    RTS                      ; $C801: 60      
    JMP   ($0336)            ; $C802: 6C 36 03
    AND   #$7F               ; $C805: 29 7F   
    CMP   #$20               ; $C807: C9 20   
    BCC   $C814              ; $C809: 90 09   
    CMP   #$7F               ; $C80B: C9 7F   
    BNE   $C811              ; $C80D: D0 02   
    LDA   #$5E               ; $C80F: A9 5E   
    JMP   $C320              ; $C811: 4C 20 C3
    LDX   $F4                ; $C814: A6 F4   
    BEQ   $C81D              ; $C816: F0 05   
    ORA   #$40               ; $C818: 09 40   
    JMP   $C326              ; $C81A: 4C 26 C3
    CMP   #$14               ; $C81D: C9 14   
    BNE   $C824              ; $C81F: D0 03   
    JMP   $C8E3              ; $C821: 4C E3 C8
    LDX   $F5                ; $C824: A6 F5   
    BNE   $C818              ; $C826: D0 F0   
    CMP   #$11               ; $C828: C9 11   
    BEQ   $C867              ; $C82A: F0 3B   
    CMP   #$1D               ; $C82C: C9 1D   
    BEQ   $C875              ; $C82E: F0 45   
    CMP   #$0E               ; $C830: C9 0E   
    BEQ   $C892              ; $C832: F0 5E   
    CMP   #$12               ; $C834: C9 12   
    BNE   $C83B              ; $C836: D0 03   
    JMP   $C8BF              ; $C838: 4C BF C8
    CMP   #$02               ; $C83B: C9 02   
    BNE   $C842              ; $C83D: D0 03   
    JMP   $C8CE              ; $C83F: 4C CE C8
    CMP   #$0F               ; $C842: C9 0F   
    BNE   $C849              ; $C844: D0 03   
    JMP   $C8DC              ; $C846: 4C DC C8
    CMP   #$13               ; $C849: C9 13   
    BNE   $C850              ; $C84B: D0 03   
    JMP   $C142              ; $C84D: 4C 42 C1
    ORA   #$80               ; $C850: 09 80   
    BNE   $C7DA              ; $C852: D0 86   
    JSR   $CBED              ; $C854: 20 ED CB
    BCS   $C85D              ; $C857: B0 04   
    RTS                      ; $C859: 60      
    JSR   $C363              ; $C85A: 20 63 C3
    JSR   $CB74              ; $C85D: 20 74 CB
    BCS   $C865              ; $C860: B0 03   
    SEC                      ; $C862: 38      
    ROR   $E8                ; $C863: 66 E8   
    CLC                      ; $C865: 18      
    RTS                      ; $C866: 60      
    LDX   $E5                ; $C867: A6 E5   
    CPX   $EB                ; $C869: E4 EB   
    BCS   $C866              ; $C86B: B0 F9   
    JSR   $C85D              ; $C86D: 20 5D C8
    DEC   $EB                ; $C870: C6 EB   
    JMP   $C15C              ; $C872: 4C 5C C1
    JSR   $CC00              ; $C875: 20 00 CC
    BCS   $C866              ; $C878: B0 EC   
    BNE   $C865              ; $C87A: D0 E9   
    INC   $EB                ; $C87C: E6 EB   
    BNE   $C86D              ; $C87E: D0 ED   
    BIT   $D7                ; $C880: 24 D7   
    BMI   $C88B              ; $C882: 30 07   
    LDA   $0A2C              ; $C884: AD 2C 0A
    ORA   #$02               ; $C887: 09 02   
    BNE   $C89B              ; $C889: D0 10   
    LDA   $F1                ; $C88B: A5 F1   
    ORA   #$80               ; $C88D: 09 80   
    STA   $F1                ; $C88F: 85 F1   
    RTS                      ; $C891: 60      
    BIT   $D7                ; $C892: 24 D7   
    BMI   $C89F              ; $C894: 30 09   
    LDA   $0A2C              ; $C896: AD 2C 0A
    AND   #$FD               ; $C899: 29 FD   
    STA   $0A2C              ; $C89B: 8D 2C 0A
    RTS                      ; $C89E: 60      
    LDA   $F1                ; $C89F: A5 F1   
    AND   #$7F               ; $C8A1: 29 7F   
    STA   $F1                ; $C8A3: 85 F1   
    RTS                      ; $C8A5: 60      
    LDA   #$80               ; $C8A6: A9 80   
    ORA   $F7                ; $C8A8: 05 F7   
    BMI   $C8B0              ; $C8AA: 30 04   
    LDA   #$7F               ; $C8AC: A9 7F   
    AND   $F7                ; $C8AE: 25 F7   
    STA   $F7                ; $C8B0: 85 F7   
    RTS                      ; $C8B2: 60      
    LDA   $F0                ; $C8B3: A5 F0   
    CMP   #$13               ; $C8B5: C9 13   
    BNE   $C8BC              ; $C8B7: D0 03   
    JSR   $CA24              ; $C8B9: 20 24 CA
    JMP   $C150              ; $C8BC: 4C 50 C1
    LDA   #$00               ; $C8BF: A9 00   
    BIT   $80A9              ; $C8C1: 2C A9 80
    STA   $F3                ; $C8C4: 85 F3   
    RTS                      ; $C8C6: 60      
    LDA   $F1                ; $C8C7: A5 F1   
    ORA   #$20               ; $C8C9: 09 20   
    STA   $F1                ; $C8CB: 85 F1   
    RTS                      ; $C8CD: 60      
    LDA   $F1                ; $C8CE: A5 F1   
    AND   #$DF               ; $C8D0: 29 DF   
    STA   $F1                ; $C8D2: 85 F1   
    RTS                      ; $C8D4: 60      
    LDA   $F1                ; $C8D5: A5 F1   
    ORA   #$10               ; $C8D7: 09 10   
    STA   $F1                ; $C8D9: 85 F1   
    RTS                      ; $C8DB: 60      
    LDA   $F1                ; $C8DC: A5 F1   
    AND   #$EF               ; $C8DE: 29 EF   
    STA   $F1                ; $C8E0: 85 F1   
    RTS                      ; $C8E2: 60      
    JSR   $CC1E              ; $C8E3: 20 1E CC
    JSR   $CBC3              ; $C8E6: 20 C3 CB
    CPX   $DF                ; $C8E9: E4 DF   
    BNE   $C8EF              ; $C8EB: D0 02   
    CPY   $DE                ; $C8ED: C4 DE   
    BCC   $C912              ; $C8EF: 90 21   
    JSR   $C33E              ; $C8F1: 20 3E C3
    BCS   $C918              ; $C8F4: B0 22   
    JSR   $CC00              ; $C8F6: 20 00 CC
    JSR   $CB58              ; $C8F9: 20 58 CB
    JSR   $CBED              ; $C8FC: 20 ED CB
    JSR   $CC32              ; $C8FF: 20 32 CC
    JSR   $CC00              ; $C902: 20 00 CC
    LDX   $EB                ; $C905: A6 EB   
    CPX   $DF                ; $C907: E4 DF   
    BNE   $C8F6              ; $C909: D0 EB   
    CPY   $DE                ; $C90B: C4 DE   
    BNE   $C8F6              ; $C90D: D0 E7   
    JSR   $CC27              ; $C90F: 20 27 CC
    INC   $F5                ; $C912: E6 F5   
    BNE   $C918              ; $C914: D0 02   
    DEC   $F5                ; $C916: C6 F5   
    JMP   $C932              ; $C918: 4C 32 C9
    JSR   $C875              ; $C91B: 20 75 C8
    JSR   $CC1E              ; $C91E: 20 1E CC
    BCS   $C932              ; $C921: B0 0F   
    CPY   $E7                ; $C923: C4 E7   
    BCC   $C93D              ; $C925: 90 16   
    LDX   $EB                ; $C927: A6 EB   
    INX                      ; $C929: E8      
    JSR   $CB76              ; $C92A: 20 76 CB
    BCS   $C93D              ; $C92D: B0 0E   
    JSR   $CC27              ; $C92F: 20 27 CC
    LDA   $DE                ; $C932: A5 DE   
    STA   $EC                ; $C934: 85 EC   
    LDA   $DF                ; $C936: A5 DF   
    STA   $EB                ; $C938: 85 EB   
    JMP   $C15C              ; $C93A: 4C 5C C1
    JSR   $CBED              ; $C93D: 20 ED CB
    JSR   $CB58              ; $C940: 20 58 CB
    JSR   $CC00              ; $C943: 20 00 CC
    JSR   $CC32              ; $C946: 20 32 CC
    JSR   $CBED              ; $C949: 20 ED CB
    JMP   $C923              ; $C94C: 4C 23 C9
    LDY   $EC                ; $C94F: A4 EC   
    INY                      ; $C951: C8      
    CPY   $E7                ; $C952: C4 E7   
    BCS   $C95C              ; $C954: B0 06   
    JSR   $C96C              ; $C956: 20 6C C9
    BEQ   $C951              ; $C959: F0 F6   
    BIT   $E7A4              ; $C95B: 2C A4 E7
    STY   $EC                ; $C95E: 84 EC   
    RTS                      ; $C960: 60      
    LDY   $EC                ; $C961: A4 EC   
    JSR   $C96C              ; $C963: 20 6C C9
    EOR   $DA                ; $C966: 45 DA   
    STA   $0354,X            ; $C968: 9D 54 03
    RTS                      ; $C96B: 60      
    TYA                      ; $C96C: 98      
    AND   #$07               ; $C96D: 29 07   
    TAX                      ; $C96F: AA      
    LDA   $CE6C,X            ; $C970: BD 6C CE
    STA   $DA                ; $C973: 85 DA   
    TYA                      ; $C975: 98      
    LSR   A                  ; $C976: 4A      
    LSR   A                  ; $C977: 4A      
    LSR   A                  ; $C978: 4A      
    TAX                      ; $C979: AA      
    LDA   $0354,X            ; $C97A: BD 54 03
    BIT   $DA                ; $C97D: 24 DA   
    RTS                      ; $C97F: 60      
    LDA   #$00               ; $C980: A9 00   
    BIT   $80A9              ; $C982: 2C A9 80
    LDX   #$09               ; $C985: A2 09   
    STA   $0354,X            ; $C987: 9D 54 03
    DEX                      ; $C98A: CA      
    BPL   $C987              ; $C98B: 10 FA   
    RTS                      ; $C98D: 60      
    BIT   $F9                ; $C98E: 24 F9   
    BMI   $C98D              ; $C990: 30 FB   
    LDA   #$15               ; $C992: A9 15   
    STA   $D418              ; $C994: 8D 18 D4
    LDY   #$09               ; $C997: A0 09   
    LDX   #$00               ; $C999: A2 00   
    STY   $D405              ; $C99B: 8C 05 D4
    STX   $D406              ; $C99E: 8E 06 D4
    LDA   #$30               ; $C9A1: A9 30   
    STA   $D401              ; $C9A3: 8D 01 D4
    LDA   #$20               ; $C9A6: A9 20   
    STA   $D404              ; $C9A8: 8D 04 D4
    LDA   #$21               ; $C9AB: A9 21   
    STA   $D404              ; $C9AD: 8D 04 D4
    RTS                      ; $C9B0: 60      
    LDA   $EC                ; $C9B1: A5 EC   
    PHA                      ; $C9B3: 48      
    JSR   $CBC3              ; $C9B4: 20 C3 CB
    JSR   $C363              ; $C9B7: 20 63 C3
    PLA                      ; $C9BA: 68      
    STA   $EC                ; $C9BB: 85 EC   
    RTS                      ; $C9BD: 60      
    JMP   ($0338)            ; $C9BE: 6C 38 03
ED_ESCAPE_IMPL:
    CMP   #$1B               ; $C9C1: C9 1B   
    BNE   $C9CA              ; $C9C3: D0 05   
    LSR   $EF                ; $C9C5: 46 EF   
    JMP   $C77D              ; $C9C7: 4C 7D C7
    AND   #$7F               ; $C9CA: 29 7F   
    SEC                      ; $C9CC: 38      
    SBC   #$40               ; $C9CD: E9 40   
    CMP   #$1B               ; $C9CF: C9 1B   
    BCS   $C9DD              ; $C9D1: B0 0A   
    ASL   A                  ; $C9D3: 0A      
    TAX                      ; $C9D4: AA      
    LDA   $C9DF,X            ; $C9D5: BD DF C9
    PHA                      ; $C9D8: 48      
    LDA   $C9DE,X            ; $C9D9: BD DE C9
    PHA                      ; $C9DC: 48      
    RTS                      ; $C9DD: 60      
    .BYTE $9E                                ; $C9DE: 9E [UNRESOLVED]
    DEX                      ; $C9DF: CA      
    CPX   $15CA              ; $C9E0: EC CA 15
    DEX                      ; $C9E3: CA      
    SBC   #$CA               ; $C9E4: E9 CA   
    EOR   ($CA),Y            ; $C9E6: 51 CA   
    ASL   A                  ; $C9E8: 0A      
    .BYTE $CB                                ; $C9E9: CB [UNRESOLVED]
    JSR   $36CB              ; $C9EA: 20 CB 36
    .BYTE $CB                                ; $C9ED: CB [UNRESOLVED]
    AND   $3CCB,Y            ; $C9EE: 39 CB 3C
    DEX                      ; $C9F1: CA      
    BCS   $C9BF              ; $C9F2: B0 CB   
    EOR   ($CB),Y            ; $C9F4: 51 CB   
    SBC   ($CA,X)            ; $C9F6: E1 CA   
    CPX   $CA                ; $C9F8: E4 CA   
    .BYTE $47                                ; $C9FA: 47 [UNRESOLVED]
    .BYTE $CB                                ; $C9FB: CB [UNRESOLVED]
    .BYTE $7C                                ; $C9FC: 7C [UNRESOLVED]
    .BYTE $C7                                ; $C9FD: C7 [UNRESOLVED]
    TXA                      ; $C9FE: 8A      
    DEX                      ; $C9FF: CA      
    ADC   $CA,X              ; $CA00: 75 CA   
    ROL   $F1CB,X            ; $CA02: 3E CB F1
    DEX                      ; $CA05: CA      
    .BYTE $13                                ; $CA06: 13 [UNRESOLVED]
    DEX                      ; $CA07: CA      
    SBC   $BBCA,X            ; $CA08: FD CA BB
    DEX                      ; $CA0B: CA      
    CMP   #$CA               ; $CA0C: C9 CA   
    .BYTE $2B                                ; $CA0E: 2B [UNRESOLVED]
    CMP   $C982              ; $CA0F: CD 82 C9
    .BYTE $7F                                ; $CA12: 7F [UNRESOLVED]
    CMP   #$18               ; $CA13: C9 18   
    BIT   $38                ; $CA15: 24 38   
    LDX   $EC                ; $CA17: A6 EC   
    LDA   $EB                ; $CA19: A5 EB   
ED_WINDOW_IMPL:
    BCC   $CA2E              ; $CA1B: 90 11   
    STA   $E4                ; $CA1D: 85 E4   
    STX   $E7                ; $CA1F: 86 E7   
    JMP   $CA32              ; $CA21: 4C 32 CA
    LDA   $ED                ; $CA24: A5 ED   
    LDX   $EE                ; $CA26: A6 EE   
    JSR   $CA1D              ; $CA28: 20 1D CA
    LDA   #$00               ; $CA2B: A9 00   
    TAX                      ; $CA2D: AA      
    STA   $E5                ; $CA2E: 85 E5   
    STX   $E6                ; $CA30: 86 E6   
    LDA   #$00               ; $CA32: A9 00   
    LDX   #$04               ; $CA34: A2 04   
    STA   $035D,X            ; $CA36: 9D 5D 03
    DEX                      ; $CA39: CA      
    BNE   $CA36              ; $CA3A: D0 FA   
    RTS                      ; $CA3C: 60      
    JSR   $C37C              ; $CA3D: 20 7C C3
    JSR   $C156              ; $CA40: 20 56 C1
    INX                      ; $CA43: E8      
    JSR   $CB76              ; $CA44: 20 76 CB
    PHP                      ; $CA47: 08      
    JSR   $CB81              ; $CA48: 20 81 CB
    PLP                      ; $CA4B: 28      
    BCS   $CA51              ; $CA4C: B0 03   
    SEC                      ; $CA4E: 38      
    ROR   $E8                ; $CA4F: 66 E8   
    RTS                      ; $CA51: 60      
    JSR   $CBB5              ; $CA52: 20 B5 CB
    LDA   $E5                ; $CA55: A5 E5   
    PHA                      ; $CA57: 48      
    LDA   $EB                ; $CA58: A5 EB   
    STA   $E5                ; $CA5A: 85 E5   
    LDA   $F8                ; $CA5C: A5 F8   
    PHA                      ; $CA5E: 48      
    LDA   #$80               ; $CA5F: A9 80   
    STA   $F8                ; $CA61: 85 F8   
    JSR   $C3B8              ; $CA63: 20 B8 C3
    PLA                      ; $CA66: 68      
    STA   $F8                ; $CA67: 85 F8   
    LDA   $E5                ; $CA69: A5 E5   
    STA   $EB                ; $CA6B: 85 EB   
    PLA                      ; $CA6D: 68      
    STA   $E5                ; $CA6E: 85 E5   
    SEC                      ; $CA70: 38      
    ROR   $E8                ; $CA71: 66 E8   
    JMP   $C156              ; $CA73: 4C 56 C1
    JSR   $CC1E              ; $CA76: 20 1E CC
    JSR   $C4AA              ; $CA79: 20 AA C4
    INC   $EB                ; $CA7C: E6 EB   
    JSR   $C15C              ; $CA7E: 20 5C C1
    LDY   $E6                ; $CA81: A4 E6   
    JSR   $CB74              ; $CA83: 20 74 CB
    BCS   $CA79              ; $CA86: B0 F1   
    JMP   $C932              ; $CA88: 4C 32 C9
    JSR   $CC1E              ; $CA8B: 20 1E CC
    JSR   $CC27              ; $CA8E: 20 27 CC
    CPY   $E6                ; $CA91: C4 E6   
    BNE   $CA9A              ; $CA93: D0 05   
    JSR   $CB74              ; $CA95: 20 74 CB
    BCC   $CA88              ; $CA98: 90 EE   
    JSR   $CC00              ; $CA9A: 20 00 CC
    BCC   $CA8E              ; $CA9D: 90 EF   
    JSR   $CC1E              ; $CA9F: 20 1E CC
    JSR   $C4AA              ; $CAA2: 20 AA C4
    INC   $EB                ; $CAA5: E6 EB   
    JSR   $C15C              ; $CAA7: 20 5C C1
    LDY   $E6                ; $CAAA: A4 E6   
    JSR   $CB74              ; $CAAC: 20 74 CB
    BCS   $CAA2              ; $CAAF: B0 F1   
    LDA   $EB                ; $CAB1: A5 EB   
    CMP   $E4                ; $CAB3: C5 E4   
    BCC   $CAA2              ; $CAB5: 90 EB   
    BEQ   $CAA2              ; $CAB7: F0 E9   
    JMP   $C932              ; $CAB9: 4C 32 C9
    JSR   $CC1E              ; $CABC: 20 1E CC
    TXA                      ; $CABF: 8A      
    PHA                      ; $CAC0: 48      
    JSR   $C3A6              ; $CAC1: 20 A6 C3
    PLA                      ; $CAC4: 68      
    STA   $DF                ; $CAC5: 85 DF   
    JMP   $C932              ; $CAC7: 4C 32 C9
    JSR   $CC1E              ; $CACA: 20 1E CC
    JSR   $CB74              ; $CACD: 20 74 CB
    BCS   $CAD5              ; $CAD0: B0 03   
    SEC                      ; $CAD2: 38      
    ROR   $E8                ; $CAD3: 66 E8   
    LDA   $E5                ; $CAD5: A5 E5   
    STA   $EB                ; $CAD7: 85 EB   
    JSR   $C37C              ; $CAD9: 20 7C C3
    JSR   $CB85              ; $CADC: 20 85 CB
    JMP   $C932              ; $CADF: 4C 32 C9
    LDA   #$00               ; $CAE2: A9 00   
    BIT   $80A9              ; $CAE4: 2C A9 80
    STA   $F8                ; $CAE7: 85 F8   
    RTS                      ; $CAE9: 60      
    LDA   #$00               ; $CAEA: A9 00   
    BIT   $FFA9              ; $CAEC: 2C A9 FF
    STA   $F6                ; $CAEF: 85 F6   
    RTS                      ; $CAF1: 60      
    BIT   $D7                ; $CAF2: 24 D7   
    BPL   $CB36              ; $CAF4: 10 40   
    LDA   $0A2B              ; $CAF6: AD 2B 0A
    AND   #$E0               ; $CAF9: 29 E0   
    JMP   $CB14              ; $CAFB: 4C 14 CB
    BIT   $D7                ; $CAFE: 24 D7   
    BPL   $CB36              ; $CB00: 10 34   
    LDA   $0A2B              ; $CB02: AD 2B 0A
    AND   #$E0               ; $CB05: 29 E0   
    ORA   #$07               ; $CB07: 09 07   
    BNE   $CB14              ; $CB09: D0 09   
    BIT   $D7                ; $CB0B: 24 D7   
    BPL   $CB1A              ; $CB0D: 10 0B   
    LDA   $0A2B              ; $CB0F: AD 2B 0A
    AND   #$1F               ; $CB12: 29 1F   
    STA   $0A2B              ; $CB14: 8D 2B 0A
    JMP   $CD91              ; $CB17: 4C 91 CD
    LDA   $0A26              ; $CB1A: AD 26 0A
    ORA   #$40               ; $CB1D: 09 40   
    BNE   $CB33              ; $CB1F: D0 12   
    BIT   $D7                ; $CB21: 24 D7   
    BPL   $CB2E              ; $CB23: 10 09   
    LDA   $0A2B              ; $CB25: AD 2B 0A
    AND   #$1F               ; $CB28: 29 1F   
    ORA   #$60               ; $CB2A: 09 60   
    BNE   $CB14              ; $CB2C: D0 E6   
    LDA   $0A26              ; $CB2E: AD 26 0A
    AND   #$BF               ; $CB31: 29 BF   
    STA   $0A26              ; $CB33: 8D 26 0A
    RTS                      ; $CB36: 60      
    LDA   #$00               ; $CB37: A9 00   
    BIT   $80A9              ; $CB39: 2C A9 80
    STA   $F9                ; $CB3C: 85 F9   
    RTS                      ; $CB3E: 60      
    LDX   #$18               ; $CB3F: A2 18   
    JSR   $CDDA              ; $CB41: 20 DA CD
    ORA   #$40               ; $CB44: 09 40   
    BNE   $CB4F              ; $CB46: D0 07   
    LDX   #$18               ; $CB48: A2 18   
    JSR   $CDDA              ; $CB4A: 20 DA CD
    AND   #$BF               ; $CB4D: 29 BF   
    JMP   $CDCC              ; $CB4F: 4C CC CD
    JSR   $CBC3              ; $CB52: 20 C3 CB
    JMP   $C33E              ; $CB55: 4C 3E C3
    LDY   $EC                ; $CB58: A4 EC   
    BIT   $D7                ; $CB5A: 24 D7   
    BMI   $CB65              ; $CB5C: 30 07   
    LDA   ($E2),Y            ; $CB5E: B1 E2   
    STA   $F2                ; $CB60: 85 F2   
    LDA   ($E0),Y            ; $CB62: B1 E0   
    RTS                      ; $CB64: 60      
    JSR   $CDF9              ; $CB65: 20 F9 CD
    JSR   $CDD8              ; $CB68: 20 D8 CD
    STA   $F2                ; $CB6B: 85 F2   
    JSR   $CDE6              ; $CB6D: 20 E6 CD
    JSR   $CDD8              ; $CB70: 20 D8 CD
    RTS                      ; $CB73: 60      
    LDX   $EB                ; $CB74: A6 EB   
    JSR   $CB9F              ; $CB76: 20 9F CB
    AND   $035E,X            ; $CB79: 3D 5E 03
    CMP   #$01               ; $CB7C: C9 01   
    JMP   $CB90              ; $CB7E: 4C 90 CB
    LDX   $EB                ; $CB81: A6 EB   
    BCS   $CB93              ; $CB83: B0 0E   
    JSR   $CB9F              ; $CB85: 20 9F CB
    EOR   #$FF               ; $CB88: 49 FF   
    AND   $035E,X            ; $CB8A: 3D 5E 03
    STA   $035E,X            ; $CB8D: 9D 5E 03
    LDX   $DA                ; $CB90: A6 DA   
    RTS                      ; $CB92: 60      
    BIT   $F8                ; $CB93: 24 F8   
    BVS   $CB76              ; $CB95: 70 DF   
    JSR   $CB9F              ; $CB97: 20 9F CB
    ORA   $035E,X            ; $CB9A: 1D 5E 03
    BNE   $CB8D              ; $CB9D: D0 EE   
    STX   $DA                ; $CB9F: 86 DA   
    TXA                      ; $CBA1: 8A      
    AND   #$07               ; $CBA2: 29 07   
    TAX                      ; $CBA4: AA      
    LDA   $CE6C,X            ; $CBA5: BD 6C CE
    PHA                      ; $CBA8: 48      
    LDA   $DA                ; $CBA9: A5 DA   
    LSR   A                  ; $CBAB: 4A      
    LSR   A                  ; $CBAC: 4A      
    LSR   A                  ; $CBAD: 4A      
    TAX                      ; $CBAE: AA      
    PLA                      ; $CBAF: 68      
    RTS                      ; $CBB0: 60      
    LDY   $E6                ; $CBB1: A4 E6   
    STY   $EC                ; $CBB3: 84 EC   
    JSR   $CB74              ; $CBB5: 20 74 CB
    BCC   $CBC0              ; $CBB8: 90 06   
    DEC   $EB                ; $CBBA: C6 EB   
    BPL   $CBB5              ; $CBBC: 10 F7   
    INC   $EB                ; $CBBE: E6 EB   
    JMP   $C15C              ; $CBC0: 4C 5C C1
    INC   $EB                ; $CBC3: E6 EB   
    JSR   $CB74              ; $CBC5: 20 74 CB
    BCS   $CBC3              ; $CBC8: B0 F9   
    DEC   $EB                ; $CBCA: C6 EB   
    JSR   $C15C              ; $CBCC: 20 5C C1
    LDY   $E7                ; $CBCF: A4 E7   
    STY   $EC                ; $CBD1: 84 EC   
; --- [DATA] Screen Editor Escape Sequence Dispatch & Control Code Tables ($CBD3-$CC33) ---
    .BYTE $20, $58, $CB, $A6, $EB, $C9, $20, $D0 ; $CBD3 [IDENTIFIED_DATA] | X.... .|
    .BYTE $0E, $C4, $E6, $D0, $05, $20, $74, $CB ; $CBDB [IDENTIFIED_DATA] |..... t.|
    .BYTE $90, $05, $20, $00, $CC, $90, $E9, $84 ; $CBE3 [IDENTIFIED_DATA] |.. .....|
    .BYTE $EA, $60, $48, $A4, $EC, $C4, $E7, $90 ; $CBEB [IDENTIFIED_DATA] |.`H.....|
    .BYTE $07, $20, $63, $C3, $A4, $E6, $88, $38 ; $CBF3 [IDENTIFIED_DATA] |. c....8|
    .BYTE $C8, $84, $EC, $68, $60, $A4, $EC, $88 ; $CBFB [IDENTIFIED_DATA] |...h`...|
    .BYTE $30, $04, $C4, $E6, $B0, $0F, $A4, $E5 ; $CC03 [IDENTIFIED_DATA] |0.......|
    .BYTE $C4, $EB, $B0, $0E, $C6, $EB, $48, $20 ; $CC0B [IDENTIFIED_DATA] |......H |
    .BYTE $5C, $C1, $68, $A4, $E7, $84, $EC, $C4 ; $CC13 [IDENTIFIED_DATA] |\.h.....|
    .BYTE $E7, $18, $60, $A4, $EC, $84, $DE, $A6 ; $CC1B [IDENTIFIED_DATA] |..`.....|
    .BYTE $EB, $86, $DF, $60, $A5, $F1, $29, $8F ; $CC23 [IDENTIFIED_DATA] |...`..).|
    .BYTE $AA, $A9, $20, $2C, $A6, $F1, $2C, $A6 ; $CC2B [IDENTIFIED_DATA] |.. ,..,.|
    .BYTE $F2                                    ; $CC33 [IDENTIFIED_DATA] |.|
ED_DISPLY_IMPL:
    TAY                      ; $CC34: A8      
    LDA   #$02               ; $CC35: A9 02   
    STA   $0A28              ; $CC37: 8D 28 0A
    JSR   $C17C              ; $CC3A: 20 7C C1
    TYA                      ; $CC3D: 98      
    LDY   $EC                ; $CC3E: A4 EC   
    BIT   $D7                ; $CC40: 24 D7   
    BMI   $CC4A              ; $CC42: 30 06   
    STA   ($E0),Y            ; $CC44: 91 E0   
    TXA                      ; $CC46: 8A      
    STA   ($E2),Y            ; $CC47: 91 E2   
    RTS                      ; $CC49: 60      
    PHA                      ; $CC4A: 48      
    TXA                      ; $CC4B: 8A      
    PHA                      ; $CC4C: 48      
    JSR   $CDF9              ; $CC4D: 20 F9 CD
    PLA                      ; $CC50: 68      
    JSR   $CDCA              ; $CC51: 20 CA CD
    JSR   $CDE6              ; $CC54: 20 E6 CD
    PLA                      ; $CC57: 68      
    JMP   $CDCA              ; $CC58: 4C CA CD
ED_SCRORG_IMPL:
    SEC                      ; $CC5B: 38      
    LDA   $E4                ; $CC5C: A5 E4   
    SBC   $E5                ; $CC5E: E5 E5   
    TAY                      ; $CC60: A8      
    SEC                      ; $CC61: 38      
    LDA   $E7                ; $CC62: A5 E7   
    SBC   $E6                ; $CC64: E5 E6   
    TAX                      ; $CC66: AA      
    LDA   $EE                ; $CC67: A5 EE   
    RTS                      ; $CC69: 60      
ED_PLOT_IMPL:
    BCS   $CC95              ; $CC6A: B0 29   
    TXA                      ; $CC6C: 8A      
    ADC   $E5                ; $CC6D: 65 E5   
    BCS   $CC85              ; $CC6F: B0 14   
    CMP   $E4                ; $CC71: C5 E4   
    BEQ   $CC77              ; $CC73: F0 02   
    BCS   $CC85              ; $CC75: B0 0E   
    PHA                      ; $CC77: 48      
    CLC                      ; $CC78: 18      
    TYA                      ; $CC79: 98      
    ADC   $E6                ; $CC7A: 65 E6   
    BCS   $CC84              ; $CC7C: B0 06   
    CMP   $E7                ; $CC7E: C5 E7   
    BEQ   $CC86              ; $CC80: F0 04   
    BCC   $CC86              ; $CC82: 90 02   
    PLA                      ; $CC84: 68      
    RTS                      ; $CC85: 60      
    STA   $EC                ; $CC86: 85 EC   
    STA   $E9                ; $CC88: 85 E9   
    PLA                      ; $CC8A: 68      
    STA   $EB                ; $CC8B: 85 EB   
    STA   $E8                ; $CC8D: 85 E8   
    JSR   $C15C              ; $CC8F: 20 5C C1
    JSR   $CD57              ; $CC92: 20 57 CD (ED_CURSOR_IMPL)
    LDA   $EB                ; $CC95: A5 EB   
    SBC   $E5                ; $CC97: E5 E5   
    TAX                      ; $CC99: AA      
    SEC                      ; $CC9A: 38      
    LDA   $EC                ; $CC9B: A5 EC   
    SBC   $E6                ; $CC9D: E5 E6   
    TAY                      ; $CC9F: A8      
    CLC                      ; $CCA0: 18      
    RTS                      ; $CCA1: 60      
ED_KEYSET_IMPL:
    DEX                      ; $CCA2: CA      
    STX   $DC                ; $CCA3: 86 DC   
    STY   $DA                ; $CCA5: 84 DA   
    STA   $02AA              ; $CCA7: 8D AA 02
    TAY                      ; $CCAA: A8      
    LDX   $02,Y              ; $CCAB: B6 02   
    JSR   $FF6B              ; $CCAD: 20 6B FF (J_GETCFG)
    STA   $DE                ; $CCB0: 85 DE   
    LDX   #$0A               ; $CCB2: A2 0A   
    JSR   $CD20              ; $CCB4: 20 20 CD
    STA   $DB                ; $CCB7: 85 DB   
    LDX   $DC                ; $CCB9: A6 DC   
    INX                      ; $CCBB: E8      
    JSR   $CD20              ; $CCBC: 20 20 CD
    STA   $DD                ; $CCBF: 85 DD   
    LDX   $DC                ; $CCC1: A6 DC   
    LDA   $DA                ; $CCC3: A5 DA   
    SEC                      ; $CCC5: 38      
    SBC   $1000,X            ; $CCC6: FD 00 10
    BEQ   $CCF6              ; $CCC9: F0 2B   
    BCC   $CCE3              ; $CCCB: 90 16   
    CLC                      ; $CCCD: 18      
    ADC   $DB                ; $CCCE: 65 DB   
    BCS   $CD1F              ; $CCD0: B0 4D   
    TAX                      ; $CCD2: AA      
    LDY   $DB                ; $CCD3: A4 DB   
    CPY   $DD                ; $CCD5: C4 DD   
    BEQ   $CCF6              ; $CCD7: F0 1D   
    DEY                      ; $CCD9: 88      
    DEX                      ; $CCDA: CA      
    LDA   $100A,Y            ; $CCDB: B9 0A 10
    STA   $100A,X            ; $CCDE: 9D 0A 10
    BCS   $CCD5              ; $CCE1: B0 F2   
    ADC   $DD                ; $CCE3: 65 DD   
    TAX                      ; $CCE5: AA      
    LDY   $DD                ; $CCE6: A4 DD   
    CPY   $DB                ; $CCE8: C4 DB   
    BCS   $CCF6              ; $CCEA: B0 0A   
    LDA   $100A,Y            ; $CCEC: B9 0A 10
    STA   $100A,X            ; $CCEF: 9D 0A 10
    INY                      ; $CCF2: C8      
    INX                      ; $CCF3: E8      
    BCC   $CCE8              ; $CCF4: 90 F2   
    LDX   $DC                ; $CCF6: A6 DC   
    JSR   $CD20              ; $CCF8: 20 20 CD
    TAX                      ; $CCFB: AA      
    LDY   $DC                ; $CCFC: A4 DC   
    LDA   $DA                ; $CCFE: A5 DA   
    STA   $1000,Y            ; $CD00: 99 00 10
    LDY   #$00               ; $CD03: A0 00   
    DEC   $DA                ; $CD05: C6 DA   
    BMI   $CD1E              ; $CD07: 30 15   
    STX   $DF                ; $CD09: 86 DF   
    LDX   $DE                ; $CD0B: A6 DE   
    LDA   $02AA              ; $CD0D: AD AA 02
    SEI                      ; $CD10: 78      
    JSR   $02A2              ; $CD11: 20 A2 02
    CLI                      ; $CD14: 58      
    LDX   $DF                ; $CD15: A6 DF   
    STA   $100A,X            ; $CD17: 9D 0A 10
    INX                      ; $CD1A: E8      
    INY                      ; $CD1B: C8      
    BNE   $CD05              ; $CD1C: D0 E7   
    CLC                      ; $CD1E: 18      
    RTS                      ; $CD1F: 60      
    LDA   #$00               ; $CD20: A9 00   
    CLC                      ; $CD22: 18      
    DEX                      ; $CD23: CA      
    BMI   $CD2B              ; $CD24: 30 05   
    ADC   $1000,X            ; $CD26: 7D 00 10
    BCC   $CD23              ; $CD29: 90 F8   
    RTS                      ; $CD2B: 60      
    STA   $F0                ; $CD2C: 85 F0   
ED_SWAPPER_IMPL:
    LDX   #$1A               ; $CD2E: A2 1A   
    LDY   $0A40,X            ; $CD30: BC 40 0A
    LDA   $E0,X              ; $CD33: B5 E0   
    STA   $0A40,X            ; $CD35: 9D 40 0A
    TYA                      ; $CD38: 98      
    STA   $E0,X              ; $CD39: 95 E0   
    DEX                      ; $CD3B: CA      
    BPL   $CD30              ; $CD3C: 10 F2   
    LDX   #$0D               ; $CD3E: A2 0D   
    LDY   $0A60,X            ; $CD40: BC 60 0A
    LDA   $0354,X            ; $CD43: BD 54 03
    STA   $0A60,X            ; $CD46: 9D 60 0A
    TYA                      ; $CD49: 98      
    STA   $0354,X            ; $CD4A: 9D 54 03
    DEX                      ; $CD4D: CA      
    BPL   $CD40              ; $CD4E: 10 F0   
    LDA   $D7                ; $CD50: A5 D7   
    EOR   #$80               ; $CD52: 49 80   
    STA   $D7                ; $CD54: 85 D7   
    RTS                      ; $CD56: 60      
ED_CURSOR_IMPL:
    BIT   $D7                ; $CD57: 24 D7   
    BPL   $CD56              ; $CD59: 10 FB   
    LDX   #$0E               ; $CD5B: A2 0E   
    CLC                      ; $CD5D: 18      
    LDA   $E0                ; $CD5E: A5 E0   
    ADC   $EC                ; $CD60: 65 EC   
    PHA                      ; $CD62: 48      
    LDA   $E1                ; $CD63: A5 E1   
    ADC   #$00               ; $CD65: 69 00   
    JSR   $CDCC              ; $CD67: 20 CC CD
    INX                      ; $CD6A: E8      
    PLA                      ; $CD6B: 68      
    JMP   $CDCC              ; $CD6C: 4C CC CD
    BIT   $D7                ; $CD6F: 24 D7   
    BPL   $CD99              ; $CD71: 10 26   
    JSR   $C17C              ; $CD73: 20 7C C1
    LDY   $EC                ; $CD76: A4 EC   
    JSR   $CDF9              ; $CD78: 20 F9 CD
    JSR   $CDD8              ; $CD7B: 20 D8 CD
    STA   $0A33              ; $CD7E: 8D 33 0A
    AND   #$F0               ; $CD81: 29 F0   
    STA   $DB                ; $CD83: 85 DB   
    JSR   $CDF9              ; $CD85: 20 F9 CD
    LDA   $F1                ; $CD88: A5 F1   
    AND   #$0F               ; $CD8A: 29 0F   
    ORA   $DB                ; $CD8C: 05 DB   
    JSR   $CDCA              ; $CD8E: 20 CA CD
    LDX   #$0A               ; $CD91: A2 0A   
    LDA   $0A2B              ; $CD93: AD 2B 0A
    JMP   $CDCC              ; $CD96: 4C CC CD
    LDA   #$00               ; $CD99: A9 00   
    STA   $0A27              ; $CD9B: 8D 27 0A
    RTS                      ; $CD9E: 60      
    BIT   $D7                ; $CD9F: 24 D7   
    BPL   $CDB3              ; $CDA1: 10 10   
    JSR   $CDF9              ; $CDA3: 20 F9 CD
    LDA   $0A33              ; $CDA6: AD 33 0A
    JSR   $CDCA              ; $CDA9: 20 CA CD
    LDX   #$0A               ; $CDAC: A2 0A   
    LDA   #$20               ; $CDAE: A9 20   
    JMP   $CDCC              ; $CDB0: 4C CC CD
    STA   $0A27              ; $CDB3: 8D 27 0A
    LDA   $0A26              ; $CDB6: AD 26 0A
    BPL   $CDC9              ; $CDB9: 10 0E   
    AND   #$40               ; $CDBB: 29 40   
    STA   $0A26              ; $CDBD: 8D 26 0A
    LDA   $0A29              ; $CDC0: AD 29 0A
    LDX   $0A2A              ; $CDC3: AE 2A 0A
    JSR   $CC34              ; $CDC6: 20 34 CC (ED_DISPLY_IMPL)
    RTS                      ; $CDC9: 60      
    LDX   #$1F               ; $CDCA: A2 1F   
    STX   $D600              ; $CDCC: 8E 00 D6 (VDC_ADDR_STATUS)
    BIT   $D600              ; $CDCF: 2C 00 D6 (VDC_ADDR_STATUS)
    BPL   $CDCF              ; $CDD2: 10 FB   
    STA   $D601              ; $CDD4: 8D 01 D6 (VDC_DATA)
    RTS                      ; $CDD7: 60      
    LDX   #$1F               ; $CDD8: A2 1F   
    STX   $D600              ; $CDDA: 8E 00 D6 (VDC_ADDR_STATUS)
    BIT   $D600              ; $CDDD: 2C 00 D6 (VDC_ADDR_STATUS)
    BPL   $CDDD              ; $CDE0: 10 FB   
    LDA   $D601              ; $CDE2: AD 01 D6 (VDC_DATA)
    RTS                      ; $CDE5: 60      
    LDX   #$12               ; $CDE6: A2 12   
    CLC                      ; $CDE8: 18      
    TYA                      ; $CDE9: 98      
    ADC   $E0                ; $CDEA: 65 E0   
    PHA                      ; $CDEC: 48      
    LDA   #$00               ; $CDED: A9 00   
    ADC   $E1                ; $CDEF: 65 E1   
    JSR   $CDCC              ; $CDF1: 20 CC CD
    PLA                      ; $CDF4: 68      
    INX                      ; $CDF5: E8      
    JMP   $CDCC              ; $CDF6: 4C CC CD
    LDX   #$12               ; $CDF9: A2 12   
    CLC                      ; $CDFB: 18      
    TYA                      ; $CDFC: 98      
    ADC   $E2                ; $CDFD: 65 E2   
    PHA                      ; $CDFF: 48      
    LDA   #$00               ; $CE00: A9 00   
    ADC   $E3                ; $CE02: 65 E3   
    JSR   $CDCC              ; $CE04: 20 CC CD
    PLA                      ; $CE07: 68      
    INX                      ; $CE08: E8      
    JMP   $CDCC              ; $CE09: 4C CC CD
ED_INIT80_IMPL:
    LDA   #$00               ; $CE0C: A9 00   
    LDY   #$D0               ; $CE0E: A0 D0   
    STA   $DA                ; $CE10: 85 DA   
    STY   $DB                ; $CE12: 84 DB   
    LDX   #$12               ; $CE14: A2 12   
    LDA   #$20               ; $CE16: A9 20   
    JSR   $CDCC              ; $CE18: 20 CC CD
    INX                      ; $CE1B: E8      
    LDA   #$00               ; $CE1C: A9 00   
    JSR   $CDCC              ; $CE1E: 20 CC CD
    LDY   #$00               ; $CE21: A0 00   
    LDX   #$0E               ; $CE23: A2 0E   
    LDA   #$DA               ; $CE25: A9 DA   
    JSR   $FF74              ; $CE27: 20 74 FF (J_INDFET)
    JSR   $CDCA              ; $CE2A: 20 CA CD
    INY                      ; $CE2D: C8      
    CPY   #$08               ; $CE2E: C0 08   
    BCC   $CE23              ; $CE30: 90 F1   
    LDA   #$00               ; $CE32: A9 00   
    JSR   $CDCA              ; $CE34: 20 CA CD
    DEY                      ; $CE37: 88      
    BNE   $CE34              ; $CE38: D0 FA   
    CLC                      ; $CE3A: 18      
    LDA   $DA                ; $CE3B: A5 DA   
    ADC   #$08               ; $CE3D: 69 08   
    STA   $DA                ; $CE3F: 85 DA   
    BCC   $CE23              ; $CE41: 90 E0   
    INC   $DB                ; $CE43: E6 DB   
    LDA   $DB                ; $CE45: A5 DB   
    CMP   #$E0               ; $CE47: C9 E0   
    BCC   $CE23              ; $CE49: 90 D8   
    RTS                      ; $CE4B: 60      
    BCC   $CE53              ; $CE4C: 90 05   
    .BYTE $1C                                ; $CE4E: 1C [UNRESOLVED]
    .BYTE $9F                                ; $CE4F: 9F [UNRESOLVED]
    .BYTE $9C                                ; $CE50: 9C [UNRESOLVED]
    ASL   $9E1F,X            ; $CE51: 1E 1F 9E
    STA   ($95,X)            ; $CE54: 81 95   
    STX   $97,Y              ; $CE56: 96 97   
    TYA                      ; $CE58: 98      
    STA   $9B9A,Y            ; $CE59: 99 9A 9B
; --- [DATA] 8563 VDC Register Init Table & Function Key Definition Strings ($CE5C-$CEF4) ---
    .BYTE $00, $0F, $08, $07, $0B, $04, $02, $0D ; $CE5C [IDENTIFIED_DATA] |........|
    .BYTE $0A, $0C, $09, $06, $01, $05, $03, $0E ; $CE64 [IDENTIFIED_DATA] |........|
    .BYTE $80, $40, $20, $10, $08, $04, $02, $01 ; $CE6C [IDENTIFIED_DATA] |.@ .....|
    .BYTE $00, $04, $00, $D8, $18, $00, $00, $27 ; $CE74 [IDENTIFIED_DATA] |.......'|
    .BYTE $00, $00, $00, $00, $00, $18, $27, $00 ; $CE7C [IDENTIFIED_DATA] |......'.|
    .BYTE $00, $0D, $0D, $00, $00, $00, $00, $00 ; $CE84 [IDENTIFIED_DATA] |........|
    .BYTE $00, $00, $00, $00, $00, $08, $18, $00 ; $CE8C [IDENTIFIED_DATA] |........|
    .BYTE $00, $4F, $00, $00, $00, $00, $00, $18 ; $CE94 [IDENTIFIED_DATA] |.O......|
    .BYTE $4F, $00, $00, $07, $07, $00, $00, $00 ; $CE9C [IDENTIFIED_DATA] |O.......|
    .BYTE $00, $00, $00, $00, $07, $06, $0A, $07 ; $CEA4 [IDENTIFIED_DATA] |........|
    .BYTE $06, $04, $05, $08, $09, $05, $47, $52 ; $CEAC [IDENTIFIED_DATA] |......GR|
    .BYTE $41, $50, $48, $49, $43, $44, $4C, $4F ; $CEB4 [IDENTIFIED_DATA] |APHICDLO|
    .BYTE $41, $44, $22, $44, $49, $52, $45, $43 ; $CEBC [IDENTIFIED_DATA] |AD"DIREC|
    .BYTE $54, $4F, $52, $59, $0D, $53, $43, $4E ; $CEC4 [IDENTIFIED_DATA] |TORY.SCN|
    .BYTE $43, $4C, $52, $0D, $44, $53, $41, $56 ; $CECC [IDENTIFIED_DATA] |CLR.DSAV|
    .BYTE $45, $22, $52, $55, $4E, $0D, $4C, $49 ; $CED4 [IDENTIFIED_DATA] |E"RUN.LI|
    .BYTE $53, $54, $0D, $4D, $4F, $4E, $49, $54 ; $CEDC [IDENTIFIED_DATA] |ST.MONIT|
    .BYTE $4F, $52, $0D, $44, $CC, $22, $2A, $0D ; $CEE4 [IDENTIFIED_DATA] |OR.D."*.|
    .BYTE $52, $55, $4E, $0D, $48, $45, $4C, $50 ; $CEEC [IDENTIFIED_DATA] |RUN.HELP|
    .BYTE $0D                                    ; $CEF4 [IDENTIFIED_DATA] |.|
; --- [PADDING] Screen Editor Unused Padding ($FF, 265 bytes) ($CEF5-$CFFD) ---
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $CEF5 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $CEFD [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $CF05 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $CF0D [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $CF15 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $CF1D [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $CF25 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $CF2D [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $CF35 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $CF3D [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $CF45 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $CF4D [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $CF55 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $CF5D [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $CF65 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $CF6D [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $CF75 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $CF7D [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $CF85 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $CF8D [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $CF95 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $CF9D [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $CFA5 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $CFAD [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $CFB5 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $CFBD [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $CFC5 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $CFCD [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $CFD5 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $CFDD [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $CFE5 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $CFED [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $CFF5 [PADDING] |........|
    .BYTE $FF                                    ; $CFFD [PADDING] |.|
; --- [DATA] Screen Editor Revision and Checksum Trailer ($CFFE-$CFFF) ---
    .BYTE $00, $C3                               ; $CFFE [IDENTIFIED_DATA] |..|
VIC_SP0X:
; --- [DATA] Embedded Z80 BIOS Image (4096 bytes, mapped to Z80 $0000-$0FFF) ($D000-$DFFF) ---
    .BYTE $3E, $3E, $32, $00, $FF, $C3, $3B, $00 ; $D000 [IDENTIFIED_DATA] |>>2...;.|
    .BYTE $31, $77, $3C, $3E, $3F, $C3, $8C, $01 ; $D008 [IDENTIFIED_DATA] |1w<>?...|
    .BYTE $E1, $6E, $C3, $20, $00, $00, $00, $00 ; $D010 [IDENTIFIED_DATA] |.n. ....|
VIC_VMCSB:
    .BYTE $E1, $6E, $C3, $28, $00, $00, $00, $00 ; $D018 [IDENTIFIED_DATA] |.n.(....|
VIC_EXTCOL:
    .BYTE $3A, $0F, $FD, $A7, $28, $02, $2C, $2C ; $D020 [IDENTIFIED_DATA] |:...(.,,|
    .BYTE $26, $01, $7E, $23, $66, $6F, $E9, $00 ; $D028 [IDENTIFIED_DATA] |&.~#fo..|
VIC_CLK2MHZ:
    .BYTE $30, $35, $2F, $31, $32, $2F, $38, $35 ; $D030 [IDENTIFIED_DATA] |05/12/85|
    .BYTE $C3, $FD, $FD, $01, $2F, $D0, $11, $FC ; $D038 [IDENTIFIED_DATA] |..../...|
    .BYTE $FF, $ED, $51, $03, $ED, $59, $01, $05 ; $D040 [IDENTIFIED_DATA] |..Q..Y..|
    .BYTE $D5, $3E, $B0, $ED, $79, $ED, $78, $2F ; $D048 [IDENTIFIED_DATA] |.>..y.x/|
    .BYTE $E6, $30, $28, $05, $3E, $F1, $ED, $79 ; $D050 [IDENTIFIED_DATA] |.0(.>..y|
    .BYTE $C7, $01, $0F, $DC, $3E, $08, $ED, $79 ; $D058 [IDENTIFIED_DATA] |....>..y|
    .BYTE $0D, $ED, $79, $0E, $03, $AF, $ED, $79 ; $D060 [IDENTIFIED_DATA] |..y....y|
    .BYTE $0D, $3D, $ED, $79, $0D, $0D, $3E, $7F ; $D068 [IDENTIFIED_DATA] |.=.y..>.|
    .BYTE $ED, $79, $03, $ED, $78, $E6, $20, $01 ; $D070 [IDENTIFIED_DATA] |.y..x. .|
    .BYTE $05, $D5, $28, $D8, $21, $B4, $0F, $01 ; $D078 [IDENTIFIED_DATA] |..(.!...|
    .BYTE $0A, $D5, $16, $0B, $7E, $ED, $79, $2B ; $D080 [IDENTIFIED_DATA] |....~.y+|
    .BYTE $0D, $15, $20, $F8, $21, $1A, $0D, $11 ; $D088 [IDENTIFIED_DATA] |.. .!...|
    .BYTE $00, $11, $01, $08, $00, $ED, $B0, $21 ; $D090 [IDENTIFIED_DATA] |.......!|
    .BYTE $E5, $0E, $11, $D0, $FF, $01, $1F, $00 ; $D098 [IDENTIFIED_DATA] |........|
    .BYTE $ED, $B0, $21, $00, $11, $22, $FA, $FF ; $D0A0 [IDENTIFIED_DATA] |..!.."..|
    .BYTE $22, $FC, $FF, $22, $FE, $FF, $22, $DD ; $D0A8 [IDENTIFIED_DATA] |".."..".|
    .BYTE $FF, $C3, $E0, $FF, $CD, $6D, $03, $3A ; $D0B0 [IDENTIFIED_DATA] |.....m.:|
    .BYTE $06, $3C, $22, $18, $FD, $11, $ED, $00 ; $D0B8 [IDENTIFIED_DATA] |.<".....|
    .BYTE $F5, $CD, $D3, $00, $CC, $FA, $02, $F1 ; $D0C0 [IDENTIFIED_DATA] |........|
    .BYTE $2A, $18, $FD, $11, $20, $00, $19, $3D ; $D0C8 [IDENTIFIED_DATA] |*... ..=|
    .BYTE $20, $E8, $C9, $06, $0C, $EB, $1A, $E6 ; $D0D0 [IDENTIFIED_DATA] | .......|
    .BYTE $7F, $BE, $C0, $23, $13, $10, $F7, $3A ; $D0D8 [IDENTIFIED_DATA] |...#...:|
    .BYTE $06, $3C, $FE, $40, $1A, $20, $01, $1F ; $D0E0 [IDENTIFIED_DATA] |.<.@. ..|
    .BYTE $32, $35, $3C, $AF, $C9, $00, $43, $50 ; $D0E8 [IDENTIFIED_DATA] |25<...CP|
    .BYTE $4D, $2B, $20, $20, $20, $20, $53, $59 ; $D0F0 [IDENTIFIED_DATA] |M+    SY|
    .BYTE $53, $00, $7C, $BA, $C0, $7D, $BB, $C9 ; $D0F8 [IDENTIFIED_DATA] |S.|..}..|
    .BYTE $84, $06, $6E, $09, $AB, $06, $BC, $09 ; $D100 [IDENTIFIED_DATA] |..n.....|
    .BYTE $C2, $06, $DD, $09, $D1, $06, $F1, $09 ; $D108 [IDENTIFIED_DATA] |........|
    .BYTE $DD, $06, $31, $0A, $E8, $06, $3C, $0A ; $D110 [IDENTIFIED_DATA] |..1...<.|
    .BYTE $F1, $06, $45, $0A, $7A, $07, $48, $0A ; $D118 [IDENTIFIED_DATA] |..E.z.H.|
    .BYTE $80, $07, $62, $0A, $91, $07, $8E, $0A ; $D120 [IDENTIFIED_DATA] |..b.....|
    .BYTE $CA, $07, $BA, $0A, $DC, $07, $DF, $0A ; $D128 [IDENTIFIED_DATA] |........|
    .BYTE $1E, $08, $2D, $0B, $1B, $07, $7B, $0B ; $D130 [IDENTIFIED_DATA] |..-...{.|
    .BYTE $10, $07, $62, $0B, $1C, $09, $95, $09 ; $D138 [IDENTIFIED_DATA] |..b.....|
    .BYTE $27, $09, $A2, $09, $4E, $07, $AE, $0B ; $D140 [IDENTIFIED_DATA] |'...N...|
    .BYTE $EB, $00, $EB, $00, $EB, $00, $EB, $00 ; $D148 [IDENTIFIED_DATA] |........|
    .BYTE $E3, $03, $6B, $04, $FA, $0C, $EB, $00 ; $D150 [IDENTIFIED_DATA] |..k.....|
    .BYTE $EB, $00, $EB, $00, $EB, $00, $EB, $00 ; $D158 [IDENTIFIED_DATA] |........|
    .BYTE $3C, $0C, $4A, $0C, $CF, $0B, $0C, $0C ; $D160 [IDENTIFIED_DATA] |<.J.....|
    .BYTE $26, $05, $32, $05, $2C, $05, $EB, $00 ; $D168 [IDENTIFIED_DATA] |&.2.,...|
    .BYTE $7F, $0C, $C2, $0C, $C7, $0C, $E4, $0C ; $D170 [IDENTIFIED_DATA] |........|
    .BYTE $EB, $00, $3D, $08, $AE, $08, $60, $06 ; $D178 [IDENTIFIED_DATA] |..=...`.|
    .BYTE $C3, $0A, $09, $C3, $33, $09, $C3, $53 ; $D180 [IDENTIFIED_DATA] |....3..S|
    .BYTE $09, $C3, $45, $09, $32, $00, $FF, $21 ; $D188 [IDENTIFIED_DATA] |..E.2..!|
    .BYTE $00, $30, $11, $01, $30, $01, $FF, $CE ; $D190 [IDENTIFIED_DATA] |.0..0...|
    .BYTE $75, $ED, $B0, $21, $22, $0D, $11, $00 ; $D198 [IDENTIFIED_DATA] |u..!"...|
    .BYTE $30, $01, $C3, $01, $ED, $B0, $21, $E5 ; $D1A0 [IDENTIFIED_DATA] |0.....!.|
    .BYTE $0E, $11, $D0, $FF, $01, $1F, $00, $ED ; $D1A8 [IDENTIFIED_DATA] |........|
    .BYTE $B0, $3E, $C9, $32, $EE, $FF, $CD, $E0 ; $D1B0 [IDENTIFIED_DATA] |.>.2....|
    .BYTE $FF, $21, $B4, $0F, $01, $0A, $D5, $16 ; $D1B8 [IDENTIFIED_DATA] |.!......|
    .BYTE $0B, $7E, $ED, $79, $2B, $0D, $15, $20 ; $D1C0 [IDENTIFIED_DATA] |.~.y+.. |
    .BYTE $F8, $21, $00, $10, $11, $01, $10, $01 ; $D1C8 [IDENTIFIED_DATA] |.!......|
    .BYTE $FF, $1F, $75, $ED, $B0, $3E, $1A, $CD ; $D1D0 [IDENTIFIED_DATA] |..u..>..|
    .BYTE $45, $09, $3E, $90, $ED, $79, $3E, $83 ; $D1D8 [IDENTIFIED_DATA] |E.>..y>.|
    .BYTE $32, $15, $24, $3E, $0E, $32, $0D, $24 ; $D1E0 [IDENTIFIED_DATA] |2.$>.2.$|
    .BYTE $CD, $BD, $05, $3E, $19, $32, $08, $24 ; $D1E8 [IDENTIFIED_DATA] |...>.2.$|
    .BYTE $CD, $26, $05, $FF, $81, $0A, $42, $4F ; $D1F0 [IDENTIFIED_DATA] |.&....BO|
    .BYTE $4F, $54, $49, $4E, $47, $20, $43, $50 ; $D1F8 [IDENTIFIED_DATA] |OTING CP|
    .BYTE $2F, $4D, $20, $50, $4C, $55, $53, $00 ; $D200 [IDENTIFIED_DATA] |/M PLUS.|
    .BYTE $01, $18, $D0, $3E, $B6, $ED, $79, $CD ; $D208 [IDENTIFIED_DATA] |...>..y.|
    .BYTE $D2, $02, $C2, $FF, $04, $21, $B2, $0F ; $D210 [IDENTIFIED_DATA] |.....!..|
    .BYTE $22, $02, $3C, $CD, $B4, $00, $CD, $B4 ; $D218 [IDENTIFIED_DATA] |".<.....|
    .BYTE $00, $2A, $09, $3C, $7C, $B5, $CA, $FF ; $D220 [IDENTIFIED_DATA] |.*.<|...|
    .BYTE $04, $21, $09, $3C, $22, $02, $3C, $CD ; $D228 [IDENTIFIED_DATA] |.!.<".<.|
    .BYTE $6D, $03, $21, $00, $34, $11, $29, $3C ; $D230 [IDENTIFIED_DATA] |m.!.4.)<|
    .BYTE $01, $0C, $00, $ED, $B0, $CD, $26, $05 ; $D238 [IDENTIFIED_DATA] |......&.|
    .BYTE $8A, $00, $00, $21, $80, $34, $CD, $34 ; $D240 [IDENTIFIED_DATA] |...!.4.4|
    .BYTE $05, $21, $00, $35, $22, $04, $3C, $CD ; $D248 [IDENTIFIED_DATA] |.!.5".<.|
    .BYTE $26, $05, $83, $0C, $44, $41, $54, $41 ; $D250 [IDENTIFIED_DATA] |&...DATA|
    .BYTE $20, $54, $41, $42, $4C, $45, $53, $00 ; $D258 [IDENTIFIED_DATA] | TABLES.|
    .BYTE $2A, $33, $3C, $22, $09, $FD, $21, $32 ; $D260 [IDENTIFIED_DATA] |*3<"..!2|
    .BYTE $3C, $CD, $31, $03, $22, $0B, $FD, $CD ; $D268 [IDENTIFIED_DATA] |<.1."...|
    .BYTE $44, $03, $11, $80, $00, $19, $20, $F7 ; $D270 [IDENTIFIED_DATA] |D..... .|
    .BYTE $CD, $26, $05, $84, $0C, $43, $4F, $4D ; $D278 [IDENTIFIED_DATA] |.&...COM|
    .BYTE $4D, $4F, $4E, $20, $43, $4F, $44, $45 ; $D280 [IDENTIFIED_DATA] |MON CODE|
    .BYTE $00, $21, $2A, $3C, $CD, $24, $03, $CD ; $D288 [IDENTIFIED_DATA] |.!*<.$..|
    .BYTE $26, $05, $85, $0C, $42, $41, $4E, $4B ; $D290 [IDENTIFIED_DATA] |&...BANK|
    .BYTE $45, $44, $20, $43, $4F, $44, $45, $00 ; $D298 [IDENTIFIED_DATA] |ED CODE.|
    .BYTE $21, $2C, $3C, $CD, $24, $03, $CD, $26 ; $D2A0 [IDENTIFIED_DATA] |!,<.$..&|
    .BYTE $05, $86, $0C, $42, $49, $4F, $53, $38 ; $D2A8 [IDENTIFIED_DATA] |...BIOS8|
    .BYTE $35, $30, $32, $20, $43, $4F, $44, $45 ; $D2B0 [IDENTIFIED_DATA] |502 CODE|
    .BYTE $00, $21, $30, $3C, $CD, $24, $03, $3A ; $D2B8 [IDENTIFIED_DATA] |.!0<.$.:|
    .BYTE $30, $3C, $47, $3A, $2F, $3C, $90, $32 ; $D2C0 [IDENTIFIED_DATA] |0<G:/<.2|
    .BYTE $DE, $FF, $AF, $32, $DD, $FF, $2A, $2D ; $D2C8 [IDENTIFIED_DATA] |...2..*-|
    .BYTE $3C, $E9, $21, $00, $FE, $22, $18, $FD ; $D2D0 [IDENTIFIED_DATA] |<.!.."..|
    .BYTE $AF, $32, $04, $FD, $3C, $32, $03, $FD ; $D2D8 [IDENTIFIED_DATA] |.2..<2..|
    .BYTE $CD, $4F, $04, $CD, $6B, $04, $C0, $3C ; $D2E0 [IDENTIFIED_DATA] |.O..k..<|
    .BYTE $21, $00, $38, $3E, $20, $20, $03, $26 ; $D2E8 [IDENTIFIED_DATA] |!.8>  .&|
    .BYTE $3C, $87, $22, $07, $3C, $32, $06, $3C ; $D2F0 [IDENTIFIED_DATA] |<.".<2.<|
    .BYTE $AF, $C9, $11, $09, $3C, $3A, $35, $3C ; $D2F8 [IDENTIFIED_DATA] |....<:5<|
    .BYTE $B7, $28, $07, $11, $19, $3C, $3D, $C2 ; $D300 [IDENTIFIED_DATA] |.(...<=.|
    .BYTE $80, $04, $2A, $18, $FD, $01, $10, $00 ; $D308 [IDENTIFIED_DATA] |..*.....|
    .BYTE $09, $ED, $B0, $3A, $09, $3C, $B7, $C8 ; $D310 [IDENTIFIED_DATA] |...:.<..|
    .BYTE $2A, $18, $3C, $AF, $BD, $28, $02, $BC ; $D318 [IDENTIFIED_DATA] |*.<..(..|
    .BYTE $C8, $C3, $29, $02, $CD, $31, $03, $11 ; $D320 [IDENTIFIED_DATA] |..)..1..|
    .BYTE $80, $FF, $19, $CD, $44, $03, $20, $F7 ; $D328 [IDENTIFIED_DATA] |....D. .|
    .BYTE $C9, $5E, $16, $00, $7B, $B7, $CA, $1B ; $D330 [IDENTIFIED_DATA] |.^..{...|
    .BYTE $05, $EB, $29, $22, $00, $3C, $EB, $2B ; $D338 [IDENTIFIED_DATA] |..)".<.+|
    .BYTE $66, $2E, $00, $C9, $E5, $2A, $07, $3C ; $D340 [IDENTIFIED_DATA] |f....*.<|
    .BYTE $EB, $2A, $04, $3C, $CD, $FA, $00, $CC ; $D348 [IDENTIFIED_DATA] |.*.<....|
    .BYTE $6D, $03, $EB, $21, $80, $00, $19, $22 ; $D350 [IDENTIFIED_DATA] |m..!..."|
    .BYTE $04, $3C, $E1, $E5, $EB, $01, $80, $00 ; $D358 [IDENTIFIED_DATA] |.<......|
    .BYTE $ED, $B0, $2A, $00, $3C, $2B, $22, $00 ; $D360 [IDENTIFIED_DATA] |..*.<+".|
    .BYTE $3C, $7D, $B4, $E1, $C9, $21, $00, $34 ; $D368 [IDENTIFIED_DATA] |<}...!.4|
    .BYTE $22, $18, $FD, $E5, $2A, $02, $3C, $16 ; $D370 [IDENTIFIED_DATA] |"...*.<.|
    .BYTE $00, $5E, $23, $22, $02, $3C, $EB, $29 ; $D378 [IDENTIFIED_DATA] |.^#".<.)|
    .BYTE $29, $3A, $06, $3C, $0F, $0F, $0F, $FE ; $D380 [IDENTIFIED_DATA] |):.<....|
    .BYTE $04, $28, $01, $29, $22, $16, $FD, $3D ; $D388 [IDENTIFIED_DATA] |.(.)"..=|
    .BYTE $32, $05, $FD, $F5, $3E, $01, $32, $BD ; $D390 [IDENTIFIED_DATA] |2...>.2.|
    .BYTE $31, $CD, $E3, $03, $2A, $16, $FD, $23 ; $D398 [IDENTIFIED_DATA] |1...*..#|
    .BYTE $22, $16, $FD, $F1, $28, $2A, $3A, $08 ; $D3A0 [IDENTIFIED_DATA] |"...(*:.|
    .BYTE $FD, $A7, $28, $24, $2A, $03, $FD, $E5 ; $D3A8 [IDENTIFIED_DATA] |..($*...|
    .BYTE $CD, $E3, $03, $E1, $3A, $03, $FD, $BD ; $D3B0 [IDENTIFIED_DATA] |....:...|
    .BYTE $20, $13, $E5, $2A, $16, $FD, $23, $22 ; $D3B8 [IDENTIFIED_DATA] | ..*..#"|
    .BYTE $16, $FD, $21, $BD, $31, $34, $21, $05 ; $D3C0 [IDENTIFIED_DATA] |..!.14!.|
    .BYTE $FD, $35, $20, $E4, $E1, $22, $03, $FD ; $D3C8 [IDENTIFIED_DATA] |.5 .."..|
    .BYTE $CD, $4F, $04, $21, $19, $FD, $3A, $BD ; $D3D0 [IDENTIFIED_DATA] |.O.!..:.|
    .BYTE $31, $86, $77, $3A, $05, $FD, $A7, $20 ; $D3D8 [IDENTIFIED_DATA] |1.w:... |
    .BYTE $AE, $E1, $C9, $3E, $23, $32, $00, $24 ; $D3E0 [IDENTIFIED_DATA] |...>#2.$|
    .BYTE $2A, $16, $FD, $11, $A8, $02, $B7, $ED ; $D3E8 [IDENTIFIED_DATA] |*.......|
    .BYTE $52, $30, $05, $AF, $32, $00, $24, $19 ; $D3F0 [IDENTIFIED_DATA] |R0..2.$.|
    .BYTE $23, $23, $11, $65, $01, $01, $00, $15 ; $D3F8 [IDENTIFIED_DATA] |##.e....|
SID_BASE:
    .BYTE $B7, $ED, $52, $38, $1B, $23, $11, $85 ; $D400 [IDENTIFIED_DATA] |..R8.#..|
    .BYTE $00, $01, $11, $13, $ED, $52, $38, $10 ; $D408 [IDENTIFIED_DATA] |.....R8.|
    .BYTE $11, $6C, $00, $01, $18, $12, $ED, $52 ; $D410 [IDENTIFIED_DATA] |.l.....R|
    .BYTE $38, $06, $11, $00, $00, $01, $1E, $11 ; $D418 [IDENTIFIED_DATA] |8.......|
    .BYTE $19, $16, $00, $58, $B7, $0C, $ED, $52 ; $D420 [IDENTIFIED_DATA] |...X...R|
    .BYTE $30, $FB, $19, $3A, $00, $24, $81, $32 ; $D428 [IDENTIFIED_DATA] |0..:.$.2|
    .BYTE $03, $FD, $E5, $21, $B5, $0F, $01, $15 ; $D430 [IDENTIFIED_DATA] |...!....|
    .BYTE $00, $7B, $B9, $28, $0A, $09, $0B, $0B ; $D438 [IDENTIFIED_DATA] |.{.(....|
    .BYTE $B9, $28, $04, $09, $0B, $18, $F9, $C1 ; $D440 [IDENTIFIED_DATA] |.(......|
    .BYTE $09, $7E, $32, $04, $FD, $3C, $C9, $3E ; $D448 [IDENTIFIED_DATA] |.~2..<.>|
    .BYTE $03, $32, $36, $3C, $3E, $01, $32, $01 ; $D450 [IDENTIFIED_DATA] |.26<>.2.|
    .BYTE $FD, $CD, $8C, $05, $CD, $E0, $FF, $3E ; $D458 [IDENTIFIED_DATA] |.......>|
    .BYTE $3F, $32, $00, $FF, $3A, $06, $FD, $B7 ; $D460 [IDENTIFIED_DATA] |?2..:...|
    .BYTE $20, $32, $C9, $21, $00, $FE, $7E, $FE ; $D468 [IDENTIFIED_DATA] | 2.!..~.|
    .BYTE $43, $C0, $2C, $7E, $FE, $42, $C0, $2C ; $D470 [IDENTIFIED_DATA] |C.,~.B.,|
    .BYTE $7E, $FE, $4D, $C0, $2E, $FF, $7E, $C9 ; $D478 [IDENTIFIED_DATA] |~.M...~.|
    .BYTE $CD, $26, $05, $93, $05, $33, $32, $4B ; $D480 [IDENTIFIED_DATA] |.&...32K|
    .BYTE $20, $4D, $41, $58, $20, $43, $50, $4D ; $D488 [IDENTIFIED_DATA] | MAX CPM|
    .BYTE $2B, $2E, $53, $59, $53, $20, $53, $49 ; $D490 [IDENTIFIED_DATA] |+.SYS SI|
    .BYTE $5A, $45, $00, $CF, $3C, $28, $FC, $3A ; $D498 [IDENTIFIED_DATA] |ZE..<(.:|
    .BYTE $36, $3C, $3D, $32, $36, $3C, $20, $AC ; $D4A0 [IDENTIFIED_DATA] |6<=26< .|
    .BYTE $CD, $26, $05, $93, $05, $52, $45, $41 ; $D4A8 [IDENTIFIED_DATA] |.&...REA|
    .BYTE $44, $20, $45, $52, $52, $4F, $52, $00 ; $D4B0 [IDENTIFIED_DATA] |D ERROR.|
    .BYTE $CD, $26, $05, $20, $2D, $20, $48, $49 ; $D4B8 [IDENTIFIED_DATA] |.&. - HI|
    .BYTE $54, $20, $52, $45, $54, $55, $52, $4E ; $D4C0 [IDENTIFIED_DATA] |T RETURN|
    .BYTE $20, $54, $4F, $20, $52, $45, $54, $52 ; $D4C8 [IDENTIFIED_DATA] | TO RETR|
    .BYTE $59, $94, $0F, $44, $45, $4C, $20, $54 ; $D4D0 [IDENTIFIED_DATA] |Y..DEL T|
    .BYTE $4F, $20, $45, $4E, $54, $45, $52, $20 ; $D4D8 [IDENTIFIED_DATA] |O ENTER |
    .BYTE $43, $31, $32, $38, $20, $4D, $4F, $44 ; $D4E0 [IDENTIFIED_DATA] |C128 MOD|
    .BYTE $45, $00, $01, $00, $DC, $3E, $FE, $ED ; $D4E8 [IDENTIFIED_DATA] |E....>..|
    .BYTE $79, $0C, $ED, $78, $E6, $02, $28, $A3 ; $D4F0 [IDENTIFIED_DATA] |y..x..(.|
    .BYTE $ED, $78, $E6, $01, $20, $EC, $C7, $CD ; $D4F8 [IDENTIFIED_DATA] |.x.. ...|
MMU_CR:
    .BYTE $26, $05, $93, $05, $4E, $4F, $00, $CD ; $D500 [IDENTIFIED_DATA] |&...NO..|
MMU_P0H:
    .BYTE $26, $05, $20, $43, $50, $4D, $2B, $2E ; $D508 [IDENTIFIED_DATA] |&. CPM+.|
    .BYTE $53, $59, $53, $20, $46, $49, $4C, $45 ; $D510 [IDENTIFIED_DATA] |SYS FILE|
    .BYTE $00, $18, $9D, $CD, $26, $05, $93, $05 ; $D518 [IDENTIFIED_DATA] |....&...|
    .BYTE $42, $41, $44, $00, $18, $E1, $E3, $CD ; $D520 [IDENTIFIED_DATA] |BAD.....|
    .BYTE $34, $05, $E3, $C9, $21, $FF, $FF, $22 ; $D528 [IDENTIFIED_DATA] |4...!.."|
    .BYTE $04, $24, $D5, $E1, $56, $23, $3A, $05 ; $D530 [IDENTIFIED_DATA] |.$..V#:.|
    .BYTE $24, $A7, $28, $05, $AA, $32, $05, $24 ; $D538 [IDENTIFIED_DATA] |$.(..2.$|
    .BYTE $57, $7A, $B7, $C8, $FE, $24, $C8, $E5 ; $D540 [IDENTIFIED_DATA] |Wz...$..|
    .BYTE $21, $33, $05, $E5, $FE, $0A, $C8, $FE ; $D548 [IDENTIFIED_DATA] |!3......|
    .BYTE $0D, $20, $0B, $CD, $45, $0A, $CD, $F1 ; $D550 [IDENTIFIED_DATA] |. ..E...|
    .BYTE $06, $CD, $F1, $09, $DF, $0C, $FE, $FF ; $D558 [IDENTIFIED_DATA] |........|
    .BYTE $20, $17, $11, $00, $18, $CD, $85, $05 ; $D560 [IDENTIFIED_DATA] | .......|
    .BYTE $CD, $48, $0A, $CD, $7A, $07, $11, $00 ; $D568 [IDENTIFIED_DATA] |.H..z...|
    .BYTE $00, $CD, $85, $05, $CD, $62, $0A, $DF ; $D570 [IDENTIFIED_DATA] |.....b..|
    .BYTE $20, $E6, $80, $28, $39, $C1, $E1, $5E ; $D578 [IDENTIFIED_DATA] | ..(9..^|
    .BYTE $23, $E5, $C5, $CB, $BA, $D5, $CD, $BC ; $D580 [IDENTIFIED_DATA] |#.......|
    .BYTE $09, $D1, $DF, $04, $11, $4A, $18, $CD ; $D588 [IDENTIFIED_DATA] |.....J..|
    .BYTE $AB, $06, $11, $22, $18, $CD, $BC, $09 ; $D590 [IDENTIFIED_DATA] |..."....|
    .BYTE $3A, $03, $FD, $CD, $A6, $05, $16, $20 ; $D598 [IDENTIFIED_DATA] |:...... |
    .BYTE $CD, $B6, $05, $3A, $04, $FD, $06, $2F ; $D5A0 [IDENTIFIED_DATA] |...:.../|
    .BYTE $04, $D6, $0A, $30, $FB, $C6, $3A, $F5 ; $D5A8 [IDENTIFIED_DATA] |...0..:.|
    .BYTE $78, $CD, $B5, $05, $F1, $57, $D5, $CD ; $D5B0 [IDENTIFIED_DATA] |x....W..|
    .BYTE $6E, $09, $D1, $DF, $00, $21, $04, $30 ; $D5B8 [IDENTIFIED_DATA] |n....!.0|
    .BYTE $CD, $3D, $09, $04, $05, $C8, $21, $00 ; $D5C0 [IDENTIFIED_DATA] |.=....!.|
    .BYTE $38, $01, $00, $04, $16, $00, $CD, $47 ; $D5C8 [IDENTIFIED_DATA] |8......G|
    .BYTE $08, $21, $A0, $37, $11, $A0, $38, $01 ; $D5D0 [IDENTIFIED_DATA] |.!.7..8.|
    .BYTE $08, $00, $CD, $B0, $08, $21, $90, $36 ; $D5D8 [IDENTIFIED_DATA] |.....!.6|
    .BYTE $11, $90, $38, $01, $08, $00, $CD, $B0 ; $D5E0 [IDENTIFIED_DATA] |..8.....|
    .BYTE $08, $21, $E0, $35, $11, $E0, $38, $01 ; $D5E8 [IDENTIFIED_DATA] |.!.5..8.|
    .BYTE $18, $00, $CD, $B0, $08, $21, $10, $30 ; $D5F0 [IDENTIFIED_DATA] |.....!.0|
    .BYTE $11, $10, $36, $01, $98, $01, $CD, $B0 ; $D5F8 [IDENTIFIED_DATA] |..6.....|
VDC_ADDR_STATUS:
    .BYTE $08, $21, $00, $30, $01, $00, $02, $16 ; $D600 [IDENTIFIED_DATA] |.!.0....|
    .BYTE $00, $CD, $47, $08, $21, $00, $20, $11 ; $D608 [IDENTIFIED_DATA] |..G.!. .|
    .BYTE $00, $34, $01, $08, $00, $CD, $B0, $08 ; $D610 [IDENTIFIED_DATA] |.4......|
    .BYTE $21, $B0, $21, $11, $B0, $35, $01, $28 ; $D618 [IDENTIFIED_DATA] |!.!..5.(|
    .BYTE $00, $CD, $B0, $08, $21, $C0, $21, $11 ; $D620 [IDENTIFIED_DATA] |....!.!.|
    .BYTE $00, $38, $01, $08, $00, $CD, $B0, $08 ; $D628 [IDENTIFIED_DATA] |.8......|
    .BYTE $21, $E0, $21, $11, $10, $38, $01, $18 ; $D630 [IDENTIFIED_DATA] |!.!..8..|
    .BYTE $00, $CD, $B0, $08, $21, $00, $24, $11 ; $D638 [IDENTIFIED_DATA] |....!.$.|
    .BYTE $00, $3C, $01, $F8, $03, $CD, $B0, $08 ; $D640 [IDENTIFIED_DATA] |.<......|
    .BYTE $11, $1A, $0F, $21, $C0, $35, $CD, $70 ; $D648 [IDENTIFIED_DATA] |...!.5.p|
    .BYTE $06, $21, $E0, $35, $06, $03, $CD, $62 ; $D650 [IDENTIFIED_DATA] |.!.5...b|
    .BYTE $06, $21, $B0, $37, $06, $05, $18, $02 ; $D658 [IDENTIFIED_DATA] |.!.7....|
    .BYTE $E1, $E3, $C5, $E5, $CD, $70, $06, $E1 ; $D660 [IDENTIFIED_DATA] |.....p..|
    .BYTE $01, $10, $00, $09, $C1, $10, $F3, $C9 ; $D668 [IDENTIFIED_DATA] |........|
    .BYTE $CD, $53, $09, $26, $08, $1A, $ED, $79 ; $D670 [IDENTIFIED_DATA] |.S.&...y|
    .BYTE $0D, $13, $ED, $78, $17, $30, $FB, $0C ; $D678 [IDENTIFIED_DATA] |...x.0..|
    .BYTE $25, $20, $F2, $C9, $2A, $11, $24, $CD ; $D680 [IDENTIFIED_DATA] |% ..*.$.|
    .BYTE $07, $09, $3A, $13, $24, $FE, $4F, $28 ; $D688 [IDENTIFIED_DATA] |..:.$.O(|
    .BYTE $3C, $3C, $32, $13, $24, $2A, $11, $24 ; $D690 [IDENTIFIED_DATA] |<<2.$*.$|
    .BYTE $23, $22, $11, $24, $3E, $0E, $CD, $45 ; $D698 [IDENTIFIED_DATA] |#".$>..E|
    .BYTE $09, $ED, $61, $3E, $0F, $CD, $45, $09 ; $D6A0 [IDENTIFIED_DATA] |..a>..E.|
    .BYTE $ED, $69, $C9, $7A, $FE, $19, $D0, $7B ; $D6A8 [IDENTIFIED_DATA] |.i.z...{|
    .BYTE $FE, $50, $D0, $EB, $22, $13, $24, $2A ; $D6B0 [IDENTIFIED_DATA] |.P..".$*|
    .BYTE $13, $24, $CD, $CE, $0C, $22, $11, $24 ; $D6B8 [IDENTIFIED_DATA] |.$...".$|
    .BYTE $18, $DA, $3A, $14, $24, $B7, $C8, $3D ; $D6C0 [IDENTIFIED_DATA] |..:.$..=|
    .BYTE $32, $14, $24, $18, $EA, $AF, $32, $13 ; $D6C8 [IDENTIFIED_DATA] |2.$...2.|
    .BYTE $24, $3A, $14, $24, $FE, $17, $28, $21 ; $D6D0 [IDENTIFIED_DATA] |$:.$..(!|
    .BYTE $30, $1A, $3C, $18, $EB, $3A, $13, $24 ; $D6D8 [IDENTIFIED_DATA] |0.<..:.$|
    .BYTE $B7, $C8, $3D, $32, $13, $24, $18, $CF ; $D6E0 [IDENTIFIED_DATA] |..=2.$..|
    .BYTE $3A, $13, $24, $3C, $FE, $50, $20, $F3 ; $D6E8 [IDENTIFIED_DATA] |:.$<.P .|
    .BYTE $C9, $AF, $18, $EF, $3E, $17, $32, $14 ; $D6F0 [IDENTIFIED_DATA] |....>.2.|
    .BYTE $24, $21, $50, $00, $11, $00, $00, $01 ; $D6F8 [IDENTIFIED_DATA] |$!P.....|
    .BYTE $30, $07, $CD, $B0, $08, $21, $30, $07 ; $D700 [IDENTIFIED_DATA] |0....!0.|
    .BYTE $01, $50, $00, $CD, $41, $08, $18, $A7 ; $D708 [IDENTIFIED_DATA] |.P..A...|
    .BYTE $3A, $15, $24, $2F, $B0, $2F, $B1, $32 ; $D710 [IDENTIFIED_DATA] |:.$/./.2|
    .BYTE $15, $24, $C9, $78, $D6, $20, $FE, $20 ; $D718 [IDENTIFIED_DATA] |.$.x. . |
    .BYTE $38, $0A, $0E, $20, $CD, $E5, $0C, $D8 ; $D720 [IDENTIFIED_DATA] |8.. ....|
    .BYTE $7E, $E6, $0F, $80, $32, $00, $24, $0E ; $D728 [IDENTIFIED_DATA] |~...2.$.|
    .BYTE $20, $C6, $30, $21, $0A, $0F, $CD, $E8 ; $D730 [IDENTIFIED_DATA] | .0!....|
    .BYTE $0C, $7E, $80, $FE, $10, $38, $1B, $E6 ; $D738 [IDENTIFIED_DATA] |.~...8..|
    .BYTE $0F, $32, $16, $24, $F5, $3E, $1A, $CD ; $D740 [IDENTIFIED_DATA] |.2.$.>..|
    .BYTE $45, $09, $F1, $ED, $79, $C9, $3A, $16 ; $D748 [IDENTIFIED_DATA] |E...y.:.|
    .BYTE $24, $47, $3A, $15, $24, $57, $3A, $17 ; $D750 [IDENTIFIED_DATA] |$G:.$W:.|
    .BYTE $24, $C9, $47, $3A, $15, $24, $E6, $F0 ; $D758 [IDENTIFIED_DATA] |$.G:.$..|
    .BYTE $B0, $32, $15, $24, $3A, $00, $24, $32 ; $D760 [IDENTIFIED_DATA] |.2.$:.$2|
    .BYTE $17, $24, $2A, $11, $24, $11, $00, $08 ; $D768 [IDENTIFIED_DATA] |.$*.$...|
    .BYTE $19, $CD, $53, $09, $3A, $15, $24, $ED ; $D770 [IDENTIFIED_DATA] |..S.:.$.|
    .BYTE $79, $C9, $CD, $C7, $0C, $03, $18, $0E ; $D778 [IDENTIFIED_DATA] |y.......|
    .BYTE $CD, $C7, $0C, $EB, $21, $80, $07, $AF ; $D780 [IDENTIFIED_DATA] |....!...|
    .BYTE $ED, $52, $F8, $44, $4D, $EB, $C3, $41 ; $D788 [IDENTIFIED_DATA] |.R.DM..A|
    .BYTE $08, $CD, $C7, $0C, $21, $4F, $00, $19 ; $D790 [IDENTIFIED_DATA] |....!O..|
    .BYTE $3D, $28, $2C, $54, $5D, $2B, $C5, $E5 ; $D798 [IDENTIFIED_DATA] |=(,T]+..|
    .BYTE $D5, $CD, $AD, $07, $01, $00, $08, $E1 ; $D7A0 [IDENTIFIED_DATA] |........|
    .BYTE $09, $EB, $E1, $09, $C1, $C5, $CD, $53 ; $D7A8 [IDENTIFIED_DATA] |.......S|
    .BYTE $09, $ED, $78, $EB, $F5, $CD, $53, $09 ; $D7B0 [IDENTIFIED_DATA] |..x...S.|
    .BYTE $F1, $ED, $79, $EB, $C1, $2B, $1B, $0B ; $D7B8 [IDENTIFIED_DATA] |..y..+..|
    .BYTE $78, $B1, $20, $E9, $2A, $11, $24, $C3 ; $D7C0 [IDENTIFIED_DATA] |x. .*.$.|
    .BYTE $05, $09, $CD, $C7, $0C, $D5, $54, $5D ; $D7C8 [IDENTIFIED_DATA] |......T]|
    .BYTE $23, $CD, $B0, $08, $E1, $11, $4F, $00 ; $D7D0 [IDENTIFIED_DATA] |#.....O.|
    .BYTE $19, $C3, $05, $09, $11, $62, $0F, $3E ; $D7D8 [IDENTIFIED_DATA] |.....b.>|
    .BYTE $17, $2A, $13, $24, $BC, $CA, $05, $07 ; $D7E0 [IDENTIFIED_DATA] |.*.$....|
    .BYTE $38, $1A, $21, $E0, $06, $11, $30, $07 ; $D7E8 [IDENTIFIED_DATA] |8.!...0.|
    .BYTE $06, $18, $CD, $0A, $08, $3A, $14, $24 ; $D7F0 [IDENTIFIED_DATA] |.....:.$|
    .BYTE $B8, $20, $F7, $CD, $C7, $0C, $EB, $01 ; $D7F8 [IDENTIFIED_DATA] |. ......|
    .BYTE $50, $00, $18, $3D, $3C, $BD, $C0, $C3 ; $D800 [IDENTIFIED_DATA] |P..=<...|
    .BYTE $2C, $05, $C5, $E5, $D5, $01, $50, $00 ; $D808 [IDENTIFIED_DATA] |,.....P.|
    .BYTE $CD, $B0, $08, $01, $B0, $FF, $E1, $09 ; $D810 [IDENTIFIED_DATA] |........|
    .BYTE $EB, $E1, $09, $C1, $05, $C9, $3A, $14 ; $D818 [IDENTIFIED_DATA] |......:.|
    .BYTE $24, $FE, $18, $D0, $CD, $C7, $0C, $21 ; $D820 [IDENTIFIED_DATA] |$......!|
    .BYTE $50, $00, $19, $EB, $E5, $21, $80, $07 ; $D828 [IDENTIFIED_DATA] |P....!..|
    .BYTE $AF, $ED, $52, $44, $4D, $E1, $EB, $CD ; $D830 [IDENTIFIED_DATA] |..RDM...|
    .BYTE $B0, $08, $C3, $05, $07, $E1, $E3, $18 ; $D838 [IDENTIFIED_DATA] |........|
    .BYTE $06, $3A, $15, $24, $5F, $16, $20, $78 ; $D840 [IDENTIFIED_DATA] |.:.$_. x|
    .BYTE $A7, $28, $0D, $E5, $D5, $C5, $AF, $CD ; $D848 [IDENTIFIED_DATA] |.(......|
    .BYTE $5B, $08, $C1, $D1, $E1, $24, $10, $F3 ; $D850 [IDENTIFIED_DATA] |[....$..|
    .BYTE $79, $A7, $C8, $F5, $E5, $D5, $CD, $6C ; $D858 [IDENTIFIED_DATA] |y......l|
    .BYTE $08, $D1, $01, $00, $08, $E1, $09, $CD ; $D860 [IDENTIFIED_DATA] |........|
    .BYTE $FE, $08, $F1, $53, $F5, $CD, $53, $09 ; $D868 [IDENTIFIED_DATA] |...S..S.|
    .BYTE $ED, $51, $F1, $3D, $C8, $F5, $3E, $18 ; $D870 [IDENTIFIED_DATA] |.Q.=..>.|
    .BYTE $CD, $45, $09, $ED, $78, $E6, $7F, $ED ; $D878 [IDENTIFIED_DATA] |.E..x...|
    .BYTE $79, $3E, $1E, $CD, $45, $09, $F1, $ED ; $D880 [IDENTIFIED_DATA] |y>..E...|
    .BYTE $79, $06, $00, $4F, $03, $09, $D5, $E5 ; $D888 [IDENTIFIED_DATA] |y..O....|
    .BYTE $3E, $12, $CD, $45, $09, $ED, $60, $3E ; $D890 [IDENTIFIED_DATA] |>..E..`>|
    .BYTE $13, $CD, $45, $09, $ED, $68, $D1, $C1 ; $D898 [IDENTIFIED_DATA] |..E..h..|
    .BYTE $CD, $FA, $00, $D0, $C5, $CD, $53, $09 ; $D8A0 [IDENTIFIED_DATA] |......S.|
    .BYTE $C1, $ED, $41, $23, $18, $F2, $E1, $E3 ; $D8A8 [IDENTIFIED_DATA] |..A#....|
    .BYTE $78, $A7, $28, $0E, $E5, $D5, $C5, $AF ; $D8B0 [IDENTIFIED_DATA] |x.(.....|
    .BYTE $CD, $C5, $08, $C1, $D1, $E1, $24, $14 ; $D8B8 [IDENTIFIED_DATA] |......$.|
    .BYTE $10, $F2, $79, $A7, $C8, $EB, $F5, $E5 ; $D8C0 [IDENTIFIED_DATA] |..y.....|
    .BYTE $D5, $CD, $D8, $08, $01, $00, $08, $E1 ; $D8C8 [IDENTIFIED_DATA] |........|
    .BYTE $09, $EB, $E1, $09, $CD, $FE, $08, $F1 ; $D8D0 [IDENTIFIED_DATA] |........|
    .BYTE $F5, $CD, $53, $09, $3E, $18, $CD, $45 ; $D8D8 [IDENTIFIED_DATA] |..S.>..E|
    .BYTE $09, $ED, $78, $F6, $80, $ED, $79, $3E ; $D8E0 [IDENTIFIED_DATA] |..x...y>|
    .BYTE $20, $CD, $45, $09, $ED, $51, $3E, $21 ; $D8E8 [IDENTIFIED_DATA] | .E..Q>!|
    .BYTE $CD, $45, $09, $ED, $59, $3E, $1E, $CD ; $D8F0 [IDENTIFIED_DATA] |.E..Y>..|
    .BYTE $45, $09, $F1, $ED, $79, $C9, $7C, $FE ; $D8F8 [IDENTIFIED_DATA] |E...y.|.|
    .BYTE $20, $D8, $F1, $F1, $C9, $16, $20, $3A ; $D900 [IDENTIFIED_DATA] | ..... :|
    .BYTE $15, $24, $E5, $D5, $11, $00, $08, $19 ; $D908 [IDENTIFIED_DATA] |.$......|
    .BYTE $57, $CD, $16, $09, $D1, $E1, $CD, $53 ; $D910 [IDENTIFIED_DATA] |W......S|
    .BYTE $09, $ED, $51, $C9, $CD, $AB, $06, $2A ; $D918 [IDENTIFIED_DATA] |..Q....*|
    .BYTE $11, $24, $CD, $33, $09, $4F, $C9, $C5 ; $D920 [IDENTIFIED_DATA] |.$.3.O..|
    .BYTE $CD, $AB, $06, $2A, $11, $24, $C1, $50 ; $D928 [IDENTIFIED_DATA] |...*.$.P|
    .BYTE $79, $18, $D7, $E5, $11, $00, $08, $19 ; $D930 [IDENTIFIED_DATA] |y.......|
    .BYTE $CD, $3D, $09, $78, $E1, $F5, $CD, $53 ; $D938 [IDENTIFIED_DATA] |.=.x...S|
    .BYTE $09, $F1, $ED, $40, $C9, $F5, $01, $00 ; $D940 [IDENTIFIED_DATA] |...@....|
    .BYTE $D6, $ED, $78, $17, $30, $FB, $F1, $ED ; $D948 [IDENTIFIED_DATA] |..x.0...|
    .BYTE $79, $0C, $C9, $3E, $12, $CD, $45, $09 ; $D950 [IDENTIFIED_DATA] |y..>..E.|
    .BYTE $ED, $61, $3E, $13, $CD, $45, $09, $ED ; $D958 [IDENTIFIED_DATA] |.a>..E..|
    .BYTE $69, $3E, $1F, $CD, $45, $09, $0D, $ED ; $D960 [IDENTIFIED_DATA] |i>..E...|
    .BYTE $78, $17, $30, $FB, $0C, $C9, $42, $CD ; $D968 [IDENTIFIED_DATA] |x.0...B.|
    .BYTE $7F, $0C, $2A, $09, $24, $47, $3A, $10 ; $D970 [IDENTIFIED_DATA] |..*.$G:.|
    .BYTE $24, $B0, $77, $23, $22, $09, $24, $11 ; $D978 [IDENTIFIED_DATA] |$.w#".$.|
    .BYTE $FF, $07, $19, $3A, $0D, $24, $77, $3A ; $D980 [IDENTIFIED_DATA] |...:.$w:|
    .BYTE $0B, $24, $FE, $4F, $28, $5F, $3C, $32 ; $D988 [IDENTIFIED_DATA] |.$.O(_<2|
    .BYTE $0B, $24, $C3, $4A, $0C, $CD, $C1, $09 ; $D990 [IDENTIFIED_DATA] |.$.J....|
    .BYTE $2A, $09, $24, $46, $11, $00, $08, $19 ; $D998 [IDENTIFIED_DATA] |*.$F....|
    .BYTE $4E, $C9, $C5, $CD, $C1, $09, $C1, $2A ; $D9A0 [IDENTIFIED_DATA] |N......*|
    .BYTE $09, $24, $78, $E6, $7F, $CB, $71, $28 ; $D9A8 [IDENTIFIED_DATA] |.$x...q(|
    .BYTE $02, $C6, $80, $77, $11, $00, $08, $19 ; $D9B0 [IDENTIFIED_DATA] |...w....|
    .BYTE $71, $C3, $4A, $0C, $21, $04, $24, $CB ; $D9B8 [IDENTIFIED_DATA] |q.J.!.$.|
    .BYTE $F6, $7A, $FE, $19, $D0, $7B, $FE, $50 ; $D9C0 [IDENTIFIED_DATA] |.z...{.P|
    .BYTE $D0, $EB, $22, $0B, $24, $2A, $0B, $24 ; $D9C8 [IDENTIFIED_DATA] |..".$*.$|
    .BYTE $CD, $CE, $0C, $11, $00, $14, $19, $22 ; $D9D0 [IDENTIFIED_DATA] |......."|
    .BYTE $09, $24, $C3, $4A, $0C, $3A, $0C, $24 ; $D9D8 [IDENTIFIED_DATA] |.$.J.:.$|
    .BYTE $B7, $C8, $3D, $32, $0C, $24, $21, $04 ; $D9E0 [IDENTIFIED_DATA] |..=2.$!.|
    .BYTE $24, $CB, $F6, $18, $E0, $AF, $32, $0B ; $D9E8 [IDENTIFIED_DATA] |$.....2.|
    .BYTE $24, $3A, $0C, $24, $FE, $17, $28, $0A ; $D9F0 [IDENTIFIED_DATA] |$:.$..(.|
    .BYTE $30, $03, $3C, $18, $E6, $3E, $17, $32 ; $D9F8 [IDENTIFIED_DATA] |0.<..>.2|
    .BYTE $0C, $24, $21, $50, $14, $11, $00, $14 ; $DA00 [IDENTIFIED_DATA] |.$!P....|
    .BYTE $01, $30, $07, $ED, $B0, $EB, $11, $31 ; $DA08 [IDENTIFIED_DATA] |.0.....1|
    .BYTE $1B, $01, $4F, $00, $CD, $24, $0B, $21 ; $DA10 [IDENTIFIED_DATA] |..O..$.!|
    .BYTE $50, $1C, $11, $00, $1C, $01, $30, $07 ; $DA18 [IDENTIFIED_DATA] |P.....0.|
    .BYTE $ED, $B0, $EB, $11, $31, $23, $01, $4F ; $DA20 [IDENTIFIED_DATA] |....1#.O|
    .BYTE $00, $3A, $0D, $24, $77, $ED, $B0, $18 ; $DA28 [IDENTIFIED_DATA] |.:.$w...|
    .BYTE $B5, $3A, $0B, $24, $B7, $C8, $3D, $32 ; $DA30 [IDENTIFIED_DATA] |.:.$..=2|
    .BYTE $0B, $24, $18, $91, $3A, $0B, $24, $3C ; $DA38 [IDENTIFIED_DATA] |.$..:.$<|
    .BYTE $FE, $50, $20, $F3, $C9, $AF, $18, $EF ; $DA40 [IDENTIFIED_DATA] |.P .....|
    .BYTE $21, $CF, $0B, $E5, $CD, $C2, $0C, $11 ; $DA48 [IDENTIFIED_DATA] |!.......|
    .BYTE $00, $14, $19, $CD, $B3, $0A, $79, $A7 ; $DA50 [IDENTIFIED_DATA] |......y.|
    .BYTE $C8, $C5, $E5, $54, $5D, $13, $ED, $B0 ; $DA58 [IDENTIFIED_DATA] |...T]...|
    .BYTE $18, $1C, $21, $0C, $0C, $E5, $11, $7F ; $DA60 [IDENTIFIED_DATA] |..!.....|
    .BYTE $1B, $2A, $09, $24, $EB, $AF, $ED, $52 ; $DA68 [IDENTIFIED_DATA] |.*.$...R|
    .BYTE $F8, $EB, $28, $3F, $42, $4B, $54, $5D ; $DA70 [IDENTIFIED_DATA] |..(?BKT]|
    .BYTE $13, $C5, $E5, $CD, $24, $0B, $01, $00 ; $DA78 [IDENTIFIED_DATA] |....$...|
    .BYTE $08, $E1, $09, $C1, $54, $5D, $13, $3A ; $DA80 [IDENTIFIED_DATA] |....T].:|
    .BYTE $0D, $24, $77, $ED, $B0, $C9, $21, $CF ; $DA88 [IDENTIFIED_DATA] |.$w...!.|
    .BYTE $0B, $E5, $CD, $C2, $0C, $21, $4F, $14 ; $DA90 [IDENTIFIED_DATA] |.....!O.|
    .BYTE $19, $3D, $28, $17, $54, $5D, $2B, $C5 ; $DA98 [IDENTIFIED_DATA] |.=(.T]+.|
    .BYTE $D5, $ED, $B8, $EB, $CD, $B3, $0A, $E1 ; $DAA0 [IDENTIFIED_DATA] |........|
    .BYTE $01, $00, $08, $09, $C1, $54, $5D, $2B ; $DAA8 [IDENTIFIED_DATA] |.....T]+|
    .BYTE $ED, $B8, $C9, $3A, $10, $24, $C6, $20 ; $DAB0 [IDENTIFIED_DATA] |...:.$. |
    .BYTE $77, $C9, $21, $CF, $0B, $E5, $CD, $C2 ; $DAB8 [IDENTIFIED_DATA] |w.!.....|
    .BYTE $0C, $11, $00, $14, $19, $3D, $28, $EB ; $DAC0 [IDENTIFIED_DATA] |.....=(.|
    .BYTE $54, $5D, $C5, $E5, $23, $ED, $B0, $EB ; $DAC8 [IDENTIFIED_DATA] |T]..#...|
    .BYTE $CD, $B3, $0A, $E1, $01, $01, $08, $09 ; $DAD0 [IDENTIFIED_DATA] |........|
    .BYTE $C1, $54, $5D, $23, $ED, $B0, $C9, $21 ; $DAD8 [IDENTIFIED_DATA] |.T]#...!|
    .BYTE $0C, $0C, $E5, $3A, $0C, $24, $FE, $17 ; $DAE0 [IDENTIFIED_DATA] |...:.$..|
    .BYTE $28, $31, $D0, $CD, $C2, $0C, $21, $00 ; $DAE8 [IDENTIFIED_DATA] |(1....!.|
    .BYTE $14, $19, $E5, $11, $50, $00, $19, $EB ; $DAF0 [IDENTIFIED_DATA] |....P...|
    .BYTE $21, $80, $1B, $AF, $ED, $52, $44, $4D ; $DAF8 [IDENTIFIED_DATA] |!....RDM|
    .BYTE $21, $2F, $1B, $11, $7F, $1B, $C5, $ED ; $DB00 [IDENTIFIED_DATA] |!/......|
    .BYTE $B8, $C1, $21, $2F, $23, $11, $7F, $23 ; $DB08 [IDENTIFIED_DATA] |..!/#..#|
    .BYTE $ED, $B8, $E1, $54, $5D, $13, $01, $4F ; $DB10 [IDENTIFIED_DATA] |...T]..O|
    .BYTE $00, $18, $09, $21, $30, $1B, $11, $31 ; $DB18 [IDENTIFIED_DATA] |...!0..1|
    .BYTE $1B, $01, $4F, $00, $3A, $10, $24, $C6 ; $DB20 [IDENTIFIED_DATA] |..O.:.$.|
    .BYTE $20, $77, $ED, $B0, $C9, $21, $0C, $0C ; $DB28 [IDENTIFIED_DATA] | w...!..|
    .BYTE $E5, $3A, $0C, $24, $FE, $17, $28, $E3 ; $DB30 [IDENTIFIED_DATA] |.:.$..(.|
    .BYTE $D0, $CD, $C2, $0C, $21, $00, $14, $19 ; $DB38 [IDENTIFIED_DATA] |....!...|
    .BYTE $E5, $11, $50, $00, $19, $EB, $21, $80 ; $DB40 [IDENTIFIED_DATA] |..P...!.|
    .BYTE $1B, $AF, $ED, $52, $44, $4D, $EB, $D1 ; $DB48 [IDENTIFIED_DATA] |...RDM..|
    .BYTE $C5, $E5, $D5, $ED, $B0, $01, $00, $08 ; $DB50 [IDENTIFIED_DATA] |........|
    .BYTE $E1, $09, $EB, $E1, $09, $C1, $ED, $B0 ; $DB58 [IDENTIFIED_DATA] |........|
    .BYTE $18, $B9, $78, $E6, $70, $47, $79, $E6 ; $DB60 [IDENTIFIED_DATA] |..x.pGy.|
    .BYTE $70, $4F, $3A, $0D, $24, $2F, $B0, $2F ; $DB68 [IDENTIFIED_DATA] |pO:.$/./|
    .BYTE $B1, $32, $0D, $24, $17, $E6, $80, $32 ; $DB70 [IDENTIFIED_DATA] |.2.$...2|
    .BYTE $10, $24, $C9, $78, $D6, $20, $FE, $30 ; $DB78 [IDENTIFIED_DATA] |.$.x. .0|
    .BYTE $38, $0E, $0E, $30, $CD, $E5, $0C, $D8 ; $DB80 [IDENTIFIED_DATA] |8..0....|
    .BYTE $7E, $0F, $0F, $0F, $0F, $E6, $0F, $80 ; $DB88 [IDENTIFIED_DATA] |~.......|
    .BYTE $FE, $10, $38, $29, $FE, $20, $38, $0B ; $DB90 [IDENTIFIED_DATA] |..8). 8.|
    .BYTE $E6, $0F, $32, $0F, $24, $01, $20, $D0 ; $DB98 [IDENTIFIED_DATA] |..2.$. .|
    .BYTE $ED, $79, $C9, $E6, $0F, $32, $0E, $24 ; $DBA0 [IDENTIFIED_DATA] |.y...2.$|
    .BYTE $01, $21, $D0, $ED, $79, $C9, $3A, $0E ; $DBA8 [IDENTIFIED_DATA] |.!..y.:.|
    .BYTE $24, $47, $3A, $0F, $24, $4F, $3A, $0D ; $DBB0 [IDENTIFIED_DATA] |$G:.$O:.|
    .BYTE $24, $57, $E6, $0F, $C9, $47, $3A, $0D ; $DBB8 [IDENTIFIED_DATA] |$W...G:.|
    .BYTE $24, $E6, $F0, $B0, $32, $0D, $24, $2A ; $DBC0 [IDENTIFIED_DATA] |$...2.$*|
    .BYTE $09, $24, $11, $00, $08, $19, $77, $3A ; $DBC8 [IDENTIFIED_DATA] |.$....w:|
    .BYTE $04, $24, $47, $B7, $FC, $3C, $0C, $3A ; $DBD0 [IDENTIFIED_DATA] |.$G..<.:|
    .BYTE $02, $24, $B8, $32, $04, $24, $20, $2C ; $DBD8 [IDENTIFIED_DATA] |.$.2.$ ,|
    .BYTE $CD, $C2, $0C, $21, $00, $14, $19, $EB ; $DBE0 [IDENTIFIED_DATA] |...!....|
    .BYTE $2A, $02, $24, $19, $E5, $3A, $0C, $24 ; $DBE8 [IDENTIFIED_DATA] |*.$..:.$|
    .BYTE $6F, $CD, $70, $0C, $EB, $E1, $E5, $D5 ; $DBF0 [IDENTIFIED_DATA] |o.p.....|
    .BYTE $3E, $01, $CD, $27, $0C, $E1, $01, $00 ; $DBF8 [IDENTIFIED_DATA] |>..'....|
CIA1_PRA:
    .BYTE $E4, $09, $EB, $E1, $01, $00, $08, $09 ; $DC00 [IDENTIFIED_DATA] |........|
    .BYTE $3E, $01, $18, $1B, $2A, $02, $24, $3A ; $DC08 [IDENTIFIED_DATA] |>...*.$:|
    .BYTE $08, $24, $E5, $F5, $11, $00, $14, $19 ; $DC10 [IDENTIFIED_DATA] |.$......|
    .BYTE $11, $00, $2C, $CD, $27, $0C, $F1, $E1 ; $DC18 [IDENTIFIED_DATA] |..,.'...|
    .BYTE $11, $00, $1C, $19, $11, $00, $10, $32 ; $DC20 [IDENTIFIED_DATA] |.......2|
    .BYTE $03, $FF, $01, $28, $00, $ED, $B0, $D5 ; $DC28 [IDENTIFIED_DATA] |...(....|
    .BYTE $11, $28, $00, $19, $D1, $3D, $20, $F2 ; $DC30 [IDENTIFIED_DATA] |.(...= .|
    .BYTE $32, $01, $FF, $C9, $3A, $0B, $24, $D6 ; $DC38 [IDENTIFIED_DATA] |2...:.$.|
    .BYTE $20, $30, $01, $AF, $E6, $F8, $32, $02 ; $DC40 [IDENTIFIED_DATA] | 0....2.|
    .BYTE $24, $C9, $CD, $69, $0C, $CD, $CF, $0B ; $DC48 [IDENTIFIED_DATA] |$..i....|
    .BYTE $3A, $02, $24, $47, $2A, $0B, $24, $7D ; $DC50 [IDENTIFIED_DATA] |:.$G*.$}|
    .BYTE $90, $38, $0E, $FE, $28, $30, $0A, $4F ; $DC58 [IDENTIFIED_DATA] |.8..(0.O|
    .BYTE $06, $00, $6C, $CD, $70, $0C, $09, $18 ; $DC60 [IDENTIFIED_DATA] |..l.p...|
    .BYTE $03, $21, $00, $00, $22, $06, $24, $C9 ; $DC68 [IDENTIFIED_DATA] |.!..".$.|
    .BYTE $26, $00, $29, $29, $29, $54, $5D, $29 ; $DC70 [IDENTIFIED_DATA] |&.)))T])|
    .BYTE $29, $19, $11, $00, $2C, $19, $C9, $78 ; $DC78 [IDENTIFIED_DATA] |)...,..x|
    .BYTE $FE, $40, $28, $3C, $D8, $FE, $5B, $D8 ; $DC80 [IDENTIFIED_DATA] |.@(<..[.|
    .BYTE $D6, $40, $FE, $20, $28, $19, $38, $23 ; $DC88 [IDENTIFIED_DATA] |.@. (.8#|
    .BYTE $D6, $20, $FE, $1B, $D8, $FE, $1B, $28 ; $DC90 [IDENTIFIED_DATA] |. .....(|
    .BYTE $11, $FE, $1C, $28, $10, $FE, $1D, $28 ; $DC98 [IDENTIFIED_DATA] |...(...(|
    .BYTE $0F, $FE, $1E, $C0, $3E, $40, $C9, $3E ; $DCA0 [IDENTIFIED_DATA] |....>@.>|
    .BYTE $7E, $C9, $3E, $73, $C9, $3E, $5D, $C9 ; $DCA8 [IDENTIFIED_DATA] |~.>s.>].|
    .BYTE $3E, $6B, $C9, $FE, $1C, $28, $06, $FE ; $DCB0 [IDENTIFIED_DATA] |>k...(..|
    .BYTE $1F, $C0, $3E, $64, $C9, $3E, $7F, $C9 ; $DCB8 [IDENTIFIED_DATA] |..>d.>..|
    .BYTE $AF, $C9, $2A, $0B, $24, $18, $03, $2A ; $DCC0 [IDENTIFIED_DATA] |..*.$..*|
    .BYTE $13, $24, $3E, $4F, $95, $4F, $45, $6C ; $DCC8 [IDENTIFIED_DATA] |.$>O.OEl|
    .BYTE $26, $00, $29, $29, $29, $29, $54, $5D ; $DCD0 [IDENTIFIED_DATA] |&.))))T]|
    .BYTE $29, $29, $19, $EB, $68, $26, $00, $19 ; $DCD8 [IDENTIFIED_DATA] |))..h&..|
    .BYTE $06, $00, $3C, $C9, $78, $2A, $0D, $FD ; $DCE0 [IDENTIFIED_DATA] |..<.x*..|
    .BYTE $D6, $30, $D8, $B9, $3F, $D8, $47, $E6 ; $DCE8 [IDENTIFIED_DATA] |.0..?.G.|
    .BYTE $0F, $5F, $16, $00, $19, $78, $E6, $30 ; $DCF0 [IDENTIFIED_DATA] |._...x.0|
    .BYTE $47, $C9, $01, $18, $D4, $2A, $10, $FD ; $DCF8 [IDENTIFIED_DATA] |G....*..|
CIA2_PRA:
    .BYTE $ED, $61, $0E, $05, $ED, $69, $2A, $12 ; $DD00 [IDENTIFIED_DATA] |.a...i*.|
    .BYTE $FD, $0C, $ED, $61, $0E, $01, $ED, $69 ; $DD08 [IDENTIFIED_DATA] |...a...i|
    .BYTE $2A, $14, $FD, $0E, $04, $ED, $61, $ED ; $DD10 [IDENTIFIED_DATA] |*.....a.|
    .BYTE $69, $C9, $A9, $00, $8D, $00, $FF, $6C ; $DD18 [IDENTIFIED_DATA] |i......l|
    .BYTE $FC, $FF, $A9, $00, $8D, $06, $FD, $20 ; $DD20 [IDENTIFIED_DATA] |....... |
    .BYTE $11, $30, $78, $A9, $3E, $8D, $00, $FF ; $DD28 [IDENTIFIED_DATA] |.0x.>...|
    .BYTE $4C, $D0, $FF, $D8, $AD, $01, $FD, $D0 ; $DD30 [IDENTIFIED_DATA] |L.......|
    .BYTE $21, $A2, $00, $8E, $00, $FF, $8E, $1A ; $DD38 [IDENTIFIED_DATA] |!.......|
    .BYTE $D0, $A2, $63, $A0, $31, $8E, $14, $03 ; $DD40 [IDENTIFIED_DATA] |..c.1...|
    .BYTE $8C, $15, $03, $8E, $16, $03, $8C, $17 ; $DD48 [IDENTIFIED_DATA] |........|
    .BYTE $03, $8E, $18, $03, $8C, $19, $03, $4C ; $DD50 [IDENTIFIED_DATA] |.......L|
    .BYTE $D7, $30, $AD, $18, $FD, $85, $20, $AD ; $DD58 [IDENTIFIED_DATA] |.0.... .|
    .BYTE $19, $FD, $85, $21, $AD, $03, $FD, $8D ; $DD60 [IDENTIFIED_DATA] |...!....|
    .BYTE $BF, $31, $20, $78, $31, $8E, $B1, $31 ; $DD68 [IDENTIFIED_DATA] |.1 x1..1|
    .BYTE $8D, $B0, $31, $AD, $04, $FD, $8D, $BE ; $DD70 [IDENTIFIED_DATA] |..1.....|
    .BYTE $31, $20, $78, $31, $8E, $AE, $31, $8D ; $DD78 [IDENTIFIED_DATA] |1 x1..1.|
    .BYTE $AD, $31, $AD, $08, $FD, $D0, $2B, $8D ; $DD80 [IDENTIFIED_DATA] |.1....+.|
    .BYTE $00, $FF, $A2, $0B, $20, $C6, $FF, $B0 ; $DD88 [IDENTIFIED_DATA] |.... ...|
    .BYTE $16, $20, $CC, $FF, $20, $31, $31, $20 ; $DD90 [IDENTIFIED_DATA] |. .. 11 |
    .BYTE $99, $31, $A0, $00, $20, $CF, $FF, $91 ; $DD98 [IDENTIFIED_DATA] |.1.. ...|
    .BYTE $20, $C8, $D0, $F8, $4C, $CC, $FF, $A9 ; $DDA0 [IDENTIFIED_DATA] | ...L...|
    .BYTE $FF, $2C, $A9, $0D, $8D, $06, $FD, $4C ; $DDA8 [IDENTIFIED_DATA] |.,.....L|
    .BYTE $08, $30, $A9, $00, $8D, $00, $FF, $A2 ; $DDB0 [IDENTIFIED_DATA] |.0......|
    .BYTE $0F, $20, $C9, $FF, $B0, $EC, $A0, $06 ; $DDB8 [IDENTIFIED_DATA] |. ......|
    .BYTE $B9, $BC, $31, $20, $D2, $FF, $88, $D0 ; $DDC0 [IDENTIFIED_DATA] |..1 ....|
    .BYTE $F7, $20, $CC, $FF, $2C, $0D, $DC, $AE ; $DDC8 [IDENTIFIED_DATA] |. ..,...|
    .BYTE $BD, $31, $20, $4F, $31, $29, $0E, $D0 ; $DDD0 [IDENTIFIED_DATA] |.1 O1)..|
    .BYTE $D1, $A0, $00, $20, $4F, $31, $91, $20 ; $DDD8 [IDENTIFIED_DATA] |... O1. |
    .BYTE $C8, $D0, $F8, $E6, $21, $CA, $D0, $EA ; $DDE0 [IDENTIFIED_DATA] |....!...|
    .BYTE $AD, $00, $DD, $29, $EF, $8D, $00, $DD ; $DDE8 [IDENTIFIED_DATA] |...)....|
    .BYTE $60, $A9, $0F, $8D, $06, $FD, $4C, $08 ; $DDF0 [IDENTIFIED_DATA] |`.....L.|
    .BYTE $30, $A9, $0F, $18, $20, $C3, $FF, $A9 ; $DDF8 [IDENTIFIED_DATA] |0... ...|
    .BYTE $0F, $8D, $08, $FD, $A2, $08, $A8, $20 ; $DE00 [IDENTIFIED_DATA] |....... |
    .BYTE $BA, $FF, $A9, $00, $8D, $1C, $0A, $AA ; $DE08 [IDENTIFIED_DATA] |........|
    .BYTE $20, $68, $FF, $A9, $04, $A2, $B8, $A0 ; $DE10 [IDENTIFIED_DATA] | h......|
    .BYTE $31, $20, $BD, $FF, $20, $C0, $FF, $B0 ; $DE18 [IDENTIFIED_DATA] |1 .. ...|
    .BYTE $D0, $20, $B7, $FF, $2A, $B0, $CA, $2C ; $DE20 [IDENTIFIED_DATA] |. ..*..,|
    .BYTE $1C, $0A, $70, $26, $A9, $0B, $18, $20 ; $DE28 [IDENTIFIED_DATA] |..p&... |
    .BYTE $C3, $FF, $A9, $0B, $A2, $08, $A0, $08 ; $DE30 [IDENTIFIED_DATA] |........|
    .BYTE $20, $BA, $FF, $A9, $00, $8D, $08, $FD ; $DE38 [IDENTIFIED_DATA] | .......|
    .BYTE $AA, $20, $68, $FF, $A9, $01, $A2, $BC ; $DE40 [IDENTIFIED_DATA] |. h.....|
    .BYTE $A0, $31, $20, $BD, $FF, $20, $C0, $FF ; $DE48 [IDENTIFIED_DATA] |.1 .. ..|
    .BYTE $B0, $9F, $60, $20, $A4, $31, $A0, $0D ; $DE50 [IDENTIFIED_DATA] |..` .1..|
    .BYTE $B9, $AB, $31, $20, $D2, $FF, $88, $D0 ; $DE58 [IDENTIFIED_DATA] |..1 ....|
    .BYTE $F7, $20, $CC, $FF, $20, $89, $31, $F0 ; $DE60 [IDENTIFIED_DATA] |. .. .1.|
    .BYTE $05, $A9, $0D, $8D, $06, $FD, $4C, $CC ; $DE68 [IDENTIFIED_DATA] |......L.|
    .BYTE $FF, $78, $AD, $00, $DD, $49, $10, $8D ; $DE70 [IDENTIFIED_DATA] |.x...I..|
    .BYTE $00, $DD, $A9, $08, $2C, $0D, $DC, $F0 ; $DE78 [IDENTIFIED_DATA] |....,...|
    .BYTE $FB, $AD, $0C, $DC, $60, $AD, $0D, $DC ; $DE80 [IDENTIFIED_DATA] |....`...|
    .BYTE $AD, $0D, $DD, $A9, $0F, $8D, $19, $D0 ; $DE88 [IDENTIFIED_DATA] |........|
    .BYTE $68, $8D, $00, $FF, $68, $A8, $68, $AA ; $DE90 [IDENTIFIED_DATA] |h...h.h.|
    .BYTE $68, $40, $D8, $A2, $30, $38, $E9, $0A ; $DE98 [IDENTIFIED_DATA] |h@..08..|
    .BYTE $90, $03, $E8, $B0, $F9, $69, $3A, $60 ; $DEA0 [IDENTIFIED_DATA] |.....i:`|
    .BYTE $20, $D7, $30, $A2, $0F, $20, $C6, $FF ; $DEA8 [IDENTIFIED_DATA] | .0.. ..|
    .BYTE $B0, $F6, $20, $CF, $FF, $C9, $30, $60 ; $DEB0 [IDENTIFIED_DATA] |.. ...0`|
    .BYTE $20, $0A, $31, $A2, $0B, $20, $C6, $FF ; $DEB8 [IDENTIFIED_DATA] | .1.. ..|
    .BYTE $B0, $F6, $60, $20, $D7, $30, $A2, $0F ; $DEC0 [IDENTIFIED_DATA] |..` .0..|
    .BYTE $20, $C9, $FF, $B0, $F6, $60, $0D, $73 ; $DEC8 [IDENTIFIED_DATA] | ....`.s|
    .BYTE $73, $20, $74, $74, $20, $30, $20, $38 ; $DED0 [IDENTIFIED_DATA] |s tt 0 8|
    .BYTE $3A, $31, $55, $30, $4C, $00, $23, $01 ; $DED8 [IDENTIFIED_DATA] |:1U0L.#.|
    .BYTE $00, $00, $00, $30, $55, $78, $A9, $3E ; $DEE0 [IDENTIFIED_DATA] |...0Ux.>|
    .BYTE $8D, $00, $FF, $A9, $B0, $8D, $05, $D5 ; $DEE8 [IDENTIFIED_DATA] |........|
    .BYTE $EA, $4C, $00, $30, $EA, $F3, $3E, $3E ; $DEF0 [IDENTIFIED_DATA] |.L.0..>>|
    .BYTE $32, $00, $FF, $01, $05, $D5, $3E, $B1 ; $DEF8 [IDENTIFIED_DATA] |2.....>.|
    .BYTE $ED, $79, $00, $CF, $9E, $FF, $BD, $58 ; $DF00 [IDENTIFIED_DATA] |.y.....X|
    .BYTE $6F, $CE, $00, $0F, $08, $07, $0B, $04 ; $DF08 [IDENTIFIED_DATA] |o.......|
    .BYTE $02, $0D, $0A, $0C, $09, $06, $01, $05 ; $DF10 [IDENTIFIED_DATA] |........|
    .BYTE $03, $0E, $00, $60, $30, $18, $0C, $06 ; $DF18 [IDENTIFIED_DATA] |...`0...|
    .BYTE $03, $00, $18, $3C, $66, $00, $00, $00 ; $DF20 [IDENTIFIED_DATA] |...<f...|
    .BYTE $00, $00, $00, $00, $00, $00, $00, $00 ; $DF28 [IDENTIFIED_DATA] |........|
    .BYTE $7F, $00, $60, $30, $18, $00, $00, $00 ; $DF30 [IDENTIFIED_DATA] |..`0....|
    .BYTE $00, $00, $1C, $30, $30, $60, $30, $30 ; $DF38 [IDENTIFIED_DATA] |...00`00|
    .BYTE $1C, $00, $18, $18, $18, $18, $18, $18 ; $DF40 [IDENTIFIED_DATA] |........|
    .BYTE $18, $00, $38, $0C, $0C, $06, $0C, $0C ; $DF48 [IDENTIFIED_DATA] |..8.....|
    .BYTE $38, $00, $00, $1B, $2A, $66, $00, $00 ; $DF50 [IDENTIFIED_DATA] |8...*f..|
    .BYTE $00, $00, $00, $00, $00, $00, $00, $41 ; $DF58 [IDENTIFIED_DATA] |.......A|
    .BYTE $7F, $00, $00, $F2, $5B, $39, $01, $4E ; $DF60 [IDENTIFIED_DATA] |....[9.N|
    .BYTE $65, $37, $06, $03, $1E, $07, $0B, $68 ; $DF68 [IDENTIFIED_DATA] |e7.....h|
    .BYTE $4B, $34, $17, $01, $44, $62, $2D, $18 ; $DF70 [IDENTIFIED_DATA] |K4..Db-.|
    .BYTE $12, $0B, $63, $59, $31, $17, $00, $0B ; $DF78 [IDENTIFIED_DATA] |..cY1...|
    .BYTE $59, $72, $2B, $18, $0F, $63, $00, $4F ; $DF80 [IDENTIFIED_DATA] |Yr+..c.O|
    .BYTE $2B, $05, $4C, $68, $2D, $17, $16, $69 ; $DF88 [IDENTIFIED_DATA] |+.Lh-..i|
    .BYTE $49, $25, $17, $13, $45, $68, $29, $18 ; $DF90 [IDENTIFIED_DATA] |I%..Eh).|
    .BYTE $17, $07, $0C, $68, $4B, $34, $13, $0F ; $DF98 [IDENTIFIED_DATA] |...hK4..|
    .BYTE $05, $4B, $70, $31, $0D, $0D, $08, $08 ; $DFA0 [IDENTIFIED_DATA] |.Kp1....|
    .BYTE $6C, $0D, $3F, $3F, $7F, $3E, $7E, $B0 ; $DFA8 [IDENTIFIED_DATA] |l.??.>~.|
    .BYTE $0B, $00, $00, $01, $00, $00, $05, $0A ; $DFB0 [IDENTIFIED_DATA] |........|
    .BYTE $0F, $14, $04, $09, $0E, $13, $03, $08 ; $DFB8 [IDENTIFIED_DATA] |........|
    .BYTE $0D, $12, $02, $07, $0C, $11, $01, $06 ; $DFC0 [IDENTIFIED_DATA] |........|
    .BYTE $0B, $10, $00, $05, $0A, $0F, $01, $06 ; $DFC8 [IDENTIFIED_DATA] |........|
    .BYTE $0B, $10, $02, $07, $0C, $11, $03, $08 ; $DFD0 [IDENTIFIED_DATA] |........|
    .BYTE $0D, $12, $04, $09, $0E, $00, $05, $0A ; $DFD8 [IDENTIFIED_DATA] |........|
    .BYTE $0F, $02, $07, $0C, $11, $04, $09, $0E ; $DFE0 [IDENTIFIED_DATA] |........|
    .BYTE $01, $06, $0B, $10, $03, $08, $0D, $00 ; $DFE8 [IDENTIFIED_DATA] |........|
    .BYTE $05, $0A, $0F, $03, $08, $0D, $01, $06 ; $DFF0 [IDENTIFIED_DATA] |........|
    .BYTE $0B, $10, $04, $09, $0E, $02, $07, $0C ; $DFF8 [IDENTIFIED_DATA] |........|
KERNAL_RESET_START:
    LDX   #$FF               ; $E000: A2 FF   
    SEI                      ; $E002: 78      
    TXS                      ; $E003: 9A      
    CLD                      ; $E004: D8      
    LDA   #$00               ; $E005: A9 00   
    STA   $FF00              ; $E007: 8D 00 FF (MMU_CR_TOP)
    LDX   #$0A               ; $E00A: A2 0A   
    LDA   $E04B,X            ; $E00C: BD 4B E0
    STA   $D500,X            ; $E00F: 9D 00 D5 (MMU_CR)
    DEX                      ; $E012: CA      
    BPL   $E00C              ; $E013: 10 F7   
    STA   $0A04              ; $E015: 8D 04 0A
    JSR   $E0CD              ; $E018: 20 CD E0
    JSR   $E1F0              ; $E01B: 20 F0 E1
    JSR   $E242              ; $E01E: 20 42 E2 (KERNAL_Z80_SWITCH)
    JSR   $E109              ; $E021: 20 09 E1 (KERNAL_IOINIT)
    JSR   $F63D              ; $E024: 20 3D F6
    PHA                      ; $E027: 48      
    BMI   $E031              ; $E028: 30 07   
    LDA   #$A5               ; $E02A: A9 A5   
    CMP   $0A02              ; $E02C: CD 02 0A
    BEQ   $E034              ; $E02F: F0 03   
    JSR   $E093              ; $E031: 20 93 E0 (KERNAL_RAMTAS)
    JSR   $E056              ; $E034: 20 56 E0 (KERNAL_RESTOR)
    JSR   $C000              ; $E037: 20 00 C0 (ED_JCINT)
    PLA                      ; $E03A: 68      
    CLI                      ; $E03B: 58      
    BMI   $E041              ; $E03C: 30 03   
    JMP   $B000              ; $E03E: 4C 00 B0 (MON_CALL_ENTRY)
    CMP   #$DF               ; $E041: C9 DF   
    BEQ   $E048              ; $E043: F0 03   
    JMP   ($0A00)            ; $E045: 6C 00 0A
    JMP   $E24B              ; $E048: 4C 4B E2 (KERNAL_C64MODE)
; --- [DATA] KERNAL MMU Initial Register Configuration Table ($D500-$D50A) ($E04B-$E055) ---
    .BYTE $00, $00, $00, $00, $00, $BF, $04, $00 ; $E04B [IDENTIFIED_DATA] |........|
    .BYTE $00, $01, $00                          ; $E053 [IDENTIFIED_DATA] |...|
KERNAL_RESTOR:
    LDX   #$73               ; $E056: A2 73   
    LDY   #$E0               ; $E058: A0 E0   
    CLC                      ; $E05A: 18      
KERNAL_VECTOR:
    STX   $C3                ; $E05B: 86 C3   
    STY   $C4                ; $E05D: 84 C4   
    LDY   #$1F               ; $E05F: A0 1F   
    LDA   $0314,Y            ; $E061: B9 14 03 (CINV)
    BCS   $E068              ; $E064: B0 02   
    LDA   ($C3),Y            ; $E066: B1 C3   
    STA   $0314,Y            ; $E068: 99 14 03 (CINV)
    BCC   $E06F              ; $E06B: 90 02   
    STA   ($C3),Y            ; $E06D: 91 C3   
    DEY                      ; $E06F: 88      
    BPL   $E061              ; $E070: 10 EF   
    RTS                      ; $E072: 60      
    ADC   $FA                ; $E073: 65 FA   
    .BYTE $03                                ; $E075: 03 [UNRESOLVED]
    BCS   $E0B8              ; $E076: B0 40   
    .BYTE $FA                                ; $E078: FA [UNRESOLVED]
    LDA   $88EF,X            ; $E079: BD EF 88
    SBC   ($06),Y            ; $E07C: F1 06   
    SBC   ($4C),Y            ; $E07E: F1 4C   
    SBC   ($26),Y            ; $E080: F1 26   
    .BYTE $F2                                ; $E082: F2 [UNRESOLVED]
    ASL   $EF                ; $E083: 06 EF   
    ADC   $6EEF,Y            ; $E085: 79 EF 6E
    INC   $EB,X              ; $E088: F6 EB   
    INC   $F222              ; $E08A: EE 22 F2
    ASL   $B0                ; $E08D: 06 B0   
    JMP   ($4EF2)            ; $E08F: 6C F2 4E
    SBC   $A9,X              ; $E092: F5 A9   
    BRK                      ; $E094: 00      
    TAY                      ; $E095: A8      
    STA.W $0002,Y            ; $E096: 99 02 00
    INY                      ; $E099: C8      
    BNE   $E096              ; $E09A: D0 FA   
    LDY   #$0B               ; $E09C: A0 0B   
    STY   $B3                ; $E09E: 84 B3   
    STA   $B2                ; $E0A0: 85 B2   
    LDY   #$0C               ; $E0A2: A0 0C   
    STY   $C9                ; $E0A4: 84 C9   
    STA   $C8                ; $E0A6: 85 C8   
    LDY   #$0D               ; $E0A8: A0 0D   
    STY   $CB                ; $E0AA: 84 CB   
    STA   $CA                ; $E0AC: 85 CA   
    CLC                      ; $E0AE: 18      
    LDY   #$FF               ; $E0AF: A0 FF   
    LDX   #$00               ; $E0B1: A2 00   
    JSR   $F76B              ; $E0B3: 20 6B F7
    LDY   #$1C               ; $E0B6: A0 1C   
    LDX   #$00               ; $E0B8: A2 00   
    JSR   $F77A              ; $E0BA: 20 7A F7
    LDY   #$40               ; $E0BD: A0 40   
    LDX   #$00               ; $E0BF: A2 00   
    STY   $0A01              ; $E0C1: 8C 01 0A
    STX   $0A00              ; $E0C4: 8E 00 0A
    LDA   #$A5               ; $E0C7: A9 A5   
    STA   $0A02              ; $E0C9: 8D 02 0A
    RTS                      ; $E0CC: 60      
    LDY   #$03               ; $E0CD: A0 03   
    LDA   $E105,Y            ; $E0CF: B9 05 E1
    STA   $FF00              ; $E0D2: 8D 00 FF (MMU_CR_TOP)
    LDX   #$3F               ; $E0D5: A2 3F   
    LDA   $FF05,X            ; $E0D7: BD 05 FF (HW_NMI_ENTRY)
    STA   $FF05,X            ; $E0DA: 9D 05 FF (HW_NMI_ENTRY)
    DEX                      ; $E0DD: CA      
    BPL   $E0D7              ; $E0DE: 10 F7   
    LDX   #$05               ; $E0E0: A2 05   
    LDA   $FFFA,X            ; $E0E2: BD FA FF (HW_VEC_NMI)
    STA   $FFFA,X            ; $E0E5: 9D FA FF (HW_VEC_NMI)
    DEX                      ; $E0E8: CA      
    BPL   $E0E2              ; $E0E9: 10 F7   
    DEY                      ; $E0EB: 88      
    BPL   $E0CF              ; $E0EC: 10 E1   
    LDX   #$59               ; $E0EE: A2 59   
    LDA   $F800,X            ; $E0F0: BD 00 F8
    STA   $02A2,X            ; $E0F3: 9D A2 02
    DEX                      ; $E0F6: CA      
    BPL   $E0F0              ; $E0F7: 10 F7   
    LDX   #$0C               ; $E0F9: A2 0C   
    LDA   $F85A,X            ; $E0FB: BD 5A F8
    STA   $03F0,X            ; $E0FE: 9D F0 03
    DEX                      ; $E101: CA      
    BPL   $E0FB              ; $E102: 10 F7   
    RTS                      ; $E104: 60      
    BRK                      ; $E105: 00      
    RTI                      ; $E106: 40      
    .BYTE $80                                ; $E107: 80 [UNRESOLVED]
    CPY   #$A9               ; $E108: C0 A9   
    .BYTE $7F                                ; $E10A: 7F [UNRESOLVED]
    STA   $DC0D              ; $E10B: 8D 0D DC (CIA1_ICR)
    STA   $DD0D              ; $E10E: 8D 0D DD (CIA2_ICR)
    STA   $DC00              ; $E111: 8D 00 DC (CIA1_PRA)
    LDA   #$08               ; $E114: A9 08   
    STA   $DC0E              ; $E116: 8D 0E DC (CIA1_CRA)
    STA   $DD0E              ; $E119: 8D 0E DD
    STA   $DC0F              ; $E11C: 8D 0F DC (CIA1_CRB)
    STA   $DD0F              ; $E11F: 8D 0F DD
    LDX   #$00               ; $E122: A2 00   
    STX   $DC03              ; $E124: 8E 03 DC (CIA1_DDRB)
    STX   $DD03              ; $E127: 8E 03 DD (CIA2_DDRB)
    DEX                      ; $E12A: CA      
    STX   $DC02              ; $E12B: 8E 02 DC (CIA1_DDRA)
    LDA   #$07               ; $E12E: A9 07   
    STA   $DD00              ; $E130: 8D 00 DD (CIA2_PRA)
    LDA   #$3F               ; $E133: A9 3F   
    STA   $DD02              ; $E135: 8D 02 DD (CIA2_DDRA)
    LDA   #$E3               ; $E138: A9 E3   
    STA   $01                ; $E13A: 85 01   
    LDA   #$2F               ; $E13C: A9 2F   
    STA   $00                ; $E13E: 85 00   
    LDX   #$FF               ; $E140: A2 FF   
    LDA   $D011              ; $E142: AD 11 D0 (VIC_SCROLY)
    BPL   $E142              ; $E145: 10 FB   
    LDA   #$08               ; $E147: A9 08   
    CMP   $D012              ; $E149: CD 12 D0 (VIC_RASTER)
    BCC   $E154              ; $E14C: 90 06   
    LDA   $D011              ; $E14E: AD 11 D0 (VIC_SCROLY)
    BMI   $E147              ; $E151: 30 F4   
    INX                      ; $E153: E8      
    STX   $0A03              ; $E154: 8E 03 0A
    LDA   #$00               ; $E157: A9 00   
    STA   $0A37              ; $E159: 8D 37 0A
    STA   $0A39              ; $E15C: 8D 39 0A
    STA   $0A0A              ; $E15F: 8D 0A 0A
    STA   $0A3A              ; $E162: 8D 3A 0A
    STA   $0A36              ; $E165: 8D 36 0A
    STA   $99                ; $E168: 85 99   
    LDA   #$03               ; $E16A: A9 03   
    STA   $9A                ; $E16C: 85 9A   
    LDX   #$30               ; $E16E: A2 30   
    LDA   $E2C7,X            ; $E170: BD C7 E2
    STA   $D000,X            ; $E173: 9D 00 D0 (VIC_SP0X)
    DEX                      ; $E176: CA      
    BPL   $E170              ; $E177: 10 F7   
    LDX   #$00               ; $E179: A2 00   
    JSR   $E1DC              ; $E17B: 20 DC E1
    LDA   $D600              ; $E17E: AD 00 D6 (VDC_ADDR_STATUS)
    AND   #$07               ; $E181: 29 07   
    BEQ   $E18A              ; $E183: F0 05   
    LDX   #$3B               ; $E185: A2 3B   
    JSR   $E1DC              ; $E187: 20 DC E1
    BIT   $0A03              ; $E18A: 2C 03 0A
    BPL   $E194              ; $E18D: 10 05   
    LDX   #$3E               ; $E18F: A2 3E   
    JSR   $E1DC              ; $E191: 20 DC E1
    LDA   $0A04              ; $E194: AD 04 0A
    BMI   $E1AE              ; $E197: 30 15   
    JSR   $C027              ; $E199: 20 27 C0 (ED_JINIT80)
    LDA   #$80               ; $E19C: A9 80   
    ORA   $0A04              ; $E19E: 0D 04 0A
    STA   $0A04              ; $E1A1: 8D 04 0A
    LDX   #$FF               ; $E1A4: A2 FF   
    LDY   #$FF               ; $E1A6: A0 FF   
    DEY                      ; $E1A8: 88      
    BNE   $E1A8              ; $E1A9: D0 FD   
    DEX                      ; $E1AB: CA      
    BNE   $E1A8              ; $E1AC: D0 FA   
    LDA   #$00               ; $E1AE: A9 00   
    LDX   #$18               ; $E1B0: A2 18   
    STA   $D400,X            ; $E1B2: 9D 00 D4 (SID_BASE)
    DEX                      ; $E1B5: CA      
    BPL   $E1B2              ; $E1B6: 10 FA   
    LDX   #$01               ; $E1B8: A2 01   
    STX   $D01A              ; $E1BA: 8E 1A D0 (VIC_IRQMSK)
    DEX                      ; $E1BD: CA      
    STX   $0A1C              ; $E1BE: 8E 1C 0A
    STX   $0A0F              ; $E1C1: 8E 0F 0A
    DEX                      ; $E1C4: CA      
    STX   $DC06              ; $E1C5: 8E 06 DC
    STX   $DC07              ; $E1C8: 8E 07 DC
    LDX   #$11               ; $E1CB: A2 11   
    STX   $DC0F              ; $E1CD: 8E 0F DC (CIA1_CRB)
    JSR   $E5C3              ; $E1D0: 20 C3 E5
    JSR   $E5D6              ; $E1D3: 20 D6 E5
    JSR   $E5C3              ; $E1D6: 20 C3 E5
    JMP   $E54E              ; $E1D9: 4C 4E E5
    LDY   $E2F8,X            ; $E1DC: BC F8 E2
    BMI   $E1EE              ; $E1DF: 30 0D   
    INX                      ; $E1E1: E8      
    LDA   $E2F8,X            ; $E1E2: BD F8 E2
    INX                      ; $E1E5: E8      
    STY   $D600              ; $E1E6: 8C 00 D6 (VDC_ADDR_STATUS)
    STA   $D601              ; $E1E9: 8D 01 D6 (VDC_DATA)
    BPL   $E1DC              ; $E1EC: 10 EE   
    INX                      ; $E1EE: E8      
    RTS                      ; $E1EF: 60      
    LDX   #$F5               ; $E1F0: A2 F5   
    LDY   #$FF               ; $E1F2: A0 FF   
    STX   $C3                ; $E1F4: 86 C3   
    STY   $C4                ; $E1F6: 84 C4   
    LDA   #$C3               ; $E1F8: A9 C3   
    STA   $02AA              ; $E1FA: 8D AA 02
    LDY   #$02               ; $E1FD: A0 02   
    LDX   #$7F               ; $E1FF: A2 7F   
    JSR   $02A2              ; $E201: 20 A2 02
    CMP   $E2C4,Y            ; $E204: D9 C4 E2
    BNE   $E224              ; $E207: D0 1B   
    DEY                      ; $E209: 88      
    BPL   $E1FF              ; $E20A: 10 F3   
    LDX   #$F8               ; $E20C: A2 F8   
    LDY   #$FF               ; $E20E: A0 FF   
    STX   $C3                ; $E210: 86 C3   
    STY   $C4                ; $E212: 84 C4   
    LDY   #$01               ; $E214: A0 01   
    LDX   #$7F               ; $E216: A2 7F   
    JSR   $02A2              ; $E218: 20 A2 02
    STA.W $0002,Y            ; $E21B: 99 02 00
    DEY                      ; $E21E: 88      
    BPL   $E216              ; $E21F: 10 F5   
    JMP   ($0002)            ; $E221: 6C 02 00
    LDA   #$40               ; $E224: A9 40   
    STA   $FF00              ; $E226: 8D 00 FF (MMU_CR_TOP)
    LDA   #$24               ; $E229: A9 24   
    LDY   #$E2               ; $E22B: A0 E2   
    STA   $FFF8              ; $E22D: 8D F8 FF
    STY   $FFF9              ; $E230: 8C F9 FF
    LDX   #$03               ; $E233: A2 03   
    LDA   $E2C3,X            ; $E235: BD C3 E2
    STA   $FFF4,X            ; $E238: 9D F4 FF
    DEX                      ; $E23B: CA      
    BNE   $E235              ; $E23C: D0 F7   
    STX   $FF00              ; $E23E: 8E 00 FF (MMU_CR_TOP)
    RTS                      ; $E241: 60      
KERNAL_Z80_SWITCH:
    LDA   $D505              ; $E242: AD 05 D5 (MMU_MCR)
    AND   #$30               ; $E245: 29 30   
    CMP   #$30               ; $E247: C9 30   
    BEQ   $E26B              ; $E249: F0 20   
KERNAL_C64MODE:
    LDA   #$E3               ; $E24B: A9 E3   
    STA   $01                ; $E24D: 85 01   
    LDA   #$2F               ; $E24F: A9 2F   
    STA   $00                ; $E251: 85 00   
    LDX   #$08               ; $E253: A2 08   
    LDA   $E262,X            ; $E255: BD 62 E2
    STA   $01,X              ; $E258: 95 01   
    DEX                      ; $E25A: CA      
    BNE   $E255              ; $E25B: D0 F8   
    STX   $D030              ; $E25D: 8E 30 D0 (VIC_CLK2MHZ)
    JMP.W $0002              ; $E260: 4C 02 00
    LDA   #$F7               ; $E263: A9 F7   
    STA   $D505              ; $E265: 8D 05 D5 (MMU_MCR)
    JMP   ($FFFC)            ; $E268: 6C FC FF (HW_VEC_RESET)
    LDX   #$03               ; $E26B: A2 03   
    STX   $0AC0              ; $E26D: 8E C0 0A
    LDA   #$00               ; $E270: A9 00   
    STA   $0AC1,X            ; $E272: 9D C1 0A
    DEX                      ; $E275: CA      
    BPL   $E272              ; $E276: 10 FA   
    STA   $9E                ; $E278: 85 9E   
    LDY   #$09               ; $E27A: A0 09   
    LDX   $0AC0              ; $E27C: AE C0 0A
    LDA   $E2BC,X            ; $E27F: BD BC E2
    STA   $9F                ; $E282: 85 9F   
    LDA   $E2C0,X            ; $E284: BD C0 E2
    STA   $02                ; $E287: 85 02   
    LDX   $02                ; $E289: A6 02   
    LDA   #$9E               ; $E28B: A9 9E   
    JSR   $F7D0              ; $E28D: 20 D0 F7 (KERNAL_INDFET)
    CMP   $E2BD,Y            ; $E290: D9 BD E2
    BNE   $E2B6              ; $E293: D0 21   
    DEY                      ; $E295: 88      
    CPY   #$07               ; $E296: C0 07   
    BCS   $E289              ; $E298: B0 EF   
    LDX   $02                ; $E29A: A6 02   
    LDA   #$9E               ; $E29C: A9 9E   
    JSR   $F7D0              ; $E29E: 20 D0 F7 (KERNAL_INDFET)
    LDX   $0AC0              ; $E2A1: AE C0 0A
    STA   $0AC1,X            ; $E2A4: 9D C1 0A
    CMP   #$01               ; $E2A7: C9 01   
    BNE   $E2B6              ; $E2A9: D0 0B   
    LDA   $9E                ; $E2AB: A5 9E   
    LDY   $9F                ; $E2AD: A4 9F   
    STA   $04                ; $E2AF: 85 04   
    STY   $03                ; $E2B1: 84 03   
    JSR   $02CD              ; $E2B3: 20 CD 02
    DEC   $0AC0              ; $E2B6: CE C0 0A
    BPL   $E27A              ; $E2B9: 10 BF   
    RTS                      ; $E2BB: 60      
    CPY   #$80               ; $E2BC: C0 80   
    CPY   #$80               ; $E2BE: C0 80   
    .BYTE $04                                ; $E2C0: 04 [UNRESOLVED]
    .BYTE $04                                ; $E2C1: 04 [UNRESOLVED]
    PHP                      ; $E2C2: 08      
    PHP                      ; $E2C3: 08      
    .BYTE $43                                ; $E2C4: 43 [UNRESOLVED]
    .BYTE $42                                ; $E2C5: 42 [UNRESOLVED]
    EOR.W $0000              ; $E2C6: 4D 00 00 (D6510)
    BRK                      ; $E2C9: 00      
    BRK                      ; $E2CA: 00      
    BRK                      ; $E2CB: 00      
    BRK                      ; $E2CC: 00      
    BRK                      ; $E2CD: 00      
    BRK                      ; $E2CE: 00      
    BRK                      ; $E2CF: 00      
    BRK                      ; $E2D0: 00      
    BRK                      ; $E2D1: 00      
    BRK                      ; $E2D2: 00      
    BRK                      ; $E2D3: 00      
    BRK                      ; $E2D4: 00      
    BRK                      ; $E2D5: 00      
    BRK                      ; $E2D6: 00      
    BRK                      ; $E2D7: 00      
    .BYTE $1B                                ; $E2D8: 1B [UNRESOLVED]
    .BYTE $FF                                ; $E2D9: FF [UNRESOLVED]
    BRK                      ; $E2DA: 00      
    BRK                      ; $E2DB: 00      
    BRK                      ; $E2DC: 00      
    PHP                      ; $E2DD: 08      
    BRK                      ; $E2DE: 00      
    .BYTE $14                                ; $E2DF: 14 [UNRESOLVED]
    .BYTE $FF                                ; $E2E0: FF [UNRESOLVED]
    ORA   ($00,X)            ; $E2E1: 01 00   
    BRK                      ; $E2E3: 00      
    BRK                      ; $E2E4: 00      
    BRK                      ; $E2E5: 00      
    BRK                      ; $E2E6: 00      
    ORA   $010B              ; $E2E7: 0D 0B 01
    .BYTE $02                                ; $E2EA: 02 [UNRESOLVED]
    .BYTE $03                                ; $E2EB: 03 [UNRESOLVED]
    ORA   ($02,X)            ; $E2EC: 01 02   
    BRK                      ; $E2EE: 00      
    ORA   ($02,X)            ; $E2EF: 01 02   
    .BYTE $03                                ; $E2F1: 03 [UNRESOLVED]
    .BYTE $04                                ; $E2F2: 04 [UNRESOLVED]
    ORA   $06                ; $E2F3: 05 06   
    .BYTE $07                                ; $E2F5: 07 [UNRESOLVED]
    .BYTE $FF                                ; $E2F6: FF [UNRESOLVED]
    .BYTE $FC                                ; $E2F7: FC [UNRESOLVED]
    BRK                      ; $E2F8: 00      
    ROR   $5001,X            ; $E2F9: 7E 01 50
    .BYTE $02                                ; $E2FC: 02 [UNRESOLVED]
    ROR   $03                ; $E2FD: 66 03   
    EOR   #$04               ; $E2FF: 49 04   
    JSR.W $0005              ; $E301: 20 05 00
    ASL   $19                ; $E304: 06 19   
    .BYTE $07                                ; $E306: 07 [UNRESOLVED]
    ORA.W $0008,X            ; $E307: 1D 08 00
    ORA   #$07               ; $E30A: 09 07   
    ASL   A                  ; $E30C: 0A      
    JSR   $070B              ; $E30D: 20 0B 07
    .BYTE $0C                                ; $E310: 0C [UNRESOLVED]
    BRK                      ; $E311: 00      
    ORA   $0E00              ; $E312: 0D 00 0E
    BRK                      ; $E315: 00      
    .BYTE $0F                                ; $E316: 0F [UNRESOLVED]
    BRK                      ; $E317: 00      
    .BYTE $14                                ; $E318: 14 [UNRESOLVED]
    PHP                      ; $E319: 08      
    ORA   $00,X              ; $E31A: 15 00   
    .BYTE $17                                ; $E31C: 17 [UNRESOLVED]
    PHP                      ; $E31D: 08      
    CLC                      ; $E31E: 18      
    JSR   $4019              ; $E31F: 20 19 40
    .BYTE $1A                                ; $E322: 1A [UNRESOLVED]
    BEQ   $E340              ; $E323: F0 1B   
    BRK                      ; $E325: 00      
    .BYTE $1C                                ; $E326: 1C [UNRESOLVED]
    JSR   $071D              ; $E327: 20 1D 07
    .BYTE $22                                ; $E32A: 22 [UNRESOLVED]
    ADC   $6423,X            ; $E32B: 7D 23 64
    BIT   $05                ; $E32E: 24 05   
    ASL   $78,X              ; $E330: 16 78   
    .BYTE $FF                                ; $E332: FF [UNRESOLVED]
    ORA   $FF47,Y            ; $E333: 19 47 FF (J_SPIN_SPOUT)
    .BYTE $04                                ; $E336: 04 [UNRESOLVED]
    .BYTE $27                                ; $E337: 27 [UNRESOLVED]
    .BYTE $07                                ; $E338: 07 [UNRESOLVED]
    JSR   $09FF              ; $E339: 20 FF 09
    RTI                      ; $E33C: 40      
    BIT   $2009              ; $E33D: 2C 09 20
    JSR   $E7EC              ; $E340: 20 EC E7
    PHA                      ; $E343: 48      
    BIT   $94                ; $E344: 24 94   
    BPL   $E352              ; $E346: 10 0A   
    SEC                      ; $E348: 38      
    ROR   $A3                ; $E349: 66 A3   
    JSR   $E38C              ; $E34B: 20 8C E3
    LSR   $94                ; $E34E: 46 94   
    LSR   $A3                ; $E350: 46 A3   
    PLA                      ; $E352: 68      
    STA   $95                ; $E353: 85 95   
    JSR   $E573              ; $E355: 20 73 E5
    JSR   $E557              ; $E358: 20 57 E5
    LDA   $DD00              ; $E35B: AD 00 DD (CIA2_PRA)
    AND   #$08               ; $E35E: 29 08   
    BNE   $E374              ; $E360: D0 12   
    JSR   $E5D6              ; $E362: 20 D6 E5
    LDA   #$FF               ; $E365: A9 FF   
    STA   $DC0C              ; $E367: 8D 0C DC
    JSR   $E5BC              ; $E36A: 20 BC E5
    TXA                      ; $E36D: 8A      
    LDX   #$14               ; $E36E: A2 14   
    DEX                      ; $E370: CA      
    BNE   $E370              ; $E371: D0 FD   
    TAX                      ; $E373: AA      
    LDA   $DD00              ; $E374: AD 00 DD (CIA2_PRA)
    ORA   #$08               ; $E377: 09 08   
    STA   $DD00              ; $E379: 8D 00 DD (CIA2_PRA)
    JSR   $E573              ; $E37C: 20 73 E5
    JSR   $E54E              ; $E37F: 20 4E E5
    JSR   $E557              ; $E382: 20 57 E5
    TXA                      ; $E385: 8A      
    LDX   #$B8               ; $E386: A2 B8   
    DEX                      ; $E388: CA      
    BNE   $E388              ; $E389: D0 FD   
    TAX                      ; $E38B: AA      
    JSR   $E573              ; $E38C: 20 73 E5
    JSR   $E557              ; $E38F: 20 57 E5
    JSR   $E569              ; $E392: 20 69 E5
    BCC   $E39A              ; $E395: 90 03   
    JMP   $E428              ; $E397: 4C 28 E4
    BIT   $DC0D              ; $E39A: 2C 0D DC (CIA1_ICR)
    JSR   $E545              ; $E39D: 20 45 E5
    BIT   $A3                ; $E3A0: 24 A3   
    BPL   $E3AE              ; $E3A2: 10 0A   
    JSR   $E569              ; $E3A4: 20 69 E5
    BCC   $E3A4              ; $E3A7: 90 FB   
    JSR   $E569              ; $E3A9: 20 69 E5
    BCS   $E3A9              ; $E3AC: B0 FB   
    LDA   $DD00              ; $E3AE: AD 00 DD (CIA2_PRA)
    CMP   $DD00              ; $E3B1: CD 00 DD (CIA2_PRA)
    BNE   $E3AE              ; $E3B4: D0 F8   
    PHA                      ; $E3B6: 48      
    LDA   $DC0D              ; $E3B7: AD 0D DC (CIA1_ICR)
    AND   #$08               ; $E3BA: 29 08   
    BEQ   $E3C3              ; $E3BC: F0 05   
    LDA   #$C0               ; $E3BE: A9 C0   
    STA   $0A1C              ; $E3C0: 8D 1C 0A
    PLA                      ; $E3C3: 68      
    BPL   $E3AE              ; $E3C4: 10 E8   
    ORA   #$10               ; $E3C6: 09 10   
    STA   $DD00              ; $E3C8: 8D 00 DD (CIA2_PRA)
    AND   #$08               ; $E3CB: 29 08   
    BNE   $E3E2              ; $E3CD: D0 13   
    BIT   $0A1C              ; $E3CF: 2C 1C 0A
    BPL   $E3E2              ; $E3D2: 10 0E   
    JSR   $E5D6              ; $E3D4: 20 D6 E5
    LDA   $95                ; $E3D7: A5 95   
    STA   $DC0C              ; $E3D9: 8D 0C DC
    JSR   $E5BC              ; $E3DC: 20 BC E5
    JMP   $E412              ; $E3DF: 4C 12 E4
    LDA   #$08               ; $E3E2: A9 08   
    STA   $A5                ; $E3E4: 85 A5   
    LDA   $DD00              ; $E3E6: AD 00 DD (CIA2_PRA)
    CMP   $DD00              ; $E3E9: CD 00 DD (CIA2_PRA)
    BNE   $E3E6              ; $E3EC: D0 F8   
    ASL   A                  ; $E3EE: 0A      
    BCC   $E425              ; $E3EF: 90 34   
    ROR   $95                ; $E3F1: 66 95   
    BCS   $E3FA              ; $E3F3: B0 05   
    JSR   $E560              ; $E3F5: 20 60 E5
    BNE   $E3FD              ; $E3F8: D0 03   
    JSR   $E557              ; $E3FA: 20 57 E5
    JSR   $E545              ; $E3FD: 20 45 E5
    NOP                      ; $E400: EA      
    NOP                      ; $E401: EA      
    NOP                      ; $E402: EA      
    NOP                      ; $E403: EA      
    LDA   $DD00              ; $E404: AD 00 DD (CIA2_PRA)
    AND   #$DF               ; $E407: 29 DF   
    ORA   #$10               ; $E409: 09 10   
    STA   $DD00              ; $E40B: 8D 00 DD (CIA2_PRA)
    DEC   $A5                ; $E40E: C6 A5   
    BNE   $E3E6              ; $E410: D0 D4   
    TXA                      ; $E412: 8A      
    PHA                      ; $E413: 48      
    LDX   #$22               ; $E414: A2 22   
    JSR   $E569              ; $E416: 20 69 E5
    BCS   $E420              ; $E419: B0 05   
    PLA                      ; $E41B: 68      
    TAX                      ; $E41C: AA      
    JMP   $E59F              ; $E41D: 4C 9F E5
    DEX                      ; $E420: CA      
    BNE   $E416              ; $E421: D0 F3   
    PLA                      ; $E423: 68      
    TAX                      ; $E424: AA      
    LDA   #$03               ; $E425: A9 03   
    BIT   $80A9              ; $E427: 2C A9 80
    PHA                      ; $E42A: 48      
    LDA   $0A1C              ; $E42B: AD 1C 0A
    AND   #$7F               ; $E42E: 29 7F   
    STA   $0A1C              ; $E430: 8D 1C 0A
    PLA                      ; $E433: 68      
    JSR   $F757              ; $E434: 20 57 F7
    JSR   $E59F              ; $E437: 20 9F E5
    CLC                      ; $E43A: 18      
    JMP   $E535              ; $E43B: 4C 35 E5
KERNAL_ACPTR:
    JSR   $E573              ; $E43E: 20 73 E5
    LDA   #$00               ; $E441: A9 00   
    STA   $A5                ; $E443: 85 A5   
    BIT   $DC0D              ; $E445: 2C 0D DC (CIA1_ICR)
    TXA                      ; $E448: 8A      
    PHA                      ; $E449: 48      
    JSR   $E545              ; $E44A: 20 45 E5
    JSR   $E569              ; $E44D: 20 69 E5
    BPL   $E44D              ; $E450: 10 FB   
    LDX   #$0D               ; $E452: A2 0D   
    LDA   $DD00              ; $E454: AD 00 DD (CIA2_PRA)
    AND   #$DF               ; $E457: 29 DF   
    STA   $DD00              ; $E459: 8D 00 DD (CIA2_PRA)
    LDA   $DD00              ; $E45C: AD 00 DD (CIA2_PRA)
    CMP   $DD00              ; $E45F: CD 00 DD (CIA2_PRA)
    BNE   $E45C              ; $E462: D0 F8   
    ASL   A                  ; $E464: 0A      
    BPL   $E484              ; $E465: 10 1D   
    DEX                      ; $E467: CA      
    BNE   $E45C              ; $E468: D0 F2   
    LDA   $A5                ; $E46A: A5 A5   
    BNE   $E47D              ; $E46C: D0 0F   
    JSR   $E560              ; $E46E: 20 60 E5
    JSR   $E545              ; $E471: 20 45 E5
    LDA   #$40               ; $E474: A9 40   
    JSR   $F757              ; $E476: 20 57 F7
    INC   $A5                ; $E479: E6 A5   
    BNE   $E452              ; $E47B: D0 D5   
    PLA                      ; $E47D: 68      
    TAX                      ; $E47E: AA      
    LDA   #$02               ; $E47F: A9 02   
    JMP   $E42A              ; $E481: 4C 2A E4
    LDX   #$08               ; $E484: A2 08   
    LDA   $DC0D              ; $E486: AD 0D DC (CIA1_ICR)
    AND   #$08               ; $E489: 29 08   
    BNE   $E4B5              ; $E48B: D0 28   
    LDA   $DD00              ; $E48D: AD 00 DD (CIA2_PRA)
    CMP   $DD00              ; $E490: CD 00 DD (CIA2_PRA)
    BNE   $E48D              ; $E493: D0 F8   
    ASL   A                  ; $E495: 0A      
    BPL   $E486              ; $E496: 10 EE   
    ROR   $A4                ; $E498: 66 A4   
    LDA   $DD00              ; $E49A: AD 00 DD (CIA2_PRA)
    CMP   $DD00              ; $E49D: CD 00 DD (CIA2_PRA)
    BNE   $E49A              ; $E4A0: D0 F8   
    ASL   A                  ; $E4A2: 0A      
    BMI   $E49A              ; $E4A3: 30 F5   
    DEX                      ; $E4A5: CA      
    BEQ   $E4BF              ; $E4A6: F0 17   
    LDA   $DD00              ; $E4A8: AD 00 DD (CIA2_PRA)
    CMP   $DD00              ; $E4AB: CD 00 DD (CIA2_PRA)
    BNE   $E4A8              ; $E4AE: D0 F8   
    ASL   A                  ; $E4B0: 0A      
    BPL   $E4A8              ; $E4B1: 10 F5   
    BMI   $E498              ; $E4B3: 30 E3   
    LDA   $DC0C              ; $E4B5: AD 0C DC
    STA   $A4                ; $E4B8: 85 A4   
    LDA   #$C0               ; $E4BA: A9 C0   
    STA   $0A1C              ; $E4BC: 8D 1C 0A
    PLA                      ; $E4BF: 68      
    TAX                      ; $E4C0: AA      
    JSR   $E560              ; $E4C1: 20 60 E5
    BIT   $90                ; $E4C4: 24 90   
    BVC   $E4CB              ; $E4C6: 50 03   
    JSR   $E538              ; $E4C8: 20 38 E5
    JSR   $E59F              ; $E4CB: 20 9F E5
    LDA   $A4                ; $E4CE: A5 A4   
    CLC                      ; $E4D0: 18      
    RTS                      ; $E4D1: 60      
KERNAL_SECOND:
    STA   $95                ; $E4D2: 85 95   
    JSR   $E37C              ; $E4D4: 20 7C E3
    LDA   $DD00              ; $E4D7: AD 00 DD (CIA2_PRA)
    AND   #$F7               ; $E4DA: 29 F7   
    STA   $DD00              ; $E4DC: 8D 00 DD (CIA2_PRA)
    RTS                      ; $E4DF: 60      
KERNAL_TKSA:
    STA   $95                ; $E4E0: 85 95   
    JSR   $E37C              ; $E4E2: 20 7C E3
    BIT   $90                ; $E4E5: 24 90   
    BMI   $E535              ; $E4E7: 30 4C   
    JSR   $E573              ; $E4E9: 20 73 E5
    JSR   $E560              ; $E4EC: 20 60 E5
    JSR   $E4D7              ; $E4EF: 20 D7 E4
    JSR   $E545              ; $E4F2: 20 45 E5
    LDA   $DD00              ; $E4F5: AD 00 DD (CIA2_PRA)
    CMP   $DD00              ; $E4F8: CD 00 DD (CIA2_PRA)
    BNE   $E4F5              ; $E4FB: D0 F8   
    ASL   A                  ; $E4FD: 0A      
    BMI   $E4F5              ; $E4FE: 30 F5   
    JMP   $E59F              ; $E500: 4C 9F E5
KERNAL_CIOUT:
    BIT   $94                ; $E503: 24 94   
    BMI   $E50C              ; $E505: 30 05   
    SEC                      ; $E507: 38      
    ROR   $94                ; $E508: 66 94   
    BNE   $E511              ; $E50A: D0 05   
    PHA                      ; $E50C: 48      
    JSR   $E38C              ; $E50D: 20 8C E3
    PLA                      ; $E510: 68      
    STA   $95                ; $E511: 85 95   
    CLC                      ; $E513: 18      
    RTS                      ; $E514: 60      
KERNAL_UNTLK:
    JSR   $E573              ; $E515: 20 73 E5
    JSR   $E54E              ; $E518: 20 4E E5
    LDA   $DD00              ; $E51B: AD 00 DD (CIA2_PRA)
    ORA   #$08               ; $E51E: 09 08   
    STA   $DD00              ; $E520: 8D 00 DD (CIA2_PRA)
    LDA   #$5F               ; $E523: A9 5F   
    BIT   $3FA9              ; $E525: 2C A9 3F
    PHA                      ; $E528: 48      
    LDA   $0A1C              ; $E529: AD 1C 0A
    AND   #$7F               ; $E52C: 29 7F   
    STA   $0A1C              ; $E52E: 8D 1C 0A
    PLA                      ; $E531: 68      
    JSR   $E343              ; $E532: 20 43 E3
    JSR   $E4D7              ; $E535: 20 D7 E4
    TXA                      ; $E538: 8A      
    LDX   #$0A               ; $E539: A2 0A   
    DEX                      ; $E53B: CA      
    BNE   $E53B              ; $E53C: D0 FD   
    TAX                      ; $E53E: AA      
    JSR   $E545              ; $E53F: 20 45 E5
    JMP   $E557              ; $E542: 4C 57 E5
    LDA   $DD00              ; $E545: AD 00 DD (CIA2_PRA)
    AND   #$EF               ; $E548: 29 EF   
    STA   $DD00              ; $E54A: 8D 00 DD (CIA2_PRA)
    RTS                      ; $E54D: 60      
    LDA   $DD00              ; $E54E: AD 00 DD (CIA2_PRA)
    ORA   #$10               ; $E551: 09 10   
    STA   $DD00              ; $E553: 8D 00 DD (CIA2_PRA)
    RTS                      ; $E556: 60      
    LDA   $DD00              ; $E557: AD 00 DD (CIA2_PRA)
    AND   #$DF               ; $E55A: 29 DF   
    STA   $DD00              ; $E55C: 8D 00 DD (CIA2_PRA)
    RTS                      ; $E55F: 60      
    LDA   $DD00              ; $E560: AD 00 DD (CIA2_PRA)
    ORA   #$20               ; $E563: 09 20   
    STA   $DD00              ; $E565: 8D 00 DD (CIA2_PRA)
    RTS                      ; $E568: 60      
    LDA   $DD00              ; $E569: AD 00 DD (CIA2_PRA)
    CMP   $DD00              ; $E56C: CD 00 DD (CIA2_PRA)
    BNE   $E569              ; $E56F: D0 F8   
    ASL   A                  ; $E571: 0A      
    RTS                      ; $E572: 60      
    SEI                      ; $E573: 78      
    BIT   $0A3A              ; $E574: 2C 3A 0A
    BMI   $E59E              ; $E577: 30 25   
    BIT   $0A37              ; $E579: 2C 37 0A
    BMI   $E59E              ; $E57C: 30 20   
    LDA   $D030              ; $E57E: AD 30 D0 (VIC_CLK2MHZ)
    STA   $0A37              ; $E581: 8D 37 0A
    LDA   $D015              ; $E584: AD 15 D0 (VIC_SPENA)
    STA   $0A38              ; $E587: 8D 38 0A
    LDA   #$00               ; $E58A: A9 00   
    STA   $D015              ; $E58C: 8D 15 D0 (VIC_SPENA)
    STA   $D030              ; $E58F: 8D 30 D0 (VIC_CLK2MHZ)
    LDA   $0A38              ; $E592: AD 38 0A
    BEQ   $E59E              ; $E595: F0 07   
    TXA                      ; $E597: 8A      
    LDX   #$00               ; $E598: A2 00   
    DEX                      ; $E59A: CA      
    BNE   $E59A              ; $E59B: D0 FD   
    TAX                      ; $E59D: AA      
    RTS                      ; $E59E: 60      
    BIT   $0A3A              ; $E59F: 2C 3A 0A
    BMI   $E5BA              ; $E5A2: 30 16   
    BIT   $0A37              ; $E5A4: 2C 37 0A
    BPL   $E5BA              ; $E5A7: 10 11   
    LDA   $0A38              ; $E5A9: AD 38 0A
    STA   $D015              ; $E5AC: 8D 15 D0 (VIC_SPENA)
    LDA   $0A37              ; $E5AF: AD 37 0A
    STA   $D030              ; $E5B2: 8D 30 D0 (VIC_CLK2MHZ)
    LDA   #$00               ; $E5B5: A9 00   
    STA   $0A37              ; $E5B7: 8D 37 0A
    CLI                      ; $E5BA: 58      
    RTS                      ; $E5BB: 60      
    LDA   $DC0D              ; $E5BC: AD 0D DC (CIA1_ICR)
    AND   #$08               ; $E5BF: 29 08   
    BEQ   $E5BC              ; $E5C1: F0 F9   
    LDA   $DC0E              ; $E5C3: AD 0E DC (CIA1_CRA)
    AND   #$80               ; $E5C6: 29 80   
    ORA   #$08               ; $E5C8: 09 08   
    STA   $DC0E              ; $E5CA: 8D 0E DC (CIA1_CRA)
    LDA   $D505              ; $E5CD: AD 05 D5 (MMU_MCR)
    AND   #$F7               ; $E5D0: 29 F7   
    STA   $D505              ; $E5D2: 8D 05 D5 (MMU_MCR)
    RTS                      ; $E5D5: 60      
    LDA   $D505              ; $E5D6: AD 05 D5 (MMU_MCR)
    ORA   #$08               ; $E5D9: 09 08   
    STA   $D505              ; $E5DB: 8D 05 D5 (MMU_MCR)
    LDA   #$7F               ; $E5DE: A9 7F   
    STA   $DC0D              ; $E5E0: 8D 0D DC (CIA1_ICR)
    LDA   #$00               ; $E5E3: A9 00   
    STA   $DC05              ; $E5E5: 8D 05 DC
    LDA   #$04               ; $E5E8: A9 04   
    STA   $DC04              ; $E5EA: 8D 04 DC
    LDA   $DC0E              ; $E5ED: AD 0E DC (CIA1_CRA)
    AND   #$80               ; $E5F0: 29 80   
    ORA   #$55               ; $E5F2: 09 55   
    STA   $DC0E              ; $E5F4: 8D 0E DC (CIA1_CRA)
    BIT   $DC0D              ; $E5F7: 2C 0D DC (CIA1_ICR)
    RTS                      ; $E5FA: 60      
KERNAL_SPIN_SPOUT:
    BCC   $E5C3              ; $E5FB: 90 C6   
    BCS   $E5D6              ; $E5FD: B0 D7   
    LDA   $B4                ; $E5FF: A5 B4   
    BEQ   $E64A              ; $E601: F0 47   
    BMI   $E644              ; $E603: 30 3F   
    LSR   $B6                ; $E605: 46 B6   
    LDX   #$00               ; $E607: A2 00   
    BCC   $E60C              ; $E609: 90 01   
    DEX                      ; $E60B: CA      
    TXA                      ; $E60C: 8A      
    EOR   $BD                ; $E60D: 45 BD   
    STA   $BD                ; $E60F: 85 BD   
    DEC   $B4                ; $E611: C6 B4   
    BEQ   $E61B              ; $E613: F0 06   
    TXA                      ; $E615: 8A      
    AND   #$04               ; $E616: 29 04   
    STA   $B5                ; $E618: 85 B5   
    RTS                      ; $E61A: 60      
    LDA   #$20               ; $E61B: A9 20   
    BIT   $0A11              ; $E61D: 2C 11 0A
    BEQ   $E636              ; $E620: F0 14   
    BMI   $E640              ; $E622: 30 1C   
    BVS   $E63A              ; $E624: 70 14   
    LDA   $BD                ; $E626: A5 BD   
    BNE   $E62B              ; $E628: D0 01   
    DEX                      ; $E62A: CA      
    DEC   $B4                ; $E62B: C6 B4   
    LDA   $0A10              ; $E62D: AD 10 0A
    BPL   $E615              ; $E630: 10 E3   
    DEC   $B4                ; $E632: C6 B4   
    BNE   $E615              ; $E634: D0 DF   
    INC   $B4                ; $E636: E6 B4   
    BNE   $E62A              ; $E638: D0 F0   
    LDA   $BD                ; $E63A: A5 BD   
    BEQ   $E62B              ; $E63C: F0 ED   
    BNE   $E62A              ; $E63E: D0 EA   
    BVS   $E62B              ; $E640: 70 E9   
    BVC   $E62A              ; $E642: 50 E6   
    INC   $B4                ; $E644: E6 B4   
    LDX   #$FF               ; $E646: A2 FF   
    BNE   $E615              ; $E648: D0 CB   
    LDA   $0A11              ; $E64A: AD 11 0A
    LSR   A                  ; $E64D: 4A      
    BCC   $E657              ; $E64E: 90 07   
    BIT   $DD01              ; $E650: 2C 01 DD (CIA2_PRB)
    BPL   $E672              ; $E653: 10 1D   
    BVC   $E675              ; $E655: 50 1E   
    LDA   #$00               ; $E657: A9 00   
    STA   $BD                ; $E659: 85 BD   
    STA   $B5                ; $E65B: 85 B5   
    LDX   $0A15              ; $E65D: AE 15 0A
    STX   $B4                ; $E660: 86 B4   
    LDY   $0A1A              ; $E662: AC 1A 0A
    CPY   $0A1B              ; $E665: CC 1B 0A
    BEQ   $E67D              ; $E668: F0 13   
    LDA   ($CA),Y            ; $E66A: B1 CA   
    STA   $B6                ; $E66C: 85 B6   
    INC   $0A1A              ; $E66E: EE 1A 0A
    RTS                      ; $E671: 60      
    LDA   #$40               ; $E672: A9 40   
    BIT   $10A9              ; $E674: 2C A9 10
    ORA   $0A14              ; $E677: 0D 14 0A
    STA   $0A14              ; $E67A: 8D 14 0A
    LDA   #$01               ; $E67D: A9 01   
    STA   $DD0D              ; $E67F: 8D 0D DD (CIA2_ICR)
    EOR   $0A0F              ; $E682: 4D 0F 0A
    ORA   #$80               ; $E685: 09 80   
    STA   $0A0F              ; $E687: 8D 0F 0A
    STA   $DD0D              ; $E68A: 8D 0D DD (CIA2_ICR)
    RTS                      ; $E68D: 60      
    LDX   #$09               ; $E68E: A2 09   
    LDA   #$20               ; $E690: A9 20   
    BIT   $0A10              ; $E692: 2C 10 0A
    BEQ   $E698              ; $E695: F0 01   
    DEX                      ; $E697: CA      
    BVC   $E69C              ; $E698: 50 02   
    DEX                      ; $E69A: CA      
    DEX                      ; $E69B: CA      
    RTS                      ; $E69C: 60      
    LDX   $A9                ; $E69D: A6 A9   
    BNE   $E6D4              ; $E69F: D0 33   
    DEC   $A8                ; $E6A1: C6 A8   
    BEQ   $E6DF              ; $E6A3: F0 3A   
    BMI   $E6B4              ; $E6A5: 30 0D   
    LDA   $A7                ; $E6A7: A5 A7   
    EOR   $AB                ; $E6A9: 45 AB   
    STA   $AB                ; $E6AB: 85 AB   
    LSR   $A7                ; $E6AD: 46 A7   
    ROR   $AA                ; $E6AF: 66 AA   
    RTS                      ; $E6B1: 60      
    DEC   $A8                ; $E6B2: C6 A8   
    LDA   $A7                ; $E6B4: A5 A7   
    BEQ   $E723              ; $E6B6: F0 6B   
    LDA   $0A10              ; $E6B8: AD 10 0A
    ASL   A                  ; $E6BB: 0A      
    LDA   #$01               ; $E6BC: A9 01   
    ADC   $A8                ; $E6BE: 65 A8   
    BNE   $E6B1              ; $E6C0: D0 EF   
    LDA   #$90               ; $E6C2: A9 90   
    STA   $DD0D              ; $E6C4: 8D 0D DD (CIA2_ICR)
    ORA   $0A0F              ; $E6C7: 0D 0F 0A
    STA   $0A0F              ; $E6CA: 8D 0F 0A
    STA   $A9                ; $E6CD: 85 A9   
    LDA   #$02               ; $E6CF: A9 02   
    JMP   $E67F              ; $E6D1: 4C 7F E6
    LDA   $A7                ; $E6D4: A5 A7   
    BNE   $E6C2              ; $E6D6: D0 EA   
    STA   $A9                ; $E6D8: 85 A9   
    LDA   #$01               ; $E6DA: A9 01   
    STA   $AB                ; $E6DC: 85 AB   
    RTS                      ; $E6DE: 60      
    LDY   $0A18              ; $E6DF: AC 18 0A
    INY                      ; $E6E2: C8      
    CPY   $0A19              ; $E6E3: CC 19 0A
    BEQ   $E712              ; $E6E6: F0 2A   
    STY   $0A18              ; $E6E8: 8C 18 0A
    DEY                      ; $E6EB: 88      
    LDA   $AA                ; $E6EC: A5 AA   
    LDX   $0A15              ; $E6EE: AE 15 0A
    CPX   #$09               ; $E6F1: E0 09   
    BEQ   $E6F9              ; $E6F3: F0 04   
    LSR   A                  ; $E6F5: 4A      
    INX                      ; $E6F6: E8      
    BNE   $E6F1              ; $E6F7: D0 F8   
    STA   ($C8),Y            ; $E6F9: 91 C8   
    LDA   #$20               ; $E6FB: A9 20   
    BIT   $0A11              ; $E6FD: 2C 11 0A
    BEQ   $E6B2              ; $E700: F0 B0   
    BMI   $E6B1              ; $E702: 30 AD   
    LDA   $A7                ; $E704: A5 A7   
    EOR   $AB                ; $E706: 45 AB   
    BEQ   $E70D              ; $E708: F0 03   
    BVS   $E6B1              ; $E70A: 70 A5   
    BIT   $A250              ; $E70C: 2C 50 A2
    LDA   #$01               ; $E70F: A9 01   
    BIT   $04A9              ; $E711: 2C A9 04
    BIT   $80A9              ; $E714: 2C A9 80
    BIT   $02A9              ; $E717: 2C A9 02
    ORA   $0A14              ; $E71A: 0D 14 0A
    STA   $0A14              ; $E71D: 8D 14 0A
    JMP   $E6C2              ; $E720: 4C C2 E6
    LDA   $AA                ; $E723: A5 AA   
    BNE   $E718              ; $E725: D0 F1   
    BEQ   $E715              ; $E727: F0 EC   
    STA   $9A                ; $E729: 85 9A   
    LDA   $0A11              ; $E72B: AD 11 0A
    LSR   A                  ; $E72E: 4A      
    BCC   $E75A              ; $E72F: 90 29   
    LDA   #$02               ; $E731: A9 02   
    BIT   $DD01              ; $E733: 2C 01 DD (CIA2_PRB)
    BPL   $E755              ; $E736: 10 1D   
    BNE   $E75A              ; $E738: D0 20   
    LDA   $0A0F              ; $E73A: AD 0F 0A
    AND   #$02               ; $E73D: 29 02   
    BNE   $E73A              ; $E73F: D0 F9   
    BIT   $DD01              ; $E741: 2C 01 DD (CIA2_PRB)
    BVS   $E741              ; $E744: 70 FB   
    LDA   $DD01              ; $E746: AD 01 DD (CIA2_PRB)
    ORA   #$02               ; $E749: 09 02   
    STA   $DD01              ; $E74B: 8D 01 DD (CIA2_PRB)
    BIT   $DD01              ; $E74E: 2C 01 DD (CIA2_PRB)
    BVS   $E75A              ; $E751: 70 07   
    BMI   $E74E              ; $E753: 30 F9   
    LDA   #$40               ; $E755: A9 40   
    STA   $0A14              ; $E757: 8D 14 0A
    CLC                      ; $E75A: 18      
    RTS                      ; $E75B: 60      
    JSR   $E770              ; $E75C: 20 70 E7
    LDY   $0A1B              ; $E75F: AC 1B 0A
    INY                      ; $E762: C8      
    CPY   $0A1A              ; $E763: CC 1A 0A
    BEQ   $E75C              ; $E766: F0 F4   
    STY   $0A1B              ; $E768: 8C 1B 0A
    DEY                      ; $E76B: 88      
    LDA   $9E                ; $E76C: A5 9E   
    STA   ($CA),Y            ; $E76E: 91 CA   
    LDA   $0A0F              ; $E770: AD 0F 0A
    LSR   A                  ; $E773: 4A      
    BCS   $E794              ; $E774: B0 1E   
    LDA   #$10               ; $E776: A9 10   
    STA   $DD0E              ; $E778: 8D 0E DD
    LDA   $0A16              ; $E77B: AD 16 0A
    STA   $DD04              ; $E77E: 8D 04 DD
    LDA   $0A17              ; $E781: AD 17 0A
    STA   $DD05              ; $E784: 8D 05 DD
    LDA   #$81               ; $E787: A9 81   
    JSR   $E67F              ; $E789: 20 7F E6
    JSR   $E64A              ; $E78C: 20 4A E6
    LDA   #$11               ; $E78F: A9 11   
    STA   $DD0E              ; $E791: 8D 0E DD
    RTS                      ; $E794: 60      
    STA   $99                ; $E795: 85 99   
    LDA   $0A11              ; $E797: AD 11 0A
    LSR   A                  ; $E79A: 4A      
    BCC   $E7C5              ; $E79B: 90 28   
    AND   #$08               ; $E79D: 29 08   
    BEQ   $E7C5              ; $E79F: F0 24   
    LDA   #$02               ; $E7A1: A9 02   
    BIT   $DD01              ; $E7A3: 2C 01 DD (CIA2_PRB)
    BPL   $E755              ; $E7A6: 10 AD   
    BEQ   $E7CC              ; $E7A8: F0 22   
    LDA   $0A0F              ; $E7AA: AD 0F 0A
    LSR   A                  ; $E7AD: 4A      
    BCS   $E7AA              ; $E7AE: B0 FA   
    LDA   $DD01              ; $E7B0: AD 01 DD (CIA2_PRB)
    AND   #$FD               ; $E7B3: 29 FD   
    STA   $DD01              ; $E7B5: 8D 01 DD (CIA2_PRB)
    LDA   $DD01              ; $E7B8: AD 01 DD (CIA2_PRB)
    AND   #$04               ; $E7BB: 29 04   
    BEQ   $E7B8              ; $E7BD: F0 F9   
    LDA   #$90               ; $E7BF: A9 90   
    CLC                      ; $E7C1: 18      
    JMP   $E67F              ; $E7C2: 4C 7F E6
    LDA   $0A0F              ; $E7C5: AD 0F 0A
    AND   #$12               ; $E7C8: 29 12   
    BEQ   $E7BF              ; $E7CA: F0 F3   
    CLC                      ; $E7CC: 18      
    RTS                      ; $E7CD: 60      
    LDA   $0A14              ; $E7CE: AD 14 0A
    LDY   $0A19              ; $E7D1: AC 19 0A
    CPY   $0A18              ; $E7D4: CC 18 0A
    BEQ   $E7E4              ; $E7D7: F0 0B   
    AND   #$F7               ; $E7D9: 29 F7   
    STA   $0A14              ; $E7DB: 8D 14 0A
    LDA   ($C8),Y            ; $E7DE: B1 C8   
    INC   $0A19              ; $E7E0: EE 19 0A
    RTS                      ; $E7E3: 60      
    ORA   #$08               ; $E7E4: 09 08   
    STA   $0A14              ; $E7E6: 8D 14 0A
    LDA   #$00               ; $E7E9: A9 00   
    RTS                      ; $E7EB: 60      
    PHA                      ; $E7EC: 48      
    LDA   $0A0F              ; $E7ED: AD 0F 0A
    BEQ   $E803              ; $E7F0: F0 11   
    LDA   $0A0F              ; $E7F2: AD 0F 0A
    AND   #$03               ; $E7F5: 29 03   
    BNE   $E7F2              ; $E7F7: D0 F9   
    LDA   #$10               ; $E7F9: A9 10   
    STA   $DD0D              ; $E7FB: 8D 0D DD (CIA2_ICR)
    LDA   #$00               ; $E7FE: A9 00   
    STA   $0A0F              ; $E800: 8D 0F 0A
    PLA                      ; $E803: 68      
    RTS                      ; $E804: 60      
    TYA                      ; $E805: 98      
    AND   $0A0F              ; $E806: 2D 0F 0A
    TAX                      ; $E809: AA      
    AND   #$01               ; $E80A: 29 01   
    BEQ   $E836              ; $E80C: F0 28   
    LDA   $DD00              ; $E80E: AD 00 DD (CIA2_PRA)
    AND   #$FB               ; $E811: 29 FB   
    ORA   $B5                ; $E813: 05 B5   
    STA   $DD00              ; $E815: 8D 00 DD (CIA2_PRA)
    LDA   $0A0F              ; $E818: AD 0F 0A
    STA   $DD0D              ; $E81B: 8D 0D DD (CIA2_ICR)
    TXA                      ; $E81E: 8A      
    AND   #$12               ; $E81F: 29 12   
    BEQ   $E830              ; $E821: F0 0D   
    AND   #$02               ; $E823: 29 02   
    BEQ   $E82D              ; $E825: F0 06   
    JSR   $E878              ; $E827: 20 78 E8
    JMP   $E830              ; $E82A: 4C 30 E8
    JSR   $E8A9              ; $E82D: 20 A9 E8
    JSR   $E5FF              ; $E830: 20 FF E5
    JMP   $E849              ; $E833: 4C 49 E8
    TXA                      ; $E836: 8A      
    AND   #$02               ; $E837: 29 02   
    BEQ   $E841              ; $E839: F0 06   
    JSR   $E878              ; $E83B: 20 78 E8
    JMP   $E849              ; $E83E: 4C 49 E8
    TXA                      ; $E841: 8A      
    AND   #$10               ; $E842: 29 10   
    BEQ   $E849              ; $E844: F0 03   
    JSR   $E8A9              ; $E846: 20 A9 E8
    LDA   $0A0F              ; $E849: AD 0F 0A
    STA   $DD0D              ; $E84C: 8D 0D DD (CIA2_ICR)
    RTS                      ; $E84F: 60      
    CMP   ($27,X)            ; $E850: C1 27   
    ROL   $C51A,X            ; $E852: 3E 1A C5
    ORA   ($74),Y            ; $E855: 11 74   
    ASL   $0CED              ; $E857: 0E ED 0C
    EOR   $06                ; $E85A: 45 06   
    BEQ   $E860              ; $E85C: F0 02   
    LSR   $01                ; $E85E: 46 01   
    CLV                      ; $E860: B8      
    BRK                      ; $E861: 00      
    ADC   ($00),Y            ; $E862: 71 00   
    ORA   $4426,Y            ; $E864: 19 26 44
    ORA   $111A,Y            ; $E867: 19 1A 11
    INX                      ; $E86A: E8      
    ORA   $0C70              ; $E86B: 0D 70 0C
    ASL   $06                ; $E86E: 06 06   
    CMP   ($02),Y            ; $E870: D1 02   
    .BYTE $37                                ; $E872: 37 [UNRESOLVED]
    ORA   ($AE,X)            ; $E873: 01 AE   
    BRK                      ; $E875: 00      
    ADC   #$00               ; $E876: 69 00   
    LDA   $DD01              ; $E878: AD 01 DD (CIA2_PRB)
    AND   #$01               ; $E87B: 29 01   
    STA   $A7                ; $E87D: 85 A7   
    LDA   $DD06              ; $E87F: AD 06 DD
    SBC   #$28               ; $E882: E9 28   
    ADC   $0A16              ; $E884: 6D 16 0A
    STA   $DD06              ; $E887: 8D 06 DD
    LDA   $DD07              ; $E88A: AD 07 DD
    ADC   $0A17              ; $E88D: 6D 17 0A
    STA   $DD07              ; $E890: 8D 07 DD
    LDA   #$11               ; $E893: A9 11   
    STA   $DD0F              ; $E895: 8D 0F DD
    LDA   $0A0F              ; $E898: AD 0F 0A
    STA   $DD0D              ; $E89B: 8D 0D DD (CIA2_ICR)
    LDA   #$FF               ; $E89E: A9 FF   
    STA   $DD06              ; $E8A0: 8D 06 DD
    STA   $DD07              ; $E8A3: 8D 07 DD
    JMP   $E69D              ; $E8A6: 4C 9D E6
    LDA   $0A12              ; $E8A9: AD 12 0A
    STA   $DD06              ; $E8AC: 8D 06 DD
    LDA   $0A13              ; $E8AF: AD 13 0A
    STA   $DD07              ; $E8B2: 8D 07 DD
    LDA   #$11               ; $E8B5: A9 11   
    STA   $DD0F              ; $E8B7: 8D 0F DD
    LDA   #$12               ; $E8BA: A9 12   
    EOR   $0A0F              ; $E8BC: 4D 0F 0A
    STA   $0A0F              ; $E8BF: 8D 0F 0A
    LDA   #$FF               ; $E8C2: A9 FF   
    STA   $DD06              ; $E8C4: 8D 06 DD
    STA   $DD07              ; $E8C7: 8D 07 DD
    LDX   $0A15              ; $E8CA: AE 15 0A
    STX   $A8                ; $E8CD: 86 A8   
    RTS                      ; $E8CF: 60      
    LDA   $93                ; $E8D0: A5 93   
    PHA                      ; $E8D2: 48      
    JSR   $E9F2              ; $E8D3: 20 F2 E9
    PLA                      ; $E8D6: 68      
    STA   $93                ; $E8D7: 85 93   
    BCS   $E918              ; $E8D9: B0 3D   
    LDY   #$00               ; $E8DB: A0 00   
    LDA   ($B2),Y            ; $E8DD: B1 B2   
    CMP   #$05               ; $E8DF: C9 05   
    BEQ   $E917              ; $E8E1: F0 34   
    CMP   #$01               ; $E8E3: C9 01   
    BEQ   $E8EF              ; $E8E5: F0 08   
    CMP   #$03               ; $E8E7: C9 03   
    BEQ   $E8EF              ; $E8E9: F0 04   
    CMP   #$04               ; $E8EB: C9 04   
    BNE   $E8D0              ; $E8ED: D0 E1   
    TAX                      ; $E8EF: AA      
    BIT   $9D                ; $E8F0: 24 9D   
    BPL   $E916              ; $E8F2: 10 22   
    LDY   #$63               ; $E8F4: A0 63   
    JSR   $F722              ; $E8F6: 20 22 F7
    LDY   #$05               ; $E8F9: A0 05   
    LDA   ($B2),Y            ; $E8FB: B1 B2   
    JSR   $FFD2              ; $E8FD: 20 D2 FF (J_BSOUT)
    INY                      ; $E900: C8      
    CPY   #$15               ; $E901: C0 15   
    BNE   $E8FB              ; $E903: D0 F6   
    LDA   $A1                ; $E905: A5 A1   
    ADC   #$02               ; $E907: 69 02   
    LDY   $91                ; $E909: A4 91   
    INY                      ; $E90B: C8      
    BNE   $E912              ; $E90C: D0 04   
    CMP   $A1                ; $E90E: C5 A1   
    BNE   $E909              ; $E910: D0 F7   
    CPY   #$F0               ; $E912: C0 F0   
    BEQ   $E8D0              ; $E914: F0 BA   
    CLC                      ; $E916: 18      
    DEY                      ; $E917: 88      
    RTS                      ; $E918: 60      
    STA   $9E                ; $E919: 85 9E   
    JSR   $E980              ; $E91B: 20 80 E9
    BCC   $E97F              ; $E91E: 90 5F   
    LDA   $C2                ; $E920: A5 C2   
    PHA                      ; $E922: 48      
    LDA   $C1                ; $E923: A5 C1   
    PHA                      ; $E925: 48      
    LDA   $AF                ; $E926: A5 AF   
    PHA                      ; $E928: 48      
    LDA   $AE                ; $E929: A5 AE   
    PHA                      ; $E92B: 48      
    LDY   #$BF               ; $E92C: A0 BF   
    LDA   #$20               ; $E92E: A9 20   
    STA   ($B2),Y            ; $E930: 91 B2   
    DEY                      ; $E932: 88      
    BNE   $E930              ; $E933: D0 FB   
    LDA   $9E                ; $E935: A5 9E   
    STA   ($B2),Y            ; $E937: 91 B2   
    INY                      ; $E939: C8      
    LDA   $C1                ; $E93A: A5 C1   
    STA   ($B2),Y            ; $E93C: 91 B2   
    INY                      ; $E93E: C8      
    LDA   $C2                ; $E93F: A5 C2   
    STA   ($B2),Y            ; $E941: 91 B2   
    INY                      ; $E943: C8      
    LDA   $AE                ; $E944: A5 AE   
    STA   ($B2),Y            ; $E946: 91 B2   
    INY                      ; $E948: C8      
    LDA   $AF                ; $E949: A5 AF   
    STA   ($B2),Y            ; $E94B: 91 B2   
    INY                      ; $E94D: C8      
    STY   $9F                ; $E94E: 84 9F   
    LDY   #$00               ; $E950: A0 00   
    STY   $9E                ; $E952: 84 9E   
    LDY   $9E                ; $E954: A4 9E   
    CPY   $B7                ; $E956: C4 B7   
    BEQ   $E967              ; $E958: F0 0D   
    JSR   $F7AE              ; $E95A: 20 AE F7
    LDY   $9F                ; $E95D: A4 9F   
    STA   ($B2),Y            ; $E95F: 91 B2   
    INC   $9E                ; $E961: E6 9E   
    INC   $9F                ; $E963: E6 9F   
    BNE   $E954              ; $E965: D0 ED   
    JSR   $E987              ; $E967: 20 87 E9
    LDA   #$69               ; $E96A: A9 69   
    STA   $AB                ; $E96C: 85 AB   
    JSR   $EA1C              ; $E96E: 20 1C EA
    TAY                      ; $E971: A8      
    PLA                      ; $E972: 68      
    STA   $AE                ; $E973: 85 AE   
    PLA                      ; $E975: 68      
    STA   $AF                ; $E976: 85 AF   
    PLA                      ; $E978: 68      
    STA   $C1                ; $E979: 85 C1   
    PLA                      ; $E97B: 68      
    STA   $C2                ; $E97C: 85 C2   
    TYA                      ; $E97E: 98      
    RTS                      ; $E97F: 60      
    LDX   $B2                ; $E980: A6 B2   
    LDY   $B3                ; $E982: A4 B3   
    CPY   #$02               ; $E984: C0 02   
    RTS                      ; $E986: 60      
    JSR   $E980              ; $E987: 20 80 E9
    TXA                      ; $E98A: 8A      
    STA   $C1                ; $E98B: 85 C1   
    CLC                      ; $E98D: 18      
    ADC   #$C0               ; $E98E: 69 C0   
    STA   $AE                ; $E990: 85 AE   
    TYA                      ; $E992: 98      
    STA   $C2                ; $E993: 85 C2   
    ADC   #$00               ; $E995: 69 00   
    STA   $AF                ; $E997: 85 AF   
    RTS                      ; $E999: 60      
    JSR   $E8D0              ; $E99A: 20 D0 E8
    BCS   $E9BD              ; $E99D: B0 1E   
    LDY   #$05               ; $E99F: A0 05   
    STY   $9F                ; $E9A1: 84 9F   
    LDY   #$00               ; $E9A3: A0 00   
    STY   $9E                ; $E9A5: 84 9E   
    CPY   $B7                ; $E9A7: C4 B7   
    BEQ   $E9BC              ; $E9A9: F0 11   
    JSR   $F7AE              ; $E9AB: 20 AE F7
    LDY   $9F                ; $E9AE: A4 9F   
    CMP   ($B2),Y            ; $E9B0: D1 B2   
    BNE   $E99A              ; $E9B2: D0 E6   
    INC   $9E                ; $E9B4: E6 9E   
    INC   $9F                ; $E9B6: E6 9F   
    LDY   $9E                ; $E9B8: A4 9E   
    BNE   $E9A7              ; $E9BA: D0 EB   
    CLC                      ; $E9BC: 18      
    RTS                      ; $E9BD: 60      
    JSR   $E980              ; $E9BE: 20 80 E9
    INC   $A6                ; $E9C1: E6 A6   
    LDY   $A6                ; $E9C3: A4 A6   
    CPY   #$C0               ; $E9C5: C0 C0   
    RTS                      ; $E9C7: 60      
    JSR   $E9DF              ; $E9C8: 20 DF E9
    BEQ   $E9E7              ; $E9CB: F0 1A   
    LDY   #$1B               ; $E9CD: A0 1B   
    JSR   $F722              ; $E9CF: 20 22 F7
    JSR   $EA8F              ; $E9D2: 20 8F EA
    JSR   $E9DF              ; $E9D5: 20 DF E9
    BNE   $E9D2              ; $E9D8: D0 F8   
    LDY   #$6A               ; $E9DA: A0 6A   
    JMP   $F722              ; $E9DC: 4C 22 F7
    LDA   #$10               ; $E9DF: A9 10   
    BIT   $01                ; $E9E1: 24 01   
    BNE   $E9E7              ; $E9E3: D0 02   
    BIT   $01                ; $E9E5: 24 01   
    CLC                      ; $E9E7: 18      
    RTS                      ; $E9E8: 60      
    JSR   $E9DF              ; $E9E9: 20 DF E9
    BEQ   $E9E7              ; $E9EC: F0 F9   
    LDY   #$2E               ; $E9EE: A0 2E   
    BNE   $E9CF              ; $E9F0: D0 DD   
    LDA   #$00               ; $E9F2: A9 00   
    STA   $90                ; $E9F4: 85 90   
    STA   $93                ; $E9F6: 85 93   
    JSR   $E987              ; $E9F8: 20 87 E9
    JSR   $E9C8              ; $E9FB: 20 C8 E9
    BCS   $EA1F              ; $E9FE: B0 1F   
    SEI                      ; $EA00: 78      
    LDA   #$00               ; $EA01: A9 00   
    STA   $AA                ; $EA03: 85 AA   
    STA   $B4                ; $EA05: 85 B4   
    STA   $B0                ; $EA07: 85 B0   
    STA   $9E                ; $EA09: 85 9E   
    STA   $9F                ; $EA0B: 85 9F   
    STA   $9C                ; $EA0D: 85 9C   
    LDA   #$90               ; $EA0F: A9 90   
    LDX   #$0E               ; $EA11: A2 0E   
    BNE   $EA26              ; $EA13: D0 11   
    JSR   $E987              ; $EA15: 20 87 E9
    LDA   #$14               ; $EA18: A9 14   
    STA   $AB                ; $EA1A: 85 AB   
    JSR   $E9E9              ; $EA1C: 20 E9 E9
    BCS   $EA9B              ; $EA1F: B0 7A   
    SEI                      ; $EA21: 78      
    LDA   #$82               ; $EA22: A9 82   
    LDX   #$08               ; $EA24: A2 08   
    LDY   #$00               ; $EA26: A0 00   
    STY   $D01A              ; $EA28: 8C 1A D0 (VIC_IRQMSK)
    DEY                      ; $EA2B: 88      
    STY   $D019              ; $EA2C: 8C 19 D0 (VIC_VICIRQ)
    STA   $DC0D              ; $EA2F: 8D 0D DC (CIA1_ICR)
    LDA   $DC0E              ; $EA32: AD 0E DC (CIA1_CRA)
    ORA   #$19               ; $EA35: 09 19   
    STA   $DC0F              ; $EA37: 8D 0F DC (CIA1_CRB)
    AND   #$91               ; $EA3A: 29 91   
    STA   $0A0B              ; $EA3C: 8D 0B 0A
    JSR   $E7EC              ; $EA3F: 20 EC E7
    LDA   $D011              ; $EA42: AD 11 D0 (VIC_SCROLY)
    TAY                      ; $EA45: A8      
    AND   #$10               ; $EA46: 29 10   
    STA   $0A39              ; $EA48: 8D 39 0A
    TYA                      ; $EA4B: 98      
    AND   #$6F               ; $EA4C: 29 6F   
    STA   $D011              ; $EA4E: 8D 11 D0 (VIC_SCROLY)
    JSR   $E574              ; $EA51: 20 74 E5
    LDA   $0314              ; $EA54: AD 14 03 (CINV)
    STA   $0A09              ; $EA57: 8D 09 0A
    LDA   $0315              ; $EA5A: AD 15 03
    STA   $0A0A              ; $EA5D: 8D 0A 0A
    JSR   $EE9B              ; $EA60: 20 9B EE
    LDA   #$02               ; $EA63: A9 02   
    STA   $BE                ; $EA65: 85 BE   
    JSR   $ED5A              ; $EA67: 20 5A ED
    LDA   $01                ; $EA6A: A5 01   
    AND   #$1F               ; $EA6C: 29 1F   
    STA   $01                ; $EA6E: 85 01   
    STA   $C0                ; $EA70: 85 C0   
    LDX   #$FF               ; $EA72: A2 FF   
    LDY   #$FF               ; $EA74: A0 FF   
    DEY                      ; $EA76: 88      
    BNE   $EA76              ; $EA77: D0 FD   
    DEX                      ; $EA79: CA      
    BNE   $EA74              ; $EA7A: D0 F8   
    CLI                      ; $EA7C: 58      
    LDA   $0A0A              ; $EA7D: AD 0A 0A
    CMP   $0315              ; $EA80: CD 15 03
    CLC                      ; $EA83: 18      
    BEQ   $EA9B              ; $EA84: F0 15   
    JSR   $EA8F              ; $EA86: 20 8F EA
    JSR   $F63D              ; $EA89: 20 3D F6
    JMP   $EA7D              ; $EA8C: 4C 7D EA
    JSR   $FFE1              ; $EA8F: 20 E1 FF (J_STOP)
    CLC                      ; $EA92: 18      
    BNE   $EAA0              ; $EA93: D0 0B   
    JSR   $EE57              ; $EA95: 20 57 EE
    SEC                      ; $EA98: 38      
    PLA                      ; $EA99: 68      
    PLA                      ; $EA9A: 68      
    LDA   #$00               ; $EA9B: A9 00   
    STA   $0A0A              ; $EA9D: 8D 0A 0A
    RTS                      ; $EAA0: 60      
    STX   $B1                ; $EAA1: 86 B1   
    LDA   $B0                ; $EAA3: A5 B0   
    ASL   A                  ; $EAA5: 0A      
    ASL   A                  ; $EAA6: 0A      
    CLC                      ; $EAA7: 18      
    ADC   $B0                ; $EAA8: 65 B0   
    CLC                      ; $EAAA: 18      
    ADC   $B1                ; $EAAB: 65 B1   
    STA   $B1                ; $EAAD: 85 B1   
    LDA   #$00               ; $EAAF: A9 00   
    BIT   $B0                ; $EAB1: 24 B0   
    BMI   $EAB6              ; $EAB3: 30 01   
    ROL   A                  ; $EAB5: 2A      
    ASL   $B1                ; $EAB6: 06 B1   
    ROL   A                  ; $EAB8: 2A      
    ASL   $B1                ; $EAB9: 06 B1   
    ROL   A                  ; $EABB: 2A      
    TAX                      ; $EABC: AA      
    LDA   $DC06              ; $EABD: AD 06 DC
    CMP   #$16               ; $EAC0: C9 16   
    BCC   $EABD              ; $EAC2: 90 F9   
    ADC   $B1                ; $EAC4: 65 B1   
    STA   $DC04              ; $EAC6: 8D 04 DC
    TXA                      ; $EAC9: 8A      
    ADC   $DC07              ; $EACA: 6D 07 DC
    STA   $DC05              ; $EACD: 8D 05 DC
    LDA   $0A0B              ; $EAD0: AD 0B 0A
    STA   $DC0E              ; $EAD3: 8D 0E DC (CIA1_CRA)
    STA   $0A0D              ; $EAD6: 8D 0D 0A
    LDA   $DC0D              ; $EAD9: AD 0D DC (CIA1_ICR)
    AND   #$10               ; $EADC: 29 10   
    BEQ   $EAE9              ; $EADE: F0 09   
    LDA   #$EA               ; $EAE0: A9 EA   
    PHA                      ; $EAE2: 48      
    LDA   #$E9               ; $EAE3: A9 E9   
    PHA                      ; $EAE5: 48      
    JMP   $EEC8              ; $EAE6: 4C C8 EE
    CLI                      ; $EAE9: 58      
    RTS                      ; $EAEA: 60      
    LDX   $DC07              ; $EAEB: AE 07 DC
    LDY   #$FF               ; $EAEE: A0 FF   
    TYA                      ; $EAF0: 98      
    SBC   $DC06              ; $EAF1: ED 06 DC
    CPX   $DC07              ; $EAF4: EC 07 DC
    BNE   $EAEB              ; $EAF7: D0 F2   
    STX   $B1                ; $EAF9: 86 B1   
    TAX                      ; $EAFB: AA      
    STY   $DC06              ; $EAFC: 8C 06 DC
    STY   $DC07              ; $EAFF: 8C 07 DC
    LDA   #$19               ; $EB02: A9 19   
    STA   $DC0F              ; $EB04: 8D 0F DC (CIA1_CRB)
    LDA   $DC0D              ; $EB07: AD 0D DC (CIA1_ICR)
    STA   $0A0C              ; $EB0A: 8D 0C 0A
    TYA                      ; $EB0D: 98      
    SBC   $B1                ; $EB0E: E5 B1   
    STX   $B1                ; $EB10: 86 B1   
    LSR   A                  ; $EB12: 4A      
    ROR   $B1                ; $EB13: 66 B1   
    LSR   A                  ; $EB15: 4A      
    ROR   $B1                ; $EB16: 66 B1   
    LDA   $B0                ; $EB18: A5 B0   
    CLC                      ; $EB1A: 18      
    ADC   #$3C               ; $EB1B: 69 3C   
    CMP   $B1                ; $EB1D: C5 B1   
    BCS   $EB6B              ; $EB1F: B0 4A   
    LDX   $9C                ; $EB21: A6 9C   
    BEQ   $EB28              ; $EB23: F0 03   
    JMP   $EC1F              ; $EB25: 4C 1F EC
    LDX   $A3                ; $EB28: A6 A3   
    BMI   $EB47              ; $EB2A: 30 1B   
    LDX   #$00               ; $EB2C: A2 00   
    ADC   #$30               ; $EB2E: 69 30   
    ADC   $B0                ; $EB30: 65 B0   
    CMP   $B1                ; $EB32: C5 B1   
    BCS   $EB52              ; $EB34: B0 1C   
    INX                      ; $EB36: E8      
    ADC   #$26               ; $EB37: 69 26   
    ADC   $B0                ; $EB39: 65 B0   
    CMP   $B1                ; $EB3B: C5 B1   
    BCS   $EB56              ; $EB3D: B0 17   
    ADC   #$2C               ; $EB3F: 69 2C   
    ADC   $B0                ; $EB41: 65 B0   
    CMP   $B1                ; $EB43: C5 B1   
    BCC   $EB4A              ; $EB45: 90 03   
    JMP   $EBCF              ; $EB47: 4C CF EB
    LDA   $B4                ; $EB4A: A5 B4   
    BEQ   $EB6B              ; $EB4C: F0 1D   
    STA   $A8                ; $EB4E: 85 A8   
    BNE   $EB6B              ; $EB50: D0 19   
    INC   $A9                ; $EB52: E6 A9   
    BCS   $EB58              ; $EB54: B0 02   
    DEC   $A9                ; $EB56: C6 A9   
    SEC                      ; $EB58: 38      
    SBC   #$13               ; $EB59: E9 13   
    SBC   $B1                ; $EB5B: E5 B1   
    ADC   $92                ; $EB5D: 65 92   
    STA   $92                ; $EB5F: 85 92   
    LDA   $A4                ; $EB61: A5 A4   
    EOR   #$01               ; $EB63: 49 01   
    STA   $A4                ; $EB65: 85 A4   
    BEQ   $EB94              ; $EB67: F0 2B   
    STX   $C5                ; $EB69: 86 C5   
    LDA   $B4                ; $EB6B: A5 B4   
    BEQ   $EB91              ; $EB6D: F0 22   
    LDA   $0A0C              ; $EB6F: AD 0C 0A
    AND   #$01               ; $EB72: 29 01   
    BNE   $EB7B              ; $EB74: D0 05   
    LDA   $0A0D              ; $EB76: AD 0D 0A
    BNE   $EB91              ; $EB79: D0 16   
    LDA   #$00               ; $EB7B: A9 00   
    STA   $A4                ; $EB7D: 85 A4   
    STA   $0A0D              ; $EB7F: 8D 0D 0A
    LDA   $A3                ; $EB82: A5 A3   
    BPL   $EBB6              ; $EB84: 10 30   
    BMI   $EB47              ; $EB86: 30 BF   
    LDX   #$A6               ; $EB88: A2 A6   
    JSR   $EAA1              ; $EB8A: 20 A1 EA
    LDA   $9B                ; $EB8D: A5 9B   
    BNE   $EB4A              ; $EB8F: D0 B9   
    JMP   $FF33              ; $EB91: 4C 33 FF
    LDA   $92                ; $EB94: A5 92   
    BEQ   $EB9F              ; $EB96: F0 07   
    BMI   $EB9D              ; $EB98: 30 03   
    DEC   $B0                ; $EB9A: C6 B0   
    BIT   $B0E6              ; $EB9C: 2C E6 B0
    LDA   #$00               ; $EB9F: A9 00   
    STA   $92                ; $EBA1: 85 92   
    CPX   $C5                ; $EBA3: E4 C5   
    BNE   $EBB6              ; $EBA5: D0 0F   
    TXA                      ; $EBA7: 8A      
    BNE   $EB4A              ; $EBA8: D0 A0   
    LDA   $A9                ; $EBAA: A5 A9   
    BMI   $EB6B              ; $EBAC: 30 BD   
    CMP   #$10               ; $EBAE: C9 10   
    BCC   $EB6B              ; $EBB0: 90 B9   
    STA   $96                ; $EBB2: 85 96   
    BCS   $EB6B              ; $EBB4: B0 B5   
    TXA                      ; $EBB6: 8A      
    EOR   $9B                ; $EBB7: 45 9B   
    STA   $9B                ; $EBB9: 85 9B   
    LDA   $B4                ; $EBBB: A5 B4   
    BEQ   $EB91              ; $EBBD: F0 D2   
    DEC   $A3                ; $EBBF: C6 A3   
    BMI   $EB88              ; $EBC1: 30 C5   
    LSR   $C5                ; $EBC3: 46 C5   
    ROR   $BF                ; $EBC5: 66 BF   
    LDX   #$DA               ; $EBC7: A2 DA   
    JSR   $EAA1              ; $EBC9: 20 A1 EA
    JMP   $FF33              ; $EBCC: 4C 33 FF
    LDA   $96                ; $EBCF: A5 96   
    BEQ   $EBD7              ; $EBD1: F0 04   
    LDA   $B4                ; $EBD3: A5 B4   
    BEQ   $EBDE              ; $EBD5: F0 07   
    LDA   $A3                ; $EBD7: A5 A3   
    BMI   $EBDE              ; $EBD9: 30 03   
    JMP   $EB56              ; $EBDB: 4C 56 EB
    LSR   $B1                ; $EBDE: 46 B1   
    LDA   #$93               ; $EBE0: A9 93   
    SEC                      ; $EBE2: 38      
    SBC   $B1                ; $EBE3: E5 B1   
    ADC   $B0                ; $EBE5: 65 B0   
    ASL   A                  ; $EBE7: 0A      
    TAX                      ; $EBE8: AA      
    JSR   $EAA1              ; $EBE9: 20 A1 EA
    INC   $9C                ; $EBEC: E6 9C   
    LDA   $B4                ; $EBEE: A5 B4   
    BNE   $EC03              ; $EBF0: D0 11   
    LDA   $96                ; $EBF2: A5 96   
    BEQ   $EC1C              ; $EBF4: F0 26   
    STA   $A8                ; $EBF6: 85 A8   
    LDA   #$00               ; $EBF8: A9 00   
    STA   $96                ; $EBFA: 85 96   
    LDA   #$81               ; $EBFC: A9 81   
    STA   $DC0D              ; $EBFE: 8D 0D DC (CIA1_ICR)
    STA   $B4                ; $EC01: 85 B4   
    LDA   $96                ; $EC03: A5 96   
    STA   $B5                ; $EC05: 85 B5   
    BEQ   $EC12              ; $EC07: F0 09   
    LDA   #$00               ; $EC09: A9 00   
    STA   $B4                ; $EC0B: 85 B4   
    LDA   #$01               ; $EC0D: A9 01   
    STA   $DC0D              ; $EC0F: 8D 0D DC (CIA1_ICR)
    LDA   $BF                ; $EC12: A5 BF   
    STA   $BD                ; $EC14: 85 BD   
    LDA   $A8                ; $EC16: A5 A8   
    ORA   $A9                ; $EC18: 05 A9   
    STA   $B6                ; $EC1A: 85 B6   
    JMP   $FF33              ; $EC1C: 4C 33 FF
    JSR   $ED5A              ; $EC1F: 20 5A ED
    STA   $9C                ; $EC22: 85 9C   
    LDX   #$DA               ; $EC24: A2 DA   
    JSR   $EAA1              ; $EC26: 20 A1 EA
    LDA   $BE                ; $EC29: A5 BE   
    BEQ   $EC2F              ; $EC2B: F0 02   
    STA   $A7                ; $EC2D: 85 A7   
    LDA   #$0F               ; $EC2F: A9 0F   
    BIT   $AA                ; $EC31: 24 AA   
    BPL   $EC4C              ; $EC33: 10 17   
    LDA   $B5                ; $EC35: A5 B5   
    BNE   $EC45              ; $EC37: D0 0C   
    LDX   $BE                ; $EC39: A6 BE   
    DEX                      ; $EC3B: CA      
    BNE   $EC49              ; $EC3C: D0 0B   
    LDA   #$08               ; $EC3E: A9 08   
    JSR   $F757              ; $EC40: 20 57 F7
    BNE   $EC49              ; $EC43: D0 04   
    LDA   #$00               ; $EC45: A9 00   
    STA   $AA                ; $EC47: 85 AA   
    JMP   $FF33              ; $EC49: 4C 33 FF
    BVS   $EC7F              ; $EC4C: 70 31   
    BNE   $EC68              ; $EC4E: D0 18   
    LDA   $B5                ; $EC50: A5 B5   
    BNE   $EC49              ; $EC52: D0 F5   
    LDA   $B6                ; $EC54: A5 B6   
    BNE   $EC49              ; $EC56: D0 F1   
    LDA   $A7                ; $EC58: A5 A7   
    LSR   A                  ; $EC5A: 4A      
    LDA   $BD                ; $EC5B: A5 BD   
    BMI   $EC62              ; $EC5D: 30 03   
    BCC   $EC79              ; $EC5F: 90 18   
    CLC                      ; $EC61: 18      
    BCS   $EC79              ; $EC62: B0 15   
    AND   #$0F               ; $EC64: 29 0F   
    STA   $AA                ; $EC66: 85 AA   
    DEC   $AA                ; $EC68: C6 AA   
    BNE   $EC49              ; $EC6A: D0 DD   
    LDA   #$40               ; $EC6C: A9 40   
    STA   $AA                ; $EC6E: 85 AA   
    JSR   $ED51              ; $EC70: 20 51 ED
    LDA   #$00               ; $EC73: A9 00   
    STA   $AB                ; $EC75: 85 AB   
    BEQ   $EC49              ; $EC77: F0 D0   
    LDA   #$80               ; $EC79: A9 80   
    STA   $AA                ; $EC7B: 85 AA   
    BNE   $EC49              ; $EC7D: D0 CA   
    LDA   $B5                ; $EC7F: A5 B5   
    BEQ   $EC8D              ; $EC81: F0 0A   
    LDA   #$04               ; $EC83: A9 04   
    JSR   $F757              ; $EC85: 20 57 F7
    LDA   #$00               ; $EC88: A9 00   
    JMP   $ED0C              ; $EC8A: 4C 0C ED
    JSR   $EEB7              ; $EC8D: 20 B7 EE
    BCC   $EC95              ; $EC90: 90 03   
    JMP   $ED0A              ; $EC92: 4C 0A ED
    LDX   $A7                ; $EC95: A6 A7   
    DEX                      ; $EC97: CA      
    BEQ   $ECC8              ; $EC98: F0 2E   
    LDA   $93                ; $EC9A: A5 93   
    BEQ   $ECAB              ; $EC9C: F0 0D   
    LDY   #$00               ; $EC9E: A0 00   
    JSR   $F7CC              ; $ECA0: 20 CC F7
    CMP   $BD                ; $ECA3: C5 BD   
    BEQ   $ECAB              ; $ECA5: F0 04   
    LDA   #$01               ; $ECA7: A9 01   
    STA   $B6                ; $ECA9: 85 B6   
    LDA   $B6                ; $ECAB: A5 B6   
    BEQ   $ECFB              ; $ECAD: F0 4C   
    LDX   #$3D               ; $ECAF: A2 3D   
    CPX   $9E                ; $ECB1: E4 9E   
    BCC   $ECF4              ; $ECB3: 90 3F   
    LDX   $9E                ; $ECB5: A6 9E   
    LDA   $AD                ; $ECB7: A5 AD   
    STA   $0101,X            ; $ECB9: 9D 01 01
    LDA   $AC                ; $ECBC: A5 AC   
    STA   $0100,X            ; $ECBE: 9D 00 01
    INX                      ; $ECC1: E8      
    INX                      ; $ECC2: E8      
    STX   $9E                ; $ECC3: 86 9E   
    JMP   $ECFB              ; $ECC5: 4C FB EC
    LDX   $9F                ; $ECC8: A6 9F   
    CPX   $9E                ; $ECCA: E4 9E   
    BEQ   $ED05              ; $ECCC: F0 37   
    LDA   $AC                ; $ECCE: A5 AC   
    CMP   $0100,X            ; $ECD0: DD 00 01
    BNE   $ED05              ; $ECD3: D0 30   
    LDA   $AD                ; $ECD5: A5 AD   
    CMP   $0101,X            ; $ECD7: DD 01 01
    BNE   $ED05              ; $ECDA: D0 29   
    INC   $9F                ; $ECDC: E6 9F   
    INC   $9F                ; $ECDE: E6 9F   
    LDA   $93                ; $ECE0: A5 93   
    BEQ   $ECF0              ; $ECE2: F0 0C   
    LDY   #$00               ; $ECE4: A0 00   
    JSR   $F7CC              ; $ECE6: 20 CC F7
    CMP   $BD                ; $ECE9: C5 BD   
    BEQ   $ED05              ; $ECEB: F0 18   
    INY                      ; $ECED: C8      
    STY   $B6                ; $ECEE: 84 B6   
    LDA   $B6                ; $ECF0: A5 B6   
    BEQ   $ECFB              ; $ECF2: F0 07   
    LDA   #$10               ; $ECF4: A9 10   
    JSR   $F757              ; $ECF6: 20 57 F7
    BNE   $ED05              ; $ECF9: D0 0A   
    LDA   $93                ; $ECFB: A5 93   
    BNE   $ED05              ; $ECFD: D0 06   
    TAY                      ; $ECFF: A8      
    LDA   $BD                ; $ED00: A5 BD   
    JSR   $F7BC              ; $ED02: 20 BC F7
    JSR   $EEC1              ; $ED05: 20 C1 EE
    BNE   $ED4E              ; $ED08: D0 44   
    LDA   #$80               ; $ED0A: A9 80   
    STA   $AA                ; $ED0C: 85 AA   
    SEI                      ; $ED0E: 78      
    LDX   #$01               ; $ED0F: A2 01   
    STX   $DC0D              ; $ED11: 8E 0D DC (CIA1_ICR)
    LDX   $DC0D              ; $ED14: AE 0D DC (CIA1_ICR)
    LDX   $BE                ; $ED17: A6 BE   
    DEX                      ; $ED19: CA      
    BMI   $ED1E              ; $ED1A: 30 02   
    STX   $BE                ; $ED1C: 86 BE   
    DEC   $A7                ; $ED1E: C6 A7   
    BEQ   $ED2A              ; $ED20: F0 08   
    LDA   $9E                ; $ED22: A5 9E   
    BNE   $ED4E              ; $ED24: D0 28   
    STA   $BE                ; $ED26: 85 BE   
    BEQ   $ED4E              ; $ED28: F0 24   
    JSR   $EE57              ; $ED2A: 20 57 EE
    JSR   $ED51              ; $ED2D: 20 51 ED
    LDY   #$00               ; $ED30: A0 00   
    STY   $AB                ; $ED32: 84 AB   
    JSR   $F7CC              ; $ED34: 20 CC F7
    EOR   $AB                ; $ED37: 45 AB   
    STA   $AB                ; $ED39: 85 AB   
    JSR   $EEC1              ; $ED3B: 20 C1 EE
    JSR   $EEB7              ; $ED3E: 20 B7 EE
    BCC   $ED34              ; $ED41: 90 F1   
    LDA   $AB                ; $ED43: A5 AB   
    EOR   $BD                ; $ED45: 45 BD   
    BEQ   $ED4E              ; $ED47: F0 05   
    LDA   #$20               ; $ED49: A9 20   
    JSR   $F757              ; $ED4B: 20 57 F7
    JMP   $FF33              ; $ED4E: 4C 33 FF
    LDA   $C2                ; $ED51: A5 C2   
    STA   $AD                ; $ED53: 85 AD   
    LDA   $C1                ; $ED55: A5 C1   
    STA   $AC                ; $ED57: 85 AC   
    RTS                      ; $ED59: 60      
    LDA   #$08               ; $ED5A: A9 08   
    STA   $A3                ; $ED5C: 85 A3   
    LDA   #$00               ; $ED5E: A9 00   
    STA   $A4                ; $ED60: 85 A4   
    STA   $A8                ; $ED62: 85 A8   
    STA   $9B                ; $ED64: 85 9B   
    STA   $A9                ; $ED66: 85 A9   
    RTS                      ; $ED68: 60      
    LDA   $BD                ; $ED69: A5 BD   
    LSR   A                  ; $ED6B: 4A      
    LDA   #$60               ; $ED6C: A9 60   
    BCC   $ED72              ; $ED6E: 90 02   
    LDA   #$B0               ; $ED70: A9 B0   
    LDX   #$00               ; $ED72: A2 00   
    STA   $DC06              ; $ED74: 8D 06 DC
    STX   $DC07              ; $ED77: 8E 07 DC
    LDA   $DC0D              ; $ED7A: AD 0D DC (CIA1_ICR)
    LDA   #$19               ; $ED7D: A9 19   
    STA   $DC0F              ; $ED7F: 8D 0F DC (CIA1_CRB)
    LDA   $01                ; $ED82: A5 01   
    EOR   #$08               ; $ED84: 49 08   
    STA   $01                ; $ED86: 85 01   
    AND   #$08               ; $ED88: 29 08   
    RTS                      ; $ED8A: 60      
    SEC                      ; $ED8B: 38      
    ROR   $B6                ; $ED8C: 66 B6   
    BMI   $EDCC              ; $ED8E: 30 3C   
    LDA   $A8                ; $ED90: A5 A8   
    BNE   $EDA6              ; $ED92: D0 12   
    LDA   #$10               ; $ED94: A9 10   
    LDX   #$01               ; $ED96: A2 01   
    JSR   $ED74              ; $ED98: 20 74 ED
    BNE   $EDCC              ; $ED9B: D0 2F   
    INC   $A8                ; $ED9D: E6 A8   
    LDA   $B6                ; $ED9F: A5 B6   
    BPL   $EDCC              ; $EDA1: 10 29   
    JMP   $EE1B              ; $EDA3: 4C 1B EE
    LDA   $A9                ; $EDA6: A5 A9   
    BNE   $EDB3              ; $EDA8: D0 09   
    JSR   $ED70              ; $EDAA: 20 70 ED
    BNE   $EDCC              ; $EDAD: D0 1D   
    INC   $A9                ; $EDAF: E6 A9   
    BNE   $EDCC              ; $EDB1: D0 19   
    JSR   $ED69              ; $EDB3: 20 69 ED
    BNE   $EDCC              ; $EDB6: D0 14   
    LDA   $A4                ; $EDB8: A5 A4   
    EOR   #$01               ; $EDBA: 49 01   
    STA   $A4                ; $EDBC: 85 A4   
    BEQ   $EDCF              ; $EDBE: F0 0F   
    LDA   $BD                ; $EDC0: A5 BD   
    EOR   #$01               ; $EDC2: 49 01   
    STA   $BD                ; $EDC4: 85 BD   
    AND   #$01               ; $EDC6: 29 01   
    EOR   $9B                ; $EDC8: 45 9B   
    STA   $9B                ; $EDCA: 85 9B   
    JMP   $FF33              ; $EDCC: 4C 33 FF
    LSR   $BD                ; $EDCF: 46 BD   
    DEC   $A3                ; $EDD1: C6 A3   
    LDA   $A3                ; $EDD3: A5 A3   
    BEQ   $EE12              ; $EDD5: F0 3B   
    BPL   $EDCC              ; $EDD7: 10 F3   
    JSR   $ED5A              ; $EDD9: 20 5A ED
    CLI                      ; $EDDC: 58      
    LDA   $A5                ; $EDDD: A5 A5   
    BEQ   $EDF3              ; $EDDF: F0 12   
    LDX   #$00               ; $EDE1: A2 00   
    STX   $C5                ; $EDE3: 86 C5   
    DEC   $A5                ; $EDE5: C6 A5   
    LDX   $BE                ; $EDE7: A6 BE   
    CPX   #$02               ; $EDE9: E0 02   
    BNE   $EDEF              ; $EDEB: D0 02   
    ORA   #$80               ; $EDED: 09 80   
    STA   $BD                ; $EDEF: 85 BD   
    BNE   $EDCC              ; $EDF1: D0 D9   
    JSR   $EEB7              ; $EDF3: 20 B7 EE
    BCC   $EE02              ; $EDF6: 90 0A   
    BNE   $ED8B              ; $EDF8: D0 91   
    INC   $AD                ; $EDFA: E6 AD   
    LDA   $C5                ; $EDFC: A5 C5   
    STA   $BD                ; $EDFE: 85 BD   
    BCS   $EDCC              ; $EE00: B0 CA   
    LDY   #$00               ; $EE02: A0 00   
    JSR   $F7CC              ; $EE04: 20 CC F7
    STA   $BD                ; $EE07: 85 BD   
    EOR   $C5                ; $EE09: 45 C5   
    STA   $C5                ; $EE0B: 85 C5   
    JSR   $EEC1              ; $EE0D: 20 C1 EE
    BNE   $EDCC              ; $EE10: D0 BA   
    LDA   $9B                ; $EE12: A5 9B   
    EOR   #$01               ; $EE14: 49 01   
    STA   $BD                ; $EE16: 85 BD   
    JMP   $FF33              ; $EE18: 4C 33 FF
    DEC   $BE                ; $EE1B: C6 BE   
    BNE   $EE22              ; $EE1D: D0 03   
    JSR   $EEB0              ; $EE1F: 20 B0 EE
    LDA   #$50               ; $EE22: A9 50   
    STA   $A7                ; $EE24: 85 A7   
    LDX   #$08               ; $EE26: A2 08   
    SEI                      ; $EE28: 78      
    JSR   $EE9B              ; $EE29: 20 9B EE
    BNE   $EE18              ; $EE2C: D0 EA   
    LDA   #$78               ; $EE2E: A9 78   
    JSR   $ED72              ; $EE30: 20 72 ED
    BNE   $EE18              ; $EE33: D0 E3   
    DEC   $A7                ; $EE35: C6 A7   
    BNE   $EE18              ; $EE37: D0 DF   
    JSR   $ED5A              ; $EE39: 20 5A ED
    DEC   $AB                ; $EE3C: C6 AB   
    BPL   $EE18              ; $EE3E: 10 D8   
    LDX   #$0A               ; $EE40: A2 0A   
    JSR   $EE9B              ; $EE42: 20 9B EE
    CLI                      ; $EE45: 58      
    INC   $AB                ; $EE46: E6 AB   
    LDA   $BE                ; $EE48: A5 BE   
    BEQ   $EE95              ; $EE4A: F0 49   
    JSR   $ED51              ; $EE4C: 20 51 ED
    LDX   #$09               ; $EE4F: A2 09   
    STX   $A5                ; $EE51: 86 A5   
    STX   $B6                ; $EE53: 86 B6   
    BNE   $EDD9              ; $EE55: D0 82   
    PHP                      ; $EE57: 08      
    SEI                      ; $EE58: 78      
    LDA   $D011              ; $EE59: AD 11 D0 (VIC_SCROLY)
    ORA   $0A39              ; $EE5C: 0D 39 0A
    AND   #$7F               ; $EE5F: 29 7F   
    STA   $D011              ; $EE61: 8D 11 D0 (VIC_SCROLY)
    BIT   $0A3A              ; $EE64: 2C 3A 0A
    BMI   $EE7F              ; $EE67: 30 16   
    BIT   $0A37              ; $EE69: 2C 37 0A
    BPL   $EE7F              ; $EE6C: 10 11   
    LDA   $0A38              ; $EE6E: AD 38 0A
    STA   $D015              ; $EE71: 8D 15 D0 (VIC_SPENA)
    LDA   $0A37              ; $EE74: AD 37 0A
    STA   $D030              ; $EE77: 8D 30 D0 (VIC_CLK2MHZ)
    LDA   #$00               ; $EE7A: A9 00   
    STA   $0A37              ; $EE7C: 8D 37 0A
    JSR   $EEB0              ; $EE7F: 20 B0 EE
    JSR   $E1B8              ; $EE82: 20 B8 E1
    LDA   $0A0A              ; $EE85: AD 0A 0A
    BEQ   $EE93              ; $EE88: F0 09   
    STA   $0315              ; $EE8A: 8D 15 03
    LDA   $0A09              ; $EE8D: AD 09 0A
    STA   $0314              ; $EE90: 8D 14 03 (CINV)
    PLP                      ; $EE93: 28      
    RTS                      ; $EE94: 60      
    JSR   $EE57              ; $EE95: 20 57 EE
    JMP   $FF33              ; $EE98: 4C 33 FF
    LDA   $EEA0,X            ; $EE9B: BD A0 EE
    STA   $0314              ; $EE9E: 8D 14 03 (CINV)
    LDA   $EEA1,X            ; $EEA1: BD A1 EE
    STA   $0315              ; $EEA4: 8D 15 03
    RTS                      ; $EEA7: 60      
    ROL   $90EE              ; $EEA8: 2E EE 90
    SBC   $FA65              ; $EEAB: ED 65 FA
    .BYTE $EB                                ; $EEAE: EB [UNRESOLVED]
    NOP                      ; $EEAF: EA      
    LDA   $01                ; $EEB0: A5 01   
    ORA   #$20               ; $EEB2: 09 20   
    STA   $01                ; $EEB4: 85 01   
    RTS                      ; $EEB6: 60      
    SEC                      ; $EEB7: 38      
    LDA   $AC                ; $EEB8: A5 AC   
    SBC   $AE                ; $EEBA: E5 AE   
    LDA   $AD                ; $EEBC: A5 AD   
    SBC   $AF                ; $EEBE: E5 AF   
    RTS                      ; $EEC0: 60      
    INC   $AC                ; $EEC1: E6 AC   
    BNE   $EEC7              ; $EEC3: D0 02   
    INC   $AD                ; $EEC5: E6 AD   
    RTS                      ; $EEC7: 60      
    PHP                      ; $EEC8: 08      
    PLA                      ; $EEC9: 68      
    AND   #$EF               ; $EECA: 29 EF   
    PHA                      ; $EECC: 48      
    JMP   $FF17              ; $EECD: 4C 17 FF (HW_IRQ_ENTRY)
    LDA   $01                ; $EED0: A5 01   
    AND   #$10               ; $EED2: 29 10   
    BEQ   $EEE0              ; $EED4: F0 0A   
    LDY   #$00               ; $EED6: A0 00   
    STY   $C0                ; $EED8: 84 C0   
    LDA   $01                ; $EEDA: A5 01   
    ORA   #$20               ; $EEDC: 09 20   
    BNE   $EEE8              ; $EEDE: D0 08   
    LDA   $C0                ; $EEE0: A5 C0   
    BNE   $EEEA              ; $EEE2: D0 06   
    LDA   $01                ; $EEE4: A5 01   
    AND   #$DF               ; $EEE6: 29 DF   
    STA   $01                ; $EEE8: 85 01   
    RTS                      ; $EEEA: 60      
    LDA   $99                ; $EEEB: A5 99   
    BNE   $EEF9              ; $EEED: D0 0A   
    LDA   $D0                ; $EEEF: A5 D0   
    ORA   $D1                ; $EEF1: 05 D1   
    BEQ   $EF04              ; $EEF3: F0 0F   
    SEI                      ; $EEF5: 78      
    JMP   $C006              ; $EEF6: 4C 06 C0 (ED_JLP2)
    CMP   #$02               ; $EEF9: C9 02   
    BNE   $EF15              ; $EEFB: D0 18   
    STY   $97                ; $EEFD: 84 97   
    JSR   $E7CE              ; $EEFF: 20 CE E7
    LDY   $97                ; $EF02: A4 97   
    CLC                      ; $EF04: 18      
    RTS                      ; $EF05: 60      
    LDA   $99                ; $EF06: A5 99   
    BNE   $EF15              ; $EF08: D0 0B   
    LDA   $EC                ; $EF0A: A5 EC   
    STA   $E9                ; $EF0C: 85 E9   
    LDA   $EB                ; $EF0E: A5 EB   
    STA   $E8                ; $EF10: 85 E8   
    JMP   $C009              ; $EF12: 4C 09 C0 (ED_JLOOP5)
    CMP   #$03               ; $EF15: C9 03   
    BNE   $EF22              ; $EF17: D0 09   
    STA   $D6                ; $EF19: 85 D6   
    LDA   $E7                ; $EF1B: A5 E7   
    STA   $EA                ; $EF1D: 85 EA   
    JMP   $C009              ; $EF1F: 4C 09 C0 (ED_JLOOP5)
    BCS   $EF5C              ; $EF22: B0 38   
    CMP   #$02               ; $EF24: C9 02   
    BEQ   $EF67              ; $EF26: F0 3F   
    STX   $97                ; $EF28: 86 97   
    JSR   $EF48              ; $EF2A: 20 48 EF
    BCS   $EF45              ; $EF2D: B0 16   
    PHA                      ; $EF2F: 48      
    JSR   $EF48              ; $EF30: 20 48 EF
    BCS   $EF42              ; $EF33: B0 0D   
    BNE   $EF3C              ; $EF35: D0 05   
    LDA   #$40               ; $EF37: A9 40   
    JSR   $F757              ; $EF39: 20 57 F7
    DEC   $A6                ; $EF3C: C6 A6   
    LDX   $97                ; $EF3E: A6 97   
    PLA                      ; $EF40: 68      
    RTS                      ; $EF41: 60      
    TAX                      ; $EF42: AA      
    PLA                      ; $EF43: 68      
    TXA                      ; $EF44: 8A      
    LDX   $97                ; $EF45: A6 97   
    RTS                      ; $EF47: 60      
    JSR   $E9BE              ; $EF48: 20 BE E9
    BNE   $EF58              ; $EF4B: D0 0B   
    JSR   $E9F2              ; $EF4D: 20 F2 E9
    BCS   $EF5B              ; $EF50: B0 09   
    LDA   #$00               ; $EF52: A9 00   
    STA   $A6                ; $EF54: 85 A6   
    BEQ   $EF48              ; $EF56: F0 F0   
    LDA   ($B2),Y            ; $EF58: B1 B2   
    CLC                      ; $EF5A: 18      
    RTS                      ; $EF5B: 60      
    LDA   $90                ; $EF5C: A5 90   
    BNE   $EF63              ; $EF5E: D0 03   
    JMP   $E43E              ; $EF60: 4C 3E E4 (KERNAL_ACPTR)
    LDA   #$0D               ; $EF63: A9 0D   
    CLC                      ; $EF65: 18      
    RTS                      ; $EF66: 60      
    JSR   $EEFD              ; $EF67: 20 FD EE
    BCS   $EF65              ; $EF6A: B0 F9   
    CMP   #$00               ; $EF6C: C9 00   
    BNE   $EF66              ; $EF6E: D0 F6   
    LDA   $0A14              ; $EF70: AD 14 0A
    AND   #$60               ; $EF73: 29 60   
    BNE   $EF63              ; $EF75: D0 EC   
    BEQ   $EF67              ; $EF77: F0 EE   
    PHA                      ; $EF79: 48      
    LDA   $9A                ; $EF7A: A5 9A   
    CMP   #$03               ; $EF7C: C9 03   
    BNE   $EF84              ; $EF7E: D0 04   
    PLA                      ; $EF80: 68      
    JMP   $C00C              ; $EF81: 4C 0C C0 (ED_JPRT)
    BCC   $EF8A              ; $EF84: 90 04   
    PLA                      ; $EF86: 68      
    JMP   $E503              ; $EF87: 4C 03 E5 (KERNAL_CIOUT)
    LSR   A                  ; $EF8A: 4A      
    PLA                      ; $EF8B: 68      
    STA   $9E                ; $EF8C: 85 9E   
    TXA                      ; $EF8E: 8A      
    PHA                      ; $EF8F: 48      
    TYA                      ; $EF90: 98      
    PHA                      ; $EF91: 48      
    BCC   $EFB7              ; $EF92: 90 23   
    JSR   $E9BE              ; $EF94: 20 BE E9
    BNE   $EFA7              ; $EF97: D0 0E   
    JSR   $EA15              ; $EF99: 20 15 EA
    BCS   $EFAC              ; $EF9C: B0 0E   
    LDA   #$02               ; $EF9E: A9 02   
    LDY   #$00               ; $EFA0: A0 00   
    STA   ($B2),Y            ; $EFA2: 91 B2   
    INY                      ; $EFA4: C8      
    STY   $A6                ; $EFA5: 84 A6   
    LDA   $9E                ; $EFA7: A5 9E   
    STA   ($B2),Y            ; $EFA9: 91 B2   
    CLC                      ; $EFAB: 18      
    PLA                      ; $EFAC: 68      
    TAY                      ; $EFAD: A8      
    PLA                      ; $EFAE: 68      
    TAX                      ; $EFAF: AA      
    LDA   $9E                ; $EFB0: A5 9E   
    BCC   $EFB6              ; $EFB2: 90 02   
    LDA   #$00               ; $EFB4: A9 00   
    RTS                      ; $EFB6: 60      
    JSR   $E75F              ; $EFB7: 20 5F E7
    JMP   $EFAB              ; $EFBA: 4C AB EF
    LDX   $B8                ; $EFBD: A6 B8   
    JSR   $F202              ; $EFBF: 20 02 F2
    BEQ   $EFF3              ; $EFC2: F0 2F   
    LDX   $98                ; $EFC4: A6 98   
    CPX   #$0A               ; $EFC6: E0 0A   
    BCS   $EFF0              ; $EFC8: B0 26   
    INC   $98                ; $EFCA: E6 98   
    LDA   $B8                ; $EFCC: A5 B8   
    STA   $0362,X            ; $EFCE: 9D 62 03
    LDA   $B9                ; $EFD1: A5 B9   
    ORA   #$60               ; $EFD3: 09 60   
    STA   $B9                ; $EFD5: 85 B9   
    STA   $0376,X            ; $EFD7: 9D 76 03
    LDA   $BA                ; $EFDA: A5 BA   
    STA   $036C,X            ; $EFDC: 9D 6C 03
    BEQ   $EFEE              ; $EFDF: F0 0D   
    CMP   #$02               ; $EFE1: C9 02   
    BEQ   $F040              ; $EFE3: F0 5B   
    BCC   $EFF6              ; $EFE5: 90 0F   
    CMP   #$03               ; $EFE7: C9 03   
    BEQ   $EFEE              ; $EFE9: F0 03   
    JSR   $F0CB              ; $EFEB: 20 CB F0
    CLC                      ; $EFEE: 18      
    RTS                      ; $EFEF: 60      
    JMP   $F67C              ; $EFF0: 4C 7C F6
    JMP   $F67F              ; $EFF3: 4C 7F F6
    JSR   $E980              ; $EFF6: 20 80 E9
    BCS   $EFFE              ; $EFF9: B0 03   
    JMP   $F694              ; $EFFB: 4C 94 F6
    LDA   $B9                ; $EFFE: A5 B9   
    AND   #$0F               ; $F000: 29 0F   
    BNE   $F023              ; $F002: D0 1F   
    JSR   $E9C8              ; $F004: 20 C8 E9
    BCS   $F03F              ; $F007: B0 36   
    JSR   $F50F              ; $F009: 20 0F F5
    LDA   $B7                ; $F00C: A5 B7   
    BEQ   $F01A              ; $F00E: F0 0A   
    JSR   $E99A              ; $F010: 20 9A E9
    BCC   $F02D              ; $F013: 90 18   
    BEQ   $F03F              ; $F015: F0 28   
    JMP   $F685              ; $F017: 4C 85 F6
    JSR   $E8D0              ; $F01A: 20 D0 E8
    BCC   $F02D              ; $F01D: 90 0E   
    BEQ   $F03F              ; $F01F: F0 1E   
    BCS   $F017              ; $F021: B0 F4   
    JSR   $E9E9              ; $F023: 20 E9 E9
    BCS   $F03F              ; $F026: B0 17   
    LDA   #$04               ; $F028: A9 04   
    JSR   $E919              ; $F02A: 20 19 E9
    LDA   #$BF               ; $F02D: A9 BF   
    LDY   $B9                ; $F02F: A4 B9   
    CPY   #$60               ; $F031: C0 60   
    BEQ   $F03C              ; $F033: F0 07   
    LDY   #$00               ; $F035: A0 00   
    LDA   #$02               ; $F037: A9 02   
    STA   ($B2),Y            ; $F039: 91 B2   
    TYA                      ; $F03B: 98      
    STA   $A6                ; $F03C: 85 A6   
    CLC                      ; $F03E: 18      
    RTS                      ; $F03F: 60      
    JSR   $F0B0              ; $F040: 20 B0 F0
    STY   $0A14              ; $F043: 8C 14 0A
    CPY   $B7                ; $F046: C4 B7   
    BEQ   $F055              ; $F048: F0 0B   
    JSR   $F7AE              ; $F04A: 20 AE F7
    STA   $0A10,Y            ; $F04D: 99 10 0A
    INY                      ; $F050: C8      
    CPY   #$04               ; $F051: C0 04   
    BNE   $F046              ; $F053: D0 F1   
    JSR   $E68E              ; $F055: 20 8E E6
    STX   $0A15              ; $F058: 8E 15 0A
    LDA   $0A10              ; $F05B: AD 10 0A
    AND   #$0F               ; $F05E: 29 0F   
    BEQ   $F07E              ; $F060: F0 1C   
    ASL   A                  ; $F062: 0A      
    TAX                      ; $F063: AA      
    LDA   $0A03              ; $F064: AD 03 0A
    BNE   $F072              ; $F067: D0 09   
    LDY   $E84F,X            ; $F069: BC 4F E8
    LDA   $E84E,X            ; $F06C: BD 4E E8
    JMP   $F078              ; $F06F: 4C 78 F0
    LDY   $E863,X            ; $F072: BC 63 E8
    LDA   $E862,X            ; $F075: BD 62 E8
    STY   $0A13              ; $F078: 8C 13 0A
    STA   $0A12              ; $F07B: 8D 12 0A
    LDA   $0A12              ; $F07E: AD 12 0A
    ASL   A                  ; $F081: 0A      
    TAX                      ; $F082: AA      
    LDA   $0A13              ; $F083: AD 13 0A
    ROL   A                  ; $F086: 2A      
    TAY                      ; $F087: A8      
    TXA                      ; $F088: 8A      
    ADC   #$C8               ; $F089: 69 C8   
    STA   $0A16              ; $F08B: 8D 16 0A
    TYA                      ; $F08E: 98      
    ADC   #$00               ; $F08F: 69 00   
    STA   $0A17              ; $F091: 8D 17 0A
    LDA   $0A11              ; $F094: AD 11 0A
    LSR   A                  ; $F097: 4A      
    BCC   $F0A3              ; $F098: 90 09   
    LDA   $DD01              ; $F09A: AD 01 DD (CIA2_PRB)
    ASL   A                  ; $F09D: 0A      
    BCS   $F0A3              ; $F09E: B0 03   
    JSR   $E755              ; $F0A0: 20 55 E7
    LDA   $0A18              ; $F0A3: AD 18 0A
    STA   $0A19              ; $F0A6: 8D 19 0A
    LDA   $0A1B              ; $F0A9: AD 1B 0A
    STA   $0A1A              ; $F0AC: 8D 1A 0A
    RTS                      ; $F0AF: 60      
    LDA   #$7F               ; $F0B0: A9 7F   
    STA   $DD0D              ; $F0B2: 8D 0D DD (CIA2_ICR)
    LDA   #$06               ; $F0B5: A9 06   
    STA   $DD03              ; $F0B7: 8D 03 DD (CIA2_DDRB)
    STA   $DD01              ; $F0BA: 8D 01 DD (CIA2_PRB)
    LDA   #$04               ; $F0BD: A9 04   
    ORA   $DD00              ; $F0BF: 0D 00 DD (CIA2_PRA)
    STA   $DD00              ; $F0C2: 8D 00 DD (CIA2_PRA)
    LDY   #$00               ; $F0C5: A0 00   
    STY   $0A0F              ; $F0C7: 8C 0F 0A
    RTS                      ; $F0CA: 60      
    LDA   $B9                ; $F0CB: A5 B9   
    BMI   $F0D3              ; $F0CD: 30 04   
    LDY   $B7                ; $F0CF: A4 B7   
    BNE   $F0D5              ; $F0D1: D0 02   
    CLC                      ; $F0D3: 18      
    RTS                      ; $F0D4: 60      
    LDA   #$00               ; $F0D5: A9 00   
    STA   $90                ; $F0D7: 85 90   
    LDA   $BA                ; $F0D9: A5 BA   
    JSR   $E33E              ; $F0DB: 20 3E E3 (KERNAL_LISTEN)
    BIT   $90                ; $F0DE: 24 90   
    BMI   $F0ED              ; $F0E0: 30 0B   
    LDA   $B9                ; $F0E2: A5 B9   
    ORA   #$F0               ; $F0E4: 09 F0   
    JSR   $E4D2              ; $F0E6: 20 D2 E4 (KERNAL_SECOND)
    LDA   $90                ; $F0E9: A5 90   
    BPL   $F0F2              ; $F0EB: 10 05   
    PLA                      ; $F0ED: 68      
    PLA                      ; $F0EE: 68      
    JMP   $F688              ; $F0EF: 4C 88 F6
    LDA   $B7                ; $F0F2: A5 B7   
    BEQ   $F103              ; $F0F4: F0 0D   
    LDY   #$00               ; $F0F6: A0 00   
    JSR   $F7AE              ; $F0F8: 20 AE F7
    JSR   $E503              ; $F0FB: 20 03 E5 (KERNAL_CIOUT)
    INY                      ; $F0FE: C8      
    CPY   $B7                ; $F0FF: C4 B7   
    BNE   $F0F8              ; $F101: D0 F5   
    JMP   $F5B0              ; $F103: 4C B0 F5
    JSR   $F202              ; $F106: 20 02 F2
    BNE   $F149              ; $F109: D0 3E   
    JSR   $F212              ; $F10B: 20 12 F2
    BEQ   $F123              ; $F10E: F0 13   
    CMP   #$03               ; $F110: C9 03   
    BEQ   $F123              ; $F112: F0 0F   
    BCS   $F127              ; $F114: B0 11   
    CMP   #$02               ; $F116: C9 02   
    BNE   $F11D              ; $F118: D0 03   
    JMP   $E795              ; $F11A: 4C 95 E7
    LDX   $B9                ; $F11D: A6 B9   
    CPX   #$60               ; $F11F: E0 60   
    BNE   $F143              ; $F121: D0 20   
    STA   $99                ; $F123: 85 99   
    CLC                      ; $F125: 18      
    RTS                      ; $F126: 60      
    TAX                      ; $F127: AA      
    JSR   $E33B              ; $F128: 20 3B E3 (KERNAL_TALK)
    BIT   $90                ; $F12B: 24 90   
    BMI   $F140              ; $F12D: 30 11   
    LDA   $B9                ; $F12F: A5 B9   
    BPL   $F138              ; $F131: 10 05   
    JSR   $E4E9              ; $F133: 20 E9 E4
    BPL   $F13B              ; $F136: 10 03   
    JSR   $E4E0              ; $F138: 20 E0 E4 (KERNAL_TKSA)
    TXA                      ; $F13B: 8A      
    BIT   $90                ; $F13C: 24 90   
    BPL   $F123              ; $F13E: 10 E3   
    JMP   $F688              ; $F140: 4C 88 F6
    JMP   $F68B              ; $F143: 4C 8B F6
    JMP   $F68E              ; $F146: 4C 8E F6
    JMP   $F682              ; $F149: 4C 82 F6
    JSR   $F202              ; $F14C: 20 02 F2
    BNE   $F149              ; $F14F: D0 F8   
    JSR   $F212              ; $F151: 20 12 F2
    BEQ   $F146              ; $F154: F0 F0   
    CMP   #$03               ; $F156: C9 03   
    BEQ   $F169              ; $F158: F0 0F   
    BCS   $F16D              ; $F15A: B0 11   
    CMP   #$02               ; $F15C: C9 02   
    BNE   $F163              ; $F15E: D0 03   
    JMP   $E729              ; $F160: 4C 29 E7
    LDX   $B9                ; $F163: A6 B9   
    CPX   #$60               ; $F165: E0 60   
    BEQ   $F146              ; $F167: F0 DD   
    STA   $9A                ; $F169: 85 9A   
    CLC                      ; $F16B: 18      
    RTS                      ; $F16C: 60      
    TAX                      ; $F16D: AA      
    JSR   $E33E              ; $F16E: 20 3E E3 (KERNAL_LISTEN)
    BIT   $90                ; $F171: 24 90   
    BMI   $F140              ; $F173: 30 CB   
    LDA   $B9                ; $F175: A5 B9   
    BPL   $F17E              ; $F177: 10 05   
    JSR   $E4D7              ; $F179: 20 D7 E4
    BNE   $F181              ; $F17C: D0 03   
    JSR   $E4D2              ; $F17E: 20 D2 E4 (KERNAL_SECOND)
    TXA                      ; $F181: 8A      
    BIT   $90                ; $F182: 24 90   
    BPL   $F169              ; $F184: 10 E3   
    BMI   $F140              ; $F186: 30 B8   
    ROR   $92                ; $F188: 66 92   
    JSR   $F207              ; $F18A: 20 07 F2
    BNE   $F16B              ; $F18D: D0 DC   
    JSR   $F212              ; $F18F: 20 12 F2
    TXA                      ; $F192: 8A      
    PHA                      ; $F193: 48      
    LDA   $BA                ; $F194: A5 BA   
    BEQ   $F1E4              ; $F196: F0 4C   
    CMP   #$03               ; $F198: C9 03   
    BEQ   $F1E4              ; $F19A: F0 48   
    BCS   $F1CF              ; $F19C: B0 31   
    CMP   #$02               ; $F19E: C9 02   
    BNE   $F1A9              ; $F1A0: D0 07   
    PLA                      ; $F1A2: 68      
    JSR   $F1E5              ; $F1A3: 20 E5 F1
    JMP   $F0B0              ; $F1A6: 4C B0 F0
    LDA   $B9                ; $F1A9: A5 B9   
    AND   #$0F               ; $F1AB: 29 0F   
    BEQ   $F1E4              ; $F1AD: F0 35   
    JSR   $E980              ; $F1AF: 20 80 E9
    LDA   #$00               ; $F1B2: A9 00   
    SEC                      ; $F1B4: 38      
    JSR   $EF8C              ; $F1B5: 20 8C EF
    JSR   $EA15              ; $F1B8: 20 15 EA
    BCC   $F1C1              ; $F1BB: 90 04   
    PLA                      ; $F1BD: 68      
    LDA   #$00               ; $F1BE: A9 00   
    RTS                      ; $F1C0: 60      
    LDA   $B9                ; $F1C1: A5 B9   
    CMP   #$62               ; $F1C3: C9 62   
    BNE   $F1E4              ; $F1C5: D0 1D   
    LDA   #$05               ; $F1C7: A9 05   
    JSR   $E919              ; $F1C9: 20 19 E9
    JMP   $F1E4              ; $F1CC: 4C E4 F1
    BIT   $92                ; $F1CF: 24 92   
    BPL   $F1E1              ; $F1D1: 10 0E   
    LDA   $BA                ; $F1D3: A5 BA   
    CMP   #$08               ; $F1D5: C9 08   
    BCC   $F1E1              ; $F1D7: 90 08   
    LDA   $B9                ; $F1D9: A5 B9   
    AND   #$0F               ; $F1DB: 29 0F   
    CMP   #$0F               ; $F1DD: C9 0F   
    BEQ   $F1E4              ; $F1DF: F0 03   
    JSR   $F59E              ; $F1E1: 20 9E F5
    PLA                      ; $F1E4: 68      
    TAX                      ; $F1E5: AA      
    DEC   $98                ; $F1E6: C6 98   
    CPX   $98                ; $F1E8: E4 98   
    BEQ   $F200              ; $F1EA: F0 14   
    LDY   $98                ; $F1EC: A4 98   
    LDA   $0362,Y            ; $F1EE: B9 62 03
    STA   $0362,X            ; $F1F1: 9D 62 03
    LDA   $036C,Y            ; $F1F4: B9 6C 03
    STA   $036C,X            ; $F1F7: 9D 6C 03
    LDA   $0376,Y            ; $F1FA: B9 76 03
    STA   $0376,X            ; $F1FD: 9D 76 03
    CLC                      ; $F200: 18      
    RTS                      ; $F201: 60      
    LDA   #$00               ; $F202: A9 00   
    STA   $90                ; $F204: 85 90   
    TXA                      ; $F206: 8A      
    LDX   $98                ; $F207: A6 98   
    DEX                      ; $F209: CA      
    BMI   $F211              ; $F20A: 30 05   
    CMP   $0362,X            ; $F20C: DD 62 03
    BNE   $F209              ; $F20F: D0 F8   
    RTS                      ; $F211: 60      
    LDA   $0362,X            ; $F212: BD 62 03
    STA   $B8                ; $F215: 85 B8   
    LDA   $0376,X            ; $F217: BD 76 03
    STA   $B9                ; $F21A: 85 B9   
    LDA   $036C,X            ; $F21C: BD 6C 03
    STA   $BA                ; $F21F: 85 BA   
    RTS                      ; $F221: 60      
    LDA   #$00               ; $F222: A9 00   
    STA   $98                ; $F224: 85 98   
    LDX   #$03               ; $F226: A2 03   
    CPX   $9A                ; $F228: E4 9A   
    BCS   $F22F              ; $F22A: B0 03   
    JSR   $E526              ; $F22C: 20 26 E5 (KERNAL_UNLSN)
    CPX   $99                ; $F22F: E4 99   
    BCS   $F236              ; $F231: B0 03   
    JSR   $E515              ; $F233: 20 15 E5 (KERNAL_UNTLK)
    STX   $9A                ; $F236: 86 9A   
    LDA   #$00               ; $F238: A9 00   
    STA   $99                ; $F23A: 85 99   
    RTS                      ; $F23C: 60      
KERNAL_CLOSE_ALL:
    STA   $BA                ; $F23D: 85 BA   
    CMP   $9A                ; $F23F: C5 9A   
    BNE   $F248              ; $F241: D0 05   
    LDA   #$03               ; $F243: A9 03   
    STA   $9A                ; $F245: 85 9A   
    BIT   $99C5              ; $F247: 2C C5 99
    BNE   $F250              ; $F24A: D0 04   
    LDA   #$00               ; $F24C: A9 00   
    STA   $99                ; $F24E: 85 99   
    LDA   $BA                ; $F250: A5 BA   
    LDX   $98                ; $F252: A6 98   
    DEX                      ; $F254: CA      
    BMI   $F264              ; $F255: 30 0D   
    CMP   $036C,X            ; $F257: DD 6C 03
    BNE   $F254              ; $F25A: D0 F8   
    LDA   $0362,X            ; $F25C: BD 62 03
    JSR   $FFC3              ; $F25F: 20 C3 FF (J_CLOSE)
    BCC   $F250              ; $F262: 90 EC   
    RTS                      ; $F264: 60      
KERNAL_LOAD:
    STX   $C3                ; $F265: 86 C3   
    STY   $C4                ; $F267: 84 C4   
    JMP   ($0330)            ; $F269: 6C 30 03 (ILOAD)
    STA   $93                ; $F26C: 85 93   
    LDA   #$00               ; $F26E: A9 00   
    STA   $90                ; $F270: 85 90   
    LDA   $BA                ; $F272: A5 BA   
    CMP   #$04               ; $F274: C9 04   
    BCS   $F27B              ; $F276: B0 03   
    JMP   $F326              ; $F278: 4C 26 F3
    LDA   $0A1C              ; $F27B: AD 1C 0A
    AND   #$BE               ; $F27E: 29 BE   
    STA   $0A1C              ; $F280: 8D 1C 0A
    LDX   $B9                ; $F283: A6 B9   
    STX   $9E                ; $F285: 86 9E   
    LDY   $B7                ; $F287: A4 B7   
    BNE   $F28E              ; $F289: D0 03   
    JMP   $F31A              ; $F28B: 4C 1A F3
    STY   $9F                ; $F28E: 84 9F   
    JSR   $F50F              ; $F290: 20 0F F5
    JSR   $F3A1              ; $F293: 20 A1 F3
    BCS   $F29B              ; $F296: B0 03   
    JMP   $F39B              ; $F298: 4C 9B F3
    LDY   $9F                ; $F29B: A4 9F   
    STY   $B7                ; $F29D: 84 B7   
    LDA   #$60               ; $F29F: A9 60   
    STA   $B9                ; $F2A1: 85 B9   
    JSR   $F0CB              ; $F2A3: 20 CB F0
    LDA   $BA                ; $F2A6: A5 BA   
    JSR   $E33B              ; $F2A8: 20 3B E3 (KERNAL_TALK)
    LDA   $B9                ; $F2AB: A5 B9   
    JSR   $E4E0              ; $F2AD: 20 E0 E4 (KERNAL_TKSA)
    JSR   $E43E              ; $F2B0: 20 3E E4 (KERNAL_ACPTR)
    STA   $AE                ; $F2B3: 85 AE   
    JSR   $E43E              ; $F2B5: 20 3E E4 (KERNAL_ACPTR)
    STA   $AF                ; $F2B8: 85 AF   
    LDA   $90                ; $F2BA: A5 90   
    LSR   A                  ; $F2BC: 4A      
    LSR   A                  ; $F2BD: 4A      
    BCS   $F317              ; $F2BE: B0 57   
    LDA   $9E                ; $F2C0: A5 9E   
    BNE   $F2CC              ; $F2C2: D0 08   
    LDA   $C3                ; $F2C4: A5 C3   
    STA   $AE                ; $F2C6: 85 AE   
    LDA   $C4                ; $F2C8: A5 C4   
    STA   $AF                ; $F2CA: 85 AF   
    JSR   $F533              ; $F2CC: 20 33 F5
    LDA   #$FD               ; $F2CF: A9 FD   
    AND   $90                ; $F2D1: 25 90   
    STA   $90                ; $F2D3: 85 90   
    JSR   $FFE1              ; $F2D5: 20 E1 FF (J_STOP)
    BEQ   $F323              ; $F2D8: F0 49   
    JSR   $E43E              ; $F2DA: 20 3E E4 (KERNAL_ACPTR)
    TAX                      ; $F2DD: AA      
    LDA   $90                ; $F2DE: A5 90   
    LSR   A                  ; $F2E0: 4A      
    LSR   A                  ; $F2E1: 4A      
    BCS   $F2CF              ; $F2E2: B0 EB   
    TXA                      ; $F2E4: 8A      
    LDY   $93                ; $F2E5: A4 93   
    BEQ   $F2FB              ; $F2E7: F0 12   
    STA   $BD                ; $F2E9: 85 BD   
    LDY   #$00               ; $F2EB: A0 00   
    JSR   $F7C9              ; $F2ED: 20 C9 F7
    CMP   $BD                ; $F2F0: C5 BD   
    BEQ   $F2FE              ; $F2F2: F0 0A   
    LDA   #$10               ; $F2F4: A9 10   
    JSR   $F757              ; $F2F6: 20 57 F7
    BNE   $F2FE              ; $F2F9: D0 03   
    JSR   $F7BF              ; $F2FB: 20 BF F7
    INC   $AE                ; $F2FE: E6 AE   
    BNE   $F30A              ; $F300: D0 08   
    INC   $AF                ; $F302: E6 AF   
    LDA   $AF                ; $F304: A5 AF   
    CMP   #$FF               ; $F306: C9 FF   
    BEQ   $F320              ; $F308: F0 16   
    BIT   $90                ; $F30A: 24 90   
    BVC   $F2CF              ; $F30C: 50 C1   
    JSR   $E515              ; $F30E: 20 15 E5 (KERNAL_UNTLK)
    JSR   $F59E              ; $F311: 20 9E F5
    JMP   $F39B              ; $F314: 4C 9B F3
    JMP   $F685              ; $F317: 4C 85 F6
    JMP   $F691              ; $F31A: 4C 91 F6
    JMP   $F694              ; $F31D: 4C 94 F6
    JMP   $F697              ; $F320: 4C 97 F6
    JMP   $F5B5              ; $F323: 4C B5 F5
    CMP   #$01               ; $F326: C9 01   
    BNE   $F31D              ; $F328: D0 F3   
    JSR   $E980              ; $F32A: 20 80 E9
    BCC   $F31D              ; $F32D: 90 EE   
    JSR   $E9C8              ; $F32F: 20 C8 E9
    BCS   $F3A0              ; $F332: B0 6C   
    JSR   $F50F              ; $F334: 20 0F F5
    LDA   $B7                ; $F337: A5 B7   
    BEQ   $F344              ; $F339: F0 09   
    JSR   $E99A              ; $F33B: 20 9A E9
    BCC   $F34B              ; $F33E: 90 0B   
    BEQ   $F3A0              ; $F340: F0 5E   
    BCS   $F317              ; $F342: B0 D3   
    JSR   $E8D0              ; $F344: 20 D0 E8
    BEQ   $F3A0              ; $F347: F0 57   
    BCS   $F317              ; $F349: B0 CC   
    SEC                      ; $F34B: 38      
    LDA   $90                ; $F34C: A5 90   
    AND   #$10               ; $F34E: 29 10   
    BNE   $F3A0              ; $F350: D0 4E   
    CPX   #$01               ; $F352: E0 01   
    BEQ   $F367              ; $F354: F0 11   
    CPX   #$03               ; $F356: E0 03   
    BNE   $F337              ; $F358: D0 DD   
    LDY   #$01               ; $F35A: A0 01   
    LDA   ($B2),Y            ; $F35C: B1 B2   
    STA   $C3                ; $F35E: 85 C3   
    INY                      ; $F360: C8      
    LDA   ($B2),Y            ; $F361: B1 B2   
    STA   $C4                ; $F363: 85 C4   
    BCS   $F36B              ; $F365: B0 04   
    LDA   $B9                ; $F367: A5 B9   
    BNE   $F35A              ; $F369: D0 EF   
    LDY   #$03               ; $F36B: A0 03   
    LDA   ($B2),Y            ; $F36D: B1 B2   
    LDY   #$01               ; $F36F: A0 01   
    SBC   ($B2),Y            ; $F371: F1 B2   
    TAX                      ; $F373: AA      
    LDY   #$04               ; $F374: A0 04   
    LDA   ($B2),Y            ; $F376: B1 B2   
    LDY   #$02               ; $F378: A0 02   
    SBC   ($B2),Y            ; $F37A: F1 B2   
    TAY                      ; $F37C: A8      
    CLC                      ; $F37D: 18      
    TXA                      ; $F37E: 8A      
    ADC   $C3                ; $F37F: 65 C3   
    STA   $AE                ; $F381: 85 AE   
    TYA                      ; $F383: 98      
    ADC   $C4                ; $F384: 65 C4   
    STA   $AF                ; $F386: 85 AF   
    CMP   #$FF               ; $F388: C9 FF   
    BEQ   $F320              ; $F38A: F0 94   
    LDA   $C3                ; $F38C: A5 C3   
    STA   $C1                ; $F38E: 85 C1   
    LDA   $C4                ; $F390: A5 C4   
    STA   $C2                ; $F392: 85 C2   
    JSR   $F533              ; $F394: 20 33 F5
    JSR   $E9FB              ; $F397: 20 FB E9
    BIT   $18                ; $F39A: 24 18   
    LDX   $AE                ; $F39C: A6 AE   
    LDY   $AF                ; $F39E: A4 AF   
    RTS                      ; $F3A0: 60      
    LDY   #$00               ; $F3A1: A0 00   
    JSR   $F7AE              ; $F3A3: 20 AE F7
    CMP   #$24               ; $F3A6: C9 24   
    BEQ   $F3A0              ; $F3A8: F0 F6   
    LDX   $BA                ; $F3AA: A6 BA   
    LDY   #$0F               ; $F3AC: A0 0F   
    LDA   #$00               ; $F3AE: A9 00   
    JSR   $F738              ; $F3B0: 20 38 F7 (KERNAL_SETLFS)
    STA   $B7                ; $F3B3: 85 B7   
    JSR   $FFC0              ; $F3B5: 20 C0 FF (J_OPEN)
    LDX   $B8                ; $F3B8: A6 B8   
    JSR   $FFC9              ; $F3BA: 20 C9 FF (J_CHKOUT)
    BCC   $F3C7              ; $F3BD: 90 08   
    JSR   $F48C              ; $F3BF: 20 8C F4
    PLA                      ; $F3C2: 68      
    PLA                      ; $F3C3: 68      
    JMP   $F688              ; $F3C4: 4C 88 F6
    LDY   #$03               ; $F3C7: A0 03   
    LDA   $F50B,Y            ; $F3C9: B9 0B F5
    JSR   $FFD2              ; $F3CC: 20 D2 FF (J_BSOUT)
    DEY                      ; $F3CF: 88      
    BNE   $F3C9              ; $F3D0: D0 F7   
    JSR   $F7AE              ; $F3D2: 20 AE F7
    JSR   $FFD2              ; $F3D5: 20 D2 FF (J_BSOUT)
    INY                      ; $F3D8: C8      
    CPY   $9F                ; $F3D9: C4 9F   
    BNE   $F3D2              ; $F3DB: D0 F5   
    JSR   $FFCC              ; $F3DD: 20 CC FF (J_CLRCH)
    BIT   $0A1C              ; $F3E0: 2C 1C 0A
    BVS   $F3EA              ; $F3E3: 70 05   
    JSR   $F48C              ; $F3E5: 20 8C F4
    SEC                      ; $F3E8: 38      
    RTS                      ; $F3E9: 60      
    LDA   $9F                ; $F3EA: A5 9F   
    STA   $B7                ; $F3EC: 85 B7   
    SEI                      ; $F3EE: 78      
    JSR   $E545              ; $F3EF: 20 45 E5
    JSR   $E5C3              ; $F3F2: 20 C3 E5
    BIT   $DC0D              ; $F3F5: 2C 0D DC (CIA1_ICR)
    JSR   $F503              ; $F3F8: 20 03 F5
    JSR   $F4BA              ; $F3FB: 20 BA F4
    CMP   #$02               ; $F3FE: C9 02   
    BNE   $F40A              ; $F400: D0 08   
    JSR   $F48C              ; $F402: 20 8C F4
    PLA                      ; $F405: 68      
    PLA                      ; $F406: 68      
    JMP   $F685              ; $F407: 4C 85 F6
    PHA                      ; $F40A: 48      
    CMP   #$1F               ; $F40B: C9 1F   
    BNE   $F41A              ; $F40D: D0 0B   
    JSR   $F503              ; $F40F: 20 03 F5
    JSR   $F4BA              ; $F412: 20 BA F4
    STA   $A5                ; $F415: 85 A5   
    JMP   $F421              ; $F417: 4C 21 F4
    CMP   #$02               ; $F41A: C9 02   
    BCC   $F421              ; $F41C: 90 03   
    PLA                      ; $F41E: 68      
    BCS   $F498              ; $F41F: B0 77   
    JSR   $F533              ; $F421: 20 33 F5
    JSR   $F503              ; $F424: 20 03 F5
    JSR   $F4BA              ; $F427: 20 BA F4
    STA   $AE                ; $F42A: 85 AE   
    JSR   $F503              ; $F42C: 20 03 F5
    JSR   $F4BA              ; $F42F: 20 BA F4
    STA   $AF                ; $F432: 85 AF   
    LDX   $9E                ; $F434: A6 9E   
    BNE   $F440              ; $F436: D0 08   
    LDA   $C3                ; $F438: A5 C3   
    LDX   $C4                ; $F43A: A6 C4   
    STA   $AE                ; $F43C: 85 AE   
    STX   $AF                ; $F43E: 86 AF   
    LDA   $AE                ; $F440: A5 AE   
    LDX   $AF                ; $F442: A6 AF   
    STA   $AC                ; $F444: 85 AC   
    STX   $AD                ; $F446: 86 AD   
    PLA                      ; $F448: 68      
    CMP   #$1F               ; $F449: C9 1F   
    BEQ   $F47F              ; $F44B: F0 32   
    JSR   $F503              ; $F44D: 20 03 F5
    LDA   #$FC               ; $F450: A9 FC   
    STA   $A5                ; $F452: 85 A5   
    JSR   $F63D              ; $F454: 20 3D F6
    JSR   $FFE1              ; $F457: 20 E1 FF (J_STOP)
    BEQ   $F4A6              ; $F45A: F0 4A   
    JSR   $F4C5              ; $F45C: 20 C5 F4
    BCS   $F4B2              ; $F45F: B0 51   
    JSR   $F4BA              ; $F461: 20 BA F4
    CMP   #$02               ; $F464: C9 02   
    BCC   $F46E              ; $F466: 90 06   
    CMP   #$1F               ; $F468: C9 1F   
    BEQ   $F477              ; $F46A: F0 0B   
    BNE   $F498              ; $F46C: D0 2A   
    JSR   $F503              ; $F46E: 20 03 F5
    LDA   #$FE               ; $F471: A9 FE   
    STA   $A5                ; $F473: 85 A5   
    BNE   $F454              ; $F475: D0 DD   
    JSR   $F503              ; $F477: 20 03 F5
    JSR   $F4BA              ; $F47A: 20 BA F4
    STA   $A5                ; $F47D: 85 A5   
    JSR   $F503              ; $F47F: 20 03 F5
    JSR   $F4C5              ; $F482: 20 C5 F4
    BCS   $F4B2              ; $F485: B0 2B   
    LDA   #$40               ; $F487: A9 40   
    JSR   $F757              ; $F489: 20 57 F7
    JSR   $E545              ; $F48C: 20 45 E5
    CLI                      ; $F48F: 58      
    LDA   $B8                ; $F490: A5 B8   
    SEC                      ; $F492: 38      
    JSR   $FFC3              ; $F493: 20 C3 FF (J_CLOSE)
    CLC                      ; $F496: 18      
    RTS                      ; $F497: 60      
    LDA   #$02               ; $F498: A9 02   
    JSR   $F757              ; $F49A: 20 57 F7
    JSR   $F48C              ; $F49D: 20 8C F4
    PLA                      ; $F4A0: 68      
    PLA                      ; $F4A1: 68      
    LDA   #$29               ; $F4A2: A9 29   
    SEC                      ; $F4A4: 38      
    RTS                      ; $F4A5: 60      
    JSR   $F48C              ; $F4A6: 20 8C F4
    LDA   #$00               ; $F4A9: A9 00   
    STA   $B9                ; $F4AB: 85 B9   
    PLA                      ; $F4AD: 68      
    PLA                      ; $F4AE: 68      
    JMP   $F5B5              ; $F4AF: 4C B5 F5
    JSR   $F48C              ; $F4B2: 20 8C F4
    PLA                      ; $F4B5: 68      
    PLA                      ; $F4B6: 68      
    JMP   $F697              ; $F4B7: 4C 97 F6
    LDA   #$08               ; $F4BA: A9 08   
    BIT   $DC0D              ; $F4BC: 2C 0D DC (CIA1_ICR)
    BEQ   $F4BC              ; $F4BF: F0 FB   
    LDA   $DC0C              ; $F4C1: AD 0C DC
    RTS                      ; $F4C4: 60      
    LDA   #$08               ; $F4C5: A9 08   
    BIT   $DC0D              ; $F4C7: 2C 0D DC (CIA1_ICR)
    BEQ   $F4C7              ; $F4CA: F0 FB   
    LDY   $DC0C              ; $F4CC: AC 0C DC
    LDA   $DD00              ; $F4CF: AD 00 DD (CIA2_PRA)
    EOR   #$10               ; $F4D2: 49 10   
    STA   $DD00              ; $F4D4: 8D 00 DD (CIA2_PRA)
    TYA                      ; $F4D7: 98      
    LDY   $93                ; $F4D8: A4 93   
    BEQ   $F4EE              ; $F4DA: F0 12   
    STA   $BD                ; $F4DC: 85 BD   
    LDY   #$00               ; $F4DE: A0 00   
    JSR   $F7C9              ; $F4E0: 20 C9 F7
    CMP   $BD                ; $F4E3: C5 BD   
    BEQ   $F4F1              ; $F4E5: F0 0A   
    LDA   #$10               ; $F4E7: A9 10   
    JSR   $F757              ; $F4E9: 20 57 F7
    BNE   $F4F1              ; $F4EC: D0 03   
    JSR   $F7BF              ; $F4EE: 20 BF F7
    INC   $AE                ; $F4F1: E6 AE   
    BNE   $F4FD              ; $F4F3: D0 08   
    INC   $AF                ; $F4F5: E6 AF   
    LDA   $AF                ; $F4F7: A5 AF   
    CMP   #$FF               ; $F4F9: C9 FF   
    BEQ   $F502              ; $F4FB: F0 05   
    DEC   $A5                ; $F4FD: C6 A5   
    BNE   $F4C5              ; $F4FF: D0 C4   
    CLC                      ; $F501: 18      
    RTS                      ; $F502: 60      
    LDA   $DD00              ; $F503: AD 00 DD (CIA2_PRA)
    EOR   #$10               ; $F506: 49 10   
    STA   $DD00              ; $F508: 8D 00 DD (CIA2_PRA)
    RTS                      ; $F50B: 60      
    .BYTE $1F                                ; $F50C: 1F [UNRESOLVED]
    BMI   $F564              ; $F50D: 30 55   
    LDA   $9D                ; $F50F: A5 9D   
    BPL   $F532              ; $F511: 10 1F   
    LDY   #$0C               ; $F513: A0 0C   
    JSR   $F722              ; $F515: 20 22 F7
    LDA   $B7                ; $F518: A5 B7   
    BEQ   $F532              ; $F51A: F0 16   
    LDY   #$17               ; $F51C: A0 17   
    JSR   $F722              ; $F51E: 20 22 F7
    LDY   $B7                ; $F521: A4 B7   
    BEQ   $F532              ; $F523: F0 0D   
    LDY   #$00               ; $F525: A0 00   
    JSR   $F7AE              ; $F527: 20 AE F7
    JSR   $FFD2              ; $F52A: 20 D2 FF (J_BSOUT)
    INY                      ; $F52D: C8      
    CPY   $B7                ; $F52E: C4 B7   
    BNE   $F527              ; $F530: D0 F5   
    RTS                      ; $F532: 60      
    LDY   #$49               ; $F533: A0 49   
    LDA   $93                ; $F535: A5 93   
    BEQ   $F53B              ; $F537: F0 02   
    LDY   #$59               ; $F539: A0 59   
    JMP   $F71E              ; $F53B: 4C 1E F7
KERNAL_SAVE:
    STX   $AE                ; $F53E: 86 AE   
    STY   $AF                ; $F540: 84 AF   
    TAX                      ; $F542: AA      
    LDA   $00,X              ; $F543: B5 00   
    STA   $C1                ; $F545: 85 C1   
    LDA   $01,X              ; $F547: B5 01   
    STA   $C2                ; $F549: 85 C2   
    JMP   ($0332)            ; $F54B: 6C 32 03 (ISAVE)
    LDA   $BA                ; $F54E: A5 BA   
    CMP   #$01               ; $F550: C9 01   
    BEQ   $F5C8              ; $F552: F0 74   
    CMP   #$04               ; $F554: C9 04   
    BCS   $F561              ; $F556: B0 09   
    JMP   $F694              ; $F558: 4C 94 F6
    JMP   $F691              ; $F55B: 4C 91 F6
    JMP   $F685              ; $F55E: 4C 85 F6
    LDY   $B7                ; $F561: A4 B7   
    BEQ   $F55B              ; $F563: F0 F6   
    LDA   #$61               ; $F565: A9 61   
    STA   $B9                ; $F567: 85 B9   
    JSR   $F0CB              ; $F569: 20 CB F0
    JSR   $F5BC              ; $F56C: 20 BC F5
    LDA   $BA                ; $F56F: A5 BA   
    JSR   $E33E              ; $F571: 20 3E E3 (KERNAL_LISTEN)
    LDA   $B9                ; $F574: A5 B9   
    JSR   $E4D2              ; $F576: 20 D2 E4 (KERNAL_SECOND)
    LDY   #$00               ; $F579: A0 00   
    JSR   $ED51              ; $F57B: 20 51 ED
    JSR   $E503              ; $F57E: 20 03 E5 (KERNAL_CIOUT)
    LDA   $AD                ; $F581: A5 AD   
    JSR   $E503              ; $F583: 20 03 E5 (KERNAL_CIOUT)
    JSR   $EEB7              ; $F586: 20 B7 EE
    BCS   $F59B              ; $F589: B0 10   
    JSR   $F7CC              ; $F58B: 20 CC F7
    JSR   $E503              ; $F58E: 20 03 E5 (KERNAL_CIOUT)
    JSR   $FFE1              ; $F591: 20 E1 FF (J_STOP)
    BEQ   $F5B5              ; $F594: F0 1F   
    JSR   $EEC1              ; $F596: 20 C1 EE
    BNE   $F586              ; $F599: D0 EB   
    JSR   $E526              ; $F59B: 20 26 E5 (KERNAL_UNLSN)
    BIT   $B9                ; $F59E: 24 B9   
    BMI   $F5B3              ; $F5A0: 30 11   
    LDA   $BA                ; $F5A2: A5 BA   
    JSR   $E33E              ; $F5A4: 20 3E E3 (KERNAL_LISTEN)
    LDA   $B9                ; $F5A7: A5 B9   
    AND   #$EF               ; $F5A9: 29 EF   
    ORA   #$E0               ; $F5AB: 09 E0   
    JSR   $E4D2              ; $F5AD: 20 D2 E4 (KERNAL_SECOND)
    JSR   $E526              ; $F5B0: 20 26 E5 (KERNAL_UNLSN)
    CLC                      ; $F5B3: 18      
    RTS                      ; $F5B4: 60      
    JSR   $F59E              ; $F5B5: 20 9E F5
    LDA   #$00               ; $F5B8: A9 00   
    SEC                      ; $F5BA: 38      
    RTS                      ; $F5BB: 60      
    LDA   $9D                ; $F5BC: A5 9D   
    BPL   $F5F7              ; $F5BE: 10 37   
    LDY   #$51               ; $F5C0: A0 51   
    JSR   $F722              ; $F5C2: 20 22 F7
    JMP   $F521              ; $F5C5: 4C 21 F5
    JSR   $E980              ; $F5C8: 20 80 E9
    BCC   $F558              ; $F5CB: 90 8B   
    JSR   $E9E9              ; $F5CD: 20 E9 E9
    BCS   $F5F7              ; $F5D0: B0 25   
    JSR   $F5BC              ; $F5D2: 20 BC F5
    LDX   #$03               ; $F5D5: A2 03   
    LDA   $B9                ; $F5D7: A5 B9   
    AND   #$01               ; $F5D9: 29 01   
    BNE   $F5DF              ; $F5DB: D0 02   
    LDX   #$01               ; $F5DD: A2 01   
    TXA                      ; $F5DF: 8A      
    JSR   $E919              ; $F5E0: 20 19 E9
    BCS   $F5F7              ; $F5E3: B0 12   
    JSR   $EA18              ; $F5E5: 20 18 EA
    BCS   $F5F7              ; $F5E8: B0 0D   
    LDA   $B9                ; $F5EA: A5 B9   
    AND   #$02               ; $F5EC: 29 02   
    BEQ   $F5F6              ; $F5EE: F0 06   
    LDA   #$05               ; $F5F0: A9 05   
    JSR   $E919              ; $F5F2: 20 19 E9
    BIT   $18                ; $F5F5: 24 18   
    RTS                      ; $F5F7: 60      
KERNAL_UDTIM:
    INC   $A2                ; $F5F8: E6 A2   
    BNE   $F602              ; $F5FA: D0 06   
    INC   $A1                ; $F5FC: E6 A1   
    BNE   $F602              ; $F5FE: D0 02   
    INC   $A0                ; $F600: E6 A0   
    SEC                      ; $F602: 38      
    LDA   $A2                ; $F603: A5 A2   
    SBC   #$01               ; $F605: E9 01   
    LDA   $A1                ; $F607: A5 A1   
    SBC   #$1A               ; $F609: E9 1A   
    LDA   $A0                ; $F60B: A5 A0   
    SBC   #$4F               ; $F60D: E9 4F   
    BCC   $F619              ; $F60F: 90 08   
    LDX   #$00               ; $F611: A2 00   
    STX   $A0                ; $F613: 86 A0   
    STX   $A1                ; $F615: 86 A1   
    STX   $A2                ; $F617: 86 A2   
    LDA   $0A1D              ; $F619: AD 1D 0A
    BNE   $F629              ; $F61C: D0 0B   
    LDA   $0A1E              ; $F61E: AD 1E 0A
    BNE   $F626              ; $F621: D0 03   
    DEC   $0A1F              ; $F623: CE 1F 0A
    DEC   $0A1E              ; $F626: CE 1E 0A
    DEC   $0A1D              ; $F629: CE 1D 0A
    BIT   $0A03              ; $F62C: 2C 03 0A
    BPL   $F63D              ; $F62F: 10 0C   
    DEC   $0A36              ; $F631: CE 36 0A
    BPL   $F63D              ; $F634: 10 07   
    LDA   #$05               ; $F636: A9 05   
    STA   $0A36              ; $F638: 8D 36 0A
    BNE   $F5F8              ; $F63B: D0 BB    (KERNAL_UDTIM)
    LDA   $DC01              ; $F63D: AD 01 DC (CIA1_PRB)
    CMP   $DC01              ; $F640: CD 01 DC (CIA1_PRB)
    BNE   $F63D              ; $F643: D0 F8   
    TAX                      ; $F645: AA      
    BMI   $F65B              ; $F646: 30 13   
    LDX   #$BD               ; $F648: A2 BD   
    STX   $DC00              ; $F64A: 8E 00 DC (CIA1_PRA)
    LDX   $DC01              ; $F64D: AE 01 DC (CIA1_PRB)
    CPX   $DC01              ; $F650: EC 01 DC (CIA1_PRB)
    BNE   $F64D              ; $F653: D0 F8   
    STA   $DC00              ; $F655: 8D 00 DC (CIA1_PRA)
    INX                      ; $F658: E8      
    BNE   $F65D              ; $F659: D0 02   
    STA   $91                ; $F65B: 85 91   
    RTS                      ; $F65D: 60      
KERNAL_RDTIM:
    SEI                      ; $F65E: 78      
    LDA   $A2                ; $F65F: A5 A2   
    LDX   $A1                ; $F661: A6 A1   
    LDY   $A0                ; $F663: A4 A0   
KERNAL_SETTIM:
    SEI                      ; $F665: 78      
    STA   $A2                ; $F666: 85 A2   
    STX   $A1                ; $F668: 86 A1   
    STY   $A0                ; $F66A: 84 A0   
    CLI                      ; $F66C: 58      
    RTS                      ; $F66D: 60      
    LDA   $91                ; $F66E: A5 91   
    CMP   #$7F               ; $F670: C9 7F   
    BNE   $F67B              ; $F672: D0 07   
    PHP                      ; $F674: 08      
    JSR   $FFCC              ; $F675: 20 CC FF (J_CLRCH)
    STA   $D0                ; $F678: 85 D0   
    PLP                      ; $F67A: 28      
    RTS                      ; $F67B: 60      
    LDA   #$01               ; $F67C: A9 01   
    BIT   $02A9              ; $F67E: 2C A9 02
    BIT   $03A9              ; $F681: 2C A9 03
    BIT   $04A9              ; $F684: 2C A9 04
    BIT   $05A9              ; $F687: 2C A9 05
    BIT   $06A9              ; $F68A: 2C A9 06
    BIT   $07A9              ; $F68D: 2C A9 07
    BIT   $08A9              ; $F690: 2C A9 08
    BIT   $09A9              ; $F693: 2C A9 09
    BIT   $10A9              ; $F696: 2C A9 10
    PHA                      ; $F699: 48      
    JSR   $FFCC              ; $F69A: 20 CC FF (J_CLRCH)
    LDY   #$00               ; $F69D: A0 00   
    BIT   $9D                ; $F69F: 24 9D   
    BVC   $F6AD              ; $F6A1: 50 0A   
    JSR   $F722              ; $F6A3: 20 22 F7
    PLA                      ; $F6A6: 68      
    PHA                      ; $F6A7: 48      
    ORA   #$30               ; $F6A8: 09 30   
    JSR   $FFD2              ; $F6AA: 20 D2 FF (J_BSOUT)
; --- [DATA] KERNAL Direct I/O Status Messages ('SEARCHING', 'LOADING', 'READY.') ($F6AD-$F718) ---
    .BYTE $68, $38, $60, $0D, $49, $2F, $4F, $20 ; $F6AD [IDENTIFIED_DATA] |h8`.I/O |
    .BYTE $45, $52, $52, $4F, $52, $20, $A3, $0D ; $F6B5 [IDENTIFIED_DATA] |ERROR ..|
    .BYTE $53, $45, $41, $52, $43, $48, $49, $4E ; $F6BD [IDENTIFIED_DATA] |SEARCHIN|
    .BYTE $47, $A0, $46, $4F, $52, $A0, $0D, $50 ; $F6C5 [IDENTIFIED_DATA] |G.FOR..P|
    .BYTE $52, $45, $53, $53, $20, $50, $4C, $41 ; $F6CD [IDENTIFIED_DATA] |RESS PLA|
    .BYTE $59, $20, $4F, $4E, $20, $54, $41, $50 ; $F6D5 [IDENTIFIED_DATA] |Y ON TAP|
    .BYTE $C5, $50, $52, $45, $53, $53, $20, $52 ; $F6DD [IDENTIFIED_DATA] |.PRESS R|
    .BYTE $45, $43, $4F, $52, $44, $20, $26, $20 ; $F6E5 [IDENTIFIED_DATA] |ECORD & |
    .BYTE $50, $4C, $41, $59, $20, $4F, $4E, $20 ; $F6ED [IDENTIFIED_DATA] |PLAY ON |
    .BYTE $54, $41, $50, $C5, $0D, $4C, $4F, $41 ; $F6F5 [IDENTIFIED_DATA] |TAP..LOA|
    .BYTE $44, $49, $4E, $C7, $0D, $53, $41, $56 ; $F6FD [IDENTIFIED_DATA] |DIN..SAV|
    .BYTE $49, $4E, $47, $A0, $0D, $56, $45, $52 ; $F705 [IDENTIFIED_DATA] |ING..VER|
    .BYTE $49, $46, $59, $49, $4E, $C7, $0D, $46 ; $F70D [IDENTIFIED_DATA] |IFYIN..F|
    .BYTE $4F, $55, $4E, $44                     ; $F715 [IDENTIFIED_DATA] |OUND|
    LDY   #$0D               ; $F719: A0 0D   
    .BYTE $4F                                ; $F71B: 4F [UNRESOLVED]
    .BYTE $4B                                ; $F71C: 4B [UNRESOLVED]
    STA   $9D24              ; $F71D: 8D 24 9D
    BPL   $F72F              ; $F720: 10 0D   
    LDA   $F6B0,Y            ; $F722: B9 B0 F6
    PHP                      ; $F725: 08      
    AND   #$7F               ; $F726: 29 7F   
    JSR   $FFD2              ; $F728: 20 D2 FF (J_BSOUT)
    INY                      ; $F72B: C8      
    PLP                      ; $F72C: 28      
    BPL   $F722              ; $F72D: 10 F3   
    CLC                      ; $F72F: 18      
    RTS                      ; $F730: 60      
KERNAL_SETNAM:
    STA   $B7                ; $F731: 85 B7   
    STX   $BB                ; $F733: 86 BB   
    STY   $BC                ; $F735: 84 BC   
    RTS                      ; $F737: 60      
KERNAL_SETLFS:
    STA   $B8                ; $F738: 85 B8   
    STX   $BA                ; $F73A: 86 BA   
    STY   $B9                ; $F73C: 84 B9   
    RTS                      ; $F73E: 60      
KERNAL_SETBNK:
    STA   $C6                ; $F73F: 85 C6   
    STX   $C7                ; $F741: 86 C7   
    RTS                      ; $F743: 60      
KERNAL_READST:
    LDA   $BA                ; $F744: A5 BA   
    CMP   #$02               ; $F746: C9 02   
    BNE   $F755              ; $F748: D0 0B   
    LDA   $0A14              ; $F74A: AD 14 0A
    PHA                      ; $F74D: 48      
    LDA   #$00               ; $F74E: A9 00   
    STA   $0A14              ; $F750: 8D 14 0A
    PLA                      ; $F753: 68      
    RTS                      ; $F754: 60      
    LDA   $90                ; $F755: A5 90   
    ORA   $90                ; $F757: 05 90   
    STA   $90                ; $F759: 85 90   
    RTS                      ; $F75B: 60      
KERNAL_SETMSG:
    STA   $9D                ; $F75C: 85 9D   
    RTS                      ; $F75E: 60      
KERNAL_SETTMO:
    STA   $0A0E              ; $F75F: 8D 0E 0A
    RTS                      ; $F762: 60      
KERNAL_MEMTOP:
    BCC   $F76B              ; $F763: 90 06   
    LDX   $0A07              ; $F765: AE 07 0A
    LDY   $0A08              ; $F768: AC 08 0A
    STX   $0A07              ; $F76B: 8E 07 0A
    STY   $0A08              ; $F76E: 8C 08 0A
    RTS                      ; $F771: 60      
KERNAL_MEMBOT:
    BCC   $F77A              ; $F772: 90 06   
    LDX   $0A05              ; $F774: AE 05 0A
    LDY   $0A06              ; $F777: AC 06 0A
    STX   $0A05              ; $F77A: 8E 05 0A
    STY   $0A06              ; $F77D: 8C 06 0A
    RTS                      ; $F780: 60      
KERNAL_IOBASE:
    LDX   #$00               ; $F781: A2 00   
    LDY   #$D0               ; $F783: A0 D0   
    RTS                      ; $F785: 60      
KERNAL_LKUPSA:
    TYA                      ; $F786: 98      
    LDX   $98                ; $F787: A6 98   
    DEX                      ; $F789: CA      
    BMI   $F79B              ; $F78A: 30 0F   
    CMP   $0376,X            ; $F78C: DD 76 03
    BNE   $F789              ; $F78F: D0 F8   
    JSR   $F212              ; $F791: 20 12 F2
    TAX                      ; $F794: AA      
    LDA   $B8                ; $F795: A5 B8   
    LDY   $B9                ; $F797: A4 B9   
    CLC                      ; $F799: 18      
    RTS                      ; $F79A: 60      
    SEC                      ; $F79B: 38      
    RTS                      ; $F79C: 60      
KERNAL_LKUPLA:
    TAX                      ; $F79D: AA      
    JSR   $F202              ; $F79E: 20 02 F2
    BEQ   $F791              ; $F7A1: F0 EE   
    BNE   $F79B              ; $F7A3: D0 F6   
KERNAL_DMA_CALL:
    LDA   $F7F0,X            ; $F7A5: BD F0 F7
    AND   #$FE               ; $F7A8: 29 FE   
    TAX                      ; $F7AA: AA      
    JMP   $03F0              ; $F7AB: 4C F0 03
    STX   $0A35              ; $F7AE: 8E 35 0A
    LDX   $C7                ; $F7B1: A6 C7   
    LDA   #$BB               ; $F7B3: A9 BB   
    JSR   $F7D0              ; $F7B5: 20 D0 F7 (KERNAL_INDFET)
    LDX   $0A35              ; $F7B8: AE 35 0A
    RTS                      ; $F7BB: 60      
    LDX   #$AC               ; $F7BC: A2 AC   
    BIT   $AEA2              ; $F7BE: 2C A2 AE
    STX   $02B9              ; $F7C1: 8E B9 02
    LDX   $C6                ; $F7C4: A6 C6   
    JMP   $F7DA              ; $F7C6: 4C DA F7 (KERNAL_INDSTA)
    LDA   #$AE               ; $F7C9: A9 AE   
    BIT   $ACA9              ; $F7CB: 2C A9 AC
    LDX   $C6                ; $F7CE: A6 C6   
KERNAL_INDFET:
    STA   $02AA              ; $F7D0: 8D AA 02
    LDA   $F7F0,X            ; $F7D3: BD F0 F7
    TAX                      ; $F7D6: AA      
    JMP   $02A2              ; $F7D7: 4C A2 02
KERNAL_INDSTA:
    PHA                      ; $F7DA: 48      
    LDA   $F7F0,X            ; $F7DB: BD F0 F7
    TAX                      ; $F7DE: AA      
    PLA                      ; $F7DF: 68      
    JMP   $02AF              ; $F7E0: 4C AF 02
KERNAL_INDCMP:
    PHA                      ; $F7E3: 48      
    LDA   $F7F0,X            ; $F7E4: BD F0 F7
    TAX                      ; $F7E7: AA      
    PLA                      ; $F7E8: 68      
    JMP   $02BE              ; $F7E9: 4C BE 02
KERNAL_GETCFG:
    LDA   $F7F0,X            ; $F7EC: BD F0 F7
    RTS                      ; $F7EF: 60      
; --- [DATA] KERNAL GETCFG Logical Bank (0-15) to MMU CR Translation Table ($F7F0-$F7FF) ---
    .BYTE $3F, $7F, $BF, $FF, $16, $56, $96, $D6 ; $F7F0 [IDENTIFIED_DATA] |?....V..|
    .BYTE $2A, $6A, $AA, $EA, $06, $0A, $01, $00 ; $F7F8 [IDENTIFIED_DATA] |*j......|
    LDA   $FF00              ; $F800: AD 00 FF (MMU_CR_TOP)
    STX   $FF00              ; $F803: 8E 00 FF (MMU_CR_TOP)
    TAX                      ; $F806: AA      
    LDA   ($FF),Y            ; $F807: B1 FF   
    STX   $FF00              ; $F809: 8E 00 FF (MMU_CR_TOP)
    RTS                      ; $F80C: 60      
    PHA                      ; $F80D: 48      
    LDA   $FF00              ; $F80E: AD 00 FF (MMU_CR_TOP)
    STX   $FF00              ; $F811: 8E 00 FF (MMU_CR_TOP)
    TAX                      ; $F814: AA      
    PLA                      ; $F815: 68      
    STA   ($FF),Y            ; $F816: 91 FF   
    STX   $FF00              ; $F818: 8E 00 FF (MMU_CR_TOP)
    RTS                      ; $F81B: 60      
    PHA                      ; $F81C: 48      
    LDA   $FF00              ; $F81D: AD 00 FF (MMU_CR_TOP)
    STX   $FF00              ; $F820: 8E 00 FF (MMU_CR_TOP)
    TAX                      ; $F823: AA      
    PLA                      ; $F824: 68      
    CMP   ($FF),Y            ; $F825: D1 FF   
    STX   $FF00              ; $F827: 8E 00 FF (MMU_CR_TOP)
    RTS                      ; $F82A: 60      
    JSR   $02E3              ; $F82B: 20 E3 02
    STA   $06                ; $F82E: 85 06   
    STX   $07                ; $F830: 86 07   
    STY   $08                ; $F832: 84 08   
    PHP                      ; $F834: 08      
    PLA                      ; $F835: 68      
    STA   $05                ; $F836: 85 05   
    TSX                      ; $F838: BA      
    STX   $09                ; $F839: 86 09   
    LDA   #$00               ; $F83B: A9 00   
    STA   $FF00              ; $F83D: 8D 00 FF (MMU_CR_TOP)
    RTS                      ; $F840: 60      
    LDX   #$00               ; $F841: A2 00   
    LDA   $03,X              ; $F843: B5 03   
    PHA                      ; $F845: 48      
    INX                      ; $F846: E8      
    CPX   #$03               ; $F847: E0 03   
    BCC   $F843              ; $F849: 90 F8   
    LDX   $02                ; $F84B: A6 02   
    JSR   $FF6B              ; $F84D: 20 6B FF (J_GETCFG)
    STA   $FF00              ; $F850: 8D 00 FF (MMU_CR_TOP)
    LDA   $06                ; $F853: A5 06   
    LDX   $07                ; $F855: A6 07   
    LDY   $08                ; $F857: A4 08   
    RTI                      ; $F859: 40      
    LDX   $FF00              ; $F85A: AE 00 FF (MMU_CR_TOP)
    STY   $DF01              ; $F85D: 8C 01 DF
    STA   $FF00              ; $F860: 8D 00 FF (MMU_CR_TOP)
    STX   $FF00              ; $F863: 8E 00 FF (MMU_CR_TOP)
    RTS                      ; $F866: 60      
KERNAL_PHOENIX:
    SEI                      ; $F867: 78      
    LDX   #$03               ; $F868: A2 03   
    STX   $0AC0              ; $F86A: 8E C0 0A
    LDX   $0AC0              ; $F86D: AE C0 0A
    LDA   $0AC1,X            ; $F870: BD C1 0A
    BEQ   $F886              ; $F873: F0 11   
    LDY   #$00               ; $F875: A0 00   
    LDA   $E2BC,X            ; $F877: BD BC E2
    STA   $03                ; $F87A: 85 03   
    STY   $04                ; $F87C: 84 04   
    LDA   $E2C0,X            ; $F87E: BD C0 E2
    STA   $02                ; $F881: 85 02   
    JSR   $02CD              ; $F883: 20 CD 02
    DEC   $0AC0              ; $F886: CE C0 0A
    BPL   $F86D              ; $F889: 10 E2   
    CLI                      ; $F88B: 58      
    LDX   #$08               ; $F88C: A2 08   
    LDA   #$30               ; $F88E: A9 30   
KERNAL_BOOT_CALL:
    STA   $BF                ; $F890: 85 BF   
    STX   $BA                ; $F892: 86 BA   
    TXA                      ; $F894: 8A      
    JSR   $F23D              ; $F895: 20 3D F2 (KERNAL_CLOSE_ALL)
    LDX   #$00               ; $F898: A2 00   
    STX   $9F                ; $F89A: 86 9F   
    STX   $C2                ; $F89C: 86 C2   
    INX                      ; $F89E: E8      
    STX   $C1                ; $F89F: 86 C1   
    INY                      ; $F8A1: C8      
    BNE   $F8A1              ; $F8A2: D0 FD   
    INX                      ; $F8A4: E8      
    BNE   $F8A1              ; $F8A5: D0 FA   
    LDX   #$0C               ; $F8A7: A2 0C   
    LDA   $FA08,X            ; $F8A9: BD 08 FA
    STA   $0100,X            ; $F8AC: 9D 00 01
    DEX                      ; $F8AF: CA      
    BPL   $F8A9              ; $F8B0: 10 F7   
    LDA   $BF                ; $F8B2: A5 BF   
    STA   $0106              ; $F8B4: 8D 06 01
    LDA   #$00               ; $F8B7: A9 00   
    LDX   #$0F               ; $F8B9: A2 0F   
    JSR   $F73F              ; $F8BB: 20 3F F7 (KERNAL_SETBNK)
    LDA   #$01               ; $F8BE: A9 01   
    LDX   #$15               ; $F8C0: A2 15   
    LDY   #$FA               ; $F8C2: A0 FA   
    JSR   $F731              ; $F8C4: 20 31 F7 (KERNAL_SETNAM)
    LDA   #$00               ; $F8C7: A9 00   
    LDY   #$0F               ; $F8C9: A0 0F   
    LDX   $BA                ; $F8CB: A6 BA   
    JSR   $F738              ; $F8CD: 20 38 F7 (KERNAL_SETLFS)
    JSR   $FFC0              ; $F8D0: 20 C0 FF (J_OPEN)
    BCS   $F8EB              ; $F8D3: B0 16   
    LDA   #$01               ; $F8D5: A9 01   
    LDX   #$16               ; $F8D7: A2 16   
    LDY   #$FA               ; $F8D9: A0 FA   
    JSR   $F731              ; $F8DB: 20 31 F7 (KERNAL_SETNAM)
    LDA   #$0D               ; $F8DE: A9 0D   
    TAY                      ; $F8E0: A8      
    LDX   $BA                ; $F8E1: A6 BA   
    JSR   $F738              ; $F8E3: 20 38 F7 (KERNAL_SETLFS)
    JSR   $FFC0              ; $F8E6: 20 C0 FF (J_OPEN)
    BCC   $F8EE              ; $F8E9: 90 03   
    JMP   $F98B              ; $F8EB: 4C 8B F9
    LDA   #$00               ; $F8EE: A9 00   
    LDY   #$0B               ; $F8F0: A0 0B   
    STA   $AC                ; $F8F2: 85 AC   
    STY   $AD                ; $F8F4: 84 AD   
    JSR   $F9D5              ; $F8F6: 20 D5 F9
    LDX   #$00               ; $F8F9: A2 00   
    LDA   $0B00,X            ; $F8FB: BD 00 0B
    CMP   $E2C4,X            ; $F8FE: DD C4 E2
    BNE   $F8EB              ; $F901: D0 E8   
    INX                      ; $F903: E8      
    CPX   #$03               ; $F904: E0 03   
    BCC   $F8FB              ; $F906: 90 F3   
    JSR   $FA17              ; $F908: 20 17 FA (KERNAL_PRIMM)
    ORA   $4F42              ; $F90B: 0D 42 4F
    .BYTE $4F                                ; $F90E: 4F [UNRESOLVED]
    .BYTE $54                                ; $F90F: 54 [UNRESOLVED]
    EOR   #$4E               ; $F910: 49 4E   
    .BYTE $47                                ; $F912: 47 [UNRESOLVED]
    JSR   $BD00              ; $F913: 20 00 BD
    BRK                      ; $F916: 00      
    .BYTE $0B                                ; $F917: 0B [UNRESOLVED]
    STA   $A9,X              ; $F918: 95 A9   
    INX                      ; $F91A: E8      
    CPX   #$07               ; $F91B: E0 07   
    BCC   $F915              ; $F91D: 90 F6   
    LDA   $0B00,X            ; $F91F: BD 00 0B
    BEQ   $F92A              ; $F922: F0 06   
    JSR   $FFD2              ; $F924: 20 D2 FF (J_BSOUT)
    INX                      ; $F927: E8      
    BNE   $F91F              ; $F928: D0 F5   
    STX   $9E                ; $F92A: 86 9E   
    JSR   $FA17              ; $F92C: 20 17 FA (KERNAL_PRIMM)
    ROL   $2E2E              ; $F92F: 2E 2E 2E
    ORA   $A500              ; $F932: 0D 00 A5
    LDX   $C685              ; $F935: AE 85 C6
    LDA   $AF                ; $F938: A5 AF   
    BEQ   $F945              ; $F93A: F0 09   
    DEC   $AF                ; $F93C: C6 AF   
    JSR   $F9B3              ; $F93E: 20 B3 F9
    INC   $AD                ; $F941: E6 AD   
    BNE   $F938              ; $F943: D0 F3   
    JSR   $F98B              ; $F945: 20 8B F9
    LDX   $9E                ; $F948: A6 9E   
    BIT   $9FE6              ; $F94A: 2C E6 9F
    INX                      ; $F94D: E8      
    LDA   $0B00,X            ; $F94E: BD 00 0B
    BNE   $F94B              ; $F951: D0 F8   
    INX                      ; $F953: E8      
    STX   $04                ; $F954: 86 04   
    LDX   $9E                ; $F956: A6 9E   
    LDA   #$3A               ; $F958: A9 3A   
    STA   $0B00,X            ; $F95A: 9D 00 0B
    DEX                      ; $F95D: CA      
    LDA   $BF                ; $F95E: A5 BF   
    STA   $0B00,X            ; $F960: 9D 00 0B
    STX   $9E                ; $F963: 86 9E   
    LDX   $9F                ; $F965: A6 9F   
    BEQ   $F97E              ; $F967: F0 15   
    INX                      ; $F969: E8      
    INX                      ; $F96A: E8      
    TXA                      ; $F96B: 8A      
    LDX   $9E                ; $F96C: A6 9E   
    LDY   #$0B               ; $F96E: A0 0B   
    JSR   $F731              ; $F970: 20 31 F7 (KERNAL_SETNAM)
    LDA   #$00               ; $F973: A9 00   
    TAX                      ; $F975: AA      
    JSR   $F73F              ; $F976: 20 3F F7 (KERNAL_SETBNK)
    LDA   #$00               ; $F979: A9 00   
    JSR   $F269              ; $F97B: 20 69 F2
    LDA   #$0B               ; $F97E: A9 0B   
    STA   $03                ; $F980: 85 03   
    LDA   #$0F               ; $F982: A9 0F   
    STA   $02                ; $F984: 85 02   
    JSR   $02CD              ; $F986: 20 CD 02
    CLC                      ; $F989: 18      
    RTS                      ; $F98A: 60      
    PHP                      ; $F98B: 08      
    PHA                      ; $F98C: 48      
    JSR   $FFCC              ; $F98D: 20 CC FF (J_CLRCH)
    LDA   #$0D               ; $F990: A9 0D   
    CLC                      ; $F992: 18      
    JSR   $FFC3              ; $F993: 20 C3 FF (J_CLOSE)
    LDX   #$00               ; $F996: A2 00   
    JSR   $FFC9              ; $F998: 20 C9 FF (J_CHKOUT)
    BCS   $F9A7              ; $F99B: B0 0A   
    LDA   #$55               ; $F99D: A9 55   
    JSR   $FFD2              ; $F99F: 20 D2 FF (J_BSOUT)
    LDA   #$49               ; $F9A2: A9 49   
    JSR   $FFD2              ; $F9A4: 20 D2 FF (J_BSOUT)
    JSR   $FFCC              ; $F9A7: 20 CC FF (J_CLRCH)
    LDA   #$00               ; $F9AA: A9 00   
    SEC                      ; $F9AC: 38      
    JSR   $FFC3              ; $F9AD: 20 C3 FF (J_CLOSE)
    PLA                      ; $F9B0: 68      
    PLP                      ; $F9B1: 28      
    RTS                      ; $F9B2: 60      
    LDX   $C2                ; $F9B3: A6 C2   
    INX                      ; $F9B5: E8      
    CPX   #$15               ; $F9B6: E0 15   
    BCC   $F9BE              ; $F9B8: 90 04   
    LDX   #$00               ; $F9BA: A2 00   
    INC   $C1                ; $F9BC: E6 C1   
    STX   $C2                ; $F9BE: 86 C2   
    TXA                      ; $F9C0: 8A      
    JSR   $F9FB              ; $F9C1: 20 FB F9
    STA   $0100              ; $F9C4: 8D 00 01
    STX   $0101              ; $F9C7: 8E 01 01
    LDA   $C1                ; $F9CA: A5 C1   
    JSR   $F9FB              ; $F9CC: 20 FB F9
    STA   $0103              ; $F9CF: 8D 03 01
    STX   $0104              ; $F9D2: 8E 04 01
    LDX   #$00               ; $F9D5: A2 00   
    JSR   $FFC9              ; $F9D7: 20 C9 FF (J_CHKOUT)
    LDX   #$0C               ; $F9DA: A2 0C   
    LDA   $0100,X            ; $F9DC: BD 00 01
    JSR   $FFD2              ; $F9DF: 20 D2 FF (J_BSOUT)
    DEX                      ; $F9E2: CA      
    BPL   $F9DC              ; $F9E3: 10 F7   
    JSR   $FFCC              ; $F9E5: 20 CC FF (J_CLRCH)
    LDX   #$0D               ; $F9E8: A2 0D   
    JSR   $FFC6              ; $F9EA: 20 C6 FF (J_CHKIN)
    LDY   #$00               ; $F9ED: A0 00   
    JSR   $FFCF              ; $F9EF: 20 CF FF (J_BASIN)
    JSR   $F7BC              ; $F9F2: 20 BC F7
    INY                      ; $F9F5: C8      
    BNE   $F9EF              ; $F9F6: D0 F7   
    JMP   $FFCC              ; $F9F8: 4C CC FF (J_CLRCH)
    LDX   #$30               ; $F9FB: A2 30   
    SEC                      ; $F9FD: 38      
    SBC   #$0A               ; $F9FE: E9 0A   
    BCC   $FA05              ; $FA00: 90 03   
    INX                      ; $FA02: E8      
    BCS   $F9FE              ; $FA03: B0 F9   
    ADC   #$3A               ; $FA05: 69 3A   
    RTS                      ; $FA07: 60      
    BMI   $FA3A              ; $FA08: 30 30   
    JSR   $3031              ; $FA0A: 20 31 30
    JSR   $2030              ; $FA0D: 20 30 20
    .BYTE $33                                ; $FA10: 33 [UNRESOLVED]
    AND   ($3A),Y            ; $FA11: 31 3A   
    AND   ($55),Y            ; $FA13: 31 55   
    EOR   #$23               ; $FA15: 49 23   
KERNAL_PRIMM:
    PHA                      ; $FA17: 48      
    TXA                      ; $FA18: 8A      
    PHA                      ; $FA19: 48      
    TYA                      ; $FA1A: 98      
    PHA                      ; $FA1B: 48      
    LDY   #$00               ; $FA1C: A0 00   
    TSX                      ; $FA1E: BA      
    INC   $0104,X            ; $FA1F: FE 04 01
    BNE   $FA27              ; $FA22: D0 03   
    INC   $0105,X            ; $FA24: FE 05 01
    LDA   $0104,X            ; $FA27: BD 04 01
    STA   $CE                ; $FA2A: 85 CE   
    LDA   $0105,X            ; $FA2C: BD 05 01
    STA   $CF                ; $FA2F: 85 CF   
    LDA   ($CE),Y            ; $FA31: B1 CE   
    BEQ   $FA3A              ; $FA33: F0 05   
    JSR   $FFD2              ; $FA35: 20 D2 FF (J_BSOUT)
    BCC   $FA1E              ; $FA38: 90 E4   
    PLA                      ; $FA3A: 68      
    TAY                      ; $FA3B: A8      
    PLA                      ; $FA3C: 68      
    TAX                      ; $FA3D: AA      
    PLA                      ; $FA3E: 68      
    RTS                      ; $FA3F: 60      
    CLD                      ; $FA40: D8      
    LDA   #$7F               ; $FA41: A9 7F   
    STA   $DD0D              ; $FA43: 8D 0D DD (CIA2_ICR)
    LDY   $DD0D              ; $FA46: AC 0D DD (CIA2_ICR)
    BMI   $FA5F              ; $FA49: 30 14   
    JSR   $F63D              ; $FA4B: 20 3D F6
    JSR   $FFE1              ; $FA4E: 20 E1 FF (J_STOP)
    BNE   $FA5F              ; $FA51: D0 0C   
    JSR   $E056              ; $FA53: 20 56 E0 (KERNAL_RESTOR)
    JSR   $E109              ; $FA56: 20 09 E1 (KERNAL_IOINIT)
    JSR   $C000              ; $FA59: 20 00 C0 (ED_JCINT)
    JMP   ($0A00)            ; $FA5C: 6C 00 0A
    JSR   $E805              ; $FA5F: 20 05 E8
    JMP   $FF33              ; $FA62: 4C 33 FF
    CLD                      ; $FA65: D8      
    JSR   $C024              ; $FA66: 20 24 C0 (ED_JIRQ)
    BCC   $FA7D              ; $FA69: 90 12   
    JSR   $F5F8              ; $FA6B: 20 F8 F5 (KERNAL_UDTIM)
    JSR   $EED0              ; $FA6E: 20 D0 EE
    LDA   $DC0D              ; $FA71: AD 0D DC (CIA1_ICR)
    LDA   $0A04              ; $FA74: AD 04 0A
    LSR   A                  ; $FA77: 4A      
    BCC   $FA7D              ; $FA78: 90 03   
    JSR   $4006              ; $FA7A: 20 06 40 (BASIC_IRQ_INIT_VEC)
    JMP   $FF33              ; $FA7D: 4C 33 FF
; --- [DATA] KERNAL National & C128 Keyboard Matrix Decode Tables ($FA80-$FC3A) ---
    .BYTE $14, $0D, $1D, $88, $85, $86, $87, $11 ; $FA80 [IDENTIFIED_DATA] |........|
    .BYTE $33, $57, $41, $34, $5A, $53, $45, $01 ; $FA88 [IDENTIFIED_DATA] |3WA4ZSE.|
    .BYTE $35, $52, $44, $36, $43, $46, $54, $58 ; $FA90 [IDENTIFIED_DATA] |5RD6CFTX|
    .BYTE $37, $59, $47, $38, $42, $48, $55, $56 ; $FA98 [IDENTIFIED_DATA] |7YG8BHUV|
    .BYTE $39, $49, $4A, $30, $4D, $4B, $4F, $4E ; $FAA0 [IDENTIFIED_DATA] |9IJ0MKON|
    .BYTE $2B, $50, $4C, $2D, $2E, $3A, $40, $2C ; $FAA8 [IDENTIFIED_DATA] |+PL-.:@,|
    .BYTE $5C, $2A, $3B, $13, $01, $3D, $5E, $2F ; $FAB0 [IDENTIFIED_DATA] |\*;..=^/|
    .BYTE $31, $5F, $04, $32, $20, $02, $51, $03 ; $FAB8 [IDENTIFIED_DATA] |1_.2 .Q.|
    .BYTE $84, $38, $35, $09, $32, $34, $37, $31 ; $FAC0 [IDENTIFIED_DATA] |.85.2471|
    .BYTE $1B, $2B, $2D, $0A, $0D, $36, $39, $33 ; $FAC8 [IDENTIFIED_DATA] |.+-..693|
    .BYTE $08, $30, $2E, $91, $11, $9D, $1D, $FF ; $FAD0 [IDENTIFIED_DATA] |.0......|
    .BYTE $FF, $94, $8D, $9D, $8C, $89, $8A, $8B ; $FAD8 [IDENTIFIED_DATA] |........|
    .BYTE $91, $23, $D7, $C1, $24, $DA, $D3, $C5 ; $FAE0 [IDENTIFIED_DATA] |.#..$...|
    .BYTE $01, $25, $D2, $C4, $26, $C3, $C6, $D4 ; $FAE8 [IDENTIFIED_DATA] |.%..&...|
    .BYTE $D8, $27, $D9, $C7, $28, $C2, $C8, $D5 ; $FAF0 [IDENTIFIED_DATA] |.'..(...|
    .BYTE $D6, $29, $C9, $CA, $30, $CD, $CB, $CF ; $FAF8 [IDENTIFIED_DATA] |.)..0...|
    .BYTE $CE, $DB, $D0, $CC, $DD, $3E, $5B, $BA ; $FB00 [IDENTIFIED_DATA] |.....>[.|
    .BYTE $3C, $A9, $C0, $5D, $93, $01, $3D, $DE ; $FB08 [IDENTIFIED_DATA] |<..]..=.|
    .BYTE $3F, $21, $5F, $04, $22, $A0, $02, $D1 ; $FB10 [IDENTIFIED_DATA] |?!_."...|
    .BYTE $83, $84, $38, $35, $18, $32, $34, $37 ; $FB18 [IDENTIFIED_DATA] |..85.247|
    .BYTE $31, $1B, $2B, $2D, $0A, $8D, $36, $39 ; $FB20 [IDENTIFIED_DATA] |1.+-..69|
    .BYTE $33, $08, $30, $2E, $91, $11, $9D, $1D ; $FB28 [IDENTIFIED_DATA] |3.0.....|
    .BYTE $FF, $FF, $94, $8D, $9D, $8C, $89, $8A ; $FB30 [IDENTIFIED_DATA] |........|
    .BYTE $8B, $91, $96, $B3, $B0, $97, $AD, $AE ; $FB38 [IDENTIFIED_DATA] |........|
    .BYTE $B1, $01, $98, $B2, $AC, $99, $BC, $BB ; $FB40 [IDENTIFIED_DATA] |........|
    .BYTE $A3, $BD, $9A, $B7, $A5, $9B, $BF, $B4 ; $FB48 [IDENTIFIED_DATA] |........|
    .BYTE $B8, $BE, $29, $A2, $B5, $30, $A7, $A1 ; $FB50 [IDENTIFIED_DATA] |..)..0..|
    .BYTE $B9, $AA, $A6, $AF, $B6, $DC, $3E, $5B ; $FB58 [IDENTIFIED_DATA] |......>[|
    .BYTE $A4, $3C, $A8, $DF, $5D, $93, $01, $3D ; $FB60 [IDENTIFIED_DATA] |.<..]..=|
    .BYTE $DE, $3F, $81, $5F, $04, $95, $A0, $02 ; $FB68 [IDENTIFIED_DATA] |.?._....|
    .BYTE $AB, $03, $84, $38, $35, $18, $32, $34 ; $FB70 [IDENTIFIED_DATA] |...85.24|
    .BYTE $37, $31, $1B, $2B, $2D, $0A, $8D, $36 ; $FB78 [IDENTIFIED_DATA] |71.+-..6|
    .BYTE $39, $33, $08, $30, $2E, $91, $11, $9D ; $FB80 [IDENTIFIED_DATA] |93.0....|
    .BYTE $1D, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FB88 [IDENTIFIED_DATA] |........|
    .BYTE $FF, $FF, $FF, $1C, $17, $01, $9F, $1A ; $FB90 [IDENTIFIED_DATA] |........|
    .BYTE $13, $05, $FF, $9C, $12, $04, $1E, $03 ; $FB98 [IDENTIFIED_DATA] |........|
    .BYTE $06, $14, $18, $1F, $19, $07, $9E, $02 ; $FBA0 [IDENTIFIED_DATA] |........|
    .BYTE $08, $15, $16, $12, $09, $0A, $92, $0D ; $FBA8 [IDENTIFIED_DATA] |........|
    .BYTE $0B, $0F, $0E, $FF, $10, $0C, $FF, $FF ; $FBB0 [IDENTIFIED_DATA] |........|
    .BYTE $1B, $00, $FF, $1C, $FF, $1D, $FF, $FF ; $FBB8 [IDENTIFIED_DATA] |........|
    .BYTE $1F, $1E, $FF, $90, $06, $FF, $05, $FF ; $FBC0 [IDENTIFIED_DATA] |........|
    .BYTE $FF, $11, $FF, $84, $38, $35, $18, $32 ; $FBC8 [IDENTIFIED_DATA] |....85.2|
    .BYTE $34, $37, $31, $1B, $2B, $2D, $0A, $8D ; $FBD0 [IDENTIFIED_DATA] |471.+-..|
    .BYTE $36, $39, $33, $08, $30, $2E, $91, $11 ; $FBD8 [IDENTIFIED_DATA] |693.0...|
    .BYTE $9D, $1D, $FF, $FF, $14, $0D, $1D, $88 ; $FBE0 [IDENTIFIED_DATA] |........|
    .BYTE $85, $86, $87, $11, $33, $D7, $C1, $34 ; $FBE8 [IDENTIFIED_DATA] |....3..4|
    .BYTE $DA, $D3, $C5, $01, $35, $D2, $C4, $36 ; $FBF0 [IDENTIFIED_DATA] |....5..6|
    .BYTE $C3, $C6, $D4, $D8, $37, $D9, $C7, $38 ; $FBF8 [IDENTIFIED_DATA] |....7..8|
    .BYTE $C2, $C8, $D5, $D6, $39, $C9, $CA, $30 ; $FC00 [IDENTIFIED_DATA] |....9..0|
    .BYTE $CD, $CB, $CF, $CE, $2B, $D0, $CC, $2D ; $FC08 [IDENTIFIED_DATA] |....+..-|
    .BYTE $2E, $3A, $40, $2C, $5C, $2A, $3B, $13 ; $FC10 [IDENTIFIED_DATA] |.:@,\*;.|
    .BYTE $01, $3D, $5E, $2F, $31, $5F, $04, $32 ; $FC18 [IDENTIFIED_DATA] |.=^/1_.2|
    .BYTE $20, $02, $51, $03, $84, $38, $35, $09 ; $FC20 [IDENTIFIED_DATA] | .Q..85.|
    .BYTE $32, $34, $37, $31, $1B, $2B, $2D, $0A ; $FC28 [IDENTIFIED_DATA] |2471.+-.|
    .BYTE $0D, $36, $39, $33, $08, $30, $2E, $91 ; $FC30 [IDENTIFIED_DATA] |.693.0..|
    .BYTE $11, $9D, $1D                          ; $FC38 [IDENTIFIED_DATA] |...|
; --- [PADDING] KERNAL Unused Padding ($FF, 709 bytes) ($FC3B-$FEFF) ---
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FC3B [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FC43 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FC4B [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FC53 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FC5B [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FC63 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FC6B [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FC73 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FC7B [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FC83 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FC8B [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FC93 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FC9B [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FCA3 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FCAB [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FCB3 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FCBB [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FCC3 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FCCB [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FCD3 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FCDB [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FCE3 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FCEB [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FCF3 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FCFB [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FD03 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FD0B [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FD13 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FD1B [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FD23 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FD2B [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FD33 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FD3B [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FD43 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FD4B [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FD53 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FD5B [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FD63 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FD6B [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FD73 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FD7B [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FD83 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FD8B [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FD93 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FD9B [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FDA3 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FDAB [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FDB3 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FDBB [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FDC3 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FDCB [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FDD3 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FDDB [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FDE3 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FDEB [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FDF3 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FDFB [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FE03 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FE0B [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FE13 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FE1B [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FE23 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FE2B [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FE33 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FE3B [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FE43 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FE4B [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FE53 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FE5B [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FE63 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FE6B [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FE73 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FE7B [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FE83 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FE8B [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FE93 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FE9B [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FEA3 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FEAB [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FEB3 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FEBB [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FEC3 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FECB [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FED3 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FEDB [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FEE3 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FEEB [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $FEF3 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF                ; $FEFB [PADDING] |.....|
MMU_CR_TOP:
; --- [PADDING] MMU $FF00-$FF04 Hardware Register Overlay Slot ($FF in ROM) ($FF00-$FF04) ---
    .BYTE $FF, $FF, $FF, $FF, $FF                ; $FF00 [PADDING] |.....|
HW_NMI_ENTRY:
    SEI                      ; $FF05: 78      
    PHA                      ; $FF06: 48      
    TXA                      ; $FF07: 8A      
    PHA                      ; $FF08: 48      
    TYA                      ; $FF09: 98      
    PHA                      ; $FF0A: 48      
    LDA   $FF00              ; $FF0B: AD 00 FF (MMU_CR_TOP)
    PHA                      ; $FF0E: 48      
    LDA   #$00               ; $FF0F: A9 00   
    STA   $FF00              ; $FF11: 8D 00 FF (MMU_CR_TOP)
    JMP   ($0318)            ; $FF14: 6C 18 03 (NMINV)
HW_IRQ_ENTRY:
    PHA                      ; $FF17: 48      
    TXA                      ; $FF18: 8A      
    PHA                      ; $FF19: 48      
    TYA                      ; $FF1A: 98      
    PHA                      ; $FF1B: 48      
    LDA   $FF00              ; $FF1C: AD 00 FF (MMU_CR_TOP)
    PHA                      ; $FF1F: 48      
    LDA   #$00               ; $FF20: A9 00   
    STA   $FF00              ; $FF22: 8D 00 FF (MMU_CR_TOP)
    TSX                      ; $FF25: BA      
    LDA   $0105,X            ; $FF26: BD 05 01
    AND   #$10               ; $FF29: 29 10   
    BEQ   $FF30              ; $FF2B: F0 03   
    JMP   ($0316)            ; $FF2D: 6C 16 03 (CBINV)
    JMP   ($0314)            ; $FF30: 6C 14 03 (CINV)
    PLA                      ; $FF33: 68      
    STA   $FF00              ; $FF34: 8D 00 FF (MMU_CR_TOP)
    PLA                      ; $FF37: 68      
    TAY                      ; $FF38: A8      
    PLA                      ; $FF39: 68      
    TAX                      ; $FF3A: AA      
    PLA                      ; $FF3B: 68      
    RTI                      ; $FF3C: 40      
HW_RESET_ENTRY:
    LDA   #$00               ; $FF3D: A9 00   
    STA   $FF00              ; $FF3F: 8D 00 FF (MMU_CR_TOP)
    JMP   $E000              ; $FF42: 4C 00 E0 (KERNAL_RESET_START)
; --- [PADDING] Unused Padding Between Reset Entry and Extended Jump Table ($FF) ($FF45-$FF46) ---
    .BYTE $FF, $FF                               ; $FF45 [PADDING] |..|
J_SPIN_SPOUT:
    JMP   $E5FB              ; $FF47: 4C FB E5 (KERNAL_SPIN_SPOUT)
J_CLOSE_ALL:
    JMP   $F23D              ; $FF4A: 4C 3D F2 (KERNAL_CLOSE_ALL)
J_C64MODE:
    JMP   $E24B              ; $FF4D: 4C 4B E2 (KERNAL_C64MODE)
J_DMA_CALL:
    JMP   $F7A5              ; $FF50: 4C A5 F7 (KERNAL_DMA_CALL)
J_BOOT_CALL:
    JMP   $F890              ; $FF53: 4C 90 F8 (KERNAL_BOOT_CALL)
J_PHOENIX:
    JMP   $F867              ; $FF56: 4C 67 F8 (KERNAL_PHOENIX)
J_LKUPLA:
    JMP   $F79D              ; $FF59: 4C 9D F7 (KERNAL_LKUPLA)
J_LKUPSA:
    JMP   $F786              ; $FF5C: 4C 86 F7 (KERNAL_LKUPSA)
J_SWAPPER:
    JMP   $C02A              ; $FF5F: 4C 2A C0 (ED_JSWAPPER)
J_DLCHR:
    JMP   $C027              ; $FF62: 4C 27 C0 (ED_JINIT80)
J_PFKEY:
    JMP   $C021              ; $FF65: 4C 21 C0 (ED_JKEYSET)
J_SETBNK:
    JMP   $F73F              ; $FF68: 4C 3F F7 (KERNAL_SETBNK)
J_GETCFG:
    JMP   $F7EC              ; $FF6B: 4C EC F7 (KERNAL_GETCFG)
J_JSRFAR:
    JMP   $02CD              ; $FF6E: 4C CD 02
J_JMPFAR:
    JMP   $02E3              ; $FF71: 4C E3 02
J_INDFET:
    JMP   $F7D0              ; $FF74: 4C D0 F7 (KERNAL_INDFET)
J_INDSTA:
    JMP   $F7DA              ; $FF77: 4C DA F7 (KERNAL_INDSTA)
J_INDCMP:
    JMP   $F7E3              ; $FF7A: 4C E3 F7 (KERNAL_INDCMP)
J_PRIMM:
    JMP   $FA17              ; $FF7D: 4C 17 FA (KERNAL_PRIMM)
; --- [DATA] KERNAL Release Revision Byte ($00) ($FF80-$FF80) ---
    .BYTE $00                                    ; $FF80 [IDENTIFIED_DATA] |.|
J_CINT:
    JMP   $C000              ; $FF81: 4C 00 C0 (ED_JCINT)
J_IOINIT:
    JMP   $E109              ; $FF84: 4C 09 E1 (KERNAL_IOINIT)
J_RAMTAS:
    JMP   $E093              ; $FF87: 4C 93 E0 (KERNAL_RAMTAS)
J_RESTOR:
    JMP   $E056              ; $FF8A: 4C 56 E0 (KERNAL_RESTOR)
J_VECTOR:
    JMP   $E05B              ; $FF8D: 4C 5B E0 (KERNAL_VECTOR)
J_SETMSG:
    JMP   $F75C              ; $FF90: 4C 5C F7 (KERNAL_SETMSG)
J_SECOND:
    JMP   $E4D2              ; $FF93: 4C D2 E4 (KERNAL_SECOND)
J_TKSA:
    JMP   $E4E0              ; $FF96: 4C E0 E4 (KERNAL_TKSA)
J_MEMTOP:
    JMP   $F763              ; $FF99: 4C 63 F7 (KERNAL_MEMTOP)
J_MEMBOT:
    JMP   $F772              ; $FF9C: 4C 72 F7 (KERNAL_MEMBOT)
J_SCNKEY:
    JMP   $C012              ; $FF9F: 4C 12 C0 (ED_JSCNKEY)
J_SETTMO:
    JMP   $F75F              ; $FFA2: 4C 5F F7 (KERNAL_SETTMO)
J_ACPTR:
    JMP   $E43E              ; $FFA5: 4C 3E E4 (KERNAL_ACPTR)
J_CIOUT:
    JMP   $E503              ; $FFA8: 4C 03 E5 (KERNAL_CIOUT)
J_UNTLK:
    JMP   $E515              ; $FFAB: 4C 15 E5 (KERNAL_UNTLK)
J_UNLSN:
    JMP   $E526              ; $FFAE: 4C 26 E5 (KERNAL_UNLSN)
J_LISTEN:
    JMP   $E33E              ; $FFB1: 4C 3E E3 (KERNAL_LISTEN)
J_TALK:
    JMP   $E33B              ; $FFB4: 4C 3B E3 (KERNAL_TALK)
J_READST:
    JMP   $F744              ; $FFB7: 4C 44 F7 (KERNAL_READST)
J_SETLFS:
    JMP   $F738              ; $FFBA: 4C 38 F7 (KERNAL_SETLFS)
J_SETNAM:
    JMP   $F731              ; $FFBD: 4C 31 F7 (KERNAL_SETNAM)
J_OPEN:
    JMP   ($031A)            ; $FFC0: 6C 1A 03 (IOPEN)
J_CLOSE:
    JMP   ($031C)            ; $FFC3: 6C 1C 03 (ICLOSE)
J_CHKIN:
    JMP   ($031E)            ; $FFC6: 6C 1E 03 (ICHKIN)
J_CHKOUT:
    JMP   ($0320)            ; $FFC9: 6C 20 03 (ICKOUT)
J_CLRCH:
    JMP   ($0322)            ; $FFCC: 6C 22 03 (ICLRCH)
J_BASIN:
    JMP   ($0324)            ; $FFCF: 6C 24 03 (IBASIN)
J_BSOUT:
    JMP   ($0326)            ; $FFD2: 6C 26 03 (IBSOUT)
J_LOAD:
    JMP   $F265              ; $FFD5: 4C 65 F2 (KERNAL_LOAD)
J_SAVE:
    JMP   $F53E              ; $FFD8: 4C 3E F5 (KERNAL_SAVE)
J_SETTIM:
    JMP   $F665              ; $FFDB: 4C 65 F6 (KERNAL_SETTIM)
J_RDTIM:
    JMP   $F65E              ; $FFDE: 4C 5E F6 (KERNAL_RDTIM)
J_STOP:
    JMP   ($0328)            ; $FFE1: 6C 28 03 (ISTOP)
J_GETIN:
    JMP   ($032A)            ; $FFE4: 6C 2A 03 (IGETIN)
J_CLALL:
    JMP   ($032C)            ; $FFE7: 6C 2C 03 (ICLALL)
J_UDTIM:
    JMP   $F5F8              ; $FFEA: 4C F8 F5 (KERNAL_UDTIM)
J_SCREEN:
    JMP   $C00F              ; $FFED: 4C 0F C0 (ED_JSCRORG)
J_PLOT:
    JMP   $C018              ; $FFF0: 4C 18 C0 (ED_JPLOT)
J_IOBASE:
    JMP   $F781              ; $FFF3: 4C 81 F7 (KERNAL_IOBASE)
; --- [PADDING] System Reserved Vector Slot ($FF) ($FFF6-$FFF9) ---
    .BYTE $FF, $FF, $24, $E2                     ; $FFF6 [PADDING] |..$.|
HW_VEC_NMI:
; --- [DATA] MOS 8502 Hardware Interrupt Vectors (NMI $FF05, RESET $FF3D, IRQ $FF17) ($FFFA-$FFFF) ---
    .BYTE $05, $FF, $3D, $FF, $17, $FF           ; $FFFA [IDENTIFIED_DATA] |..=...|
