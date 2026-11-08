import os

def read_d64_dir(d64_path):
    with open(d64_path, 'rb') as f:
        data = f.read()
    # Track 18, sector 0 is BAM (offset: sectors 1..17 have 21 sectors each = 17*21 = 357 * 256 = 0x16500)
    bam_offset = 357 * 256
    disk_name = data[bam_offset + 0x90 : bam_offset + 0xA0].decode('latin1', errors='replace')
    disk_id = data[bam_offset + 0xA2 : bam_offset + 0xA7].decode('latin1', errors='replace')
    
    # Track 1 sector 0: Boot sector
    boot_sig = data[0:16].hex(' ')
    boot_ascii = ''.join(chr(b) if 32 <= b <= 126 else '.' for b in data[0:32])
    
    # Read directory entries (Track 18, Sector 1 onwards)
    dir_files = []
    curr_t, curr_s = 18, 1
    while curr_t != 0:
        # compute offset
        sec_before = 0
        for t in range(1, curr_t):
            if t <= 17: sec_before += 21
            elif t <= 24: sec_before += 19
            elif t <= 30: sec_before += 18
            else: sec_before += 17
        if curr_t < 1 or curr_t > 35: break
        off = (sec_before + curr_s) * 256
        if off >= len(data): break
        next_t = data[off]
        next_s = data[off + 1]
        
        for entry_idx in range(8):
            eoff = off + entry_idx * 32
            ftype = data[eoff + 2]
            if ftype != 0:
                raw_name = data[eoff + 5 : eoff + 21]
                fname = ''.join(chr(b) if 32 <= b <= 126 else '?' for b in raw_name).rstrip('\xa0').rstrip()
                blocks = data[eoff + 0x1E] | (data[eoff + 0x1F] << 8)
                dir_files.append((fname, blocks, ftype & 0x07))
        curr_t, curr_s = next_t, next_s
        if len(dir_files) > 100: break
        
    return disk_name, disk_id, boot_sig, boot_ascii, dir_files

for name in ['cpm_1985.d64', 'cpm.system.622-580745.d64', 'cpm_1987.d64', 'cpm_28may87_extracted.d64', 'cpm.utilities.d64']:
    path = os.path.join('disks', name)
    dname, did, bsig, bascii, files = read_d64_dir(path)
    print(f"=== {name} ===")
    print(f"Disk Name: '{dname}' ID: '{did}'")
    print(f"Boot header (T1 S0): {bsig}")
    print(f"Boot ASCII: {bascii}")
    print(f"Files ({len(files)}):")
    for fn, blk, ft in files:
        print(f"  {fn:<20} {blk:>3} blocks (type {ft})")
    print()
