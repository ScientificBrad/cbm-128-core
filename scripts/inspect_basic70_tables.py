#!/usr/bin/env python3
"""
Phase 5 Part 3: Decode all BASIC 7.0 Token Tables ($4417-$4700),
Statement Dispatch Tables ($46FC-$47D7), Function Dispatch Tables ($47D8-$4827),
Operator Precedence & Vector Table ($4828-$484A), Error Message Table ($484B-$4A84),
and disassemble FRMEVL ($77EF+), PTRGET ($7B00+), and ML Monitor ($B000-$BFFF).
"""
from pathlib import Path
import json
import struct
import sys

ROOT = Path(r"D:\Emulation\C128")
sys.path.insert(0, str(ROOT / "scripts"))
from inspect_basic70 import read_rom_byte, read_rom_slice, disasm_range

def extract_highbit_strings(start_addr, end_addr):
    items = []
    addr = start_addr
    idx = 0
    while addr <= end_addr:
        b0 = read_rom_byte(addr)
        if b0 == 0x00 and addr >= end_addr - 1:
            break
        s_addr = addr
        chars = []
        while addr <= end_addr:
            b = read_rom_byte(addr)
            addr += 1
            chars.append(chr(b & 0x7F))
            if b & 0x80:
                break
        items.append({
            "index": idx,
            "addr": f"${s_addr:04X}",
            "text": "".join(chars)
        })
        idx += 1
    return items

