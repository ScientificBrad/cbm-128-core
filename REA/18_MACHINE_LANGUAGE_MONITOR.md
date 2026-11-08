# Phase 5 Deliverable 18: Commodore 128 Machine Language Monitor (`$B000–$BFFF`)

**Classification:** `CONFIRMED`  
**Source ROM:** `basic-8000.318019-02.bin` (`$B000–$BFFF`, 4,096 bytes)

---

## 1. Entry Points & Startup Sequence (`$B000–$B08A`)

The Commodore 128 resident Machine Language Monitor occupies the upper 4 KB of `basic-8000.318019-02.bin` (`$B000–$BFFF`) and begins with a 3-vector jump table:

| Vector | Instruction | Target | Entry Condition |
|---|---|---|---|
| **`$B000`** | `JMP $B021` | `MON_COLD_ENTRY` | Invoked by BASIC `MONITOR` command (`$FA`) or Run/Stop + Restore warm monitor entry |
| **`$B003`** | `JMP $B009` | `MON_BRK_ENTRY` | Invoked via KERNAL `CBINV` (`$0316/$0317 = $B003`) when the 8502 executes a `BRK` (`$00`) instruction |
| **`$B006`** | `JMP $B0B2` | `MON_CMD_PARSE` | Indirectly vectored through `$032E/$032F` (`EXMON`) to parse and dispatch monitor commands |

### 1.1 `BRK` Entry (`$B009–$B020`) vs Cold Entry (`$B021–$B04F`)
1. **`BRK` Entry (`$B009`):**
   - Calls `J_PRIMM` (`$FF7D`) to print `<CR>BREAK<BEL>` (`0D 42 52 45 41 4B 07 00`).
   - Pops the MMU bank byte pushed by the IRQ/BRK handler into `$02` (`PLA; STA $02`), then pops `Y`, `X`, `A`, `SR`, `PC_LO`, and `PC_HI` from the hardware stack into `$08, $07, $06, $05, $04, $03` (`$B017–$B01E`) and branches to `$B046`.
2. **Cold Entry (`$B021`):**
   - Resets MMU `CR` (`LDA #$00; STA $FF00`), clears `$05–$08` (`SR, A, X, Y = $00`), sets default `PC` (`$03/$04`) to `$B000` (`$B02E–$B035`), sets default bank `$02 = $0F` (Bank 15, System ROM/IO view at `$B036–$B039`), and calls `J_PRIMM` (`$FF7D`) to print `<CR>MONITOR` (`$B03A–$B045`).
3. **Common Register Display (`$B046–$B08A`):**
   - Saves the current hardware stack pointer `TSX; STX $09`, enables KERNAL messages (`LDA #$C0; JSR $FF90`), enables interrupts (`CLI`), and falls into the **`R` (Display Registers)** handler at `$B050`.

---

## 2. Command Loop & 22-Command Dispatch Table (`$B08B–$B119`)

At `$B08B`, the Monitor prints `<CR>`, reads up to 160 characters (`CPX #$A1`) into `$0200` via `J_BASIN` (`$FFCF`), null-terminates the line (`STA $01FF,X`), skips leading spaces via `$B8E9`, and jumps through **`JMP ($032E)`** (`$B0AF -> $B0B2`).

At **`$B0B2`**, the Monitor scans the 22-byte command table at **`$B0E6–$B0FB`** (`LDX #$15`):
- **Indices `0–14` (`$B0E6–$B0F4`):** Dispatched via `RTS` using the 15-entry `RTS-1` vector table at **`$B0FC–$B119`** (after pre-parsing the first numeric argument via `JMP $B7A7` at `$B0D8`!).
- **Indices `15–18` (`$B0F5–$B0F8`: `$`, `+`, `&`, `%`):** Base conversion commands (`CPX #$0F; BCS $B0E0 -> JMP $B9B1`).
- **Indices `19–21` (`$B0F9–$B0FB`: `L`, `S`, `V`):** Disk/tape file commands (`CPX #$13; BCS $B0DB -> JMP $B337`).

