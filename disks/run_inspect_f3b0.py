with open('D:/Emulation/C128/disks/inspect_f000.py', 'r') as f:
    s = f.read()

s += """
f3b0_off = 0xF3B0 - 0xEA00
print("Bytes at $F3B0:", mem_common[f3b0_off:f3b0_off+32].hex(' '))
"""

with open('D:/Emulation/C128/disks/inspect_f3b0.py', 'wb') as f:
    f.write(s.encode('utf-8'))
