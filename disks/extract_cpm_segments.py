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

# Read directory to find all blocks of CPM+.SYS
# Extent 0: blocks [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17]
# Extent 1: blocks [18, 19, 20, 21, 22, 23, 24, 25, 26]
cpm_blocks = list(range(2, 27))
print(f"Reading {len(cpm_blocks)} allocation blocks of CPM+.SYS...")

cpm_data = bytearray()
for blk in cpm_blocks:
    for s in range(4):
        log_sec = blk * 4 + s
        cpm_data.extend(read_cpm_logical_sector(log_sec))

print(f"Total CPM+.SYS payload: {len(cpm_data)} bytes ({len(cpm_data)//128} records)")

# Let's inspect the segments as loaded by Z80 BIOS:
# Header is at offset 0:
# [0] COMMON_LOAD_HI = 0xFC, [1] COMMON_LEN_PAGES = 0x12
# [2] BANKED_LOAD_HI = 0xE0, [3] BANKED_LEN_PAGES = 0x47
# [4..5] ENTRY = 0xF000
# [6] BIOS8502_LOAD_HI = 0x2B, [7] BIOS8502_LEN_PAGES = 0x05
# [8] DATA_TABLES_HI = 0x10, [9] DATA_TABLES_LEN = 0x04
# [10..11] INFO = 0x1290

# Records start at offset +256 (record index 2)
# 1. DATA TABLES: loaded ascending into DATA_TABLES_HI ($1000)
# DATA_TABLES_LEN = 4 pages = 8 records (1024 bytes)
rec_offset = 256
dt_len = 0x04 * 256
dt_bytes = cpm_data[rec_offset:rec_offset+dt_len]
rec_offset += dt_len
print(f"1. DATA TABLES: offset +256, {dt_len} bytes -> loads into $1000..$13FF")

# 2. COMMON CODE: loaded descending from COMMON_LOAD_HI ($FC00)
# COMMON_LEN_PAGES = 0x12 (18 pages = 4608 bytes = 36 records)
cc_len = 0x12 * 256
cc_bytes = cpm_data[rec_offset:rec_offset+cc_len]
rec_offset += cc_len
print(f"2. COMMON CODE: {cc_len} bytes -> loads descending from $FC00 down to $EA00")

# 3. BANKED CODE: loaded descending from BANKED_LOAD_HI ($E000)
# BANKED_LEN_PAGES = 0x47 (71 pages = 18176 bytes = 142 records)
bc_len = 0x47 * 256
bc_bytes = cpm_data[rec_offset:rec_offset+bc_len]
rec_offset += bc_len
print(f"3. BANKED CODE: {bc_len} bytes -> loads descending from $E000 down to $9900")

# 4. BIOS8502 CODE: loaded descending from BIOS8502_LOAD_HI ($2B00)
# BIOS8502_LEN_PAGES = 0x05 (5 pages = 1280 bytes = 10 records)
b85_len = 0x05 * 256
b85_bytes = cpm_data[rec_offset:rec_offset+b85_len]
rec_offset += b85_len
print(f"4. BIOS8502 CODE: {b85_len} bytes -> loads descending from $2B00 down to $2600")

# Let's inspect the start of BIOS8502 CODE (which lands at $2600)
# Because it was loaded descending:
# Record 0 was loaded into $2AF0, Record 1 into $2A70 ... last record into $2600!
# So $2600 is at the END of b85_bytes!
# Let's check how the Z80 loader does descending:
# LD DE, $FF80; ADD HL, DE; CALL $0344 (reads 128 bytes into (HL))
# So the first record read goes to (LOAD_HI << 8) - 128 ($2B00 - $80 = $2A80)
# The second record goes to $2A00, etc., and the LAST record goes to $2600!
# That means in memory, $2600 has the bytes from the LAST record read!
last_128 = b85_bytes[-128:]
print("\nFirst 32 bytes of 8502 BIOS code at $2600 (hex):", last_128[:32].hex(' '))
