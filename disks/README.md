# Commodore 128 Floppy Disk Images & Drive Architecture

> **LEGAL NOTICE**  
> Floppy disk images containing proprietary operating systems (such as Commodore CP/M Plus 3.0) or commercial software are not bundled into this repository. Users must provide their own disk images (`.d64`, `.d71`, `.d81`).

---

## Supported Disk Formats

The Commodore 128 emulation core features hardware-accurate drive support for the Commodore 1571 fast floppy disk drive:

1. **D64 (Single-Sided GCR, 1541 / 1571 Mode):**
   - 35 Tracks, 683 Sectors (174,848 bytes).
   - Speed zones: Tracks 1-17 (21 sectors), 18-24 (19 sectors), 25-30 (18 sectors), 31-35 (17 sectors).
   - BAM (Block Availability Map) located on Track 18, Sector 0.
   - Genuine Commodore DOS 2.6 directory parsing and sector-level reading.

2. **D71 (Double-Sided GCR, 1571 Native Mode):**
   - 70 Tracks (Side 0: 1-35, Side 1: 36-70), 1,366 Sectors (349,696 bytes).
   - Fast serial burst transfer protocol supported.

---

## Verified CP/M Disk Images

The following genuine CP/M Plus 3.0 system disk dumps were used during reverse engineering and regression verification:

| Disk Image Filename | Size (Bytes) | Format | Description | SHA-256 Hash |
| :--- | :--- | :--- | :--- | :--- |
| `cpm_1985.d64` | 174,848 | D64 (35 track) | Commodore CP/M 3.0 Boot Disk (Dec 1985 release) | `49ff87df4f0a4502d34144f1ac9c6ee4616baad9a1035efcacd0b7490e310cf2` |
| `cpm_1987.d64` | 174,848 | D64 (35 track) | Commodore CP/M 3.0 System Disk (May 1987 revision) | `8fbc8d6725890e03e42a02e605d3f23a49ba3f93c1bcf35e26715f1f9e54dcb3` |
| `cpm.utilities.d64` | 174,848 | D64 (35 track) | CP/M Utilities Disk (DATE.COM, COPYSYS, FORMAT) | `9ba6eb154563b71569421fa8a7a8d003fcce7d2b217154238e85c9dcfe933be5` |

---

## Mounting a Disk in the Emulator

To boot CP/M 3.0 using the C# emulator:
```bash
# Attach CP/M boot disk as Drive 8
Commodore128.exe --disk disks/cpm_1985.d64 --cpm
```
