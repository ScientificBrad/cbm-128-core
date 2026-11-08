# Phase 5 Deliverable 17: Commodore BASIC 7.0 Command & Function Implementation Map

**Classification:** `CONFIRMED`  
**Primary ROMs Analysed:** `basic-4000.318018-02.bin` (`$4000–$7FFF`), `basic-8000.318019-02.bin` (`$8000–$BFFF`)

---

## 1. Statement & Function Dispatch Architecture

BASIC 7.0 dispatches **110 statement entries** via `STMDSP` (`$46FC–$47D7`, storing 16-bit `RTS-1` addresses) and **40 function entries** via `FUNDSP` (`$47D8–$4827`, storing direct 16-bit addresses called via `JMP ($0057)` at `$0056`).

### 1.1 Complete Statement Dispatch Map (`$46FC–$47D7`)
- **Primary Statements (`$80–$A2`, Indices `0–34`, `$46FC–$4741`):**
  - `END` (`$80 -> $51F0`), `FOR` (`$81 -> $5746`), `NEXT` (`$82 -> $5D63`), `DATA` (`$83 -> $537A`), `INPUT#` (`$84 -> $5648`), `INPUT` (`$85 -> $5662`), `DIM` (`$86 -> $587B`), `READ` (`$87 -> $56CB`), `LET` (`$88 -> $5831`), `GOTO` (`$89 -> $5238`), `RUN` (`$8A -> $51D6`), `IF` (`$8B -> $5986`), `RESTORE` (`$8C -> $51CD`), `GOSUB` (`$8D -> $521F`), `RETURN` (`$8E -> $5262`), `REM` (`$8F -> $59CA`), `STOP` (`$90 -> $51EE`), `ON` (`$91 -> $59DB`), `WAIT` (`$92 -> $8800`), `LOAD` (`$93 -> $912E`), `SAVE` (`$94 -> $91AE`), `VERIFY` (`$95 -> $912B`), `DEF` (`$96 -> $7CE3`), `POKE` (`$97 -> $80E5`), `PRINT#` (`$98 -> $554A`), `PRINT` (`$99 -> $555A`), `CONT` (`$9A -> $520D`), `LIST` (`$9B -> $50E2`), `CLR` (`$9C -> $4F79`), `CMD` (`$9D -> $5541`), `SYS` (`$9E -> $5885`), `OPEN` (`$9F -> $91E2`), `CLOSE` (`$A0 -> $91FB`), `GET` (`$A1 -> $5612`), `NEW` (`$A2 -> $4F62`).
- **Extended Single-Byte Statements (`$D5–$FA`, Indices `35–72`, `$4742–$478D`):**
  - `ELSE` (`$D5 -> $59D6`), `RESUME` (`$D6 -> $5F62`), `TRAP` (`$D7 -> $5F4D`), `TRON` (`$D8 -> $5FC9`), `TROFF` (`$D9 -> $5FCA`), `SOUND` (`$DA -> $71EC`), `VOL` (`$DB -> $71C5`), `AUTO` (`$DC -> $5FCC`), `PUDEF` (`$DD -> $9548`), `GRAPHIC` (`$DE -> $6B5A`), `PAINT` (`$DF -> $61A8`), `CHAR` (`$E0 -> $658D`), `BOX` (`$E1 -> $62B7`), `CIRCLE` (`$E2 -> $668E`), `GSHAPE` (`$E3 -> $642B`), `SSHAPE` (`$E4 -> $65D4`), `DRAW` (`$E5 -> $67B6`), `LOCATE` (`$E6 -> $682F`), `COLOR` (`$E7 -> $6AA6`), `SCNCLR` (`$E8 -> $69F9`), `SCALE` (`$E9 -> $693D`), `HELP` (`$EA -> $60E1`), `DO` (`$EB -> $5FF6`), `LOOP` (`$EC -> $608C`), `EXIT` (`$ED -> $6037`), `DIRECTORY` (`$EE -> $A37C`), `DSAVE` (`$EF -> $A126`), `DLOAD` (`$F0 -> $A134`), `HEADER` (`$F1 -> $A103`), `SCRATCH` (`$F2 -> $A109`), `COLLECT` (`$F3 -> $A366`), `COPY` (`$F4 -> $A137`), `RENAME` (`$F5 -> $A36E`), `BACKUP` (`$F6 -> $A11D`), `DELETE` (`$F7 -> $5EB0`), `RENUMBER` (`$F8 -> $6127`), `KEY` (`$F9 -> $5DDF`), `MONITOR` (`$FA -> $B000`).
