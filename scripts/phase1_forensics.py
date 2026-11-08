#!/usr/bin/env python3
"""
Phase 1 Forensics Analysis Script for Commodore 128 Original 1985 Firmware Set.
Performs strictly read-only forensic inspection of the 5 ROM images:
- basic-4000.318018-02.bin (16384 bytes)
- basic-8000.318019-02.bin (16384 bytes)
- kernal.318020-03.bin     (16384 bytes)
- characters.390059-01.bin (8192 bytes)
- z80bios.bin              (4096 bytes)
"""

import os
import json
import csv
import hashlib
import zlib
import math
from collections import Counter

WORKSPACE = r"D:\Emulation\C128"
ROMS = [
    {
        "filename": "basic-4000.318018-02.bin",
        "expected_size": 16384,
        "part_number": "318018-02",
        "revision": "R2 (1985)",
        "purpose": "BASIC 7.0 lower ROM",
        "cpu_base": 0x4000,
        "cpu_end": 0x7FFF,
        "socket": "U34 (Early boards) / Combined in U34 318022-01 (32KB)"
    },
    {
        "filename": "basic-8000.318019-02.bin",
        "expected_size": 16384,
        "part_number": "318019-02",
        "revision": "R2 (1985)",
        "purpose": "BASIC 7.0 upper ROM & ML Monitor",
        "cpu_base": 0x8000,
        "cpu_end": 0xBFFF,
        "socket": "U33 (Early boards) / Combined in U34 318022-01 (32KB)"
    },
    {
        "filename": "kernal.318020-03.bin",
        "expected_size": 16384,
        "part_number": "318020-03",
        "revision": "R3 (1985)",
        "purpose": "Screen Editor, Z80 BIOS and C128 KERNAL",
        "cpu_base": 0xC000,
        "cpu_end": 0xFFFF,
        "socket": "U35"
    },
    {
        "filename": "characters.390059-01.bin",
        "expected_size": 8192,
        "part_number": "390059-01",
        "revision": "R1 (1985 US/International)",
        "purpose": "Character Generator (C64 + C128 fonts)",
        "cpu_base": 0xD000,
        "cpu_end": 0xEFFF,
        "socket": "U18"
    },
    {
        "filename": "z80bios.bin",
        "expected_size": 4096,
        "part_number": "Embedded in 318020-03",
        "revision": "R3 (1985)",
        "purpose": "Separate Z80 BIOS image (mapped at Z80 $0000-$0FFF)",
        "cpu_base": 0x0000,
        "cpu_end": 0x0FFF,
        "socket": "Logical slice of U35 ($D000-$DFFF physical)"
    }
]

def shannon_entropy(data: bytes) -> float:
    if not data:
        return 0.0
    counts = Counter(data)
    length = len(data)
    return -sum((c / length) * math.log2(c / length) for c in counts.values())

def find_runs(data: bytes, min_len: int = 8):
    runs = []
    if not data:
        return runs
    cur_byte = data[0]
    start = 0
    for i in range(1, len(data)):
        if data[i] != cur_byte:
            if i - start >= min_len:
                runs.append({
                    "byte": f"0x{cur_byte:02X}",
                    "start_offset": f"0x{start:04X}",
                    "end_offset": f"0x{i-1:04X}",
                    "length": i - start
                })
            cur_byte = data[i]
            start = i
    if len(data) - start >= min_len:
        runs.append({
            "byte": f"0x{cur_byte:02X}",
            "start_offset": f"0x{start:04X}",
            "end_offset": f"0x{len(data)-1:04X}",
            "length": len(data) - start
        })
    return runs

def extract_ascii_strings(data: bytes, min_len: int = 4):
    strings = []
    cur = bytearray()
    start = 0
    for i, b in enumerate(data):
        # Include standard printable ASCII (0x20-0x7E)
        if 0x20 <= b <= 0x7E:
            if not cur:
                start = i
            cur.append(b)
        else:
            if len(cur) >= min_len:
                strings.append({
                    "offset": f"0x{start:04X}",
                    "length": len(cur),
                    "text": cur.decode("ascii", errors="replace"),
                    "terminator": f"0x{b:02X}"
                })
            cur = bytearray()
    if len(cur) >= min_len:
        strings.append({
            "offset": f"0x{start:04X}",
            "length": len(cur),
            "text": cur.decode("ascii", errors="replace"),
            "terminator": "EOF"
        })
    return strings