def decode_all_basic_tables():
    # 1. Primary tokens ($4417-$4607, terminated by $00 at $4608)
    # Wait: let's check token codes!
    # In $43E2: index $0D starts at 0, and at $4412: ORA #$80 -> token = $80 + index!
    t1 = extract_highbit_strings(0x4417, 0x4607)
    for item in t1:
        item["token_byte"] = f"${0x80 + item['index']:02X}"
        item["token_int"] = 0x80 + item["index"]

    # 2. What is at $4609-$46C8 vs $46C9-$4700?
    # Look at Crunch ($4356-$4372) and List ($518C-$51BE):
    # At $4356: A=$46, Y=$09 -> searches table at $4609!
    # If matched: LDA #$81; LDX #$00 -> at $43B0: ADC $0D (Carry=1 -> $82 + index? Wait: at $4412, $0D had ORA #$80, so $81 + ($80 + idx) + C(1) = $02 + idx!).
    # And at $43B7: LDA #$FE; INX; BNE $43BE -> since X=0, INX makes X=1 (NZ), so it keeps A=$FE!
    # WAIT A SECOND!
    # Look closely at $4356-$43C4 and $518C-$51BE!
    # At $4356: searches $4609 (`A=$46, Y=$09`). If found, sets `X=$00`, and at `$43B7`:
    #   `LDA #$FE; INX; BNE $43BE; LDA #$CE`
    # When `X=$00` (from `$4609`), `INX` makes `X=$01` (`BNE $43BE` is TAKEN!), so `$4609` is the **`$FE`-prefixed statement table** (`$FE $02` .. `$FE $26`)!
    # And when `X=$FF` (from `$46C9` at `$4365`), `INX` makes `X=$00` (`BNE $43BE` is NOT taken!), so it executes `LDA #$CE` — meaning `$46C9` is the **`$CE`-prefixed function table** (`$CE $02` .. `$CE $0A`)!
    # Let's verify that in $518C-$51BE (LIST detokenizer):
    #   $515B: CMP #$FE; BEQ $518C -> at $518C: checks $02 <= byte < $27, loads Y=$09, A=$46 ($4609)!
    #   $515F: CMP #$CE; BEQ $51A6 -> at $51A6: checks $02 <= byte < $0B, loads Y=$C9, A=$46 ($46C9)!
    t_fe = extract_highbit_strings(0x4609, 0x46C7)
    for item in t_fe:
        tok2 = 0x02 + item["index"]
        item["prefix_byte"] = "$FE"
        item["sub_token"] = f"${tok2:02X}"
        item["full_token"] = f"$FE ${tok2:02X}"

    t_ce = extract_highbit_strings(0x46C9, 0x46FE)
    for item in t_ce:
        tok2 = 0x02 + item["index"]
        item["prefix_byte"] = "$CE"
        item["sub_token"] = f"${tok2:02X}"
        item["full_token"] = f"$CE ${tok2:02X}"

    print(f"Primary tokens ($4417): {len(t1)} (tokens $80..${0x80+len(t1)-1:02X})")
    print(f"$FE-prefixed tokens ($4609): {len(t_fe)} ($FE $02..$FE ${0x02+len(t_fe)-1:02X})")
    for x in t_fe:
        print(f"  {x['full_token']} @ {x['addr']}: {x['text']}")
    print(f"$CE-prefixed tokens ($46C9): {len(t_ce)} ($CE $02..$CE ${0x02+len(t_ce)-1:02X})")
    for x in t_ce:
        print(f"  {x['full_token']} @ {x['addr']}: {x['text']}")

    # Now let's decode the dispatch tables at $46FC-$484A!
    print("\n=== STATEMENT DISPATCH TABLE ($46FC-$47D7) ===")
    # Look at $4B68-$4BA3:
    # For single-byte statement tokens:
    #   - Tokens $80..$A2 (END..NEW): A - $80 -> index 0..34 ($00..$22), Y = index * 2, read from $46FC,Y (RTS-1)!
    #   - Wait: what about tokens >= $D5?
    #     Look at $4B68:
    #       CMP #$FB; BCS $4BAB (syntax error if >= $FB)
    #       CMP #$A3; BCC $4B76 (if $80..$A2, skip to SBC #$80)
    #       CMP #$D5; BCC $4BAB (if $A3..$D4, syntax error as a statement because $A3..$D4 are TAB(/TO/FN/SPC(/THEN/NOT/STEP, operators, and functions!)
    #       SBC #$32  (Carry is 1, so A = token - $32! For token $D5, $D5 - $32 = $A3!)
    #       SEC; SBC #$80 (so token $D5 becomes $A3 - $80 = $23 = 35!)
    #   - And what about $FE-prefixed tokens ($02..$26)?
    #     Look at $4B94:
    #       CMP #$02; BCC $4BA5
    #       CMP #$27; BCS $4BA5
    #       ADC #$47  (Carry is 0 because CMP #$27 was BCC! So $02 + $47 = $49 = 73!)
    #       BNE $4B7E (ASL A; TAY; LDA $46FD,Y; PHA; LDA $46FC,Y; PHA; JMP $0380)
    # Let's verify every single entry in $46FC-$47D7!
    tok_name_by_byte = {item["token_int"]: item["text"] for item in t1}
    fe_name_by_sub = {0x02 + item["index"]: item["text"] for item in t_fe}
    ce_name_by_sub = {0x02 + item["index"]: item["text"] for item in t_ce}

    for idx in range(0, 110):
        table_addr = 0x46FC + idx * 2
        if table_addr >= 0x47D8:
            break
        vec_m1 = read_rom_byte(table_addr) | (read_rom_byte(table_addr + 1) << 8)
        target = (vec_m1 + 1) & 0xFFFF
        if idx <= 0x22:
            tok = 0x80 + idx
            name = tok_name_by_byte.get(tok, f"TOK_${tok:02X}")
            tok_str = f"${tok:02X}"
        elif idx <= 0x48:
            tok = 0x80 + idx + 0x32  # $D5..$FA
            name = tok_name_by_byte.get(tok, f"TOK_${tok:02X}")
            tok_str = f"${tok:02X}"
        else:
            sub = idx - 0x47  # $02..$26
            name = fe_name_by_sub.get(sub, f"FE_${sub:02X}")
            tok_str = f"$FE ${sub:02X}"
        print(f"  Idx {idx:3d} (${table_addr:04X}): Token {tok_str:<8} {name:<10} -> ${target:04X} (word ${vec_m1:04X})")

    print("\n=== FUNCTION DISPATCH TABLE ($47D8-$4827) ===")
    # Look at $4C3F:
    #   SEC; SBC #$B4; ASL A; TAY; LDA $47D9,Y; STA $58; LDA $47D8,Y; STA $57; JSR $0056 (`JMP ($0057)`)!
    # Notice that $47D8 stores ACTUAL 16-bit addresses (called via `JMP ($0057)` at `$0056`), NOT address-1!
    # Single-byte functions: tokens $B4..$D4 (`SGN`..`MID$`, 33 functions, indices 0..32)
    # `$CE`-prefixed functions: at $4C68:
    #   CMP #$02; BCC; CMP #$0B; BCS; ADC #$D1 (Carry=0, so sub_token $02 + $D1 = $D3; wait: at $4C59, CMP #$0A BEQ $4C68, and for $02..$09, it evaluates the `(expr)` argument FIRST at $4C61-$4C64, whereas for $0A (`POINTER`), it skips `JSR $7959; JSR $77EF` and jumps straight to $4C68! And at $4C70: `ADC #$D1` (with C=0) -> `$02 + $D1 = $D3`? Wait: $D5 - $B4 = 33! Wait: when `CMP #$0B` branches `BCC`, Carry is 0, wait: why `ADC #$D1`? Let's check: `$02 + $D1 = $D3`? No! `$B4 + 33 = $D5`, and `$D5 - $02 = $D3`? Wait: why did ROM have `69 D1` (`ADC #$D1`) at `$4C70`? Let's check what is at `$47D8`!)
    for idx in range(0, 42):
        table_addr = 0x47D8 + idx * 2
        if table_addr >= 0x4828:
            break
        target = read_rom_byte(table_addr) | (read_rom_byte(table_addr + 1) << 8)
        if idx <= 32:
            tok = 0xB4 + idx
            name = tok_name_by_byte.get(tok, f"FN_${tok:02X}")
            tok_str = f"${tok:02X}"
        else:
            # Wait: let's see which $CE token maps to which index!
            sub = idx - 31  # if idx 33 -> sub $02
            name = ce_name_by_sub.get(sub, f"CE_${sub:02X}")
            tok_str = f"$CE ${sub:02X}"
        print(f"  FnIdx {idx:2d} (${table_addr:04X}): Token {tok_str:<8} {name:<10} -> ${target:04X}")

    print("\n=== OPERATOR PRECEDENCE & DISPATCH TABLE ($4828-$484A) ===")
    for off in range(0x4828, 0x484B, 3):
        prec = read_rom_byte(off)
        vec_m1 = read_rom_byte(off + 1) | (read_rom_byte(off + 2) << 8)
        target = (vec_m1 + 1) & 0xFFFF
        op_idx = (off - 0x4828) // 3
        tok = 0xAA + op_idx
        name = tok_name_by_byte.get(tok, f"OP_${tok:02X}")
        print(f"  OpIdx {op_idx:2d} (${off:04X}): Token ${tok:02X} {name:<6} Precedence=${prec:02X} -> ${target:04X} (word ${vec_m1:04X})")

if __name__ == "__main__":
    decode_all_basic_tables()
