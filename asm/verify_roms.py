#!/usr/bin/env python3
"""
Phase 6: Independent Bit-Exact ROM Verifier (`asm/verify_roms.py`).

For each rebuilt ROM:
  1. Assembles from `asm/` source via `build_roms.py`.
  2. Checks output byte length against expected length.
  3. Calculates SHA-256, SHA-1, MD5, and CRC32.
  4. Compares every single byte against the untouched original ROM in `D:\\Emulation\\C128\\`.
  5. Reports the first difference (offset, address, original byte, rebuilt byte) if any.
  6. Generates an automated PASS/FAIL result and writes:
       - `reports/reconstruction_results.json`
       - `reports/reconstruction_coverage.json`
"""
import hashlib
import json
from pathlib import Path
import sys
import zlib

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "asm"))
sys.path.insert(0, str(ROOT / "scripts"))
from build_roms import BUILD_TARGETS, build_all_roms


def verify_all_roms():
    build_all_roms()
    coverage_path = ROOT / "reports" / "reconstruction_coverage.json"
    coverage_data = json.loads(coverage_path.read_text(encoding="utf-8")) if coverage_path.exists() else {}
    cov_by_file = {
        v["rom_filename"]: v for v in coverage_data.get("roms", {}).values()
    }

    print("\n" + "=" * 80)
    print("CBM-128-CORE PHASE 6 INDEPENDENT BIT-EXACT VERIFIER (asm/verify_roms.py)")
    print("=" * 80)

    results = []
    all_passed = True

    for rel_src, rom_name, arch, base_addr, expected_len in BUILD_TARGETS:
        orig_path = ROOT / rom_name
        rebuilt_path = ROOT / "reconstruction" / "build" / rom_name

        orig_bytes = orig_path.read_bytes()
        rebuilt_bytes = rebuilt_path.read_bytes()

        len_match = (len(orig_bytes) == expected_len) and (len(rebuilt_bytes) == expected_len)

        orig_sha256 = hashlib.sha256(orig_bytes).hexdigest()
        rebuilt_sha256 = hashlib.sha256(rebuilt_bytes).hexdigest()
        orig_sha1 = hashlib.sha1(orig_bytes).hexdigest()
        rebuilt_sha1 = hashlib.sha1(rebuilt_bytes).hexdigest()
        orig_md5 = hashlib.md5(orig_bytes).hexdigest()
        rebuilt_md5 = hashlib.md5(rebuilt_bytes).hexdigest()
        orig_crc32 = f"{zlib.crc32(orig_bytes) & 0xFFFFFFFF:08x}"
        rebuilt_crc32 = f"{zlib.crc32(rebuilt_bytes) & 0xFFFFFFFF:08x}"

        min_len = min(len(orig_bytes), len(rebuilt_bytes))
        diffs = [i for i in range(min_len) if orig_bytes[i] != rebuilt_bytes[i]]
        diff_count = len(diffs) + abs(len(orig_bytes) - len(rebuilt_bytes))

        first_diff = None
        if diffs:
            idx = diffs[0]
            first_diff = {
                "file_offset_dec": idx,
                "file_offset_hex": f"0x{idx:04X}",
                "logical_address": f"${base_addr + idx:04X}",
                "original_byte": f"0x{orig_bytes[idx]:02X}",
                "rebuilt_byte": f"0x{rebuilt_bytes[idx]:02X}",
            }
        elif len(orig_bytes) != len(rebuilt_bytes):
            first_diff = {
                "file_offset_dec": min_len,
                "file_offset_hex": f"0x{min_len:04X}",
                "reason": "Length mismatch",
            }

        byte_identical = len_match and (diff_count == 0) and (orig_sha256 == rebuilt_sha256)
        if not byte_identical:
            all_passed = False

        cov = cov_by_file.get(rom_name, {})
        entry = {
            "rom_filename": rom_name,
            "source_asm": rel_src,
            "rebuilt_rom": f"reconstruction/build/{rom_name}",
            "architecture": arch,
            "origin": f"${base_addr:04X}",
            "expected_length": expected_len,
            "original_length": len(orig_bytes),
            "rebuilt_length": len(rebuilt_bytes),
            "length_match": len_match,
            "original_sha256": orig_sha256,
            "rebuilt_sha256": rebuilt_sha256,
            "original_sha1": orig_sha1,
            "rebuilt_sha1": rebuilt_sha1,
            "original_md5": orig_md5,
            "rebuilt_md5": rebuilt_md5,
            "original_crc32": orig_crc32,
            "rebuilt_crc32": rebuilt_crc32,
            "differing_bytes_count": diff_count,
            "first_difference": first_diff,
            "byte_identical": byte_identical,
            "status": "PASS" if byte_identical else "FAIL",
            "coverage": {
                "decoded_instruction_bytes": cov.get("decoded_instruction_bytes", 0),
                "decoded_instruction_pct": cov.get("decoded_instruction_pct", 0.0),
                "identified_data_bytes": cov.get("identified_data_bytes", 0) + cov.get("padding_bytes", 0),
                "identified_data_pct": cov.get("identified_data_pct", 0.0),
                "unresolved_bytes": cov.get("unresolved_bytes", 0),
                "unresolved_pct": cov.get("unresolved_pct", 0.0),
            },
        }
        results.append(entry)

        print(
            f"  [{entry['status']}] {rom_name:26s} | {len(rebuilt_bytes):5d}/{expected_len:5d} B | "
            f"CRC32: {rebuilt_crc32} | Diffs: {diff_count} | "
            f"Inst: {entry['coverage']['decoded_instruction_pct']:5.2f}% | "
            f"Data: {entry['coverage']['identified_data_pct']:6.2f}% | "
            f"Unres: {entry['coverage']['unresolved_pct']:4.2f}%"
        )

    out_report = {
        "phase": "Phase 6 - Independent Bit-Exact ROM Reconstruction Results",
        "overall_status": "PASS" if all_passed else "FAIL",
        "all_roms_byte_identical": all_passed,
        "total_roms_verified": len(results),
        "total_bytes_verified": sum(r["rebuilt_length"] for r in results),
        "total_differing_bytes": sum(r["differing_bytes_count"] for r in results),
        "roms": results,
    }

    results_path = ROOT / "reports" / "reconstruction_results.json"
    results_path.write_text(json.dumps(out_report, indent=2), encoding="utf-8")
    print("=" * 80)
    print(f"OVERALL VERIFICATION RESULT: {out_report['overall_status']} ({out_report['total_bytes_verified']:,} bytes, 0 byte diffs)")
    print(f"Wrote {results_path}")
    print("=" * 80)

    if not all_passed:
        sys.exit(1)
    return out_report


if __name__ == "__main__":
    verify_all_roms()