| Index | Cmd Byte | ASCII | `RTS-1` Slot | Handler Address | Command Syntax & Function |
|---:|---|---|---|---|---|
| 0 | `$41` | **`A`** | `$B0FC` (`$B405`) | **`$B406`** | `A <addr> <mnem> [oper]` — Assemble 8502 instruction |
| 1 | `$43` | **`C`** | `$B0FE` (`$B230`) | **`$B231`** | `C <start> <end> <dest>` — Compare memory blocks |
| 2 | `$44` | **`D`** | `$B100` (`$B598`) | **`$B599`** | `D [<start> [<end>]]` — Disassemble 8502 machine code |
| 3 | `$46` | **`F`** | `$B102` (`$B3DA`) | **`$B3DB`** | `F <start> <end> <byte>` — Fill memory range with byte |
| 4 | `$47` | **`G`** | `$B104` (`$B1D5`) | **`$B1D6`** | `G [<addr>]` — Go (execute via `JMPFAR` `$FF71`) |
| 5 | `$48` | **`H`** | `$B106` (`$B2CD`) | **`$B2CE`** | `H <start> <end> <bytes\|'str>` — Hunt for bytes or string |
| 6 | `$4A` | **`J`** | `$B108` (`$B1DE`) | **`$B1DF`** | `J [<addr>]` — Jump to subroutine (via `JSRFAR` `$FF6E`, then return to Monitor) |
| 7 | `$4D` | **`M`** | `$B10A` (`$B151`) | **`$B152`** | `M [<start> [<end>]]` — Memory hex/ASCII dump |
| 8 | `$52` | **`R`** | `$B10C` (`$B04F`) | **`$B050`** | `R` — Display saved 8502 registers (`PC SR AC XR YR SP`) |
| 9 | `$54` | **`T`** | `$B10E` (`$B233`) | **`$B234`** | `T <start> <end> <dest>` — Transfer (copy) memory block |
| 10 | `$58` | **`X`** | `$B110` (`$B0E2`) | **`$B0E3`** | `X` — Exit to BASIC warm start (`JMP ($0A00)` -> `$4003`) |
| 11 | `$40` | **`@`** | `$B112` (`$BA8F`) | **`$BA90`** | `@ [<unit>] [<cmd>]` — Disk status, command, or directory (`@$`) |
| 12 | `$2E` | **`.`** | `$B114` (`$B405`) | **`$B406`** | `. <addr> <mnem> [oper]` — Alias for `A` (Assemble) |
| 13 | `$3E` | **`>`** | `$B116` (`$B1AA`) | **`$B1AB`** | `> <addr> <b1> [<b2>..]` — Modify memory bytes in place |
| 14 | `$3B` | **`;`** | `$B118` (`$B193`) | **`$B194`** | `; [<addr> <sr> <ac> <xr> <yr> <sp>]` — Modify saved registers |
| 15 | `$24` | **`$`** | Direct `$B0E0` | **`$B9B1`** | `$<hex>` — Convert hexadecimal to `$`, `+`, `&`, `%` |
| 16 | `$2B` | **`+`** | Direct `$B0E0` | **`$B9B1`** | `+<dec>` — Convert decimal to `$`, `+`, `&`, `%` |
| 17 | `$26` | **`&`** | Direct `$B0E0` | **`$B9B1`** | `&<oct>` — Convert octal to `$`, `+`, `&`, `%` |
| 18 | `$25` | **`%`** | Direct `$B0E0` | **`$B9B1`** | `%<bin>` — Convert binary to `$`, `+`, `&`, `%` |
| 19 | `$4C` | **`L`** | Direct `$B0DB` | **`$B337`** | `L ["file" [,<dev> [,<alt_addr>]]]` — Load file |
| 20 | `$53` | **`S`** | Direct `$B0DB` | **`$B337`** | `S "file",<dev>,<start>,<end>` — Save memory range |
| 21 | `$56` | **`V`** | Direct `$B0DB` | **`$B337`** | `V ["file" [,<dev>]]` — Verify file against memory |

---

## 3. Multi-Radix & 5-Digit Bank Address Parser (`$B7A5–$B889`)

Every numeric argument in the Monitor is parsed by **`$B7A7` / `$B7CE`** into a 24-bit value in zero page **`$60` (low), `$61` (mid), `$62` (bank nibble `0–F`)**:
- Checks prefix character against `$B0F5–$B0F8` (`$`, `+`, `&`, `%`, defaulting to hexadecimal `$` if omitted at `$B7F3`).
- Looks up base (`16, 10, 8, 2`) from `$B88A` (`10 0A 08 02`) and bit-shift count (`4, 2, 3, 1`) from `$B88E` (`04 02 03 01`).
- **5-Digit Banked Addressing:** A 5-hex-digit address such as `01C01` or `F4000` places the low 16 bits in `$60/$61` (`$1C01` / `$4000`) and the bank nibble (`$00` / `$0F`) in `$62`!
- Cross-bank memory operations (`$B11A` read, `$B12A` write, `$B13D` compare) copy `$60–$62` to `$66–$68` (`$B901`) and invoke KERNAL **`J_INDFET` (`$FF74`)**, **`J_INDSTA` (`$FF77`)**, and **`J_INDCMP` (`$FF7A`)** with `X = $68` (the bank number `0–15`).

