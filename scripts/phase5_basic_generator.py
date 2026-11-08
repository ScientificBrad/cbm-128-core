"""Generate Phase 5 machine-readable deliverables:
- reports/basic_tokens.json
- reports/basic_functions.csv
"""
import csv
import json
import sys
from pathlib import Path

ROOT = Path(r"D:\Emulation\C128")
sys.path.insert(0, str(ROOT / "scripts"))
from inspect_basic70 import read_rom_byte
from inspect_basic70_tables import extract_highbit_strings


def get_word(addr):
    return read_rom_byte(addr) | (read_rom_byte(addr + 1) << 8)


def build_tokens_json():
    # 1. Primary tokens ($4417-$4607, 126 entries, $80..$FD)
    t_primary = extract_highbit_strings(0x4417, 0x4607)
    primary_list = []

    # 2. $FE-prefixed statement tokens ($4609-$46C7, 37 entries, $FE $02..$FE $26)
    t_fe = extract_highbit_strings(0x4609, 0x46C7)
    fe_list = []

    # 3. $CE-prefixed function tokens ($46C9-$46F8, 9 entries, $CE $02..$CE $0A)
    t_ce = extract_highbit_strings(0x46C9, 0x46F8)
    ce_list = []

    # Map primary tokens
    for item in t_primary:
        idx = item["index"]
        tok = 0x80 + idx
        kw = item["text"]
        entry = {
            "token_hex": f"${tok:02X}",
            "token_dec": tok,
            "keyword": kw,
            "table_addr": item["addr"],
        }
        if 0x80 <= tok <= 0xA2:
            disp_idx = tok - 0x80
            vec_addr = 0x46FC + disp_idx * 2
            vec_m1 = get_word(vec_addr)
            target = (vec_m1 + 1) & 0xFFFF
            entry["category"] = "statement_primary"
            entry["dispatch_table_addr"] = f"${vec_addr:04X}"
            entry["handler_addr"] = f"${target:04X}"
        elif 0xA3 <= tok <= 0xA9:
            entry["category"] = "auxiliary_keyword"
            aux_handlers = {
                0xA3: "$55B9 (PRINT TAB() handler)",
                0xA4: "$577D (FOR..TO / DRAW..TO)",
                0xA5: "$7CD1 (FN user function evaluator)",
                0xA6: "$55B9 (PRINT SPC() handler)",
                0xA7: "$59A7 (IF..THEN handler)",
                0xA8: "$8484 (NOT logical negation)",
                0xA9: "$578A (FOR..STEP / graphic STEP)",
            }
            entry["handler_addr"] = aux_handlers.get(tok, "inline")
        elif 0xAA <= tok <= 0xB3:
            entry["category"] = "operator"
            if 0xAA <= tok <= 0xB0:
                op_idx = tok - 0xAA
                op_addr = 0x4828 + op_idx * 3
                prec = read_rom_byte(op_addr)
                vec_m1 = get_word(op_addr + 1)
                target = (vec_m1 + 1) & 0xFFFF
                entry["precedence"] = f"${prec:02X}"
                entry["dispatch_table_addr"] = f"${op_addr:04X}"
                entry["handler_addr"] = f"${target:04X}"
            else:
                # >, =, < relational operators ($B1, $B2, $B3)
                entry["precedence"] = "$64"
                entry["dispatch_table_addr"] = "$4843"
                entry["handler_addr"] = "$4CB6 (relational) / $5848 (LET=)"
        elif 0xB4 <= tok <= 0xD4:
            fn_idx = tok - 0xB4
            vec_addr = 0x47D8 + fn_idx * 2
            target = get_word(vec_addr)
            if tok == 0xCD:  # RCLR intercepted at $4BF7 -> $81D7
                entry["category"] = "function_primary"
                entry["dispatch_table_addr"] = f"${vec_addr:04X} (intercepted at $4BF7)"
                entry["handler_addr"] = "$81D7"
            elif tok == 0xCE:  # $CE prefix placeholder
                entry["category"] = "prefix_placeholder"
                entry["dispatch_table_addr"] = f"${vec_addr:04X} (intercepted at $4BF3 -> $4C54)"
                entry["handler_addr"] = "$4C54"
            else:
                entry["category"] = "function_primary"
                entry["dispatch_table_addr"] = f"${vec_addr:04X}"
                entry["handler_addr"] = f"${target:04X}"
        elif 0xD5 <= tok <= 0xFA:
            disp_idx = tok - 0x32 - 0x80  # 35..72
            vec_addr = 0x46FC + disp_idx * 2
            vec_m1 = get_word(vec_addr)
            target = (vec_m1 + 1) & 0xFFFF
            entry["category"] = "statement_extended_single_byte"
            entry["dispatch_table_addr"] = f"${vec_addr:04X}"
            entry["handler_addr"] = f"${target:04X}"
        else:
            # $FB (USING), $FC (UNTIL), $FD (WHILE)
            entry["category"] = "clause_keyword"
            clause_handlers = {
                0xFB: "$555C -> $9520 (PRINT USING)",
                0xFC: "$5FF6 / $608C (DO / LOOP UNTIL)",
                0xFD: "$5FF6 / $608C (DO / LOOP WHILE)",
            }
            entry["handler_addr"] = clause_handlers.get(tok, "inline")
        primary_list.append(entry)

    # Map $FE-prefixed statement tokens ($FE $02..$FE $26)
    for item in t_fe:
        sub = 0x02 + item["index"]
        disp_idx = sub + 0x47  # 73..109
        vec_addr = 0x46FC + disp_idx * 2
        vec_m1 = get_word(vec_addr)
        target = (vec_m1 + 1) & 0xFFFF
        fe_list.append({
            "token_hex": f"$FE ${sub:02X}",
            "prefix_byte": "$FE",
            "sub_token_hex": f"${sub:02X}",
            "sub_token_dec": sub,
            "keyword": item["text"],
            "table_addr": item["addr"],
            "category": "statement_fe_prefixed" if item["text"].strip() else "reserved_fe_slot",
            "dispatch_table_addr": f"${vec_addr:04X}",
            "handler_addr": f"${target:04X}",
        })

    # Map $CE-prefixed function tokens ($CE $02..$CE $0A)
    for item in t_ce:
        sub = 0x02 + item["index"]
        # At $4C70: ADC #$D1 (with C=0), then at $4C3F: SEC; SBC #$B4 -> fn_idx = sub + $1D = sub + 29!
        fn_idx = sub + 0x1D  # 31..39
        vec_addr = 0x47D8 + fn_idx * 2
        target = get_word(vec_addr)
        ce_list.append({
            "token_hex": f"$CE ${sub:02X}",
            "prefix_byte": "$CE",
            "sub_token_hex": f"${sub:02X}",
            "sub_token_dec": sub,
            "keyword": item["text"],
            "table_addr": item["addr"],
            "category": "function_ce_prefixed",
            "dispatch_table_addr": f"${vec_addr:04X}",
            "handler_addr": f"${target:04X}",
        })

    # 4. Operator Precedence & Vector Table ($4828-$4845, 10 entries)
    op_names = [
        ("+", "$AA", "Addition / String Concatenation"),
        ("-", "$AB", "Subtraction"),
        ("*", "$AC", "Multiplication"),
        ("/", "$AD", "Division"),
        ("^", "$AE", "Exponentiation"),
        ("AND", "$AF", "Bitwise 16-bit AND"),
        ("OR", "$B0", "Bitwise 16-bit OR"),
        ("NEG", "$AB (unary)", "Unary Negation"),
        ("NOT", "$A8 (unary)", "Logical/Bitwise NOT"),
        ("REL", "$B1..$B3", "Relational Comparison (>, =, <)"),
    ]
    operators = []
    for i in range(10):
        addr = 0x4828 + i * 3
        prec = read_rom_byte(addr)
        vec_m1 = get_word(addr + 1)
        target = (vec_m1 + 1) & 0xFFFF
        sym, tok_s, desc = op_names[i]
        operators.append({
            "index": i,
            "symbol": sym,
            "token": tok_s,
            "description": desc,
            "table_addr": f"${addr:04X}",
            "precedence_hex": f"${prec:02X}",
            "precedence_dec": prec,
            "handler_addr": f"${target:04X}",
        })

    # 5. Error Message Table ($484B-$4A81, 41 messages, codes $01..$29)
    raw_errs = extract_highbit_strings(0x484B, 0x4A81)
    errors = []
    for item in raw_errs:
        code = item["index"] + 1
        errors.append({
            "error_code_dec": code,
            "error_code_hex": f"${code:02X}",
            "addr": item["addr"],
            "message": item["text"],
        })

    payload = {
        "rom_set": {
            "lower_rom": "basic-4000.318018-02.bin ($4000-$7FFF)",
            "upper_rom": "basic-8000.318019-02.bin ($8000-$BFFF)",
        },
        "summary": {
            "primary_token_count": len(primary_list),
            "fe_prefixed_statement_count": len(fe_list),
            "ce_prefixed_function_count": len(ce_list),
            "operator_table_entries": len(operators),
            "error_message_count": len(errors),
        },
        "primary_tokens": primary_list,
        "fe_prefixed_statement_tokens": fe_list,
        "ce_prefixed_function_tokens": ce_list,
        "operator_precedence_table": operators,
        "error_messages": errors,
    }

    out_json = ROOT / "reports" / "basic_tokens.json"
    out_json.write_text(json.dumps(payload, indent=2), encoding="utf-8")
    print(f"Wrote {out_json} ({len(primary_list)} primary, {len(fe_list)} $FE, {len(ce_list)} $CE, {len(errors)} errors)")
    return payload


