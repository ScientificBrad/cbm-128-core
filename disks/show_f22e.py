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

for a in range(0xF225, 0xF245):
    print(f"{a:04X}: {mem[a]:02X}")