---

## 4. Register Display (`R` at `$B050`) and Modification (`;` at `$B194`)

- **`R` (`$B050–$B08A`):**
  - Prints `<CR>    PC  SR AC XR YR SP<CR>; ` (`$B050–$B06F`, using `<ESC>Q` `$1B $51` to clear to end of line).
  - Prints the bank nibble `$02` (`LDA $02; JSR $B8D2`), the 16-bit `PC` (`$03/$04`), and the 5 bytes `$05–$09` (`SR, AC, XR, YR, SP`) separated by spaces (`$B07E–$B08A`).
- **`;` (`$B194–$B1A8`):**
  - Calls `$B974` to store a new 24-bit `Bank:PC` (`$60–$62`) into `$04, $03, $02` (if supplied), then loops up to 5 times (`$B199–$B1A6`) parsing `SR, AC, XR, YR, SP` into `$05–$09`. This allows the user to cursor up to the `;` line printed by `R`, edit any register value, and press `<RETURN>`!

---

## 5. Memory Examination & Block Operations (`M`, `>`, `F`, `T`, `C`, `H`)

- **`M` (`$B152–$B193`) and `>` (`$B1AB–$B1D5`):**
  - Checks the current screen mode (`BIT $D7`, bit 7 = 80-column VDC mode):
    - In **40-column VIC-II mode (`$D7 >= 0`)**, displays/accepts **8 bytes per row** (`LDA #$08` at `$B17F`, `CPY #$08` at `$B1C5`).
    - In **80-column VDC mode (`$D7 < 0`)**, displays/accepts **16 bytes per row** (`ASL A` -> `16` at `$B185`, `CPY #$10` at `$B1C1`).
  - Each row begins with `>` followed by the 5-digit bank+address (`$B1EB–$B1F2`), the hex bytes (`$B1F7–$B209`), `:`, reverse-video on (`$12`), and the ASCII dump (`$B211–$B230`, replacing control characters `< $20` with `.`).
- **`F` (`$B3DB–$B405`):** Parses `<start> <end> <fill_byte>` (`$B983`, `$B7A7`), verifies start and end banks match (`LDA $68; CMP $0AB9; BNE $B403`), and loops writing `A` via `JSR $B12A` (`INDSTA`).
- **`C` (`$B231`) and `T` (`$B234`):** Share `$B236–$B2CB` (`$93 = $00` for Compare, `$93 = $80` for Transfer). For `T`, if `dest > start` (`$B24E–$B279`), the Monitor automatically switches to **backward copy mode** (`$0AB3 = $80`) from `end` down to `start` so overlapping regions within the same bank are copied without corruption!
- **`H` (`$B2CE–$B336`):** Parses `<start> <end>`, then accepts either a single-quoted ASCII string `'...` (`CMP #$27` at `$B2D8`, up to 32 characters stored in `$0A80–$0A9F`) or up to 32 hex byte values (`$B2F2–$B305`), and scans memory via `JSR $B11A` printing every matching 5-digit address.

---

## 6. 8502 Disassembler (`D` at `$B599`) & Single-Line Assembler (`A`/`.` at `$B406`)

### 6.1 Packed 5-Bit Opcode & Addressing Mode Tables (`$B714–$B7A0`)
Both the disassembler (`D`) and assembler (`A`/`.`) share a compact table-driven 6502/8502 instruction decoder (`$B659–$B6B7`):
- **Opcode Classification (`$B659–$B69D`):** Decodes any 8-bit opcode (`$00–$FF`) into:
  - A **6-bit mnemonic index (`0–63`)** returned in `A`, indexing the two 64-byte packed character tables at **`$B721–$B760`** (low byte) and **`$B761–$B7A0`** (high byte). Each 16-bit entry packs three 5-bit ASCII letters (`char - $3F`, unpacked by shifting 5 bits at a time at `$B69E–$B6B7`).
  - An **addressing mode descriptor byte** stored in `$0AAA` and instruction byte length (`0, 1, or 2` operand bytes) stored in `$0AAB`, derived from the mode lookup table at **`$B770–$B79F`** and prefix/suffix character tables at **`$B714–$B720`** (`#`, `(`, `,X`, `,Y`, `)`).

