with open('D:/Emulation/C128/disks/cpm_1985.d64', 'rb') as f:
    data = f.read()

# 21 sector interleave table from z80bios.bin ($0FB5):
table_21 = [0, 5, 10, 15, 20, 4, 9, 14, 19, 3, 8, 13, 18, 2, 7, 12, 17, 1, 6, 11, 16]

# Sectors per track on 1541:
# Tracks 1-17: 21 sectors
# Track 18-24: 19 sectors
# Track 25-30: 18 sectors
# Track 31-35: 17 sectors

def track_sector_offset(track, sector):
    # track is 1-based, sector is 0-based
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
    # Track 1 has 21 sectors (log_sec 0..20)
    # Track 1 is base track
    phys_sec = table_21[log_sec % 21]
    track = 1 + (log_sec // 21)
    # Skip track 18 if crossed
    if track >= 18:
        track += 1
    offset = track_sector_offset(track, phys_sec)
    return data[offset:offset+256]

print("--- Reading logical sectors 0..8 (Allocation blocks 0 and 1, CP/M Directory) ---")
for log_sec in range(0, 12):
    sec = read_logical_sector(log_sec)
    print(f"\nLogical Sector {log_sec} (Track {1 + log_sec//21}, Phys Sector {table_21[log_sec%21]}):")
    if log_sec == 0:
        print("  Sig:", sec[:3].decode('ascii', errors='replace'), "Byte 255:", hex(sec[255]))
    for e in range(0, 256, 32):
        ent = sec[e:e+32]
        if ent[0] == 0xE5:
            continue
        name = ''.join(chr(b & 0x7F) if 32 <= (b & 0x7F) < 127 else '.' for b in ent[1:12])
        blocks = [b for b in ent[16:32] if b != 0]
        print(f"  User={ent[0]:02X} Name=\"{name}\" Ext={ent[12]:02X} Recs={ent[15]:02X} Blocks={blocks}")
