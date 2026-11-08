# Phase 5 Deliverable 16: Commodore BASIC 7.0 Complete Token & Error Tables

**Classification:** `CONFIRMED`  
**Source ROM:** `basic-4000.318018-02.bin` (`$4417–$4A84`)

---

## 1. Token Table Architecture Overview

Commodore BASIC 7.0 uses a three-table high-bit-terminated ASCII keyword structure in `basic-4000.318018-02.bin` (`$4417–$46F9`):

| Table Name | ROM Address Range | Terminator | Entries | Token Encoding | Purpose |
|---|---|---|---|---|---|
| **Primary Keyword Table** | `$4417–$4607` | `$00` at `$4608` | 126 | `$80` .. `$FD` | Core BASIC V2/V3.5/V7.0 statements, operators, functions, and clause keywords |
| **`$FE` Extended Statement Table** | `$4609–$46C7` | `$00` at `$46C8` | 37 | `$FE $02` .. `$FE $26` | C128 extended statements (`BANK`, `SPRITE`, `PLAY`, `SLOW`, `FAST`, etc.) |
| **`$CE` Extended Function Table** | `$46C9–$46F8` | `$00` at `$46F9` | 9 | `$CE $02` .. `$CE $0A` | C128 extended functions (`POT`, `BUMP`, `PEN`, `RSPPOS`, `RSPRITE`, `RSPCOLOR`, `XOR`, `RWINDOW`, `POINTER`) |

> [!IMPORTANT]
> **Prefix Disambiguation (`$CE` and `$FE`):**
> - In the Primary Keyword Table (`$4417`), index 78 (token `$CE` at `$452B`) is a single shifted-space byte (`$A0`, ASCII `' ' | $80`), so `CRUNCH` never emits `$CE` as a single-byte keyword.
> - The Primary Keyword Table ends at index 125 (`$FD` = `WHILE` at `$4603–$4607`), leaving `$FE` exclusively as the 2-byte extended statement prefix and `$FF` as the numeric literal constant `PI`.
> - In the `$FE` Extended Statement Table (`$4609`), sub-tokens `$FE $20` (`$46AA`) and `$FE $22` (`$46B0`) are 1-byte shifted-space (`$A0`) reserved slots whose dispatch vectors point to `$0001` (`$0000 + 1`).

---

## 2. Primary Single-Byte Token Table (`$4417–$4607`, Tokens `$80–$FD`)

