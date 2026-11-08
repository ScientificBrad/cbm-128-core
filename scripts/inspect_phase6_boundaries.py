"""Inspect $FAC0-$BB35 in basic_high."""
import sys
from pathlib import Path

ROOT = Path(r"D:\Emulation\C128")
sys.path.insert(0, str(ROOT / "scripts"))
from inspect_basic70 import disasm_range

disasm_range(0xBAC0, 0xBB35, "ML Monitor @ command ($BAC0-$BB35)")
