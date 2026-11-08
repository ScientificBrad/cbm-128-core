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

cpm_blocks = list(range(2, 27))
cpm_data = bytearray()
for blk in cpm_blocks:
    for s in range(4):
        cpm_data.extend(read_cpm_logical_sector(blk * 4 + s))

# COMMON CODE: offset = 256 + 1024 = 1280, length = 4608 (36 records = 18 pages)
# Loaded descending from $FC00 down to $EA00!
# Record 0 goes to $FC00 - $80 = $FB80
# Record 1 goes to $FB00
# ...
# Where does $F000 land?
# $FC00 - $F000 = $0C00 (3072 bytes = 24 records = 12 pages)
# Record index for $F000:
# The record that starts at $F000 is loaded when HL - 128 = $F000, so HL was $F080!
# That means 23 records before it ($FC00 - 23*128 = $F080).
# The record loaded to $F000..$F07F is Record 23 (offset 23 * 128 = 2944)!
cc_records = cpm_data[1280:1280+4608]
mem_common = bytearray(4608)
for r in range(36):
    dest = 0xFC00 - (r + 1) * 128
    rec = cc_records[r*128:(r+1)*128]
    mem_common[dest - 0xEA00 : dest - 0xEA00 + 128] = rec

f000_offset = 0xF000 - 0xEA00
print("Bytes at $F000 (hex):", mem_common[f000_offset:f000_offset+32].hex(' '))

f0da_off = 0xF0DA - 0xEA00
print("Bytes at $F0DA (CONOUT):", mem_common[f0da_off:f0da_off+32].hex(' '))