| Token (Hex) | Token (Dec) | Keyword | String Addr | Category | Dispatch Table Slot | Handler Entry |
|---|---:|---|---|---|---|---|
| `$80` | 128 | `END` | `$4417` | `statement_primary` | `$46FC` | `$4BCD` |
| `$81` | 129 | `FOR` | `$441A` | `statement_primary` | `$46FE` | `$5DF9` |
| `$82` | 130 | `NEXT` | `$441D` | `statement_primary` | `$4700` | `$57F4` |
| `$83` | 131 | `DATA` | `$4421` | `statement_primary` | `$4702` | `$528F` |
| `$84` | 132 | `INPUT#` | `$4425` | `statement_primary` | `$4704` | `$5648` |
| `$85` | 133 | `INPUT` | `$442B` | `statement_primary` | `$4706` | `$5662` |
| `$86` | 134 | `DIM` | `$4430` | `statement_primary` | `$4708` | `$587B` |
| `$87` | 135 | `READ` | `$4433` | `statement_primary` | `$470A` | `$56A9` |
| `$88` | 136 | `LET` | `$4437` | `statement_primary` | `$470C` | `$53C6` |
| `$89` | 137 | `GOTO` | `$443A` | `statement_primary` | `$470E` | `$59DB` |
| `$8A` | 138 | `RUN` | `$443E` | `statement_primary` | `$4710` | `$5A9B` |
| `$8B` | 139 | `IF` | `$4441` | `statement_primary` | `$4712` | `$52C5` |
| `$8C` | 140 | `RESTORE` | `$4443` | `statement_primary` | `$4714` | `$5ACA` |
| `$8D` | 141 | `GOSUB` | `$444A` | `statement_primary` | `$4716` | `$59CF` |
| `$8E` | 142 | `RETURN` | `$444F` | `statement_primary` | `$4718` | `$5262` |
| `$8F` | 143 | `REM` | `$4455` | `statement_primary` | `$471A` | `$529D` |
| `$90` | 144 | `STOP` | `$4458` | `statement_primary` | `$471C` | `$4BCB` |
| `$91` | 145 | `ON` | `$445C` | `statement_primary` | `$471E` | `$53A3` |
| `$92` | 146 | `WAIT` | `$445E` | `statement_primary` | `$4720` | `$6C2D` |
| `$93` | 147 | `LOAD` | `$4462` | `statement_primary` | `$4722` | `$912C` |
| `$94` | 148 | `SAVE` | `$4466` | `statement_primary` | `$4724` | `$9112` |
| `$95` | 149 | `VERIFY` | `$446A` | `statement_primary` | `$4726` | `$9129` |
| `$96` | 150 | `DEF` | `$4470` | `statement_primary` | `$4728` | `$84FA` |
| `$97` | 151 | `POKE` | `$4473` | `statement_primary` | `$472A` | `$80E5` |
| `$98` | 152 | `PRINT#` | `$4477` | `statement_primary` | `$472C` | `$553A` |
| `$99` | 153 | `PRINT` | `$447D` | `statement_primary` | `$472E` | `$555A` |
| `$9A` | 154 | `CONT` | `$4482` | `statement_primary` | `$4730` | `$5A60` |
| `$9B` | 155 | `LIST` | `$4486` | `statement_primary` | `$4732` | `$50E2` |
| `$9C` | 156 | `CLR` | `$448A` | `statement_primary` | `$4734` | `$51F8` |
| `$9D` | 157 | `CMD` | `$448D` | `statement_primary` | `$4736` | `$5540` |
| `$9E` | 158 | `SYS` | `$4490` | `statement_primary` | `$4738` | `$5885` |
| `$9F` | 159 | `OPEN` | `$4493` | `statement_primary` | `$473A` | `$918D` |
| `$A0` | 160 | `CLOSE` | `$4497` | `statement_primary` | `$473C` | `$919A` |
| `$A1` | 161 | `GET` | `$449C` | `statement_primary` | `$473E` | `$5612` |
| `$A2` | 162 | `NEW` | `$449F` | `statement_primary` | `$4740` | `$51D6` |
| `$A3` | 163 | `TAB(` | `$44A2` | `auxiliary_keyword` | `—` | `$55B9 (PRINT TAB() handler)` |
| `$A4` | 164 | `TO` | `$44A6` | `auxiliary_keyword` | `—` | `$577D (FOR..TO / DRAW..TO)` |
| `$A5` | 165 | `FN` | `$44A8` | `auxiliary_keyword` | `—` | `$7CD1 (FN user function evaluator)` |
| `$A6` | 166 | `SPC(` | `$44AA` | `auxiliary_keyword` | `—` | `$55B9 (PRINT SPC() handler)` |
| `$A7` | 167 | `THEN` | `$44AE` | `auxiliary_keyword` | `—` | `$59A7 (IF..THEN handler)` |
| `$A8` | 168 | `NOT` | `$44B2` | `auxiliary_keyword` | `—` | `$8484 (NOT logical negation)` |
| `$A9` | 169 | `STEP` | `$44B5` | `auxiliary_keyword` | `—` | `$578A (FOR..STEP / graphic STEP)` |
| `$AA` | 170 | `+` | `$44B9` | `operator` | `$4828` | `$8848` |
| `$AB` | 171 | `-` | `$44BA` | `operator` | `$482B` | `$8831` |
| `$AC` | 172 | `*` | `$44BB` | `operator` | `$482E` | `$8A27` |
| `$AD` | 173 | `/` | `$44BC` | `operator` | `$4831` | `$8B4C` |
| `$AE` | 174 | `^` | `$44BD` | `operator` | `$4834` | `$8FC1` |
| `$AF` | 175 | `AND` | `$44BE` | `operator` | `$4837` | `$4C89` |
| `$B0` | 176 | `OR` | `$44C1` | `operator` | `$483A` | `$4C86` |
| `$B1` | 177 | `>` | `$44C3` | `operator` | `$4843` | `$4CB6 (relational) / $5848 (LET=)` |
| `$B2` | 178 | `=` | `$44C4` | `operator` | `$4843` | `$4CB6 (relational) / $5848 (LET=)` |
| `$B3` | 179 | `<` | `$44C5` | `operator` | `$4843` | `$4CB6 (relational) / $5848 (LET=)` |
| `$B4` | 180 | `SGN` | `$44C6` | `function_primary` | `$47D8` | `$8C65` |
| `$B5` | 181 | `INT` | `$44C9` | `function_primary` | `$47DA` | `$8CFB` |
| `$B6` | 182 | `ABS` | `$44CC` | `function_primary` | `$47DC` | `$8C84` |
| `$B7` | 183 | `USR` | `$44CF` | `function_primary` | `$47DE` | `$1218` |
| `$B8` | 184 | `FRE` | `$44D2` | `function_primary` | `$47E0` | `$8000` |
| `$B9` | 185 | `POS` | `$44D5` | `function_primary` | `$47E2` | `$84D0` |
| `$BA` | 186 | `SQR` | `$44D8` | `function_primary` | `$47E4` | `$8FB7` |
| `$BB` | 187 | `RND` | `$44DB` | `function_primary` | `$47E6` | `$8434` |
| `$BC` | 188 | `LOG` | `$44DE` | `function_primary` | `$47E8` | `$89CA` |
| `$BD` | 189 | `EXP` | `$44E1` | `function_primary` | `$47EA` | `$9033` |
| `$BE` | 190 | `COS` | `$44E4` | `function_primary` | `$47EC` | `$9409` |
| `$BF` | 191 | `SIN` | `$44E7` | `function_primary` | `$47EE` | `$9410` |
| `$C0` | 192 | `TAN` | `$44EA` | `function_primary` | `$47F0` | `$9459` |
| `$C1` | 193 | `ATN` | `$44ED` | `function_primary` | `$47F2` | `$94B3` |
| `$C2` | 194 | `PEEK` | `$44F0` | `function_primary` | `$47F4` | `$80C5` |
| `$C3` | 195 | `LEN` | `$44F4` | `function_primary` | `$47F6` | `$8668` |
| `$C4` | 196 | `STR$` | `$44F7` | `function_primary` | `$47F8` | `$85AE` |
| `$C5` | 197 | `VAL` | `$44FB` | `function_primary` | `$47FA` | `$804A` |
| `$C6` | 198 | `ASC` | `$44FE` | `function_primary` | `$47FC` | `$8677` |
| `$C7` | 199 | `CHR$` | `$4501` | `function_primary` | `$47FE` | `$85BF` |
| `$C8` | 200 | `LEFT$` | `$4505` | `function_primary` | `$4800` | `$85D6` |
| `$C9` | 201 | `RIGHT$` | `$450A` | `function_primary` | `$4802` | `$860A` |
| `$CA` | 202 | `MID$` | `$4510` | `function_primary` | `$4804` | `$861C` |
| `$CB` | 203 | `GO` | `$4514` | `function_primary` | `$4806` | `$8182` |
| `$CC` | 204 | `RGR` | `$4516` | `function_primary` | `$4808` | `$819B` |
| `$CD` | 205 | `RCLR` | `$4519` | `function_primary` | `$480A (intercepted at $4BF7)` | `$81D7` |
| `$CE` | 206 | ` ` | `$451D` | `prefix_placeholder` | `$480C (intercepted at $4BF3 -> $4C54)` | `$4C54` |
| `$CF` | 207 | `JOY` | `$451E` | `function_primary` | `$480E` | `$9B0C` |
| `$D0` | 208 | `RDOT` | `$4521` | `function_primary` | `$4810` | `$8076` |
| `$D1` | 209 | `DEC` | `$4525` | `function_primary` | `$4812` | `$8142` |
| `$D2` | 210 | `HEX$` | `$4528` | `function_primary` | `$4814` | `$80F6` |
| `$D3` | 211 | `ERR$` | `$452C` | `function_primary` | `$4816` | `$824D` |
| `$D4` | 212 | `INSTR` | `$4530` | `function_primary` | `$4818` | `$837C` |
| `$D5` | 213 | `ELSE` | `$4535` | `statement_extended_single_byte` | `$4742` | `$5391` |
| `$D6` | 214 | `RESUME` | `$4539` | `statement_extended_single_byte` | `$4744` | `$5F62` |
| `$D7` | 215 | `TRAP` | `$453F` | `statement_extended_single_byte` | `$4746` | `$5F4D` |
| `$D8` | 216 | `TRON` | `$4543` | `statement_extended_single_byte` | `$4748` | `$58B4` |
| `$D9` | 217 | `TROFF` | `$4547` | `statement_extended_single_byte` | `$474A` | `$58B7` |
| `$DA` | 218 | `SOUND` | `$454C` | `statement_extended_single_byte` | `$474C` | `$71EC` |
| `$DB` | 219 | `VOL` | `$4551` | `statement_extended_single_byte` | `$474E` | `$71C5` |
| `$DC` | 220 | `AUTO` | `$4554` | `statement_extended_single_byte` | `$4750` | `$5975` |
| `$DD` | 221 | `PUDEF` | `$4558` | `statement_extended_single_byte` | `$4752` | `$5F34` |
| `$DE` | 222 | `GRAPHIC` | `$455D` | `statement_extended_single_byte` | `$4754` | `$6B5A` |
| `$DF` | 223 | `PAINT` | `$4564` | `statement_extended_single_byte` | `$4756` | `$61A8` |
| `$E0` | 224 | `CHAR` | `$4569` | `statement_extended_single_byte` | `$4758` | `$67D7` |
| `$E1` | 225 | `BOX` | `$456D` | `statement_extended_single_byte` | `$475A` | `$62B7` |
| `$E2` | 226 | `CIRCLE` | `$4570` | `statement_extended_single_byte` | `$475C` | `$668E` |
| `$E3` | 227 | `GSHAPE` | `$4576` | `statement_extended_single_byte` | `$475E` | `$658D` |
| `$E4` | 228 | `SSHAPE` | `$457C` | `statement_extended_single_byte` | `$4760` | `$642B` |
| `$E5` | 229 | `DRAW` | `$4582` | `statement_extended_single_byte` | `$4762` | `$6797` |
| `$E6` | 230 | `LOCATE` | `$4586` | `statement_extended_single_byte` | `$4764` | `$6955` |
| `$E7` | 231 | `COLOR` | `$458C` | `statement_extended_single_byte` | `$4766` | `$69E2` |
| `$E8` | 232 | `SCNCLR` | `$4591` | `statement_extended_single_byte` | `$4768` | `$6A79` |
| `$E9` | 233 | `SCALE` | `$4597` | `statement_extended_single_byte` | `$476A` | `$6960` |
| `$EA` | 234 | `HELP` | `$459C` | `statement_extended_single_byte` | `$476C` | `$5986` |
| `$EB` | 235 | `DO` | `$45A0` | `statement_extended_single_byte` | `$476E` | `$5FE0` |
| `$EC` | 236 | `LOOP` | `$45A2` | `statement_extended_single_byte` | `$4770` | `$608A` |
| `$ED` | 237 | `EXIT` | `$45A6` | `statement_extended_single_byte` | `$4772` | `$6039` |
| `$EE` | 238 | `DIRECTORY` | `$45AA` | `statement_extended_single_byte` | `$4774` | `$A07E` |
| `$EF` | 239 | `DSAVE` | `$45B3` | `statement_extended_single_byte` | `$4776` | `$A18C` |
| `$F0` | 240 | `DLOAD` | `$45B8` | `statement_extended_single_byte` | `$4778` | `$A1A7` |
| `$F1` | 241 | `HEADER` | `$45BD` | `statement_extended_single_byte` | `$477A` | `$A267` |
| `$F2` | 242 | `SCRATCH` | `$45C3` | `statement_extended_single_byte` | `$477C` | `$A2A1` |
| `$F3` | 243 | `COLLECT` | `$45CA` | `statement_extended_single_byte` | `$477E` | `$A32F` |
| `$F4` | 244 | `COPY` | `$45D1` | `statement_extended_single_byte` | `$4780` | `$A346` |
| `$F5` | 245 | `RENAME` | `$45D5` | `statement_extended_single_byte` | `$4782` | `$A36E` |
| `$F6` | 246 | `BACKUP` | `$45DB` | `statement_extended_single_byte` | `$4784` | `$A37C` |
| `$F7` | 247 | `DELETE` | `$45E1` | `statement_extended_single_byte` | `$4786` | `$5E87` |
| `$F8` | 248 | `RENUMBER` | `$45E7` | `statement_extended_single_byte` | `$4788` | `$5AF8` |
| `$F9` | 249 | `KEY` | `$45EF` | `statement_extended_single_byte` | `$478A` | `$610A` |
| `$FA` | 250 | `MONITOR` | `$45F2` | `statement_extended_single_byte` | `$478C` | `$B000` |
| `$FB` | 251 | `USING` | `$45F9` | `clause_keyword` | `—` | `$555C -> $9520 (PRINT USING)` |
| `$FC` | 252 | `UNTIL` | `$45FE` | `clause_keyword` | `—` | `$5FF6 / $608C (DO / LOOP UNTIL)` |
| `$FD` | 253 | `WHILE` | `$4603` | `clause_keyword` | `—` | `$5FF6 / $608C (DO / LOOP WHILE)` |

