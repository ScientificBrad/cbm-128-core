with open('D:/Emulation/C128/disks/cpm_1985.d64', 'rb') as f:
    data = f.read()

table_21 = [0, 5, 10, 15, 20, 4, 9, 14, 19, 3, 8, 13, 18, 2, 7, 12, 17, 1, 6, 11, 16]
table_19 = [0, 5, 10, 15, 1, 6, 11, 16, 2, 7, 12, 17, 3, 8, 13, 18, 4, 9, 14]
table_18 = [0, 5, 10, 15, 2, 7, 12, 17, 4, 9, 14, 1, 6, 11, 16, 3, 8, 13]
table_17 = [0, 5, 10, 15, 3, 8, 13, 1, 6, 11, 16, 4, 9, 14, 2, 7, 12]

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

def z80_logical_to_track_sector(log_sec):
    # Exact Z80 routine $03E3
    side_offset = 0x23 # 35
    hl = log_sec
    if hl >= 0x02A8:
        hl -= 0x02A8
    else:
        side_offset = 0
    hl += 2

    # Zone checks
    if hl < 0x0165:
        # Zone 0: 21 sectors/track, base track 0
        b, c = 21, 0
    else:
        hl -= 0x0165
        hl += 1 # crossing track 17
        if hl < 0x0085:
            # Zone 1: 19 sectors/track, base track 17
            b, c = 19, 17
        else:
            hl -= 0x0085
            if hl < 0x006C:
                # Zone 2: 18 sectors/track, base track 24
                b, c = 18, 24
            else:
                hl -= 0x006C
                # Zone 3: 17 sectors/track, base track 30
                b, c = 17, 30

    e = b
    while hl >= e:
        c += 1
        hl -= e
    c += 1 # 1-based track
    track = side_offset + c
    sec_idx = hl

    if e == 21:
        phys_sec = table_21[sec_idx]
    elif e == 19:
        phys_sec = table_19[sec_idx]
    elif e == 18:
        phys_sec = table_18[sec_idx]
    else:
        phys_sec = table_17[sec_idx]

    return track, phys_sec

def read_cpm_logical_sector(log_sec):
    t, s = z80_logical_to_track_sector(log_sec)
    off = track_sector_offset(t, s)
    return data[off:off+256], t, s

# Now let's read Block 2 (logical sectors 8, 9, 10, 11) - start of CPM+.SYS!
sec8, t, s = read_cpm_logical_sector(8)
print(f"CPM+.SYS Start -> Logical Sector 8 = Track {t}, Sector {s}:")
print("16-byte header:", sec8[:16].hex(' '))
print("Decoded 12-byte header:")
print("  COMMON_LOAD_HI:    0x{:02X}".format(sec8[0]))
print("  COMMON_LEN_PAGES:  0x{:02X} ({} pages = {} bytes)".format(sec8[1], sec8[1], sec8[1]*256))
print("  BANKED_LOAD_HI:    0x{:02X}".format(sec8[2]))
print("  BANKED_LEN_PAGES:  0x{:02X} ({} pages = {} bytes)".format(sec8[3], sec8[3], sec8[3]*256))
entry_addr = sec8[4] | (sec8[5] << 8)
print("  CPM_ENTRY_ADDR:    0x{:04X}".format(entry_addr))
print("  BIOS8502_LOAD_HI:  0x{:02X}".format(sec8[6]))
print("  BIOS8502_LEN_PAGES: 0x{:02X} ({} pages = {} bytes)".format(sec8[7], sec8[7], sec8[7]*256))
print("  DATA_TABLES_HI:    0x{:02X}".format(sec8[8]))
print("  DATA_TABLES_LEN:   0x{:02X} ({} pages = {} bytes)".format(sec8[9], sec8[9], sec8[9]*256))
info_word = sec8[10] | (sec8[11] << 8)
print("  CPM_INFO_WORD:     0x{:04X}".format(info_word))

banner = sec8[128:256].split(b'\x00')[0]
print("\nBanner at offset +128:")
print("Text:", banner.decode('ascii', errors='replace'))
