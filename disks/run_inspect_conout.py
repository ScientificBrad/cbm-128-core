with open('D:/Emulation/C128/disks/inspect_f000.py', 'r') as f:
    s = f.read()

# Let's inspect $F0DA
# In mem_common, $F0DA is at offset $F0DA - $EA00 = $06DA
s += """
f0da_off = 0xF0DA - 0xEA00
print("Bytes at $F0DA (CONOUT):", mem_common[f0da_off:f0da_off+32].hex(' '))
"""
with open('D:/Emulation/C128/disks/inspect_conout.py', 'wb') as f:
    f.write(s.encode('utf-8'))