def build_functions_csv(tokens_data):
    rows = []

    def add_fn(addr, end_addr, name, category, rom_chip, summary, confidence="CONFIRMED"):
        clean_name = "".join(c if 32 <= ord(c) < 127 else f"\\x{ord(c):02X}" for c in name)
        clean_sum = "".join(c if 32 <= ord(c) < 127 else f"\\x{ord(c):02X}" for c in summary)
        rows.append({
            "address": addr,
            "end_address": end_addr,
            "symbol": clean_name,
            "category": category,
            "rom_image": rom_chip,
            "description": clean_sum,
            "confidence": confidence,
        })

    # Core architecture, entry points, startup, tokenizer, dispatcher, runtime, math, monitor
    core_routines = [
        ("$4000", "$4002", "BASIC_COLD_ENTRY", "Entry Vector", "318018-02", "Cold start entry vector (JMP $4009)"),
        ("$4003", "$4005", "BASIC_WARM_ENTRY", "Entry Vector", "318018-02", "Warm start / NMI entry vector (JMP $4023)"),
        ("$4006", "$4008", "BASIC_IRQ_ENTRY", "Entry Vector", "318018-02", "IRQ Sprite/Sound/Collision service vector (JMP $A84D)"),
        ("$4009", "$4022", "COLD_START", "Startup", "318018-02", "BASIC 7.0 cold start sequence: JSR $4169, $4045, $419B, $4251, $4142, $4235, $4026"),
        ("$4023", "$4044", "WARM_START", "Startup", "318018-02", "BASIC 7.0 warm start sequence: CLI, init vectors, jump to READY ($4D37)"),
        ("$4045", "$4141", "INIT_VECTORS_AND_RAM", "Startup", "318018-02", "Copy $0380-$03D4 common RAM stub, init $0300-$0313 vectors, Bank 0/1 pointers ($1C01, $0400, $FF00)"),
        ("$4142", "$4168", "PRINT_STARTUP_BANNER", "Startup", "318018-02", "Print C128 BASIC V7.0 startup banner ($4107) and copyright messages"),
        ("$4169", "$419A", "INIT_MMU_PRECONFIGS", "Startup", "318018-02", "Set MMU $D501-$D504 preconfiguration registers ($3F, $7F, $01, $41) and sound/sprite state"),
        ("$419B", "$4234", "INIT_VIC_SID_GRAPHICS", "Startup", "318018-02", "Initialize VIC-II/SID shadow registers, default sprite colors, and scale factors"),
        ("$4251", "$4278", "TEST_AUTOBOOT_CART", "Startup", "318018-02", "Check for autostart disk boot or cartridge before entering READY"),
        ("$4279", "$42CD", "COMMON_RAM_TEMPLATE", "Memory Management", "318018-02", "85-byte template copied to $0380-$03D4 (CHRGET + Bank 0/Bank 1 indirect fetch routines)"),
        ("$42CE", "$4309", "BANK0_BANK1_HELPERS", "Memory Management", "318018-02", "Helpers for reading/comparing Bank 0 program text ($42D5/$42EC) and Bank 1 variables ($42E7)"),
        ("$430A", "$4416", "CRUNCH", "Tokenizer", "318018-02", "Tokenize ASCII input line in $0200 into single-byte ($80-$FD), $FE-prefixed, and $CE-prefixed tokens"),
        ("$4417", "$4608", "TOKEN_TABLE_PRIMARY", "Table", "318018-02", "Primary keyword table (126 high-bit terminated strings for tokens $80..$FD)"),
        ("$4609", "$46C8", "TOKEN_TABLE_FE", "Table", "318018-02", "$FE-prefixed extended statement keyword table (37 strings for $FE $02..$FE $26)"),
        ("$46C9", "$46F9", "TOKEN_TABLE_CE", "Table", "318018-02", "$CE-prefixed extended function keyword table (9 strings for $CE $02..$CE $0A)"),
        ("$46FC", "$47D7", "STMDSP_TABLE", "Table", "318018-02", "Statement dispatch table (110 RTS-1 vectors: $80..$A2, $D5..$FA, $FE $02..$26)"),
        ("$47D8", "$4827", "FUNDSP_TABLE", "Table", "318018-02", "Function dispatch table (40 direct 16-bit vectors: $B4..$D4 and $CE $02..$0A)"),
        ("$4828", "$4845", "OPTAB_TABLE", "Table", "318018-02", "Operator precedence & RTS-1 dispatch table (10 3-byte entries)"),
        ("$4846", "$484A", "UNIMPL_CMD_ERR", "Error Handling", "318018-02", "LDX #$28; JMP $4D3C (UNIMPLEMENTED COMMAND error for OFF/QUIT)"),
        ("$484B", "$4A81", "ERRMSG_TABLE", "Table", "318018-02", "41 high-bit terminated BASIC 7.0 error message strings (codes $01..$29)"),
        ("$4A82", "$4AA1", "FIND_ERRMSG", "Error Handling", "318018-02", "Scan $484B error message table to error index A and set pointer ($26/$27)"),
        ("$4AA2", "$4B67", "NEWSTT", "Execution Engine", "318018-02", "Statement execution loop: poll STOP, trace line ($1216), advance TXTPTR ($3D/$3E)"),
        ("$4B68", "$4BAA", "GONE", "Execution Engine", "318018-02", "Decode statement token ($80-$A2, $D5-$FA, or $FE $02-$26) and RTS-dispatch via $46FC"),
        ("$4BEF", "$4C85", "EVAL_FUNCTION", "Execution Engine", "318018-02", "Evaluate built-in ($B4-$D4) and $CE-prefixed ($CE $02-$0A) functions via $47D8"),
        ("$4C86", "$4CB5", "OP_OR_AND", "Execution Engine", "318018-02", "Bitwise 16-bit OR ($4C86) and AND ($4C89) operator evaluation"),
        ("$4CB6", "$4D2B", "OP_RELATIONAL", "Execution Engine", "318018-02", "Numeric and string relational comparison (<, =, >)"),
        ("$4D2C", "$4D3B", "ERR_SYNTAX_DIV0", "Error Handling", "318018-02", "Common error stubs: OUT OF DATA ($0D), SYNTAX ($0B), DIVISION BY ZERO ($14), OUT OF MEMORY ($10)"),
        ("$4D3C", "$4DC5", "ERROR_HANDLER", "Error Handling", "318018-02", "Central error handler ($0300 IERROR): check TRAP ($1209), store ERRNUM ($120B), print ?...ERROR"),
        ("$4DC6", "$4EF0", "MAIN_LINE_LOOP", "Execution Engine", "318018-02", "Interactive input loop ($0302 IMAIN): read line, crunch ($430A), insert/delete Bank 0 program line or execute direct"),
        ("$4EF1", "$4FA9", "LNKPRG_FINDLINE", "Program Storage", "318018-02", "Relink BASIC program lines in Bank 0 ($4F4F) and search for line number ($5064)"),
        ("$4FAA", "$5063", "RUNTIME_STACK_MGR", "Control Flow", "318018-02", "Manage 512-byte Software Control-Flow Stack ($0800-$09FF, TOS=$7D/$7E) for FOR/GOSUB/DO frames"),
        ("$514E", "$51DF", "QPLOP_DETOKENIZE", "Tokenizer", "318018-02", "Detokenize ($0306 IQPLOP) single-byte, $FE-prefixed, and $CE-prefixed tokens during LIST"),
        ("$77D4", "$77EE", "CHKNUM_CHKSTR", "Execution Engine", "318018-02", "Type-check routines: FRMNUM ($77D7), CHKNUM ($77DA), CHKSTR ($77DD), TYPE MISMATCH ($77E7)"),
        ("$77EF", "$78D6", "FRMEVL", "Execution Engine", "318018-02", "Recursive operator-precedence expression evaluator using $4828 OPTAB"),
        ("$78D7", "$794F", "EVAL", "Execution Engine", "318018-02", "Evaluate single term/atom: literal number, string, variable, array, FN, or function token"),
        ("$7950", "$7975", "CHKCHAR_HELPERS", "Execution Engine", "318018-02", "Syntax check helpers: CHKCLS ')' ($7956), CHKOPN '(' ($7959), CHKCOM ',' ($795C), SYNCHR ($795E)"),
        ("$7AAF", "$7CAA", "PTRGET", "Variable Storage", "318018-02", "Locate or allocate 7-byte simple variable in Bank 1 RAM ($2F/$30..$31/$32)"),
        ("$7CAB", "$7E70", "ARRAY_LOOKUP_DIM", "Variable Storage", "318018-02", "Locate or allocate multi-dimensional array in Bank 1 RAM ($31/$32..$33/$34)"),
        ("$8000", "$8005", "BASIC_HI_ENTRY", "Entry Vector", "318019-02", "Upper BASIC ROM header jump table ($8000 JMP $4000, $8003 JMP $51F3)"),
        ("$84B4", "$85AD", "INT_FP_CONVERSIONS", "Math Engine", "318019-02", "Convert FAC1 to 16-bit signed integer ($84B4) and signed/unsigned 16-bit to FAC1 ($84C9/$84D4)"),
        ("$85AE", "$879E", "STRING_ENGINE", "String Engine", "318019-02", "String allocation ($8690/$86CC), descriptor stack ($18..$21), concatenation ($86FF), FRESTR ($8781)"),
        ("$87F1", "$882D", "GETBYT_GETADR", "Execution Engine", "318019-02", "Evaluate 8-bit unsigned byte in X ($87F4 GETBYT) and 16-bit unsigned address in $16/$17 ($8812 GETADR)"),
        ("$882E", "$90CF", "FP_MATH_LIBRARY", "Math Engine", "318019-02", "5-byte Floating-Point arithmetic (FADD $8848, FSUB $8831, FMUL $8A27, FDIV $8B4C,LOG,EXP,SIN,COS,TAN,ATN,SQR,RND)"),
        ("$92EA", "$943F", "GARBAG_COLLECT", "String Engine", "318019-02", "Bank 1 dynamic string garbage collector using back-pointer marking"),
        ("$9520", "$9A5F", "PRINT_USING_PUDEF", "I/O & Formatting", "318019-02", "Formatted output engine for PRINT USING and PUDEF"),
        ("$9B00", "$A07F", "GRAPHICS_PRIMITIVES", "Graphics Engine", "318019-02", "VIC-II bitmapped graphics coordinate scaling, pixel plotting, line drawing, and $1C00-$3FFF memory relocation ($9F4F/$A022)"),
        ("$A84D", "$AAF0", "BASIC_IRQ_DRIVER", "Interrupt Driver", "318019-02", "60 Hz raster/IRQ service for automatic sprite movement (MOVSPR), collision detection (COLLISION), and 3-voice PLAY/SOUND envelope engine"),
        ("$B000", "$B008", "MON_ENTRY_TABLE", "ML Monitor", "318019-02", "ML Monitor entry vectors: $B000 Cold Entry (JMP $B021), $B003 BRK Entry (JMP $B009), $B006 Cmd Parser (JMP $B0B2)"),
        ("$B009", "$B08A", "MON_BRK_AND_REG_DISP", "ML Monitor", "318019-02", "Save 8502 registers/bank to $02-$09 on BRK/entry and display PC SR AC XR YR SP header & values ('R' command)"),
        ("$B08B", "$B0E5", "MON_MAIN_LOOP", "ML Monitor", "318019-02", "Read command line into $0200, indirect via ($032E) to $B0B2, match 22 command characters in $B0E6, dispatch via $B0FC"),
        ("$B11A", "$B151", "MON_BANK_MEM_ACCESS", "ML Monitor", "318019-02", "Cross-bank memory read ($B11A -> INDFET), write ($B12A -> INDSTA), and compare ($B13D -> INDCMP)"),
        ("$B152", "$B230", "MON_MEM_DUMP_MODIFY", "ML Monitor", "318019-02", "Memory examine ('M' $B152) and modify ('>' $B1AB) in 8-byte (40-col) or 16-byte (80-col) rows"),
        ("$B231", "$B2CD", "MON_COMPARE_TRANSFER", "ML Monitor", "318019-02", "Compare ('C' $B231) and overlap-safe Transfer ('T' $B234) memory blocks across banks"),
        ("$B2CE", "$B336", "MON_HUNT", "ML Monitor", "318019-02", "Hunt ('H' $B2CE) for up to 32 hex bytes or ASCII string across bank memory"),
        ("$B337", "$B3DA", "MON_LOAD_SAVE_VERIFY", "ML Monitor", "318019-02", "Disk/tape Load ('L'), Save ('S'), and Verify ('V') handler via KERNAL LOAD/SAVE"),
        ("$B3DB", "$B405", "MON_FILL", "ML Monitor", "318019-02", "Fill ('F' $B3DB) memory range with byte value"),
        ("$B406", "$B598", "MON_ASSEMBLER", "ML Monitor", "318019-02", "Single-line 8502 assembler ('A' / '.' $B406): trial-disassemble opcodes $00-$FF to match mnemonic & operand pattern"),
        ("$B599", "$B713", "MON_DISASSEMBLER", "ML Monitor", "318019-02", "8502 disassembler ('D' $B599, ';' $B61F) using packed 5-bit mnemonic tables ($B721/$B761) and mode table ($B770)"),
        ("$B7A5", "$B889", "MON_NUM_PARSER", "ML Monitor", "318019-02", "Multi-radix number parser ($ hex, + dec, & oct, % bin) producing 24-bit bank+address in $60-$62"),
        ("$B9B1", "$BA8F", "MON_BASE_CONVERT", "ML Monitor", "318019-02", "Number base converter ($/+/&/% command at $B9B1): display value in hex, signed/BCD decimal, octal, and 24-bit binary"),
        ("$BA90", "$BB40", "MON_DISK_CMD", "ML Monitor", "318019-02", "Disk status/command/directory ('@' $BA90) utility for IEC drives 4-30"),
    ]

    for r in core_routines:
        add_fn(*r)

    # Also add all statement and function handlers from tokens_data
    for t in tokens_data["primary_tokens"]:
        h = t.get("handler_addr", "")
        kw = t["keyword"].replace("\r", "<CR>").strip()
        if h.startswith("$") and len(h) == 5 and kw:
            addr_int = int(h[1:], 16)
            chip = "318018-02" if addr_int < 0x8000 else "318019-02"
            add_fn(h, "", f"CMD_{kw}", t["category"], chip, f"Handler for primary token {t['token_hex']} ({kw})")

    for t in tokens_data["fe_prefixed_statement_tokens"]:
        h = t.get("handler_addr", "")
        if h.startswith("$") and len(h) == 5 and t["keyword"].strip():
            addr_int = int(h[1:], 16)
            chip = "318018-02" if addr_int < 0x8000 else "318019-02"
            add_fn(h, "", f"CMD_FE_{t['keyword']}", t["category"], chip, f"Handler for extended token {t['token_hex']} ({t['keyword']})")

    for t in tokens_data["ce_prefixed_function_tokens"]:
        h = t.get("handler_addr", "")
        if h.startswith("$") and len(h) == 5:
            addr_int = int(h[1:], 16)
            chip = "318018-02" if addr_int < 0x8000 else "318019-02"
            add_fn(h, "", f"FN_CE_{t['keyword']}", t["category"], chip, f"Handler for extended function {t['token_hex']} ({t['keyword']})")

    out_csv = ROOT / "reports" / "basic_functions.csv"
    with out_csv.open("w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=["address", "end_address", "symbol", "category", "rom_image", "description", "confidence"])
        writer.writeheader()
        writer.writerows(rows)
    print(f"Wrote {out_csv} ({len(rows)} rows)")


if __name__ == "__main__":
    data = build_tokens_json()
    build_functions_csv(data)