- **`$FE`-Prefixed Extended Statements (`$FE $02–$FE $26`, Indices `73–109`, `$478E–$47D7`):**
  - `BANK` (`$FE $02 -> $6BC9`), `FILTER` (`$FE $03 -> $728A`), `PLAY` (`$FE $04 -> $6DE3`), `TEMPO` (`$FE $05 -> $6FD7`), `MOVSPR` (`$FE $06 -> $6DEC`), `SPRITE` (`$FE $07 -> $6C4F`), `SPRCOLOR` (`$FE $08 -> $7190`), `RREG` (`$FE $09 -> $58BD`), `ENVELOPE` (`$FE $0A -> $70C1`), `SLEEP` (`$FE $0B -> $6BD7`), `CATALOG` (`$FE $0C -> $A37C`), `DOPEN` (`$FE $0D -> $A146`), `APPEND` (`$FE $0E -> $A117`), `DCLOSE` (`$FE $0F -> $A329`), `BSAVE` (`$FE $10 -> $91B5`), `BLOAD` (`$FE $11 -> $9148`), `RECORD` (`$FE $12 -> $A2D8`), `CONCAT` (`$FE $13 -> $A10F`), `DVERIFY` (`$FE $14 -> $A12E`), `DCLEAR` (`$FE $15 -> $A35F`), `SPRSAV` (`$FE $16 -> $76EC`), `COLLISION` (`$FE $17 -> $7164`), `BEGIN` (`$FE $18 -> $59D4`), `BEND` (`$FE $19 -> $59D9`), `WINDOW` (`$FE $1A -> $767A`), `BOOT` (`$FE $1B -> $9157`), `WIDTH` (`$FE $1C -> $71B6`), `SPRDEF` (`$FE $1D -> $7332`), `QUIT` (`$FE $1E -> $4846` `UNIMPLEMENTED COMMAND`), `STASH` (`$FE $1F -> $9224`), `FETCH` (`$FE $21 -> $921C`), `SWAP` (`$FE $23 -> $9221`), `OFF` (`$FE $24 -> $4846` `UNIMPLEMENTED COMMAND`), `FAST` (`$FE $25 -> $77B3`), `SLOW` (`$FE $26 -> $77C4`).

---

## 2. Deep-Dive Analysis of Core & Extended BASIC 7.0 Commands

### 2.1 `PRINT` (`$99 -> $555A`) and `INPUT` (`$85 -> $5662`)
- **`PRINT` (`$555A`):**
  - Checks for end-of-statement (`BEQ $5598` -> outputs `<CR>` `$0D` via `$560C -> $90DF -> JSR $FFD2`).
  - Checks for `USING` (`$FB` at `$555C -> JMP $9520`), `TAB(` (`$A3` at `$5565 -> $55B9`), `SPC(` (`$A6` at `$5569 -> $55B9`), `,` (`$2C` at `$556E -> $55A9`, advancing to the next 10-column tab stop via `SEC; JSR $928D`), and `;` (`$3B` at `$5572 -> $55D4`).
  - For expressions (`$5576`): Calls `FRMEVL` (`$77EF`). If numeric (`BIT $0F; BPL`), converts `FAC1` to an ASCII string in `$0100` via `FOUT` (`$8E42`), creates a string descriptor via `$869A`, and prints it via `$55E5` (which fetches characters from Bank 1 RAM via `JSR $03B7`).
- **`INPUT` (`$5662`):**
  - If followed by a string literal (`CMP #$22`), prints the prompt string (`$7913`), requires `;` (`$795E`), and prints it (`$55E5`).
  - Calls `ERRDIR` (`$84D9`) to reject `INPUT` in Direct Mode (`?ILLEGAL DIRECT ERROR`), reads a line via `$569C` (`INLIN`), and parses comma-separated values into the target variables (`$56CB+`), printing `?REDO FROM START` or `??` if fewer values are supplied.

### 2.2 `BANK` (`$FE $02 -> $6BC9`), `PEEK` (`$C2 -> $80C5`), `POKE` (`$97 -> $80E5`), and `SYS` (`$9E -> $5885`)
- **`BANK` (`$6BC9`):**
  - Evaluates an 8-bit integer (`JSR $87F4` `GETBYT`), checks `CPX #$10; BCS $6BD4` (`?ILLEGAL QUANTITY ERROR` if `bank > 15`), and stores the bank number (`0–15`) in **`$03D5`** (`STX $03D5; RTS`).
  - When KERNAL `INDFET`/`INDSTA`/`JSRFAR` are called, `$03D5` is translated via KERNAL `GETCFG` (`$FF6B`) into the corresponding MMU `CR` byte (`$D500`).