---

## 3. `$FE`-Prefixed Extended Statement Token Table (`$4609–$46C7`, `$FE $02–$FE $26`)

Dispatched by `GONE` at `$4B62 -> $4B94`: after reading prefix `$FE`, `CHRGET` reads the sub-token (`$02..$26`), adds `$47` (`Carry=0`, producing `STMDSP` index `73..109`), and performs an `RTS` dispatch via `$46FC,Y`.

| Full Token | Sub-Token | Keyword | String Addr | Category | Dispatch Table Slot | Handler Entry |
|---|---|---|---|---|---|---|
| `$FE $02` | `$02` (2) | `BANK` | `$4609` | `statement_fe_prefixed` | `$478E` | `$6BC9` |
| `$FE $03` | `$03` (3) | `FILTER` | `$460D` | `statement_fe_prefixed` | `$4790` | `$7046` |
| `$FE $04` | `$04` (4) | `PLAY` | `$4613` | `statement_fe_prefixed` | `$4792` | `$6DE1` |
| `$FE $05` | `$05` (5) | `TEMPO` | `$4617` | `statement_fe_prefixed` | `$4794` | `$6FD7` |
| `$FE $06` | `$06` (6) | `MOVSPR` | `$461C` | `statement_fe_prefixed` | `$4796` | `$6CC6` |
| `$FE $07` | `$07` (7) | `SPRITE` | `$4622` | `statement_fe_prefixed` | `$4798` | `$6C4F` |
| `$FE $08` | `$08` (8) | `SPRCOLOR` | `$4628` | `statement_fe_prefixed` | `$479A` | `$7190` |
| `$FE $09` | `$09` (9) | `RREG` | `$4630` | `statement_fe_prefixed` | `$479C` | `$58BD` |
| `$FE $0A` | `$0A` (10) | `ENVELOPE` | `$4634` | `statement_fe_prefixed` | `$479E` | `$70C1` |
| `$FE $0B` | `$0B` (11) | `SLEEP` | `$463C` | `statement_fe_prefixed` | `$47A0` | `$6BD7` |
| `$FE $0C` | `$0C` (12) | `CATALOG` | `$4641` | `statement_fe_prefixed` | `$47A2` | `$A07E` |
| `$FE $0D` | `$0D` (13) | `DOPEN` | `$4648` | `statement_fe_prefixed` | `$47A4` | `$A11D` |
| `$FE $0E` | `$0E` (14) | `APPEND` | `$464D` | `statement_fe_prefixed` | `$47A6` | `$A134` |
| `$FE $0F` | `$0F` (15) | `DCLOSE` | `$4653` | `statement_fe_prefixed` | `$47A8` | `$A16F` |
| `$FE $10` | `$10` (16) | `BSAVE` | `$4659` | `statement_fe_prefixed` | `$47AA` | `$A1C8` |
| `$FE $11` | `$11` (17) | `BLOAD` | `$465E` | `statement_fe_prefixed` | `$47AC` | `$A218` |
| `$FE $12` | `$12` (18) | `RECORD` | `$4663` | `statement_fe_prefixed` | `$47AE` | `$A2D7` |
| `$FE $13` | `$13` (19) | `CONCAT` | `$4669` | `statement_fe_prefixed` | `$47B0` | `$A362` |
| `$FE $14` | `$14` (20) | `DVERIFY` | `$466F` | `statement_fe_prefixed` | `$47B2` | `$A1A4` |
| `$FE $15` | `$15` (21) | `DCLEAR` | `$4676` | `statement_fe_prefixed` | `$47B4` | `$A322` |
| `$FE $16` | `$16` (22) | `SPRSAV` | `$467C` | `statement_fe_prefixed` | `$47B6` | `$76EC` |
| `$FE $17` | `$17` (23) | `COLLISION` | `$4682` | `statement_fe_prefixed` | `$47B8` | `$7164` |
| `$FE $18` | `$18` (24) | `BEGIN` | `$468B` | `statement_fe_prefixed` | `$47BA` | `$796C` |
| `$FE $19` | `$19` (25) | `BEND` | `$4690` | `statement_fe_prefixed` | `$47BC` | `$528F` |
| `$FE $1A` | `$1A` (26) | `WINDOW` | `$4694` | `statement_fe_prefixed` | `$47BE` | `$72CC` |
| `$FE $1B` | `$1B` (27) | `BOOT` | `$469A` | `statement_fe_prefixed` | `$47C0` | `$7335` |
| `$FE $1C` | `$1C` (28) | `WIDTH` | `$469E` | `statement_fe_prefixed` | `$47C2` | `$71B6` |
| `$FE $1D` | `$1D` (29) | `SPRDEF` | `$46A3` | `statement_fe_prefixed` | `$47C4` | `$7372` |
| `$FE $1E` | `$1E` (30) | `QUIT` | `$46A9` | `statement_fe_prefixed` | `$47C6` | `$4846` |
| `$FE $1F` | `$1F` (31) | `STASH` | `$46AD` | `statement_fe_prefixed` | `$47C8` | `$AA1F` |
| `$FE $20` | `$20` (32) | `(reserved $A0)` | `$46B2` | `reserved_fe_slot` | `$47CA` | `$0001` |
| `$FE $21` | `$21` (33) | `FETCH` | `$46B3` | `statement_fe_prefixed` | `$47CC` | `$AA24` |
| `$FE $22` | `$22` (34) | `(reserved $A0)` | `$46B8` | `reserved_fe_slot` | `$47CE` | `$0001` |
| `$FE $23` | `$23` (35) | `SWAP` | `$46B9` | `statement_fe_prefixed` | `$47D0` | `$AA29` |
| `$FE $24` | `$24` (36) | `OFF` | `$46BD` | `statement_fe_prefixed` | `$47D2` | `$4846` |
| `$FE $25` | `$25` (37) | `FAST` | `$46C0` | `statement_fe_prefixed` | `$47D4` | `$77B3` |
| `$FE $26` | `$26` (38) | `SLOW` | `$46C4` | `statement_fe_prefixed` | `$47D6` | `$77C4` |

