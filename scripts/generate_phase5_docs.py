"""Generate Phase 5 Markdown Deliverables:
- REA/16_BASIC_TOKEN_TABLE.md
- REA/17_BASIC_COMMAND_MAP.md
- REA/18_MACHINE_LANGUAGE_MONITOR.md
"""
import json
from pathlib import Path

ROOT = Path(r"D:\Emulation\C128")
tokens_data = json.loads((ROOT / "reports" / "basic_tokens.json").read_text(encoding="utf-8"))


def generate_16_token_table():
    lines = [
        "# Phase 5 Deliverable 16: Commodore BASIC 7.0 Complete Token & Error Tables",
        "",
        "**Classification:** `CONFIRMED`  ",
        "**Source ROM:** `basic-4000.318018-02.bin` (`$4417–$4A84`)",
        "",
        "---",
        "",
        "## 1. Token Table Architecture Overview",
        "",
        "Commodore BASIC 7.0 uses a three-table high-bit-terminated ASCII keyword structure in `basic-4000.318018-02.bin` (`$4417–$46F9`):",
        "",
        "| Table Name | ROM Address Range | Terminator | Entries | Token Encoding | Purpose |",
        "|---|---|---|---|---|---|",
        "| **Primary Keyword Table** | `$4417–$4607` | `$00` at `$4608` | 126 | `$80` .. `$FD` | Core BASIC V2/V3.5/V7.0 statements, operators, functions, and clause keywords |",
        "| **`$FE` Extended Statement Table** | `$4609–$46C7` | `$00` at `$46C8` | 37 | `$FE $02` .. `$FE $26` | C128 extended statements (`BANK`, `SPRITE`, `PLAY`, `SLOW`, `FAST`, etc.) |",
        "| **`$CE` Extended Function Table** | `$46C9–$46F8` | `$00` at `$46F9` | 9 | `$CE $02` .. `$CE $0A` | C128 extended functions (`POT`, `BUMP`, `PEN`, `RSPPOS`, `RSPRITE`, `RSPCOLOR`, `XOR`, `RWINDOW`, `POINTER`) |",
        "",
        "> [!IMPORTANT]",
        "> **Prefix Disambiguation (`$CE` and `$FE`):**",
        "> - In the Primary Keyword Table (`$4417`), index 78 (token `$CE` at `$452B`) is a single shifted-space byte (`$A0`, ASCII `' ' | $80`), so `CRUNCH` never emits `$CE` as a single-byte keyword.",
        "> - The Primary Keyword Table ends at index 125 (`$FD` = `WHILE` at `$4603–$4607`), leaving `$FE` exclusively as the 2-byte extended statement prefix and `$FF` as the numeric literal constant `PI`.",
        "> - In the `$FE` Extended Statement Table (`$4609`), sub-tokens `$FE $20` (`$46AA`) and `$FE $22` (`$46B0`) are 1-byte shifted-space (`$A0`) reserved slots whose dispatch vectors point to `$0001` (`$0000 + 1`).",
        "",
        "---",
        "",
        "## 2. Primary Single-Byte Token Table (`$4417–$4607`, Tokens `$80–$FD`)",
        "",
        "| Token (Hex) | Token (Dec) | Keyword | String Addr | Category | Dispatch Table Slot | Handler Entry |",
        "|---|---:|---|---|---|---|---|",
    ]

    for t in tokens_data["primary_tokens"]:
        kw = t["keyword"].replace("\r", "<CR>")
        disp = t.get("dispatch_table_addr", "—")
        lines.append(
            f"| `{t['token_hex']}` | {t['token_dec']} | `{kw}` | `{t['table_addr']}` | `{t['category']}` | `{disp}` | `{t['handler_addr']}` |"
        )

    lines.extend([
        "",
        "---",
        "",
        "## 3. `$FE`-Prefixed Extended Statement Token Table (`$4609–$46C7`, `$FE $02–$FE $26`)",
        "",
        "Dispatched by `GONE` at `$4B62 -> $4B94`: after reading prefix `$FE`, `CHRGET` reads the sub-token (`$02..$26`), adds `$47` (`Carry=0`, producing `STMDSP` index `73..109`), and performs an `RTS` dispatch via `$46FC,Y`.",
        "",
        "| Full Token | Sub-Token | Keyword | String Addr | Category | Dispatch Table Slot | Handler Entry |",
        "|---|---|---|---|---|---|---|",
    ])

    for t in tokens_data["fe_prefixed_statement_tokens"]:
        kw = t["keyword"] if t["keyword"].strip() else "(reserved $A0)"
        lines.append(
            f"| `{t['token_hex']}` | `{t['sub_token_hex']}` ({t['sub_token_dec']}) | `{kw}` | `{t['table_addr']}` | `{t['category']}` | `{t['dispatch_table_addr']}` | `{t['handler_addr']}` |"
        )

    lines.extend([
        "",
        "---",
        "",
        "## 4. `$CE`-Prefixed Extended Function Token Table (`$46C9–$46F8`, `$CE $02–$CE $0A`)",
        "",
        "Dispatched by `EVAL` at `$4BF3 -> $4C54`: after reading prefix `$CE`, `CHRGET` fetches the sub-token (`$02..$0A`). For `$02..$09` (`POT` through `RWINDOW`), `$4C61–$4C64` automatically parses `(` and evaluates the first expression into `FAC1` before dispatching; for `$0A` (`POINTER`), `$4C59` (`CMP #$0A; BEQ $4C68`) skips expression evaluation so `POINTER(var)` can pass the variable name directly to `PTRGET` (`$7AAF`) at `$82FA`! At `$4C70`, `ADC #$D1` (`Carry=0`) maps `$02..$0A` to `$D3..$DB`, which at `$4C3F` (`SEC; SBC #$B4`) indexes `FUNDSP` (`$47D8`) slots `31..39` (`$4816–$4827`).",
        "",
        "| Full Token | Sub-Token | Keyword | String Addr | Category | Dispatch Table Slot | Handler Entry |",
        "|---|---|---|---|---|---|---|",
    ])

    for t in tokens_data["ce_prefixed_function_tokens"]:
        lines.append(
            f"| `{t['token_hex']}` | `{t['sub_token_hex']}` ({t['sub_token_dec']}) | `{t['keyword']}` | `{t['table_addr']}` | `{t['category']}` | `{t['dispatch_table_addr']}` | `{t['handler_addr']}` |"
        )

    lines.extend([
        "",
        "---",
        "",
        "## 5. Operator Precedence & Vector Table (`OPTAB`, `$4828–$4845`)",
        "",
        "Each 3-byte entry consists of `[Precedence, Handler_Lo_Minus_1, Handler_Hi_Minus_1]`:",
        "",
        "| Index | Table Addr | Operator | Token | Precedence | Handler Entry | Description |",
        "|---:|---|---|---|---|---|---|",
    ])

    for op in tokens_data["operator_precedence_table"]:
        lines.append(
            f"| {op['index']} | `{op['table_addr']}` | `{op['symbol']}` | `{op['token']}` | `{op['precedence_hex']}` ({op['precedence_dec']}) | `{op['handler_addr']}` | {op['description']} |"
        )

    lines.extend([
        "",
        "---",
        "",
        "## 6. BASIC 7.0 Error Message Table (`$484B–$4A81`, Codes `$01–$29`)",
        "",
        "Scanned by `$4A82` (`FIND_ERRMSG`) for both the central error handler (`$4D3F`) and the `ERR$(n)` function (`$80F6`):",
        "",
        "| Code (Dec) | Code (Hex) | ROM Address | Error Message Text |",
        "|---:|---|---|---|",
    ])

    for err in tokens_data["error_messages"]:
        lines.append(
            f"| {err['error_code_dec']} | `{err['error_code_hex']}` | `{err['addr']}` | `{err['message']}` |"
        )

    out_path = ROOT / "REA" / "16_BASIC_TOKEN_TABLE.md"
    out_path.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(f"Wrote {out_path}")


if __name__ == "__main__":
    generate_16_token_table()