- **`PEEK(addr)` (`$80C5`):**
  - Saves `$16/$17` on the stack, checks numeric argument (`$77DA`), converts `FAC1` to a 16-bit unsigned address in `$16/$17` (`JSR $8815` `GETADR`), loads the current `BANK` setting `LDX $03D5` (`$80D1`), sets `LDA #$16; LDY #$00`, and calls KERNAL **`J_INDFET` (`JSR $FF74`)** to read the byte from bank `X` at `($16),Y`! Transfers the result to `Y` and floats it via `JMP $84D4` (`SNGFLT`).
- **`POKE addr, val` (`$80E5`):**
  - Calls `$8803` (evaluates 16-bit address into `$16/$17`, checks `,`, and evaluates 8-bit byte into `X`), transfers `TXA`, sets `LDX #$16; STX $02B9`, loads `LDX $03D5` (`BANK`), and jumps to KERNAL **`J_INDSTA` (`JMP $FF77`)** to write `A` to `($16),Y` in bank `X`.
- **`SYS addr [, a [, x [, y [, sr]]]]` (`$5885`):**
  - Evaluates 16-bit target address into `$16/$17` (`JSR $8812`), copies it to `$03/$04` (`PC_HI`/`PC_LO`), and copies `$03D5` (`BANK`) to `$02` (`$5890–$5893`).
  - Parses up to four optional comma-separated 8-bit arguments via `JSR $9E1E` (`$5895–$58B0`), storing them in `$06` (`A`), `$07` (`X`), `$08` (`Y`), and `$05` (`SR`).
  - Dispatches via **`JMP $FF6E` (`J_JSRFAR`)**, which switches to bank `$02`, loads `A/X/Y/SR` from `$05–$08`, calls `($03/$04)`, captures the returned `A/X/Y/SR` back into `$05–$08` (readable via **`RREG`** at `$58BD`!), and returns to BASIC!

### 2.3 Bitmapped Graphics Engine: `GRAPHIC`, `BOX`, `CIRCLE`, `PAINT`, and `DRAW`
- **`GRAPHIC mode [, clear [, top_row]]` (`$DE -> $6B5A`):**
  - If followed by `CLR` (`$9C` at `$6B5A`), calls **`$A022` (`DEALLOC_BITMAP`)** to copy the BASIC program in Bank 0 down from `$4001` back to `$1C01`, decrementing `TXTTAB` (`$2E`), `EOP` (`$1211`), and all line links by `$24` pages (`9,216` bytes), and clears `$76` and `$D8` (`GRAPHM`).
  - Otherwise evaluates `mode` (`0–5` at `$6B69–$6B72`):
    - `0`: 40-column text (`$D8 = $00`)
    - `1`: High-res bitmap (`320×200`, `$D8 = $20`)
    - `2`: High-res split-screen bitmap + text (`$D8 = $60`, default split at row 20)
    - `3`: Multicolor bitmap (`160×200`, `$D8 = $A0`)
    - `4`: Multicolor split-screen bitmap + text (`$D8 = $E0`)
    - `5`: 80-column VDC text (calls `JSR $FF5F` `J_SWAPPER` if not already in 80-column mode)
  - For bitmap modes (`1–4`), calls **`$9F4F` (`ALLOC_BITMAP`)**, which checks `$76` (bitmap allocated flag); if `0`, it relocates the entire BASIC program in Bank 0 upward by `$2400` bytes (`$1C01 -> $4001`), updates all pointers (`$2E`, `$1211`, `$3E`, and `$0800–$09FF` stack frames at `$9FF2–$A020`), and sets `$76 = $FF`, reserving `$1C00–$1FFF` for color RAM and `$2000–$3FFF` (8,000 bytes) for the VIC-II bitmap!
  - If `clear = 1`, calls `SCNCLR` (`$6A92`) to clear the bitmap and color planes.
- **`DRAW [color], [x1, y1] [TO x2, y2 ...]` (`$E5 -> $67B6`):**
  - Calls `$9E2F` (verify bitmap allocated), parses optional color selector (`0–3`), starting coordinate pair (`$9E6D` -> `$9D99`, updating graphic cursor `XPOS`/`YPOS` at `$1131–$1134`), and loops over `TO` (`$A4`) segments (`$67CE–$6814`), invoking the Bresenham line-drawing primitive **`$9B30`** (`plot_line`) or single-point plotter **`$9C19`** (`plot_pixel`).