---

## 4. `$CE`-Prefixed Extended Function Token Table (`$46C9–$46F8`, `$CE $02–$CE $0A`)

Dispatched by `EVAL` at `$4BF3 -> $4C54`: after reading prefix `$CE`, `CHRGET` fetches the sub-token (`$02..$0A`). For `$02..$09` (`POT` through `RWINDOW`), `$4C61–$4C64` automatically parses `(` and evaluates the first expression into `FAC1` before dispatching; for `$0A` (`POINTER`), `$4C59` (`CMP #$0A; BEQ $4C68`) skips expression evaluation so `POINTER(var)` can pass the variable name directly to `PTRGET` (`$7AAF`) at `$82FA`! At `$4C70`, `ADC #$D1` (`Carry=0`) maps `$02..$0A` to `$D3..$DB`, which at `$4C3F` (`SEC; SBC #$B4`) indexes `FUNDSP` (`$47D8`) slots `31..39` (`$4816–$4827`).

| Full Token | Sub-Token | Keyword | String Addr | Category | Dispatch Table Slot | Handler Entry |
|---|---|---|---|---|---|---|
| `$CE $02` | `$02` (2) | `POT` | `$46C9` | `function_ce_prefixed` | `$4816` | `$824D` |
| `$CE $03` | `$03` (3) | `BUMP` | `$46CC` | `function_ce_prefixed` | `$4818` | `$837C` |
| `$CE $04` | `$04` (4) | `PEN` | `$46D0` | `function_ce_prefixed` | `$481A` | `$82AE` |
| `$CE $05` | `$05` (5) | `RSPPOS` | `$46D3` | `function_ce_prefixed` | `$481C` | `$8397` |
| `$CE $06` | `$06` (6) | `RSPRITE` | `$46D9` | `function_ce_prefixed` | `$481E` | `$831E` |
| `$CE $07` | `$07` (7) | `RSPCOLOR` | `$46E0` | `function_ce_prefixed` | `$4820` | `$8361` |
| `$CE $08` | `$08` (8) | `XOR` | `$46E8` | `function_ce_prefixed` | `$4822` | `$83E1` |
| `$CE $09` | `$09` (9) | `RWINDOW` | `$46EB` | `function_ce_prefixed` | `$4824` | `$8407` |
| `$CE $0A` | `$0A` (10) | `POINTER` | `$46F2` | `function_ce_prefixed` | `$4826` | `$82FA` |

