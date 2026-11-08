with open('D:/Emulation/C128/disks/inspect_f000.py', 'r') as f:
    s = f.read()

s += """
f371_off = 0xF371 - 0xEA00
print("Bytes at $F371:", mem_common[f371_off:f371_off+48].hex(' '))
"""

with open('D:/Emulation/C128/disks/inspect_f371.py', 'wb') as f:
    f.write(s.encode('utf-8'))
