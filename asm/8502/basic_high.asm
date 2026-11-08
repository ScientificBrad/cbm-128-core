; =============================================================================
; Commodore 128 BASIC 7.0 Upper ROM & ML Monitor (318019-02)
; Source ROM: basic-8000.318019-02.bin (16384 bytes, $8000-$BFFF)
; Architecture: MOS 8502
; Phase 6 Bit-Exact Reconstructible Assembly Source
; =============================================================================
    .ORG $8000

BASIC_UPPER_BASE:
    JSR   $87F7              ; $8000: 20 F7 87
    CPX   #$01               ; $8003: E0 01   
    BCC   $800C              ; $8005: 90 05   
    BEQ   $803A              ; $8007: F0 31   
    JMP   $7D28              ; $8009: 4C 28 7D
    SEC                      ; $800C: 38      
    LDA   $1212              ; $800D: AD 12 12
    SBC   $1210              ; $8010: ED 10 12
    TAY                      ; $8013: A8      
    LDA   $1213              ; $8014: AD 13 12
    SBC   $1211              ; $8017: ED 11 12
    BCS   $8047              ; $801A: B0 2B   
    LDX   $35                ; $801C: A6 35   
    INX                      ; $801E: E8      
    INY                      ; $801F: C8      
    STA   $70                ; $8020: 85 70   
    TYA                      ; $8022: 98      
    SEC                      ; $8023: 38      
    SBC   #$05               ; $8024: E9 05   
    STA   $71                ; $8026: 85 71   
    LDA   $71                ; $8028: A5 71   
    EOR   $AE37,X            ; $802A: 5D 37 AE
    EOR   $70                ; $802D: 45 70   
    BEQ   $8075              ; $802F: F0 44   
    JSR   $FFD2              ; $8031: 20 D2 FF (J_BSOUT)
    INC   $71                ; $8034: E6 71   
    INX                      ; $8036: E8      
    BNE   $8028              ; $8037: D0 EF   
    RTS                      ; $8039: 60      
    JSR   $92EA              ; $803A: 20 EA 92 (GARBAG_COLLECT)
    SEC                      ; $803D: 38      
    LDA   $35                ; $803E: A5 35   
    SBC   $33                ; $8040: E5 33   
    TAY                      ; $8042: A8      
    LDA   $36                ; $8043: A5 36   
    SBC   $34                ; $8045: E5 34   
    JMP   $84C9              ; $8047: 4C C9 84
CMD_VAL:
    JSR   $866E              ; $804A: 20 6E 86
    BNE   $8052              ; $804D: D0 03   
    JMP   $88D6              ; $804F: 4C D6 88
    CLC                      ; $8052: 18      
    ADC   $24                ; $8053: 65 24   
    STA   $72                ; $8055: 85 72   
    LDA   $25                ; $8057: A5 25   
    ADC   #$00               ; $8059: 69 00   
    STA   $73                ; $805B: 85 73   
    LDY   #$00               ; $805D: A0 00   
    LDA   #$72               ; $805F: A9 72   
    JSR   $03AB              ; $8061: 20 AB 03
    PHA                      ; $8064: 48      
    TYA                      ; $8065: 98      
    STA   ($72),Y            ; $8066: 91 72   
    JSR   $8E03              ; $8068: 20 03 8E
    LDX   #$01               ; $806B: A2 01   
    JSR   $8D22              ; $806D: 20 22 8D
    PLA                      ; $8070: 68      
    LDY   #$00               ; $8071: A0 00   
    STA   ($72),Y            ; $8073: 91 72   
    RTS                      ; $8075: 60      
CMD_RDOT:
    JSR   $866E              ; $8076: 20 6E 86
    STA   $26                ; $8079: 85 26   
    LDY   #$00               ; $807B: A0 00   
    STY   $27                ; $807D: 84 27   
    STY   $72                ; $807F: 84 72   
    STY   $73                ; $8081: 84 73   
    CPY   $26                ; $8083: C4 26   
    BEQ   $80BB              ; $8085: F0 34   
    JSR   $03B7              ; $8087: 20 B7 03
    INY                      ; $808A: C8      
    CMP   #$20               ; $808B: C9 20   
    BEQ   $8083              ; $808D: F0 F4   
    INC   $27                ; $808F: E6 27   
    LDX   $27                ; $8091: A6 27   
    CPX   #$05               ; $8093: E0 05   
    BEQ   $80C2              ; $8095: F0 2B   
    CMP   #$30               ; $8097: C9 30   
    BCC   $80C2              ; $8099: 90 27   
    CMP   #$3A               ; $809B: C9 3A   
    BCC   $80A9              ; $809D: 90 0A   
    CMP   #$41               ; $809F: C9 41   
    BCC   $80C2              ; $80A1: 90 1F   
    CMP   #$47               ; $80A3: C9 47   
    BCS   $80C2              ; $80A5: B0 1B   
    SBC   #$07               ; $80A7: E9 07   
    SBC   #$2F               ; $80A9: E9 2F   
    ASL   A                  ; $80AB: 0A      
    ASL   A                  ; $80AC: 0A      
    ASL   A                  ; $80AD: 0A      
    ASL   A                  ; $80AE: 0A      
    LDX   #$04               ; $80AF: A2 04   
    ASL   A                  ; $80B1: 0A      
    ROL   $72                ; $80B2: 26 72   
    ROL   $73                ; $80B4: 26 73   
    DEX                      ; $80B6: CA      
    BNE   $80B1              ; $80B7: D0 F8   
    BEQ   $8083              ; $80B9: F0 C8   
    LDY   $72                ; $80BB: A4 72   
    LDA   $73                ; $80BD: A5 73   
    JMP   $84C9              ; $80BF: 4C C9 84
    JMP   $7D28              ; $80C2: 4C 28 7D
CMD_PEEK:
    LDA   $17                ; $80C5: A5 17   
    PHA                      ; $80C7: 48      
    LDA   $16                ; $80C8: A5 16   
    PHA                      ; $80CA: 48      
    JSR   $77DA              ; $80CB: 20 DA 77
    JSR   $8815              ; $80CE: 20 15 88
    LDX   $03D5              ; $80D1: AE D5 03
    LDY   #$00               ; $80D4: A0 00   
    LDA   #$16               ; $80D6: A9 16   
    JSR   $FF74              ; $80D8: 20 74 FF (J_INDFET)
    TAY                      ; $80DB: A8      
    PLA                      ; $80DC: 68      
    STA   $16                ; $80DD: 85 16   
    PLA                      ; $80DF: 68      
    STA   $17                ; $80E0: 85 17   
    JMP   $84D4              ; $80E2: 4C D4 84
CMD_POKE:
    JSR   $8803              ; $80E5: 20 03 88
    TXA                      ; $80E8: 8A      
    LDY   #$00               ; $80E9: A0 00   
    LDX   #$16               ; $80EB: A2 16   
    STX   $02B9              ; $80ED: 8E B9 02
    LDX   $03D5              ; $80F0: AE D5 03
    JMP   $FF77              ; $80F3: 4C 77 FF (J_INDSTA)
CMD_HEX_:
    JSR   $87F7              ; $80F6: 20 F7 87
    DEX                      ; $80F9: CA      
    TXA                      ; $80FA: 8A      
    CMP   #$29               ; $80FB: C9 29   
    BCS   $8136              ; $80FD: B0 37   
    JSR   $4A82              ; $80FF: 20 82 4A (FIND_ERRMSG)
    LDY   #$FF               ; $8102: A0 FF   
    LDX   #$00               ; $8104: A2 00   
    INX                      ; $8106: E8      
    INY                      ; $8107: C8      
    LDA   ($26),Y            ; $8108: B1 26   
    BMI   $8112              ; $810A: 30 06   
    CMP   #$20               ; $810C: C9 20   
    BCC   $8107              ; $810E: 90 F7   
    BCS   $8106              ; $8110: B0 F4   
    TXA                      ; $8112: 8A      
    JSR   $8690              ; $8113: 20 90 86
    LDX   #$00               ; $8116: A2 00   
    LDY   #$FF               ; $8118: A0 FF   
    STA   $FF04              ; $811A: 8D 04 FF (MMU_LCRD_TOP)
    INY                      ; $811D: C8      
    LDA   ($26),Y            ; $811E: B1 26   
    CMP   #$20               ; $8120: C9 20   
    BCC   $811D              ; $8122: 90 F9   
    JSR   $8139              ; $8124: 20 39 81
    PHA                      ; $8127: 48      
    AND   #$7F               ; $8128: 29 7F   
    STA   ($64),Y            ; $812A: 91 64   
    JSR   $8139              ; $812C: 20 39 81
    INX                      ; $812F: E8      
    PLA                      ; $8130: 68      
    BPL   $811D              ; $8131: 10 EA   
    JMP   $85D1              ; $8133: 4C D1 85
    JMP   $7D28              ; $8136: 4C 28 7D
    PHA                      ; $8139: 48      
    TXA                      ; $813A: 8A      
    PHA                      ; $813B: 48      
    TYA                      ; $813C: 98      
    TAX                      ; $813D: AA      
    PLA                      ; $813E: 68      
    TAY                      ; $813F: A8      
    PLA                      ; $8140: 68      
    RTS                      ; $8141: 60      
CMD_DEC:
    JSR   $77DA              ; $8142: 20 DA 77
    LDA   $16                ; $8145: A5 16   
    PHA                      ; $8147: 48      
    LDA   $17                ; $8148: A5 17   
    PHA                      ; $814A: 48      
    JSR   $8815              ; $814B: 20 15 88
    LDA   #$04               ; $814E: A9 04   
    JSR   $8690              ; $8150: 20 90 86
    LDY   #$00               ; $8153: A0 00   
    LDA   $17                ; $8155: A5 17   
    STA   $FF04              ; $8157: 8D 04 FF (MMU_LCRD_TOP)
    JSR   $816B              ; $815A: 20 6B 81
    LDA   $16                ; $815D: A5 16   
    JSR   $816B              ; $815F: 20 6B 81
    PLA                      ; $8162: 68      
    STA   $17                ; $8163: 85 17   
    PLA                      ; $8165: 68      
    STA   $16                ; $8166: 85 16   
    JMP   $85D1              ; $8168: 4C D1 85
    PHA                      ; $816B: 48      
    LSR   A                  ; $816C: 4A      
    LSR   A                  ; $816D: 4A      
    LSR   A                  ; $816E: 4A      
    LSR   A                  ; $816F: 4A      
    JSR   $8174              ; $8170: 20 74 81
    PLA                      ; $8173: 68      
    AND   #$0F               ; $8174: 29 0F   
    CMP   #$0A               ; $8176: C9 0A   
    BCC   $817C              ; $8178: 90 02   
    ADC   #$06               ; $817A: 69 06   
    ADC   #$30               ; $817C: 69 30   
    STA   ($64),Y            ; $817E: 91 64   
    INY                      ; $8180: C8      
    RTS                      ; $8181: 60      
CMD_GO:
    JSR   $77DA              ; $8182: 20 DA 77
    JSR   $818C              ; $8185: 20 8C 81
    TAY                      ; $8188: A8      
    JMP   $84D4              ; $8189: 4C D4 84
    LDA   $D8                ; $818C: A5 D8   
    CLC                      ; $818E: 18      
    ROL   A                  ; $818F: 2A      
    ROL   A                  ; $8190: 2A      
    ROL   A                  ; $8191: 2A      
    ADC   #$00               ; $8192: 69 00   
    BIT   $D7                ; $8194: 24 D7   
    BPL   $819A              ; $8196: 10 02   
    ADC   #$05               ; $8198: 69 05   
    RTS                      ; $819A: 60      
CMD_RGR:
    JSR   $87F7              ; $819B: 20 F7 87
    JSR   $A845              ; $819E: 20 45 A8
    DEX                      ; $81A1: CA      
    BMI   $81B9              ; $81A2: 30 15   
    DEX                      ; $81A4: CA      
    BMI   $81C1              ; $81A5: 30 1A   
    DEX                      ; $81A7: CA      
    BMI   $81C6              ; $81A8: 30 1C   
    DEX                      ; $81AA: CA      
    BMI   $81CB              ; $81AB: 30 1E   
    DEX                      ; $81AD: CA      
    BMI   $81D0              ; $81AE: 30 20   
    DEX                      ; $81B0: CA      
    BMI   $81D6              ; $81B1: 30 23   
    DEX                      ; $81B3: CA      
    BMI   $81DE              ; $81B4: 30 28   
    JMP   $7D28              ; $81B6: 4C 28 7D
    LDA   $D021              ; $81B9: AD 21 D0 (VIC_BGCOL0)
    AND   #$7F               ; $81BC: 29 7F   
    JMP   $81EC              ; $81BE: 4C EC 81
    LDA   $86                ; $81C1: A5 86   
    JMP   $81EC              ; $81C3: 4C EC 81
    LDA   $84                ; $81C6: A5 84   
    JMP   $81EC              ; $81C8: 4C EC 81
    LDA   $85                ; $81CB: A5 85   
    JMP   $81EC              ; $81CD: 4C EC 81
    LDA   $D020              ; $81D0: AD 20 D0 (VIC_EXTCOL)
    JMP   $81EC              ; $81D3: 4C EC 81
    LDA   $F1                ; $81D6: A5 F1   
    BIT   $D7                ; $81D8: 24 D7   
    BPL   $81EC              ; $81DA: 10 10   
    BMI   $81E6              ; $81DC: 30 08   
    LDA   #$1A               ; $81DE: A9 1A   
    STA   $D600              ; $81E0: 8D 00 D6 (VDC_ADDR_STATUS)
    LDA   $D601              ; $81E3: AD 01 D6 (VDC_DATA)
    AND   #$0F               ; $81E6: 29 0F   
    TAX                      ; $81E8: AA      
    LDA   $81F3,X            ; $81E9: BD F3 81
    AND   #$0F               ; $81EC: 29 0F   
    TAY                      ; $81EE: A8      
    INY                      ; $81EF: C8      
    JMP   $84D4              ; $81F0: 4C D4 84
; --- [DATA] VDC 80-Column Color Code Translation Table ($81F3-$8202) ---
    .BYTE $00, $0C, $06, $0E, $05, $0D, $0B, $03 ; $81F3 [IDENTIFIED_DATA] |........|
    .BYTE $02, $0A, $08, $04, $09, $07, $0F, $01 ; $81FB [IDENTIFIED_DATA] |........|
    JSR   $87F7              ; $8203: 20 F7 87
    DEX                      ; $8206: CA      
    CPX   #$02               ; $8207: E0 02   
    BCS   $823F              ; $8209: B0 34   
    TXA                      ; $820B: 8A      
    EOR   #$01               ; $820C: 49 01   
    TAX                      ; $820E: AA      
    PHP                      ; $820F: 08      
    JSR   $A845              ; $8210: 20 45 A8
    SEI                      ; $8213: 78      
    LDA   $DC00              ; $8214: AD 00 DC (CIA1_PRA)
    PHA                      ; $8217: 48      
    LDY   #$FF               ; $8218: A0 FF   
    STY   $DC00              ; $821A: 8C 00 DC (CIA1_PRA)
    LDA   $DC00,X            ; $821D: BD 00 DC (CIA1_PRA)
    CMP   $DC00,X            ; $8220: DD 00 DC (CIA1_PRA)
    BNE   $821D              ; $8223: D0 F8   
    TAX                      ; $8225: AA      
    PLA                      ; $8226: 68      
    STA   $DC00              ; $8227: 8D 00 DC (CIA1_PRA)
    TXA                      ; $822A: 8A      
    PLP                      ; $822B: 28      
    AND   #$0F               ; $822C: 29 0F   
    TAY                      ; $822E: A8      
    LDA   $823D,Y            ; $822F: B9 3D 82
    TAY                      ; $8232: A8      
    TXA                      ; $8233: 8A      
    AND   #$10               ; $8234: 29 10   
    BNE   $823C              ; $8236: D0 04   
    TYA                      ; $8238: 98      
    ORA   #$80               ; $8239: 09 80   
    TAY                      ; $823B: A8      
    .BYTE $4C                                ; $823C: 4C [UNRESOLVED]
; --- [DATA] JOY Joystick Direction Decode Table ($823D-$824C) ---
    .BYTE $D4, $84, $4C, $28, $7D, $04, $02, $03 ; $823D [IDENTIFIED_DATA] |..L(}...|
    .BYTE $00, $06, $08, $07, $00, $05, $01, $00 ; $8245 [IDENTIFIED_DATA] |........|
CMD_ERR_:
    JSR   $7956              ; $824D: 20 56 79
    JSR   $87F7              ; $8250: 20 F7 87
    DEX                      ; $8253: CA      
    CPX   #$04               ; $8254: E0 04   
    BCS   $82AB              ; $8256: B0 53   
    JSR   $A845              ; $8258: 20 45 A8
    LDY   #$00               ; $825B: A0 00   
    TXA                      ; $825D: 8A      
    LDX   #$40               ; $825E: A2 40   
    LSR   A                  ; $8260: 4A      
    BCC   $8264              ; $8261: 90 01   
    INY                      ; $8263: C8      
    LSR   A                  ; $8264: 4A      
    BCC   $8269              ; $8265: 90 02   
    LDX   #$80               ; $8267: A2 80   
    STX   $12B1              ; $8269: 8E B1 12
    PHP                      ; $826C: 08      
    SEI                      ; $826D: 78      
    LDA   $DC00              ; $826E: AD 00 DC (CIA1_PRA)
    PHA                      ; $8271: 48      
    STX   $DC00              ; $8272: 8E 00 DC (CIA1_PRA)
    LDX   #$00               ; $8275: A2 00   
    INX                      ; $8277: E8      
    BNE   $8277              ; $8278: D0 FD   
    LDA   $D419,Y            ; $827A: B9 19 D4
    CMP   $D419,Y            ; $827D: D9 19 D4
    BNE   $827A              ; $8280: D0 F8   
    STA   $12B2              ; $8282: 8D B2 12
    LDX   #$00               ; $8285: A2 00   
    BIT   $12B1              ; $8287: 2C B1 12
    BMI   $828D              ; $828A: 30 01   
    INX                      ; $828C: E8      
    LDA   #$04               ; $828D: A9 04   
    DEY                      ; $828F: 88      
    BMI   $8293              ; $8290: 30 01   
    ASL   A                  ; $8292: 0A      
    LDY   #$FF               ; $8293: A0 FF   
    STY   $DC00              ; $8295: 8C 00 DC (CIA1_PRA)
    INY                      ; $8298: C8      
    AND   $DC00,X            ; $8299: 3D 00 DC (CIA1_PRA)
    BNE   $829F              ; $829C: D0 01   
    INY                      ; $829E: C8      
    PLA                      ; $829F: 68      
    STA   $DC00              ; $82A0: 8D 00 DC (CIA1_PRA)
    TYA                      ; $82A3: 98      
    LDY   $12B2              ; $82A4: AC B2 12
    PLP                      ; $82A7: 28      
    JMP   $84C9              ; $82A8: 4C C9 84
    JMP   $7D28              ; $82AB: 4C 28 7D
FN_CE_PEN:
    JSR   $7956              ; $82AE: 20 56 79
    JSR   $87F7              ; $82B1: 20 F7 87
    CPX   #$05               ; $82B4: E0 05   
    BCS   $82AB              ; $82B6: B0 F3   
    CPX   #$02               ; $82B8: E0 02   
    BCS   $82D6              ; $82BA: B0 1A   
    LDY   $11E9,X            ; $82BC: BC E9 11
    STY   $12B1              ; $82BF: 8C B1 12
    LDA   #$00               ; $82C2: A9 00   
    STA   $11E9,X            ; $82C4: 9D E9 11
    CPX   #$00               ; $82C7: E0 00   
    BNE   $82D0              ; $82C9: D0 05   
    ASL   $12B1              ; $82CB: 0E B1 12
    ADC   #$00               ; $82CE: 69 00   
    LDY   $12B1              ; $82D0: AC B1 12
    JMP   $84C9              ; $82D3: 4C C9 84
    JSR   $A845              ; $82D6: 20 45 A8
    CPX   #$04               ; $82D9: E0 04   
    BEQ   $82ED              ; $82DB: F0 10   
    LDY   #$11               ; $82DD: A0 11   
    CPX   #$02               ; $82DF: E0 02   
    BEQ   $82E4              ; $82E1: F0 01   
    DEY                      ; $82E3: 88      
    STY   $D600              ; $82E4: 8C 00 D6 (VDC_ADDR_STATUS)
    LDY   $D601              ; $82E7: AC 01 D6 (VDC_DATA)
    JMP   $84D4              ; $82EA: 4C D4 84
    LDA   $D600              ; $82ED: AD 00 D6 (VDC_ADDR_STATUS)
    LDY   #$00               ; $82F0: A0 00   
    AND   #$40               ; $82F2: 29 40   
    BEQ   $82F7              ; $82F4: F0 01   
    INY                      ; $82F6: C8      
    JMP   $84D4              ; $82F7: 4C D4 84
FN_CE_POINTER:
    JSR   $0380              ; $82FA: 20 80 03
    JSR   $7959              ; $82FD: 20 59 79
    JSR   $7B3C              ; $8300: 20 3C 7B
    BCC   $831B              ; $8303: 90 16   
    JSR   $7AAF              ; $8305: 20 AF 7A (PTRGET)
    TAX                      ; $8308: AA      
    TYA                      ; $8309: 98      
    PHA                      ; $830A: 48      
    JSR   $7956              ; $830B: 20 56 79
    TXA                      ; $830E: 8A      
    TAY                      ; $830F: A8      
    PLA                      ; $8310: 68      
    CMP   #$03               ; $8311: C9 03   
    BNE   $8318              ; $8313: D0 03   
    LDA   #$00               ; $8315: A9 00   
    TAY                      ; $8317: A8      
    JMP   $84C9              ; $8318: 4C C9 84
    JMP   $796C              ; $831B: 4C 6C 79 (CMD_FE_BEGIN)
FN_CE_RSPRITE:
    JSR   $87F7              ; $831E: 20 F7 87
    DEX                      ; $8321: CA      
    CPX   #$10               ; $8322: E0 10   
    BCS   $8358              ; $8324: B0 32   
    TXA                      ; $8326: 8A      
    PHA                      ; $8327: 48      
    JSR   $795C              ; $8328: 20 5C 79
    JSR   $87F4              ; $832B: 20 F4 87
    JSR   $7956              ; $832E: 20 56 79
    CPX   #$06               ; $8331: E0 06   
    BCS   $8358              ; $8333: B0 23   
    PLA                      ; $8335: 68      
    TAY                      ; $8336: A8      
    JSR   $A845              ; $8337: 20 45 A8
    LDA   $D027,Y            ; $833A: B9 27 D0
    AND   #$0F               ; $833D: 29 0F   
    CLC                      ; $833F: 18      
    ADC   #$01               ; $8340: 69 01   
    CPX   #$01               ; $8342: E0 01   
    BEQ   $8354              ; $8344: F0 0E   
    LDA   $835B,X            ; $8346: BD 5B 83
    TAX                      ; $8349: AA      
    LDA   $6CB3,Y            ; $834A: B9 B3 6C
    AND   $D000,X            ; $834D: 3D 00 D0 (VIC_SP0X)
    BEQ   $8354              ; $8350: F0 02   
    LDA   #$01               ; $8352: A9 01   
    TAY                      ; $8354: A8      
    JMP   $84D4              ; $8355: 4C D4 84
    JMP   $7D28              ; $8358: 4C 28 7D
; --- [DATA] RSPRITE VIC-II Register Offset Table ($835B-$8360) ---
    .BYTE $15, $27, $1B, $1D, $17, $1C           ; $835B [IDENTIFIED_DATA] |.'....|
FN_CE_RSPCOLOR:
    JSR   $7956              ; $8361: 20 56 79
    JSR   $87F7              ; $8364: 20 F7 87
    DEX                      ; $8367: CA      
    CPX   #$02               ; $8368: E0 02   
    BCS   $8379              ; $836A: B0 0D   
    JSR   $A845              ; $836C: 20 45 A8
    LDA   $D025,X            ; $836F: BD 25 D0
    AND   #$0F               ; $8372: 29 0F   
    TAY                      ; $8374: A8      
    INY                      ; $8375: C8      
    JMP   $84D4              ; $8376: 4C D4 84
    JMP   $7D28              ; $8379: 4C 28 7D
CMD_INSTR:
    JSR   $7956              ; $837C: 20 56 79
    JSR   $87F7              ; $837F: 20 F7 87
    DEX                      ; $8382: CA      
    CPX   #$02               ; $8383: E0 02   
    BCS   $8394              ; $8385: B0 0D   
    SEI                      ; $8387: 78      
    LDY   $11E7,X            ; $8388: BC E7 11
    LDA   #$00               ; $838B: A9 00   
    STA   $11E7,X            ; $838D: 9D E7 11
    CLI                      ; $8390: 58      
    JMP   $84D4              ; $8391: 4C D4 84
    JMP   $7D28              ; $8394: 4C 28 7D
FN_CE_RSPPOS:
    JSR   $87F7              ; $8397: 20 F7 87
    DEX                      ; $839A: CA      
    CPX   #$10               ; $839B: E0 10   
    BCS   $83DE              ; $839D: B0 3F   
    TXA                      ; $839F: 8A      
    PHA                      ; $83A0: 48      
    JSR   $795C              ; $83A1: 20 5C 79
    JSR   $87F4              ; $83A4: 20 F4 87
    JSR   $7956              ; $83A7: 20 56 79
    CPX   #$03               ; $83AA: E0 03   
    BCS   $83DE              ; $83AC: B0 30   
    PLA                      ; $83AE: 68      
    TAY                      ; $83AF: A8      
    CPX   #$02               ; $83B0: E0 02   
    BNE   $83BD              ; $83B2: D0 09   
    LDX   $6DD9,Y            ; $83B4: BE D9 6D
    LDY   $117E,X            ; $83B7: BC 7E 11
    JMP   $84D4              ; $83BA: 4C D4 84
    SEI                      ; $83BD: 78      
    LDA   $6CB3,Y            ; $83BE: B9 B3 6C
    AND   $11E6              ; $83C1: 2D E6 11
    BEQ   $83C8              ; $83C4: F0 02   
    LDA   #$01               ; $83C6: A9 01   
    PHA                      ; $83C8: 48      
    TYA                      ; $83C9: 98      
    ASL   A                  ; $83CA: 0A      
    TAY                      ; $83CB: A8      
    TXA                      ; $83CC: 8A      
    LSR   A                  ; $83CD: 4A      
    BCC   $83D5              ; $83CE: 90 05   
    INY                      ; $83D0: C8      
    PLA                      ; $83D1: 68      
    LDA   #$00               ; $83D2: A9 00   
    PHA                      ; $83D4: 48      
    LDA   $11D6,Y            ; $83D5: B9 D6 11
    CLI                      ; $83D8: 58      
    TAY                      ; $83D9: A8      
    PLA                      ; $83DA: 68      
    JMP   $84C9              ; $83DB: 4C C9 84
    JMP   $7D28              ; $83DE: 4C 28 7D
FN_CE_XOR:
    LDA   $16                ; $83E1: A5 16   
    PHA                      ; $83E3: 48      
    LDA   $17                ; $83E4: A5 17   
    PHA                      ; $83E6: 48      
    JSR   $77DA              ; $83E7: 20 DA 77
    JSR   $8815              ; $83EA: 20 15 88
    PHA                      ; $83ED: 48      
    TYA                      ; $83EE: 98      
    PHA                      ; $83EF: 48      
    JSR   $880F              ; $83F0: 20 0F 88
    JSR   $7956              ; $83F3: 20 56 79
    PLA                      ; $83F6: 68      
    EOR   $16                ; $83F7: 45 16   
    TAY                      ; $83F9: A8      
    PLA                      ; $83FA: 68      
    EOR   $17                ; $83FB: 45 17   
    JSR   $84C9              ; $83FD: 20 C9 84
    PLA                      ; $8400: 68      
    STA   $17                ; $8401: 85 17   
    PLA                      ; $8403: 68      
    STA   $16                ; $8404: 85 16   
    RTS                      ; $8406: 60      
FN_CE_RWINDOW:
    JSR   $7956              ; $8407: 20 56 79
    JSR   $87F7              ; $840A: 20 F7 87
    CPX   #$02               ; $840D: E0 02   
    BEQ   $8425              ; $840F: F0 14   
    BCS   $8431              ; $8411: B0 1E   
    CPX   #$00               ; $8413: E0 00   
    BNE   $841E              ; $8415: D0 07   
    LDA   $E4                ; $8417: A5 E4   
    SEC                      ; $8419: 38      
    SBC   $E5                ; $841A: E5 E5   
    BCS   $842D              ; $841C: B0 0F   
    LDA   $E7                ; $841E: A5 E7   
    SEC                      ; $8420: 38      
    SBC   $E6                ; $8421: E5 E6   
    BCS   $842D              ; $8423: B0 08   
    LDA   #$28               ; $8425: A9 28   
    BIT   $D7                ; $8427: 24 D7   
    BPL   $842D              ; $8429: 10 02   
    LDA   #$50               ; $842B: A9 50   
    TAY                      ; $842D: A8      
    JMP   $84D4              ; $842E: 4C D4 84
    JMP   $7D28              ; $8431: 4C 28 7D
CMD_RND:
    JSR   $8C57              ; $8434: 20 57 8C
    BMI   $846A              ; $8437: 30 31   
    BNE   $8455              ; $8439: D0 1A   
    JSR   $A845              ; $843B: 20 45 A8
    LDA   $DC06              ; $843E: AD 06 DC
    STA   $64                ; $8441: 85 64   
    LDA   $DC07              ; $8443: AD 07 DC
    STA   $66                ; $8446: 85 66   
    LDA   $DC04              ; $8448: AD 04 DC
    STA   $65                ; $844B: 85 65   
    LDA   $DC05              ; $844D: AD 05 DC
    STA   $67                ; $8450: 85 67   
    JMP   $847A              ; $8452: 4C 7A 84
    LDA   #$1B               ; $8455: A9 1B   
    LDY   #$12               ; $8457: A0 12   
    JSR   $8BD4              ; $8459: 20 D4 8B
    LDA   #$90               ; $845C: A9 90   
    LDY   #$84               ; $845E: A0 84   
    JSR   $8A08              ; $8460: 20 08 8A
    LDA   #$95               ; $8463: A9 95   
    LDY   #$84               ; $8465: A0 84   
    JSR   $8A12              ; $8467: 20 12 8A
    LDX   $67                ; $846A: A6 67   
    LDA   $64                ; $846C: A5 64   
    STA   $67                ; $846E: 85 67   
    STX   $64                ; $8470: 86 64   
    LDX   $65                ; $8472: A6 65   
    LDA   $66                ; $8474: A5 66   
    STA   $65                ; $8476: 85 65   
    STX   $66                ; $8478: 86 66   
    LDA   #$00               ; $847A: A9 00   
    STA   $68                ; $847C: 85 68   
    LDA   $63                ; $847E: A5 63   
    STA   $71                ; $8480: 85 71   
    LDA   #$80               ; $8482: A9 80   
    STA   $63                ; $8484: 85 63   
    JSR   $88B6              ; $8486: 20 B6 88
    LDX   #$1B               ; $8489: A2 1B   
    LDY   #$12               ; $848B: A0 12   
    JMP   $8C00              ; $848D: 4C 00 8C
    TYA                      ; $8490: 98      
    AND   $44,X              ; $8491: 35 44   
    .BYTE $7A                                ; $8493: 7A [UNRESOLVED]
    BRK                      ; $8494: 00      
    PLA                      ; $8495: 68      
    PLP                      ; $8496: 28      
    LDA   ($46),Y            ; $8497: B1 46   
    BRK                      ; $8499: 00      
    BCC   $841C              ; $849A: 90 80   
    BRK                      ; $849C: 00      
    BRK                      ; $849D: 00      
    BRK                      ; $849E: 00      
    JSR   $84B4              ; $849F: 20 B4 84 (INT_FP_CONVERSIONS)
    LDA   $66                ; $84A2: A5 66   
    LDY   $67                ; $84A4: A4 67   
    RTS                      ; $84A6: 60      
    JSR   $0380              ; $84A7: 20 80 03
    JSR   $77EF              ; $84AA: 20 EF 77 (FRMEVL)
    JSR   $77DA              ; $84AD: 20 DA 77
    LDA   $68                ; $84B0: A5 68   
    BMI   $84C1              ; $84B2: 30 0D   
INT_FP_CONVERSIONS:
    LDA   $63                ; $84B4: A5 63   
    CMP   #$90               ; $84B6: C9 90   
    BCC   $84C6              ; $84B8: 90 0C   
    LDA   #$9A               ; $84BA: A9 9A   
    LDY   #$84               ; $84BC: A0 84   
    JSR   $8C87              ; $84BE: 20 87 8C
    BEQ   $84C6              ; $84C1: F0 03   
    JMP   $7D28              ; $84C3: 4C 28 7D
    JMP   $8CC7              ; $84C6: 4C C7 8C
    JSR   $84E5              ; $84C9: 20 E5 84
    SEC                      ; $84CC: 38      
    JMP   $8C75              ; $84CD: 4C 75 8C
CMD_POS:
    SEC                      ; $84D0: 38      
    JSR   $928D              ; $84D1: 20 8D 92
    LDA   #$00               ; $84D4: A9 00   
    JMP   $793C              ; $84D6: 4C 3C 79
    BIT   $7F                ; $84D9: 24 7F   
    BMI   $84EF              ; $84DB: 30 12   
    LDX   #$15               ; $84DD: A2 15   
    BIT   $1BA2              ; $84DF: 2C A2 1B
    JMP   $4D3C              ; $84E2: 4C 3C 4D (BASIC_ERROR_ENTRY)
    LDX   #$00               ; $84E5: A2 00   
    STX   $0F                ; $84E7: 86 0F   
    STA   $64                ; $84E9: 85 64   
    STY   $65                ; $84EB: 84 65   
    LDX   #$90               ; $84ED: A2 90   
    RTS                      ; $84EF: 60      
    BIT   $7F                ; $84F0: 24 7F   
    BMI   $84F5              ; $84F2: 30 01   
    RTS                      ; $84F4: 60      
    LDX   #$22               ; $84F5: A2 22   
    JMP   $4D3C              ; $84F7: 4C 3C 4D (BASIC_ERROR_ENTRY)
CMD_DEF:
    JSR   $8528              ; $84FA: 20 28 85
    JSR   $84D9              ; $84FD: 20 D9 84
    JSR   $7959              ; $8500: 20 59 79
    LDA   #$80               ; $8503: A9 80   
    STA   $12                ; $8505: 85 12   
    JSR   $7AAF              ; $8507: 20 AF 7A (PTRGET)
    JSR   $77DA              ; $850A: 20 DA 77
    JSR   $7956              ; $850D: 20 56 79
    LDA   #$B2               ; $8510: A9 B2   
    JSR   $795E              ; $8512: 20 5E 79
    PHA                      ; $8515: 48      
    LDA   $4A                ; $8516: A5 4A   
    PHA                      ; $8518: 48      
    LDA   $49                ; $8519: A5 49   
    PHA                      ; $851B: 48      
    LDA   $3E                ; $851C: A5 3E   
    PHA                      ; $851E: 48      
    LDA   $3D                ; $851F: A5 3D   
    PHA                      ; $8521: 48      
    JSR   $528F              ; $8522: 20 8F 52 (CMD_DATA)
    JMP   $85A0              ; $8525: 4C A0 85
    LDA   #$A5               ; $8528: A9 A5   
    JSR   $795E              ; $852A: 20 5E 79
    ORA   #$80               ; $852D: 09 80   
    STA   $12                ; $852F: 85 12   
    JSR   $7AB6              ; $8531: 20 B6 7A
    STA   $50                ; $8534: 85 50   
    STY   $51                ; $8536: 84 51   
    JMP   $77DA              ; $8538: 4C DA 77
    JSR   $8528              ; $853B: 20 28 85
    LDA   $51                ; $853E: A5 51   
    PHA                      ; $8540: 48      
    LDA   $50                ; $8541: A5 50   
    PHA                      ; $8543: 48      
    JSR   $7950              ; $8544: 20 50 79 (CHKCHAR_HELPERS)
    JSR   $77DA              ; $8547: 20 DA 77
    PLA                      ; $854A: 68      
    STA   $50                ; $854B: 85 50   
    PLA                      ; $854D: 68      
    STA   $51                ; $854E: 85 51   
    LDY   #$02               ; $8550: A0 02   
    JSR   $42CE              ; $8552: 20 CE 42 (BANK0_BANK1_HELPERS)
    STA   $49                ; $8555: 85 49   
    TAX                      ; $8557: AA      
    INY                      ; $8558: C8      
    JSR   $42CE              ; $8559: 20 CE 42 (BANK0_BANK1_HELPERS)
    BEQ   $84E0              ; $855C: F0 82   
    STA   $4A                ; $855E: 85 4A   
    INY                      ; $8560: C8      
    LDA   #$49               ; $8561: A9 49   
    JSR   $03AB              ; $8563: 20 AB 03
    PHA                      ; $8566: 48      
    DEY                      ; $8567: 88      
    BPL   $8561              ; $8568: 10 F7   
    LDY   $4A                ; $856A: A4 4A   
    STA   $FF04              ; $856C: 8D 04 FF (MMU_LCRD_TOP)
    JSR   $8C00              ; $856F: 20 00 8C
    LDA   $3E                ; $8572: A5 3E   
    PHA                      ; $8574: 48      
    LDA   $3D                ; $8575: A5 3D   
    PHA                      ; $8577: 48      
    JSR   $42CE              ; $8578: 20 CE 42 (BANK0_BANK1_HELPERS)
    STA   $3D                ; $857B: 85 3D   
    INY                      ; $857D: C8      
    JSR   $42CE              ; $857E: 20 CE 42 (BANK0_BANK1_HELPERS)
    STA   $3E                ; $8581: 85 3E   
    LDA   $4A                ; $8583: A5 4A   
    PHA                      ; $8585: 48      
    LDA   $49                ; $8586: A5 49   
    PHA                      ; $8588: 48      
    JSR   $77D7              ; $8589: 20 D7 77
    PLA                      ; $858C: 68      
    STA   $50                ; $858D: 85 50   
    PLA                      ; $858F: 68      
    STA   $51                ; $8590: 85 51   
    JSR   $0386              ; $8592: 20 86 03
    BEQ   $859A              ; $8595: F0 03   
    JMP   $796C              ; $8597: 4C 6C 79 (CMD_FE_BEGIN)
    PLA                      ; $859A: 68      
    STA   $3D                ; $859B: 85 3D   
    PLA                      ; $859D: 68      
    STA   $3E                ; $859E: 85 3E   
    LDY   #$00               ; $85A0: A0 00   
    STA   $FF04              ; $85A2: 8D 04 FF (MMU_LCRD_TOP)
    PLA                      ; $85A5: 68      
    STA   ($50),Y            ; $85A6: 91 50   
    INY                      ; $85A8: C8      
    CPY   #$05               ; $85A9: C0 05   
    BNE   $85A5              ; $85AB: D0 F8   
    RTS                      ; $85AD: 60      
STRING_ENGINE:
    JSR   $77DA              ; $85AE: 20 DA 77
    LDY   #$00               ; $85B1: A0 00   
    JSR   $8E44              ; $85B3: 20 44 8E
    PLA                      ; $85B6: 68      
    PLA                      ; $85B7: 68      
    LDA   #$FF               ; $85B8: A9 FF   
    LDY   #$00               ; $85BA: A0 00   
    JMP   $869A              ; $85BC: 4C 9A 86
CMD_CHR_:
    JSR   $87F7              ; $85BF: 20 F7 87
    TXA                      ; $85C2: 8A      
    PHA                      ; $85C3: 48      
    LDA   #$01               ; $85C4: A9 01   
    JSR   $8690              ; $85C6: 20 90 86
    PLA                      ; $85C9: 68      
    LDY   #$00               ; $85CA: A0 00   
    STA   $FF04              ; $85CC: 8D 04 FF (MMU_LCRD_TOP)
    STA   ($64),Y            ; $85CF: 91 64   
    PLA                      ; $85D1: 68      
    PLA                      ; $85D2: 68      
    JMP   $86E3              ; $85D3: 4C E3 86
CMD_LEFT_:
    JSR   $864D              ; $85D6: 20 4D 86
    PHA                      ; $85D9: 48      
    JSR   $42D8              ; $85DA: 20 D8 42
    STA   $79                ; $85DD: 85 79   
    PLA                      ; $85DF: 68      
    CMP   $79                ; $85E0: C5 79   
    TYA                      ; $85E2: 98      
    BCC   $85EA              ; $85E3: 90 05   
    JSR   $42D8              ; $85E5: 20 D8 42
    TAX                      ; $85E8: AA      
    TYA                      ; $85E9: 98      
    PHA                      ; $85EA: 48      
    TXA                      ; $85EB: 8A      
    PHA                      ; $85EC: 48      
    JSR   $8690              ; $85ED: 20 90 86
    LDA   $52                ; $85F0: A5 52   
    LDY   $53                ; $85F2: A4 53   
    JSR   $8785              ; $85F4: 20 85 87
    PLA                      ; $85F7: 68      
    TAY                      ; $85F8: A8      
    PLA                      ; $85F9: 68      
    CLC                      ; $85FA: 18      
    ADC   $24                ; $85FB: 65 24   
    STA   $24                ; $85FD: 85 24   
    BCC   $8603              ; $85FF: 90 02   
    INC   $25                ; $8601: E6 25   
    TYA                      ; $8603: 98      
    JSR   $8763              ; $8604: 20 63 87
    JMP   $86E3              ; $8607: 4C E3 86
CMD_RIGHT_:
    JSR   $864D              ; $860A: 20 4D 86
    PHA                      ; $860D: 48      
    JSR   $42D8              ; $860E: 20 D8 42
    STA   $79                ; $8611: 85 79   
    PLA                      ; $8613: 68      
    CLC                      ; $8614: 18      
    SBC   $79                ; $8615: E5 79   
    EOR   #$FF               ; $8617: 49 FF   
    JMP   $85E3              ; $8619: 4C E3 85
CMD_MID_:
    LDA   #$FF               ; $861C: A9 FF   
    STA   $67                ; $861E: 85 67   
    JSR   $0386              ; $8620: 20 86 03
    CMP   #$29               ; $8623: C9 29   
    BEQ   $862D              ; $8625: F0 06   
    JSR   $795C              ; $8627: 20 5C 79
    JSR   $87F4              ; $862A: 20 F4 87
    JSR   $864D              ; $862D: 20 4D 86
    BEQ   $8685              ; $8630: F0 53   
    DEX                      ; $8632: CA      
    TXA                      ; $8633: 8A      
    PHA                      ; $8634: 48      
    LDX   #$00               ; $8635: A2 00   
    PHA                      ; $8637: 48      
    JSR   $42D8              ; $8638: 20 D8 42
    STA   $79                ; $863B: 85 79   
    PLA                      ; $863D: 68      
    CLC                      ; $863E: 18      
    SBC   $79                ; $863F: E5 79   
    BCS   $85EB              ; $8641: B0 A8   
    EOR   #$FF               ; $8643: 49 FF   
    CMP   $67                ; $8645: C5 67   
    BCC   $85EC              ; $8647: 90 A3   
    LDA   $67                ; $8649: A5 67   
    BCS   $85EC              ; $864B: B0 9F   
    JSR   $7956              ; $864D: 20 56 79
    PLA                      ; $8650: 68      
    TAY                      ; $8651: A8      
    PLA                      ; $8652: 68      
    STA   $57                ; $8653: 85 57   
    PLA                      ; $8655: 68      
    PLA                      ; $8656: 68      
    PLA                      ; $8657: 68      
    TAX                      ; $8658: AA      
    PLA                      ; $8659: 68      
    STA   $52                ; $865A: 85 52   
    PLA                      ; $865C: 68      
    STA   $53                ; $865D: 85 53   
    LDA   $57                ; $865F: A5 57   
    PHA                      ; $8661: 48      
    TYA                      ; $8662: 98      
    PHA                      ; $8663: 48      
    LDY   #$00               ; $8664: A0 00   
    TXA                      ; $8666: 8A      
    RTS                      ; $8667: 60      
CMD_LEN:
    JSR   $866E              ; $8668: 20 6E 86
    JMP   $84D4              ; $866B: 4C D4 84
    JSR   $877E              ; $866E: 20 7E 87
    LDX   #$00               ; $8671: A2 00   
    STX   $0F                ; $8673: 86 0F   
    TAY                      ; $8675: A8      
    RTS                      ; $8676: 60      
CMD_ASC:
    JSR   $866E              ; $8677: 20 6E 86
    BEQ   $8682              ; $867A: F0 06   
    LDY   #$00               ; $867C: A0 00   
    JSR   $03B7              ; $867E: 20 B7 03
    TAY                      ; $8681: A8      
    JMP   $84D4              ; $8682: 4C D4 84
    JMP   $7D28              ; $8685: 4C 28 7D
    LDX   $66                ; $8688: A6 66   
    LDY   $67                ; $868A: A4 67   
    STX   $52                ; $868C: 86 52   
    STY   $53                ; $868E: 84 53   
    JSR   $9299              ; $8690: 20 99 92
    STX   $64                ; $8693: 86 64   
    STY   $65                ; $8695: 84 65   
    STA   $63                ; $8697: 85 63   
    RTS                      ; $8699: 60      
    LDX   #$22               ; $869A: A2 22   
    STX   $09                ; $869C: 86 09   
    STX   $0A                ; $869E: 86 0A   
    STA   $70                ; $86A0: 85 70   
    STY   $71                ; $86A2: 84 71   
    STA   $64                ; $86A4: 85 64   
    STY   $65                ; $86A6: 84 65   
    LDY   #$FF               ; $86A8: A0 FF   
    INY                      ; $86AA: C8      
    JSR   $42F1              ; $86AB: 20 F1 42
    BEQ   $86BC              ; $86AE: F0 0C   
    CMP   $09                ; $86B0: C5 09   
    BEQ   $86B8              ; $86B2: F0 04   
    CMP   $0A                ; $86B4: C5 0A   
    BNE   $86AA              ; $86B6: D0 F2   
    CMP   #$22               ; $86B8: C9 22   
    BEQ   $86BD              ; $86BA: F0 01   
    CLC                      ; $86BC: 18      
    STY   $63                ; $86BD: 84 63   
    TYA                      ; $86BF: 98      
    ADC   $70                ; $86C0: 65 70   
    STA   $72                ; $86C2: 85 72   
    LDX   $71                ; $86C4: A6 71   
    BCC   $86C9              ; $86C6: 90 01   
    INX                      ; $86C8: E8      
    STX   $73                ; $86C9: 86 73   
    TYA                      ; $86CB: 98      
    JSR   $8688              ; $86CC: 20 88 86
    TAY                      ; $86CF: A8      
    BEQ   $86E3              ; $86D0: F0 11   
    PHA                      ; $86D2: 48      
    DEY                      ; $86D3: 88      
    JSR   $42F1              ; $86D4: 20 F1 42
    STA   $FF04              ; $86D7: 8D 04 FF (MMU_LCRD_TOP)
    STA   ($37),Y            ; $86DA: 91 37   
    TYA                      ; $86DC: 98      
    BNE   $86D3              ; $86DD: D0 F4   
    PLA                      ; $86DF: 68      
    JSR   $8771              ; $86E0: 20 71 87
    LDX   $18                ; $86E3: A6 18   
    CPX   #$24               ; $86E5: E0 24   
    BNE   $86EE              ; $86E7: D0 05   
    LDX   #$19               ; $86E9: A2 19   
    JMP   $4D3C              ; $86EB: 4C 3C 4D (BASIC_ERROR_ENTRY)
    LDA   $63                ; $86EE: A5 63   
    STA   $00,X              ; $86F0: 95 00   
    LDA   $64                ; $86F2: A5 64   
    STA   $01,X              ; $86F4: 95 01   
    LDA   $65                ; $86F6: A5 65   
    STA   $02,X              ; $86F8: 95 02   
    LDY   #$00               ; $86FA: A0 00   
    STX   $66                ; $86FC: 86 66   
    STY   $67                ; $86FE: 84 67   
    STY   $71                ; $8700: 84 71   
    DEY                      ; $8702: 88      
    STY   $0F                ; $8703: 84 0F   
    STX   $19                ; $8705: 86 19   
    INX                      ; $8707: E8      
    INX                      ; $8708: E8      
    INX                      ; $8709: E8      
    STX   $18                ; $870A: 86 18   
    RTS                      ; $870C: 60      
    LDA   $67                ; $870D: A5 67   
    PHA                      ; $870F: 48      
    LDA   $66                ; $8710: A5 66   
    PHA                      ; $8712: 48      
    JSR   $78D7              ; $8713: 20 D7 78 (EVAL)
    JSR   $77DD              ; $8716: 20 DD 77
    PLA                      ; $8719: 68      
    STA   $70                ; $871A: 85 70   
    PLA                      ; $871C: 68      
    STA   $71                ; $871D: 85 71   
    LDY   #$00               ; $871F: A0 00   
    JSR   $42F6              ; $8721: 20 F6 42
    STA   $79                ; $8724: 85 79   
    JSR   $42E7              ; $8726: 20 E7 42
    CLC                      ; $8729: 18      
    ADC   $79                ; $872A: 65 79   
    BCC   $8731              ; $872C: 90 03   
    JMP   $A5ED              ; $872E: 4C ED A5
    JSR   $8688              ; $8731: 20 88 86
    JSR   $874E              ; $8734: 20 4E 87
    LDA   $52                ; $8737: A5 52   
    LDY   $53                ; $8739: A4 53   
    JSR   $8785              ; $873B: 20 85 87
    JSR   $8763              ; $873E: 20 63 87
    LDA   $70                ; $8741: A5 70   
    LDY   $71                ; $8743: A4 71   
    JSR   $8785              ; $8745: 20 85 87
    JSR   $86E3              ; $8748: 20 E3 86
    JMP   $7809              ; $874B: 4C 09 78
    LDY   #$00               ; $874E: A0 00   
    JSR   $42F6              ; $8750: 20 F6 42
    PHA                      ; $8753: 48      
    INY                      ; $8754: C8      
    JSR   $42F6              ; $8755: 20 F6 42
    TAX                      ; $8758: AA      
    INY                      ; $8759: C8      
    JSR   $42F6              ; $875A: 20 F6 42
    TAY                      ; $875D: A8      
    PLA                      ; $875E: 68      
    STX   $24                ; $875F: 86 24   
    STY   $25                ; $8761: 84 25   
    TAY                      ; $8763: A8      
    BEQ   $8771              ; $8764: F0 0B   
    PHA                      ; $8766: 48      
    DEY                      ; $8767: 88      
    JSR   $03B7              ; $8768: 20 B7 03
    STA   ($37),Y            ; $876B: 91 37   
    TYA                      ; $876D: 98      
    BNE   $8767              ; $876E: D0 F7   
    PLA                      ; $8770: 68      
    CLC                      ; $8771: 18      
    ADC   $37                ; $8772: 65 37   
    STA   $37                ; $8774: 85 37   
    BCC   $877A              ; $8776: 90 02   
    INC   $38                ; $8778: E6 38   
    RTS                      ; $877A: 60      
    JSR   $77EF              ; $877B: 20 EF 77 (FRMEVL)
    JSR   $77DD              ; $877E: 20 DD 77
    LDA   $66                ; $8781: A5 66   
    LDY   $67                ; $8783: A4 67   
    STA   $24                ; $8785: 85 24   
    STY   $25                ; $8787: 84 25   
    JSR   $87E0              ; $8789: 20 E0 87
    BNE   $87CA              ; $878C: D0 3C   
    JSR   $54F6              ; $878E: 20 F6 54
    BCC   $87CA              ; $8791: 90 37   
    DEY                      ; $8793: 88      
    LDA   #$FF               ; $8794: A9 FF   
    STA   $FF04              ; $8796: 8D 04 FF (MMU_LCRD_TOP)
    STA   ($24),Y            ; $8799: 91 24   
    DEY                      ; $879B: 88      
    TXA                      ; $879C: 8A      
    STA   ($24),Y            ; $879D: 91 24   
    PHA                      ; $879F: 48      
    EOR   #$FF               ; $87A0: 49 FF   
    SEC                      ; $87A2: 38      
    ADC   $24                ; $87A3: 65 24   
    LDY   $25                ; $87A5: A4 25   
    BCS   $87AA              ; $87A7: B0 01   
    DEY                      ; $87A9: 88      
    STA   $24                ; $87AA: 85 24   
    STY   $25                ; $87AC: 84 25   
    TAX                      ; $87AE: AA      
    PLA                      ; $87AF: 68      
    CPY   $36                ; $87B0: C4 36   
    BNE   $87F0              ; $87B2: D0 3C   
    CPX   $35                ; $87B4: E4 35   
    BNE   $87F0              ; $87B6: D0 38   
    PHA                      ; $87B8: 48      
    SEC                      ; $87B9: 38      
    ADC   $35                ; $87BA: 65 35   
    STA   $35                ; $87BC: 85 35   
    BCC   $87C2              ; $87BE: 90 02   
    INC   $36                ; $87C0: E6 36   
    INC   $35                ; $87C2: E6 35   
    BNE   $87C8              ; $87C4: D0 02   
    INC   $36                ; $87C6: E6 36   
    PLA                      ; $87C8: 68      
    RTS                      ; $87C9: 60      
    LDY   #$00               ; $87CA: A0 00   
    JSR   $03B7              ; $87CC: 20 B7 03
    PHA                      ; $87CF: 48      
    INY                      ; $87D0: C8      
    JSR   $03B7              ; $87D1: 20 B7 03
    TAX                      ; $87D4: AA      
    INY                      ; $87D5: C8      
    JSR   $03B7              ; $87D6: 20 B7 03
    TAY                      ; $87D9: A8      
    STX   $24                ; $87DA: 86 24   
    STY   $25                ; $87DC: 84 25   
    PLA                      ; $87DE: 68      
    RTS                      ; $87DF: 60      
    CPY   $1A                ; $87E0: C4 1A   
    BNE   $87F0              ; $87E2: D0 0C   
    CMP   $19                ; $87E4: C5 19   
    BNE   $87F0              ; $87E6: D0 08   
    STA   $18                ; $87E8: 85 18   
    SBC   #$03               ; $87EA: E9 03   
    STA   $19                ; $87EC: 85 19   
    LDY   #$00               ; $87EE: A0 00   
    RTS                      ; $87F0: 60      
GETBYT_GETADR:
    JSR   $0380              ; $87F1: 20 80 03
    JSR   $77D7              ; $87F4: 20 D7 77
    JSR   $84AD              ; $87F7: 20 AD 84
    LDX   $66                ; $87FA: A6 66   
    BNE   $882B              ; $87FC: D0 2D   
    LDX   $67                ; $87FE: A6 67   
    JMP   $0386              ; $8800: 4C 86 03
    JSR   $77D7              ; $8803: 20 D7 77
    JSR   $8815              ; $8806: 20 15 88
    JSR   $795C              ; $8809: 20 5C 79
    JMP   $87F4              ; $880C: 4C F4 87
    JSR   $795C              ; $880F: 20 5C 79
    JSR   $77D7              ; $8812: 20 D7 77
    LDA   $68                ; $8815: A5 68   
    BMI   $882B              ; $8817: 30 12   
    LDA   $63                ; $8819: A5 63   
    CMP   #$91               ; $881B: C9 91   
    BCS   $882B              ; $881D: B0 0C   
    JSR   $8CC7              ; $881F: 20 C7 8C
    LDA   $66                ; $8822: A5 66   
    LDY   $67                ; $8824: A4 67   
    STY   $16                ; $8826: 84 16   
    STA   $17                ; $8828: 85 17   
    RTS                      ; $882A: 60      
    JMP   $7D28              ; $882B: 4C 28 7D
FP_MATH_LIBRARY:
    JSR   $8AB4              ; $882E: 20 B4 8A
CMD__:
    LDA   $68                ; $8831: A5 68   
    EOR   #$FF               ; $8833: 49 FF   
    STA   $68                ; $8835: 85 68   
    EOR   $6F                ; $8837: 45 6F   
    STA   $70                ; $8839: 85 70   
    LDA   $63                ; $883B: A5 63   
    JMP   $8848              ; $883D: 4C 48 88 (CMD__)
    JSR   $8979              ; $8840: 20 79 89
    BCC   $8882              ; $8843: 90 3D   
    JSR   $8AB4              ; $8845: 20 B4 8A
CMD__:
    BNE   $884D              ; $8848: D0 03   
    JMP   $8C28              ; $884A: 4C 28 8C
    LDX   $71                ; $884D: A6 71   
    STX   $58                ; $884F: 86 58   
    LDX   #$6A               ; $8851: A2 6A   
    LDA   $6A                ; $8853: A5 6A   
    TAY                      ; $8855: A8      
    BNE   $8859              ; $8856: D0 01   
    RTS                      ; $8858: 60      
    SEC                      ; $8859: 38      
    SBC   $63                ; $885A: E5 63   
    BEQ   $8882              ; $885C: F0 24   
    BCC   $8872              ; $885E: 90 12   
    STY   $63                ; $8860: 84 63   
    LDY   $6F                ; $8862: A4 6F   
    STY   $68                ; $8864: 84 68   
    EOR   #$FF               ; $8866: 49 FF   
    ADC   #$00               ; $8868: 69 00   
    LDY   #$00               ; $886A: A0 00   
    STY   $58                ; $886C: 84 58   
    LDX   #$63               ; $886E: A2 63   
    BNE   $8876              ; $8870: D0 04   
    LDY   #$00               ; $8872: A0 00   
    STY   $71                ; $8874: 84 71   
    CMP   #$F9               ; $8876: C9 F9   
    BMI   $8840              ; $8878: 30 C6   
    TAY                      ; $887A: A8      
    LDA   $71                ; $887B: A5 71   
    LSR   $01,X              ; $887D: 56 01   
    JSR   $8990              ; $887F: 20 90 89
    BIT   $70                ; $8882: 24 70   
    BPL   $88DD              ; $8884: 10 57   
    LDY   #$63               ; $8886: A0 63   
    CPX   #$6A               ; $8888: E0 6A   
    BEQ   $888E              ; $888A: F0 02   
    LDY   #$6A               ; $888C: A0 6A   
    SEC                      ; $888E: 38      
    EOR   #$FF               ; $888F: 49 FF   
    ADC   $58                ; $8891: 65 58   
    STA   $71                ; $8893: 85 71   
    LDA.W $0004,Y            ; $8895: B9 04 00
    SBC   $04,X              ; $8898: F5 04   
    STA   $67                ; $889A: 85 67   
    LDA.W $0003,Y            ; $889C: B9 03 00
    SBC   $03,X              ; $889F: F5 03   
    STA   $66                ; $88A1: 85 66   
    LDA.W $0002,Y            ; $88A3: B9 02 00
    SBC   $02,X              ; $88A6: F5 02   
    STA   $65                ; $88A8: 85 65   
    LDA.W $0001,Y            ; $88AA: B9 01 00 (R6510)
    SBC   $01,X              ; $88AD: F5 01   
    STA   $64                ; $88AF: 85 64   
    BCS   $88B6              ; $88B1: B0 03   
    JSR   $8926              ; $88B3: 20 26 89
    LDY   #$00               ; $88B6: A0 00   
    TYA                      ; $88B8: 98      
    CLC                      ; $88B9: 18      
    LDX   $64                ; $88BA: A6 64   
    BNE   $8908              ; $88BC: D0 4A   
    LDX   $65                ; $88BE: A6 65   
    STX   $64                ; $88C0: 86 64   
    LDX   $66                ; $88C2: A6 66   
    STX   $65                ; $88C4: 86 65   
    LDX   $67                ; $88C6: A6 67   
    STX   $66                ; $88C8: 86 66   
    LDX   $71                ; $88CA: A6 71   
    STX   $67                ; $88CC: 86 67   
    STY   $71                ; $88CE: 84 71   
    ADC   #$08               ; $88D0: 69 08   
    CMP   #$20               ; $88D2: C9 20   
    BNE   $88BA              ; $88D4: D0 E4   
    LDA   #$00               ; $88D6: A9 00   
    STA   $63                ; $88D8: 85 63   
    STA   $68                ; $88DA: 85 68   
    RTS                      ; $88DC: 60      
    ADC   $58                ; $88DD: 65 58   
    STA   $71                ; $88DF: 85 71   
    LDA   $67                ; $88E1: A5 67   
    ADC   $6E                ; $88E3: 65 6E   
    STA   $67                ; $88E5: 85 67   
    LDA   $66                ; $88E7: A5 66   
    ADC   $6D                ; $88E9: 65 6D   
    STA   $66                ; $88EB: 85 66   
    LDA   $65                ; $88ED: A5 65   
    ADC   $6C                ; $88EF: 65 6C   
    STA   $65                ; $88F1: 85 65   
    LDA   $64                ; $88F3: A5 64   
    ADC   $6B                ; $88F5: 65 6B   
    STA   $64                ; $88F7: 85 64   
    JMP   $8915              ; $88F9: 4C 15 89
    ADC   #$01               ; $88FC: 69 01   
    ASL   $71                ; $88FE: 06 71   
    ROL   $67                ; $8900: 26 67   
    ROL   $66                ; $8902: 26 66   
    ROL   $65                ; $8904: 26 65   
    ROL   $64                ; $8906: 26 64   
    BPL   $88FC              ; $8908: 10 F2   
    SEC                      ; $890A: 38      
    SBC   $63                ; $890B: E5 63   
    BCS   $88D6              ; $890D: B0 C7   
    EOR   #$FF               ; $890F: 49 FF   
    ADC   #$01               ; $8911: 69 01   
    STA   $63                ; $8913: 85 63   
    BCC   $8925              ; $8915: 90 0E   
    INC   $63                ; $8917: E6 63   
    BEQ   $895D              ; $8919: F0 42   
    ROR   $64                ; $891B: 66 64   
    ROR   $65                ; $891D: 66 65   
    ROR   $66                ; $891F: 66 66   
    ROR   $67                ; $8921: 66 67   
    ROR   $71                ; $8923: 66 71   
    RTS                      ; $8925: 60      
    LDA   $68                ; $8926: A5 68   
    EOR   #$FF               ; $8928: 49 FF   
    STA   $68                ; $892A: 85 68   
    LDA   $64                ; $892C: A5 64   
    EOR   #$FF               ; $892E: 49 FF   
    STA   $64                ; $8930: 85 64   
    LDA   $65                ; $8932: A5 65   
    EOR   #$FF               ; $8934: 49 FF   
    STA   $65                ; $8936: 85 65   
    LDA   $66                ; $8938: A5 66   
    EOR   #$FF               ; $893A: 49 FF   
    STA   $66                ; $893C: 85 66   
    LDA   $67                ; $893E: A5 67   
    EOR   #$FF               ; $8940: 49 FF   
    STA   $67                ; $8942: 85 67   
    LDA   $71                ; $8944: A5 71   
    EOR   #$FF               ; $8946: 49 FF   
    STA   $71                ; $8948: 85 71   
    INC   $71                ; $894A: E6 71   
    BNE   $895C              ; $894C: D0 0E   
    INC   $67                ; $894E: E6 67   
    BNE   $895C              ; $8950: D0 0A   
    INC   $66                ; $8952: E6 66   
    BNE   $895C              ; $8954: D0 06   
    INC   $65                ; $8956: E6 65   
    BNE   $895C              ; $8958: D0 02   
    INC   $64                ; $895A: E6 64   
    RTS                      ; $895C: 60      
    LDX   #$0F               ; $895D: A2 0F   
    JMP   $4D3C              ; $895F: 4C 3C 4D (BASIC_ERROR_ENTRY)
    LDX   #$27               ; $8962: A2 27   
    LDY   $04,X              ; $8964: B4 04   
    STY   $71                ; $8966: 84 71   
    LDY   $03,X              ; $8968: B4 03   
    STY   $04,X              ; $896A: 94 04   
    LDY   $02,X              ; $896C: B4 02   
    STY   $03,X              ; $896E: 94 03   
    LDY   $01,X              ; $8970: B4 01   
    STY   $02,X              ; $8972: 94 02   
    LDY   $03DF              ; $8974: AC DF 03
    STY   $01,X              ; $8977: 94 01   
    ADC   #$08               ; $8979: 69 08   
    BMI   $8964              ; $897B: 30 E7   
    BEQ   $8964              ; $897D: F0 E5   
    SBC   #$08               ; $897F: E9 08   
    TAY                      ; $8981: A8      
    LDA   $71                ; $8982: A5 71   
    BCS   $899A              ; $8984: B0 14   
    ASL   $01,X              ; $8986: 16 01   
    BCC   $898C              ; $8988: 90 02   
    INC   $01,X              ; $898A: F6 01   
    ROR   $01,X              ; $898C: 76 01   
    ROR   $01,X              ; $898E: 76 01   
    ROR   $02,X              ; $8990: 76 02   
    ROR   $03,X              ; $8992: 76 03   
    ROR   $04,X              ; $8994: 76 04   
    ROR   A                  ; $8996: 6A      
    INY                      ; $8997: C8      
    BNE   $8986              ; $8998: D0 EC   
    CLC                      ; $899A: 18      
    RTS                      ; $899B: 60      
    STA   ($00,X)            ; $899C: 81 00   
    BRK                      ; $899E: 00      
    BRK                      ; $899F: 00      
    BRK                      ; $89A0: 00      
    .BYTE $03                                ; $89A1: 03 [UNRESOLVED]
    .BYTE $7F                                ; $89A2: 7F [UNRESOLVED]
    LSR   $CB56,X            ; $89A3: 5E 56 CB
    ADC   $1380,Y            ; $89A6: 79 80 13
    .BYTE $9B                                ; $89A9: 9B [UNRESOLVED]
    .BYTE $0B                                ; $89AA: 0B [UNRESOLVED]
    .BYTE $64                                ; $89AB: 64 [UNRESOLVED]
    .BYTE $80                                ; $89AC: 80 [UNRESOLVED]
    ROR   $38,X              ; $89AD: 76 38   
    .BYTE $93                                ; $89AF: 93 [UNRESOLVED]
    ASL   $82,X              ; $89B0: 16 82   
    SEC                      ; $89B2: 38      
    TAX                      ; $89B3: AA      
    .BYTE $3B                                ; $89B4: 3B [UNRESOLVED]
    JSR   $3580              ; $89B5: 20 80 35
    .BYTE $04                                ; $89B8: 04 [UNRESOLVED]
    .BYTE $F3                                ; $89B9: F3 [UNRESOLVED]
    .BYTE $34                                ; $89BA: 34 [UNRESOLVED]
    STA   ($35,X)            ; $89BB: 81 35   
    .BYTE $04                                ; $89BD: 04 [UNRESOLVED]
    .BYTE $F3                                ; $89BE: F3 [UNRESOLVED]
    .BYTE $34                                ; $89BF: 34 [UNRESOLVED]
    .BYTE $80                                ; $89C0: 80 [UNRESOLVED]
    .BYTE $80                                ; $89C1: 80 [UNRESOLVED]
    BRK                      ; $89C2: 00      
    BRK                      ; $89C3: 00      
    BRK                      ; $89C4: 00      
    .BYTE $80                                ; $89C5: 80 [UNRESOLVED]
    AND   ($72),Y            ; $89C6: 31 72   
    .BYTE $17                                ; $89C8: 17 [UNRESOLVED]
    SED                      ; $89C9: F8      
CMD_LOG:
    JSR   $8C57              ; $89CA: 20 57 8C
    BEQ   $89D1              ; $89CD: F0 02   
    BPL   $89D4              ; $89CF: 10 03   
    JMP   $7D28              ; $89D1: 4C 28 7D
    LDA   $63                ; $89D4: A5 63   
    SBC   #$7F               ; $89D6: E9 7F   
    PHA                      ; $89D8: 48      
    LDA   #$80               ; $89D9: A9 80   
    STA   $63                ; $89DB: 85 63   
    LDA   #$B6               ; $89DD: A9 B6   
    LDY   #$89               ; $89DF: A0 89   
    JSR   $8A12              ; $89E1: 20 12 8A
    LDA   #$BB               ; $89E4: A9 BB   
    LDY   #$89               ; $89E6: A0 89   
    JSR   $8A1E              ; $89E8: 20 1E 8A
    LDA   #$9C               ; $89EB: A9 9C   
    LDY   #$89               ; $89ED: A0 89   
    JSR   $8A18              ; $89EF: 20 18 8A
    LDA   #$A1               ; $89F2: A9 A1   
    LDY   #$89               ; $89F4: A0 89   
    JSR   $9086              ; $89F6: 20 86 90
    LDA   #$C0               ; $89F9: A9 C0   
    LDY   #$89               ; $89FB: A0 89   
    JSR   $8A12              ; $89FD: 20 12 8A
    PLA                      ; $8A00: 68      
    JSR   $8DB0              ; $8A01: 20 B0 8D
    LDA   #$C5               ; $8A04: A9 C5   
    LDY   #$89               ; $8A06: A0 89   
    JSR   $8A89              ; $8A08: 20 89 8A
    JMP   $8A27              ; $8A0B: 4C 27 8A (CMD__)
    LDA   #$76               ; $8A0E: A9 76   
    LDY   #$8F               ; $8A10: A0 8F   
    JSR   $8A89              ; $8A12: 20 89 8A
    JMP   $8848              ; $8A15: 4C 48 88 (CMD__)
    JSR   $8A89              ; $8A18: 20 89 8A
    JMP   $8831              ; $8A1B: 4C 31 88 (CMD__)
    JSR   $8A89              ; $8A1E: 20 89 8A
    JMP   $8B4C              ; $8A21: 4C 4C 8B (CMD__)
    JSR   $8AB4              ; $8A24: 20 B4 8A
CMD__:
    BNE   $8A2C              ; $8A27: D0 03   
    JMP   $8A88              ; $8A29: 4C 88 8A
    JSR   $8AEC              ; $8A2C: 20 EC 8A
    LDA   #$00               ; $8A2F: A9 00   
    STA   $28                ; $8A31: 85 28   
    STA   $29                ; $8A33: 85 29   
    STA   $2A                ; $8A35: 85 2A   
    STA   $2B                ; $8A37: 85 2B   
    LDA   $71                ; $8A39: A5 71   
    JSR   $8A55              ; $8A3B: 20 55 8A
    LDA   $67                ; $8A3E: A5 67   
    JSR   $8A55              ; $8A40: 20 55 8A
    LDA   $66                ; $8A43: A5 66   
    JSR   $8A55              ; $8A45: 20 55 8A
    LDA   $65                ; $8A48: A5 65   
    JSR   $8A55              ; $8A4A: 20 55 8A
    LDA   $64                ; $8A4D: A5 64   
    JSR   $8A5B              ; $8A4F: 20 5B 8A
    JMP   $8BC1              ; $8A52: 4C C1 8B
    BNE   $8A5B              ; $8A55: D0 04   
    SEC                      ; $8A57: 38      
    JMP   $8962              ; $8A58: 4C 62 89
    LSR   A                  ; $8A5B: 4A      
    ORA   #$80               ; $8A5C: 09 80   
    TAY                      ; $8A5E: A8      
    BCC   $8A7A              ; $8A5F: 90 19   
    CLC                      ; $8A61: 18      
    LDA   $2B                ; $8A62: A5 2B   
    ADC   $6E                ; $8A64: 65 6E   
    STA   $2B                ; $8A66: 85 2B   
    LDA   $2A                ; $8A68: A5 2A   
    ADC   $6D                ; $8A6A: 65 6D   
    STA   $2A                ; $8A6C: 85 2A   
    LDA   $29                ; $8A6E: A5 29   
    ADC   $6C                ; $8A70: 65 6C   
    STA   $29                ; $8A72: 85 29   
    LDA   $28                ; $8A74: A5 28   
    ADC   $6B                ; $8A76: 65 6B   
    STA   $28                ; $8A78: 85 28   
    ROR   $28                ; $8A7A: 66 28   
    ROR   $29                ; $8A7C: 66 29   
    ROR   $2A                ; $8A7E: 66 2A   
    ROR   $2B                ; $8A80: 66 2B   
    ROR   $71                ; $8A82: 66 71   
    TYA                      ; $8A84: 98      
    LSR   A                  ; $8A85: 4A      
    BNE   $8A5E              ; $8A86: D0 D6   
    RTS                      ; $8A88: 60      
    STA   $24                ; $8A89: 85 24   
    STY   $25                ; $8A8B: 84 25   
    LDY   #$04               ; $8A8D: A0 04   
    LDA   ($24),Y            ; $8A8F: B1 24   
    STA   $6E                ; $8A91: 85 6E   
    DEY                      ; $8A93: 88      
    LDA   ($24),Y            ; $8A94: B1 24   
    STA   $6D                ; $8A96: 85 6D   
    DEY                      ; $8A98: 88      
    LDA   ($24),Y            ; $8A99: B1 24   
    STA   $6C                ; $8A9B: 85 6C   
    DEY                      ; $8A9D: 88      
    LDA   ($24),Y            ; $8A9E: B1 24   
    STA   $6F                ; $8AA0: 85 6F   
    EOR   $68                ; $8AA2: 45 68   
    STA   $70                ; $8AA4: 85 70   
    LDA   $6F                ; $8AA6: A5 6F   
    ORA   #$80               ; $8AA8: 09 80   
    STA   $6B                ; $8AAA: 85 6B   
    DEY                      ; $8AAC: 88      
    LDA   ($24),Y            ; $8AAD: B1 24   
    STA   $6A                ; $8AAF: 85 6A   
    LDA   $63                ; $8AB1: A5 63   
    RTS                      ; $8AB3: 60      
    STA   $24                ; $8AB4: 85 24   
    STY   $25                ; $8AB6: 84 25   
    LDA   $FF00              ; $8AB8: AD 00 FF (MMU_CR_TOP)
    PHA                      ; $8ABB: 48      
    LDY   #$04               ; $8ABC: A0 04   
    JSR   $03B7              ; $8ABE: 20 B7 03
    STA   $6E                ; $8AC1: 85 6E   
    DEY                      ; $8AC3: 88      
    JSR   $03B7              ; $8AC4: 20 B7 03
    STA   $6D                ; $8AC7: 85 6D   
    DEY                      ; $8AC9: 88      
    JSR   $03B7              ; $8ACA: 20 B7 03
    STA   $6C                ; $8ACD: 85 6C   
    DEY                      ; $8ACF: 88      
    JSR   $03B7              ; $8AD0: 20 B7 03
    STA   $6F                ; $8AD3: 85 6F   
    EOR   $68                ; $8AD5: 45 68   
    STA   $70                ; $8AD7: 85 70   
    LDA   $6F                ; $8AD9: A5 6F   
    ORA   #$80               ; $8ADB: 09 80   
    STA   $6B                ; $8ADD: 85 6B   
    DEY                      ; $8ADF: 88      
    JSR   $03B7              ; $8AE0: 20 B7 03
    STA   $6A                ; $8AE3: 85 6A   
    PLA                      ; $8AE5: 68      
    STA   $FF00              ; $8AE6: 8D 00 FF (MMU_CR_TOP)
    LDA   $63                ; $8AE9: A5 63   
    RTS                      ; $8AEB: 60      
    LDA   $6A                ; $8AEC: A5 6A   
    BEQ   $8B0F              ; $8AEE: F0 1F   
    CLC                      ; $8AF0: 18      
    ADC   $63                ; $8AF1: 65 63   
    BCC   $8AF9              ; $8AF3: 90 04   
    BMI   $8B14              ; $8AF5: 30 1D   
    CLC                      ; $8AF7: 18      
    BIT   $1410              ; $8AF8: 2C 10 14
    ADC   #$80               ; $8AFB: 69 80   
    STA   $63                ; $8AFD: 85 63   
    BNE   $8B04              ; $8AFF: D0 03   
    JMP   $88DA              ; $8B01: 4C DA 88
    LDA   $70                ; $8B04: A5 70   
    STA   $68                ; $8B06: 85 68   
    RTS                      ; $8B08: 60      
    LDA   $68                ; $8B09: A5 68   
    EOR   #$FF               ; $8B0B: 49 FF   
    BMI   $8B14              ; $8B0D: 30 05   
    PLA                      ; $8B0F: 68      
    PLA                      ; $8B10: 68      
    JMP   $88D6              ; $8B11: 4C D6 88
    JMP   $895D              ; $8B14: 4C 5D 89
    JSR   $8C38              ; $8B17: 20 38 8C
    TAX                      ; $8B1A: AA      
    BEQ   $8B2D              ; $8B1B: F0 10   
    CLC                      ; $8B1D: 18      
    ADC   #$02               ; $8B1E: 69 02   
    BCS   $8B14              ; $8B20: B0 F2   
    LDX   #$00               ; $8B22: A2 00   
    STX   $70                ; $8B24: 86 70   
    JSR   $8855              ; $8B26: 20 55 88
    INC   $63                ; $8B29: E6 63   
    BEQ   $8B14              ; $8B2B: F0 E7   
    RTS                      ; $8B2D: 60      
    STY   $20                ; $8B2E: 84 20   
    BRK                      ; $8B30: 00      
    BRK                      ; $8B31: 00      
    BRK                      ; $8B32: 00      
    LDX   #$14               ; $8B33: A2 14   
    JMP   $4D3C              ; $8B35: 4C 3C 4D (BASIC_ERROR_ENTRY)
    JSR   $8C38              ; $8B38: 20 38 8C
    LDA   #$2E               ; $8B3B: A9 2E   
    LDY   #$8B               ; $8B3D: A0 8B   
    LDX   #$00               ; $8B3F: A2 00   
    STX   $70                ; $8B41: 86 70   
    JSR   $8BD4              ; $8B43: 20 D4 8B
    JMP   $8B4C              ; $8B46: 4C 4C 8B (CMD__)
    JSR   $8AB4              ; $8B49: 20 B4 8A
CMD__:
    BEQ   $8B33              ; $8B4C: F0 E5   
    JSR   $8C47              ; $8B4E: 20 47 8C
    LDA   #$00               ; $8B51: A9 00   
    SEC                      ; $8B53: 38      
    SBC   $63                ; $8B54: E5 63   
    STA   $63                ; $8B56: 85 63   
    JSR   $8AEC              ; $8B58: 20 EC 8A
    INC   $63                ; $8B5B: E6 63   
    BEQ   $8B14              ; $8B5D: F0 B5   
    LDX   #$FC               ; $8B5F: A2 FC   
    LDA   #$01               ; $8B61: A9 01   
    LDY   $6B                ; $8B63: A4 6B   
    CPY   $64                ; $8B65: C4 64   
    BNE   $8B79              ; $8B67: D0 10   
    LDY   $6C                ; $8B69: A4 6C   
    CPY   $65                ; $8B6B: C4 65   
    BNE   $8B79              ; $8B6D: D0 0A   
    LDY   $6D                ; $8B6F: A4 6D   
    CPY   $66                ; $8B71: C4 66   
    BNE   $8B79              ; $8B73: D0 04   
    LDY   $6E                ; $8B75: A4 6E   
    CPY   $67                ; $8B77: C4 67   
    PHP                      ; $8B79: 08      
    ROL   A                  ; $8B7A: 2A      
    BCC   $8B86              ; $8B7B: 90 09   
    INX                      ; $8B7D: E8      
    STA   $2B,X              ; $8B7E: 95 2B   
    BEQ   $8BB4              ; $8B80: F0 32   
    BPL   $8BB8              ; $8B82: 10 34   
    LDA   #$01               ; $8B84: A9 01   
    PLP                      ; $8B86: 28      
    BCS   $8B97              ; $8B87: B0 0E   
    ASL   $6E                ; $8B89: 06 6E   
    ROL   $6D                ; $8B8B: 26 6D   
    ROL   $6C                ; $8B8D: 26 6C   
    ROL   $6B                ; $8B8F: 26 6B   
    BCS   $8B79              ; $8B91: B0 E6   
    BMI   $8B63              ; $8B93: 30 CE   
    BPL   $8B79              ; $8B95: 10 E2   
    TAY                      ; $8B97: A8      
    LDA   $6E                ; $8B98: A5 6E   
    SBC   $67                ; $8B9A: E5 67   
    STA   $6E                ; $8B9C: 85 6E   
    LDA   $6D                ; $8B9E: A5 6D   
    SBC   $66                ; $8BA0: E5 66   
    STA   $6D                ; $8BA2: 85 6D   
    LDA   $6C                ; $8BA4: A5 6C   
    SBC   $65                ; $8BA6: E5 65   
    STA   $6C                ; $8BA8: 85 6C   
    LDA   $6B                ; $8BAA: A5 6B   
    SBC   $64                ; $8BAC: E5 64   
    STA   $6B                ; $8BAE: 85 6B   
    TYA                      ; $8BB0: 98      
    JMP   $8B89              ; $8BB1: 4C 89 8B
    LDA   #$40               ; $8BB4: A9 40   
    BNE   $8B86              ; $8BB6: D0 CE   
    ASL   A                  ; $8BB8: 0A      
    ASL   A                  ; $8BB9: 0A      
    ASL   A                  ; $8BBA: 0A      
    ASL   A                  ; $8BBB: 0A      
    ASL   A                  ; $8BBC: 0A      
    ASL   A                  ; $8BBD: 0A      
    STA   $71                ; $8BBE: 85 71   
    PLP                      ; $8BC0: 28      
    LDA   $28                ; $8BC1: A5 28   
    STA   $64                ; $8BC3: 85 64   
    LDA   $29                ; $8BC5: A5 29   
    STA   $65                ; $8BC7: 85 65   
    LDA   $2A                ; $8BC9: A5 2A   
    STA   $66                ; $8BCB: 85 66   
    LDA   $2B                ; $8BCD: A5 2B   
    STA   $67                ; $8BCF: 85 67   
    JMP   $88B6              ; $8BD1: 4C B6 88
    STA   $24                ; $8BD4: 85 24   
    STY   $25                ; $8BD6: 84 25   
    LDY   #$04               ; $8BD8: A0 04   
    LDA   ($24),Y            ; $8BDA: B1 24   
    STA   $67                ; $8BDC: 85 67   
    DEY                      ; $8BDE: 88      
    LDA   ($24),Y            ; $8BDF: B1 24   
    STA   $66                ; $8BE1: 85 66   
    DEY                      ; $8BE3: 88      
    LDA   ($24),Y            ; $8BE4: B1 24   
    STA   $65                ; $8BE6: 85 65   
    DEY                      ; $8BE8: 88      
    LDA   ($24),Y            ; $8BE9: B1 24   
    STA   $68                ; $8BEB: 85 68   
    ORA   #$80               ; $8BED: 09 80   
    STA   $64                ; $8BEF: 85 64   
    DEY                      ; $8BF1: 88      
    LDA   ($24),Y            ; $8BF2: B1 24   
    STA   $63                ; $8BF4: 85 63   
    STY   $71                ; $8BF6: 84 71   
    RTS                      ; $8BF8: 60      
    LDX   #$5E               ; $8BF9: A2 5E   
    BIT   $59A2              ; $8BFB: 2C A2 59
    LDY   #$00               ; $8BFE: A0 00   
    JSR   $8C47              ; $8C00: 20 47 8C
    STX   $24                ; $8C03: 86 24   
    STY   $25                ; $8C05: 84 25   
    LDY   #$04               ; $8C07: A0 04   
    LDA   $67                ; $8C09: A5 67   
    STA   ($24),Y            ; $8C0B: 91 24   
    DEY                      ; $8C0D: 88      
    LDA   $66                ; $8C0E: A5 66   
    STA   ($24),Y            ; $8C10: 91 24   
    DEY                      ; $8C12: 88      
    LDA   $65                ; $8C13: A5 65   
    STA   ($24),Y            ; $8C15: 91 24   
    DEY                      ; $8C17: 88      
    LDA   $68                ; $8C18: A5 68   
    ORA   #$7F               ; $8C1A: 09 7F   
    AND   $64                ; $8C1C: 25 64   
    STA   ($24),Y            ; $8C1E: 91 24   
    DEY                      ; $8C20: 88      
    LDA   $63                ; $8C21: A5 63   
    STA   ($24),Y            ; $8C23: 91 24   
    STY   $71                ; $8C25: 84 71   
    RTS                      ; $8C27: 60      
    LDA   $6F                ; $8C28: A5 6F   
    STA   $68                ; $8C2A: 85 68   
    LDX   #$05               ; $8C2C: A2 05   
    LDA   $69,X              ; $8C2E: B5 69   
    STA   $62,X              ; $8C30: 95 62   
    DEX                      ; $8C32: CA      
    BNE   $8C2E              ; $8C33: D0 F9   
    STX   $71                ; $8C35: 86 71   
    RTS                      ; $8C37: 60      
    JSR   $8C47              ; $8C38: 20 47 8C
    LDX   #$06               ; $8C3B: A2 06   
    LDA   $62,X              ; $8C3D: B5 62   
    STA   $69,X              ; $8C3F: 95 69   
    DEX                      ; $8C41: CA      
    BNE   $8C3D              ; $8C42: D0 F9   
    STX   $71                ; $8C44: 86 71   
    RTS                      ; $8C46: 60      
    LDA   $63                ; $8C47: A5 63   
    BEQ   $8C46              ; $8C49: F0 FB   
    ASL   $71                ; $8C4B: 06 71   
    BCC   $8C46              ; $8C4D: 90 F7   
    JSR   $894E              ; $8C4F: 20 4E 89
    BNE   $8C46              ; $8C52: D0 F2   
    JMP   $8917              ; $8C54: 4C 17 89
    LDA   $63                ; $8C57: A5 63   
    BEQ   $8C64              ; $8C59: F0 09   
    LDA   $68                ; $8C5B: A5 68   
    ROL   A                  ; $8C5D: 2A      
    LDA   #$FF               ; $8C5E: A9 FF   
    BCS   $8C64              ; $8C60: B0 02   
    LDA   #$01               ; $8C62: A9 01   
    RTS                      ; $8C64: 60      
CMD_SGN:
    JSR   $8C57              ; $8C65: 20 57 8C
    STA   $64                ; $8C68: 85 64   
    LDA   #$00               ; $8C6A: A9 00   
    STA   $65                ; $8C6C: 85 65   
    LDX   #$88               ; $8C6E: A2 88   
    LDA   $64                ; $8C70: A5 64   
    EOR   #$FF               ; $8C72: 49 FF   
    ROL   A                  ; $8C74: 2A      
    LDA   #$00               ; $8C75: A9 00   
    STA   $67                ; $8C77: 85 67   
    STA   $66                ; $8C79: 85 66   
    STX   $63                ; $8C7B: 86 63   
    STA   $71                ; $8C7D: 85 71   
    STA   $68                ; $8C7F: 85 68   
    JMP   $88B1              ; $8C81: 4C B1 88
CMD_ABS:
    LSR   $68                ; $8C84: 46 68   
    RTS                      ; $8C86: 60      
    STA   $26                ; $8C87: 85 26   
    STY   $27                ; $8C89: 84 27   
    LDY   #$00               ; $8C8B: A0 00   
    LDA   ($26),Y            ; $8C8D: B1 26   
    INY                      ; $8C8F: C8      
    TAX                      ; $8C90: AA      
    BEQ   $8C57              ; $8C91: F0 C4   
    LDA   ($26),Y            ; $8C93: B1 26   
    EOR   $68                ; $8C95: 45 68   
    BMI   $8C5B              ; $8C97: 30 C2   
    CPX   $63                ; $8C99: E4 63   
    BNE   $8CBE              ; $8C9B: D0 21   
    LDA   ($26),Y            ; $8C9D: B1 26   
    ORA   #$80               ; $8C9F: 09 80   
    CMP   $64                ; $8CA1: C5 64   
    BNE   $8CBE              ; $8CA3: D0 19   
    INY                      ; $8CA5: C8      
    LDA   ($26),Y            ; $8CA6: B1 26   
    CMP   $65                ; $8CA8: C5 65   
    BNE   $8CBE              ; $8CAA: D0 12   
    INY                      ; $8CAC: C8      
    LDA   ($26),Y            ; $8CAD: B1 26   
    CMP   $66                ; $8CAF: C5 66   
    BNE   $8CBE              ; $8CB1: D0 0B   
    INY                      ; $8CB3: C8      
    LDA   #$7F               ; $8CB4: A9 7F   
    CMP   $71                ; $8CB6: C5 71   
    LDA   ($26),Y            ; $8CB8: B1 26   
    SBC   $67                ; $8CBA: E5 67   
    BEQ   $8CE8              ; $8CBC: F0 2A   
    LDA   $68                ; $8CBE: A5 68   
    BCC   $8CC4              ; $8CC0: 90 02   
    EOR   #$FF               ; $8CC2: 49 FF   
    JMP   $8C5D              ; $8CC4: 4C 5D 8C
    LDA   $63                ; $8CC7: A5 63   
    BEQ   $8D18              ; $8CC9: F0 4D   
    SEC                      ; $8CCB: 38      
    SBC   #$A0               ; $8CCC: E9 A0   
    BIT   $68                ; $8CCE: 24 68   
    BPL   $8CDC              ; $8CD0: 10 0A   
    TAX                      ; $8CD2: AA      
    LDA   #$FF               ; $8CD3: A9 FF   
    STA   $03DF              ; $8CD5: 8D DF 03
    JSR   $892C              ; $8CD8: 20 2C 89
    TXA                      ; $8CDB: 8A      
    LDX   #$63               ; $8CDC: A2 63   
    CMP   #$F9               ; $8CDE: C9 F9   
    BPL   $8CE9              ; $8CE0: 10 07   
    JSR   $8979              ; $8CE2: 20 79 89
    STY   $03DF              ; $8CE5: 8C DF 03
    RTS                      ; $8CE8: 60      
    TAY                      ; $8CE9: A8      
    LDA   $68                ; $8CEA: A5 68   
    AND   #$80               ; $8CEC: 29 80   
    LSR   $64                ; $8CEE: 46 64   
    ORA   $64                ; $8CF0: 05 64   
    STA   $64                ; $8CF2: 85 64   
    JSR   $8990              ; $8CF4: 20 90 89
    STY   $03DF              ; $8CF7: 8C DF 03
    RTS                      ; $8CFA: 60      
CMD_INT:
    LDA   $63                ; $8CFB: A5 63   
    CMP   #$A0               ; $8CFD: C9 A0   
    BCS   $8D21              ; $8CFF: B0 20   
    JSR   $AA68              ; $8D01: 20 68 AA
    STY   $71                ; $8D04: 84 71   
    LDA   $68                ; $8D06: A5 68   
    STY   $68                ; $8D08: 84 68   
    EOR   #$80               ; $8D0A: 49 80   
    ROL   A                  ; $8D0C: 2A      
    LDA   #$A0               ; $8D0D: A9 A0   
    STA   $63                ; $8D0F: 85 63   
    LDA   $67                ; $8D11: A5 67   
    STA   $09                ; $8D13: 85 09   
    JMP   $88B1              ; $8D15: 4C B1 88
    STA   $64                ; $8D18: 85 64   
    STA   $65                ; $8D1A: 85 65   
    STA   $66                ; $8D1C: 85 66   
    STA   $67                ; $8D1E: 85 67   
    TAY                      ; $8D20: A8      
    RTS                      ; $8D21: 60      
    STX   $03DA              ; $8D22: 8E DA 03
    LDY   #$00               ; $8D25: A0 00   
    LDX   #$0A               ; $8D27: A2 0A   
    STY   $5F,X              ; $8D29: 94 5F   
    DEX                      ; $8D2B: CA      
    BPL   $8D29              ; $8D2C: 10 FB   
    BCC   $8D3F              ; $8D2E: 90 0F   
    CMP   #$2D               ; $8D30: C9 2D   
    BNE   $8D38              ; $8D32: D0 04   
    STX   $69                ; $8D34: 86 69   
    BEQ   $8D3C              ; $8D36: F0 04   
    CMP   #$2B               ; $8D38: C9 2B   
    BNE   $8D41              ; $8D3A: D0 05   
    JSR   $8DF5              ; $8D3C: 20 F5 8D
    BCC   $8D9C              ; $8D3F: 90 5B   
    CMP   #$2E               ; $8D41: C9 2E   
    BEQ   $8D73              ; $8D43: F0 2E   
    CMP   #$45               ; $8D45: C9 45   
    BNE   $8D79              ; $8D47: D0 30   
    JSR   $8DF5              ; $8D49: 20 F5 8D
    BCC   $8D65              ; $8D4C: 90 17   
    CMP   #$AB               ; $8D4E: C9 AB   
    BEQ   $8D60              ; $8D50: F0 0E   
    CMP   #$2D               ; $8D52: C9 2D   
    BEQ   $8D60              ; $8D54: F0 0A   
    CMP   #$AA               ; $8D56: C9 AA   
    BEQ   $8D62              ; $8D58: F0 08   
    CMP   #$2B               ; $8D5A: C9 2B   
    BEQ   $8D62              ; $8D5C: F0 04   
    BNE   $8D67              ; $8D5E: D0 07   
    ROR   $62                ; $8D60: 66 62   
    JSR   $8DF5              ; $8D62: 20 F5 8D
    BCC   $8DC3              ; $8D65: 90 5C   
    BIT   $62                ; $8D67: 24 62   
    BPL   $8D79              ; $8D69: 10 0E   
    LDA   #$00               ; $8D6B: A9 00   
    SEC                      ; $8D6D: 38      
    SBC   $60                ; $8D6E: E5 60   
    JMP   $8D7B              ; $8D70: 4C 7B 8D
    ROR   $61                ; $8D73: 66 61   
    BIT   $61                ; $8D75: 24 61   
    BVC   $8D3C              ; $8D77: 50 C3   
    LDA   $60                ; $8D79: A5 60   
    SEC                      ; $8D7B: 38      
    SBC   $5F                ; $8D7C: E5 5F   
    STA   $60                ; $8D7E: 85 60   
    BEQ   $8D94              ; $8D80: F0 12   
    BPL   $8D8D              ; $8D82: 10 09   
    JSR   $8B38              ; $8D84: 20 38 8B
    INC   $60                ; $8D87: E6 60   
    BNE   $8D84              ; $8D89: D0 F9   
    BEQ   $8D94              ; $8D8B: F0 07   
    JSR   $8B17              ; $8D8D: 20 17 8B
    DEC   $60                ; $8D90: C6 60   
    BNE   $8D8D              ; $8D92: D0 F9   
    LDA   $69                ; $8D94: A5 69   
    BMI   $8D99              ; $8D96: 30 01   
    RTS                      ; $8D98: 60      
    JMP   $8FFA              ; $8D99: 4C FA 8F
    PHA                      ; $8D9C: 48      
    BIT   $61                ; $8D9D: 24 61   
    BPL   $8DA3              ; $8D9F: 10 02   
    INC   $5F                ; $8DA1: E6 5F   
    JSR   $8B17              ; $8DA3: 20 17 8B
    PLA                      ; $8DA6: 68      
    SEC                      ; $8DA7: 38      
    SBC   #$30               ; $8DA8: E9 30   
    JSR   $8DB0              ; $8DAA: 20 B0 8D
    JMP   $8D3C              ; $8DAD: 4C 3C 8D
    PHA                      ; $8DB0: 48      
    JSR   $8C38              ; $8DB1: 20 38 8C
    PLA                      ; $8DB4: 68      
    JSR   $8C68              ; $8DB5: 20 68 8C
    LDA   $6F                ; $8DB8: A5 6F   
    EOR   $68                ; $8DBA: 45 68   
    STA   $70                ; $8DBC: 85 70   
    LDX   $63                ; $8DBE: A6 63   
    JMP   $8848              ; $8DC0: 4C 48 88 (CMD__)
    LDA   $60                ; $8DC3: A5 60   
    CMP   #$0A               ; $8DC5: C9 0A   
    BCC   $8DD2              ; $8DC7: 90 09   
    LDA   #$64               ; $8DC9: A9 64   
    BIT   $62                ; $8DCB: 24 62   
    BMI   $8DF0              ; $8DCD: 30 21   
    JMP   $895D              ; $8DCF: 4C 5D 89
    ASL   A                  ; $8DD2: 0A      
    ASL   A                  ; $8DD3: 0A      
    CLC                      ; $8DD4: 18      
    ADC   $60                ; $8DD5: 65 60   
    ASL   A                  ; $8DD7: 0A      
    CLC                      ; $8DD8: 18      
    LDY   #$00               ; $8DD9: A0 00   
    STA   $79                ; $8DDB: 85 79   
    LDA   $03DA              ; $8DDD: AD DA 03
    BNE   $8DE8              ; $8DE0: D0 06   
    JSR   $03C9              ; $8DE2: 20 C9 03
    JMP   $8DEB              ; $8DE5: 4C EB 8D
    JSR   $03B7              ; $8DE8: 20 B7 03
    ADC   $79                ; $8DEB: 65 79   
    SEC                      ; $8DED: 38      
    SBC   #$30               ; $8DEE: E9 30   
    STA   $60                ; $8DF0: 85 60   
    JMP   $8D62              ; $8DF2: 4C 62 8D
    LDA   $03DA              ; $8DF5: AD DA 03
    BNE   $8DFD              ; $8DF8: D0 03   
    JMP   $0380              ; $8DFA: 4C 80 03
    INC   $24                ; $8DFD: E6 24   
    BNE   $8E03              ; $8DFF: D0 02   
    INC   $25                ; $8E01: E6 25   
    LDY   #$00               ; $8E03: A0 00   
    JSR   $03B7              ; $8E05: 20 B7 03
    CMP   #$3A               ; $8E08: C9 3A   
    BCS   $8E16              ; $8E0A: B0 0A   
    CMP   #$20               ; $8E0C: C9 20   
    BEQ   $8DFD              ; $8E0E: F0 ED   
    SEC                      ; $8E10: 38      
    SBC   #$30               ; $8E11: E9 30   
; --- [DATA] Floating-Point Powers-of-10 Table (FOUT Constants) ($8E13-$8E31) ---
    .BYTE $38, $E9, $D0, $60, $9B, $3E, $BC, $1F ; $8E13 [IDENTIFIED_DATA] |8..`.>..|
    .BYTE $FD, $9E, $6E, $6B, $27, $FD, $9E, $6E ; $8E1B [IDENTIFIED_DATA] |..nk'..n|
    .BYTE $6B, $28, $00, $20, $81, $92, $20, $49 ; $8E23 [IDENTIFIED_DATA] |k(. .. I|
    .BYTE $4E, $20, $00, $A5, $3C, $A6, $3B      ; $8E2B [IDENTIFIED_DATA] |N ..<.;|
    STA   $64                ; $8E32: 85 64   
    STX   $65                ; $8E34: 86 65   
    LDX   #$90               ; $8E36: A2 90   
    SEC                      ; $8E38: 38      
    JSR   $8C75              ; $8E39: 20 75 8C
    JSR   $8E44              ; $8E3C: 20 44 8E
    JMP   $55E2              ; $8E3F: 4C E2 55
    LDY   #$01               ; $8E42: A0 01   
    LDA   #$20               ; $8E44: A9 20   
    BIT   $68                ; $8E46: 24 68   
    BPL   $8E4C              ; $8E48: 10 02   
    LDA   #$2D               ; $8E4A: A9 2D   
    STA.W $00FF,Y            ; $8E4C: 99 FF 00
    STA   $68                ; $8E4F: 85 68   
    STY   $72                ; $8E51: 84 72   
    INY                      ; $8E53: C8      
    LDA   #$30               ; $8E54: A9 30   
    LDX   $63                ; $8E56: A6 63   
    BNE   $8E5D              ; $8E58: D0 03   
    JMP   $8F69              ; $8E5A: 4C 69 8F
    LDA   #$00               ; $8E5D: A9 00   
    CPX   #$80               ; $8E5F: E0 80   
    BEQ   $8E65              ; $8E61: F0 02   
    BCS   $8E6E              ; $8E63: B0 09   
    LDA   #$21               ; $8E65: A9 21   
    LDY   #$8E               ; $8E67: A0 8E   
    JSR   $8A08              ; $8E69: 20 08 8A
    LDA   #$F7               ; $8E6C: A9 F7   
    STA   $5F                ; $8E6E: 85 5F   
    LDA   #$1C               ; $8E70: A9 1C   
    LDY   #$8E               ; $8E72: A0 8E   
    JSR   $8C87              ; $8E74: 20 87 8C
    BEQ   $8E97              ; $8E77: F0 1E   
    BPL   $8E8D              ; $8E79: 10 12   
    LDA   #$17               ; $8E7B: A9 17   
    LDY   #$8E               ; $8E7D: A0 8E   
    JSR   $8C87              ; $8E7F: 20 87 8C
    BEQ   $8E86              ; $8E82: F0 02   
    BPL   $8E94              ; $8E84: 10 0E   
    JSR   $8B17              ; $8E86: 20 17 8B
    DEC   $5F                ; $8E89: C6 5F   
    BNE   $8E7B              ; $8E8B: D0 EE   
    JSR   $8B38              ; $8E8D: 20 38 8B
    INC   $5F                ; $8E90: E6 5F   
    BNE   $8E70              ; $8E92: D0 DC   
    JSR   $8A0E              ; $8E94: 20 0E 8A
    JSR   $8CC7              ; $8E97: 20 C7 8C
    LDX   #$01               ; $8E9A: A2 01   
    LDA   $5F                ; $8E9C: A5 5F   
    CLC                      ; $8E9E: 18      
    ADC   #$0A               ; $8E9F: 69 0A   
    BMI   $8EAC              ; $8EA1: 30 09   
    CMP   #$0B               ; $8EA3: C9 0B   
    BCS   $8EAD              ; $8EA5: B0 06   
    ADC   #$FF               ; $8EA7: 69 FF   
    TAX                      ; $8EA9: AA      
    LDA   #$02               ; $8EAA: A9 02   
    SEC                      ; $8EAC: 38      
    SBC   #$02               ; $8EAD: E9 02   
    STA   $60                ; $8EAF: 85 60   
    STX   $5F                ; $8EB1: 86 5F   
    TXA                      ; $8EB3: 8A      
    BEQ   $8EB8              ; $8EB4: F0 02   
    BPL   $8ECB              ; $8EB6: 10 13   
    LDY   $72                ; $8EB8: A4 72   
    LDA   #$2E               ; $8EBA: A9 2E   
    INY                      ; $8EBC: C8      
    STA.W $00FF,Y            ; $8EBD: 99 FF 00
    TXA                      ; $8EC0: 8A      
    BEQ   $8EC9              ; $8EC1: F0 06   
    LDA   #$30               ; $8EC3: A9 30   
    INY                      ; $8EC5: C8      
    STA.W $00FF,Y            ; $8EC6: 99 FF 00
    STY   $72                ; $8EC9: 84 72   
    LDY   #$00               ; $8ECB: A0 00   
    LDX   #$80               ; $8ECD: A2 80   
    LDA   $67                ; $8ECF: A5 67   
    CLC                      ; $8ED1: 18      
    ADC   $8F7E,Y            ; $8ED2: 79 7E 8F
    STA   $67                ; $8ED5: 85 67   
    LDA   $66                ; $8ED7: A5 66   
    ADC   $8F7D,Y            ; $8ED9: 79 7D 8F
    STA   $66                ; $8EDC: 85 66   
    LDA   $65                ; $8EDE: A5 65   
    ADC   $8F7C,Y            ; $8EE0: 79 7C 8F
    STA   $65                ; $8EE3: 85 65   
    LDA   $64                ; $8EE5: A5 64   
    ADC   $8F7B,Y            ; $8EE7: 79 7B 8F
    STA   $64                ; $8EEA: 85 64   
    INX                      ; $8EEC: E8      
    BCS   $8EF3              ; $8EED: B0 04   
    BPL   $8ECF              ; $8EEF: 10 DE   
    BMI   $8EF5              ; $8EF1: 30 02   
    BMI   $8ECF              ; $8EF3: 30 DA   
    TXA                      ; $8EF5: 8A      
    BCC   $8EFC              ; $8EF6: 90 04   
    EOR   #$FF               ; $8EF8: 49 FF   
    ADC   #$0A               ; $8EFA: 69 0A   
    ADC   #$2F               ; $8EFC: 69 2F   
    INY                      ; $8EFE: C8      
    INY                      ; $8EFF: C8      
    INY                      ; $8F00: C8      
    INY                      ; $8F01: C8      
    STY   $49                ; $8F02: 84 49   
    LDY   $72                ; $8F04: A4 72   
    INY                      ; $8F06: C8      
    TAX                      ; $8F07: AA      
    AND   #$7F               ; $8F08: 29 7F   
    STA.W $00FF,Y            ; $8F0A: 99 FF 00
    DEC   $5F                ; $8F0D: C6 5F   
    BNE   $8F17              ; $8F0F: D0 06   
    LDA   #$2E               ; $8F11: A9 2E   
    INY                      ; $8F13: C8      
    STA.W $00FF,Y            ; $8F14: 99 FF 00
    STY   $72                ; $8F17: 84 72   
    LDY   $49                ; $8F19: A4 49   
    TXA                      ; $8F1B: 8A      
    EOR   #$FF               ; $8F1C: 49 FF   
    AND   #$80               ; $8F1E: 29 80   
    TAX                      ; $8F20: AA      
    CPY   #$24               ; $8F21: C0 24   
    BEQ   $8F29              ; $8F23: F0 04   
    CPY   #$3C               ; $8F25: C0 3C   
    BNE   $8ECF              ; $8F27: D0 A6   
    LDY   $72                ; $8F29: A4 72   
    LDA.W $00FF,Y            ; $8F2B: B9 FF 00
    DEY                      ; $8F2E: 88      
    CMP   #$30               ; $8F2F: C9 30   
    BEQ   $8F2B              ; $8F31: F0 F8   
    CMP   #$2E               ; $8F33: C9 2E   
    BEQ   $8F38              ; $8F35: F0 01   
    INY                      ; $8F37: C8      
    LDA   #$2B               ; $8F38: A9 2B   
    LDX   $60                ; $8F3A: A6 60   
    BEQ   $8F6C              ; $8F3C: F0 2E   
    BPL   $8F48              ; $8F3E: 10 08   
    LDA   #$00               ; $8F40: A9 00   
    SEC                      ; $8F42: 38      
    SBC   $60                ; $8F43: E5 60   
    TAX                      ; $8F45: AA      
    LDA   #$2D               ; $8F46: A9 2D   
    STA   $0101,Y            ; $8F48: 99 01 01
    LDA   #$45               ; $8F4B: A9 45   
    STA   $0100,Y            ; $8F4D: 99 00 01
    TXA                      ; $8F50: 8A      
    LDX   #$2F               ; $8F51: A2 2F   
    SEC                      ; $8F53: 38      
    INX                      ; $8F54: E8      
    SBC   #$0A               ; $8F55: E9 0A   
    BCS   $8F54              ; $8F57: B0 FB   
    ADC   #$3A               ; $8F59: 69 3A   
    STA   $0103,Y            ; $8F5B: 99 03 01
    TXA                      ; $8F5E: 8A      
    STA   $0102,Y            ; $8F5F: 99 02 01
    LDA   #$00               ; $8F62: A9 00   
    STA   $0104,Y            ; $8F64: 99 04 01
    BEQ   $8F71              ; $8F67: F0 08   
    STA.W $00FF,Y            ; $8F69: 99 FF 00
    LDA   #$00               ; $8F6C: A9 00   
    STA   $0100,Y            ; $8F6E: 99 00 01
    LDA   #$00               ; $8F71: A9 00   
    LDY   #$01               ; $8F73: A0 01   
    RTS                      ; $8F75: 60      
    .BYTE $80                                ; $8F76: 80 [UNRESOLVED]
    BRK                      ; $8F77: 00      
    BRK                      ; $8F78: 00      
    BRK                      ; $8F79: 00      
    BRK                      ; $8F7A: 00      
    .BYTE $FA                                ; $8F7B: FA [UNRESOLVED]
    ASL   A                  ; $8F7C: 0A      
    .BYTE $1F                                ; $8F7D: 1F [UNRESOLVED]
    BRK                      ; $8F7E: 00      
    BRK                      ; $8F7F: 00      
    TYA                      ; $8F80: 98      
    STX   $80,Y              ; $8F81: 96 80   
    .BYTE $FF                                ; $8F83: FF [UNRESOLVED]
    BEQ   $8F43              ; $8F84: F0 BD   
    CPY   #$00               ; $8F86: C0 00   
    ORA   ($86,X)            ; $8F88: 01 86   
; --- [DATA] Floating-Point LOG / SQR Series Polynomial Constants ($8F8A-$8FC0) ---
    .BYTE $A0, $FF, $FF, $D8, $F0, $00, $00, $03 ; $8F8A [IDENTIFIED_DATA] |........|
    .BYTE $E8, $FF, $FF, $FF, $9C, $00, $00, $00 ; $8F92 [IDENTIFIED_DATA] |........|
    .BYTE $0A, $FF, $FF, $FF, $FF, $FF, $DF, $0A ; $8F9A [IDENTIFIED_DATA] |........|
    .BYTE $80, $00, $03, $4B, $C0, $FF, $FF, $73 ; $8FA2 [IDENTIFIED_DATA] |...K...s|
    .BYTE $60, $00, $00, $0E, $10, $FF, $FF, $FD ; $8FAA [IDENTIFIED_DATA] |`.......|
    .BYTE $A8, $00, $00, $00, $3C, $20, $38, $8C ; $8FB2 [IDENTIFIED_DATA] |....< 8.|
    .BYTE $A9, $76, $A0, $8F, $20, $D4, $8B      ; $8FBA [IDENTIFIED_DATA] |.v.. ..|
CMD__:
    BEQ   $9033              ; $8FC1: F0 70    (CMD_EXP)
    LDA   $6A                ; $8FC3: A5 6A   
    BNE   $8FCA              ; $8FC5: D0 03   
    JMP   $88D8              ; $8FC7: 4C D8 88
    LDX   #$50               ; $8FCA: A2 50   
    LDY   #$00               ; $8FCC: A0 00   
    JSR   $8C00              ; $8FCE: 20 00 8C
    LDA   $6F                ; $8FD1: A5 6F   
    BPL   $8FE4              ; $8FD3: 10 0F   
    JSR   $8CFB              ; $8FD5: 20 FB 8C (CMD_INT)
    LDA   #$50               ; $8FD8: A9 50   
    LDY   #$00               ; $8FDA: A0 00   
    JSR   $8C87              ; $8FDC: 20 87 8C
    BNE   $8FE4              ; $8FDF: D0 03   
    TYA                      ; $8FE1: 98      
    LDY   $09                ; $8FE2: A4 09   
    JSR   $8C2A              ; $8FE4: 20 2A 8C
    TYA                      ; $8FE7: 98      
    PHA                      ; $8FE8: 48      
    JSR   $89CA              ; $8FE9: 20 CA 89 (CMD_LOG)
    LDA   #$50               ; $8FEC: A9 50   
    LDY   #$00               ; $8FEE: A0 00   
    JSR   $8A24              ; $8FF0: 20 24 8A
    JSR   $9033              ; $8FF3: 20 33 90 (CMD_EXP)
    PLA                      ; $8FF6: 68      
    LSR   A                  ; $8FF7: 4A      
    BCC   $9004              ; $8FF8: 90 0A   
    LDA   $63                ; $8FFA: A5 63   
    BEQ   $9004              ; $8FFC: F0 06   
    LDA   $68                ; $8FFE: A5 68   
    EOR   #$FF               ; $9000: 49 FF   
    STA   $68                ; $9002: 85 68   
    RTS                      ; $9004: 60      
    STA   ($38,X)            ; $9005: 81 38   
    TAX                      ; $9007: AA      
    .BYTE $3B                                ; $9008: 3B [UNRESOLVED]
    AND   #$07               ; $9009: 29 07   
    ADC   ($34),Y            ; $900B: 71 34   
    CLI                      ; $900D: 58      
    ROL   $7456,X            ; $900E: 3E 56 74
    ASL   $7E,X              ; $9011: 16 7E   
    .BYTE $B3                                ; $9013: B3 [UNRESOLVED]
    .BYTE $1B                                ; $9014: 1B [UNRESOLVED]
    .BYTE $77                                ; $9015: 77 [UNRESOLVED]
    .BYTE $2F                                ; $9016: 2F [UNRESOLVED]
    INC   $85E3              ; $9017: EE E3 85
    .BYTE $7A                                ; $901A: 7A [UNRESOLVED]
    ORA   $1C84,X            ; $901B: 1D 84 1C
    ROL   A                  ; $901E: 2A      
    .BYTE $7C                                ; $901F: 7C [UNRESOLVED]
    .BYTE $63                                ; $9020: 63 [UNRESOLVED]
    EOR   $0A58,Y            ; $9021: 59 58 0A
    ROR   $FD75,X            ; $9024: 7E 75 FD
    .BYTE $E7                                ; $9027: E7 [UNRESOLVED]
; --- [DATA] Floating-Point EXP Series Polynomial Constants ($9028-$907A) ---
    .BYTE $C6, $80, $31, $72, $18, $10, $81, $00 ; $9028 [IDENTIFIED_DATA] |..1r....|
    .BYTE $00, $00, $00, $A9, $05, $A0, $90, $20 ; $9030 [IDENTIFIED_DATA] |....... |
    .BYTE $08, $8A, $A5, $71, $69, $50, $90, $03 ; $9038 [IDENTIFIED_DATA] |...qiP..|
    .BYTE $20, $4F, $8C, $85, $58, $20, $3B, $8C ; $9040 [IDENTIFIED_DATA] | O..X ;.|
    .BYTE $A5, $63, $C9, $88, $90, $03, $20, $09 ; $9048 [IDENTIFIED_DATA] |.c.... .|
    .BYTE $8B, $20, $FB, $8C, $A5, $09, $18, $69 ; $9050 [IDENTIFIED_DATA] |. .....i|
    .BYTE $81, $F0, $F3, $38, $E9, $01, $48, $A2 ; $9058 [IDENTIFIED_DATA] |...8..H.|
    .BYTE $05, $B5, $6A, $B4, $63, $95, $63, $94 ; $9060 [IDENTIFIED_DATA] |..j.c.c.|
    .BYTE $6A, $CA, $10, $F5, $A5, $58, $85, $71 ; $9068 [IDENTIFIED_DATA] |j....X.q|
    .BYTE $20, $31, $88, $20, $FA, $8F, $A9, $0A ; $9070 [IDENTIFIED_DATA] | 1. ....|
    .BYTE $A0, $90, $20                          ; $9078 [IDENTIFIED_DATA] |.. |
    .BYTE $9C                                ; $907B: 9C [UNRESOLVED]
    BCC   $9027              ; $907C: 90 A9   
    BRK                      ; $907E: 00      
    STA   $70                ; $907F: 85 70   
    PLA                      ; $9081: 68      
    JSR   $8AEE              ; $9082: 20 EE 8A
    RTS                      ; $9085: 60      
    STA   $72                ; $9086: 85 72   
    STY   $73                ; $9088: 84 73   
    JSR   $8BFC              ; $908A: 20 FC 8B
    LDA   #$59               ; $908D: A9 59   
    JSR   $8A24              ; $908F: 20 24 8A
    JSR   $90A0              ; $9092: 20 A0 90
    LDA   #$59               ; $9095: A9 59   
    LDY   #$00               ; $9097: A0 00   
    JMP   $8A24              ; $9099: 4C 24 8A
    STA   $72                ; $909C: 85 72   
    STY   $73                ; $909E: 84 73   
    JSR   $8BF9              ; $90A0: 20 F9 8B
    LDA   ($72),Y            ; $90A3: B1 72   
    STA   $69                ; $90A5: 85 69   
    LDY   $72                ; $90A7: A4 72   
    INY                      ; $90A9: C8      
    TYA                      ; $90AA: 98      
    BNE   $90AF              ; $90AB: D0 02   
    INC   $73                ; $90AD: E6 73   
    STA   $72                ; $90AF: 85 72   
    LDY   $73                ; $90B1: A4 73   
    JSR   $8A08              ; $90B3: 20 08 8A
    LDA   $72                ; $90B6: A5 72   
    LDY   $73                ; $90B8: A4 73   
    CLC                      ; $90BA: 18      
    ADC   #$05               ; $90BB: 69 05   
    BCC   $90C0              ; $90BD: 90 01   
    INY                      ; $90BF: C8      
    STA   $72                ; $90C0: 85 72   
    STY   $73                ; $90C2: 84 73   
    JSR   $8A12              ; $90C4: 20 12 8A
    LDA   #$5E               ; $90C7: A9 5E   
    LDY   #$00               ; $90C9: A0 00   
    DEC   $69                ; $90CB: C6 69   
    BNE   $90B3              ; $90CD: D0 E4   
    RTS                      ; $90CF: 60      
    TAX                      ; $90D0: AA      
    BNE   $90D5              ; $90D1: D0 02   
    LDX   #$1E               ; $90D3: A2 1E   
    JMP   $4D3C              ; $90D5: 4C 3C 4D (BASIC_ERROR_ENTRY)
    JSR   $A845              ; $90D8: 20 45 A8
    JSR   $FFC0              ; $90DB: 20 C0 FF (J_OPEN)
    RTS                      ; $90DE: 60      
    JSR   $9269              ; $90DF: 20 69 92
    BCS   $90D0              ; $90E2: B0 EC   
    RTS                      ; $90E4: 60      
    JSR   $9263              ; $90E5: 20 63 92
    BCS   $90D0              ; $90E8: B0 E6   
    RTS                      ; $90EA: 60      
    PHA                      ; $90EB: 48      
    JSR   $A845              ; $90EC: 20 45 A8
    JSR   $FFC9              ; $90EF: 20 C9 FF (J_CHKOUT)
    JSR   $9243              ; $90F2: 20 43 92
    TAX                      ; $90F5: AA      
    PLA                      ; $90F6: 68      
    BCC   $90FC              ; $90F7: 90 03   
    TXA                      ; $90F9: 8A      
    BCS   $90D0              ; $90FA: B0 D4   
    RTS                      ; $90FC: 60      
    JSR   $A845              ; $90FD: 20 45 A8
; --- [DATA] Floating-Point SIN / COS / ATN Trigonometric Constants ($9100-$912A) ---
    .BYTE $20, $C6, $FF, $20, $43, $92, $B0, $C8 ; $9100 [IDENTIFIED_DATA] | .. C...|
    .BYTE $60, $20, $45, $A8, $20, $E4, $FF, $B0 ; $9108 [IDENTIFIED_DATA] |` E. ...|
    .BYTE $C2, $60, $20, $AE, $91, $AE, $10, $12 ; $9110 [IDENTIFIED_DATA] |.` .....|
    .BYTE $AC, $11, $12, $A9, $2D, $20, $45, $A8 ; $9118 [IDENTIFIED_DATA] |....- E.|
    .BYTE $20, $D8, $FF, $20, $43, $92, $B0, $A8 ; $9120 [IDENTIFIED_DATA] | .. C...|
    .BYTE $60, $A9, $01                          ; $9128 [IDENTIFIED_DATA] |`..|
    BIT.W $00A9              ; $912B: 2C A9 00
    STA   $0C                ; $912E: 85 0C   
    JSR   $91AE              ; $9130: 20 AE 91
    JSR   $A845              ; $9133: 20 45 A8
    LDA   $0C                ; $9136: A5 0C   
    LDX   $2D                ; $9138: A6 2D   
    LDY   $2E                ; $913A: A4 2E   
    JSR   $FFD5              ; $913C: 20 D5 FF (J_LOAD)
    PHP                      ; $913F: 08      
    JSR   $9243              ; $9140: 20 43 92
    PLP                      ; $9143: 28      
    BCS   $91AB              ; $9144: B0 65   
    LDA   $0C                ; $9146: A5 0C   
    BEQ   $9160              ; $9148: F0 16   
    LDX   #$1C               ; $914A: A2 1C   
    JSR   $9251              ; $914C: 20 51 92
    AND   #$10               ; $914F: 29 10   
    BNE   $9169              ; $9151: D0 16   
    BIT   $7F                ; $9153: 24 7F   
    BMI   $915F              ; $9155: 30 08   
    JSR   $9281              ; $9157: 20 81 92
    ORA   $4B4F              ; $915A: 0D 4F 4B
    ORA   $6000              ; $915D: 0D 00 60
    JSR   $9251              ; $9160: 20 51 92
    AND   #$BF               ; $9163: 29 BF   
    BEQ   $916C              ; $9165: F0 05   
    LDX   #$1D               ; $9167: A2 1D   
    JMP   $4D3C              ; $9169: 4C 3C 4D (BASIC_ERROR_ENTRY)
    STX   $1210              ; $916C: 8E 10 12
    STY   $1211              ; $916F: 8C 11 12
    BIT   $7F                ; $9172: 24 7F   
    BMI   $9184              ; $9174: 30 0E   
    BVS   $915F              ; $9176: 70 E7   
    JSR   $4D2A              ; $9178: 20 2A 4D
    JSR   $4F4F              ; $917B: 20 4F 4F
    JSR   $51F3              ; $917E: 20 F3 51
    JMP   $4DC3              ; $9181: 4C C3 4D
    JSR   $5254              ; $9184: 20 54 52
    JSR   $4F4F              ; $9187: 20 4F 4F
    JMP   $5235              ; $918A: 4C 35 52
CMD_OPEN:
    JSR   $91F6              ; $918D: 20 F6 91
    CLC                      ; $9190: 18      
    JSR   $90D8              ; $9191: 20 D8 90
    JSR   $9243              ; $9194: 20 43 92
    BCS   $91AB              ; $9197: B0 12   
    RTS                      ; $9199: 60      
CMD_CLOSE:
    JSR   $91F6              ; $919A: 20 F6 91
    JSR   $A845              ; $919D: 20 45 A8
    LDA   $4B                ; $91A0: A5 4B   
    CLC                      ; $91A2: 18      
    JSR   $9275              ; $91A3: 20 75 92
    JSR   $9243              ; $91A6: 20 43 92
    BCC   $915F              ; $91A9: 90 B4   
    JMP   $90D0              ; $91AB: 4C D0 90
    LDA   #$00               ; $91AE: A9 00   
    JSR   $925D              ; $91B0: 20 5D 92
    LDX   #$01               ; $91B3: A2 01   
    LDY   #$00               ; $91B5: A0 00   
    JSR   $9257              ; $91B7: 20 57 92
    JSR   $9287              ; $91BA: 20 87 92
    JSR   $91E3              ; $91BD: 20 E3 91
    JSR   $9239              ; $91C0: 20 39 92
    JSR   $91E3              ; $91C3: 20 E3 91
    JSR   $91DD              ; $91C6: 20 DD 91
    LDY   #$00               ; $91C9: A0 00   
    STX   $4B                ; $91CB: 86 4B   
    JSR   $9257              ; $91CD: 20 57 92
    JSR   $91E3              ; $91D0: 20 E3 91
    JSR   $91DD              ; $91D3: 20 DD 91
    TXA                      ; $91D6: 8A      
    TAY                      ; $91D7: A8      
    LDX   $4B                ; $91D8: A6 4B   
    JMP   $9257              ; $91DA: 4C 57 92
    JSR   $91EB              ; $91DD: 20 EB 91
    JMP   $87F4              ; $91E0: 4C F4 87
    JSR   $0386              ; $91E3: 20 86 03
    BNE   $91EA              ; $91E6: D0 02   
    PLA                      ; $91E8: 68      
    PLA                      ; $91E9: 68      
    RTS                      ; $91EA: 60      
    JSR   $795C              ; $91EB: 20 5C 79
    JSR   $0386              ; $91EE: 20 86 03
    BNE   $91EA              ; $91F1: D0 F7   
    JMP   $796C              ; $91F3: 4C 6C 79 (CMD_FE_BEGIN)
    LDA   #$00               ; $91F6: A9 00   
    LDX   #$01               ; $91F8: A2 01   
    JSR   $9287              ; $91FA: 20 87 92
    JSR   $925D              ; $91FD: 20 5D 92
    JSR   $91EE              ; $9200: 20 EE 91
    JSR   $87F4              ; $9203: 20 F4 87
    STX   $4B                ; $9206: 86 4B   
    TXA                      ; $9208: 8A      
    LDX   #$01               ; $9209: A2 01   
    LDY   #$00               ; $920B: A0 00   
    JSR   $9257              ; $920D: 20 57 92
    JSR   $91E3              ; $9210: 20 E3 91
    JSR   $91DD              ; $9213: 20 DD 91
    STX   $4C                ; $9216: 86 4C   
    LDY   #$00               ; $9218: A0 00   
    LDA   $4B                ; $921A: A5 4B   
    CPX   #$03               ; $921C: E0 03   
    BCC   $9221              ; $921E: 90 01   
    DEY                      ; $9220: 88      
    JSR   $9257              ; $9221: 20 57 92
    JSR   $91E3              ; $9224: 20 E3 91
    JSR   $91DD              ; $9227: 20 DD 91
    TXA                      ; $922A: 8A      
    TAY                      ; $922B: A8      
    LDX   $4C                ; $922C: A6 4C   
    LDA   $4B                ; $922E: A5 4B   
    JSR   $9257              ; $9230: 20 57 92
    JSR   $91E3              ; $9233: 20 E3 91
    JSR   $91EB              ; $9236: 20 EB 91
    JSR   $877B              ; $9239: 20 7B 87
    LDX   $24                ; $923C: A6 24   
    LDY   $25                ; $923E: A4 25   
    JMP   $925D              ; $9240: 4C 5D 92
    PHP                      ; $9243: 08      
    PHA                      ; $9244: 48      
    LDA   $BA                ; $9245: A5 BA   
    CMP   #$04               ; $9247: C9 04   
    BCC   $924E              ; $9249: 90 03   
    JSR   $A80D              ; $924B: 20 0D A8
    PLA                      ; $924E: 68      
    PLP                      ; $924F: 28      
    RTS                      ; $9250: 60      
    JSR   $A845              ; $9251: 20 45 A8
    JMP   $FFB7              ; $9254: 4C B7 FF (J_READST)
    JSR   $A845              ; $9257: 20 45 A8
    JMP   $FFBA              ; $925A: 4C BA FF (J_SETLFS)
    JSR   $A845              ; $925D: 20 45 A8
    JMP   $FFBD              ; $9260: 4C BD FF (J_SETNAM)
    JSR   $A845              ; $9263: 20 45 A8
    JMP   $FFCF              ; $9266: 4C CF FF (J_BASIN)
    JSR   $A845              ; $9269: 20 45 A8
    JMP   $FFD2              ; $926C: 4C D2 FF (J_BSOUT)
    JSR   $A845              ; $926F: 20 45 A8
    JMP   $FFCC              ; $9272: 4C CC FF (J_CLRCH)
    JSR   $A845              ; $9275: 20 45 A8
    JMP   $FFC3              ; $9278: 4C C3 FF (J_CLOSE)
    JSR   $A845              ; $927B: 20 45 A8
    JMP   $FFE7              ; $927E: 4C E7 FF (J_CLALL)
    JSR   $A845              ; $9281: 20 45 A8
    JMP   $FF7D              ; $9284: 4C 7D FF (J_PRIMM)
    JSR   $A845              ; $9287: 20 45 A8
    JMP   $FF68              ; $928A: 4C 68 FF (J_SETBNK)
    STA   $FF03              ; $928D: 8D 03 FF (MMU_LCRC_TOP)
    JMP   $FFF0              ; $9290: 4C F0 FF (J_PLOT)
    JSR   $A845              ; $9293: 20 45 A8
    JMP   $FFE1              ; $9296: 4C E1 FF (J_STOP)
    LSR   $11                ; $9299: 46 11   
    TAX                      ; $929B: AA      
    BEQ   $92D9              ; $929C: F0 3B   
    PHA                      ; $929E: 48      
    LDA   $35                ; $929F: A5 35   
    SEC                      ; $92A1: 38      
    SBC   #$02               ; $92A2: E9 02   
    LDY   $36                ; $92A4: A4 36   
    BCS   $92A9              ; $92A6: B0 01   
    DEY                      ; $92A8: 88      
    STA   $24                ; $92A9: 85 24   
    STY   $25                ; $92AB: 84 25   
    TXA                      ; $92AD: 8A      
    EOR   #$FF               ; $92AE: 49 FF   
    SEC                      ; $92B0: 38      
    ADC   $24                ; $92B1: 65 24   
    BCS   $92B6              ; $92B3: B0 01   
    DEY                      ; $92B5: 88      
    CPY   $34                ; $92B6: C4 34   
    BCC   $92DA              ; $92B8: 90 20   
    BNE   $92C0              ; $92BA: D0 04   
    CMP   $33                ; $92BC: C5 33   
    BCC   $92DA              ; $92BE: 90 1A   
    STA   $37                ; $92C0: 85 37   
    STY   $38                ; $92C2: 84 38   
    LDY   #$01               ; $92C4: A0 01   
    LDA   #$FF               ; $92C6: A9 FF   
    STA   $FF04              ; $92C8: 8D 04 FF (MMU_LCRD_TOP)
    STA   ($24),Y            ; $92CB: 91 24   
    DEY                      ; $92CD: 88      
    PLA                      ; $92CE: 68      
    STA   ($24),Y            ; $92CF: 91 24   
    LDX   $37                ; $92D1: A6 37   
    LDY   $38                ; $92D3: A4 38   
    STX   $35                ; $92D5: 86 35   
    STY   $36                ; $92D7: 84 36   
    RTS                      ; $92D9: 60      
    LDA   $11                ; $92DA: A5 11   
    BMI   $92E7              ; $92DC: 30 09   
    JSR   $92EA              ; $92DE: 20 EA 92 (GARBAG_COLLECT)
    SEC                      ; $92E1: 38      
    ROR   $11                ; $92E2: 66 11   
    PLA                      ; $92E4: 68      
    BNE   $929B              ; $92E5: D0 B4   
    JMP   $4D3A              ; $92E7: 4C 3A 4D
GARBAG_COLLECT:
    LDX   $18                ; $92EA: A6 18   
    CPX   #$1B               ; $92EC: E0 1B   
    BEQ   $9303              ; $92EE: F0 13   
    JSR   $93F0              ; $92F0: 20 F0 93
    BEQ   $92EC              ; $92F3: F0 F7   
    TXA                      ; $92F5: 8A      
    LDY   #$00               ; $92F6: A0 00   
    STA   $FF04              ; $92F8: 8D 04 FF (MMU_LCRD_TOP)
    STA   ($5E),Y            ; $92FB: 91 5E   
    TYA                      ; $92FD: 98      
    INY                      ; $92FE: C8      
    STA   ($5E),Y            ; $92FF: 91 5E   
    BNE   $92EC              ; $9301: D0 E9   
    LDY   #$00               ; $9303: A0 00   
    STY   $5A                ; $9305: 84 5A   
    LDX   $39                ; $9307: A6 39   
    LDY   $3A                ; $9309: A4 3A   
    STX   $61                ; $930B: 86 61   
    STX   $50                ; $930D: 86 50   
    STX   $37                ; $930F: 86 37   
    STY   $62                ; $9311: 84 62   
    STY   $51                ; $9313: 84 51   
    STY   $38                ; $9315: 84 38   
    TXA                      ; $9317: 8A      
    JSR   $9383              ; $9318: 20 83 93
    BNE   $9329              ; $931B: D0 0C   
    DEY                      ; $931D: 88      
    JSR   $42FB              ; $931E: 20 FB 42
    JSR   $93D2              ; $9321: 20 D2 93
    SEC                      ; $9324: 38      
    ROR   $5A                ; $9325: 66 5A   
    BNE   $9318              ; $9327: D0 EF   
    BIT   $5A                ; $9329: 24 5A   
    BPL   $936F              ; $932B: 10 42   
    LDX   #$00               ; $932D: A2 00   
    STX   $5A                ; $932F: 86 5A   
    LDA   #$02               ; $9331: A9 02   
    LDY   #$01               ; $9333: A0 01   
    JSR   $42FB              ; $9335: 20 FB 42
    STA   ($61),Y            ; $9338: 91 61   
    DEY                      ; $933A: 88      
    JSR   $42FB              ; $933B: 20 FB 42
    STA   ($61),Y            ; $933E: 91 61   
    JSR   $03B7              ; $9340: 20 B7 03
    TAX                      ; $9343: AA      
    JSR   $93E1              ; $9344: 20 E1 93
    STA   $37                ; $9347: 85 37   
    STY   $38                ; $9349: 84 38   
    TXA                      ; $934B: 8A      
    JSR   $93D2              ; $934C: 20 D2 93
    TXA                      ; $934F: 8A      
    TAY                      ; $9350: A8      
    DEY                      ; $9351: 88      
    JSR   $42FB              ; $9352: 20 FB 42
    STA   ($61),Y            ; $9355: 91 61   
    DEX                      ; $9357: CA      
    BNE   $9351              ; $9358: D0 F7   
    LDY   #$02               ; $935A: A0 02   
    LDA.W $0060,Y            ; $935C: B9 60 00
    STA   ($24),Y            ; $935F: 91 24   
    DEY                      ; $9361: 88      
    BNE   $935C              ; $9362: D0 F8   
    LDA   $50                ; $9364: A5 50   
    LDY   $51                ; $9366: A4 51   
    JSR   $9383              ; $9368: 20 83 93
    BEQ   $931D              ; $936B: F0 B0   
    BNE   $9333              ; $936D: D0 C4   
    LDY   #$00               ; $936F: A0 00   
    JSR   $03B7              ; $9371: 20 B7 03
    TAX                      ; $9374: AA      
    JSR   $93E1              ; $9375: 20 E1 93
    STA   $37                ; $9378: 85 37   
    STY   $38                ; $937A: 84 38   
    TXA                      ; $937C: 8A      
    JSR   $93D2              ; $937D: 20 D2 93
    JMP   $9318              ; $9380: 4C 18 93
    CPY   $36                ; $9383: C4 36   
    BCC   $93B1              ; $9385: 90 2A   
    BNE   $938F              ; $9387: D0 06   
    CMP   $35                ; $9389: C5 35   
    BEQ   $93B1              ; $938B: F0 24   
    BCC   $93B1              ; $938D: 90 22   
    BIT   $5A                ; $938F: 24 5A   
    BMI   $9398              ; $9391: 30 05   
    LDA   #$02               ; $9393: A9 02   
    JSR   $93E1              ; $9395: 20 E1 93
    LDA   #$02               ; $9398: A9 02   
    JSR   $93D2              ; $939A: 20 D2 93
    LDY   #$01               ; $939D: A0 01   
    JSR   $42FB              ; $939F: 20 FB 42
    CMP   #$FF               ; $93A2: C9 FF   
    BNE   $93A7              ; $93A4: D0 01   
    RTS                      ; $93A6: 60      
    JSR   $42FB              ; $93A7: 20 FB 42
    STA.W $0024,Y            ; $93AA: 99 24 00
    DEY                      ; $93AD: 88      
    BPL   $93A7              ; $93AE: 10 F7   
    RTS                      ; $93B0: 60      
    LDX   $18                ; $93B1: A6 18   
    CPX   #$1B               ; $93B3: E0 1B   
    BEQ   $93C7              ; $93B5: F0 10   
    JSR   $93F0              ; $93B7: 20 F0 93
    BEQ   $93B3              ; $93BA: F0 F7   
    LDY   #$00               ; $93BC: A0 00   
    STA   ($5E),Y            ; $93BE: 91 5E   
    INY                      ; $93C0: C8      
    LDA   #$FF               ; $93C1: A9 FF   
    STA   ($5E),Y            ; $93C3: 91 5E   
    BNE   $93B3              ; $93C5: D0 EC   
    PLA                      ; $93C7: 68      
    PLA                      ; $93C8: 68      
    LDA   $37                ; $93C9: A5 37   
    LDY   $38                ; $93CB: A4 38   
    STA   $35                ; $93CD: 85 35   
    STY   $36                ; $93CF: 84 36   
    RTS                      ; $93D1: 60      
    EOR   #$FF               ; $93D2: 49 FF   
    SEC                      ; $93D4: 38      
    ADC   $50                ; $93D5: 65 50   
    LDY   $51                ; $93D7: A4 51   
    BCS   $93DC              ; $93D9: B0 01   
    DEY                      ; $93DB: 88      
    STA   $50                ; $93DC: 85 50   
    STY   $51                ; $93DE: 84 51   
    RTS                      ; $93E0: 60      
    EOR   #$FF               ; $93E1: 49 FF   
    SEC                      ; $93E3: 38      
    ADC   $61                ; $93E4: 65 61   
    LDY   $62                ; $93E6: A4 62   
    BCS   $93EB              ; $93E8: B0 01   
    DEY                      ; $93EA: 88      
    STA   $61                ; $93EB: 85 61   
    STY   $62                ; $93ED: 84 62   
    RTS                      ; $93EF: 60      
    DEX                      ; $93F0: CA      
    LDA   $00,X              ; $93F1: B5 00   
    STA   $5F                ; $93F3: 85 5F   
    DEX                      ; $93F5: CA      
    LDA   $00,X              ; $93F6: B5 00   
    STA   $5E                ; $93F8: 85 5E   
    DEX                      ; $93FA: CA      
    LDA   $00,X              ; $93FB: B5 00   
    PHA                      ; $93FD: 48      
    CLC                      ; $93FE: 18      
    ADC   $5E                ; $93FF: 65 5E   
    STA   $5E                ; $9401: 85 5E   
    BCC   $9407              ; $9403: 90 02   
    INC   $5F                ; $9405: E6 5F   
    PLA                      ; $9407: 68      
    RTS                      ; $9408: 60      
CMD_COS:
    LDA   #$85               ; $9409: A9 85   
    LDY   #$94               ; $940B: A0 94   
    JSR   $8A12              ; $940D: 20 12 8A
CMD_SIN:
    JSR   $8C38              ; $9410: 20 38 8C
    LDA   #$8A               ; $9413: A9 8A   
    LDY   #$94               ; $9415: A0 94   
    LDX   $6F                ; $9417: A6 6F   
    JSR   $8B41              ; $9419: 20 41 8B
    JSR   $8C38              ; $941C: 20 38 8C
    JSR   $8CFB              ; $941F: 20 FB 8C (CMD_INT)
    LDA   #$00               ; $9422: A9 00   
    STA   $70                ; $9424: 85 70   
    JSR   $8831              ; $9426: 20 31 88 (CMD__)
    LDA   #$8F               ; $9429: A9 8F   
    LDY   #$94               ; $942B: A0 94   
    JSR   $8A18              ; $942D: 20 18 8A
    LDA   $68                ; $9430: A5 68   
    PHA                      ; $9432: 48      
    BPL   $9442              ; $9433: 10 0D   
    JSR   $8A0E              ; $9435: 20 0E 8A
    LDA   $68                ; $9438: A5 68   
    BMI   $9445              ; $943A: 30 09   
    LDA   $14                ; $943C: A5 14   
    EOR   #$FF               ; $943E: 49 FF   
    STA   $14                ; $9440: 85 14   
    JSR   $8FFA              ; $9442: 20 FA 8F
    LDA   #$8F               ; $9445: A9 8F   
    LDY   #$94               ; $9447: A0 94   
    JSR   $8A12              ; $9449: 20 12 8A
    PLA                      ; $944C: 68      
    BPL   $9452              ; $944D: 10 03   
    JSR   $8FFA              ; $944F: 20 FA 8F
    LDA   #$94               ; $9452: A9 94   
    LDY   #$94               ; $9454: A0 94   
    JMP   $9086              ; $9456: 4C 86 90
CMD_TAN:
    JSR   $8BFC              ; $9459: 20 FC 8B
    LDA   #$00               ; $945C: A9 00   
    STA   $14                ; $945E: 85 14   
    JSR   $9410              ; $9460: 20 10 94 (CMD_SIN)
    LDX   #$50               ; $9463: A2 50   
    LDY   #$00               ; $9465: A0 00   
    JSR   $8C00              ; $9467: 20 00 8C
    LDA   #$59               ; $946A: A9 59   
    LDY   #$00               ; $946C: A0 00   
    JSR   $8BD4              ; $946E: 20 D4 8B
    LDA   #$00               ; $9471: A9 00   
    STA   $68                ; $9473: 85 68   
    LDA   $14                ; $9475: A5 14   
    JSR   $9481              ; $9477: 20 81 94
    LDA   #$50               ; $947A: A9 50   
    LDY   #$00               ; $947C: A0 00   
    JMP   $8B49              ; $947E: 4C 49 8B
    PHA                      ; $9481: 48      
    JMP   $9442              ; $9482: 4C 42 94
    STA   ($49,X)            ; $9485: 81 49   
    .BYTE $0F                                ; $9487: 0F [UNRESOLVED]
    .BYTE $DA                                ; $9488: DA [UNRESOLVED]
    LDX   #$83               ; $9489: A2 83   
    EOR   #$0F               ; $948B: 49 0F   
    .BYTE $DA                                ; $948D: DA [UNRESOLVED]
    LDX   #$7F               ; $948E: A2 7F   
    BRK                      ; $9490: 00      
    BRK                      ; $9491: 00      
    BRK                      ; $9492: 00      
    BRK                      ; $9493: 00      
    ORA   $84                ; $9494: 05 84   
    INC   $1A                ; $9496: E6 1A   
    AND   $861B              ; $9498: 2D 1B 86
    PLP                      ; $949B: 28      
    .BYTE $07                                ; $949C: 07 [UNRESOLVED]
    .BYTE $FB                                ; $949D: FB [UNRESOLVED]
    SED                      ; $949E: F8      
    .BYTE $87                                ; $949F: 87 [UNRESOLVED]
    STA   $8968,Y            ; $94A0: 99 68 89
    ORA   ($87,X)            ; $94A3: 01 87   
    .BYTE $23                                ; $94A5: 23 [UNRESOLVED]
    AND   $DF,X              ; $94A6: 35 DF   
    SBC   ($86,X)            ; $94A8: E1 86   
    LDA   $5D                ; $94AA: A5 5D   
    .BYTE $E7                                ; $94AC: E7 [UNRESOLVED]
    PLP                      ; $94AD: 28      
    .BYTE $83                                ; $94AE: 83 [UNRESOLVED]
    EOR   #$0F               ; $94AF: 49 0F   
    .BYTE $DA                                ; $94B1: DA [UNRESOLVED]
    LDX   #$A5               ; $94B2: A2 A5   
    PLA                      ; $94B4: 68      
    PHA                      ; $94B5: 48      
    BPL   $94BB              ; $94B6: 10 03   
    JSR   $8FFA              ; $94B8: 20 FA 8F
    LDA   $63                ; $94BB: A5 63   
    PHA                      ; $94BD: 48      
    CMP   #$81               ; $94BE: C9 81   
    BCC   $94C9              ; $94C0: 90 07   
    LDA   #$9C               ; $94C2: A9 9C   
    LDY   #$89               ; $94C4: A0 89   
    JSR   $8A1E              ; $94C6: 20 1E 8A
    LDA   #$E3               ; $94C9: A9 E3   
    LDY   #$94               ; $94CB: A0 94   
    JSR   $9086              ; $94CD: 20 86 90
    PLA                      ; $94D0: 68      
    CMP   #$81               ; $94D1: C9 81   
    BCC   $94DC              ; $94D3: 90 07   
    LDA   #$85               ; $94D5: A9 85   
    LDY   #$94               ; $94D7: A0 94   
    JSR   $8A18              ; $94D9: 20 18 8A
    PLA                      ; $94DC: 68      
    BPL   $94E2              ; $94DD: 10 03   
    JMP   $8FFA              ; $94DF: 4C FA 8F
    RTS                      ; $94E2: 60      
    .BYTE $0B                                ; $94E3: 0B [UNRESOLVED]
    ROR   $B3,X              ; $94E4: 76 B3   
    .BYTE $83                                ; $94E6: 83 [UNRESOLVED]
    LDA   $79D3,X            ; $94E7: BD D3 79
    ASL   $A6F4,X            ; $94EA: 1E F4 A6
    SBC   $7B,X              ; $94ED: F5 7B   
    .BYTE $83                                ; $94EF: 83 [UNRESOLVED]
    .BYTE $FC                                ; $94F0: FC [UNRESOLVED]
    BCS   $9503              ; $94F1: B0 10   
    .BYTE $7C                                ; $94F3: 7C [UNRESOLVED]
    .BYTE $0C                                ; $94F4: 0C [UNRESOLVED]
    .BYTE $1F                                ; $94F5: 1F [UNRESOLVED]
    .BYTE $67                                ; $94F6: 67 [UNRESOLVED]
    DEX                      ; $94F7: CA      
    .BYTE $7C                                ; $94F8: 7C [UNRESOLVED]
    DEC   $CB53,X            ; $94F9: DE 53 CB
    CMP   ($7D,X)            ; $94FC: C1 7D   
    .BYTE $14                                ; $94FE: 14 [UNRESOLVED]
    .BYTE $64                                ; $94FF: 64 [UNRESOLVED]
    BVS   $954E              ; $9500: 70 4C   
    ADC   $EAB7,X            ; $9502: 7D B7 EA
    EOR   ($7A),Y            ; $9505: 51 7A   
    ADC   $3063,X            ; $9507: 7D 63 30
    DEY                      ; $950A: 88      
    ROR   $927E,X            ; $950B: 7E 7E 92
    .BYTE $44                                ; $950E: 44 [UNRESOLVED]
    STA   $7E3A,Y            ; $950F: 99 3A 7E
    JMP   $91CC              ; $9512: 4C CC 91
    .BYTE $C7                                ; $9515: C7 [UNRESOLVED]
    .BYTE $7F                                ; $9516: 7F [UNRESOLVED]
    TAX                      ; $9517: AA      
    TAX                      ; $9518: AA      
    TAX                      ; $9519: AA      
    .BYTE $13                                ; $951A: 13 [UNRESOLVED]
    STA   ($00,X)            ; $951B: 81 00   
    BRK                      ; $951D: 00      
    BRK                      ; $951E: 00      
    BRK                      ; $951F: 00      
PRINT_USING_PUDEF:
    LDX   #$FF               ; $9520: A2 FF   
    STX   $0136              ; $9522: 8E 36 01
    JSR   $0380              ; $9525: 20 80 03
    JSR   $77EF              ; $9528: 20 EF 77 (FRMEVL)
    JSR   $77DD              ; $952B: 20 DD 77
    LDA   $66                ; $952E: A5 66   
    PHA                      ; $9530: 48      
    LDA   $67                ; $9531: A5 67   
    PHA                      ; $9533: 48      
    LDY   #$02               ; $9534: A0 02   
    JSR   $42E7              ; $9536: 20 E7 42
    DEY                      ; $9539: 88      
    STA.W $003F,Y            ; $953A: 99 3F 00
    BNE   $9536              ; $953D: D0 F7   
    JSR   $42E7              ; $953F: 20 E7 42
    STA   $0135              ; $9542: 8D 35 01
    TAY                      ; $9545: A8      
    BEQ   $9553              ; $9546: F0 0B   
    DEY                      ; $9548: 88      
    JSR   $42D3              ; $9549: 20 D3 42
    CMP   #$23               ; $954C: C9 23   
    BEQ   $9556              ; $954E: F0 06   
    TYA                      ; $9550: 98      
    BNE   $9548              ; $9551: D0 F5   
    JMP   $796C              ; $9553: 4C 6C 79 (CMD_FE_BEGIN)
    LDA   #$3B               ; $9556: A9 3B   
    JSR   $795E              ; $9558: 20 5E 79
    STY   $77                ; $955B: 84 77   
    STY   $0123              ; $955D: 8C 23 01
    JSR   $77EF              ; $9560: 20 EF 77 (FRMEVL)
    BIT   $0F                ; $9563: 24 0F   
    BPL   $95A0              ; $9565: 10 39   
    JSR   $979F              ; $9567: 20 9F 97
    JSR   $98F2              ; $956A: 20 F2 98
    LDX   $012B              ; $956D: AE 2B 01
    BEQ   $9587              ; $9570: F0 15   
    LDX   #$00               ; $9572: A2 00   
    SEC                      ; $9574: 38      
    LDA   $0131              ; $9575: AD 31 01
    SBC   $78                ; $9578: E5 78   
    BCC   $9587              ; $957A: 90 0B   
    LDX   #$3D               ; $957C: A2 3D   
    CPX   $012B              ; $957E: EC 2B 01
    BNE   $9586              ; $9581: D0 03   
    LSR   A                  ; $9583: 4A      
    ADC   #$00               ; $9584: 69 00   
    TAX                      ; $9586: AA      
    LDY   #$00               ; $9587: A0 00   
    TXA                      ; $9589: 8A      
    BEQ   $9591              ; $958A: F0 05   
    DEX                      ; $958C: CA      
    LDA   #$20               ; $958D: A9 20   
    BNE   $9599              ; $958F: D0 08   
    CPY   $78                ; $9591: C4 78   
    BCS   $958D              ; $9593: B0 F8   
    JSR   $03B7              ; $9595: 20 B7 03
    INY                      ; $9598: C8      
    JSR   $98EB              ; $9599: 20 EB 98
    BNE   $9589              ; $959C: D0 EB   
    BEQ   $95C7              ; $959E: F0 27   
    JSR   $8E42              ; $95A0: 20 42 8E
    LDY   #$FF               ; $95A3: A0 FF   
    INY                      ; $95A5: C8      
    LDA   $0100,Y            ; $95A6: B9 00 01
    BNE   $95A5              ; $95A9: D0 FA   
    TYA                      ; $95AB: 98      
    JSR   $8690              ; $95AC: 20 90 86
    LDY   #$00               ; $95AF: A0 00   
    STA   $FF04              ; $95B1: 8D 04 FF (MMU_LCRD_TOP)
    LDA   $0100,Y            ; $95B4: B9 00 01
    BEQ   $95BE              ; $95B7: F0 05   
    STA   ($64),Y            ; $95B9: 91 64   
    INY                      ; $95BB: C8      
    BNE   $95B4              ; $95BC: D0 F6   
    JSR   $86E3              ; $95BE: 20 E3 86
    JSR   $979F              ; $95C1: 20 9F 97
    JSR   $95E7              ; $95C4: 20 E7 95
    JSR   $0386              ; $95C7: 20 86 03
    CMP   #$2C               ; $95CA: C9 2C   
    BEQ   $9558              ; $95CC: F0 8A   
    SEC                      ; $95CE: 38      
    ROR   $77                ; $95CF: 66 77   
    JSR   $98F2              ; $95D1: 20 F2 98
    PLA                      ; $95D4: 68      
    TAY                      ; $95D5: A8      
    PLA                      ; $95D6: 68      
    JSR   $8785              ; $95D7: 20 85 87
    JSR   $0386              ; $95DA: 20 86 03
    CMP   #$3B               ; $95DD: C9 3B   
    BEQ   $95E4              ; $95DF: F0 03   
    JMP   $5598              ; $95E1: 4C 98 55
    JMP   $0380              ; $95E4: 4C 80 03
    STA   $FF03              ; $95E7: 8D 03 FF (MMU_LCRC_TOP)
    LDA   $1204              ; $95EA: AD 04 12
    STA   $0133              ; $95ED: 8D 33 01
    LDA   #$FF               ; $95F0: A9 FF   
    STA   $0132              ; $95F2: 8D 32 01
    JMP   $95FA              ; $95F5: 4C FA 95
    STX   $80                ; $95F8: 86 80   
    CPY   $78                ; $95FA: C4 78   
    BEQ   $9631              ; $95FC: F0 33   
    LDA   $0100,Y            ; $95FE: B9 00 01
    INY                      ; $9601: C8      
    CMP   #$20               ; $9602: C9 20   
    BEQ   $95FA              ; $9604: F0 F4   
    CMP   #$2D               ; $9606: C9 2D   
    BEQ   $95F2              ; $9608: F0 E8   
    CMP   #$2E               ; $960A: C9 2E   
    BEQ   $95F8              ; $960C: F0 EA   
    CMP   #$45               ; $960E: C9 45   
    BEQ   $9623              ; $9610: F0 11   
    STA   $0100,X            ; $9612: 9D 00 01
    STX   $0124              ; $9615: 8E 24 01
    INX                      ; $9618: E8      
    BIT   $80                ; $9619: 24 80   
    BPL   $95FA              ; $961B: 10 DD   
    INC   $012A              ; $961D: EE 2A 01
    JMP   $95FA              ; $9620: 4C FA 95
    LDA   $0100,Y            ; $9623: B9 00 01
    CMP   #$2D               ; $9626: C9 2D   
    BNE   $962D              ; $9628: D0 03   
    ROR   $0128              ; $962A: 6E 28 01
    INY                      ; $962D: C8      
    STY   $0129              ; $962E: 8C 29 01
    LDA   $80                ; $9631: A5 80   
    BPL   $9637              ; $9633: 10 02   
    STX   $80                ; $9635: 86 80   
    JSR   $98F2              ; $9637: 20 F2 98
    LDA   $012C              ; $963A: AD 2C 01
    CMP   #$FF               ; $963D: C9 FF   
    BEQ   $966A              ; $963F: F0 29   
    LDA   $012F              ; $9641: AD 2F 01
    BEQ   $9685              ; $9644: F0 3F   
    LDA   $0129              ; $9646: AD 29 01
    BNE   $965D              ; $9649: D0 12   
    LDX   $0124              ; $964B: AE 24 01
    JSR   $9774              ; $964E: 20 74 97
    DEC   $0102,X            ; $9651: DE 02 01
    INX                      ; $9654: E8      
    STX   $0129              ; $9655: 8E 29 01
    JSR   $97FB              ; $9658: 20 FB 97
    BEQ   $9682              ; $965B: F0 25   
    LDY   $012E              ; $965D: AC 2E 01
    BNE   $9679              ; $9660: D0 17   
    LDY   $0132              ; $9662: AC 32 01
    BMI   $9679              ; $9665: 30 12   
    LDA   $012C              ; $9667: AD 2C 01
    BEQ   $96D6              ; $966A: F0 6A   
    DEC   $012C              ; $966C: CE 2C 01
    BNE   $9676              ; $966F: D0 05   
    LDA   $012D              ; $9671: AD 2D 01
    BEQ   $96D6              ; $9674: F0 60   
    INC   $0127              ; $9676: EE 27 01
    JSR   $96EE              ; $9679: 20 EE 96
    JSR   $97B9              ; $967C: 20 B9 97
    JSR   $96EE              ; $967F: 20 EE 96
    JMP   $981C              ; $9682: 4C 1C 98
    LDY   $0129              ; $9685: AC 29 01
    BEQ   $96A0              ; $9688: F0 16   
    STA   $78                ; $968A: 85 78   
    SEC                      ; $968C: 38      
    ROR   $0130              ; $968D: 6E 30 01
    LDY   $80                ; $9690: A4 80   
    LDA   $0128              ; $9692: AD 28 01
    BPL   $969D              ; $9695: 10 06   
    JSR   $9727              ; $9697: 20 27 97
    JMP   $96A9              ; $969A: 4C A9 96
    JSR   $9708              ; $969D: 20 08 97
    LDY   $80                ; $96A0: A4 80   
    BEQ   $96A9              ; $96A2: F0 05   
    JSR   $97FF              ; $96A4: 20 FF 97
    BEQ   $96AF              ; $96A7: F0 06   
    JSR   $97B9              ; $96A9: 20 B9 97
    JMP   $96B2              ; $96AC: 4C B2 96
    DEC   $012A              ; $96AF: CE 2A 01
    SEC                      ; $96B2: 38      
    LDA   $012C              ; $96B3: AD 2C 01
    SBC   $012A              ; $96B6: ED 2A 01
    BCC   $96D6              ; $96B9: 90 1B   
    STA   $0127              ; $96BB: 8D 27 01
    LDY   $012E              ; $96BE: AC 2E 01
    BNE   $96DE              ; $96C1: D0 1B   
    LDY   $0132              ; $96C3: AC 32 01
    BMI   $96DE              ; $96C6: 30 16   
    TAY                      ; $96C8: A8      
    BEQ   $96D6              ; $96C9: F0 0B   
    DEY                      ; $96CB: 88      
    BNE   $96E1              ; $96CC: D0 13   
    LDA   $012D              ; $96CE: AD 2D 01
    ORA   $012A              ; $96D1: 0D 2A 01
    BNE   $9682              ; $96D4: D0 AC   
    LDA   #$2A               ; $96D6: A9 2A   
    JSR   $98EB              ; $96D8: 20 EB 98
    BNE   $96D8              ; $96DB: D0 FB   
    RTS                      ; $96DD: 60      
    TAY                      ; $96DE: A8      
    BEQ   $9682              ; $96DF: F0 A1   
    LDA   $012A              ; $96E1: AD 2A 01
    BNE   $9682              ; $96E4: D0 9C   
    DEC   $0127              ; $96E6: CE 27 01
    INC   $77                ; $96E9: E6 77   
    JMP   $9682              ; $96EB: 4C 82 96
    SEC                      ; $96EE: 38      
    LDA   $012C              ; $96EF: AD 2C 01
    SBC   $012A              ; $96F2: ED 2A 01
    BEQ   $9730              ; $96F5: F0 39   
    LDY   $80                ; $96F7: A4 80   
    BCC   $9711              ; $96F9: 90 16   
    STA   $78                ; $96FB: 85 78   
    CPY   $0124              ; $96FD: CC 24 01
    BEQ   $9704              ; $9700: F0 02   
    BCS   $9705              ; $9702: B0 01   
    INY                      ; $9704: C8      
    INC   $012A              ; $9705: EE 2A 01
    JSR   $973D              ; $9708: 20 3D 97
    DEC   $78                ; $970B: C6 78   
    BNE   $96FD              ; $970D: D0 EE   
    BEQ   $972E              ; $970F: F0 1D   
    EOR   #$FF               ; $9711: 49 FF   
    ADC   #$01               ; $9713: 69 01   
    STA   $78                ; $9715: 85 78   
    CPY   $0123              ; $9717: CC 23 01
    BEQ   $9723              ; $971A: F0 07   
    DEY                      ; $971C: 88      
    DEC   $012A              ; $971D: CE 2A 01
    JMP   $9725              ; $9720: 4C 25 97
    INC   $77                ; $9723: E6 77   
    LDA   #$80               ; $9725: A9 80   
    JSR   $973F              ; $9727: 20 3F 97
    DEC   $78                ; $972A: C6 78   
    BNE   $9717              ; $972C: D0 E9   
    STY   $80                ; $972E: 84 80   
    RTS                      ; $9730: 60      
    BNE   $976C              ; $9731: D0 39   
    EOR   #$09               ; $9733: 49 09   
    STA   $0100,X            ; $9735: 9D 00 01
    DEX                      ; $9738: CA      
    CPX   $0129              ; $9739: EC 29 01
    RTS                      ; $973C: 60      
    LDA   #$00               ; $973D: A9 00   
    LDX   $0129              ; $973F: AE 29 01
    INX                      ; $9742: E8      
    BIT   $0130              ; $9743: 2C 30 01
    BMI   $9758              ; $9746: 30 10   
    EOR   $0128              ; $9748: 4D 28 01
    BEQ   $9758              ; $974B: F0 0B   
    JSR   $9782              ; $974D: 20 82 97
    JSR   $9731              ; $9750: 20 31 97
    BCS   $974D              ; $9753: B0 F8   
    JMP   $895D              ; $9755: 4C 5D 89
    LDA   $0100,X            ; $9758: BD 00 01
    DEC   $0100,X            ; $975B: DE 00 01
    CMP   #$30               ; $975E: C9 30   
    JSR   $9731              ; $9760: 20 31 97
    BCS   $9758              ; $9763: B0 F3   
    BIT   $0130              ; $9765: 2C 30 01
    BPL   $976F              ; $9768: 10 05   
    STY   $80                ; $976A: 84 80   
    PLA                      ; $976C: 68      
    PLA                      ; $976D: 68      
    RTS                      ; $976E: 60      
    LDA   $0128              ; $976F: AD 28 01
    EOR   #$80               ; $9772: 49 80   
    STA   $0128              ; $9774: 8D 28 01
    LDA   #$30               ; $9777: A9 30   
    STA   $0101,X            ; $9779: 9D 01 01
    LDA   #$31               ; $977C: A9 31   
    STA   $0102,X            ; $977E: 9D 02 01
    RTS                      ; $9781: 60      
    LDA   $0100,X            ; $9782: BD 00 01
    INC   $0100,X            ; $9785: FE 00 01
    CMP   #$39               ; $9788: C9 39   
    RTS                      ; $978A: 60      
    CLC                      ; $978B: 18      
    INY                      ; $978C: C8      
    BEQ   $9794              ; $978D: F0 05   
    CPY   $0135              ; $978F: CC 35 01
    BCC   $9798              ; $9792: 90 04   
    LDY   $77                ; $9794: A4 77   
    BNE   $976C              ; $9796: D0 D4   
    JSR   $42D3              ; $9798: 20 D3 42
    INC   $0131              ; $979B: EE 31 01
    RTS                      ; $979E: 60      
    JSR   $8781              ; $979F: 20 81 87
    STA   $78                ; $97A2: 85 78   
    LDX   #$0A               ; $97A4: A2 0A   
    LDA   #$00               ; $97A6: A9 00   
    STA   $0127,X            ; $97A8: 9D 27 01
    DEX                      ; $97AB: CA      
    BPL   $97A8              ; $97AC: 10 FA   
    STX   $0126              ; $97AE: 8E 26 01
    STX   $80                ; $97B1: 86 80   
    STX   $0125              ; $97B3: 8E 25 01
    TAX                      ; $97B6: AA      
    TAY                      ; $97B7: A8      
    RTS                      ; $97B8: 60      
    CLC                      ; $97B9: 18      
    LDA   $80                ; $97BA: A5 80   
    ADC   $012D              ; $97BC: 6D 2D 01
    BCS   $97FA              ; $97BF: B0 39   
    SEC                      ; $97C1: 38      
    SBC   $77                ; $97C2: E5 77   
    BCC   $97FA              ; $97C4: 90 34   
    CMP   $0124              ; $97C6: CD 24 01
    BEQ   $97CD              ; $97C9: F0 02   
    BCS   $97FA              ; $97CB: B0 2D   
    CMP   $0123              ; $97CD: CD 23 01
    BCC   $97FA              ; $97D0: 90 28   
    TAX                      ; $97D2: AA      
    LDA   $0100,X            ; $97D3: BD 00 01
    CMP   #$35               ; $97D6: C9 35   
    BCC   $97FA              ; $97D8: 90 20   
    CPX   $0123              ; $97DA: EC 23 01
    BEQ   $97E9              ; $97DD: F0 0A   
    DEX                      ; $97DF: CA      
    JSR   $9782              ; $97E0: 20 82 97
    STX   $0124              ; $97E3: 8E 24 01
    BEQ   $97DA              ; $97E6: F0 F2   
    RTS                      ; $97E8: 60      
    LDA   #$31               ; $97E9: A9 31   
    STA   $0100,X            ; $97EB: 9D 00 01
    INX                      ; $97EE: E8      
    STX   $80                ; $97EF: 86 80   
    DEC   $77                ; $97F1: C6 77   
    BPL   $97FA              ; $97F3: 10 05   
    INC   $77                ; $97F5: E6 77   
    INC   $012A              ; $97F7: EE 2A 01
    RTS                      ; $97FA: 60      
    LDY   $80                ; $97FB: A4 80   
    BEQ   $9816              ; $97FD: F0 17   
    LDY   $0123              ; $97FF: AC 23 01
    LDA   $0100,Y            ; $9802: B9 00 01
    CMP   #$30               ; $9805: C9 30   
    RTS                      ; $9807: 60      
    INC   $80                ; $9808: E6 80   
    JSR   $973D              ; $980A: 20 3D 97
    INC   $0123              ; $980D: EE 23 01
    CPY   $0124              ; $9810: CC 24 01
    BEQ   $97FA              ; $9813: F0 E5   
    INY                      ; $9815: C8      
    JSR   $9802              ; $9816: 20 02 98
    BEQ   $9808              ; $9819: F0 ED   
    RTS                      ; $981B: 60      
    LDA   $0125              ; $981C: AD 25 01
    BMI   $9823              ; $981F: 30 02   
    INC   $77                ; $9821: E6 77   
    LDX   $0123              ; $9823: AE 23 01
    DEX                      ; $9826: CA      
    LDY   $0134              ; $9827: AC 34 01
    JSR   $42D3              ; $982A: 20 D3 42
    INY                      ; $982D: C8      
    CMP   #$2C               ; $982E: C9 2C   
    BNE   $9846              ; $9830: D0 14   
    BIT   $0126              ; $9832: 2C 26 01
    BMI   $9840              ; $9835: 30 09   
    STA   $FF03              ; $9837: 8D 03 FF (MMU_LCRC_TOP)
    LDA   $1205              ; $983A: AD 05 12
    JMP   $98AB              ; $983D: 4C AB 98
    LDA   $0133              ; $9840: AD 33 01
    JMP   $98AB              ; $9843: 4C AB 98
    CMP   #$2E               ; $9846: C9 2E   
    BNE   $9853              ; $9848: D0 09   
    STA   $FF03              ; $984A: 8D 03 FF (MMU_LCRC_TOP)
    LDA   $1206              ; $984D: AD 06 12
    JMP   $98AB              ; $9850: 4C AB 98
    CMP   #$2B               ; $9853: C9 2B   
    BEQ   $9892              ; $9855: F0 3B   
    CMP   #$2D               ; $9857: C9 2D   
    BEQ   $988D              ; $9859: F0 32   
    CMP   #$5E               ; $985B: C9 5E   
    BNE   $98C8              ; $985D: D0 69   
    LDA   #$45               ; $985F: A9 45   
    JSR   $98EB              ; $9861: 20 EB 98
    LDY   $0129              ; $9864: AC 29 01
    JSR   $9802              ; $9867: 20 02 98
    BNE   $9872              ; $986A: D0 06   
    INY                      ; $986C: C8      
    JSR   $9802              ; $986D: 20 02 98
    BEQ   $9879              ; $9870: F0 07   
    LDA   #$2D               ; $9872: A9 2D   
    BIT   $0128              ; $9874: 2C 28 01
    BMI   $987B              ; $9877: 30 02   
    LDA   #$2B               ; $9879: A9 2B   
    JSR   $98EB              ; $987B: 20 EB 98
    LDX   $0129              ; $987E: AE 29 01
    LDA   $0100,X            ; $9881: BD 00 01
    JSR   $98EB              ; $9884: 20 EB 98
    LDY   $0136              ; $9887: AC 36 01
    JMP   $98A1              ; $988A: 4C A1 98
    LDA   $0132              ; $988D: AD 32 01
    BMI   $9840              ; $9890: 30 AE   
    LDA   $0132              ; $9892: AD 32 01
    JMP   $98AB              ; $9895: 4C AB 98
    LDA   $77                ; $9898: A5 77   
    BNE   $98B4              ; $989A: D0 18   
    CPX   $0124              ; $989C: EC 24 01
    BEQ   $98A6              ; $989F: F0 05   
    INX                      ; $98A1: E8      
    LDA   $0100,X            ; $98A2: BD 00 01
    BIT   $30A9              ; $98A5: 2C A9 30
    LSR   $0126              ; $98A8: 4E 26 01
    JSR   $98EB              ; $98AB: 20 EB 98
    BEQ   $98B3              ; $98AE: F0 03   
    JMP   $982A              ; $98B0: 4C 2A 98
    RTS                      ; $98B3: 60      
    DEC   $77                ; $98B4: C6 77   
    LDA   $0125              ; $98B6: AD 25 01
    BMI   $98A6              ; $98B9: 30 EB   
    SEC                      ; $98BB: 38      
    ROR   $0125              ; $98BC: 6E 25 01
    STA   $FF03              ; $98BF: 8D 03 FF (MMU_LCRC_TOP)
    LDA   $1207              ; $98C2: AD 07 12
    JMP   $98A8              ; $98C5: 4C A8 98
    LDA   $0127              ; $98C8: AD 27 01
    BEQ   $9898              ; $98CB: F0 CB   
    DEC   $0127              ; $98CD: CE 27 01
    BEQ   $98D5              ; $98D0: F0 03   
    JMP   $9840              ; $98D2: 4C 40 98
    LDA   $012E              ; $98D5: AD 2E 01
    BMI   $98D0              ; $98D8: 30 F6   
    JSR   $42D3              ; $98DA: 20 D3 42
    CMP   #$2C               ; $98DD: C9 2C   
    BNE   $988D              ; $98DF: D0 AC   
    LDA   $0133              ; $98E1: AD 33 01
    JSR   $98EB              ; $98E4: 20 EB 98
    INY                      ; $98E7: C8      
    JMP   $98DA              ; $98E8: 4C DA 98
    JSR   $560C              ; $98EB: 20 0C 56
    DEC   $0131              ; $98EE: CE 31 01
    RTS                      ; $98F1: 60      
    LDY   $0136              ; $98F2: AC 36 01
    JSR   $978B              ; $98F5: 20 8B 97
    JSR   $99A7              ; $98F8: 20 A7 99
    BNE   $9911              ; $98FB: D0 14   
    STY   $0134              ; $98FD: 8C 34 01
    BCC   $991C              ; $9900: 90 1A   
    TAX                      ; $9902: AA      
    JSR   $978B              ; $9903: 20 8B 97
    BCS   $990D              ; $9906: B0 05   
    JSR   $99AF              ; $9908: 20 AF 99
    BEQ   $9917              ; $990B: F0 0A   
    LDY   $0134              ; $990D: AC 34 01
    TXA                      ; $9910: 8A      
    JSR   $560C              ; $9911: 20 0C 56
    JMP   $98F5              ; $9914: 4C F5 98
    BCS   $9903              ; $9917: B0 EA   
    LDY   $0134              ; $9919: AC 34 01
    LDX   $77                ; $991C: A6 77   
    BNE   $999A              ; $991E: D0 7A   
    STX   $0131              ; $9920: 8E 31 01
    DEY                      ; $9923: 88      
    DEC   $0131              ; $9924: CE 31 01
    JSR   $978B              ; $9927: 20 8B 97
    BCS   $99A0              ; $992A: B0 74   
    CMP   #$2C               ; $992C: C9 2C   
    BEQ   $9927              ; $992E: F0 F7   
    JSR   $997E              ; $9930: 20 7E 99
    BCC   $9924              ; $9933: 90 EF   
    CMP   #$2E               ; $9935: C9 2E   
    BNE   $9941              ; $9937: D0 08   
    INX                      ; $9939: E8      
    CPX   #$02               ; $993A: E0 02   
    BCC   $9927              ; $993C: 90 E9   
    JMP   $796C              ; $993E: 4C 6C 79 (CMD_FE_BEGIN)
    JSR   $99B3              ; $9941: 20 B3 99
    BNE   $9951              ; $9944: D0 0B   
    BCC   $994B              ; $9946: 90 03   
    STA   $012B              ; $9948: 8D 2B 01
    INC   $012C,X            ; $994B: FE 2C 01
    JMP   $9927              ; $994E: 4C 27 99
    CMP   #$24               ; $9951: C9 24   
    BNE   $9964              ; $9953: D0 0F   
    BIT   $0125              ; $9955: 2C 25 01
    BPL   $994B              ; $9958: 10 F1   
    CLC                      ; $995A: 18      
    ROR   $0125              ; $995B: 6E 25 01
    DEC   $012C              ; $995E: CE 2C 01
    JMP   $994B              ; $9961: 4C 4B 99
    CMP   #$5E               ; $9964: C9 5E   
    BNE   $997E              ; $9966: D0 16   
    LDX   #$02               ; $9968: A2 02   
    JSR   $978B              ; $996A: 20 8B 97
    BCS   $993E              ; $996D: B0 CF   
    CMP   #$5E               ; $996F: C9 5E   
    BNE   $993E              ; $9971: D0 CB   
    DEX                      ; $9973: CA      
    BPL   $996A              ; $9974: 10 F4   
    INC   $012F              ; $9976: EE 2F 01
    JSR   $978B              ; $9979: 20 8B 97
    BCS   $99A0              ; $997C: B0 22   
    CMP   #$2B               ; $997E: C9 2B   
    BNE   $999B              ; $9980: D0 19   
    LDA   $0132              ; $9982: AD 32 01
    BPL   $998C              ; $9985: 10 05   
    LDA   #$2B               ; $9987: A9 2B   
    STA   $0132              ; $9989: 8D 32 01
    LDA   $012E              ; $998C: AD 2E 01
    BNE   $993E              ; $998F: D0 AD   
    ROR   $012E              ; $9991: 6E 2E 01
    STY   $0136              ; $9994: 8C 36 01
    INC   $0131              ; $9997: EE 31 01
    RTS                      ; $999A: 60      
    CMP   #$2D               ; $999B: C9 2D   
    BEQ   $998C              ; $999D: F0 ED   
    SEC                      ; $999F: 38      
    STY   $0136              ; $99A0: 8C 36 01
    DEC   $0136              ; $99A3: CE 36 01
    RTS                      ; $99A6: 60      
    CMP   #$2B               ; $99A7: C9 2B   
    BEQ   $99C0              ; $99A9: F0 15   
    CMP   #$2D               ; $99AB: C9 2D   
    BEQ   $99C0              ; $99AD: F0 11   
    CMP   #$2E               ; $99AF: C9 2E   
    BEQ   $99C0              ; $99B1: F0 0D   
    CMP   #$3D               ; $99B3: C9 3D   
    BEQ   $99C0              ; $99B5: F0 09   
    CMP   #$3E               ; $99B7: C9 3E   
    BEQ   $99C0              ; $99B9: F0 05   
    CMP   #$23               ; $99BB: C9 23   
    BNE   $99C0              ; $99BD: D0 01   
    CLC                      ; $99BF: 18      
    RTS                      ; $99C0: 60      
    LDA   $66                ; $99C1: A5 66   
    STA   $03D6              ; $99C3: 8D D6 03
    LDA   $67                ; $99C6: A5 67   
    STA   $03D7              ; $99C8: 8D D7 03
    JSR   $77EF              ; $99CB: 20 EF 77 (FRMEVL)
    JSR   $77DD              ; $99CE: 20 DD 77
    LDA   $66                ; $99D1: A5 66   
    STA   $03D8              ; $99D3: 8D D8 03
    LDA   $67                ; $99D6: A5 67   
    STA   $03D9              ; $99D8: 8D D9 03
    LDX   #$01               ; $99DB: A2 01   
    STX   $67                ; $99DD: 86 67   
    JSR   $0386              ; $99DF: 20 86 03
    CMP   #$29               ; $99E2: C9 29   
    BEQ   $99E9              ; $99E4: F0 03   
    JSR   $8809              ; $99E6: 20 09 88
    JSR   $7956              ; $99E9: 20 56 79
    LDX   $67                ; $99EC: A6 67   
    BNE   $99F3              ; $99EE: D0 03   
    JMP   $7D28              ; $99F0: 4C 28 7D
    DEX                      ; $99F3: CA      
    STX   $63                ; $99F4: 86 63   
    LDX   #$03               ; $99F6: A2 03   
    LDA   $03D6,X            ; $99F8: BD D6 03
    STA   $59,X              ; $99FB: 95 59   
    DEX                      ; $99FD: CA      
    BPL   $99F8              ; $99FE: 10 F8   
    LDY   #$02               ; $9A00: A0 02   
    LDA   #$59               ; $9A02: A9 59   
    JSR   $03AB              ; $9A04: 20 AB 03
    STA.W $005D,Y            ; $9A07: 99 5D 00
    LDA   #$5B               ; $9A0A: A9 5B   
    JSR   $03AB              ; $9A0C: 20 AB 03
    STA.W $0060,Y            ; $9A0F: 99 60 00
    DEY                      ; $9A12: 88      
    BPL   $9A02              ; $9A13: 10 ED   
    LDA   $60                ; $9A15: A5 60   
    BEQ   $9A54              ; $9A17: F0 3B   
    LDA   #$00               ; $9A19: A9 00   
    STA   $64                ; $9A1B: 85 64   
    CLC                      ; $9A1D: 18      
    LDA   $60                ; $9A1E: A5 60   
    ADC   $63                ; $9A20: 65 63   
    BCS   $9A54              ; $9A22: B0 30   
    CMP   $5D                ; $9A24: C5 5D   
    BCC   $9A2A              ; $9A26: 90 02   
    BNE   $9A54              ; $9A28: D0 2A   
    LDY   $64                ; $9A2A: A4 64   
    CPY   $60                ; $9A2C: C4 60   
    BEQ   $9A4F              ; $9A2E: F0 1F   
    TYA                      ; $9A30: 98      
    CLC                      ; $9A31: 18      
    ADC   $63                ; $9A32: 65 63   
    TAY                      ; $9A34: A8      
    LDA   #$5E               ; $9A35: A9 5E   
    JSR   $03AB              ; $9A37: 20 AB 03
    STA   $79                ; $9A3A: 85 79   
    LDY   $64                ; $9A3C: A4 64   
    LDA   #$61               ; $9A3E: A9 61   
    JSR   $03AB              ; $9A40: 20 AB 03
    CMP   $79                ; $9A43: C5 79   
    BEQ   $9A4B              ; $9A45: F0 04   
    INC   $63                ; $9A47: E6 63   
    BNE   $9A19              ; $9A49: D0 CE   
    INC   $64                ; $9A4B: E6 64   
    BNE   $9A2A              ; $9A4D: D0 DB   
    INC   $63                ; $9A4F: E6 63   
    LDA   $63                ; $9A51: A5 63   
    BIT.W $00A9              ; $9A53: 2C A9 00
    STA   $FF03              ; $9A56: 8D 03 FF (MMU_LCRC_TOP)
    PHA                      ; $9A59: 48      
    LDA   $03D8              ; $9A5A: AD D8 03
    LDY   $03D9              ; $9A5D: AC D9 03
    JSR   $8785              ; $9A60: 20 85 87
    STA   $FF03              ; $9A63: 8D 03 FF (MMU_LCRC_TOP)
    LDA   $03D6              ; $9A66: AD D6 03
    LDY   $03D7              ; $9A69: AC D7 03
    JSR   $8785              ; $9A6C: 20 85 87
    PLA                      ; $9A6F: 68      
    TAY                      ; $9A70: A8      
    JMP   $84D4              ; $9A71: 4C D4 84
    JSR   $9D8F              ; $9A74: 20 8F 9D
    LDX   #$00               ; $9A77: A2 00   
    INX                      ; $9A79: E8      
    SEC                      ; $9A7A: 38      
    SBC   #$5A               ; $9A7B: E9 5A   
    BCS   $9A79              ; $9A7D: B0 FA   
    DEY                      ; $9A7F: 88      
    BPL   $9A79              ; $9A80: 10 F7   
    STX   $1149              ; $9A82: 8E 49 11
    PHA                      ; $9A85: 48      
    ADC   #$5A               ; $9A86: 69 5A   
    JSR   $9A94              ; $9A88: 20 94 9A
    PLA                      ; $9A8B: 68      
    CLC                      ; $9A8C: 18      
    EOR   #$FF               ; $9A8D: 49 FF   
    ADC   #$01               ; $9A8F: 69 01   
    DEC   $1149              ; $9A91: CE 49 11
    LDX   #$FF               ; $9A94: A2 FF   
    INX                      ; $9A96: E8      
    SEC                      ; $9A97: 38      
    SBC   #$0A               ; $9A98: E9 0A   
    BCS   $9A96              ; $9A9A: B0 FA   
    ADC   #$0A               ; $9A9C: 69 0A   
    STA   $8E                ; $9A9E: 85 8E   
    TXA                      ; $9AA0: 8A      
    ASL   A                  ; $9AA1: 0A      
    TAX                      ; $9AA2: AA      
    LDA   $9F2A,X            ; $9AA3: BD 2A 9F
    LDY   $9F29,X            ; $9AA6: BC 29 9F
    CLC                      ; $9AA9: 18      
    DEC   $8E                ; $9AAA: C6 8E   
    BMI   $9ABA              ; $9AAC: 30 0C   
    ADC   $9F3E,X            ; $9AAE: 7D 3E 9F
    PHA                      ; $9AB1: 48      
    TYA                      ; $9AB2: 98      
    ADC   $9F3D,X            ; $9AB3: 7D 3D 9F
    TAY                      ; $9AB6: A8      
    PLA                      ; $9AB7: 68      
    BCC   $9AA9              ; $9AB8: 90 EF   
    PHA                      ; $9ABA: 48      
    LDX   #$00               ; $9ABB: A2 00   
    LDA   $1149              ; $9ABD: AD 49 11
    LSR   A                  ; $9AC0: 4A      
    BCS   $9AC5              ; $9AC1: B0 02   
    LDX   #$02               ; $9AC3: A2 02   
    PLA                      ; $9AC5: 68      
    STA   $114A,X            ; $9AC6: 9D 4A 11
    TYA                      ; $9AC9: 98      
    STA   $114B,X            ; $9ACA: 9D 4B 11
    RTS                      ; $9ACD: 60      
    LDY   #$19               ; $9ACE: A0 19   
    BCC   $9AD4              ; $9AD0: 90 02   
    LDY   #$1B               ; $9AD2: A0 1B   
    LDA   $1149              ; $9AD4: AD 49 11
    ADC   #$02               ; $9AD7: 69 02   
    LSR   A                  ; $9AD9: 4A      
    LSR   A                  ; $9ADA: 4A      
    PHP                      ; $9ADB: 08      
    JSR   $9D8F              ; $9ADC: 20 8F 9D
    CPY   #$FF               ; $9ADF: C0 FF   
    BCC   $9AEA              ; $9AE1: 90 07   
    TXA                      ; $9AE3: 8A      
    TAY                      ; $9AE4: A8      
    JSR   $9D8F              ; $9AE5: 20 8F 9D
    BCS   $9AED              ; $9AE8: B0 03   
    JSR   $9DAE              ; $9AEA: 20 AE 9D
    PLP                      ; $9AED: 28      
    BCS   $9B0B              ; $9AEE: B0 1B   
    JMP   $9D9E              ; $9AF0: 4C 9E 9D
    STA   $114E              ; $9AF3: 8D 4E 11
    LDX   #$23               ; $9AF6: A2 23   
    ASL   $114E              ; $9AF8: 0E 4E 11
    JSR   $9ACE              ; $9AFB: 20 CE 9A
    STA   $1131,X            ; $9AFE: 9D 31 11
    TYA                      ; $9B01: 98      
    STA   $1132,X            ; $9B02: 9D 32 11
    INX                      ; $9B05: E8      
    INX                      ; $9B06: E8      
    CPX   #$2B               ; $9B07: E0 2B   
    BCC   $9AF8              ; $9B09: 90 ED   
    RTS                      ; $9B0B: 60      
CMD_JOY:
    JSR   $87F7              ; $9B0C: 20 F7 87
    CPX   #$02               ; $9B0F: E0 02   
    BCC   $9B23              ; $9B11: 90 10   
    BEQ   $9B18              ; $9B13: F0 03   
    JMP   $7D28              ; $9B15: 4C 28 7D
    JSR   $9C49              ; $9B18: 20 49 9C
    TAY                      ; $9B1B: A8      
    BCC   $9B20              ; $9B1C: 90 02   
    LDY   #$00               ; $9B1E: A0 00   
    JMP   $84D4              ; $9B20: 4C D4 84
    TXA                      ; $9B23: 8A      
    ASL   A                  ; $9B24: 0A      
    TAX                      ; $9B25: AA      
    LDA   $1131,X            ; $9B26: BD 31 11
    TAY                      ; $9B29: A8      
    LDA   $1132,X            ; $9B2A: BD 32 11
    JMP   $793C              ; $9B2D: 4C 3C 79
    LDX   #$02               ; $9B30: A2 02   
    LDY   #$06               ; $9B32: A0 06   
    LDA   #$00               ; $9B34: A9 00   
    STA   $113D,X            ; $9B36: 9D 3D 11
    STA   $113E,X            ; $9B39: 9D 3E 11
    JSR   $9D99              ; $9B3C: 20 99 9D
    BPL   $9B49              ; $9B3F: 10 08   
    DEC   $113D,X            ; $9B41: DE 3D 11
    DEC   $113E,X            ; $9B44: DE 3E 11
    BNE   $9B54              ; $9B47: D0 0B   
    CMP   #$00               ; $9B49: C9 00   
    BNE   $9B51              ; $9B4B: D0 04   
    CPY   #$00               ; $9B4D: C0 00   
    BEQ   $9B54              ; $9B4F: F0 03   
    INC   $113D,X            ; $9B51: FE 3D 11
    STA   $1139,X            ; $9B54: 9D 39 11
    ASL   A                  ; $9B57: 0A      
    STA   $1141,X            ; $9B58: 9D 41 11
    TYA                      ; $9B5B: 98      
    STA   $113A,X            ; $9B5C: 9D 3A 11
    ROL   A                  ; $9B5F: 2A      
    STA   $1142,X            ; $9B60: 9D 42 11
    DEX                      ; $9B63: CA      
    DEX                      ; $9B64: CA      
    LDY   #$04               ; $9B65: A0 04   
    CPX   #$00               ; $9B67: E0 00   
    BEQ   $9B34              ; $9B69: F0 C9   
    LDX   #$0A               ; $9B6B: A2 0A   
    LDY   #$08               ; $9B6D: A0 08   
    JSR   $9D7C              ; $9B6F: 20 7C 9D
    LDA   #$00               ; $9B72: A9 00   
    ROL   A                  ; $9B74: 2A      
    ROL   A                  ; $9B75: 2A      
    STA   $1147              ; $9B76: 8D 47 11
    EOR   #$02               ; $9B79: 49 02   
    STA   $1148              ; $9B7B: 8D 48 11
    CLC                      ; $9B7E: 18      
    LDA   #$10               ; $9B7F: A9 10   
    ADC   $1147              ; $9B81: 6D 47 11
    TAY                      ; $9B84: A8      
    PHA                      ; $9B85: 48      
    EOR   #$02               ; $9B86: 49 02   
    TAX                      ; $9B88: AA      
    JSR   $9D7C              ; $9B89: 20 7C 9D
    STA   $1131,X            ; $9B8C: 9D 31 11
    TYA                      ; $9B8F: 98      
    STA   $1132,X            ; $9B90: 9D 32 11
    PLA                      ; $9B93: 68      
    TAY                      ; $9B94: A8      
    CLC                      ; $9B95: 18      
    LDA   #$08               ; $9B96: A9 08   
    ADC   $1148              ; $9B98: 6D 48 11
    TAX                      ; $9B9B: AA      
    JSR   $9D7C              ; $9B9C: 20 7C 9D
    STA   $1145              ; $9B9F: 8D 45 11
    STY   $1146              ; $9BA2: 8C 46 11
    JSR   $9BFB              ; $9BA5: 20 FB 9B
    LDY   $1148              ; $9BA8: AC 48 11
    SEC                      ; $9BAB: 38      
    LDA   $1139,Y            ; $9BAC: B9 39 11
    SBC   #$01               ; $9BAF: E9 01   
    STA   $1139,Y            ; $9BB1: 99 39 11
    BCS   $9BC1              ; $9BB4: B0 0B   
    LDA   $113A,Y            ; $9BB6: B9 3A 11
    SBC   #$00               ; $9BB9: E9 00   
    STA   $113A,Y            ; $9BBB: 99 3A 11
    BCS   $9BC1              ; $9BBE: B0 01   
    RTS                      ; $9BC0: 60      
    LDX   $1147              ; $9BC1: AE 47 11
    LDA   $1146              ; $9BC4: AD 46 11
    BMI   $9BCF              ; $9BC7: 30 06   
    JSR   $9BEA              ; $9BC9: 20 EA 9B
    LDX   $1148              ; $9BCC: AE 48 11
    CLC                      ; $9BCF: 18      
    LDA   $1145              ; $9BD0: AD 45 11
    ADC   $1141,X            ; $9BD3: 7D 41 11
    STA   $1145              ; $9BD6: 8D 45 11
    LDA   $1146              ; $9BD9: AD 46 11
    ADC   $1142,X            ; $9BDC: 7D 42 11
    STA   $1146              ; $9BDF: 8D 46 11
    LDX   $1148              ; $9BE2: AE 48 11
    JSR   $9BEA              ; $9BE5: 20 EA 9B
    BEQ   $9BA5              ; $9BE8: F0 BB   
    LDY   #$02               ; $9BEA: A0 02   
    CLC                      ; $9BEC: 18      
    LDA   $1131,X            ; $9BED: BD 31 11
    ADC   $113D,X            ; $9BF0: 7D 3D 11
    STA   $1131,X            ; $9BF3: 9D 31 11
    INX                      ; $9BF6: E8      
    DEY                      ; $9BF7: 88      
    BNE   $9BED              ; $9BF8: D0 F3   
    RTS                      ; $9BFA: 60      
    LDA   $116C              ; $9BFB: AD 6C 11
    ORA   $116B              ; $9BFE: 0D 6B 11
    BEQ   $9C19              ; $9C01: F0 16   
    INC   $1131              ; $9C03: EE 31 11
    BNE   $9C0B              ; $9C06: D0 03   
    INC   $1132              ; $9C08: EE 32 11
    JSR   $9C19              ; $9C0B: 20 19 9C
    LDX   $1131              ; $9C0E: AE 31 11
    BNE   $9C16              ; $9C11: D0 03   
    DEC   $1132              ; $9C13: CE 32 11
    DEC   $1131              ; $9C16: CE 31 11
    JSR   $9D24              ; $9C19: 20 24 9D
    BCS   $9C42              ; $9C1C: B0 24   
    JSR   $9C70              ; $9C1E: 20 70 9C
    JSR   $9CE8              ; $9C21: 20 E8 9C
    STA   $116D              ; $9C24: 8D 6D 11
    LDA   ($8C),Y            ; $9C27: B1 8C   
    ORA   $116D              ; $9C29: 0D 6D 11
    BIT   $D8                ; $9C2C: 24 D8   
    BPL   $9C43              ; $9C2E: 10 13   
    PHA                      ; $9C30: 48      
    LDX   $83                ; $9C31: A6 83   
    LDA   $116D              ; $9C33: AD 6D 11
    AND   $9F25,X            ; $9C36: 3D 25 9F
    STA   $116D              ; $9C39: 8D 6D 11
    PLA                      ; $9C3C: 68      
    EOR   $116D              ; $9C3D: 4D 6D 11
    STA   ($8C),Y            ; $9C40: 91 8C   
    RTS                      ; $9C42: 60      
    LDX   $83                ; $9C43: A6 83   
    BNE   $9C40              ; $9C45: D0 F9   
    BEQ   $9C3D              ; $9C47: F0 F4   
    JSR   $9CE3              ; $9C49: 20 E3 9C
    BCS   $9C6F              ; $9C4C: B0 21   
    STA   $116D              ; $9C4E: 8D 6D 11
    LDA   ($8C),Y            ; $9C51: B1 8C   
    AND   $116D              ; $9C53: 2D 6D 11
    ROL   A                  ; $9C56: 2A      
    DEX                      ; $9C57: CA      
    BPL   $9C56              ; $9C58: 10 FC   
    ROL   A                  ; $9C5A: 2A      
    BIT   $8B                ; $9C5B: 24 8B   
    BMI   $9C65              ; $9C5D: 30 06   
    AND   #$03               ; $9C5F: 29 03   
    CMP   $83                ; $9C61: C5 83   
    CLC                      ; $9C63: 18      
    RTS                      ; $9C64: 60      
    CLC                      ; $9C65: 18      
    AND   #$03               ; $9C66: 29 03   
    BEQ   $9C6D              ; $9C68: F0 03   
    LDX   #$00               ; $9C6A: A2 00   
    RTS                      ; $9C6C: 60      
    LDX   #$FF               ; $9C6D: A2 FF   
    RTS                      ; $9C6F: 60      
    LDA   $C033,X            ; $9C70: BD 33 C0
    STA   $8C                ; $9C73: 85 8C   
    LDA   $9CCA,X            ; $9C75: BD CA 9C
    STA   $8D                ; $9C78: 85 8D   
    LDA   $83                ; $9C7A: A5 83   
    BNE   $9C86              ; $9C7C: D0 08   
    LDA   $03E2              ; $9C7E: AD E2 03
    BIT   $D8                ; $9C81: 24 D8   
    BPL   $9C8D              ; $9C83: 10 08   
    RTS                      ; $9C85: 60      
    CMP   #$02               ; $9C86: C9 02   
    BNE   $9C9A              ; $9C88: D0 10   
    LDA   $03E3              ; $9C8A: AD E3 03
    AND   #$0F               ; $9C8D: 29 0F   
    STA   $77                ; $9C8F: 85 77   
    LDA   ($8C),Y            ; $9C91: B1 8C   
    AND   #$F0               ; $9C93: 29 F0   
    ORA   $77                ; $9C95: 05 77   
    STA   ($8C),Y            ; $9C97: 91 8C   
    RTS                      ; $9C99: 60      
    BCS   $9CAC              ; $9C9A: B0 10   
    LDA   $03E2              ; $9C9C: AD E2 03
    AND   #$F0               ; $9C9F: 29 F0   
    STA   $77                ; $9CA1: 85 77   
    LDA   ($8C),Y            ; $9CA3: B1 8C   
    AND   #$0F               ; $9CA5: 29 0F   
    ORA   $77                ; $9CA7: 05 77   
    STA   ($8C),Y            ; $9CA9: 91 8C   
    RTS                      ; $9CAB: 60      
    LDA   $8D                ; $9CAC: A5 8D   
    AND   #$03               ; $9CAE: 29 03   
    ORA   #$D8               ; $9CB0: 09 D8   
    STA   $8D                ; $9CB2: 85 8D   
    LDA   #$00               ; $9CB4: A9 00   
    STA   $FF00              ; $9CB6: 8D 00 FF (MMU_CR_TOP)
    SEI                      ; $9CB9: 78      
    LDA   $01                ; $9CBA: A5 01   
    PHA                      ; $9CBC: 48      
    AND   #$FE               ; $9CBD: 29 FE   
    STA   $01                ; $9CBF: 85 01   
    LDA   $85                ; $9CC1: A5 85   
    STA   ($8C),Y            ; $9CC3: 91 8C   
    PLA                      ; $9CC5: 68      
    STA   $01                ; $9CC6: 85 01   
    CLI                      ; $9CC8: 58      
    RTS                      ; $9CC9: 60      
    .BYTE $1C                                ; $9CCA: 1C [UNRESOLVED]
    .BYTE $1C                                ; $9CCB: 1C [UNRESOLVED]
    .BYTE $1C                                ; $9CCC: 1C [UNRESOLVED]
    .BYTE $1C                                ; $9CCD: 1C [UNRESOLVED]
    .BYTE $1C                                ; $9CCE: 1C [UNRESOLVED]
    .BYTE $1C                                ; $9CCF: 1C [UNRESOLVED]
    .BYTE $1C                                ; $9CD0: 1C [UNRESOLVED]
    ORA   $1D1D,X            ; $9CD1: 1D 1D 1D
    ORA   $1D1D,X            ; $9CD4: 1D 1D 1D
    ASL   $1E1E,X            ; $9CD7: 1E 1E 1E
    ASL   $1E1E,X            ; $9CDA: 1E 1E 1E
    ASL   $1F1F,X            ; $9CDD: 1E 1F 1F
    .BYTE $1F                                ; $9CE0: 1F [UNRESOLVED]
    .BYTE $1F                                ; $9CE1: 1F [UNRESOLVED]
    .BYTE $1F                                ; $9CE2: 1F [UNRESOLVED]
    JSR   $9D24              ; $9CE3: 20 24 9D
    BCS   $9D1B              ; $9CE6: B0 33   
    TYA                      ; $9CE8: 98      
    CLC                      ; $9CE9: 18      
    ADC   $C033,X            ; $9CEA: 7D 33 C0
    STA   $8C                ; $9CED: 85 8C   
    LDA   $C04C,X            ; $9CEF: BD 4C C0
    ADC   #$00               ; $9CF2: 69 00   
    ASL   $8C                ; $9CF4: 06 8C   
    ROL   A                  ; $9CF6: 2A      
    ASL   $8C                ; $9CF7: 06 8C   
    ROL   A                  ; $9CF9: 2A      
    ASL   $8C                ; $9CFA: 06 8C   
    ROL   A                  ; $9CFC: 2A      
    STA   $8D                ; $9CFD: 85 8D   
    LDA   $1133              ; $9CFF: AD 33 11
    AND   #$07               ; $9D02: 29 07   
    TAY                      ; $9D04: A8      
    LDA   $1131              ; $9D05: AD 31 11
    BIT   $D8                ; $9D08: 24 D8   
    PHP                      ; $9D0A: 08      
    BPL   $9D0E              ; $9D0B: 10 01   
    ASL   A                  ; $9D0D: 0A      
    AND   #$07               ; $9D0E: 29 07   
    TAX                      ; $9D10: AA      
    LDA   $9D1C,X            ; $9D11: BD 1C 9D
    PLP                      ; $9D14: 28      
    BPL   $9D1B              ; $9D15: 10 04   
    INX                      ; $9D17: E8      
    ORA   $9D1C,X            ; $9D18: 1D 1C 9D
    RTS                      ; $9D1B: 60      
    .BYTE $80                                ; $9D1C: 80 [UNRESOLVED]
    RTI                      ; $9D1D: 40      
    JSR   $0810              ; $9D1E: 20 10 08
    .BYTE $04                                ; $9D21: 04 [UNRESOLVED]
    .BYTE $02                                ; $9D22: 02 [UNRESOLVED]
    ORA   ($AD,X)            ; $9D23: 01 AD   
    .BYTE $32                                ; $9D25: 32 [UNRESOLVED]
    ORA   ($4A),Y            ; $9D26: 11 4A   
    BNE   $9D48              ; $9D28: D0 1E   
    LDA   $1131              ; $9D2A: AD 31 11
    ROR   A                  ; $9D2D: 6A      
    LSR   A                  ; $9D2E: 4A      
    BIT   $D8                ; $9D2F: 24 D8   
    BMI   $9D34              ; $9D31: 30 01   
    LSR   A                  ; $9D33: 4A      
    TAY                      ; $9D34: A8      
    CPY   #$28               ; $9D35: C0 28   
    BCS   $9D48              ; $9D37: B0 0F   
    LDA   $1134              ; $9D39: AD 34 11
    BNE   $9D48              ; $9D3C: D0 0A   
    LDA   $1133              ; $9D3E: AD 33 11
    LSR   A                  ; $9D41: 4A      
    LSR   A                  ; $9D42: 4A      
    LSR   A                  ; $9D43: 4A      
    TAX                      ; $9D44: AA      
    CMP   #$19               ; $9D45: C9 19   
    RTS                      ; $9D47: 60      
    SEC                      ; $9D48: 38      
    RTS                      ; $9D49: 60      
    LDA   $116A              ; $9D4A: AD 6A 11
    BEQ   $9D66              ; $9D4D: F0 17   
    LDA   $87                ; $9D4F: A5 87   
    LDY   $88                ; $9D51: A4 88   
    JSR   $9D5A              ; $9D53: 20 5A 9D
    LDA   $89                ; $9D56: A5 89   
    LDY   $8A                ; $9D58: A4 8A   
    JSR   $9DAE              ; $9D5A: 20 AE 9D
    STA   $1131,X            ; $9D5D: 9D 31 11
    TYA                      ; $9D60: 98      
    INX                      ; $9D61: E8      
    STA   $1131,X            ; $9D62: 9D 31 11
    INX                      ; $9D65: E8      
    RTS                      ; $9D66: 60      
    BCC   $9D70              ; $9D67: 90 07   
    BCS   $9D7F              ; $9D69: B0 14   
    BCS   $9D7C              ; $9D6B: B0 0F   
    JSR   $9D8F              ; $9D6D: 20 8F 9D
    CLC                      ; $9D70: 18      
    ADC   $1131,X            ; $9D71: 7D 31 11
    PHA                      ; $9D74: 48      
    TYA                      ; $9D75: 98      
    ADC   $1132,X            ; $9D76: 7D 32 11
    TAY                      ; $9D79: A8      
    PLA                      ; $9D7A: 68      
    RTS                      ; $9D7B: 60      
    JSR   $9D8F              ; $9D7C: 20 8F 9D
    SEC                      ; $9D7F: 38      
    SBC   $1131,X            ; $9D80: FD 31 11
    STA   $59                ; $9D83: 85 59   
    TYA                      ; $9D85: 98      
    SBC   $1132,X            ; $9D86: FD 32 11
    TAY                      ; $9D89: A8      
    PHP                      ; $9D8A: 08      
    LDA   $59                ; $9D8B: A5 59   
    PLP                      ; $9D8D: 28      
    RTS                      ; $9D8E: 60      
    LDA   $1131,Y            ; $9D8F: B9 31 11
    PHA                      ; $9D92: 48      
    LDA   $1132,Y            ; $9D93: B9 32 11
    TAY                      ; $9D96: A8      
    PLA                      ; $9D97: 68      
    RTS                      ; $9D98: 60      
    JSR   $9D7C              ; $9D99: 20 7C 9D
    BPL   $9DAD              ; $9D9C: 10 0F   
    PHP                      ; $9D9E: 08      
    CLC                      ; $9D9F: 18      
    EOR   #$FF               ; $9DA0: 49 FF   
    ADC   #$01               ; $9DA2: 69 01   
    PHA                      ; $9DA4: 48      
    TYA                      ; $9DA5: 98      
    EOR   #$FF               ; $9DA6: 49 FF   
    ADC   #$00               ; $9DA8: 69 00   
    TAY                      ; $9DAA: A8      
    PLA                      ; $9DAB: 68      
    PLP                      ; $9DAC: 28      
    RTS                      ; $9DAD: 60      
    STY   $8E                ; $9DAE: 84 8E   
    STA   $8F                ; $9DB0: 85 8F   
    LDA   $1131,X            ; $9DB2: BD 31 11
    LDY   $1132,X            ; $9DB5: BC 32 11
    PHP                      ; $9DB8: 08      
    JSR   $9D9C              ; $9DB9: 20 9C 9D
    STA   $1131,X            ; $9DBC: 9D 31 11
    TYA                      ; $9DBF: 98      
    STA   $1132,X            ; $9DC0: 9D 32 11
    LDA   #$00               ; $9DC3: A9 00   
    STA   $1177              ; $9DC5: 8D 77 11
    LDY   #$10               ; $9DC8: A0 10   
    LSR   $8E                ; $9DCA: 46 8E   
    ROR   $8F                ; $9DCC: 66 8F   
    BCC   $9DDF              ; $9DCE: 90 0F   
    CLC                      ; $9DD0: 18      
    ADC   $1131,X            ; $9DD1: 7D 31 11
    PHA                      ; $9DD4: 48      
    LDA   $1177              ; $9DD5: AD 77 11
    ADC   $1132,X            ; $9DD8: 7D 32 11
    STA   $1177              ; $9DDB: 8D 77 11
    PLA                      ; $9DDE: 68      
    LSR   $1177              ; $9DDF: 4E 77 11
    ROR   A                  ; $9DE2: 6A      
    DEY                      ; $9DE3: 88      
    BNE   $9DCA              ; $9DE4: D0 E4   
    ADC   #$00               ; $9DE6: 69 00   
    LDY   $1177              ; $9DE8: AC 77 11
    BCC   $9DEE              ; $9DEB: 90 01   
    INY                      ; $9DED: C8      
    PLP                      ; $9DEE: 28      
    JMP   $9D9C              ; $9DEF: 4C 9C 9D
    LDY   #$00               ; $9DF2: A0 00   
    JSR   $9DF9              ; $9DF4: 20 F9 9D
    LDY   #$02               ; $9DF7: A0 02   
    LDA   $1135,Y            ; $9DF9: B9 35 11
    STA   $1131,Y            ; $9DFC: 99 31 11
    LDA   $1136,Y            ; $9DFF: B9 36 11
    STA   $1132,Y            ; $9E02: 99 32 11
    RTS                      ; $9E05: 60      
    JSR   $0386              ; $9E06: 20 86 03
    BEQ   $9E17              ; $9E09: F0 0C   
    JSR   $795C              ; $9E0B: 20 5C 79
    CMP   #$2C               ; $9E0E: C9 2C   
    BEQ   $9E17              ; $9E10: F0 05   
    JSR   $8812              ; $9E12: 20 12 88
    SEC                      ; $9E15: 38      
    RTS                      ; $9E16: 60      
    LDA   #$00               ; $9E17: A9 00   
    TAY                      ; $9E19: A8      
    CLC                      ; $9E1A: 18      
    RTS                      ; $9E1B: 60      
    LDX   #$00               ; $9E1C: A2 00   
    JSR   $0386              ; $9E1E: 20 86 03
    BEQ   $9E1A              ; $9E21: F0 F7   
    JSR   $795C              ; $9E23: 20 5C 79
    CMP   #$2C               ; $9E26: C9 2C   
    BEQ   $9E1A              ; $9E28: F0 F0   
    JSR   $87F4              ; $9E2A: 20 F4 87
    SEC                      ; $9E2D: 38      
    RTS                      ; $9E2E: 60      
    JSR   $A074              ; $9E2F: 20 74 A0
    LDX   #$01               ; $9E32: A2 01   
    JSR   $0386              ; $9E34: 20 86 03
    BEQ   $9E4C              ; $9E37: F0 13   
    CMP   #$2C               ; $9E39: C9 2C   
    BEQ   $9E4C              ; $9E3B: F0 0F   
    JSR   $87F4              ; $9E3D: 20 F4 87
    CPX   #$04               ; $9E40: E0 04   
    BCS   $9E4F              ; $9E42: B0 0B   
    CPX   #$02               ; $9E44: E0 02   
    BIT   $D8                ; $9E46: 24 D8   
    BMI   $9E4C              ; $9E48: 30 02   
    BCS   $9E4F              ; $9E4A: B0 03   
    STX   $83                ; $9E4C: 86 83   
    RTS                      ; $9E4E: 60      
    JMP   $7D28              ; $9E4F: 4C 28 7D
    JSR   $0386              ; $9E52: 20 86 03
    BEQ   $9E5E              ; $9E55: F0 07   
    JSR   $795C              ; $9E57: 20 5C 79
    CMP   #$2C               ; $9E5A: C9 2C   
    BNE   $9E70              ; $9E5C: D0 12   
    LDY   #$00               ; $9E5E: A0 00   
    LDA   $1131,Y            ; $9E60: B9 31 11
    STA   $1131,X            ; $9E63: 9D 31 11
    INX                      ; $9E66: E8      
    INY                      ; $9E67: C8      
    CPY   #$04               ; $9E68: C0 04   
    BNE   $9E60              ; $9E6A: D0 F4   
    RTS                      ; $9E6C: 60      
    JSR   $795C              ; $9E6D: 20 5C 79
    STX   $1178              ; $9E70: 8E 78 11
    JSR   $9F08              ; $9E73: 20 08 9F
    JSR   $0386              ; $9E76: 20 86 03
    CMP   #$2C               ; $9E79: C9 2C   
    BEQ   $9ED3              ; $9E7B: F0 56   
    CMP   #$3B               ; $9E7D: C9 3B   
    BEQ   $9E84              ; $9E7F: F0 03   
    JMP   $796C              ; $9E81: 4C 6C 79 (CMD_FE_BEGIN)
    JSR   $0380              ; $9E84: 20 80 03
    JSR   $8812              ; $9E87: 20 12 88
    STA   $77                ; $9E8A: 85 77   
    TYA                      ; $9E8C: 98      
    LDY   $77                ; $9E8D: A4 77   
    JSR   $9A77              ; $9E8F: 20 77 9A
    LDX   $1178              ; $9E92: AE 78 11
    LDA   $1131,X            ; $9E95: BD 31 11
    STA   $1133,X            ; $9E98: 9D 33 11
    LDA   $1132,X            ; $9E9B: BD 32 11
    STA   $1134,X            ; $9E9E: 9D 34 11
    JSR   $9D4A              ; $9EA1: 20 4A 9D
    LDA   #$0E               ; $9EA4: A9 0E   
    STA   $1179              ; $9EA6: 8D 79 11
    CLC                      ; $9EA9: 18      
    LDX   $1178              ; $9EAA: AE 78 11
    JSR   $9ACE              ; $9EAD: 20 CE 9A
    STA   $1131,X            ; $9EB0: 9D 31 11
    TYA                      ; $9EB3: 98      
    STA   $1132,X            ; $9EB4: 9D 32 11
    LDY   #$00               ; $9EB7: A0 00   
    LSR   $1179              ; $9EB9: 4E 79 11
    BCC   $9EC0              ; $9EBC: 90 02   
    LDY   #$02               ; $9EBE: A0 02   
    JSR   $9D6B              ; $9EC0: 20 6B 9D
    STA   $1131,X            ; $9EC3: 9D 31 11
    TYA                      ; $9EC6: 98      
    STA   $1132,X            ; $9EC7: 9D 32 11
    INX                      ; $9ECA: E8      
    INX                      ; $9ECB: E8      
    LSR   $1179              ; $9ECC: 4E 79 11
    BNE   $9EAD              ; $9ECF: D0 DC   
    CLC                      ; $9ED1: 18      
    RTS                      ; $9ED2: 60      
    JSR   $0380              ; $9ED3: 20 80 03
    INC   $1178              ; $9ED6: EE 78 11
    INC   $1178              ; $9ED9: EE 78 11
    JSR   $9F08              ; $9EDC: 20 08 9F
    LDX   $1178              ; $9EDF: AE 78 11
    DEX                      ; $9EE2: CA      
    DEX                      ; $9EE3: CA      
    JSR   $9D4A              ; $9EE4: 20 4A 9D
    LDY   #$02               ; $9EE7: A0 02   
    LDX   $1178              ; $9EE9: AE 78 11
    INX                      ; $9EEC: E8      
    INX                      ; $9EED: E8      
    DEX                      ; $9EEE: CA      
    DEX                      ; $9EEF: CA      
    LSR   $1179              ; $9EF0: 4E 79 11
    BCC   $9EFF              ; $9EF3: 90 0A   
    JSR   $9D6D              ; $9EF5: 20 6D 9D
    STA   $1131,X            ; $9EF8: 9D 31 11
    TYA                      ; $9EFB: 98      
    STA   $1132,X            ; $9EFC: 9D 32 11
    LDY   #$00               ; $9EFF: A0 00   
    CPX   $1178              ; $9F01: EC 78 11
    BEQ   $9EEE              ; $9F04: F0 E8   
    CLC                      ; $9F06: 18      
    RTS                      ; $9F07: 60      
    JSR   $0386              ; $9F08: 20 86 03
    CMP   #$AA               ; $9F0B: C9 AA   
    BEQ   $9F14              ; $9F0D: F0 05   
    CMP   #$AB               ; $9F0F: C9 AB   
    BEQ   $9F14              ; $9F11: F0 01   
    CLC                      ; $9F13: 18      
    ROL   $1179              ; $9F14: 2E 79 11
    JSR   $8812              ; $9F17: 20 12 88
    LDX   $1178              ; $9F1A: AE 78 11
    STA   $1132,X            ; $9F1D: 9D 32 11
    TYA                      ; $9F20: 98      
    STA   $1131,X            ; $9F21: 9D 31 11
    RTS                      ; $9F24: 60      
; --- [DATA] Bitmapped Graphics Bitmask & Scale Lookup Tables ($9F25-$9F4E) ---
    .BYTE $FF, $AA, $55, $00, $00, $00, $2C, $71 ; $9F25 [IDENTIFIED_DATA] |..U...,q|
    .BYTE $57, $8D, $80, $00, $A4, $8F, $C4, $19 ; $9F2D [IDENTIFIED_DATA] |W.......|
    .BYTE $DD, $B2, $F0, $90, $FC, $1C, $FF, $FF ; $9F35 [IDENTIFIED_DATA] |........|
    .BYTE $04, $72, $04, $50, $04, $0B, $03, $A8 ; $9F3D [IDENTIFIED_DATA] |.r.P....|
    .BYTE $03, $28, $02, $90, $01, $E3, $01, $28 ; $9F45 [IDENTIFIED_DATA] |.(.....(|
    .BYTE $00, $63                               ; $9F4D [IDENTIFIED_DATA] |.c|
    LDA   $76                ; $9F4F: A5 76   
    BEQ   $9F54              ; $9F51: F0 01   
    RTS                      ; $9F53: 60      
    LDA   $1211              ; $9F54: AD 11 12
    CLC                      ; $9F57: 18      
    ADC   #$24               ; $9F58: 69 24   
    BCS   $9F6A              ; $9F5A: B0 0E   
    STA   $62                ; $9F5C: 85 62   
    CMP   $1213              ; $9F5E: CD 13 12
    BCC   $9F6D              ; $9F61: 90 0A   
    BNE   $9F6A              ; $9F63: D0 05   
    CPY   $1212              ; $9F65: CC 12 12
    BCC   $9F6D              ; $9F68: 90 03   
    JMP   $4D3A              ; $9F6A: 4C 3A 4D
    DEC   $76                ; $9F6D: C6 76   
    LDA   $1210              ; $9F6F: AD 10 12
    STA   $24                ; $9F72: 85 24   
    LDA   $62                ; $9F74: A5 62   
    STA   $25                ; $9F76: 85 25   
    LDX   $1210              ; $9F78: AE 10 12
    STX   $26                ; $9F7B: 86 26   
    LDA   $1211              ; $9F7D: AD 11 12
    STA   $27                ; $9F80: 85 27   
    SEC                      ; $9F82: 38      
    SBC   #$1C               ; $9F83: E9 1C   
    TAY                      ; $9F85: A8      
    TXA                      ; $9F86: 8A      
    EOR   #$FF               ; $9F87: 49 FF   
    STA   $50                ; $9F89: 85 50   
    TYA                      ; $9F8B: 98      
    EOR   #$FF               ; $9F8C: 49 FF   
    STA   $51                ; $9F8E: 85 51   
    LDY   #$00               ; $9F90: A0 00   
    INC   $50                ; $9F92: E6 50   
    BNE   $9F9A              ; $9F94: D0 04   
    INC   $51                ; $9F96: E6 51   
    BEQ   $9FB2              ; $9F98: F0 18   
    LDA   $24                ; $9F9A: A5 24   
    BNE   $9FA0              ; $9F9C: D0 02   
    DEC   $25                ; $9F9E: C6 25   
    DEC   $24                ; $9FA0: C6 24   
    LDA   $26                ; $9FA2: A5 26   
    BNE   $9FA8              ; $9FA4: D0 02   
    DEC   $27                ; $9FA6: C6 27   
    DEC   $26                ; $9FA8: C6 26   
    JSR   $03C0              ; $9FAA: 20 C0 03
    STA   ($24),Y            ; $9FAD: 91 24   
    JMP   $9F92              ; $9FAF: 4C 92 9F
    CLC                      ; $9FB2: 18      
    LDA   $1211              ; $9FB3: AD 11 12
    ADC   #$24               ; $9FB6: 69 24   
    STA   $1211              ; $9FB8: 8D 11 12
    LDA   $2E                ; $9FBB: A5 2E   
    ADC   #$24               ; $9FBD: 69 24   
    STA   $2E                ; $9FBF: 85 2E   
    LDA   $44                ; $9FC1: A5 44   
    ADC   #$24               ; $9FC3: 69 24   
    STA   $44                ; $9FC5: 85 44   
    JSR   $4F4F              ; $9FC7: 20 4F 4F
    JSR   $4F82              ; $9FCA: 20 82 4F
    BIT   $7F                ; $9FCD: 24 7F   
    BPL   $9FFE              ; $9FCF: 10 2D   
    LDX   #$24               ; $9FD1: A2 24   
    BIT   $76                ; $9FD3: 24 76   
    BMI   $9FD9              ; $9FD5: 30 02   
    LDX   #$DC               ; $9FD7: A2 DC   
    TXA                      ; $9FD9: 8A      
    CLC                      ; $9FDA: 18      
    ADC   $3E                ; $9FDB: 65 3E   
    STA   $3E                ; $9FDD: 85 3E   
    TXA                      ; $9FDF: 8A      
    CLC                      ; $9FE0: 18      
    ADC   $1203              ; $9FE1: 6D 03 12
    STA   $1203              ; $9FE4: 8D 03 12
    TXA                      ; $9FE7: 8A      
    CLC                      ; $9FE8: 18      
    ADC   $120F              ; $9FE9: 6D 0F 12
    STA   $120F              ; $9FEC: 8D 0F 12
    JSR   $5047              ; $9FEF: 20 47 50
    LDA   $3F                ; $9FF2: A5 3F   
    CMP   #$FF               ; $9FF4: C9 FF   
    BNE   $9FFF              ; $9FF6: D0 07   
    LDA   $40                ; $9FF8: A5 40   
    CMP   #$09               ; $9FFA: C9 09   
    BNE   $9FFF              ; $9FFC: D0 01   
    RTS                      ; $9FFE: 60      
    LDY   #$00               ; $9FFF: A0 00   
    LDA   ($3F),Y            ; $A001: B1 3F   
    CMP   #$81               ; $A003: C9 81   
    BNE   $A010              ; $A005: D0 09   
    LDY   #$10               ; $A007: A0 10   
    JSR   $A062              ; $A009: 20 62 A0
    LDA   #$12               ; $A00C: A9 12   
    BNE   $A017              ; $A00E: D0 07   
    LDY   #$04               ; $A010: A0 04   
    JSR   $A062              ; $A012: 20 62 A0
    LDA   #$05               ; $A015: A9 05   
    CLC                      ; $A017: 18      
    ADC   $3F                ; $A018: 65 3F   
    STA   $3F                ; $A01A: 85 3F   
    BCC   $9FF2              ; $A01C: 90 D4   
    INC   $40                ; $A01E: E6 40   
    BNE   $9FF2              ; $A020: D0 D0   
    LDA   $76                ; $A022: A5 76   
    BNE   $A027              ; $A024: D0 01   
    RTS                      ; $A026: 60      
    LDY   #$00               ; $A027: A0 00   
    STY   $76                ; $A029: 84 76   
    STY   $24                ; $A02B: 84 24   
    STY   $26                ; $A02D: 84 26   
    LDA   #$1C               ; $A02F: A9 1C   
    STA   $25                ; $A031: 85 25   
    LDA   #$40               ; $A033: A9 40   
    STA   $27                ; $A035: 85 27   
    JSR   $03C0              ; $A037: 20 C0 03
    STA   ($24),Y            ; $A03A: 91 24   
    INY                      ; $A03C: C8      
    BNE   $A037              ; $A03D: D0 F8   
    INC   $25                ; $A03F: E6 25   
    INC   $27                ; $A041: E6 27   
    LDA   $1211              ; $A043: AD 11 12
    CMP   $27                ; $A046: C5 27   
    BCS   $A037              ; $A048: B0 ED   
    SEC                      ; $A04A: 38      
    LDA   $2E                ; $A04B: A5 2E   
    SBC   #$24               ; $A04D: E9 24   
    STA   $2E                ; $A04F: 85 2E   
    LDA   $1211              ; $A051: AD 11 12
    SBC   #$24               ; $A054: E9 24   
    STA   $1211              ; $A056: 8D 11 12
    LDA   $44                ; $A059: A5 44   
    SBC   #$24               ; $A05B: E9 24   
    STA   $44                ; $A05D: 85 44   
    JMP   $9FC7              ; $A05F: 4C C7 9F
    LDA   ($3F),Y            ; $A062: B1 3F   
    BIT   $76                ; $A064: 24 76   
    BNE   $A06E              ; $A066: D0 06   
    SEC                      ; $A068: 38      
    SBC   #$24               ; $A069: E9 24   
    STA   ($3F),Y            ; $A06B: 91 3F   
    RTS                      ; $A06D: 60      
    CLC                      ; $A06E: 18      
    ADC   #$24               ; $A06F: 69 24   
    STA   ($3F),Y            ; $A071: 91 3F   
    RTS                      ; $A073: 60      
    LDA   $76                ; $A074: A5 76   
    BEQ   $A079              ; $A076: F0 01   
    RTS                      ; $A078: 60      
    LDX   #$23               ; $A079: A2 23   
    JMP   $4D3C              ; $A07B: 4C 3C 4D (BASIC_ERROR_ENTRY)
CMD_DIRECTORY:
    JSR   $A3BF              ; $A07E: 20 BF A3
    LDA   $80                ; $A081: A5 80   
    AND   #$E6               ; $A083: 29 E6   
    BEQ   $A08A              ; $A085: F0 03   
    JMP   $796C              ; $A087: 4C 6C 79 (CMD_FE_BEGIN)
    LDY   #$01               ; $A08A: A0 01   
    LDX   #$01               ; $A08C: A2 01   
    LDA   $80                ; $A08E: A5 80   
    AND   #$11               ; $A090: 29 11   
    BEQ   $A09A              ; $A092: F0 06   
    LSR   A                  ; $A094: 4A      
    BCC   $A099              ; $A095: 90 02   
    INX                      ; $A097: E8      
    INX                      ; $A098: E8      
    INX                      ; $A099: E8      
    TXA                      ; $A09A: 8A      
    JSR   $A667              ; $A09B: 20 67 A6
    LDA   #$00               ; $A09E: A9 00   
    TAX                      ; $A0A0: AA      
    JSR   $9287              ; $A0A1: 20 87 92
    LDY   #$60               ; $A0A4: A0 60   
    LDX   $011C              ; $A0A6: AE 1C 01
    LDA   #$00               ; $A0A9: A9 00   
    JSR   $9257              ; $A0AB: 20 57 92
    SEC                      ; $A0AE: 38      
    JSR   $90D8              ; $A0AF: 20 D8 90
    BCC   $A0BD              ; $A0B2: 90 09   
    PHA                      ; $A0B4: 48      
    JSR   $A114              ; $A0B5: 20 14 A1
    PLA                      ; $A0B8: 68      
    TAX                      ; $A0B9: AA      
    JMP   $4D3C              ; $A0BA: 4C 3C 4D (BASIC_ERROR_ENTRY)
    LDX   #$00               ; $A0BD: A2 00   
    JSR   $A845              ; $A0BF: 20 45 A8
    JSR   $FFC6              ; $A0C2: 20 C6 FF (J_CHKIN)
    LDY   #$03               ; $A0C5: A0 03   
    STY   $1174              ; $A0C7: 8C 74 11
    JSR   $9263              ; $A0CA: 20 63 92
    STA   $1175              ; $A0CD: 8D 75 11
    JSR   $9251              ; $A0D0: 20 51 92
    BNE   $A114              ; $A0D3: D0 3F   
    JSR   $9263              ; $A0D5: 20 63 92
    STA   $1176              ; $A0D8: 8D 76 11
    JSR   $9251              ; $A0DB: 20 51 92
    BNE   $A114              ; $A0DE: D0 34   
    DEC   $1174              ; $A0E0: CE 74 11
    BNE   $A0CA              ; $A0E3: D0 E5   
    LDX   $1175              ; $A0E5: AE 75 11
    LDA   $1176              ; $A0E8: AD 76 11
    JSR   $8E32              ; $A0EB: 20 32 8E
    LDA   #$20               ; $A0EE: A9 20   
    JSR   $9269              ; $A0F0: 20 69 92
    JSR   $9263              ; $A0F3: 20 63 92
    PHA                      ; $A0F6: 48      
    JSR   $9251              ; $A0F7: 20 51 92
    BNE   $A113              ; $A0FA: D0 17   
    PLA                      ; $A0FC: 68      
    BEQ   $A105              ; $A0FD: F0 06   
    JSR   $9269              ; $A0FF: 20 69 92
    JMP   $A0F3              ; $A102: 4C F3 A0
    LDA   #$0D               ; $A105: A9 0D   
    JSR   $9269              ; $A107: 20 69 92
    JSR   $9293              ; $A10A: 20 93 92
    BEQ   $A114              ; $A10D: F0 05   
    LDY   #$02               ; $A10F: A0 02   
    BNE   $A0C7              ; $A111: D0 B4   
    PLA                      ; $A113: 68      
    JSR   $926F              ; $A114: 20 6F 92
    LDA   #$00               ; $A117: A9 00   
    CLC                      ; $A119: 18      
    JMP   $9275              ; $A11A: 4C 75 92
CMD_FE_DOPEN:
    LDA   #$22               ; $A11D: A9 22   
    JSR   $A3C1              ; $A11F: 20 C1 A3
    JSR   $A76F              ; $A122: 20 6F A7
    JSR   $A157              ; $A125: 20 57 A1
    LDY   #$05               ; $A128: A0 05   
    LDX   #$04               ; $A12A: A2 04   
    BIT   $80                ; $A12C: 24 80   
    BVC   $A143              ; $A12E: 50 13   
    LDX   #$08               ; $A130: A2 08   
    BNE   $A143              ; $A132: D0 0F   
CMD_FE_APPEND:
    LDA   #$E2               ; $A134: A9 E2   
    JSR   $A3C1              ; $A136: 20 C1 A3
    JSR   $A76F              ; $A139: 20 6F A7
    JSR   $A157              ; $A13C: 20 57 A1
    LDY   #$16               ; $A13F: A0 16   
    LDX   #$05               ; $A141: A2 05   
    TXA                      ; $A143: 8A      
    JSR   $A667              ; $A144: 20 67 A6
    JSR   $926F              ; $A147: 20 6F 92
    LDA   #$00               ; $A14A: A9 00   
    TAX                      ; $A14C: AA      
    JSR   $9287              ; $A14D: 20 87 92
    JSR   $90D8              ; $A150: 20 D8 90
    SEC                      ; $A153: 38      
    JMP   $9275              ; $A154: 4C 75 92
    LDY   #$61               ; $A157: A0 61   
    INY                      ; $A159: C8      
    CPY   #$6F               ; $A15A: C0 6F   
    BEQ   $A16A              ; $A15C: F0 0C   
    JSR   $A845              ; $A15E: 20 45 A8
    JSR   $FF5C              ; $A161: 20 5C FF (J_LKUPSA)
    BCC   $A159              ; $A164: 90 F3   
    STY   $011D              ; $A166: 8C 1D 01
    RTS                      ; $A169: 60      
    LDX   #$01               ; $A16A: A2 01   
    JMP   $4D3C              ; $A16C: 4C 3C 4D (BASIC_ERROR_ENTRY)
CMD_FE_DCLOSE:
    LDA   #$F3               ; $A16F: A9 F3   
    JSR   $A3C1              ; $A171: 20 C1 A3
    JSR   $A80D              ; $A174: 20 0D A8
    LDA   $80                ; $A177: A5 80   
    AND   #$04               ; $A179: 29 04   
    BEQ   $A183              ; $A17B: F0 06   
    LDA   $011B              ; $A17D: AD 1B 01
    JMP   $9275              ; $A180: 4C 75 92
    LDA   $011C              ; $A183: AD 1C 01
    JSR   $A845              ; $A186: 20 45 A8
    JMP   $FF4A              ; $A189: 4C 4A FF (J_CLOSE_ALL)
CMD_DSAVE:
    LDA   #$66               ; $A18C: A9 66   
    JSR   $A3C1              ; $A18E: 20 C1 A3
    JSR   $A750              ; $A191: 20 50 A7
    LDY   #$05               ; $A194: A0 05   
    LDA   #$04               ; $A196: A9 04   
    JSR   $A667              ; $A198: 20 67 A6
    LDA   #$00               ; $A19B: A9 00   
    TAX                      ; $A19D: AA      
    JSR   $9287              ; $A19E: 20 87 92
    JMP   $9115              ; $A1A1: 4C 15 91
CMD_FE_DVERIFY:
    LDA   #$01               ; $A1A4: A9 01   
    BIT.W $00A9              ; $A1A6: 2C A9 00
    STA   $0C                ; $A1A9: 85 0C   
    LDA   #$E6               ; $A1AB: A9 E6   
    JSR   $A3C1              ; $A1AD: 20 C1 A3
    JSR   $A750              ; $A1B0: 20 50 A7
    LDA   #$00               ; $A1B3: A9 00   
    STA   $011D              ; $A1B5: 8D 1D 01
    LDY   #$05               ; $A1B8: A0 05   
    LDA   #$04               ; $A1BA: A9 04   
    JSR   $A667              ; $A1BC: 20 67 A6
    LDA   #$00               ; $A1BF: A9 00   
    TAX                      ; $A1C1: AA      
    JSR   $9287              ; $A1C2: 20 87 92
    JMP   $9133              ; $A1C5: 4C 33 91
CMD_FE_BSAVE:
    LDA   #$66               ; $A1C8: A9 66   
    LDX   #$F8               ; $A1CA: A2 F8   
    JSR   $A3C3              ; $A1CC: 20 C3 A3
    JSR   $A750              ; $A1CF: 20 50 A7
    LDA   $81                ; $A1D2: A5 81   
    AND   #$06               ; $A1D4: 29 06   
    CMP   #$06               ; $A1D6: C9 06   
    BEQ   $A1DD              ; $A1D8: F0 03   
    JMP   $796C              ; $A1DA: 4C 6C 79 (CMD_FE_BEGIN)
    LDA   $011A              ; $A1DD: AD 1A 01
    CMP   $0118              ; $A1E0: CD 18 01
    BCC   $A215              ; $A1E3: 90 30   
    BNE   $A1F1              ; $A1E5: D0 0A   
    LDA   $0119              ; $A1E7: AD 19 01
    CMP   $0117              ; $A1EA: CD 17 01
    BCC   $A215              ; $A1ED: 90 26   
    BEQ   $A215              ; $A1EF: F0 24   
    LDY   #$05               ; $A1F1: A0 05   
    LDA   #$04               ; $A1F3: A9 04   
    JSR   $A667              ; $A1F5: 20 67 A6
    LDA   $011F              ; $A1F8: AD 1F 01
    LDX   #$00               ; $A1FB: A2 00   
    JSR   $9287              ; $A1FD: 20 87 92
    LDX   $0117              ; $A200: AE 17 01
    LDY   $0118              ; $A203: AC 18 01
    LDA   #$5A               ; $A206: A9 5A   
    STX   $5A                ; $A208: 86 5A   
    STY   $5B                ; $A20A: 84 5B   
    LDX   $0119              ; $A20C: AE 19 01
    LDY   $011A              ; $A20F: AC 1A 01
    JMP   $911D              ; $A212: 4C 1D 91
    JMP   $7D28              ; $A215: 4C 28 7D
CMD_FE_BLOAD:
    LDA   #$E6               ; $A218: A9 E6   
    LDX   #$FC               ; $A21A: A2 FC   
    JSR   $A3C3              ; $A21C: 20 C3 A3
    JSR   $A750              ; $A21F: 20 50 A7
    LDX   $0117              ; $A222: AE 17 01
    LDY   $0118              ; $A225: AC 18 01
    LDA   #$00               ; $A228: A9 00   
    CPX   #$FF               ; $A22A: E0 FF   
    BNE   $A234              ; $A22C: D0 06   
    CPY   #$FF               ; $A22E: C0 FF   
    BNE   $A234              ; $A230: D0 02   
    LDA   #$FF               ; $A232: A9 FF   
    STA   $011D              ; $A234: 8D 1D 01
    LDY   #$05               ; $A237: A0 05   
    LDA   #$04               ; $A239: A9 04   
    JSR   $A667              ; $A23B: 20 67 A6
    LDA   $011F              ; $A23E: AD 1F 01
    LDX   #$00               ; $A241: A2 00   
    JSR   $9287              ; $A243: 20 87 92
    LDA   #$00               ; $A246: A9 00   
    LDX   $0117              ; $A248: AE 17 01
    LDY   $0118              ; $A24B: AC 18 01
    JSR   $FFD5              ; $A24E: 20 D5 FF (J_LOAD)
    PHP                      ; $A251: 08      
    JSR   $9243              ; $A252: 20 43 92
    PLP                      ; $A255: 28      
    BCC   $A25B              ; $A256: 90 03   
    JMP   $90D0              ; $A258: 4C D0 90
    JSR   $9251              ; $A25B: 20 51 92
    AND   #$BF               ; $A25E: 29 BF   
    BEQ   $A265              ; $A260: F0 03   
    JMP   $9167              ; $A262: 4C 67 91
    CLC                      ; $A265: 18      
    RTS                      ; $A266: 60      
CMD_HEADER:
    JSR   $A3BF              ; $A267: 20 BF A3
    JSR   $A749              ; $A26A: 20 49 A7
    AND   #$01               ; $A26D: 29 01   
    CMP   #$01               ; $A26F: C9 01   
    BNE   $A2D4              ; $A271: D0 61   
    JSR   $927B              ; $A273: 20 7B 92
    JSR   $A7E1              ; $A276: 20 E1 A7
    BNE   $A2A0              ; $A279: D0 25   
    LDY   #$1B               ; $A27B: A0 1B   
    LDA   #$04               ; $A27D: A9 04   
    LDX   $0120              ; $A27F: AE 20 01
    BEQ   $A286              ; $A282: F0 02   
    LDA   #$06               ; $A284: A9 06   
    JSR   $A397              ; $A286: 20 97 A3
    JSR   $A778              ; $A289: 20 78 A7
    BIT   $7F                ; $A28C: 24 7F   
    BMI   $A2A0              ; $A28E: 30 10   
    LDY   #$00               ; $A290: A0 00   
    LDA   #$7B               ; $A292: A9 7B   
    JSR   $03AB              ; $A294: 20 AB 03
    CMP   #$32               ; $A297: C9 32   
    BCC   $A2A0              ; $A299: 90 05   
    LDX   #$24               ; $A29B: A2 24   
    JMP   $4D3C              ; $A29D: 4C 3C 4D (BASIC_ERROR_ENTRY)
    RTS                      ; $A2A0: 60      
CMD_SCRATCH:
    JSR   $A3BF              ; $A2A1: 20 BF A3
    JSR   $A749              ; $A2A4: 20 49 A7
    JSR   $A7E1              ; $A2A7: 20 E1 A7
    BNE   $A2D3              ; $A2AA: D0 27   
    LDY   #$37               ; $A2AC: A0 37   
    LDA   #$04               ; $A2AE: A9 04   
    JSR   $A397              ; $A2B0: 20 97 A3
    JSR   $A778              ; $A2B3: 20 78 A7
    BIT   $7F                ; $A2B6: 24 7F   
    BMI   $A2D3              ; $A2B8: 30 19   
    LDA   #$0D               ; $A2BA: A9 0D   
    JSR   $9269              ; $A2BC: 20 69 92
    LDY   #$00               ; $A2BF: A0 00   
    LDA   #$7B               ; $A2C1: A9 7B   
    JSR   $03AB              ; $A2C3: 20 AB 03
    BEQ   $A2CE              ; $A2C6: F0 06   
    JSR   $9269              ; $A2C8: 20 69 92
    INY                      ; $A2CB: C8      
    BNE   $A2C1              ; $A2CC: D0 F3   
    LDA   #$0D               ; $A2CE: A9 0D   
    JSR   $90DF              ; $A2D0: 20 DF 90
    RTS                      ; $A2D3: 60      
    JMP   $796C              ; $A2D4: 4C 6C 79 (CMD_FE_BEGIN)
CMD_FE_RECORD:
    LDA   #$23               ; $A2D7: A9 23   
    JSR   $795E              ; $A2D9: 20 5E 79
    JSR   $87F4              ; $A2DC: 20 F4 87
    CPX   #$00               ; $A2DF: E0 00   
    BEQ   $A31A              ; $A2E1: F0 37   
    STX   $011B              ; $A2E3: 8E 1B 01
    JSR   $880F              ; $A2E6: 20 0F 88
    LDX   #$01               ; $A2E9: A2 01   
    JSR   $9E1E              ; $A2EB: 20 1E 9E
    CPX   #$00               ; $A2EE: E0 00   
    BEQ   $A31A              ; $A2F0: F0 28   
    CPX   #$FF               ; $A2F2: E0 FF   
    BEQ   $A31A              ; $A2F4: F0 24   
    STX   $011E              ; $A2F6: 8E 1E 01
    LDA   $011B              ; $A2F9: AD 1B 01
    JSR   $A845              ; $A2FC: 20 45 A8
    JSR   $FF59              ; $A2FF: 20 59 FF (J_LKUPLA)
    BCS   $A31D              ; $A302: B0 19   
    STY   $11ED              ; $A304: 8C ED 11
    STX   $011C              ; $A307: 8E 1C 01
    LDA   #$00               ; $A30A: A9 00   
    STA   $011B              ; $A30C: 8D 1B 01
    LDA   #$6F               ; $A30F: A9 6F   
    STA   $011D              ; $A311: 8D 1D 01
    LDY   #$3B               ; $A314: A0 3B   
    LDA   #$04               ; $A316: A9 04   
    BNE   $A397              ; $A318: D0 7D   
    JMP   $7D28              ; $A31A: 4C 28 7D
    LDX   #$04               ; $A31D: A2 04   
    JMP   $4D3C              ; $A31F: 4C 3C 4D (BASIC_ERROR_ENTRY)
CMD_FE_DCLEAR:
    JSR   $A3BF              ; $A322: 20 BF A3
    LDY   #$FF               ; $A325: A0 FF   
    LDA   #$02               ; $A327: A9 02   
    JSR   $A397              ; $A329: 20 97 A3
    JMP   $A183              ; $A32C: 4C 83 A1
CMD_COLLECT:
    JSR   $A3BF              ; $A32F: 20 BF A3
    JSR   $A75B              ; $A332: 20 5B A7
    JSR   $927B              ; $A335: 20 7B 92
    LDY   #$21               ; $A338: A0 21   
    LDX   #$01               ; $A33A: A2 01   
    LDA   $80                ; $A33C: A5 80   
    AND   #$10               ; $A33E: 29 10   
    BEQ   $A343              ; $A340: F0 01   
    INX                      ; $A342: E8      
    TXA                      ; $A343: 8A      
    BNE   $A397              ; $A344: D0 51   
CMD_COPY:
    JSR   $A3BF              ; $A346: 20 BF A3
    AND   #$30               ; $A349: 29 30   
    CMP   #$30               ; $A34B: C9 30   
    BNE   $A355              ; $A34D: D0 06   
    LDA   $80                ; $A34F: A5 80   
    AND   #$C7               ; $A351: 29 C7   
    BEQ   $A35C              ; $A353: F0 07   
    LDA   $80                ; $A355: A5 80   
    JSR   $A760              ; $A357: 20 60 A7
    LDA   $80                ; $A35A: A5 80   
    LDY   #$27               ; $A35C: A0 27   
    LDA   #$08               ; $A35E: A9 08   
    BNE   $A397              ; $A360: D0 35   
CMD_FE_CONCAT:
    JSR   $A3BF              ; $A362: 20 BF A3
    JSR   $A760              ; $A365: 20 60 A7
    LDY   #$0D               ; $A368: A0 0D   
    LDA   #$0C               ; $A36A: A9 0C   
    BNE   $A397              ; $A36C: D0 29   
CMD_RENAME:
    LDA   #$E4               ; $A36E: A9 E4   
    JSR   $A3C1              ; $A370: 20 C1 A3
    JSR   $A766              ; $A373: 20 66 A7
    LDY   #$2F               ; $A376: A0 2F   
    LDA   #$08               ; $A378: A9 08   
    BNE   $A397              ; $A37A: D0 1B   
CMD_BACKUP:
    LDA   #$C7               ; $A37C: A9 C7   
    JSR   $A3C1              ; $A37E: 20 C1 A3
    AND   #$30               ; $A381: 29 30   
    CMP   #$30               ; $A383: C9 30   
    BEQ   $A38A              ; $A385: F0 03   
    JMP   $796C              ; $A387: 4C 6C 79 (CMD_FE_BEGIN)
    JSR   $A7E1              ; $A38A: 20 E1 A7
    BEQ   $A390              ; $A38D: F0 01   
    RTS                      ; $A38F: 60      
    JSR   $A183              ; $A390: 20 83 A1
    LDY   #$23               ; $A393: A0 23   
    LDA   #$04               ; $A395: A9 04   
    JSR   $A667              ; $A397: 20 67 A6
    JSR   $926F              ; $A39A: 20 6F 92
    LDA   #$00               ; $A39D: A9 00   
    TAX                      ; $A39F: AA      
    JSR   $9287              ; $A3A0: 20 87 92
    SEC                      ; $A3A3: 38      
    JSR   $90D8              ; $A3A4: 20 D8 90
    PHP                      ; $A3A7: 08      
    PHA                      ; $A3A8: 48      
    LDA   $011B              ; $A3A9: AD 1B 01
    SEC                      ; $A3AC: 38      
    JSR   $9275              ; $A3AD: 20 75 92
    PLA                      ; $A3B0: 68      
    PLP                      ; $A3B1: 28      
    BCS   $A3B5              ; $A3B2: B0 01   
    RTS                      ; $A3B4: 60      
    JMP   $90D0              ; $A3B5: 4C D0 90
; --- [DATA] DOS Command Parameter Mask Table ($A3B8-$A3BE) ---
    .BYTE $FF, $FF, $FF, $FF, $00, $08, $6F      ; $A3B8 [IDENTIFIED_DATA] |......o|
    LDA   #$00               ; $A3BF: A9 00   
    LDX   #$FF               ; $A3C1: A2 FF   
    PHA                      ; $A3C3: 48      
    TXA                      ; $A3C4: 8A      
    PHA                      ; $A3C5: 48      
    LDA   #$00               ; $A3C6: A9 00   
    STA   $80                ; $A3C8: 85 80   
    STA   $81                ; $A3CA: 85 81   
    LDX   #$22               ; $A3CC: A2 22   
    STA   $0100,X            ; $A3CE: 9D 00 01
    DEX                      ; $A3D1: CA      
    BNE   $A3CE              ; $A3D2: D0 FA   
    LDX   #$06               ; $A3D4: A2 06   
    LDA   $A3B8,X            ; $A3D6: BD B8 A3
    STA   $0117,X            ; $A3D9: 9D 17 01
    DEX                      ; $A3DC: CA      
    BPL   $A3D6              ; $A3DD: 10 F7   
    LDX   $03D5              ; $A3DF: AE D5 03
    STX   $011F              ; $A3E2: 8E 1F 01
    JSR   $0386              ; $A3E5: 20 86 03
    BNE   $A3F8              ; $A3E8: D0 0E   
    PLA                      ; $A3EA: 68      
    AND   $81                ; $A3EB: 25 81   
    BNE   $A45A              ; $A3ED: D0 6B   
    PLA                      ; $A3EF: 68      
    JSR   $A61D              ; $A3F0: 20 1D A6
    LDA   $80                ; $A3F3: A5 80   
    LDX   $81                ; $A3F5: A6 81   
    RTS                      ; $A3F7: 60      
    CMP   #$23               ; $A3F8: C9 23   
    BEQ   $A447              ; $A3FA: F0 4B   
    CMP   #$57               ; $A3FC: C9 57   
    BEQ   $A45D              ; $A3FE: F0 5D   
    CMP   #$4C               ; $A400: C9 4C   
    BEQ   $A45D              ; $A402: F0 59   
    CMP   #$52               ; $A404: C9 52   
    BEQ   $A431              ; $A406: F0 29   
    CMP   #$44               ; $A408: C9 44   
    BEQ   $A47F              ; $A40A: F0 73   
    CMP   #$91               ; $A40C: C9 91   
    BEQ   $A437              ; $A40E: F0 27   
    CMP   #$42               ; $A410: C9 42   
    BEQ   $A442              ; $A412: F0 2E   
    CMP   #$55               ; $A414: C9 55   
    BEQ   $A43D              ; $A416: F0 25   
    CMP   #$50               ; $A418: C9 50   
    BNE   $A41F              ; $A41A: D0 03   
    JMP   $A4B4              ; $A41C: 4C B4 A4
    CMP   #$49               ; $A41F: C9 49   
    BEQ   $A498              ; $A421: F0 75   
    CMP   #$22               ; $A423: C9 22   
    BEQ   $A42E              ; $A425: F0 07   
    CMP   #$28               ; $A427: C9 28   
    BEQ   $A42E              ; $A429: F0 03   
    JMP   $796C              ; $A42B: 4C 6C 79 (CMD_FE_BEGIN)
    JMP   $A4DC              ; $A42E: 4C DC A4
    JSR   $0380              ; $A431: 20 80 03
    JMP   $A4FB              ; $A434: 4C FB A4
    JSR   $A582              ; $A437: 20 82 A5
    JMP   $A4F7              ; $A43A: 4C F7 A4
    JSR   $A58D              ; $A43D: 20 8D A5
    BNE   $A43A              ; $A440: D0 F8   
    JSR   $A59E              ; $A442: 20 9E A5
    BEQ   $A43A              ; $A445: F0 F3   
    LDA   #$04               ; $A447: A9 04   
    JSR   $A61D              ; $A449: 20 1D A6
    JSR   $A5F2              ; $A44C: 20 F2 A5
    CPX   #$00               ; $A44F: E0 00   
    BEQ   $A495              ; $A451: F0 42   
    STX   $011B              ; $A453: 8E 1B 01
    LDA   #$04               ; $A456: A9 04   
    BNE   $A43A              ; $A458: D0 E0   
    JMP   $796C              ; $A45A: 4C 6C 79 (CMD_FE_BEGIN)
    TAX                      ; $A45D: AA      
    LDA   #$40               ; $A45E: A9 40   
    JSR   $A61D              ; $A460: 20 1D A6
    CPX   #$57               ; $A463: E0 57   
    BNE   $A46D              ; $A465: D0 06   
    JSR   $0380              ; $A467: 20 80 03
    JMP   $A47B              ; $A46A: 4C 7B A4
    JSR   $A5F2              ; $A46D: 20 F2 A5
    CPX   #$00               ; $A470: E0 00   
    BEQ   $A495              ; $A472: F0 21   
    CPX   #$FF               ; $A474: E0 FF   
    BEQ   $A495              ; $A476: F0 1D   
    STX   $011E              ; $A478: 8E 1E 01
    LDA   #$40               ; $A47B: A9 40   
    BNE   $A493              ; $A47D: D0 14   
    LDA   #$10               ; $A47F: A9 10   
    JSR   $A61D              ; $A481: 20 1D A6
    JSR   $A5F2              ; $A484: 20 F2 A5
    CPX   #$02               ; $A487: E0 02   
    BCS   $A495              ; $A489: B0 0A   
    STX   $0112              ; $A48B: 8E 12 01
    STX   $0114              ; $A48E: 8E 14 01
    LDA   #$10               ; $A491: A9 10   
    BNE   $A4F7              ; $A493: D0 62   
    JMP   $7D28              ; $A495: 4C 28 7D
    LDA   $0122              ; $A498: AD 22 01
    BNE   $A45A              ; $A49B: D0 BD   
    JSR   $0380              ; $A49D: 20 80 03
    STA   $0120              ; $A4A0: 8D 20 01
    JSR   $0380              ; $A4A3: 20 80 03
    STA   $0121              ; $A4A6: 8D 21 01
    LDA   #$FF               ; $A4A9: A9 FF   
    STA   $0122              ; $A4AB: 8D 22 01
    JSR   $0380              ; $A4AE: 20 80 03
    JMP   $A4FB              ; $A4B1: 4C FB A4
    LDA   #$02               ; $A4B4: A9 02   
    JSR   $A622              ; $A4B6: 20 22 A6
    JSR   $A605              ; $A4B9: 20 05 A6
    STY   $0117              ; $A4BC: 8C 17 01
    STA   $0118              ; $A4BF: 8D 18 01
    LDA   #$02               ; $A4C2: A9 02   
    ORA   $81                ; $A4C4: 05 81   
    STA   $81                ; $A4C6: 85 81   
    BNE   $A4FB              ; $A4C8: D0 31   
    LDA   #$04               ; $A4CA: A9 04   
    JSR   $A622              ; $A4CC: 20 22 A6
    JSR   $A605              ; $A4CF: 20 05 A6
    STY   $0119              ; $A4D2: 8C 19 01
    STA   $011A              ; $A4D5: 8D 1A 01
    LDA   #$04               ; $A4D8: A9 04   
    BNE   $A4C4              ; $A4DA: D0 E8   
    LDA   #$01               ; $A4DC: A9 01   
    JSR   $A5B9              ; $A4DE: 20 B9 A5
    STA   $0111              ; $A4E1: 8D 11 01
    LDY   #$00               ; $A4E4: A0 00   
    JSR   $03B7              ; $A4E6: 20 B7 03
    STA   $FF03              ; $A4E9: 8D 03 FF (MMU_LCRC_TOP)
    STA   $12B7,Y            ; $A4EC: 99 B7 12
    INY                      ; $A4EF: C8      
    CPY   $0111              ; $A4F0: CC 11 01
    BCC   $A4E6              ; $A4F3: 90 F1   
    LDA   #$01               ; $A4F5: A9 01   
    ORA   $80                ; $A4F7: 05 80   
    STA   $80                ; $A4F9: 85 80   
    JSR   $0386              ; $A4FB: 20 86 03
    BNE   $A519              ; $A4FE: D0 19   
    JMP   $A3EA              ; $A500: 4C EA A3
    CMP   #$91               ; $A503: C9 91   
    BNE   $A50A              ; $A505: D0 03   
    JMP   $A437              ; $A507: 4C 37 A4
    CMP   #$A4               ; $A50A: C9 A4   
    BEQ   $A510              ; $A50C: F0 02   
    BNE   $A57D              ; $A50E: D0 6D   
    JSR   $0380              ; $A510: 20 80 03
    CMP   #$50               ; $A513: C9 50   
    BNE   $A526              ; $A515: D0 0F   
    BEQ   $A4CA              ; $A517: F0 B1   
    CMP   #$2C               ; $A519: C9 2C   
    BNE   $A503              ; $A51B: D0 E6   
    JSR   $0380              ; $A51D: 20 80 03
    JMP   $A3F8              ; $A520: 4C F8 A3
    JSR   $0380              ; $A523: 20 80 03
    CMP   #$44               ; $A526: C9 44   
    BEQ   $A53A              ; $A528: F0 10   
    CMP   #$91               ; $A52A: C9 91   
    BEQ   $A54D              ; $A52C: F0 1F   
    CMP   #$55               ; $A52E: C9 55   
    BEQ   $A553              ; $A530: F0 21   
    CMP   #$22               ; $A532: C9 22   
    BEQ   $A558              ; $A534: F0 22   
    CMP   #$28               ; $A536: C9 28   
    BEQ   $A558              ; $A538: F0 1E   
    LDA   #$20               ; $A53A: A9 20   
    JSR   $A61D              ; $A53C: 20 1D A6
    JSR   $A5F2              ; $A53F: 20 F2 A5
    CPX   #$02               ; $A542: E0 02   
    BCS   $A57F              ; $A544: B0 39   
    STX   $0114              ; $A546: 8E 14 01
    LDA   #$20               ; $A549: A9 20   
    BNE   $A568              ; $A54B: D0 1B   
    JSR   $A582              ; $A54D: 20 82 A5
    JMP   $A568              ; $A550: 4C 68 A5
    JSR   $A58D              ; $A553: 20 8D A5
    BNE   $A568              ; $A556: D0 10   
    LDA   #$02               ; $A558: A9 02   
    JSR   $A5B9              ; $A55A: 20 B9 A5
    STA   $0113              ; $A55D: 8D 13 01
    STX   $0115              ; $A560: 8E 15 01
    STY   $0116              ; $A563: 8C 16 01
    LDA   #$02               ; $A566: A9 02   
    ORA   $80                ; $A568: 05 80   
    STA   $80                ; $A56A: 85 80   
    JSR   $0386              ; $A56C: 20 86 03
    BEQ   $A500              ; $A56F: F0 8F   
    CMP   #$2C               ; $A571: C9 2C   
    BEQ   $A523              ; $A573: F0 AE   
    CMP   #$91               ; $A575: C9 91   
    BEQ   $A54D              ; $A577: F0 D4   
    CMP   #$55               ; $A579: C9 55   
    BEQ   $A553              ; $A57B: F0 D6   
    BNE   $A5B6              ; $A57D: D0 37   
    JMP   $7D28              ; $A57F: 4C 28 7D
    JSR   $0380              ; $A582: 20 80 03
    CMP   #$42               ; $A585: C9 42   
    BEQ   $A59E              ; $A587: F0 15   
    CMP   #$55               ; $A589: C9 55   
    BNE   $A5B6              ; $A58B: D0 29   
    JSR   $A5F2              ; $A58D: 20 F2 A5
    CPX   #$1F               ; $A590: E0 1F   
    BCS   $A5EA              ; $A592: B0 56   
    CPX   #$04               ; $A594: E0 04   
    BCC   $A5EA              ; $A596: 90 52   
    STX   $011C              ; $A598: 8E 1C 01
    LDA   #$08               ; $A59B: A9 08   
    RTS                      ; $A59D: 60      
    LDA   #$01               ; $A59E: A9 01   
    JSR   $A622              ; $A5A0: 20 22 A6
    JSR   $A5F2              ; $A5A3: 20 F2 A5
    CPX   #$10               ; $A5A6: E0 10   
    BCS   $A57F              ; $A5A8: B0 D5   
    STX   $011F              ; $A5AA: 8E 1F 01
    LDA   #$01               ; $A5AD: A9 01   
    ORA   $81                ; $A5AF: 05 81   
    STA   $81                ; $A5B1: 85 81   
    LDA   #$00               ; $A5B3: A9 00   
    RTS                      ; $A5B5: 60      
    JMP   $796C              ; $A5B6: 4C 6C 79 (CMD_FE_BEGIN)
    JSR   $A61D              ; $A5B9: 20 1D A6
    JSR   $877B              ; $A5BC: 20 7B 87
    TAX                      ; $A5BF: AA      
    BEQ   $A5E7              ; $A5C0: F0 25   
    LDY   #$00               ; $A5C2: A0 00   
    JSR   $03B7              ; $A5C4: 20 B7 03
    CMP   #$40               ; $A5C7: C9 40   
    BNE   $A5DD              ; $A5C9: D0 12   
    LDA   #$80               ; $A5CB: A9 80   
    JSR   $A61D              ; $A5CD: 20 1D A6
    LDA   $80                ; $A5D0: A5 80   
    ORA   #$80               ; $A5D2: 09 80   
    STA   $80                ; $A5D4: 85 80   
    DEX                      ; $A5D6: CA      
    INC   $24                ; $A5D7: E6 24   
    BNE   $A5DD              ; $A5D9: D0 02   
    INC   $25                ; $A5DB: E6 25   
    TXA                      ; $A5DD: 8A      
    CMP   #$11               ; $A5DE: C9 11   
    BCS   $A5ED              ; $A5E0: B0 0B   
    LDX   $24                ; $A5E2: A6 24   
    LDY   $25                ; $A5E4: A4 25   
    RTS                      ; $A5E6: 60      
    LDX   #$08               ; $A5E7: A2 08   
    BIT   $09A2              ; $A5E9: 2C A2 09
    BIT   $17A2              ; $A5EC: 2C A2 17
    JMP   $4D3C              ; $A5EF: 4C 3C 4D (BASIC_ERROR_ENTRY)
    JSR   $0380              ; $A5F2: 20 80 03
    BEQ   $A5B6              ; $A5F5: F0 BF   
    BCC   $A602              ; $A5F7: 90 09   
    JSR   $7959              ; $A5F9: 20 59 79
    JSR   $87F4              ; $A5FC: 20 F4 87
    JMP   $7956              ; $A5FF: 4C 56 79
    JMP   $87F4              ; $A602: 4C F4 87
    JSR   $0380              ; $A605: 20 80 03
    BEQ   $A5B6              ; $A608: F0 AC   
    BCC   $A61A              ; $A60A: 90 0E   
    JSR   $7959              ; $A60C: 20 59 79
    JSR   $8812              ; $A60F: 20 12 88
    JSR   $7956              ; $A612: 20 56 79
    LDY   $16                ; $A615: A4 16   
    LDA   $17                ; $A617: A5 17   
    RTS                      ; $A619: 60      
    JMP   $8812              ; $A61A: 4C 12 88
    AND   $80                ; $A61D: 25 80   
    BNE   $A5B6              ; $A61F: D0 95   
    RTS                      ; $A621: 60      
    AND   $81                ; $A622: 25 81   
    BNE   $A5B6              ; $A624: D0 90   
    RTS                      ; $A626: 60      
    EOR   #$D1               ; $A627: 49 D1   
    BIT   $D1                ; $A629: 24 D1   
    .BYTE $3A                                ; $A62B: 3A [UNRESOLVED]
    SBC   ($F0),Y            ; $A62C: F1 F0   
    CMP   ($3A),Y            ; $A62E: D1 3A   
    SBC   ($2C),Y            ; $A630: F1 2C   
    SBC   ($2C,X)            ; $A632: E1 2C   
    CPX   #$43               ; $A634: E0 43   
    .BYTE $D2                                ; $A636: D2 [UNRESOLVED]
    .BYTE $3A                                ; $A637: 3A [UNRESOLVED]
    .BYTE $F2                                ; $A638: F2 [UNRESOLVED]
    AND   $3AD2,X            ; $A639: 3D D2 3A
    .BYTE $F2                                ; $A63C: F2 [UNRESOLVED]
    BIT   $3AD1              ; $A63D: 2C D1 3A
    SBC   ($2C),Y            ; $A640: F1 2C   
    EOR   ($4E,X)            ; $A642: 41 4E   
    CMP   ($3A),Y            ; $A644: D1 3A   
    SBC   ($2C),Y            ; $A646: F1 2C   
    BNE   $A6A0              ; $A648: D0 56   
    CMP   ($44),Y            ; $A64A: D1 44   
    .BYTE $D2                                ; $A64C: D2 [UNRESOLVED]
    AND   $43D1,X            ; $A64D: 3D D1 43
    .BYTE $D2                                ; $A650: D2 [UNRESOLVED]
    .BYTE $3A                                ; $A651: 3A [UNRESOLVED]
    .BYTE $F2                                ; $A652: F2 [UNRESOLVED]
    AND   $3AD1,X            ; $A653: 3D D1 3A
    SBC   ($52),Y            ; $A656: F1 52   
    CMP   ($3A),Y            ; $A658: D1 3A   
    .BYTE $F2                                ; $A65A: F2 [UNRESOLVED]
    AND   $3AD1,X            ; $A65B: 3D D1 3A
    SBC   ($53),Y            ; $A65E: F1 53   
    CMP   ($3A),Y            ; $A660: D1 3A   
    SBC   ($50),Y            ; $A662: F1 50   
    .BYTE $C2                                ; $A664: C2 [UNRESOLVED]
    .BYTE $E2                                ; $A665: E2 [UNRESOLVED]
    CPX   #$8D               ; $A666: E0 8D   
    BPL   $A66B              ; $A668: 10 01   
    TYA                      ; $A66A: 98      
    PHA                      ; $A66B: 48      
    JSR   $A80D              ; $A66C: 20 0D A8
    LDX   #$00               ; $A66F: A2 00   
    PLA                      ; $A671: 68      
    DEC   $0110              ; $A672: CE 10 01
    BMI   $A6BF              ; $A675: 30 48   
    TAY                      ; $A677: A8      
    INY                      ; $A678: C8      
    TYA                      ; $A679: 98      
    PHA                      ; $A67A: 48      
    LDA   $A627,Y            ; $A67B: B9 27 A6
    BPL   $A6B7              ; $A67E: 10 37   
    CMP   #$C2               ; $A680: C9 C2   
    BEQ   $A6D6              ; $A682: F0 52   
    CMP   #$D0               ; $A684: C9 D0   
    BEQ   $A6E5              ; $A686: F0 5D   
    CMP   #$E2               ; $A688: C9 E2   
    BEQ   $A703              ; $A68A: F0 77   
    CMP   #$E1               ; $A68C: C9 E1   
    BEQ   $A6F1              ; $A68E: F0 61   
    CMP   #$F0               ; $A690: C9 F0   
    BEQ   $A6DB              ; $A692: F0 47   
    CMP   #$F1               ; $A694: C9 F1   
    BEQ   $A70D              ; $A696: F0 75   
    CMP   #$F2               ; $A698: C9 F2   
    BEQ   $A6BD              ; $A69A: F0 21   
    CMP   #$E0               ; $A69C: C9 E0   
    BNE   $A6A5              ; $A69E: D0 05   
    LDA   $011E              ; $A6A0: AD 1E 01
    BNE   $A6B7              ; $A6A3: D0 12   
    CMP   #$D1               ; $A6A5: C9 D1   
    BNE   $A6AE              ; $A6A7: D0 05   
    LDA   $0112              ; $A6A9: AD 12 01
    BPL   $A6B5              ; $A6AC: 10 07   
    CMP   #$D2               ; $A6AE: C9 D2   
    BNE   $A671              ; $A6B0: D0 BF   
    LDA   $0114              ; $A6B2: AD 14 01
    ORA   #$30               ; $A6B5: 09 30   
    STA   $1100,X            ; $A6B7: 9D 00 11
    INX                      ; $A6BA: E8      
    BNE   $A671              ; $A6BB: D0 B4   
    BEQ   $A723              ; $A6BD: F0 64   
    TXA                      ; $A6BF: 8A      
    PHA                      ; $A6C0: 48      
    LDX   #$00               ; $A6C1: A2 00   
    LDY   #$11               ; $A6C3: A0 11   
    JSR   $925D              ; $A6C5: 20 5D 92
    LDA   $011B              ; $A6C8: AD 1B 01
    LDX   $011C              ; $A6CB: AE 1C 01
    LDY   $011D              ; $A6CE: AC 1D 01
    JSR   $9257              ; $A6D1: 20 57 92
    PLA                      ; $A6D4: 68      
    RTS                      ; $A6D5: 60      
    LDA   $11ED              ; $A6D6: AD ED 11
    BNE   $A6B7              ; $A6D9: D0 DC   
    BIT   $80                ; $A6DB: 24 80   
    BMI   $A6E1              ; $A6DD: 30 02   
    BPL   $A671              ; $A6DF: 10 90   
    LDA   #$40               ; $A6E1: A9 40   
    BNE   $A6B7              ; $A6E3: D0 D2   
    LDA   $0120              ; $A6E5: AD 20 01
    STA   $1100,X            ; $A6E8: 9D 00 11
    INX                      ; $A6EB: E8      
    LDA   $0121              ; $A6EC: AD 21 01
    BNE   $A6B7              ; $A6EF: D0 C6   
    LDA   $011E              ; $A6F1: AD 1E 01
    BEQ   $A6FA              ; $A6F4: F0 04   
    LDA   #$4C               ; $A6F6: A9 4C   
    BNE   $A6B7              ; $A6F8: D0 BD   
    LDA   #$53               ; $A6FA: A9 53   
    STA   $011E              ; $A6FC: 8D 1E 01
    LDA   #$57               ; $A6FF: A9 57   
    BNE   $A6B7              ; $A701: D0 B4   
    LDA   $16                ; $A703: A5 16   
    STA   $1100,X            ; $A705: 9D 00 11
    LDA   $17                ; $A708: A5 17   
    INX                      ; $A70A: E8      
    BNE   $A6B7              ; $A70B: D0 AA   
    LDY   $0111              ; $A70D: AC 11 01
    BEQ   $A745              ; $A710: F0 33   
    LDY   #$00               ; $A712: A0 00   
    LDA   $12B7,Y            ; $A714: B9 B7 12
    STA   $1100,X            ; $A717: 9D 00 11
    INX                      ; $A71A: E8      
    INY                      ; $A71B: C8      
    CPY   $0111              ; $A71C: CC 11 01
    BNE   $A714              ; $A71F: D0 F3   
    BEQ   $A746              ; $A721: F0 23   
    LDA   $0115              ; $A723: AD 15 01
    STA   $24                ; $A726: 85 24   
    LDA   $0116              ; $A728: AD 16 01
    STA   $25                ; $A72B: 85 25   
    LDY   $0113              ; $A72D: AC 13 01
    BEQ   $A745              ; $A730: F0 13   
    LDY   #$00               ; $A732: A0 00   
    JSR   $03B7              ; $A734: 20 B7 03
    STA   $FF03              ; $A737: 8D 03 FF (MMU_LCRC_TOP)
    STA   $1100,X            ; $A73A: 9D 00 11
    INX                      ; $A73D: E8      
    INY                      ; $A73E: C8      
    CPY   $0113              ; $A73F: CC 13 01
    BNE   $A734              ; $A742: D0 F0   
    BIT   $CA                ; $A744: 24 CA   
    JMP   $A671              ; $A746: 4C 71 A6
    AND   #$E6               ; $A749: 29 E6   
    BEQ   $A750              ; $A74B: F0 03   
    JMP   $796C              ; $A74D: 4C 6C 79 (CMD_FE_BEGIN)
    LDA   $80                ; $A750: A5 80   
    AND   #$01               ; $A752: 29 01   
    CMP   #$01               ; $A754: C9 01   
    BNE   $A74D              ; $A756: D0 F5   
    LDA   $80                ; $A758: A5 80   
    RTS                      ; $A75A: 60      
    AND   #$E7               ; $A75B: 29 E7   
    BNE   $A74D              ; $A75D: D0 EE   
    RTS                      ; $A75F: 60      
    AND   #$C4               ; $A760: 29 C4   
    BNE   $A74D              ; $A762: D0 E9   
    LDA   $80                ; $A764: A5 80   
    AND   #$03               ; $A766: 29 03   
    CMP   #$03               ; $A768: C9 03   
    BNE   $A74D              ; $A76A: D0 E1   
    LDA   $80                ; $A76C: A5 80   
    RTS                      ; $A76E: 60      
    AND   #$05               ; $A76F: 29 05   
    CMP   #$05               ; $A771: C9 05   
    BNE   $A74D              ; $A773: D0 D8   
    LDA   $80                ; $A775: A5 80   
    RTS                      ; $A777: 60      
    LDA   $7A                ; $A778: A5 7A   
    BNE   $A795              ; $A77A: D0 19   
    LDA   #$28               ; $A77C: A9 28   
    STA   $7A                ; $A77E: 85 7A   
    JSR   $9299              ; $A780: 20 99 92
    STX   $7B                ; $A783: 86 7B   
    STY   $7C                ; $A785: 84 7C   
    LDY   #$28               ; $A787: A0 28   
    STA   $FF04              ; $A789: 8D 04 FF (MMU_LCRD_TOP)
    LDA   #$7A               ; $A78C: A9 7A   
    STA   ($7B),Y            ; $A78E: 91 7B   
    INY                      ; $A790: C8      
    LDA   #$00               ; $A791: A9 00   
    STA   ($7B),Y            ; $A793: 91 7B   
    LDX   $011C              ; $A795: AE 1C 01
    BNE   $A79F              ; $A798: D0 05   
    LDX   #$08               ; $A79A: A2 08   
    STX   $011C              ; $A79C: 8E 1C 01
    LDA   #$00               ; $A79F: A9 00   
    LDY   #$6F               ; $A7A1: A0 6F   
    JSR   $9257              ; $A7A3: 20 57 92
    LDA   #$00               ; $A7A6: A9 00   
    JSR   $925D              ; $A7A8: 20 5D 92
    JSR   $90D8              ; $A7AB: 20 D8 90
    LDX   #$00               ; $A7AE: A2 00   
    JSR   $FFC6              ; $A7B0: 20 C6 FF (J_CHKIN)
    BCS   $A7D5              ; $A7B3: B0 20   
    LDY   #$FF               ; $A7B5: A0 FF   
    INY                      ; $A7B7: C8      
    JSR   $9263              ; $A7B8: 20 63 92
    STA   $FF04              ; $A7BB: 8D 04 FF (MMU_LCRD_TOP)
    CMP   #$0D               ; $A7BE: C9 0D   
    BEQ   $A7C8              ; $A7C0: F0 06   
    STA   ($7B),Y            ; $A7C2: 91 7B   
    CPY   #$28               ; $A7C4: C0 28   
    BCC   $A7B7              ; $A7C6: 90 EF   
    LDA   #$00               ; $A7C8: A9 00   
    STA   ($7B),Y            ; $A7CA: 91 7B   
    JSR   $926F              ; $A7CC: 20 6F 92
    LDA   #$00               ; $A7CF: A9 00   
    SEC                      ; $A7D1: 38      
    JMP   $9275              ; $A7D2: 4C 75 92
    PHA                      ; $A7D5: 48      
    JSR   $A7C8              ; $A7D6: 20 C8 A7
    JSR   $A80D              ; $A7D9: 20 0D A8
    PLA                      ; $A7DC: 68      
    TAX                      ; $A7DD: AA      
    JMP   $4D3C              ; $A7DE: 4C 3C 4D (BASIC_ERROR_ENTRY)
    BIT   $7F                ; $A7E1: 24 7F   
    BMI   $A80A              ; $A7E3: 30 25   
    JSR   $9281              ; $A7E5: 20 81 92
    EOR   ($52,X)            ; $A7E8: 41 52   
    EOR   $20                ; $A7EA: 45 20   
    EOR   $554F,Y            ; $A7EC: 59 4F 55
    JSR   $5553              ; $A7EF: 20 53 55
    .BYTE $52                                ; $A7F2: 52 [UNRESOLVED]
    EOR   $3F                ; $A7F3: 45 3F   
    BRK                      ; $A7F5: 00      
    JSR   $926F              ; $A7F6: 20 6F 92
    JSR   $9263              ; $A7F9: 20 63 92
    PHA                      ; $A7FC: 48      
    CMP   #$0D               ; $A7FD: C9 0D   
    BEQ   $A806              ; $A7FF: F0 05   
    JSR   $9263              ; $A801: 20 63 92
    BNE   $A7FD              ; $A804: D0 F7   
    PLA                      ; $A806: 68      
    CMP   #$59               ; $A807: C9 59   
    RTS                      ; $A809: 60      
    LDA   #$00               ; $A80A: A9 00   
    RTS                      ; $A80C: 60      
    TYA                      ; $A80D: 98      
    PHA                      ; $A80E: 48      
    LDA   $7A                ; $A80F: A5 7A   
    BEQ   $A820              ; $A811: F0 0D   
    LDY   #$28               ; $A813: A0 28   
    TYA                      ; $A815: 98      
    STA   $FF04              ; $A816: 8D 04 FF (MMU_LCRD_TOP)
    STA   ($7B),Y            ; $A819: 91 7B   
    INY                      ; $A81B: C8      
    LDA   #$FF               ; $A81C: A9 FF   
    STA   ($7B),Y            ; $A81E: 91 7B   
    LDA   #$00               ; $A820: A9 00   
    STA   $FF03              ; $A822: 8D 03 FF (MMU_LCRC_TOP)
    STA   $7A                ; $A825: 85 7A   
    PLA                      ; $A827: 68      
    TAY                      ; $A828: A8      
    RTS                      ; $A829: 60      
    BIT   $2030              ; $A82A: 2C 30 20
    EOR   $4B45,Y            ; $A82D: 59 45 4B
    TAX                      ; $A830: AA      
    TYA                      ; $A831: 98      
    PHA                      ; $A832: 48      
    LDA   #$00               ; $A833: A9 00   
    JSR   $8E32              ; $A835: 20 32 8E
    PLA                      ; $A838: 68      
    TAY                      ; $A839: A8      
    RTS                      ; $A83A: 60      
    STA   $3C                ; $A83B: 85 3C   
    DEY                      ; $A83D: 88      
    TAX                      ; $A83E: AA      
    INX                      ; $A83F: E8      
    BNE   $A844              ; $A840: D0 02   
    STX   $7F                ; $A842: 86 7F   
    RTS                      ; $A844: 60      
    PHA                      ; $A845: 48      
    LDA   #$00               ; $A846: A9 00   
    STA   $FF00              ; $A848: 8D 00 FF (MMU_CR_TOP)
    PLA                      ; $A84B: 68      
    RTS                      ; $A84C: 60      
BASIC_INIT_UPPER:
    LDA   $12FD              ; $A84D: AD FD 12
    BEQ   $A853              ; $A850: F0 01   
    RTS                      ; $A852: 60      
    INC   $12FD              ; $A853: EE FD 12
    LDX   #$10               ; $A856: A2 10   
    LDA   $11D6,X            ; $A858: BD D6 11
    STA   $D000,X            ; $A85B: 9D 00 D0 (VIC_SP0X)
    DEX                      ; $A85E: CA      
    BPL   $A858              ; $A85F: 10 F7   
    LDY   #$07               ; $A861: A0 07   
    LDA   $D015              ; $A863: AD 15 D0 (VIC_SPENA)
    AND   $6CB3,Y            ; $A866: 39 B3 6C
    BEQ   $A8A3              ; $A869: F0 38   
    LDX   $6DD9,Y            ; $A86B: BE D9 6D
    LDA   $117E,X            ; $A86E: BD 7E 11
    BEQ   $A8A3              ; $A871: F0 30   
    STA   $117F,X            ; $A873: 9D 7F 11
    TYA                      ; $A876: 98      
    ASL   A                  ; $A877: 0A      
    TAY                      ; $A878: A8      
    LDA   $1180,X            ; $A879: BD 80 11
    SEC                      ; $A87C: 38      
    SBC   #$01               ; $A87D: E9 01   
    INX                      ; $A87F: E8      
    INX                      ; $A880: E8      
    INY                      ; $A881: C8      
    JSR   $A9F4              ; $A882: 20 F4 A9
    DEX                      ; $A885: CA      
    DEX                      ; $A886: CA      
    DEY                      ; $A887: 88      
    LDA   $1180,X            ; $A888: BD 80 11
    JSR   $A9F4              ; $A88B: 20 F4 A9
    PHP                      ; $A88E: 08      
    TYA                      ; $A88F: 98      
    LSR   A                  ; $A890: 4A      
    TAY                      ; $A891: A8      
    PLP                      ; $A892: 28      
    BCC   $A89E              ; $A893: 90 09   
    LDA   $11E6              ; $A895: AD E6 11
    EOR   $6CB3,Y            ; $A898: 59 B3 6C
    STA   $11E6              ; $A89B: 8D E6 11
    DEC   $117F,X            ; $A89E: DE 7F 11
    BNE   $A876              ; $A8A1: D0 D3   
    DEY                      ; $A8A3: 88      
    BPL   $A863              ; $A8A4: 10 BD   
    LDA   $D019              ; $A8A6: AD 19 D0 (VIC_VICIRQ)
    STA   $D019              ; $A8A9: 8D 19 D0 (VIC_VICIRQ)
    AND   #$0E               ; $A8AC: 29 0E   
    BEQ   $A8F4              ; $A8AE: F0 44   
    LSR   A                  ; $A8B0: 4A      
    LDY   #$01               ; $A8B1: A0 01   
    LSR   A                  ; $A8B3: 4A      
    BCC   $A8D6              ; $A8B4: 90 20   
    PHA                      ; $A8B6: 48      
    LDA   $D01E,Y            ; $A8B7: B9 1E D0
    ORA   $11E7,Y            ; $A8BA: 19 E7 11
    STA   $11E7,Y            ; $A8BD: 99 E7 11
    LDA   #$00               ; $A8C0: A9 00   
    STA   $D01E,Y            ; $A8C2: 99 1E D0
    LDA   $127F              ; $A8C5: AD 7F 12
    CPY   #$00               ; $A8C8: C0 00   
    BEQ   $A8CD              ; $A8CA: F0 01   
    LSR   A                  ; $A8CC: 4A      
    LSR   A                  ; $A8CD: 4A      
    BCC   $A8D5              ; $A8CE: 90 05   
    LDA   #$FF               ; $A8D0: A9 FF   
    STA   $1276,Y            ; $A8D2: 99 76 12
    PLA                      ; $A8D5: 68      
    DEY                      ; $A8D6: 88      
    BPL   $A8B3              ; $A8D7: 10 DA   
    LSR   A                  ; $A8D9: 4A      
    BCC   $A8F4              ; $A8DA: 90 18   
    LDA   $D013              ; $A8DC: AD 13 D0
    STA   $11E9              ; $A8DF: 8D E9 11
    LDA   $D014              ; $A8E2: AD 14 D0
    STA   $11EA              ; $A8E5: 8D EA 11
    LDA   $127F              ; $A8E8: AD 7F 12
    AND   #$04               ; $A8EB: 29 04   
    BEQ   $A8F4              ; $A8ED: F0 05   
    LDA   #$FF               ; $A8EF: A9 FF   
    STA   $1278              ; $A8F1: 8D 78 12
    LDX   #$00               ; $A8F4: A2 00   
    LDA   $1224,X            ; $A8F6: BD 24 12
    BMI   $A922              ; $A8F9: 30 27   
    LDA   $1223,X            ; $A8FB: BD 23 12
    SEC                      ; $A8FE: 38      
    SBC   $1222              ; $A8FF: ED 22 12
    STA   $1223,X            ; $A902: 9D 23 12
    BCS   $A922              ; $A905: B0 1B   
    LDA   $1224,X            ; $A907: BD 24 12
    SBC   #$00               ; $A90A: E9 00   
    STA   $1224,X            ; $A90C: 9D 24 12
    BCS   $A922              ; $A90F: B0 11   
    TXA                      ; $A911: 8A      
    LSR   A                  ; $A912: 4A      
    TAY                      ; $A913: A8      
    LDA   $1230,Y            ; $A914: B9 30 12
    AND   #$FE               ; $A917: 29 FE   
    PHA                      ; $A919: 48      
    LDA   $7039,Y            ; $A91A: B9 39 70
    TAY                      ; $A91D: A8      
    PLA                      ; $A91E: 68      
    STA   $D404,Y            ; $A91F: 99 04 D4
    INX                      ; $A922: E8      
    INX                      ; $A923: E8      
    CPX   #$06               ; $A924: E0 06   
    BNE   $A8F6              ; $A926: D0 CE   
    LDY   #$02               ; $A928: A0 02   
    LDA   $1285,Y            ; $A92A: B9 85 12
    BPL   $A935              ; $A92D: 10 06   
    DEY                      ; $A92F: 88      
    BPL   $A92A              ; $A930: 10 F8   
    JMP   $A9F0              ; $A932: 4C F0 A9
    CLC                      ; $A935: 18      
    LDA   $129D,Y            ; $A936: B9 9D 12
    ADC   $1297,Y            ; $A939: 79 97 12
    STA   $129D,Y            ; $A93C: 99 9D 12
    LDA   $12A0,Y            ; $A93F: B9 A0 12
    ADC   $129A,Y            ; $A942: 79 9A 12
    STA   $12A0,Y            ; $A945: 99 A0 12
    LDA   $1294,Y            ; $A948: B9 94 12
    TAX                      ; $A94B: AA      
    AND   #$01               ; $A94C: 29 01   
    BEQ   $A97E              ; $A94E: F0 2E   
    BCC   $A961              ; $A950: 90 0F   
    SEC                      ; $A952: 38      
    LDA   $129D,Y            ; $A953: B9 9D 12
    SBC   $128E,Y            ; $A956: F9 8E 12
    LDA   $12A0,Y            ; $A959: B9 A0 12
    SBC   $1291,Y            ; $A95C: F9 91 12
    BCS   $A9AE              ; $A95F: B0 4D   
    CPX   #$02               ; $A961: E0 02   
    BCC   $A96F              ; $A963: 90 0A   
    JSR   $A9DA              ; $A965: 20 DA A9
    LDA   #$02               ; $A968: A9 02   
    STA   $1294,Y            ; $A96A: 99 94 12
    BNE   $A9A2              ; $A96D: D0 33   
    LDA   $1288,Y            ; $A96F: B9 88 12
    STA   $129D,Y            ; $A972: 99 9D 12
    LDA   $128B,Y            ; $A975: B9 8B 12
    STA   $12A0,Y            ; $A978: 99 A0 12
    JMP   $A9AE              ; $A97B: 4C AE A9
    BCS   $A994              ; $A97E: B0 14   
    LDA   $12A0,Y            ; $A980: B9 A0 12
    CMP   $128B,Y            ; $A983: D9 8B 12
    BCC   $A9AE              ; $A986: 90 26   
    BNE   $A994              ; $A988: D0 0A   
    LDA   $129D,Y            ; $A98A: B9 9D 12
    CMP   $1288,Y            ; $A98D: D9 88 12
    BCC   $A9AE              ; $A990: 90 1C   
    BEQ   $A9AE              ; $A992: F0 1A   
    CPX   #$02               ; $A994: E0 02   
    BCC   $A9A2              ; $A996: 90 0A   
    JSR   $A9DA              ; $A998: 20 DA A9
    LDA   #$03               ; $A99B: A9 03   
    STA   $1294,Y            ; $A99D: 99 94 12
    BNE   $A96F              ; $A9A0: D0 CD   
    LDA   $128E,Y            ; $A9A2: B9 8E 12
    STA   $129D,Y            ; $A9A5: 99 9D 12
    LDA   $1291,Y            ; $A9A8: B9 91 12
    STA   $12A0,Y            ; $A9AB: 99 A0 12
    LDX   $7039,Y            ; $A9AE: BE 39 70
    LDA   $129D,Y            ; $A9B1: B9 9D 12
    STA   $D400,X            ; $A9B4: 9D 00 D4 (SID_BASE)
    LDA   $12A0,Y            ; $A9B7: B9 A0 12
    STA   $D401,X            ; $A9BA: 9D 01 D4
    TYA                      ; $A9BD: 98      
    TAX                      ; $A9BE: AA      
    LDA   $1282,X            ; $A9BF: BD 82 12
    BNE   $A9C7              ; $A9C2: D0 03   
    DEC   $1285,X            ; $A9C4: DE 85 12
    DEC   $1282,X            ; $A9C7: DE 82 12
    LDA   $1285,X            ; $A9CA: BD 85 12
    BPL   $A9D7              ; $A9CD: 10 08   
    LDA   #$08               ; $A9CF: A9 08   
    LDX   $7039,Y            ; $A9D1: BE 39 70
    STA   $D404,X            ; $A9D4: 9D 04 D4
    JMP   $A92F              ; $A9D7: 4C 2F A9
    LDA   $1297,Y            ; $A9DA: B9 97 12
    EOR   #$FF               ; $A9DD: 49 FF   
    CLC                      ; $A9DF: 18      
    ADC   #$01               ; $A9E0: 69 01   
    STA   $1297,Y            ; $A9E2: 99 97 12
    LDA   $129A,Y            ; $A9E5: B9 9A 12
    EOR   #$FF               ; $A9E8: 49 FF   
    ADC   #$00               ; $A9EA: 69 00   
    STA   $129A,Y            ; $A9EC: 99 9A 12
    RTS                      ; $A9EF: 60      
    DEC   $12FD              ; $A9F0: CE FD 12
    RTS                      ; $A9F3: 60      
    PHA                      ; $A9F4: 48      
    CLC                      ; $A9F5: 18      
    LDA   $1181,X            ; $A9F6: BD 81 11
    ADC   $1185,X            ; $A9F9: 7D 85 11
    STA   $1185,X            ; $A9FC: 9D 85 11
    LDA   $1182,X            ; $A9FF: BD 82 11
    ADC   $1186,X            ; $AA02: 7D 86 11
    STA   $1186,X            ; $AA05: 9D 86 11
    PLA                      ; $AA08: 68      
    BCC   $AA1E              ; $AA09: 90 13   
    LSR   A                  ; $AA0B: 4A      
    LSR   A                  ; $AA0C: 4A      
    LDA   $11D6,Y            ; $AA0D: B9 D6 11
    BCS   $AA17              ; $AA10: B0 05   
    ADC   #$01               ; $AA12: 69 01   
    JMP   $AA1B              ; $AA14: 4C 1B AA
    SBC   #$01               ; $AA17: E9 01   
    CMP   #$FF               ; $AA19: C9 FF   
    STA   $11D6,Y            ; $AA1B: 99 D6 11
    RTS                      ; $AA1E: 60      
CMD_FE_STASH:
    LDA   #$84               ; $AA1F: A9 84   
    JMP   $AA2B              ; $AA21: 4C 2B AA
CMD_FE_FETCH:
    LDA   #$85               ; $AA24: A9 85   
    JMP   $AA2B              ; $AA26: 4C 2B AA
CMD_FE_SWAP:
    LDA   #$86               ; $AA29: A9 86   
    PHA                      ; $AA2B: 48      
    JSR   $8812              ; $AA2C: 20 12 88
    JSR   $A845              ; $AA2F: 20 45 A8
    STY   $DF07              ; $AA32: 8C 07 DF
    STA   $DF08              ; $AA35: 8D 08 DF
    JSR   $880F              ; $AA38: 20 0F 88
    JSR   $A845              ; $AA3B: 20 45 A8
    STY   $DF02              ; $AA3E: 8C 02 DF
    STA   $DF03              ; $AA41: 8D 03 DF
    JSR   $880F              ; $AA44: 20 0F 88
    JSR   $A845              ; $AA47: 20 45 A8
    STY   $DF04              ; $AA4A: 8C 04 DF
    STA   $DF05              ; $AA4D: 8D 05 DF
    JSR   $8809              ; $AA50: 20 09 88
    CPX   #$10               ; $AA53: E0 10   
    BCS   $AA65              ; $AA55: B0 0E   
    JSR   $A845              ; $AA57: 20 45 A8
    STX   $DF06              ; $AA5A: 8E 06 DF
    PLA                      ; $AA5D: 68      
    TAY                      ; $AA5E: A8      
    LDX   $03D5              ; $AA5F: AE D5 03
    JMP   $FF50              ; $AA62: 4C 50 FF (J_DMA_CALL)
    JMP   $7D28              ; $AA65: 4C 28 7D
    JSR   $8C47              ; $AA68: 20 47 8C
    JMP   $8CC7              ; $AA6B: 4C C7 8C
; --- [PADDING] Unused ROM Padding Block 1 ($FF, 1013 bytes) ($AA6E-$AE62) ---
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AA6E [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AA76 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AA7E [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AA86 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AA8E [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AA96 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AA9E [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AAA6 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AAAE [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AAB6 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AABE [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AAC6 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AACE [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AAD6 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AADE [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AAE6 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AAEE [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AAF6 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AAFE [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AB06 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AB0E [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AB16 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AB1E [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AB26 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AB2E [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AB36 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AB3E [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AB46 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AB4E [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AB56 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AB5E [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AB66 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AB6E [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AB76 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AB7E [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AB86 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AB8E [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AB96 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AB9E [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $ABA6 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $ABAE [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $ABB6 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $ABBE [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $ABC6 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $ABCE [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $ABD6 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $ABDE [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $ABE6 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $ABEE [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $ABF6 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $ABFE [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AC06 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AC0E [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AC16 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AC1E [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AC26 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AC2E [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AC36 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AC3E [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AC46 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AC4E [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AC56 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AC5E [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AC66 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AC6E [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AC76 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AC7E [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AC86 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AC8E [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AC96 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AC9E [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $ACA6 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $ACAE [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $ACB6 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $ACBE [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $ACC6 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $ACCE [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $ACD6 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $ACDE [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $ACE6 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $ACEE [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $ACF6 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $ACFE [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AD06 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AD0E [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AD16 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AD1E [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AD26 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AD2E [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AD36 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AD3E [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AD46 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AD4E [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AD56 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AD5E [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AD66 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AD6E [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AD76 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AD7E [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AD86 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AD8E [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AD96 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AD9E [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $ADA6 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $ADAE [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $ADB6 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $ADBE [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $ADC6 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $ADCE [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $ADD6 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $ADDE [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $ADE6 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $ADEE [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $ADF6 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $ADFE [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AE06 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AE0E [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AE16 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AE1E [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AE26 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AE2E [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AE36 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AE3E [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AE46 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AE4E [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AE56 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF                ; $AE5E [PADDING] |.....|
    .BYTE $7B                                ; $AE63: 7B [UNRESOLVED]
    SBC   #$77               ; $AE64: E9 77   
    ROR   A                  ; $AE66: 6A      
    .BYTE $5F                                ; $AE67: 5F [UNRESOLVED]
    LSR   $BE5D,X            ; $AE68: 5E 5D BE
    AND   ($3D,X)            ; $AE6B: 21 3D   
    BIT   $37                ; $AE6D: 24 37   
    .BYTE $3F                                ; $AE6F: 3F [UNRESOLVED]
    .BYTE $22                                ; $AE70: 22 [UNRESOLVED]
    EOR   $20,X              ; $AE71: 55 20   
    BIT   $4A                ; $AE73: 24 4A   
    BMI   $AE9E              ; $AE75: 30 27   
    .BYTE $3A                                ; $AE77: 3A [UNRESOLVED]
    LSR   $352F              ; $AE78: 4E 2F 35
    EOR   $4F4C              ; $AE7B: 4D 4C 4F
    RTI                      ; $AE7E: 40      
    .BYTE $47                                ; $AE7F: 47 [UNRESOLVED]
    LSR   $68                ; $AE80: 46 68   
    ADC   #$88               ; $AE82: 69 88   
    ORA   $1F,X              ; $AE84: 15 1F   
    .BYTE $0C                                ; $AE86: 0C [UNRESOLVED]
    PHP                      ; $AE87: 08      
    .BYTE $1F                                ; $AE88: 1F [UNRESOLVED]
    .BYTE $0F                                ; $AE89: 0F [UNRESOLVED]
    ORA   $5F69,Y            ; $AE8A: 19 69 5F
    ADC   ($96),Y            ; $AE8D: 71 96   
    ORA   $13                ; $AE8F: 05 13   
    ORA   ($74),Y            ; $AE91: 11 74   
    .BYTE $89                                ; $AE93: 89 [UNRESOLVED]
    ORA   $1E                ; $AE94: 05 1E   
    ORA   $4301              ; $AE96: 0D 01 43
    ADC   $0698              ; $AE99: 6D 98 06
    BPL   $AEB1              ; $AE9C: 10 13   
    ORA   $9467,Y            ; $AE9E: 19 67 94
    .BYTE $1C                                ; $AEA1: 1C [UNRESOLVED]
    ORA   $75                ; $AEA2: 05 75   
    .BYTE $37                                ; $AEA4: 37 [UNRESOLVED]
    ORA   $70EE,Y            ; $AEA5: 19 EE 70
    BVS   $AEC7              ; $AEA8: 70 1D   
    SBC   $6661,Y            ; $AEAA: F9 61 66
    ROR   $79                ; $AEAD: 66 79   
    ADC   $3873,Y            ; $AEAF: 79 73 38
    AND   $6FE3,Y            ; $AEB2: 39 E3 6F
    .BYTE $7B                                ; $AEB5: 7B [UNRESOLVED]
    JMP   ($6F78)            ; $AEB6: 6C 78 6F
    .BYTE $7F                                ; $AEB9: 7F [UNRESOLVED]
    ADC   #$19               ; $AEBA: 69 19   
    .BYTE $2F                                ; $AEBC: 2F [UNRESOLVED]
    ORA   ($E2,X)            ; $AEBD: 01 E2   
    ROR   $056A              ; $AEBF: 6E 6A 05
    CPX   $485E              ; $AEC2: EC 5E 48
    EOR   $3F15,X            ; $AEC5: 5D 15 3F
    .BYTE $DA                                ; $AEC8: DA [UNRESOLVED]
    .BYTE $5C                                ; $AEC9: 5C [UNRESOLVED]
    LSR   A                  ; $AECA: 4A      
    LSR   $32,X              ; $AECB: 56 32   
    CMP   $4E51,Y            ; $AECD: D9 51 4E
    CLI                      ; $AED0: 58      
    .BYTE $5C                                ; $AED1: 5C [UNRESOLVED]
    EOR   ($06),Y            ; $AED2: 51 06   
    ROL   A                  ; $AED4: 2A      
    .BYTE $CF                                ; $AED5: CF [UNRESOLVED]
    .BYTE $5A                                ; $AED6: 5A [UNRESOLVED]
    LSR   $4640              ; $AED7: 4E 40 46
    BIT   $43D3              ; $AEDA: 2C D3 43
    EOR   $4E41              ; $AEDD: 4D 41 4E
    .BYTE $47                                ; $AEE0: 47 [UNRESOLVED]
    PHP                      ; $AEE1: 08      
    ORA   #$E9               ; $AEE2: 09 E9   
    ROL   $B0,X              ; $AEE4: 36 B0   
    LDX   $B4,Y              ; $AEE6: B6 B4   
    DEC   $AEBC,X            ; $AEE8: DE BC AE
    LDX   $DDA1,Y            ; $AEEB: BE A1 DD
    LDY   $B8,X              ; $AEEE: B4 B8   
    CLV                      ; $AEF0: B8      
    .BYTE $D2                                ; $AEF1: D2 [UNRESOLVED]
    LDY   #$CB               ; $AEF2: A0 CB   
    .BYTE $A7                                ; $AEF4: A7 [UNRESOLVED]
    TAY                      ; $AEF5: A8      
    .BYTE $A3                                ; $AEF6: A3 [UNRESOLVED]
    TAX                      ; $AEF7: AA      
    DEC   $A4B9              ; $AEF8: CE B9 A4
    LDX   $AF                ; $AEFB: A6 AF   
    .BYTE $CF                                ; $AEFD: CF [UNRESOLVED]
    SBC   $4CE7              ; $AEFE: ED E7 4C
    LDY   $84,X              ; $AF01: B4 84   
    JMP   $793C              ; $AF03: 4C 3C 79
    JMP   $8E42              ; $AF06: 4C 42 8E
    JMP   $8052              ; $AF09: 4C 52 80
    JMP   $8815              ; $AF0C: 4C 15 88
    JMP   $8C75              ; $AF0F: 4C 75 8C
    JMP   $882E              ; $AF12: 4C 2E 88 (FP_MATH_LIBRARY)
    JMP   $8831              ; $AF15: 4C 31 88 (CMD__)
    JMP   $8845              ; $AF18: 4C 45 88
    JMP   $8848              ; $AF1B: 4C 48 88 (CMD__)
    JMP   $8A24              ; $AF1E: 4C 24 8A
    JMP   $8A27              ; $AF21: 4C 27 8A (CMD__)
    JMP   $8B49              ; $AF24: 4C 49 8B
    JMP   $8B4C              ; $AF27: 4C 4C 8B (CMD__)
    JMP   $89CA              ; $AF2A: 4C CA 89 (CMD_LOG)
    JMP   $8CFB              ; $AF2D: 4C FB 8C (CMD_INT)
    JMP   $8FB7              ; $AF30: 4C B7 8F (CMD_SQR)
    JMP   $8FFA              ; $AF33: 4C FA 8F
    JMP   $8FBE              ; $AF36: 4C BE 8F
    JMP   $8FC1              ; $AF39: 4C C1 8F (CMD__)
    JMP   $9033              ; $AF3C: 4C 33 90 (CMD_EXP)
    JMP   $9409              ; $AF3F: 4C 09 94 (CMD_COS)
    JMP   $9410              ; $AF42: 4C 10 94 (CMD_SIN)
    JMP   $9459              ; $AF45: 4C 59 94 (CMD_TAN)
    JMP   $94B3              ; $AF48: 4C B3 94 (CMD_ATN)
    JMP   $8C47              ; $AF4B: 4C 47 8C
    JMP   $8C84              ; $AF4E: 4C 84 8C (CMD_ABS)
    JMP   $8C57              ; $AF51: 4C 57 8C
    JMP   $8C87              ; $AF54: 4C 87 8C
    JMP   $8437              ; $AF57: 4C 37 84
    JMP   $8AB4              ; $AF5A: 4C B4 8A
    JMP   $8A89              ; $AF5D: 4C 89 8A
    JMP   $7A85              ; $AF60: 4C 85 7A
    JMP   $8BD4              ; $AF63: 4C D4 8B
    JMP   $8C00              ; $AF66: 4C 00 8C
    JMP   $8C28              ; $AF69: 4C 28 8C
    JMP   $8C38              ; $AF6C: 4C 38 8C
    JMP   $4828              ; $AF6F: 4C 28 48 (OPTAB_TABLE)
    JMP   $9B30              ; $AF72: 4C 30 9B
    JMP   $9BFB              ; $AF75: 4C FB 9B
    JMP   $6750              ; $AF78: 4C 50 67
    JMP   $5A9B              ; $AF7B: 4C 9B 5A (CMD_RUN)
    JMP   $51F3              ; $AF7E: 4C F3 51
    JMP   $51F8              ; $AF81: 4C F8 51 (CMD_CLR)
    JMP   $51D6              ; $AF84: 4C D6 51 (CMD_NEW)
    JMP   $4F4F              ; $AF87: 4C 4F 4F
    JMP   $430A              ; $AF8A: 4C 0A 43 (CRUNCH)
    JMP   $5064              ; $AF8D: 4C 64 50
    JMP   $4AF6              ; $AF90: 4C F6 4A
    JMP   $78D7              ; $AF93: 4C D7 78 (EVAL)
    JMP   $77EF              ; $AF96: 4C EF 77 (FRMEVL)
    JMP   $5AA6              ; $AF99: 4C A6 5A
    JMP   $5A81              ; $AF9C: 4C 81 5A
    JMP   $50A0              ; $AF9F: 4C A0 50
    JMP   $92EA              ; $AFA2: 4C EA 92 (GARBAG_COLLECT)
    JMP   $4DCD              ; $AFA5: 4C CD 4D
; --- [PADDING] Unused ROM Padding Block 2 ($FF, 88 bytes) ($AFA8-$AFFF) ---
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AFA8 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AFB0 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AFB8 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AFC0 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AFC8 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AFD0 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AFD8 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AFE0 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AFE8 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AFF0 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $AFF8 [PADDING] |........|
MON_CALL_ENTRY:
    JMP   $B021              ; $B000: 4C 21 B0 (MON_INIT_HANDLER)
MON_BRK_ENTRY:
    JMP   $B009              ; $B003: 4C 09 B0 (MON_BRK_HANDLER)
MON_CMD_ENTRY:
    JMP   $B0B2              ; $B006: 4C B2 B0 (MON_MAIN_LOOP)
MON_BRK_HANDLER:
    JSR   $FF7D              ; $B009: 20 7D FF (J_PRIMM)
; --- [DATA] ML Monitor Inline String: '<CR>BREAK<BEL>\0' ($B00C-$B013) ---
    .BYTE $0D, $42, $52, $45, $41, $4B, $07, $00 ; $B00C [IDENTIFIED_DATA] |.BREAK..|
    PLA                      ; $B014: 68      
    STA   $02                ; $B015: 85 02   
    LDX   #$05               ; $B017: A2 05   
    PLA                      ; $B019: 68      
    STA   $03,X              ; $B01A: 95 03   
    DEX                      ; $B01C: CA      
    BPL   $B019              ; $B01D: 10 FA   
    BMI   $B046              ; $B01F: 30 25   
MON_INIT_HANDLER:
    LDA   #$00               ; $B021: A9 00   
    STA   $FF00              ; $B023: 8D 00 FF (MMU_CR_TOP)
    STA   $06                ; $B026: 85 06   
    STA   $07                ; $B028: 85 07   
    STA   $08                ; $B02A: 85 08   
    STA   $05                ; $B02C: 85 05   
    LDA   #$00               ; $B02E: A9 00   
    LDY   #$B0               ; $B030: A0 B0   
    STA   $04                ; $B032: 85 04   
    STY   $03                ; $B034: 84 03   
    LDA   #$0F               ; $B036: A9 0F   
    STA   $02                ; $B038: 85 02   
    JSR   $FF7D              ; $B03A: 20 7D FF (J_PRIMM)
; --- [DATA] ML Monitor Inline String: '<CR>MONITOR\0' ($B03D-$B045) ---
    .BYTE $0D, $4D, $4F, $4E, $49, $54, $4F, $52 ; $B03D [IDENTIFIED_DATA] |.MONITOR|
    .BYTE $00                                    ; $B045 [IDENTIFIED_DATA] |.|
    CLD                      ; $B046: D8      
    TSX                      ; $B047: BA      
    STX   $09                ; $B048: 86 09   
    LDA   #$C0               ; $B04A: A9 C0   
    JSR   $FF90              ; $B04C: 20 90 FF (J_SETMSG)
    CLI                      ; $B04F: 58      
    JSR   $FF7D              ; $B050: 20 7D FF (J_PRIMM)
; --- [DATA] ML Monitor Register Display Header String ($B053-$B06F) ---
    .BYTE $0D, $20, $20, $20, $20, $50, $43, $20 ; $B053 [IDENTIFIED_DATA] |.    PC |
    .BYTE $20, $53, $52, $20, $41, $43, $20, $58 ; $B05B [IDENTIFIED_DATA] | SR AC X|
    .BYTE $52, $20, $59, $52, $20, $53, $50, $0D ; $B063 [IDENTIFIED_DATA] |R YR SP.|
    .BYTE $3B, $20, $1B, $51, $00                ; $B06B [IDENTIFIED_DATA] |; .Q.|
    LDA   $02                ; $B070: A5 02   
    JSR   $B8D2              ; $B072: 20 D2 B8
    TXA                      ; $B075: 8A      
    JSR   $FFD2              ; $B076: 20 D2 FF (J_BSOUT)
    LDA   $03                ; $B079: A5 03   
    JSR   $B8C2              ; $B07B: 20 C2 B8
    LDY   #$02               ; $B07E: A0 02   
    LDA.W $0002,Y            ; $B080: B9 02 00
    JSR   $B8A5              ; $B083: 20 A5 B8
    INY                      ; $B086: C8      
    CPY   #$08               ; $B087: C0 08   
    BCC   $B080              ; $B089: 90 F5   
MON_MAIN_LOOP:
    JSR   $B8B4              ; $B08B: 20 B4 B8
    LDX   #$00               ; $B08E: A2 00   
    STX   $7A                ; $B090: 86 7A   
    JSR   $FFCF              ; $B092: 20 CF FF (J_BASIN)
    STA   $0200,X            ; $B095: 9D 00 02
    INX                      ; $B098: E8      
    CPX   #$A1               ; $B099: E0 A1   
    BCS   $B0BC              ; $B09B: B0 1F   
    CMP   #$0D               ; $B09D: C9 0D   
    BNE   $B092              ; $B09F: D0 F1   
    LDA   #$00               ; $B0A1: A9 00   
    STA   $01FF,X            ; $B0A3: 9D FF 01
    JSR   $B8E9              ; $B0A6: 20 E9 B8
    BEQ   $B08B              ; $B0A9: F0 E0    (MON_MAIN_LOOP)
    CMP   #$20               ; $B0AB: C9 20   
    BEQ   $B0A6              ; $B0AD: F0 F7   
    JMP   ($032E)            ; $B0AF: 6C 2E 03 (EXMON)
MON_MAIN_LOOP:
    LDX   #$15               ; $B0B2: A2 15   
    CMP   $B0E6,X            ; $B0B4: DD E6 B0
    BEQ   $B0C5              ; $B0B7: F0 0C   
    DEX                      ; $B0B9: CA      
    BPL   $B0B4              ; $B0BA: 10 F8   
    JSR   $FF7D              ; $B0BC: 20 7D FF (J_PRIMM)
; --- [DATA] ML Monitor Inline Error String: '<LEFT>?\0' ($B0BF-$B0C1) ---
    .BYTE $1D, $3F, $00                          ; $B0BF [IDENTIFIED_DATA] |.?.|
    JMP   $B08B              ; $B0C2: 4C 8B B0 (MON_MAIN_LOOP)
    CPX   #$13               ; $B0C5: E0 13   
    BCS   $B0DB              ; $B0C7: B0 12   
    CPX   #$0F               ; $B0C9: E0 0F   
    BCS   $B0E0              ; $B0CB: B0 13   
    TXA                      ; $B0CD: 8A      
    ASL   A                  ; $B0CE: 0A      
    TAX                      ; $B0CF: AA      
    LDA   $B0FD,X            ; $B0D0: BD FD B0
    PHA                      ; $B0D3: 48      
    LDA   $B0FC,X            ; $B0D4: BD FC B0
    PHA                      ; $B0D7: 48      
    JMP   $B7A7              ; $B0D8: 4C A7 B7
    STA   $93                ; $B0DB: 85 93   
    JMP   $B337              ; $B0DD: 4C 37 B3 (MON_LOAD_SAVE_VERIFY)
    JMP   $B9B1              ; $B0E0: 4C B1 B9 (MON_BASE_CONVERT)
    JMP   ($0A00)            ; $B0E3: 6C 00 0A
; --- [DATA] ML Monitor 22-Command Character Lookup Table ($B0E6-$B0FB) ---
    .BYTE $41, $43, $44, $46, $47, $48, $4A, $4D ; $B0E6 [IDENTIFIED_DATA] |ACDFGHJM|
    .BYTE $52, $54, $58, $40, $2E, $3E, $3B, $24 ; $B0EE [IDENTIFIED_DATA] |RTX@.>;$|
    .BYTE $2B, $26, $25, $4C, $53, $56           ; $B0F6 [IDENTIFIED_DATA] |+&%LSV|
; --- [DATA] ML Monitor 15-Entry Command RTS-1 Vector Table ($B0FC-$B119) ---
    .BYTE $05, $B4, $30, $B2, $98, $B5, $DA, $B3 ; $B0FC [IDENTIFIED_DATA] |..0.....|
    .BYTE $D5, $B1, $CD, $B2, $DE, $B1, $51, $B1 ; $B104 [IDENTIFIED_DATA] |......Q.|
    .BYTE $4F, $B0, $33, $B2, $E2, $B0, $8F, $BA ; $B10C [IDENTIFIED_DATA] |O.3.....|
    .BYTE $05, $B4, $AA, $B1, $93, $B1           ; $B114 [IDENTIFIED_DATA] |......|
MON_BANK_MEM_ACCESS:
    STX   $0AB2              ; $B11A: 8E B2 0A
    LDX   $68                ; $B11D: A6 68   
    LDA   #$66               ; $B11F: A9 66   
    SEI                      ; $B121: 78      
    JSR   $FF74              ; $B122: 20 74 FF (J_INDFET)
    CLI                      ; $B125: 58      
    LDX   $0AB2              ; $B126: AE B2 0A
    RTS                      ; $B129: 60      
    STX   $0AB2              ; $B12A: 8E B2 0A
    LDX   #$66               ; $B12D: A2 66   
    STX   $02B9              ; $B12F: 8E B9 02
    LDX   $68                ; $B132: A6 68   
    SEI                      ; $B134: 78      
    JSR   $FF77              ; $B135: 20 77 FF (J_INDSTA)
    CLI                      ; $B138: 58      
    LDX   $0AB2              ; $B139: AE B2 0A
    RTS                      ; $B13C: 60      
    STX   $0AB2              ; $B13D: 8E B2 0A
    LDX   #$66               ; $B140: A2 66   
    STX   $02C8              ; $B142: 8E C8 02
    LDX   $68                ; $B145: A6 68   
    SEI                      ; $B147: 78      
    JSR   $FF7A              ; $B148: 20 7A FF (J_INDCMP)
    CLI                      ; $B14B: 58      
    PHP                      ; $B14C: 08      
    LDX   $0AB2              ; $B14D: AE B2 0A
    PLP                      ; $B150: 28      
    RTS                      ; $B151: 60      
MON_MEM_DUMP_MODIFY:
    BCS   $B15C              ; $B152: B0 08   
    JSR   $B901              ; $B154: 20 01 B9
    JSR   $B7A7              ; $B157: 20 A7 B7
    BCC   $B162              ; $B15A: 90 06   
    LDA   #$0B               ; $B15C: A9 0B   
    STA   $60                ; $B15E: 85 60   
    BNE   $B177              ; $B160: D0 15   
    JSR   $B90E              ; $B162: 20 0E B9
    BCC   $B191              ; $B165: 90 2A   
    LDX   #$03               ; $B167: A2 03   
    BIT   $D7                ; $B169: 24 D7   
    BPL   $B16E              ; $B16B: 10 01   
    INX                      ; $B16D: E8      
    LSR   $62                ; $B16E: 46 62   
    ROR   $61                ; $B170: 66 61   
    ROR   $60                ; $B172: 66 60   
    DEX                      ; $B174: CA      
    BNE   $B16E              ; $B175: D0 F7   
    JSR   $FFE1              ; $B177: 20 E1 FF (J_STOP)
    BEQ   $B18E              ; $B17A: F0 12   
    JSR   $B1E8              ; $B17C: 20 E8 B1
    LDA   #$08               ; $B17F: A9 08   
    BIT   $D7                ; $B181: 24 D7   
    BPL   $B186              ; $B183: 10 01   
    ASL   A                  ; $B185: 0A      
    JSR   $B952              ; $B186: 20 52 B9
    JSR   $B922              ; $B189: 20 22 B9
    BCS   $B177              ; $B18C: B0 E9   
    JMP   $B08B              ; $B18E: 4C 8B B0 (MON_MAIN_LOOP)
    JMP   $B0BC              ; $B191: 4C BC B0
    JSR   $B974              ; $B194: 20 74 B9
    LDY   #$00               ; $B197: A0 00   
    JSR   $B7A7              ; $B199: 20 A7 B7
    BCS   $B1A8              ; $B19C: B0 0A   
    LDA   $60                ; $B19E: A5 60   
    STA.W $0005,Y            ; $B1A0: 99 05 00
    INY                      ; $B1A3: C8      
    CPY   #$05               ; $B1A4: C0 05   
    BCC   $B199              ; $B1A6: 90 F1   
    JMP   $B08B              ; $B1A8: 4C 8B B0 (MON_MAIN_LOOP)
    BCS   $B1C9              ; $B1AB: B0 1C   
    JSR   $B901              ; $B1AD: 20 01 B9
    LDY   #$00               ; $B1B0: A0 00   
    JSR   $B7A7              ; $B1B2: 20 A7 B7
    BCS   $B1C9              ; $B1B5: B0 12   
    LDA   $60                ; $B1B7: A5 60   
    JSR   $B12A              ; $B1B9: 20 2A B1
    INY                      ; $B1BC: C8      
    BIT   $D7                ; $B1BD: 24 D7   
    BPL   $B1C5              ; $B1BF: 10 04   
    CPY   #$10               ; $B1C1: C0 10   
    BCC   $B1B2              ; $B1C3: 90 ED   
    CPY   #$08               ; $B1C5: C0 08   
    BCC   $B1B2              ; $B1C7: 90 E9   
    JSR   $FF7D              ; $B1C9: 20 7D FF (J_PRIMM)
; --- [DATA] ML Monitor Inline String: '<ESC>O<UP>\0' ($B1CC-$B1CF) ---
    .BYTE $1B, $4F, $91, $00                     ; $B1CC [IDENTIFIED_DATA] |.O..|
    JSR   $B1E8              ; $B1D0: 20 E8 B1
    JMP   $B08B              ; $B1D3: 4C 8B B0 (MON_MAIN_LOOP)
    JSR   $B974              ; $B1D6: 20 74 B9
    LDX   $09                ; $B1D9: A6 09   
    TXS                      ; $B1DB: 9A      
    JMP   $FF71              ; $B1DC: 4C 71 FF (J_JMPFAR)
    JSR   $B974              ; $B1DF: 20 74 B9
    JSR   $FF6E              ; $B1E2: 20 6E FF (J_JSRFAR)
    JMP   $B08B              ; $B1E5: 4C 8B B0 (MON_MAIN_LOOP)
    JSR   $B8B4              ; $B1E8: 20 B4 B8
    LDA   #$3E               ; $B1EB: A9 3E   
    JSR   $FFD2              ; $B1ED: 20 D2 FF (J_BSOUT)
    JSR   $B892              ; $B1F0: 20 92 B8
    LDY   #$00               ; $B1F3: A0 00   
    BEQ   $B1FA              ; $B1F5: F0 03   
    JSR   $B8A8              ; $B1F7: 20 A8 B8
    JSR   $B11A              ; $B1FA: 20 1A B1 (MON_BANK_MEM_ACCESS)
    JSR   $B8C2              ; $B1FD: 20 C2 B8
    INY                      ; $B200: C8      
    CPY   #$08               ; $B201: C0 08   
    BIT   $D7                ; $B203: 24 D7   
    BPL   $B209              ; $B205: 10 02   
    CPY   #$10               ; $B207: C0 10   
    BCC   $B1F7              ; $B209: 90 EC   
    JSR   $FF7D              ; $B20B: 20 7D FF (J_PRIMM)
; --- [DATA] ML Monitor Inline String: ':<RVS>\0' ($B20E-$B210) ---
    .BYTE $3A, $12, $00                          ; $B20E [IDENTIFIED_DATA] |:..|
    LDY   #$00               ; $B211: A0 00   
    JSR   $B11A              ; $B213: 20 1A B1 (MON_BANK_MEM_ACCESS)
    PHA                      ; $B216: 48      
    AND   #$7F               ; $B217: 29 7F   
    CMP   #$20               ; $B219: C9 20   
    PLA                      ; $B21B: 68      
    BCS   $B220              ; $B21C: B0 02   
    LDA   #$2E               ; $B21E: A9 2E   
    JSR   $FFD2              ; $B220: 20 D2 FF (J_BSOUT)
    INY                      ; $B223: C8      
    BIT   $D7                ; $B224: 24 D7   
    BPL   $B22C              ; $B226: 10 04   
    CPY   #$10               ; $B228: C0 10   
    BCC   $B213              ; $B22A: 90 E7   
    CPY   #$08               ; $B22C: C0 08   
    BCC   $B213              ; $B22E: 90 E3   
    RTS                      ; $B230: 60      
MON_COMPARE_TRANSFER:
    LDA   #$00               ; $B231: A9 00   
    BIT   $80A9              ; $B233: 2C A9 80
    STA   $93                ; $B236: 85 93   
    LDA   #$00               ; $B238: A9 00   
    STA   $0AB3              ; $B23A: 8D B3 0A
    JSR   $B983              ; $B23D: 20 83 B9
    BCS   $B247              ; $B240: B0 05   
    JSR   $B7A7              ; $B242: 20 A7 B7
    BCC   $B24A              ; $B245: 90 03   
    JMP   $B0BC              ; $B247: 4C BC B0
    BIT   $93                ; $B24A: 24 93   
    BPL   $B27A              ; $B24C: 10 2C   
    SEC                      ; $B24E: 38      
    LDA   $66                ; $B24F: A5 66   
    SBC   $60                ; $B251: E5 60   
    LDA   $67                ; $B253: A5 67   
    SBC   $61                ; $B255: E5 61   
    BCS   $B27A              ; $B257: B0 21   
    LDA   $63                ; $B259: A5 63   
    ADC   $60                ; $B25B: 65 60   
    STA   $60                ; $B25D: 85 60   
    LDA   $64                ; $B25F: A5 64   
    ADC   $61                ; $B261: 65 61   
    STA   $61                ; $B263: 85 61   
    LDA   $65                ; $B265: A5 65   
    ADC   $62                ; $B267: 65 62   
    STA   $62                ; $B269: 85 62   
    LDX   #$02               ; $B26B: A2 02   
    LDA   $0AB7,X            ; $B26D: BD B7 0A
    STA   $66,X              ; $B270: 95 66   
    DEX                      ; $B272: CA      
    BPL   $B26D              ; $B273: 10 F8   
    LDA   #$80               ; $B275: A9 80   
    STA   $0AB3              ; $B277: 8D B3 0A
    JSR   $B8B4              ; $B27A: 20 B4 B8
    LDY   #$00               ; $B27D: A0 00   
    JSR   $FFE1              ; $B27F: 20 E1 FF (J_STOP)
    BEQ   $B2CB              ; $B282: F0 47   
    JSR   $B11A              ; $B284: 20 1A B1 (MON_BANK_MEM_ACCESS)
    LDX   #$60               ; $B287: A2 60   
    STX   $02B9              ; $B289: 8E B9 02
    STX   $02C8              ; $B28C: 8E C8 02
    LDX   $62                ; $B28F: A6 62   
    SEI                      ; $B291: 78      
    BIT   $93                ; $B292: 24 93   
    BPL   $B299              ; $B294: 10 03   
    JSR   $FF77              ; $B296: 20 77 FF (J_INDSTA)
    LDX   $62                ; $B299: A6 62   
    JSR   $FF7A              ; $B29B: 20 7A FF (J_INDCMP)
    CLI                      ; $B29E: 58      
    BEQ   $B2AA              ; $B29F: F0 09   
    JSR   $B892              ; $B2A1: 20 92 B8
    JSR   $B8A8              ; $B2A4: 20 A8 B8
    JSR   $B8A8              ; $B2A7: 20 A8 B8
    BIT   $0AB3              ; $B2AA: 2C B3 0A
    BMI   $B2BA              ; $B2AD: 30 0B   
    INC   $60                ; $B2AF: E6 60   
    BNE   $B2C3              ; $B2B1: D0 10   
    INC   $61                ; $B2B3: E6 61   
    BNE   $B2C3              ; $B2B5: D0 0C   
    JMP   $B0BC              ; $B2B7: 4C BC B0
    JSR   $B922              ; $B2BA: 20 22 B9
    JSR   $B960              ; $B2BD: 20 60 B9
    JMP   $B2C6              ; $B2C0: 4C C6 B2
    JSR   $B950              ; $B2C3: 20 50 B9
    JSR   $B93C              ; $B2C6: 20 3C B9
    BCS   $B27F              ; $B2C9: B0 B4   
    JMP   $B08B              ; $B2CB: 4C 8B B0 (MON_MAIN_LOOP)
MON_HUNT:
    JSR   $B983              ; $B2CE: 20 83 B9
    BCS   $B334              ; $B2D1: B0 61   
    LDY   #$00               ; $B2D3: A0 00   
    JSR   $B8E9              ; $B2D5: 20 E9 B8
    CMP   #$27               ; $B2D8: C9 27   
    BNE   $B2F2              ; $B2DA: D0 16   
    JSR   $B8E9              ; $B2DC: 20 E9 B8
    CMP   #$00               ; $B2DF: C9 00   
    BEQ   $B334              ; $B2E1: F0 51   
    STA   $0A80,Y            ; $B2E3: 99 80 0A
    INY                      ; $B2E6: C8      
    JSR   $B8E9              ; $B2E7: 20 E9 B8
    BEQ   $B307              ; $B2EA: F0 1B   
    CPY   #$20               ; $B2EC: C0 20   
    BNE   $B2E3              ; $B2EE: D0 F3   
    BEQ   $B307              ; $B2F0: F0 15   
    STY   $0100              ; $B2F2: 8C 00 01
    JSR   $B7A5              ; $B2F5: 20 A5 B7 (MON_NUM_PARSER)
    LDA   $60                ; $B2F8: A5 60   
    STA   $0A80,Y            ; $B2FA: 99 80 0A
    INY                      ; $B2FD: C8      
    JSR   $B7A7              ; $B2FE: 20 A7 B7
    BCS   $B307              ; $B301: B0 04   
    CPY   #$20               ; $B303: C0 20   
    BNE   $B2F8              ; $B305: D0 F1   
    STY   $93                ; $B307: 84 93   
    JSR   $B8B4              ; $B309: 20 B4 B8
    LDY   #$00               ; $B30C: A0 00   
    JSR   $B11A              ; $B30E: 20 1A B1 (MON_BANK_MEM_ACCESS)
    CMP   $0A80,Y            ; $B311: D9 80 0A
    BNE   $B324              ; $B314: D0 0E   
    INY                      ; $B316: C8      
    CPY   $93                ; $B317: C4 93   
    BNE   $B30E              ; $B319: D0 F3   
    JSR   $B892              ; $B31B: 20 92 B8
    JSR   $B8A8              ; $B31E: 20 A8 B8
    JSR   $B8A8              ; $B321: 20 A8 B8
    JSR   $FFE1              ; $B324: 20 E1 FF (J_STOP)
    BEQ   $B331              ; $B327: F0 08   
    JSR   $B950              ; $B329: 20 50 B9
    JSR   $B93C              ; $B32C: 20 3C B9
    BCS   $B30C              ; $B32F: B0 DB   
    JMP   $B08B              ; $B331: 4C 8B B0 (MON_MAIN_LOOP)
    JMP   $B0BC              ; $B334: 4C BC B0
MON_LOAD_SAVE_VERIFY:
    LDY   #$01               ; $B337: A0 01   
    STY   $BA                ; $B339: 84 BA   
    STY   $B9                ; $B33B: 84 B9   
    DEY                      ; $B33D: 88      
    STY   $C6                ; $B33E: 84 C6   
    STY   $B7                ; $B340: 84 B7   
    STY   $C7                ; $B342: 84 C7   
    STY   $90                ; $B344: 84 90   
    LDA   #$0A               ; $B346: A9 0A   
    STA   $BC                ; $B348: 85 BC   
    LDA   #$80               ; $B34A: A9 80   
    STA   $BB                ; $B34C: 85 BB   
    JSR   $B8E9              ; $B34E: 20 E9 B8
    BEQ   $B3AB              ; $B351: F0 58   
    CMP   #$20               ; $B353: C9 20   
    BEQ   $B34E              ; $B355: F0 F7   
    CMP   #$22               ; $B357: C9 22   
    BNE   $B370              ; $B359: D0 15   
    LDX   $7A                ; $B35B: A6 7A   
    LDA   $0200,X            ; $B35D: BD 00 02
    BEQ   $B3AB              ; $B360: F0 49   
    INX                      ; $B362: E8      
    CMP   #$22               ; $B363: C9 22   
    BEQ   $B373              ; $B365: F0 0C   
    STA   ($BB),Y            ; $B367: 91 BB   
    INC   $B7                ; $B369: E6 B7   
    INY                      ; $B36B: C8      
    CPY   #$11               ; $B36C: C0 11   
    BCC   $B35D              ; $B36E: 90 ED   
    JMP   $B0BC              ; $B370: 4C BC B0
    STX   $7A                ; $B373: 86 7A   
    JSR   $B8E9              ; $B375: 20 E9 B8
    BEQ   $B3AB              ; $B378: F0 31   
    JSR   $B7A7              ; $B37A: 20 A7 B7
    BCS   $B3AB              ; $B37D: B0 2C   
    LDA   $60                ; $B37F: A5 60   
    STA   $BA                ; $B381: 85 BA   
    JSR   $B7A7              ; $B383: 20 A7 B7
    BCS   $B3AB              ; $B386: B0 23   
    JSR   $B901              ; $B388: 20 01 B9
    STA   $C6                ; $B38B: 85 C6   
    JSR   $B7A7              ; $B38D: 20 A7 B7
    BCS   $B3D1              ; $B390: B0 3F   
    JSR   $B8B4              ; $B392: 20 B4 B8
    LDX   $60                ; $B395: A6 60   
    LDY   $61                ; $B397: A4 61   
    LDA   $93                ; $B399: A5 93   
    CMP   #$53               ; $B39B: C9 53   
    BNE   $B370              ; $B39D: D0 D1   
    LDA   #$00               ; $B39F: A9 00   
    STA   $B9                ; $B3A1: 85 B9   
    LDA   #$66               ; $B3A3: A9 66   
    JSR   $FFD8              ; $B3A5: 20 D8 FF (J_SAVE)
    JMP   $B08B              ; $B3A8: 4C 8B B0 (MON_MAIN_LOOP)
    LDA   $93                ; $B3AB: A5 93   
    CMP   #$56               ; $B3AD: C9 56   
    BEQ   $B3B7              ; $B3AF: F0 06   
    CMP   #$4C               ; $B3B1: C9 4C   
    BNE   $B370              ; $B3B3: D0 BB   
    LDA   #$00               ; $B3B5: A9 00   
    JSR   $FFD5              ; $B3B7: 20 D5 FF (J_LOAD)
    LDA   $90                ; $B3BA: A5 90   
    AND   #$10               ; $B3BC: 29 10   
    BEQ   $B3A8              ; $B3BE: F0 E8   
    LDA   $93                ; $B3C0: A5 93   
    BEQ   $B370              ; $B3C2: F0 AC   
    JSR   $FF7D              ; $B3C4: 20 7D FF (J_PRIMM)
; --- [DATA] ML Monitor Inline String: ' ERROR\0' ($B3C7-$B3CD) ---
    .BYTE $20, $45, $52, $52, $4F, $52, $00      ; $B3C7 [IDENTIFIED_DATA] | ERROR.|
    JMP   $B08B              ; $B3CE: 4C 8B B0 (MON_MAIN_LOOP)
    LDX   $66                ; $B3D1: A6 66   
    LDY   $67                ; $B3D3: A4 67   
    LDA   #$00               ; $B3D5: A9 00   
    STA   $B9                ; $B3D7: 85 B9   
    BEQ   $B3AB              ; $B3D9: F0 D0   
MON_FILL:
    JSR   $B983              ; $B3DB: 20 83 B9
    BCS   $B403              ; $B3DE: B0 23   
    LDA   $68                ; $B3E0: A5 68   
    CMP   $0AB9              ; $B3E2: CD B9 0A
    BNE   $B403              ; $B3E5: D0 1C   
    JSR   $B7A7              ; $B3E7: 20 A7 B7
    BCS   $B403              ; $B3EA: B0 17   
    LDY   #$00               ; $B3EC: A0 00   
    LDA   $60                ; $B3EE: A5 60   
    JSR   $B12A              ; $B3F0: 20 2A B1
    JSR   $FFE1              ; $B3F3: 20 E1 FF (J_STOP)
    BEQ   $B400              ; $B3F6: F0 08   
    JSR   $B950              ; $B3F8: 20 50 B9
    JSR   $B93C              ; $B3FB: 20 3C B9
    BCS   $B3EE              ; $B3FE: B0 EE   
    JMP   $B08B              ; $B400: 4C 8B B0 (MON_MAIN_LOOP)
    JMP   $B0BC              ; $B403: 4C BC B0
MON_ASSEMBLER:
    BCS   $B442              ; $B406: B0 3A   
    JSR   $B901              ; $B408: 20 01 B9
    LDX   #$00               ; $B40B: A2 00   
    STX   $0AA1              ; $B40D: 8E A1 0A
    STX   $0AB4              ; $B410: 8E B4 0A
    JSR   $B8E9              ; $B413: 20 E9 B8
    BNE   $B41F              ; $B416: D0 07   
    CPX   #$00               ; $B418: E0 00   
    BNE   $B41F              ; $B41A: D0 03   
    JMP   $B08B              ; $B41C: 4C 8B B0 (MON_MAIN_LOOP)
    CMP   #$20               ; $B41F: C9 20   
    BEQ   $B40B              ; $B421: F0 E8   
    STA   $0AAC,X            ; $B423: 9D AC 0A
    INX                      ; $B426: E8      
    CPX   #$03               ; $B427: E0 03   
    BNE   $B413              ; $B429: D0 E8   
    DEX                      ; $B42B: CA      
    BMI   $B445              ; $B42C: 30 17   
    LDA   $0AAC,X            ; $B42E: BD AC 0A
    SEC                      ; $B431: 38      
    SBC   #$3F               ; $B432: E9 3F   
    LDY   #$05               ; $B434: A0 05   
    LSR   A                  ; $B436: 4A      
    ROR   $0AA1              ; $B437: 6E A1 0A
    ROR   $0AA0              ; $B43A: 6E A0 0A
    DEY                      ; $B43D: 88      
    BNE   $B436              ; $B43E: D0 F6   
    BEQ   $B42B              ; $B440: F0 E9   
    JMP   $B0BC              ; $B442: 4C BC B0
    LDX   #$02               ; $B445: A2 02   
    LDA   $0AB4              ; $B447: AD B4 0A
    BNE   $B47C              ; $B44A: D0 30   
    JSR   $B7CE              ; $B44C: 20 CE B7
    BEQ   $B47A              ; $B44F: F0 29   
    BCS   $B442              ; $B451: B0 EF   
    LDA   #$24               ; $B453: A9 24   
    STA   $0AA0,X            ; $B455: 9D A0 0A
    INX                      ; $B458: E8      
    LDA   $62                ; $B459: A5 62   
    BNE   $B442              ; $B45B: D0 E5   
    LDY   #$04               ; $B45D: A0 04   
    LDA   $0AB6              ; $B45F: AD B6 0A
    CMP   #$08               ; $B462: C9 08   
    BCC   $B46B              ; $B464: 90 05   
    CPY   $0AB4              ; $B466: CC B4 0A
    BEQ   $B471              ; $B469: F0 06   
    LDA   $61                ; $B46B: A5 61   
    BNE   $B471              ; $B46D: D0 02   
    LDY   #$02               ; $B46F: A0 02   
    LDA   #$30               ; $B471: A9 30   
    STA   $0AA0,X            ; $B473: 9D A0 0A
    INX                      ; $B476: E8      
    DEY                      ; $B477: 88      
    BNE   $B473              ; $B478: D0 F9   
    DEC   $7A                ; $B47A: C6 7A   
    JSR   $B8E9              ; $B47C: 20 E9 B8
    BEQ   $B48F              ; $B47F: F0 0E   
    CMP   #$20               ; $B481: C9 20   
    BEQ   $B447              ; $B483: F0 C2   
    STA   $0AA0,X            ; $B485: 9D A0 0A
    INX                      ; $B488: E8      
    CPX   #$0A               ; $B489: E0 0A   
    BCC   $B447              ; $B48B: 90 BA   
    BCS   $B442              ; $B48D: B0 B3   
    STX   $63                ; $B48F: 86 63   
    LDX   #$00               ; $B491: A2 00   
    STX   $0AB1              ; $B493: 8E B1 0A
    LDX   #$00               ; $B496: A2 00   
    STX   $9F                ; $B498: 86 9F   
    LDA   $0AB1              ; $B49A: AD B1 0A
    JSR   $B659              ; $B49D: 20 59 B6
    LDX   $0AAA              ; $B4A0: AE AA 0A
    STX   $64                ; $B4A3: 86 64   
    TAX                      ; $B4A5: AA      
    LDA   $B761,X            ; $B4A6: BD 61 B7
    JSR   $B57F              ; $B4A9: 20 7F B5
    LDA   $B721,X            ; $B4AC: BD 21 B7
    JSR   $B57F              ; $B4AF: 20 7F B5
    LDX   #$06               ; $B4B2: A2 06   
    CPX   #$03               ; $B4B4: E0 03   
    BNE   $B4CC              ; $B4B6: D0 14   
    LDY   $0AAB              ; $B4B8: AC AB 0A
    BEQ   $B4CC              ; $B4BB: F0 0F   
    LDA   $0AAA              ; $B4BD: AD AA 0A
    CMP   #$E8               ; $B4C0: C9 E8   
    LDA   #$30               ; $B4C2: A9 30   
    BCS   $B4E4              ; $B4C4: B0 1E   
    JSR   $B57C              ; $B4C6: 20 7C B5
    DEY                      ; $B4C9: 88      
    BNE   $B4BD              ; $B4CA: D0 F1   
    ASL   $0AAA              ; $B4CC: 0E AA 0A
    BCC   $B4DF              ; $B4CF: 90 0E   
    LDA   $B714,X            ; $B4D1: BD 14 B7
    JSR   $B57F              ; $B4D4: 20 7F B5
    LDA   $B71A,X            ; $B4D7: BD 1A B7
    BEQ   $B4DF              ; $B4DA: F0 03   
    JSR   $B57F              ; $B4DC: 20 7F B5
    DEX                      ; $B4DF: CA      
    BNE   $B4B4              ; $B4E0: D0 D2   
    BEQ   $B4EA              ; $B4E2: F0 06   
    JSR   $B57C              ; $B4E4: 20 7C B5
    JSR   $B57C              ; $B4E7: 20 7C B5
    LDA   $63                ; $B4EA: A5 63   
    CMP   $9F                ; $B4EC: C5 9F   
    BEQ   $B4F3              ; $B4EE: F0 03   
    JMP   $B58B              ; $B4F0: 4C 8B B5
    LDY   $0AAB              ; $B4F3: AC AB 0A
    BEQ   $B52A              ; $B4F6: F0 32   
    LDA   $64                ; $B4F8: A5 64   
    CMP   #$9D               ; $B4FA: C9 9D   
    BNE   $B521              ; $B4FC: D0 23   
    LDA   $60                ; $B4FE: A5 60   
    SBC   $66                ; $B500: E5 66   
    TAX                      ; $B502: AA      
    LDA   $61                ; $B503: A5 61   
    SBC   $67                ; $B505: E5 67   
    BCC   $B511              ; $B507: 90 08   
    BNE   $B579              ; $B509: D0 6E   
    CPX   #$82               ; $B50B: E0 82   
    BCS   $B579              ; $B50D: B0 6A   
    BCC   $B519              ; $B50F: 90 08   
    TAY                      ; $B511: A8      
    INY                      ; $B512: C8      
    BNE   $B579              ; $B513: D0 64   
    CPX   #$82               ; $B515: E0 82   
    BCC   $B579              ; $B517: 90 60   
    DEX                      ; $B519: CA      
    DEX                      ; $B51A: CA      
    TXA                      ; $B51B: 8A      
    LDY   $0AAB              ; $B51C: AC AB 0A
    BNE   $B524              ; $B51F: D0 03   
    LDA.W $005F,Y            ; $B521: B9 5F 00
    JSR   $B12A              ; $B524: 20 2A B1
    DEY                      ; $B527: 88      
    BNE   $B521              ; $B528: D0 F7   
    LDA   $0AB1              ; $B52A: AD B1 0A
    JSR   $B12A              ; $B52D: 20 2A B1
    JSR   $B8AD              ; $B530: 20 AD B8
    JSR   $FF7D              ; $B533: 20 7D FF (J_PRIMM)
; --- [DATA] ML Monitor Inline String: 'A <ESC>Q\0' ($B536-$B53A) ---
    .BYTE $41, $20, $1B, $51, $00                ; $B536 [IDENTIFIED_DATA] |A .Q.|
    JSR   $B5DC              ; $B53B: 20 DC B5
    INC   $0AAB              ; $B53E: EE AB 0A
    LDA   $0AAB              ; $B541: AD AB 0A
    JSR   $B952              ; $B544: 20 52 B9
    LDA   #$41               ; $B547: A9 41   
    STA   $034A              ; $B549: 8D 4A 03
    LDA   #$20               ; $B54C: A9 20   
    STA   $034B              ; $B54E: 8D 4B 03
    STA   $0351              ; $B551: 8D 51 03
    LDA   $68                ; $B554: A5 68   
    JSR   $B8D2              ; $B556: 20 D2 B8
    STX   $034C              ; $B559: 8E 4C 03
    LDA   $67                ; $B55C: A5 67   
    JSR   $B8D2              ; $B55E: 20 D2 B8
    STA   $034D              ; $B561: 8D 4D 03
    STX   $034E              ; $B564: 8E 4E 03
    LDA   $66                ; $B567: A5 66   
    JSR   $B8D2              ; $B569: 20 D2 B8
    STA   $034F              ; $B56C: 8D 4F 03
    STX   $0350              ; $B56F: 8E 50 03
    LDA   #$08               ; $B572: A9 08   
    STA   $D0                ; $B574: 85 D0   
    JMP   $B08B              ; $B576: 4C 8B B0 (MON_MAIN_LOOP)
    JMP   $B0BC              ; $B579: 4C BC B0
    JSR   $B57F              ; $B57C: 20 7F B5
    STX   $0AAF              ; $B57F: 8E AF 0A
    LDX   $9F                ; $B582: A6 9F   
    CMP   $0AA0,X            ; $B584: DD A0 0A
    BEQ   $B593              ; $B587: F0 0A   
    PLA                      ; $B589: 68      
    PLA                      ; $B58A: 68      
    INC   $0AB1              ; $B58B: EE B1 0A
    BEQ   $B579              ; $B58E: F0 E9   
    JMP   $B496              ; $B590: 4C 96 B4
    INC   $9F                ; $B593: E6 9F   
    LDX   $0AAF              ; $B595: AE AF 0A
    RTS                      ; $B598: 60      
MON_DISASSEMBLER:
    BCS   $B5A3              ; $B599: B0 08   
    JSR   $B901              ; $B59B: 20 01 B9
    JSR   $B7A7              ; $B59E: 20 A7 B7
    BCC   $B5A9              ; $B5A1: 90 06   
    LDA   #$14               ; $B5A3: A9 14   
    STA   $60                ; $B5A5: 85 60   
    BNE   $B5AE              ; $B5A7: D0 05   
    JSR   $B90E              ; $B5A9: 20 0E B9
    BCC   $B5D1              ; $B5AC: 90 23   
    JSR   $FF7D              ; $B5AE: 20 7D FF (J_PRIMM)
; --- [DATA] ML Monitor Inline String: '<CR><ESC>Q\0' ($B5B1-$B5B4) ---
    .BYTE $0D, $1B, $51, $00                     ; $B5B1 [IDENTIFIED_DATA] |..Q.|
    JSR   $FFE1              ; $B5B5: 20 E1 FF (J_STOP)
    BEQ   $B5CE              ; $B5B8: F0 14   
    JSR   $B5D4              ; $B5BA: 20 D4 B5
    INC   $0AAB              ; $B5BD: EE AB 0A
    LDA   $0AAB              ; $B5C0: AD AB 0A
    JSR   $B952              ; $B5C3: 20 52 B9
    LDA   $0AAB              ; $B5C6: AD AB 0A
    JSR   $B924              ; $B5C9: 20 24 B9
    BCS   $B5AE              ; $B5CC: B0 E0   
    JMP   $B08B              ; $B5CE: 4C 8B B0 (MON_MAIN_LOOP)
    JMP   $B0BC              ; $B5D1: 4C BC B0
    LDA   #$2E               ; $B5D4: A9 2E   
    JSR   $FFD2              ; $B5D6: 20 D2 FF (J_BSOUT)
    JSR   $B8A8              ; $B5D9: 20 A8 B8
    JSR   $B892              ; $B5DC: 20 92 B8
    JSR   $B8A8              ; $B5DF: 20 A8 B8
    LDY   #$00               ; $B5E2: A0 00   
    JSR   $B11A              ; $B5E4: 20 1A B1 (MON_BANK_MEM_ACCESS)
    JSR   $B659              ; $B5E7: 20 59 B6
    PHA                      ; $B5EA: 48      
    LDX   $0AAB              ; $B5EB: AE AB 0A
    INX                      ; $B5EE: E8      
    DEX                      ; $B5EF: CA      
    BPL   $B5FC              ; $B5F0: 10 0A   
    JSR   $FF7D              ; $B5F2: 20 7D FF (J_PRIMM)
    JSR   $2020              ; $B5F5: 20 20 20
    BRK                      ; $B5F8: 00      
    JMP   $B602              ; $B5F9: 4C 02 B6
    JSR   $B11A              ; $B5FC: 20 1A B1 (MON_BANK_MEM_ACCESS)
    JSR   $B8A5              ; $B5FF: 20 A5 B8
    INY                      ; $B602: C8      
    CPY   #$03               ; $B603: C0 03   
    BCC   $B5EF              ; $B605: 90 E8   
    PLA                      ; $B607: 68      
    LDX   #$03               ; $B608: A2 03   
    JSR   $B6A1              ; $B60A: 20 A1 B6
    LDX   #$06               ; $B60D: A2 06   
    CPX   #$03               ; $B60F: E0 03   
    BNE   $B62A              ; $B611: D0 17   
    LDY   $0AAB              ; $B613: AC AB 0A
    BEQ   $B62A              ; $B616: F0 12   
    LDA   $0AAA              ; $B618: AD AA 0A
    CMP   #$E8               ; $B61B: C9 E8   
    PHP                      ; $B61D: 08      
    JSR   $B11A              ; $B61E: 20 1A B1 (MON_BANK_MEM_ACCESS)
    PLP                      ; $B621: 28      
    BCS   $B641              ; $B622: B0 1D   
    JSR   $B8C2              ; $B624: 20 C2 B8
    DEY                      ; $B627: 88      
    BNE   $B618              ; $B628: D0 EE   
    ASL   $0AAA              ; $B62A: 0E AA 0A
    BCC   $B63D              ; $B62D: 90 0E   
    LDA   $B714,X            ; $B62F: BD 14 B7
    JSR   $FFD2              ; $B632: 20 D2 FF (J_BSOUT)
    LDA   $B71A,X            ; $B635: BD 1A B7
    BEQ   $B63D              ; $B638: F0 03   
    JSR   $FFD2              ; $B63A: 20 D2 FF (J_BSOUT)
    DEX                      ; $B63D: CA      
    BNE   $B60F              ; $B63E: D0 CF   
    RTS                      ; $B640: 60      
    JSR   $B64D              ; $B641: 20 4D B6
    CLC                      ; $B644: 18      
    ADC   #$01               ; $B645: 69 01   
    BNE   $B64A              ; $B647: D0 01   
    INX                      ; $B649: E8      
    JMP   $B89F              ; $B64A: 4C 9F B8
    LDX   $67                ; $B64D: A6 67   
    TAY                      ; $B64F: A8      
    BPL   $B653              ; $B650: 10 01   
    DEX                      ; $B652: CA      
    ADC   $66                ; $B653: 65 66   
    BCC   $B658              ; $B655: 90 01   
    INX                      ; $B657: E8      
    RTS                      ; $B658: 60      
    TAY                      ; $B659: A8      
    LSR   A                  ; $B65A: 4A      
    BCC   $B668              ; $B65B: 90 0B   
    LSR   A                  ; $B65D: 4A      
    BCS   $B677              ; $B65E: B0 17   
    CMP   #$22               ; $B660: C9 22   
    BEQ   $B677              ; $B662: F0 13   
    AND   #$07               ; $B664: 29 07   
    ORA   #$80               ; $B666: 09 80   
    LSR   A                  ; $B668: 4A      
    TAX                      ; $B669: AA      
    LDA   $B6C3,X            ; $B66A: BD C3 B6
    BCS   $B673              ; $B66D: B0 04   
    LSR   A                  ; $B66F: 4A      
    LSR   A                  ; $B670: 4A      
    LSR   A                  ; $B671: 4A      
    LSR   A                  ; $B672: 4A      
    AND   #$0F               ; $B673: 29 0F   
    BNE   $B67B              ; $B675: D0 04   
    LDY   #$80               ; $B677: A0 80   
    LDA   #$00               ; $B679: A9 00   
    TAX                      ; $B67B: AA      
    LDA   $B707,X            ; $B67C: BD 07 B7
    STA   $0AAA              ; $B67F: 8D AA 0A
    AND   #$03               ; $B682: 29 03   
    STA   $0AAB              ; $B684: 8D AB 0A
    TYA                      ; $B687: 98      
    AND   #$8F               ; $B688: 29 8F   
    TAX                      ; $B68A: AA      
    TYA                      ; $B68B: 98      
    LDY   #$03               ; $B68C: A0 03   
    CPX   #$8A               ; $B68E: E0 8A   
    BEQ   $B69D              ; $B690: F0 0B   
    LSR   A                  ; $B692: 4A      
    BCC   $B69D              ; $B693: 90 08   
    LSR   A                  ; $B695: 4A      
    LSR   A                  ; $B696: 4A      
    ORA   #$20               ; $B697: 09 20   
    DEY                      ; $B699: 88      
    BNE   $B696              ; $B69A: D0 FA   
    INY                      ; $B69C: C8      
    DEY                      ; $B69D: 88      
    BNE   $B692              ; $B69E: D0 F2   
    RTS                      ; $B6A0: 60      
    TAY                      ; $B6A1: A8      
    LDA   $B721,Y            ; $B6A2: B9 21 B7
    STA   $63                ; $B6A5: 85 63   
    LDA   $B761,Y            ; $B6A7: B9 61 B7
    STA   $64                ; $B6AA: 85 64   
    LDA   #$00               ; $B6AC: A9 00   
    LDY   #$05               ; $B6AE: A0 05   
    ASL   $64                ; $B6B0: 06 64   
    ROL   $63                ; $B6B2: 26 63   
    ROL   A                  ; $B6B4: 2A      
    DEY                      ; $B6B5: 88      
    BNE   $B6B0              ; $B6B6: D0 F8   
    ADC   #$3F               ; $B6B8: 69 3F   
    JSR   $FFD2              ; $B6BA: 20 D2 FF (J_BSOUT)
    DEX                      ; $B6BD: CA      
    BNE   $B6AC              ; $B6BE: D0 EC   
    JMP   $B8A8              ; $B6C0: 4C A8 B8
    RTI                      ; $B6C3: 40      
    .BYTE $02                                ; $B6C4: 02 [UNRESOLVED]
    EOR   $03                ; $B6C5: 45 03   
    BNE   $B6D1              ; $B6C7: D0 08   
    RTI                      ; $B6C9: 40      
    ORA   #$30               ; $B6CA: 09 30   
    .BYTE $22                                ; $B6CC: 22 [UNRESOLVED]
    EOR   $33                ; $B6CD: 45 33   
    BNE   $B6D9              ; $B6CF: D0 08   
    RTI                      ; $B6D1: 40      
    ORA   #$40               ; $B6D2: 09 40   
    .BYTE $02                                ; $B6D4: 02 [UNRESOLVED]
    EOR   $33                ; $B6D5: 45 33   
    BNE   $B6E1              ; $B6D7: D0 08   
    RTI                      ; $B6D9: 40      
    ORA   #$40               ; $B6DA: 09 40   
    .BYTE $02                                ; $B6DC: 02 [UNRESOLVED]
    EOR   $B3                ; $B6DD: 45 B3   
    BNE   $B6E9              ; $B6DF: D0 08   
    RTI                      ; $B6E1: 40      
    ORA   #$00               ; $B6E2: 09 00   
    .BYTE $22                                ; $B6E4: 22 [UNRESOLVED]
    .BYTE $44                                ; $B6E5: 44 [UNRESOLVED]
    .BYTE $33                                ; $B6E6: 33 [UNRESOLVED]
    BNE   $B675              ; $B6E7: D0 8C   
    .BYTE $44                                ; $B6E9: 44 [UNRESOLVED]
    BRK                      ; $B6EA: 00      
    ORA   ($22),Y            ; $B6EB: 11 22   
    .BYTE $44                                ; $B6ED: 44 [UNRESOLVED]
    .BYTE $33                                ; $B6EE: 33 [UNRESOLVED]
    BNE   $B67D              ; $B6EF: D0 8C   
    .BYTE $44                                ; $B6F1: 44 [UNRESOLVED]
    TXS                      ; $B6F2: 9A      
    BPL   $B717              ; $B6F3: 10 22   
    .BYTE $44                                ; $B6F5: 44 [UNRESOLVED]
    .BYTE $33                                ; $B6F6: 33 [UNRESOLVED]
    BNE   $B701              ; $B6F7: D0 08   
    RTI                      ; $B6F9: 40      
    ORA   #$10               ; $B6FA: 09 10   
    .BYTE $22                                ; $B6FC: 22 [UNRESOLVED]
    .BYTE $44                                ; $B6FD: 44 [UNRESOLVED]
    .BYTE $33                                ; $B6FE: 33 [UNRESOLVED]
    BNE   $B709              ; $B6FF: D0 08   
    RTI                      ; $B701: 40      
    ORA   #$62               ; $B702: 09 62   
    .BYTE $13                                ; $B704: 13 [UNRESOLVED]
    SEI                      ; $B705: 78      
    LDA   #$00               ; $B706: A9 00   
    AND   ($81,X)            ; $B708: 21 81   
    .BYTE $82                                ; $B70A: 82 [UNRESOLVED]
    BRK                      ; $B70B: 00      
    BRK                      ; $B70C: 00      
    EOR   $914D,Y            ; $B70D: 59 4D 91
    .BYTE $92                                ; $B710: 92 [UNRESOLVED]
    STX   $4A                ; $B711: 86 4A   
    .BYTE $85                                ; $B713: 85 [UNRESOLVED]
; --- [DATA] ML Monitor 8502 Addressing Mode & 5-Bit Packed Mnemonic Tables ($B714-$B7A0) ---
    .BYTE $9D, $2C, $29, $2C, $23, $28, $24, $59 ; $B714 [IDENTIFIED_DATA] |.,),#($Y|
    .BYTE $00, $58, $24, $24, $00, $1C, $8A, $1C ; $B71C [IDENTIFIED_DATA] |.X$$....|
    .BYTE $23, $5D, $8B, $1B, $A1, $9D, $8A, $1D ; $B724 [IDENTIFIED_DATA] |#]......|
    .BYTE $23, $9D, $8B, $1D, $A1, $00, $29, $19 ; $B72C [IDENTIFIED_DATA] |#.....).|
    .BYTE $AE, $69, $A8, $19, $23, $24, $53, $1B ; $B734 [IDENTIFIED_DATA] |.i..#$S.|
    .BYTE $23, $24, $53, $19, $A1, $00, $1A, $5B ; $B73C [IDENTIFIED_DATA] |#$S....[|
    .BYTE $5B, $A5, $69, $24, $24, $AE, $AE, $A8 ; $B744 [IDENTIFIED_DATA] |[.i$$...|
    .BYTE $AD, $29, $00, $7C, $00, $15, $9C, $6D ; $B74C [IDENTIFIED_DATA] |.).|...m|
    .BYTE $9C, $A5, $69, $29, $53, $84, $13, $34 ; $B754 [IDENTIFIED_DATA] |..i)S..4|
    .BYTE $11, $A5, $69, $23, $A0, $D8, $62, $5A ; $B75C [IDENTIFIED_DATA] |..i#..bZ|
    .BYTE $48, $26, $62, $94, $88, $54, $44, $C8 ; $B764 [IDENTIFIED_DATA] |H&b..TD.|
    .BYTE $54, $68, $44, $E8, $94, $00, $B4, $08 ; $B76C [IDENTIFIED_DATA] |ThD.....|
    .BYTE $84, $74, $B4, $28, $6E, $74, $F4, $CC ; $B774 [IDENTIFIED_DATA] |.t.(nt..|
    .BYTE $4A, $72, $F2, $A4, $8A, $00, $AA, $A2 ; $B77C [IDENTIFIED_DATA] |Jr......|
    .BYTE $A2, $74, $74, $74, $72, $44, $68, $B2 ; $B784 [IDENTIFIED_DATA] |.tttrDh.|
    .BYTE $32, $B2, $00, $22, $00, $1A, $1A, $26 ; $B78C [IDENTIFIED_DATA] |2.."...&|
    .BYTE $26, $72, $72, $88, $C8, $C4, $CA, $26 ; $B794 [IDENTIFIED_DATA] |&rr....&|
    .BYTE $48, $44, $44, $A2, $C8                ; $B79C [IDENTIFIED_DATA] |HDD..|
    ORA   $2020              ; $B7A1: 0D 20 20
    JSR   $7AC6              ; $B7A4: 20 C6 7A
    JSR   $B7CE              ; $B7A7: 20 CE B7
    BCS   $B7C2              ; $B7AA: B0 16   
    JSR   $B8E7              ; $B7AC: 20 E7 B8
    BNE   $B7BA              ; $B7AF: D0 09   
    DEC   $7A                ; $B7B1: C6 7A   
    LDA   $0AB4              ; $B7B3: AD B4 0A
    BNE   $B7C9              ; $B7B6: D0 11   
    BEQ   $B7C7              ; $B7B8: F0 0D   
    CMP   #$20               ; $B7BA: C9 20   
    BEQ   $B7C9              ; $B7BC: F0 0B   
    CMP   #$2C               ; $B7BE: C9 2C   
    BEQ   $B7C9              ; $B7C0: F0 07   
    PLA                      ; $B7C2: 68      
    PLA                      ; $B7C3: 68      
    JMP   $B0BC              ; $B7C4: 4C BC B0
    SEC                      ; $B7C7: 38      
    BIT   $18                ; $B7C8: 24 18   
    LDA   $0AB4              ; $B7CA: AD B4 0A
    RTS                      ; $B7CD: 60      
    LDA   #$00               ; $B7CE: A9 00   
    STA   $60                ; $B7D0: 85 60   
    STA   $61                ; $B7D2: 85 61   
    STA   $62                ; $B7D4: 85 62   
    STA   $0AB4              ; $B7D6: 8D B4 0A
    TXA                      ; $B7D9: 8A      
    PHA                      ; $B7DA: 48      
    TYA                      ; $B7DB: 98      
    PHA                      ; $B7DC: 48      
    JSR   $B8E9              ; $B7DD: 20 E9 B8
    BNE   $B7E5              ; $B7E0: D0 03   
    JMP   $B87E              ; $B7E2: 4C 7E B8
    CMP   #$20               ; $B7E5: C9 20   
    BEQ   $B7DD              ; $B7E7: F0 F4   
    LDX   #$03               ; $B7E9: A2 03   
    CMP   $B0F5,X            ; $B7EB: DD F5 B0
    BEQ   $B7F6              ; $B7EE: F0 06   
    DEX                      ; $B7F0: CA      
    BPL   $B7EB              ; $B7F1: 10 F8   
    INX                      ; $B7F3: E8      
    DEC   $7A                ; $B7F4: C6 7A   
    LDY   $B88A,X            ; $B7F6: BC 8A B8
    LDA   $B88E,X            ; $B7F9: BD 8E B8
    STA   $0AB6              ; $B7FC: 8D B6 0A
    JSR   $B8E9              ; $B7FF: 20 E9 B8
    BEQ   $B87E              ; $B802: F0 7A   
    SEC                      ; $B804: 38      
    SBC   #$30               ; $B805: E9 30   
    BCC   $B87E              ; $B807: 90 75   
    CMP   #$0A               ; $B809: C9 0A   
    BCC   $B813              ; $B80B: 90 06   
    SBC   #$07               ; $B80D: E9 07   
    CMP   #$10               ; $B80F: C9 10   
    BCS   $B87E              ; $B811: B0 6B   
    STA   $0AB5              ; $B813: 8D B5 0A
    CPY   $0AB5              ; $B816: CC B5 0A
    BCC   $B87C              ; $B819: 90 61   
    BEQ   $B87C              ; $B81B: F0 5F   
    INC   $0AB4              ; $B81D: EE B4 0A
    CPY   #$0A               ; $B820: C0 0A   
    BNE   $B82E              ; $B822: D0 0A   
    LDX   #$02               ; $B824: A2 02   
    LDA   $60,X              ; $B826: B5 60   
    STA   $0AB7,X            ; $B828: 9D B7 0A
    DEX                      ; $B82B: CA      
    BPL   $B826              ; $B82C: 10 F8   
    LDX   $0AB6              ; $B82E: AE B6 0A
    ASL   $60                ; $B831: 06 60   
    ROL   $61                ; $B833: 26 61   
    ROL   $62                ; $B835: 26 62   
    BCS   $B87C              ; $B837: B0 43   
    DEX                      ; $B839: CA      
    BNE   $B831              ; $B83A: D0 F5   
    CPY   #$0A               ; $B83C: C0 0A   
    BNE   $B862              ; $B83E: D0 22   
    ASL   $0AB7              ; $B840: 0E B7 0A
    ROL   $0AB8              ; $B843: 2E B8 0A
    ROL   $0AB9              ; $B846: 2E B9 0A
    BCS   $B87C              ; $B849: B0 31   
    LDA   $0AB7              ; $B84B: AD B7 0A
    ADC   $60                ; $B84E: 65 60   
    STA   $60                ; $B850: 85 60   
    LDA   $0AB8              ; $B852: AD B8 0A
    ADC   $61                ; $B855: 65 61   
    STA   $61                ; $B857: 85 61   
    LDA   $0AB9              ; $B859: AD B9 0A
    ADC   $62                ; $B85C: 65 62   
    STA   $62                ; $B85E: 85 62   
    BCS   $B87C              ; $B860: B0 1A   
    CLC                      ; $B862: 18      
    LDA   $0AB5              ; $B863: AD B5 0A
    ADC   $60                ; $B866: 65 60   
    STA   $60                ; $B868: 85 60   
    TXA                      ; $B86A: 8A      
    ADC   $61                ; $B86B: 65 61   
    STA   $61                ; $B86D: 85 61   
    TXA                      ; $B86F: 8A      
    ADC   $62                ; $B870: 65 62   
    STA   $62                ; $B872: 85 62   
    BCS   $B87C              ; $B874: B0 06   
    AND   #$F0               ; $B876: 29 F0   
    BNE   $B87C              ; $B878: D0 02   
    BEQ   $B7FF              ; $B87A: F0 83   
    SEC                      ; $B87C: 38      
    BIT   $18                ; $B87D: 24 18   
    STY   $0AB6              ; $B87F: 8C B6 0A
    PLA                      ; $B882: 68      
    TAY                      ; $B883: A8      
    PLA                      ; $B884: 68      
    TAX                      ; $B885: AA      
    LDA   $0AB4              ; $B886: AD B4 0A
    RTS                      ; $B889: 60      
; --- [DATA] ML Monitor Base Radix (16,10,8,2) & Bit-Shift Count Tables ($B88A-$B891) ---
    .BYTE $10, $0A, $08, $02, $04, $03, $03, $01 ; $B88A [IDENTIFIED_DATA] |........|
    LDA   $68                ; $B892: A5 68   
    JSR   $B8D2              ; $B894: 20 D2 B8
    TXA                      ; $B897: 8A      
    JSR   $FFD2              ; $B898: 20 D2 FF (J_BSOUT)
    LDA   $66                ; $B89B: A5 66   
    LDX   $67                ; $B89D: A6 67   
    PHA                      ; $B89F: 48      
    TXA                      ; $B8A0: 8A      
    JSR   $B8C2              ; $B8A1: 20 C2 B8
    PLA                      ; $B8A4: 68      
    JSR   $B8C2              ; $B8A5: 20 C2 B8
    LDA   #$20               ; $B8A8: A9 20   
    JMP   $FFD2              ; $B8AA: 4C D2 FF (J_BSOUT)
    JSR   $FF7D              ; $B8AD: 20 7D FF (J_PRIMM)
    ORA.W $0091              ; $B8B0: 0D 91 00
    RTS                      ; $B8B3: 60      
    LDA   #$0D               ; $B8B4: A9 0D   
    JMP   $FFD2              ; $B8B6: 4C D2 FF (J_BSOUT)
    JSR   $FF7D              ; $B8B9: 20 7D FF (J_PRIMM)
    ORA   $511B              ; $B8BC: 0D 1B 51
    JSR   $6000              ; $B8BF: 20 00 60
    STX   $0AAF              ; $B8C2: 8E AF 0A
    JSR   $B8D2              ; $B8C5: 20 D2 B8
    JSR   $FFD2              ; $B8C8: 20 D2 FF (J_BSOUT)
    TXA                      ; $B8CB: 8A      
    LDX   $0AAF              ; $B8CC: AE AF 0A
    JMP   $FFD2              ; $B8CF: 4C D2 FF (J_BSOUT)
    PHA                      ; $B8D2: 48      
    JSR   $B8DC              ; $B8D3: 20 DC B8
    TAX                      ; $B8D6: AA      
    PLA                      ; $B8D7: 68      
    LSR   A                  ; $B8D8: 4A      
    LSR   A                  ; $B8D9: 4A      
    LSR   A                  ; $B8DA: 4A      
    LSR   A                  ; $B8DB: 4A      
    AND   #$0F               ; $B8DC: 29 0F   
    CMP   #$0A               ; $B8DE: C9 0A   
    BCC   $B8E4              ; $B8E0: 90 02   
    ADC   #$06               ; $B8E2: 69 06   
    ADC   #$30               ; $B8E4: 69 30   
    RTS                      ; $B8E6: 60      
    DEC   $7A                ; $B8E7: C6 7A   
    STX   $0AAF              ; $B8E9: 8E AF 0A
    LDX   $7A                ; $B8EC: A6 7A   
    LDA   $0200,X            ; $B8EE: BD 00 02
    BEQ   $B8F9              ; $B8F1: F0 06   
    CMP   #$3A               ; $B8F3: C9 3A   
    BEQ   $B8F9              ; $B8F5: F0 02   
    CMP   #$3F               ; $B8F7: C9 3F   
    PHP                      ; $B8F9: 08      
    INC   $7A                ; $B8FA: E6 7A   
    LDX   $0AAF              ; $B8FC: AE AF 0A
    PLP                      ; $B8FF: 28      
    RTS                      ; $B900: 60      
    LDA   $60                ; $B901: A5 60   
    STA   $66                ; $B903: 85 66   
    LDA   $61                ; $B905: A5 61   
    STA   $67                ; $B907: 85 67   
    LDA   $62                ; $B909: A5 62   
    STA   $68                ; $B90B: 85 68   
    RTS                      ; $B90D: 60      
    SEC                      ; $B90E: 38      
    LDA   $60                ; $B90F: A5 60   
    SBC   $66                ; $B911: E5 66   
    STA   $60                ; $B913: 85 60   
    LDA   $61                ; $B915: A5 61   
    SBC   $67                ; $B917: E5 67   
    STA   $61                ; $B919: 85 61   
    LDA   $62                ; $B91B: A5 62   
    SBC   $68                ; $B91D: E5 68   
    STA   $62                ; $B91F: 85 62   
    RTS                      ; $B921: 60      
    LDA   #$01               ; $B922: A9 01   
    STA   $0AAF              ; $B924: 8D AF 0A
    SEC                      ; $B927: 38      
    LDA   $60                ; $B928: A5 60   
    SBC   $0AAF              ; $B92A: ED AF 0A
    STA   $60                ; $B92D: 85 60   
    LDA   $61                ; $B92F: A5 61   
    SBC   #$00               ; $B931: E9 00   
    STA   $61                ; $B933: 85 61   
    LDA   $62                ; $B935: A5 62   
    SBC   #$00               ; $B937: E9 00   
    STA   $62                ; $B939: 85 62   
    RTS                      ; $B93B: 60      
    SEC                      ; $B93C: 38      
    LDA   $63                ; $B93D: A5 63   
    SBC   #$01               ; $B93F: E9 01   
    STA   $63                ; $B941: 85 63   
    LDA   $64                ; $B943: A5 64   
    SBC   #$00               ; $B945: E9 00   
    STA   $64                ; $B947: 85 64   
    LDA   $65                ; $B949: A5 65   
    SBC   #$00               ; $B94B: E9 00   
    STA   $65                ; $B94D: 85 65   
    RTS                      ; $B94F: 60      
    LDA   #$01               ; $B950: A9 01   
    CLC                      ; $B952: 18      
    ADC   $66                ; $B953: 65 66   
    STA   $66                ; $B955: 85 66   
    BCC   $B95F              ; $B957: 90 06   
    INC   $67                ; $B959: E6 67   
    BNE   $B95F              ; $B95B: D0 02   
    INC   $68                ; $B95D: E6 68   
    RTS                      ; $B95F: 60      
    SEC                      ; $B960: 38      
    LDA   $66                ; $B961: A5 66   
    SBC   #$01               ; $B963: E9 01   
    STA   $66                ; $B965: 85 66   
    LDA   $67                ; $B967: A5 67   
    SBC   #$00               ; $B969: E9 00   
    STA   $67                ; $B96B: 85 67   
    LDA   $68                ; $B96D: A5 68   
    SBC   #$00               ; $B96F: E9 00   
    STA   $68                ; $B971: 85 68   
    RTS                      ; $B973: 60      
    BCS   $B982              ; $B974: B0 0C   
    LDA   $60                ; $B976: A5 60   
    LDY   $61                ; $B978: A4 61   
    LDX   $62                ; $B97A: A6 62   
    STA   $04                ; $B97C: 85 04   
    STY   $03                ; $B97E: 84 03   
    STX   $02                ; $B980: 86 02   
    RTS                      ; $B982: 60      
    BCS   $B9AF              ; $B983: B0 2A   
    JSR   $B901              ; $B985: 20 01 B9
    JSR   $B7A7              ; $B988: 20 A7 B7
    BCS   $B9AF              ; $B98B: B0 22   
    LDA   $60                ; $B98D: A5 60   
    STA   $0AB7              ; $B98F: 8D B7 0A
    LDA   $61                ; $B992: A5 61   
    STA   $0AB8              ; $B994: 8D B8 0A
    LDA   $62                ; $B997: A5 62   
    STA   $0AB9              ; $B999: 8D B9 0A
    JSR   $B90E              ; $B99C: 20 0E B9
    LDA   $60                ; $B99F: A5 60   
    STA   $63                ; $B9A1: 85 63   
    LDA   $61                ; $B9A3: A5 61   
    STA   $64                ; $B9A5: 85 64   
    LDA   $62                ; $B9A7: A5 62   
    STA   $65                ; $B9A9: 85 65   
    BCC   $B9AF              ; $B9AB: 90 02   
    CLC                      ; $B9AD: 18      
    BIT   $38                ; $B9AE: 24 38   
    RTS                      ; $B9B0: 60      
MON_BASE_CONVERT:
    JSR   $B7A5              ; $B9B1: 20 A5 B7 (MON_NUM_PARSER)
    JSR   $B8B9              ; $B9B4: 20 B9 B8
    LDA   #$24               ; $B9B7: A9 24   
    JSR   $FFD2              ; $B9B9: 20 D2 FF (J_BSOUT)
    LDA   $62                ; $B9BC: A5 62   
    BEQ   $B9C7              ; $B9BE: F0 07   
    JSR   $B8D2              ; $B9C0: 20 D2 B8
    TXA                      ; $B9C3: 8A      
    JSR   $FFD2              ; $B9C4: 20 D2 FF (J_BSOUT)
    LDA   $60                ; $B9C7: A5 60   
    LDX   $61                ; $B9C9: A6 61   
    JSR   $B89F              ; $B9CB: 20 9F B8
    JSR   $B8B9              ; $B9CE: 20 B9 B8
    LDA   #$2B               ; $B9D1: A9 2B   
    JSR   $FFD2              ; $B9D3: 20 D2 FF (J_BSOUT)
    JSR   $BA07              ; $B9D6: 20 07 BA
    LDA   #$00               ; $B9D9: A9 00   
    LDX   #$08               ; $B9DB: A2 08   
    LDY   #$03               ; $B9DD: A0 03   
    JSR   $BA5D              ; $B9DF: 20 5D BA
    JSR   $B8B9              ; $B9E2: 20 B9 B8
    LDA   #$26               ; $B9E5: A9 26   
    JSR   $FFD2              ; $B9E7: 20 D2 FF (J_BSOUT)
    LDA   #$00               ; $B9EA: A9 00   
    LDX   #$08               ; $B9EC: A2 08   
    LDY   #$02               ; $B9EE: A0 02   
    JSR   $BA47              ; $B9F0: 20 47 BA
    JSR   $B8B9              ; $B9F3: 20 B9 B8
    LDA   #$25               ; $B9F6: A9 25   
    JSR   $FFD2              ; $B9F8: 20 D2 FF (J_BSOUT)
    LDA   #$00               ; $B9FB: A9 00   
    LDX   #$18               ; $B9FD: A2 18   
    LDY   #$00               ; $B9FF: A0 00   
    JSR   $BA47              ; $BA01: 20 47 BA
    JMP   $B08B              ; $BA04: 4C 8B B0 (MON_MAIN_LOOP)
    JSR   $B901              ; $BA07: 20 01 B9
    LDA   #$00               ; $BA0A: A9 00   
    LDX   #$07               ; $BA0C: A2 07   
    STA   $0AA0,X            ; $BA0E: 9D A0 0A
    DEX                      ; $BA11: CA      
    BPL   $BA0E              ; $BA12: 10 FA   
    INC   $0AA7              ; $BA14: EE A7 0A
    LDY   #$17               ; $BA17: A0 17   
    PHP                      ; $BA19: 08      
    SEI                      ; $BA1A: 78      
    SED                      ; $BA1B: F8      
    LSR   $68                ; $BA1C: 46 68   
    ROR   $67                ; $BA1E: 66 67   
    ROR   $66                ; $BA20: 66 66   
    BCC   $BA33              ; $BA22: 90 0F   
    CLC                      ; $BA24: 18      
    LDX   #$03               ; $BA25: A2 03   
    LDA   $0AA4,X            ; $BA27: BD A4 0A
    ADC   $0AA0,X            ; $BA2A: 7D A0 0A
    STA   $0AA0,X            ; $BA2D: 9D A0 0A
    DEX                      ; $BA30: CA      
    BPL   $BA27              ; $BA31: 10 F4   
    CLC                      ; $BA33: 18      
    LDX   #$03               ; $BA34: A2 03   
    LDA   $0AA4,X            ; $BA36: BD A4 0A
    ADC   $0AA4,X            ; $BA39: 7D A4 0A
    STA   $0AA4,X            ; $BA3C: 9D A4 0A
    DEX                      ; $BA3F: CA      
    BPL   $BA36              ; $BA40: 10 F4   
    DEY                      ; $BA42: 88      
    BPL   $BA1C              ; $BA43: 10 D7   
    PLP                      ; $BA45: 28      
    RTS                      ; $BA46: 60      
    PHA                      ; $BA47: 48      
    LDA   $60                ; $BA48: A5 60   
    STA   $0AA2              ; $BA4A: 8D A2 0A
    LDA   $61                ; $BA4D: A5 61   
    STA   $0AA1              ; $BA4F: 8D A1 0A
    LDA   $62                ; $BA52: A5 62   
    STA   $0AA0              ; $BA54: 8D A0 0A
    LDA   #$00               ; $BA57: A9 00   
    STA   $0AA3              ; $BA59: 8D A3 0A
    PLA                      ; $BA5C: 68      
    STA   $0AB4              ; $BA5D: 8D B4 0A
    STY   $0AB6              ; $BA60: 8C B6 0A
    LDY   $0AB6              ; $BA63: AC B6 0A
    LDA   #$00               ; $BA66: A9 00   
    ASL   $0AA3              ; $BA68: 0E A3 0A
    ROL   $0AA2              ; $BA6B: 2E A2 0A
    ROL   $0AA1              ; $BA6E: 2E A1 0A
    ROL   $0AA0              ; $BA71: 2E A0 0A
    ROL   A                  ; $BA74: 2A      
    DEY                      ; $BA75: 88      
    BPL   $BA68              ; $BA76: 10 F0   
    TAY                      ; $BA78: A8      
    BNE   $BA84              ; $BA79: D0 09   
    CPX   #$01               ; $BA7B: E0 01   
    BEQ   $BA84              ; $BA7D: F0 05   
    LDY   $0AB4              ; $BA7F: AC B4 0A
    BEQ   $BA8C              ; $BA82: F0 08   
    INC   $0AB4              ; $BA84: EE B4 0A
    ORA   #$30               ; $BA87: 09 30   
    JSR   $FFD2              ; $BA89: 20 D2 FF (J_BSOUT)
    DEX                      ; $BA8C: CA      
    BNE   $BA63              ; $BA8D: D0 D4   
    RTS                      ; $BA8F: 60      
MON_DISK_CMD:
    BNE   $BA95              ; $BA90: D0 03   
    LDX   #$08               ; $BA92: A2 08   
    BIT   $60A6              ; $BA94: 2C A6 60
    CPX   #$04               ; $BA97: E0 04   
    BCC   $BB00              ; $BA99: 90 65   
    CPX   #$1F               ; $BA9B: E0 1F   
    BCS   $BB00              ; $BA9D: B0 61   
    STX   $60                ; $BA9F: 86 60   
    LDA   #$00               ; $BAA1: A9 00   
    STA   $62                ; $BAA3: 85 62   
    STA   $B7                ; $BAA5: 85 B7   
    TAX                      ; $BAA7: AA      
    JSR   $FF68              ; $BAA8: 20 68 FF (J_SETBNK)
    JSR   $B8E9              ; $BAAB: 20 E9 B8
    DEC   $7A                ; $BAAE: C6 7A   
    CMP   #$24               ; $BAB0: C9 24   
    BEQ   $BB03              ; $BAB2: F0 4F   
    LDA   #$00               ; $BAB4: A9 00   
    LDX   $60                ; $BAB6: A6 60   
    LDY   #$0F               ; $BAB8: A0 0F   
    JSR   $FFBA              ; $BABA: 20 BA FF (J_SETLFS)
    JSR   $FFC0              ; $BABD: 20 C0 FF (J_OPEN)
    BCS   $BAF4              ; $BAC0: B0 32   
    LDX   #$00               ; $BAC2: A2 00   
    JSR   $FFC9              ; $BAC4: 20 C9 FF (J_CHKOUT)
    BCS   $BAF4              ; $BAC7: B0 2B   
    LDX   $7A                ; $BAC9: A6 7A   
    INC   $7A                ; $BACB: E6 7A   
    LDA   $0200,X            ; $BACD: BD 00 02
    BEQ   $BAD7              ; $BAD0: F0 05   
    JSR   $FFD2              ; $BAD2: 20 D2 FF (J_BSOUT)
    BCC   $BAC9              ; $BAD5: 90 F2   
    JSR   $FFCC              ; $BAD7: 20 CC FF (J_CLRCH)
    JSR   $B8B4              ; $BADA: 20 B4 B8
    LDX   #$00               ; $BADD: A2 00   
    JSR   $FFC6              ; $BADF: 20 C6 FF (J_CHKIN)
    BCS   $BAF4              ; $BAE2: B0 10   
    JSR   $FFCF              ; $BAE4: 20 CF FF (J_BASIN)
    JSR   $FFD2              ; $BAE7: 20 D2 FF (J_BSOUT)
    CMP   #$0D               ; $BAEA: C9 0D   
    BEQ   $BAF4              ; $BAEC: F0 06   
    LDA   $90                ; $BAEE: A5 90   
    AND   #$BF               ; $BAF0: 29 BF   
    BEQ   $BAE4              ; $BAF2: F0 F0   
    JSR   $FFCC              ; $BAF4: 20 CC FF (J_CLRCH)
    LDA   #$00               ; $BAF7: A9 00   
    SEC                      ; $BAF9: 38      
    JSR   $FFC3              ; $BAFA: 20 C3 FF (J_CLOSE)
    JMP   $B08B              ; $BAFD: 4C 8B B0 (MON_MAIN_LOOP)
    JMP   $B0BC              ; $BB00: 4C BC B0
    LDY   #$FF               ; $BB03: A0 FF   
    LDX   $7A                ; $BB05: A6 7A   
    DEX                      ; $BB07: CA      
    INY                      ; $BB08: C8      
    INX                      ; $BB09: E8      
    LDA   $0200,X            ; $BB0A: BD 00 02
    BNE   $BB08              ; $BB0D: D0 F9   
    TYA                      ; $BB0F: 98      
    LDX   $7A                ; $BB10: A6 7A   
    LDY   #$02               ; $BB12: A0 02   
    JSR   $FFBD              ; $BB14: 20 BD FF (J_SETNAM)
    LDA   #$00               ; $BB17: A9 00   
    LDX   $60                ; $BB19: A6 60   
    LDY   #$60               ; $BB1B: A0 60   
    JSR   $FFBA              ; $BB1D: 20 BA FF (J_SETLFS)
    JSR   $FFC0              ; $BB20: 20 C0 FF (J_OPEN)
    BCS   $BAF4              ; $BB23: B0 CF   
    LDX   #$00               ; $BB25: A2 00   
    JSR   $FFC6              ; $BB27: 20 C6 FF (J_CHKIN)
    JSR   $B8B4              ; $BB2A: 20 B4 B8
    LDY   #$03               ; $BB2D: A0 03   
    STY   $63                ; $BB2F: 84 63   
    JSR   $FFCF              ; $BB31: 20 CF FF (J_BASIN)
    STA   $60                ; $BB34: 85 60   
    LDA   $90                ; $BB36: A5 90   
    BNE   $BAF4              ; $BB38: D0 BA   
    JSR   $FFCF              ; $BB3A: 20 CF FF (J_BASIN)
    STA   $61                ; $BB3D: 85 61   
    LDA   $90                ; $BB3F: A5 90   
    BNE   $BAF4              ; $BB41: D0 B1   
    DEC   $63                ; $BB43: C6 63   
    BNE   $BB31              ; $BB45: D0 EA   
    JSR   $BA07              ; $BB47: 20 07 BA
    LDA   #$00               ; $BB4A: A9 00   
    LDX   #$08               ; $BB4C: A2 08   
    LDY   #$03               ; $BB4E: A0 03   
    JSR   $BA5D              ; $BB50: 20 5D BA
    LDA   #$20               ; $BB53: A9 20   
    JSR   $FFD2              ; $BB55: 20 D2 FF (J_BSOUT)
    JSR   $FFCF              ; $BB58: 20 CF FF (J_BASIN)
    BEQ   $BB66              ; $BB5B: F0 09   
    LDX   $90                ; $BB5D: A6 90   
    BNE   $BAF4              ; $BB5F: D0 93   
    JSR   $FFD2              ; $BB61: 20 D2 FF (J_BSOUT)
    BCC   $BB58              ; $BB64: 90 F2   
    JSR   $B8B4              ; $BB66: 20 B4 B8
    JSR   $FFE1              ; $BB69: 20 E1 FF (J_STOP)
    BEQ   $BAF4              ; $BB6C: F0 86   
    LDY   #$02               ; $BB6E: A0 02   
    BNE   $BB2F              ; $BB70: D0 BD   
; --- [PADDING] Unused ROM Padding Block 3 ($FF, 1164 bytes) ($BB72-$BFFD) ---
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BB72 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BB7A [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BB82 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BB8A [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BB92 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BB9A [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BBA2 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BBAA [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BBB2 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BBBA [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BBC2 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BBCA [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BBD2 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BBDA [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BBE2 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BBEA [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BBF2 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BBFA [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BC02 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BC0A [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BC12 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BC1A [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BC22 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BC2A [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BC32 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BC3A [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BC42 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BC4A [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BC52 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BC5A [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BC62 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BC6A [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BC72 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BC7A [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BC82 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BC8A [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BC92 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BC9A [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BCA2 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BCAA [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BCB2 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BCBA [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BCC2 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BCCA [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BCD2 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BCDA [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BCE2 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BCEA [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BCF2 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BCFA [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BD02 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BD0A [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BD12 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BD1A [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BD22 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BD2A [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BD32 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BD3A [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BD42 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BD4A [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BD52 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BD5A [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BD62 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BD6A [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BD72 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BD7A [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BD82 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BD8A [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BD92 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BD9A [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BDA2 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BDAA [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BDB2 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BDBA [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BDC2 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BDCA [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BDD2 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BDDA [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BDE2 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BDEA [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BDF2 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BDFA [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BE02 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BE0A [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BE12 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BE1A [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BE22 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BE2A [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BE32 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BE3A [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BE42 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BE4A [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BE52 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BE5A [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BE62 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BE6A [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BE72 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BE7A [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BE82 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BE8A [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BE92 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BE9A [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BEA2 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BEAA [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BEB2 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BEBA [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BEC2 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BECA [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BED2 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BEDA [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BEE2 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BEEA [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BEF2 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BEFA [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BF02 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BF0A [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BF12 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BF1A [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BF22 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BF2A [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BF32 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BF3A [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BF42 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BF4A [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BF52 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BF5A [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BF62 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BF6A [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BF72 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BF7A [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BF82 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BF8A [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BF92 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BF9A [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BFA2 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BFAA [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BFB2 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BFBA [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BFC2 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BFCA [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BFD2 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BFDA [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BFE2 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BFEA [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; $BFF2 [PADDING] |........|
    .BYTE $FF, $FF, $FF, $FF                     ; $BFFA [PADDING] |....|
; --- [DATA] ROM Revision and Checksum Trailer ($BFFE-$BFFF) ---
    .BYTE $00, $3A                               ; $BFFE [IDENTIFIED_DATA] |.:|