---

## 5. Operator Precedence & Vector Table (`OPTAB`, `$4828–$4845`)

Each 3-byte entry consists of `[Precedence, Handler_Lo_Minus_1, Handler_Hi_Minus_1]`:

| Index | Table Addr | Operator | Token | Precedence | Handler Entry | Description |
|---:|---|---|---|---|---|---|
| 0 | `$4828` | `+` | `$AA` | `$79` (121) | `$8848` | Addition / String Concatenation |
| 1 | `$482B` | `-` | `$AB` | `$79` (121) | `$8831` | Subtraction |
| 2 | `$482E` | `*` | `$AC` | `$7B` (123) | `$8A27` | Multiplication |
| 3 | `$4831` | `/` | `$AD` | `$7B` (123) | `$8B4C` | Division |
| 4 | `$4834` | `^` | `$AE` | `$7F` (127) | `$8FC1` | Exponentiation |
| 5 | `$4837` | `AND` | `$AF` | `$50` (80) | `$4C89` | Bitwise 16-bit AND |
| 6 | `$483A` | `OR` | `$B0` | `$46` (70) | `$4C86` | Bitwise 16-bit OR |
| 7 | `$483D` | `NEG` | `$AB (unary)` | `$7D` (125) | `$8FFA` | Unary Negation |
| 8 | `$4840` | `NOT` | `$A8 (unary)` | `$5A` (90) | `$7930` | Logical/Bitwise NOT |
| 9 | `$4843` | `REL` | `$B1..$B3` | `$64` (100) | `$4CB6` | Relational Comparison (>, =, <) |

