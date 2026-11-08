# Commodore 128 System ROMs

> **LEGAL NOTICE & REPOSITORY POLICY**  
> Under our clean-room development and digital preservation principles, proprietary Commodore firmware binaries are **never** distributed within this repository or packaged into automated releases. Users must provide their own genuine Commodore 128 ROM dumps.

---

## Required ROM Inventory

To execute full Commodore BASIC 7.0 or CP/M 3.0 emulation, place the following ROM binary dumps in either the root project directory or the `roms/` folder:

| ROM Name | Part Number | Size (Bytes) | Address Range | Chip Type | SHA-256 Hash |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `basic-4000.318018-02.bin` | 318018-02 | 16,384 (16 KB) | `$4000-$7FFF` (Bank 0) | 23128 ROM | `c5ddb7c57dd0b6f259b95b9dd0494ba807cbe6dce8f1f19410a0a05833aa0b5e` |
| `basic-8000.318019-02.bin` | 318019-02 | 16,384 (16 KB) | `$8000-$BFFF` (Bank 0) | 23128 ROM | `e1432465b8abafd3397b0e6cb4eb8422449fb3f85c6366e8616b48c35a86ad79` |
| `kernal.318020-03.bin` | 318020-03 | 16,384 (16 KB) | `$C000-$FFFF` (Bank 0) | 23128 ROM | `dcb17b5ce33c2490005b5d0f2a4d767ae56e8ab7ed41d6aa20c43173449e4786` |
| `characters.390059-01.bin` | 390059-01 | 8,192 (8 KB) | `$D000-$DFFF` (Bank 0/1) | 2364 ROM | `f08d8f525b44f5cbb3f5776739fcdff737886e1813f1eb7a20aedb128db1d4a8` |
| `z80bios.bin` | *Embedded* | 4,096 (4 KB) | `$1000-$1FFF` (KERNAL) | Internal sub-ROM | `39c7656b326e4ad724ff4b50c995cb3b2b8ff9ed3bb2b4d277eb0ecd3cac062f` |

Total uncompressed firmware footprint: **61,440 bytes (60 KB)** across 5 binaries (4 physical chips totaling 56 KB).

---

## ROM Verification

You can verify the cryptographic integrity of your dumped ROM images using:

```bash
# Windows PowerShell
Get-FileHash -Algorithm SHA256 roms/*.bin

# Linux / macOS
sha256sum -c roms/checksums.sha256
```

The emulator also includes an automated verification utility:
```bash
python asm/verify_roms.py
```

---

## Clean-Room Fallback Architecture

If no ROM files are detected, the C# emulator (`Commodore128.exe`) and unit test harness safely allocate zeroed memory blocks and allow ROM-free unit tests (e.g., CPU instruction verification, timer math, MMU banking, and GCR disk layouts) to execute without crashing.