def extract_highbit_terminated_strings(data: bytes, min_len: int = 3):
    """Extract strings where characters are ASCII 0x20..0x5F and the final char has bit 7 set (0xA0..0xDF)."""
    strings = []
    cur = bytearray()
    start = 0
    for i, b in enumerate(data):
        if 0x20 <= b <= 0x5F:
            if not cur:
                start = i
            cur.append(b)
        elif 0xA0 <= b <= 0xDF and len(cur) >= (min_len - 1):
            cur.append(b & 0x7F)
            strings.append({
                "offset": f"0x{start:04X}",
                "end_offset": f"0x{i:04X}",
                "length": len(cur),
                "text": cur.decode("ascii", errors="replace")
            })
            cur = bytearray()
        else:
            cur = bytearray()
    return strings

def main():
    checksum_records = []
    detailed_forensics = {}

    raw_blobs = {}
    for rom in ROMS:
        path = os.path.join(WORKSPACE, rom["filename"])
        with open(path, "rb") as f:
            data = f.read()
        raw_blobs[rom["filename"]] = data

        size = len(data)
        sha256 = hashlib.sha256(data).hexdigest()
        sha1 = hashlib.sha1(data).hexdigest()
        md5 = hashlib.md5(data).hexdigest()
        crc32 = f"{zlib.crc32(data) & 0xFFFFFFFF:08x}"
        sum16 = sum(data) & 0xFFFF
        sum32 = sum(data) & 0xFFFFFFFF
        overall_entropy = round(shannon_entropy(data), 4)

        # Block entropy in 1KB (1024-byte) and 256-byte pages
        kb_entropy = []
        for offset in range(0, size, 1024):
            chunk = data[offset:offset+1024]
            kb_entropy.append({
                "offset_range": f"0x{offset:04X}-0x{offset+len(chunk)-1:04X}",
                "cpu_range": f"0x{rom['cpu_base']+offset:04X}-0x{rom['cpu_base']+offset+len(chunk)-1:04X}",
                "entropy": round(shannon_entropy(chunk), 4),
                "unique_bytes": len(set(chunk)),
                "ff_count": chunk.count(0xFF),
                "00_count": chunk.count(0x00),
                "aa_count": chunk.count(0xAA)
            })

        runs = find_runs(data, min_len=8)
        ascii_strings = extract_ascii_strings(data, min_len=4)
        hi_strings = extract_highbit_terminated_strings(data, min_len=3)

        rec = {
            "filename": rom["filename"],
            "part_number": rom["part_number"],
            "revision": rom["revision"],
            "purpose": rom["purpose"],
            "socket": rom["socket"],
            "size_bytes": size,
            "expected_size_bytes": rom["expected_size"],
            "size_match": size == rom["expected_size"],
            "cpu_address_start": f"0x{rom['cpu_base']:04X}",
            "cpu_address_end": f"0x{rom['cpu_end']:04X}",
            "sha256": sha256,
            "sha1": sha1,
            "md5": md5,
            "crc32": crc32,
            "sum16_hex": f"0x{sum16:04X}",
            "sum32_hex": f"0x{sum32:08X}",
            "shannon_entropy_bits_per_byte": overall_entropy,
            "unique_byte_values": len(set(data)),
            "padding_ff_bytes": data.count(0xFF),
            "padding_00_bytes": data.count(0x00),
            "padding_aa_bytes": data.count(0xAA)
        }
        checksum_records.append(rec)

        detailed_forensics[rom["filename"]] = {
            "summary": rec,
            "kb_blocks": kb_entropy,
            "repeated_byte_runs_min8": runs,
            "ascii_strings_min4_count": len(ascii_strings),
            "ascii_strings_sample": ascii_strings[:120],
            "highbit_strings_count": len(hi_strings),
            "highbit_strings_sample": hi_strings[:120]
        }

    # Cross-image verification: z80bios.bin vs kernal.318020-03.bin
    kernal_data = raw_blobs["kernal.318020-03.bin"]
    z80_data = raw_blobs["z80bios.bin"]

    # Check every 4KB slice of kernal_data and also search for exact match
    exact_offset = kernal_data.find(z80_data)
    slice_comparisons = []
    for k_off in range(0, len(kernal_data), 4096):
        k_slice = kernal_data[k_off:k_off+4096]
        diff_positions = [i for i in range(4096) if k_slice[i] != z80_data[i]]
        slice_comparisons.append({
            "kernal_file_offset": f"0x{k_off:04X}-0x{k_off+4095:04X}",
            "kernal_cpu_address": f"0x{0xC000+k_off:04X}-0x{0xC000+k_off+4095:04X}",
            "kernal_slice_sha256": hashlib.sha256(k_slice).hexdigest(),
            "kernal_slice_crc32": f"{zlib.crc32(k_slice) & 0xFFFFFFFF:08x}",
            "matching_bytes": 4096 - len(diff_positions),
            "differing_bytes": len(diff_positions),
            "exact_match": len(diff_positions) == 0
        })

    cross_verification = {
        "z80bios_size": len(z80_data),
        "z80bios_sha256": hashlib.sha256(z80_data).hexdigest(),
        "z80bios_crc32": f"{zlib.crc32(z80_data) & 0xFFFFFFFF:08x}",
        "exact_embedded_offset_in_kernal": f"0x{exact_offset:04X}" if exact_offset != -1 else None,
        "exact_embedded_cpu_range_in_kernal": f"0x{0xC000+exact_offset:04X}-0x{0xC000+exact_offset+4095:04X}" if exact_offset != -1 else None,
        "4kb_slice_comparisons": slice_comparisons
    }

    # Write reports/rom_checksums.json
    with open(os.path.join(WORKSPACE, "reports", "rom_checksums.json"), "w", encoding="utf-8") as f:
        json.dump({
            "project": "cbm-128-core",
            "target": "Commodore 128 (1985 Original Firmware Revision)",
            "total_roms": len(checksum_records),
            "total_bytes": sum(r["size_bytes"] for r in checksum_records),
            "roms": checksum_records,
            "cross_image_verification": cross_verification
        }, f, indent=2)

    # Write reports/rom_inventory.csv
    csv_fields = [
        "filename", "part_number", "revision", "purpose", "socket",
        "size_bytes", "expected_size_bytes", "size_match",
        "cpu_address_start", "cpu_address_end",
        "crc32", "md5", "sha1", "sha256",
        "sum16_hex", "shannon_entropy_bits_per_byte",
        "unique_byte_values", "padding_ff_bytes", "padding_00_bytes", "padding_aa_bytes"
    ]
    with open(os.path.join(WORKSPACE, "reports", "rom_inventory.csv"), "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=csv_fields)
        writer.writeheader()
        for r in checksum_records:
            writer.writerow({k: r[k] for k in csv_fields})

    # Write detailed evidence to REA/EVIDENCE/PHASE1/forensics_raw.json
    with open(os.path.join(WORKSPACE, "REA", "EVIDENCE", "PHASE1", "forensics_raw.json"), "w", encoding="utf-8") as f:
        json.dump({
            "detailed_forensics": detailed_forensics,
            "cross_verification": cross_verification
        }, f, indent=2)

    print("Forensics analysis complete.")
    for r in checksum_records:
        print(f"{r['filename']:28s} | {r['size_bytes']:6d} B | CRC32: {r['crc32']} | SHA256: {r['sha256'][:16]}... | H={r['shannon_entropy_bits_per_byte']}")
    print(f"z80bios.bin exact match in kernal.318020-03.bin at offset: {cross_verification['exact_embedded_offset_in_kernal']}")

if __name__ == "__main__":
    main()
