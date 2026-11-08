#!/usr/bin/env python3
"""
Exact boundary verification for BASIC 7.0 Keyword Tables, Dispatch Tables, Error Tables,
ML Monitor Tables, Screen Editor Tables, Z80 BIOS Tables, and KERNAL Vectors.
"""
import os
import json

WORKSPACE = r"D:\Emulation\C128"

def load_rom(name):
    with open(os.path.join(WORKSPACE, name), "rb") as f:
        return f.read()

def decode_highbit_list(data, start_off, max_off, base_addr):
    items = []
    cur = bytearray()
    item_start = start_off
    off = start_off
    while off < max_off:
        b = data[off]
        if b == 0x00 or b == 0xFF:
            break
        cur.append(b & 0x7F)
        if b & 0x80:
            items.append({
                "index": len(items),
                "offset": f"0x{item_start:04X}",
                "cpu_addr": f"${base_addr+item_start:04X}",
                "text": cur.decode("ascii", errors="replace")
            })
            cur = bytearray()
            item_start = off + 1
        off += 1
    return items, f"0x{off:04X}", f"${base_addr+off:04X}", f"0x{data[off]:02X}"

def main():
    b4 = load_rom("basic-4000.318018-02.bin")
    b8 = load_rom("basic-8000.318019-02.bin")
    kn = load_rom("kernal.318020-03.bin")

    # Inspect bytes around $4400-$4850 in b4
    tokens_1, end_off_1, end_cpu_1, term_1 = decode_highbit_list(b4, 0x0417, 0x0850, 0x4000)
    # Check if there is a second token table (e.g. CE / FE extended tokens) right after end_off_1
    next_start = int(end_off_1, 16) + 1
    tokens_2, end_off_2, end_cpu_2, term_2 = decode_highbit_list(b4, next_start, 0x0850, 0x4000)

    # Error messages at 0x084B ($484B)
    errors_1, err_end_off, err_end_cpu, err_term = decode_highbit_list(b4, 0x084B, 0x0B00, 0x4000)
    # Notice earlier we saw BREAK at $49D5 terminated by 0x00, and then at $49DC "CAN'T RESUME" etc.!
    err2_start = int(err_end_off, 16) + 1
    errors_2, err2_end_off, err2_end_cpu, err2_term = decode_highbit_list(b4, err2_start, 0x0B00, 0x4000)

    # Check what is between $4700 and $484B (dispatch addresses for BASIC keywords!)
    # And check what is between $4300 and $4417!
    out = {
        "b4_0300_0420_hex": b4[0x0300:0x0420].hex(),
        "b4_06F0_0850_hex": b4[0x06F0:0x0850].hex(),
        "b4_09D0_0A90_hex": b4[0x09D0:0x0A90].hex(),
        "tokens_table_1": {
            "start_cpu": "$4417",
            "end_cpu": end_cpu_1,
            "terminator": term_1,
            "count": len(tokens_1),
            "items": tokens_1
        },
        "tokens_table_2": {
            "start_cpu": f"${0x4000+next_start:04X}",
            "end_cpu": end_cpu_2,
            "terminator": term_2,
            "count": len(tokens_2),
            "items": tokens_2
        },
        "errors_table_1": {
            "start_cpu": "$484B",
            "end_cpu": err_end_cpu,
            "terminator": err_term,
            "count": len(errors_1),
            "items": errors_1
        },
        "errors_table_2": {
            "start_cpu": f"${0x4000+err2_start:04X}",
            "end_cpu": err2_end_cpu,
            "terminator": err2_term,
            "count": len(errors_2),
            "items": errors_2
        }
    }

    with open(os.path.join(WORKSPACE, "REA", "EVIDENCE", "PHASE1", "basic_tables_exact.json"), "w", encoding="utf-8") as f:
        json.dump(out, f, indent=2)

    print(f"Tokens 1: {len(tokens_1)} items ($4417..{end_cpu_1}, term {term_1})")
    print(f"Tokens 2: {len(tokens_2)} items (${0x4000+next_start:04X}..{end_cpu_2}, term {term_2})")
    print(f"Errors 1: {len(errors_1)} items ($484B..{err_end_cpu}, term {err_term})")
    print(f"Errors 2: {len(errors_2)} items (${0x4000+err2_start:04X}..{err2_end_cpu}, term {err2_term})")

if __name__ == "__main__":
    main()