### 6.2 Trial-Disassembly Single-Line Assembler (`$B406–$B598`)
Rather than maintaining a separate assembler parser table, the Monitor implements an ingenious **trial-disassembly synthesis algorithm**:
1. **Mnemonic Packing (`$B413–$B441`):** Reads the 3-letter mnemonic into `$0AAC–$0AAE`, subtracts `$3F` from each letter, and shifts 5 bits per character into the 16-bit target word `$0AA0/$0AA1`.
2. **Operand Template Canonicalization (`$B445–$B48F`):** Parses the operand tokens after the mnemonic into a normalized pattern buffer at `$0AA2–$0AA9`, replacing any numeric byte with `"$00"` (`24 30 30`) and any 16-bit word with `"$0000"` (`24 30 30 30 30`), while preserving punctuation (`#`, `(`, `,`, `X`, `Y`, `)`).
3. **Exhaustive Opcode Search (`$B491–$B4F2`):** Iterates candidate opcode `$0AB1` from `$00` to `$FF`:
   - Calls `$B659` to decode candidate opcode `$0AB1`.
   - Compares the candidate's packed mnemonic (`$B761,X` / `$B721,X`) and formatted operand template (`$B4B2–$B4E9`) character-by-character against `$0AA0,X` via `$B57F`.
   - If a mismatch occurs (`$B587`), pops the return address, increments `$0AB1` (`INC $0AB1`), and tries the next opcode (`JMP $B496`). If all 256 opcodes fail (`BEQ $B579`), prints `?` error (`JMP $B0BC`).
4. **Relative Branch & Code Emission (`$B4F3–$B576`):**
   - Once the matching opcode is found, if the addressing mode is relative branch (`CMP #$9D` at `$B4FA`), computes the signed 8-bit displacement `target - (PC + 2)` (`$B4FE–$B51B`), verifying it fits in `-128..+127` (`CPX #$82`).
   - Writes the assembled opcode and operand bytes into target bank memory via `JSR $B12A` (`INDSTA`), prints the disassembled instruction on screen (`$B53B`), advances `PC` (`$B541`), and **stuffs `"A <next_addr> "` into the KERNAL keyboard buffer (`$034A–$0351`, `NDX $D0 = 8` at `$B547–$B575`)** so the user is automatically prompted to assemble the next sequential instruction!

---

## 7. Execution Control (`G`, `J`, `X`), Base Conversion (`$/+/&/%`), and Disk (`L/S/V/@`)

- **`G` (`$B1D6–$B1DE`):** Updates `$02–$04` (`Bank:PC`) if an address is given (`JSR $B974`), restores the hardware stack pointer `LDX $09; TXS`, and executes **`JMP $FF71` (`J_JMPFAR`)**.
- **`J` (`$B1DF–$B1E7`):** Updates `$02–$04` if an address is given, executes **`JSR $FF6E` (`J_JSRFAR`)**, and returns to the Monitor command loop (`JMP $B08B`).
- **`X` (`$B0E3–$B0E5`):** Executes **`JMP ($0A00)`**, which points to `$4003` (BASIC 7.0 warm start `READY.`).
- **`$`, `+`, `&`, `%` (`$B9B1–$BA8F`):** Parses the number in the specified radix (`$B7A5`), then prints it in all four bases on separate indented lines:
  - `$` Hexadecimal (`$B9B7–$B9CB`)
  - `+` Decimal (`$B9D1–$B9DF`, converted from 24-bit binary to 8-digit BCD via hardware decimal mode `SED` at `$BA07–$BA46`)
  - `&` Octal (`$B9E5–$B9F0`, 3 bits per digit via `$BA47`)
  - `%` Binary (`$B9F6–$BA01`, 24 bits via `$BA47`)
- **`L`, `S`, `V` (`$B337–$B3DA`):** Parses optional quoted filename (`$0A80`), device number (default `1` tape or `8` disk), and start/end addresses, calling KERNAL `J_SETBNK` (`$FF68` with bank `$68`), `J_SAVE` (`$FFD8`), or `J_LOAD` (`$FFD5` with `A=0` for Load or `A=$56` non-zero for Verify).
- **`@` (`$BA90–$BB40`):** Sends DOS commands, reads the drive error channel (when no string is given), or lists the disk directory (`@$` at `$BAB0`) on IEC units `4–30` (default unit `8` at `$BA92`).
