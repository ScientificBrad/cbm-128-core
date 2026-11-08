import os

with open('D:/Emulation/C128/disks/cpm_1985.d64', 'rb') as f:
    data = f.read()

table_21 = [0, 5, 10, 15, 20, 4, 9, 14, 19, 3, 8, 13, 18, 2, 7, 12, 17, 1, 6, 11, 16]
table_19 = [0, 5, 10, 15, 1, 6, 11, 16, 2, 7, 12, 17, 3, 8, 13, 18, 4, 9, 14]
table_18 = [0, 5, 10, 15, 2, 7, 12, 17, 4, 9, 14, 1, 6, 11, 16, 3, 8, 13]
table_17 = [0, 5, 10, 15, 3, 8, 13, 1, 6, 11, 16, 4, 9, 14, 2, 7, 12]

def track_sector_offset(track, sector):
    sectors_before = 0
    for t in range(1, track):
        if t <= 17: sectors_before += 21
        elif t <= 24: sectors_before += 19
        elif t <= 30: sectors_before += 18
        else: sectors_before += 17
    return (sectors_before + sector) * 256

def z80_logical_to_track_sector(log_sec):
    side_offset = 0x23 if log_sec >= 0x02A8 else 0
    hl = log_sec - 0x02A8 if log_sec >= 0x02A8 else log_sec
    hl += 2
    if hl < 0x0165: b, c = 21, 0
    else:
        hl = hl - 0x0165 + 1
        if hl < 0x0085: b, c = 19, 17
        else:
            hl -= 0x0085
            if hl < 0x006C: b, c = 18, 24
            else:
                hl -= 0x006C
                b, c = 17, 30
    e = b
    while hl >= e:
        c += 1
        hl -= e
    c += 1
    track = side_offset + c
    sec_idx = hl
    if e == 21: phys_sec = table_21[sec_idx]
    elif e == 19: phys_sec = table_19[sec_idx]
    elif e == 18: phys_sec = table_18[sec_idx]
    else: phys_sec = table_17[sec_idx]
    return track, phys_sec

def read_cpm_logical_sector(log_sec):
    t, s = z80_logical_to_track_sector(log_sec)
    off = track_sector_offset(t, s)
    return data[off:off+256]

# Read all 25 blocks of CPM+.SYS
cpm_blocks = list(range(2, 27))
cpm_data = bytearray()
for blk in cpm_blocks:
    for s in range(4):
        cpm_data.extend(read_cpm_logical_sector(blk * 4 + s))

# BIOS8502 segment: 5 pages (1280 bytes = 10 records)
# In cpm_data:
# DATA TABLES: offset 256, len 1024 (record offset 256)
# COMMON CODE: len 4608
# BANKED CODE: len 18176
# BIOS8502: len 1280
offset = 256 + 1024 + 4608 + 18176
b8502_records = cpm_data[offset:offset+1280]

# Remember: loaded descending!
# Record 0 -> $2B00 - $80 = $2A80
# Record 1 -> $2A00
# ...
# Record 9 -> $2600
# Let's reconstruct memory array $2600..$2AFF
mem_2600 = bytearray(1280)
for r in range(10):
    rec_bytes = b8502_records[r*128:(r+1)*128]
    # Address is $2B00 - (r+1)*128
    dest_addr = 0x2B00 - (r + 1) * 128
    offset_in_mem = dest_addr - 0x2600
    mem_2600[offset_in_mem:offset_in_mem+128] = rec_bytes

print("Successfully reconstructed 8502 BIOS code at $2600-$2AFF!")
print("Entry $2600 (first 32 bytes):", mem_2600[:32].hex(' '))

# Let's save to a binary file for disassembly or inspection
with open('D:/Emulation/C128/disks/bios8502_runtime.bin', 'wb') as f:
    f.write(mem_2600)
