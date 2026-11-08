import os

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

def inspect_cpm_dir(disk_path):
    with open(disk_path, 'rb') as f:
        data = f.read()
    # CP/M directory is in Allocation Blocks 0 and 1 (8 sectors = 2048 bytes = 64 directory entries)
    # Logical sectors 0..7
    dir_entries = []
    seen = set()
    for log_sec in range(8):
        t, s = z80_logical_to_track_sector(log_sec)
        off = track_sector_offset(t, s)
        sec = data[off:off+256]
        for e in range(8):
            entry = sec[e*32 : (e+1)*32]
            user = entry[0]
            if user < 16: # valid file entry
                name = ''.join(chr(b & 0x7F) for b in entry[1:9]).strip()
                ext = ''.join(chr(b & 0x7F) for b in entry[9:12]).strip()
                full = f"{name}.{ext}" if ext else name
                rc = entry[15] # record count in extent
                alloc = [b for b in entry[16:32] if b != 0]
                if full not in seen:
                    seen.add(full)
                    dir_entries.append((user, full, rc, alloc))
    return dir_entries

for name in ['cpm_1985.d64', 'cpm.system.622-580745.d64', 'cpm_1987.d64', 'cpm_28may87_extracted.d64', 'cpm.utilities.d64']:
    path = os.path.join('disks', name)
    entries = inspect_cpm_dir(path)
    print(f"=== {name} ({len(entries)} files) ===")
    for u, fn, rc, alloc in entries:
        print(f"  User {u}: {fn:<14} (rc={rc}, blocks={alloc})")
    print()