- **`BOX [color], x1, y1 [, x2, y2 [, angle [, fill]]]` (`$E1 -> $62B7`):**
  - Parses corner coordinates, rotation angle (`0–359` degrees, default `0`, stored in `$1154/$1155`), and fill flag (`0` or `1`, stored in `$116C`).
  - Computes rotated rectangle vertices using the trigonometric sine/cosine helper (`$6389` / `$9D6D`), and either draws the 4 outline edges via `$9B30` (`fill = 0` at `$62E4–$62ED`) or sweeps scanlines across the box interior (`fill = 1` at `$62FE–$6360`).
- **`CIRCLE [color], x, y [, xr [, yr [, sa [, ea [, angle [, inc]]]]]]` (`$E2 -> $668E`):**
  - Parses center `(x, y)`, X-radius (`$1154/$1155`), optional Y-radius (`$1156/$1157`, defaulting to X-radius scaled for high-res/multicolor aspect ratio at `$66B1–$66C4`), start angle (`sa`, default `0`), end angle (`ea`, default `360`), rotation (`angle`), and degree increment (`inc`, default `2` degrees at `$671A`).
  - Steps from `sa` to `ea` by `inc` (`$6728–$6758`), computing each chord endpoint via `$6750` (`SIN`/`COS`) and drawing chord segments via `$9B30`.
- **`PAINT [color], x, y [, mode]` (`$DF -> $61A8`):**
  - Flood-fill engine that first runs `GARBAG` (`JSR $92EA` at `$61D0`) to maximize free space between `STREND` (`$33/$34`) and `FRETOP` (`$35/$36`) in Bank 1 RAM, then uses the free Bank 1 region (`$24/$25` up to `$1B/$1C`) as a **span work-queue stack** to flood-fill contiguous horizontal pixel spans via `$9C49` (pixel test) and `$9C19` (pixel plot)!

### 2.4 Sprite & Sound Architecture: `SPRITE`, `SOUND`, `PLAY`, and `MONITOR`
- **`SPRITE num [, enable [, color [, priority [, x_exp [, y_exp [, mode]]]]]]` (`$FE $07 -> $6C4F`):**
  - Parses sprite number `1–8` (`$6CBB`, converted to `0–7` in `$77` and bitmask `$6CB3,X`).
  - Calls `$A845` to ensure VIC-II I/O is mapped, then updates:
    - Enable bit in `$D015` (`Y=$15` at `$6C57`)
    - Sprite color `1–16` (`0–15`) in `$D027,X` (`$6C6C`)
    - Background priority in `$D01B` (`Y=$1B` at `$6C74`)
    - X-expansion in `$D01D` (`Y=$1D` at `$6C7E`)
    - Y-expansion in `$D017` (`Y=$17` at `$6C88`)
    - Multicolor mode in `$D01C` (`Y=$1C` at `$6C92`)
- **`SOUND voice, freq, dur [, dir [, min [, step [, wform [, pwidth]]]]]` (`$DA -> $71EC`):**
  - Validates `voice` (`1–3`, converted to `0–2` in `$1281`), 16-bit `freq` (`$12A5/$12A6`), 16-bit `dur` in 60 Hz jiffies (`$12A3/$12A4`), sweep `dir` (`0=up, 1=down, 2=oscillate`), `min` frequency (`$12A7/$12A8`), `step` (`$12AA/$12AB`), `wform` (`0–3`: triangle, sawtooth, pulse, noise), and `pwidth` (`0–4095`).
  - Loads the parameters into the SID voice shadow tables (`$1282–$12B0`) serviced at 60 Hz by the BASIC IRQ driver (`$A84D`)!
- **`PLAY string$` (`$FE $04 -> $6DE3`):**
  - Evaluates the music command string in Bank 1 (`JSR $877B`), fetches each character from Bank 1 via `JSR $03B7` (`$6DF4`), and dispatches through the score parser at **`$6E02`**:
    - Notes `A–G` (`$6E07 -> $6F1E`)
    - Duration codes `W, H, Q, I, S` (`$6FE7` table: Whole, Half, Quarter, Eighth, Sixteenth at `$6E12 -> $6F07`)
    - Rest `R` (`$6E1F -> $6F78`) and Dotted note `.` (`$6E26 -> $6F03`)
    - Control prefixes `V` (Voice `1–3`), `O` (Octave `0–6`), `T` (Tune envelope `0–9`), `U` (Volume), `X` (Filter `0–1`), `M` (Measure wait) via table `$6FEC` (`$6E2D`), '#' (Sharp), and '$' (Flat).
- **`MONITOR` (`$FA -> $B000`):**
  - Dispatches directly via `STMDSP` index 72 (`$478C`, word `$AFFF` -> `$B000`) into the resident Machine Language Monitor cold entry point (`JMP $B021`).
