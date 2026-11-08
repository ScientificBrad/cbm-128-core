import os

with open('D:/Emulation/C128/disks/cpm_1985.d64', 'rb') as f:
    data = f.read()

print('Length:', len(data))
t1s0 = data[0:256]
print('Track 1 Sector 0 header (hex):', t1s0[:16].hex())
print('Track 1 Sector 0 header (ASCII):', bytes([b if 32 <= b < 127 else 46 for b in t1s0[:32]]).decode('ascii'))
print('Byte 255 (format byte):', hex(t1s0[255]))

print('\n--- CP/M Directory on Track 1 (Sectors 1..3) ---')
for s in range(1, 4):
    sec = data[s*256:(s+1)*256]
    for e in range(0, 256, 32):
        ent = sec[e:e+32]
        if ent[0] == 0xE5:
            continue
        name = ''.join(chr(b & 0x7F) if 32 <= (b & 0x7F) < 127 else '.' for b in ent[1:12])
        blocks = [b for b in ent[16:32] if b != 0]
        print(f'User={ent[0]:02X} Name="{name}" Ext={ent[12]:02X} Recs={ent[15]:02X} Blocks={blocks}')
