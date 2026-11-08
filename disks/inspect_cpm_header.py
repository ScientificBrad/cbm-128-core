with open('D:/Emulation/C128/disks/cpm_1985.d64', 'rb') as f:
    data = f.read()

table_21 = [0, 5, 10, 15, 20, 4, 9, 14, 19, 3, 8, 13, 18, 2, 7, 12, 17, 1, 6, 11, 16]

def track_sector_offset(track, sector):
    sectors_before = 0
    for t in range(1, track):
        if t <= 17:
            sectors_before += 21
        elif t <= 24:
            sectors_before += 19
        elif t <= 30:
            sectors_before += 18
        else:
            sectors_before += 17
    return (sectors_before + sector) * 256

def read_logical_sector(log_sec):
    phys_sec = table_21[log_sec % 21]
    track = 1 + (log_sec // 21)
    if track >= 18:
        track += 1
    offset = track_sector_offset(track, phys_sec)
    return data[offset:offset+256]

sec8 = read_logical_sector(8)
print("Logical Sector 8 (Start of CPM+.SYS, Block 2):")
print("Hex header (16 bytes):", sec8[:16].hex(' '))
print("Decoded 12-byte header:")
print("  COMMON_LOAD_HI:   ", hex(sec8[0]))
print("  COMMON_LEN_PAGES: ", hex(sec8[1]), f"({sec8[1]} pages = {sec8[1]*256} bytes)")
print("  BANKED_LOAD_HI:   ", hex(sec8[2]))
print("  BANKED_LEN_PAGES: ", hex(sec8[3]), f"({sec8[3]} pages = {sec8[3]*256} bytes)")
print("  CPM_ENTRY_ADDR:   ", hex(sec8[4] | (sec8[5] << 8)))
print("  BIOS8502_LOAD_HI: ", hex(sec8[6]))
print("  BIOS8502_LEN_PAGES:", hex(sec8[7]), f"({sec8[7]} pages = {sec8[7]*256} bytes)")
print("  DATA_TABLES_HI:   ", hex(sec8[8]))
print("  DATA_TABLES_LEN:  ", hex(sec8[9]), f"({sec8[9]} pages = {sec8[9]*256} bytes)")
print("  CPM_INFO_WORD:    ", hex(sec8[10] | (sec8[11] << 8)))

print("\nOffset +128 in Block 2 (Banner string):")
print(repr(sec8[128:256].split(b'\x00')[0].decode('ascii', errors='replace')))
