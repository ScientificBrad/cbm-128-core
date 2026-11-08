with open('D:/Emulation/C128/disks/inspect_f000.py', 'r') as f:
    s = f.read()

s += """
f16f_off = 0xF16F - 0xEA00
print("Bytes at $F16F (CONST):", mem_common[f16f_off:f16f_off+32].hex(' '))
f188_off = 0xF188 - 0xEA00
print("Bytes at $F188 (CONIN):", mem_common[f188_off:f188_off+32].hex(' '))
"""

with open('D:/Emulation/C128/disks/inspect_conin.py', 'wb') as f:
    f.write(s.encode('utf-8'))
