exec(open('D:/Emulation/C128/disks/extract_cpm_segments.py').read())

mem = bytearray(0x10000)
for r in range(len(cc_bytes) // 128):
    src = r * 128
    dst = 0xFC00 - (r + 1) * 128
    mem[dst:dst+128] = cc_bytes[src:src+128]

for r in range(len(bc_bytes) // 128):
    src = r * 128
    dst = 0xE000 - (r + 1) * 128
    mem[dst:dst+128] = bc_bytes[src:src+128]

# EFC0 word
vec = mem[0xEFC0] | (mem[0xEFC1] << 8)
print(f"EFC0 points to: 0x{vec:04X}")

# What is at F0E9?
print("F0E9..F100:", mem[0xF0E9:0xF100].hex(' '))
