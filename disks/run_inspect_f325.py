with open('D:/Emulation/C128/disks/inspect_f000.py', 'r') as f:
    s = f.read()

s += """
f325_off = 0xF325 - 0xEA00
print("Bytes at $F325:", mem_common[f325_off:f325_off+64].hex(' '))
"""

with open('D:/Emulation/C128/disks/inspect_f325.py', 'wb') as f:
    f.write(s.encode('utf-8'))
