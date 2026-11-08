# ROM Verification & Provenance Specification
**Project 002: Commodore 128 Dual-CPU Reconstruction**  
**Author:** ScientificBrad Research & Digital Preservation

---

## 1. Physical Chipset & Motherboard Mapping

The standard production Commodore 128 motherboard (PCB 250466 / 310378) incorporates four primary mask ROM integrated circuits totaling 56 KB of physical non-volatile storage:

| Motherboard Location | Chip Designator | Part Number | Capacity | Bus Function | Address Range |
| :---: | :---: | :---: | :---: | :--- | :--- |
| **U32** | 23128 ROM | `318018-02` | 16 KB (16,384 bytes) | BASIC 7.0 Low ROM | Bank 0: `$4000-$7FFF` |
| **U33** | 23128 ROM | `318019-02` | 16 KB (16,384 bytes) | BASIC 7.0 High ROM | Bank 0: `$8000-$BFFF` |
| **U34** | 23128 ROM | `318020-03` | 16 KB (16,384 bytes) | KERNAL & Z80 BIOS | Bank 0: `$C000-$FFFF` |
| **U35** | 2364 ROM | `390059-01` | 8 KB (8,192 bytes) | Character Generator | Bank 0/1: `$D000-$DFFF` |

> **Note on Z80 BIOS Mapping:** The Z80 BIOS is not a separate physical chip on the motherboard. It resides inside U34 (KERNAL ROM) at offset `$1000-$1FFF`. When the Z80 takes control of the bus at reset, the MMU maps this 4 KB slice to Z80 address `$0000-$0FFF`.

---

## 2. Cryptographic Checksum Reference

All reverse engineering and emulation verification tests were conducted against the verified canonical Rev 3 ROM set:

```text
========================================================================================================
File: basic-4000.318018-02.bin
Size: 16,384 bytes (16.0 KB)
MD5:  0e51e2cccc9e7028ed48a45d402402f9
SHA-1: 3b1a8d0701a248f7639e334a1d48c8bcf627dd2c
SHA-256: c5ddb7c57dd0b6f259b95b9dd0494ba807cbe6dce8f1f19410a0a05833aa0b5e
--------------------------------------------------------------------------------------------------------
File: basic-8000.318019-02.bin
Size: 16,384 bytes (16.0 KB)
MD5:  788a59e0cf22cc8421f1ea59f199b6f9
SHA-1: d2414757c3e5361db4058d4e9d1bf77bb79e0a0a
SHA-256: e1432465b8abafd3397b0e6cb4eb8422449fb3f85c6366e8616b48c35a86ad79
--------------------------------------------------------------------------------------------------------
File: kernal.318020-03.bin
Size: 16,384 bytes (16.0 KB)
MD5:  25a0f37e843e3643fce21fb6fd65bd4d
SHA-1: 1f0e8f3b25324ec378873040fa74e5088c227546
SHA-256: dcb17b5ce33c2490005b5d0f2a4d767ae56e8ab7ed41d6aa20c43173449e4786
--------------------------------------------------------------------------------------------------------
File: characters.390059-01.bin
Size: 8,192 bytes (8.0 KB)
MD5:  46b3cb2140f244c0ed1150c819e7bdc4
SHA-1: d7fa3df4e00780447385be26e84d436a5a0720cb
SHA-256: f08d8f525b44f5cbb3f5776739fcdff737886e1813f1eb7a20aedb128db1d4a8
--------------------------------------------------------------------------------------------------------
File: z80bios.bin (Extracted 4 KB sub-slice from KERNAL $1000-$1FFF)
Size: 4,096 bytes (4.0 KB)
MD5:  894dad6f8fc898dd4c1174163ed1838a
SHA-1: 520ea85e7874602f067d023a9b1c70e704812328
SHA-256: 39c7656b326e4ad724ff4b50c995cb3b2b8ff9ed3bb2b4d277eb0ecd3cac062f
========================================================================================================
```

---

## 3. Verifying Your ROM Images

You can automatically verify your dumped ROM files against the SHA-256 signatures:

```bash
# Using PowerShell
Get-FileHash -Algorithm SHA256 roms/*.bin

# Using sha256sum
sha256sum -c roms/checksums.sha256
```

If hashes match, the emulator will boot cleanly with 100% hardware fidelity.