---

## 6. BASIC 7.0 Error Message Table (`$484B–$4A81`, Codes `$01–$29`)

Scanned by `$4A82` (`FIND_ERRMSG`) for both the central error handler (`$4D3F`) and the `ERR$(n)` function (`$80F6`):

| Code (Dec) | Code (Hex) | ROM Address | Error Message Text |
|---:|---|---|---|
| 1 | `$01` | `$484B` | `TOO MANY FILES` |
| 2 | `$02` | `$4859` | `FILE OPEN` |
| 3 | `$03` | `$4862` | `FILE NOT OPEN` |
| 4 | `$04` | `$486F` | `FILE NOT FOUND` |
| 5 | `$05` | `$487D` | `DEVICE NOT PRESENT` |
| 6 | `$06` | `$488F` | `NOT INPUT FILE` |
| 7 | `$07` | `$489D` | `NOT OUTPUT FILE` |
| 8 | `$08` | `$48AC` | `MISSING FILE NAME` |
| 9 | `$09` | `$48BD` | `ILLEGAL DEVICE NUMBER` |
| 10 | `$0A` | `$48D2` | `NEXT WITHOUT FOR` |
| 11 | `$0B` | `$48E2` | `SYNTAX` |
| 12 | `$0C` | `$48E8` | `RETURN WITHOUT GOSUB` |
| 13 | `$0D` | `$48FC` | `OUT OF DATA` |
| 14 | `$0E` | `$4907` | `ILLEGAL QUANTITY` |
| 15 | `$0F` | `$4917` | `OVERFLOW` |
| 16 | `$10` | `$491F` | `OUT OF MEMORY` |
| 17 | `$11` | `$492C` | `UNDEF'D STATEMENT` |
| 18 | `$12` | `$493D` | `BAD SUBSCRIPT` |
| 19 | `$13` | `$494A` | `REDIM'D ARRAY` |
| 20 | `$14` | `$4957` | `DIVISION BY ZERO` |
| 21 | `$15` | `$4967` | `ILLEGAL DIRECT` |
| 22 | `$16` | `$4975` | `TYPE MISMATCH` |
| 23 | `$17` | `$4982` | `STRING TOO LONG` |
| 24 | `$18` | `$4991` | `FILE DATA` |
| 25 | `$19` | `$499A` | `FORMULA TOO COMPLEX` |
| 26 | `$1A` | `$49AD` | `CAN'T CONTINUE` |
| 27 | `$1B` | `$49BB` | `UNDEF'D FUNCTION` |
| 28 | `$1C` | `$49CB` | `VERIFY` |
| 29 | `$1D` | `$49D1` | `LOAD` |
| 30 | `$1E` | `$49D5` | `BREAK  ` |
| 31 | `$1F` | `$49DC` | `CAN'T RESUME` |
| 32 | `$20` | `$49E8` | `LOOP NOT FOUND` |
| 33 | `$21` | `$49F6` | `LOOP WITHOUT DO` |
| 34 | `$22` | `$4A05` | `DIRECT MODE ONLY` |
| 35 | `$23` | `$4A15` | `NO GRAPHICS AREA` |
| 36 | `$24` | `$4A25` | `BAD DISK` |
| 37 | `$25` | `$4A2D` | `BEND NOT FOUND` |
| 38 | `$26` | `$4A3B` | `LINE NUMBER TOO LARGE` |
| 39 | `$27` | `$4A50` | `UNRESOLVED REFERENCE` |
| 40 | `$28` | `$4A64` | `UNIMPLEMENTED COMMAND` |
| 41 | `$29` | `$4A79` | `FILE READ` |
