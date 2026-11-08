import os, sys
WORKSPACE = r'D:\Emulation\C128'
sys.path.insert(0, os.path.join(WORKSPACE, 'src'))
from cbm128 import Commodore128Machine

m = Commodore128Machine(WORKSPACE)
m.reset()
m.run_until_ready(3_000_000)

with open(os.path.join(WORKSPACE, 'games', 'kik_extracted', 'KIKSTART128_C64_.prg'), 'rb') as f:
    data = f.read()
load_addr = data[0] | (data[1] << 8)
payload = data[2:]
for i, b in enumerate(payload):
    m.mmu.ram[0][load_addr + i] = b

orig_w = m.mmu.write8
def custom_w(addr, val, z80_mode=False):
    addr &= 0xFFFF
    if 0xFF00 <= addr <= 0xFF04 or 0xD500 <= addr <= 0xD50B:
        m.mmu.ram[0][addr] = val
        return
    orig_w(addr, val, z80_mode)

m.mmu.write8 = custom_w
m.mmu.cr = 0x3E
m.m8502.pc = 0x080B
while m.m8502.pc != 0xC000: m.m8502.step()
m.m8502.pc = 0xC00D
while m.m8502.pc != 0x3600: m.m8502.step()
while m.m8502.pc != 0x3637: m.m8502.step()

print("At title screen loop! Extracting multicolor bitmap...")

# VIC-II Palette (R, G, B)
VIC_PALETTE = [
    (0, 0, 0),       # 0: Black
    (255, 255, 255), # 1: White
    (136, 0, 0),     # 2: Red
    (170, 255, 238), # 3: Cyan
    (204, 68, 204),  # 4: Purple
    (0, 204, 85),    # 5: Green
    (0, 0, 170),     # 6: Blue
    (238, 238, 119), # 7: Yellow
    (221, 136, 85),  # 8: Orange
    (102, 68, 0),    # 9: Brown
    (255, 119, 119), # 10: Light Red
    (51, 51, 51),    # 11: Dark Grey
    (119, 119, 119), # 12: Medium Grey
    (170, 255, 102), # 13: Light Green
    (0, 136, 255),   # 14: Light Blue
    (187, 187, 187)  # 15: Light Grey
]

# 320x200 image buffer (RGB)
pixels = [[(0,0,0) for _ in range(320)] for _ in range(200)]

bg_color = m.mmu.read8(0xD021) & 0x0F # Blue (6)

# Bank 3: base is $C000.
# $D018 = 0x80 -> Screen at $C000, Bitmap at $E000
screen_base = 0xC000
bitmap_base = 0xE000

for row in range(25):
    for col in range(40):
        cell = row * 40 + col
        screen_byte = m.mmu.ram[0][screen_base + cell]
        color_ram_byte = m.mmu.ram[0][0xD800 + cell] & 0x0F
        col01 = (screen_byte >> 4) & 0x0F
        col10 = screen_byte & 0x0F
        col11 = color_ram_byte
        col00 = bg_color

        color_map = [col00, col01, col10, col11]

        for y in range(8):
            bm_byte = m.mmu.ram[0][bitmap_base + cell * 8 + y]
            py = row * 8 + y
            # 4 pairs of 2 bits each
            p0 = (bm_byte >> 6) & 0x03
            p1 = (bm_byte >> 4) & 0x03
            p2 = (bm_byte >> 2) & 0x03
            p3 = bm_byte & 0x03

            px = col * 8
            rgb0 = VIC_PALETTE[color_map[p0]]
            rgb1 = VIC_PALETTE[color_map[p1]]
            rgb2 = VIC_PALETTE[color_map[p2]]
            rgb3 = VIC_PALETTE[color_map[p3]]

            # Each multicolor pixel is 2 hi-res pixels wide
            pixels[py][px + 0] = rgb0
            pixels[py][px + 1] = rgb0
            pixels[py][px + 2] = rgb1
            pixels[py][px + 3] = rgb1
            pixels[py][px + 4] = rgb2
            pixels[py][px + 5] = rgb2
            pixels[py][px + 6] = rgb3
            pixels[py][px + 7] = rgb3

# Write uncompressed 24-bit BMP file
os.makedirs(os.path.join(WORKSPACE, 'screenshots'), exist_ok=True)
bmp_path = os.path.join(WORKSPACE, 'screenshots', 'kikstart_title.bmp')

width = 320
height = 200
row_padded = (width * 3 + 3) & (~3)
file_size = 54 + row_padded * height

with open(bmp_path, 'wb') as f:
    # BMP Header
    f.write(b'BM')
    f.write(file_size.to_bytes(4, 'little'))
    f.write((0).to_bytes(4, 'little')) # reserved
    f.write((54).to_bytes(4, 'little')) # offset to pixel data
    # DIB Header (BITMAPINFOHEADER)
    f.write((40).to_bytes(4, 'little'))
    f.write(width.to_bytes(4, 'little'))
    f.write(height.to_bytes(4, 'little'))
    f.write((1).to_bytes(2, 'little')) # planes
    f.write((24).to_bytes(2, 'little')) # bpp
    f.write((0).to_bytes(4, 'little')) # compression (none)
    f.write((row_padded * height).to_bytes(4, 'little'))
    f.write((2835).to_bytes(4, 'little')) # 72 DPI
    f.write((2835).to_bytes(4, 'little'))
    f.write((0).to_bytes(4, 'little'))
    f.write((0).to_bytes(4, 'little'))

    # Pixel data bottom-to-top
    for y in range(height - 1, -1, -1):
        row_bytes = bytearray()
        for x in range(width):
            r, g, b = pixels[y][x]
            row_bytes.extend([b, g, r]) # BGR order
        # Padding to 4-byte boundary
        while len(row_bytes) % 4 != 0:
            row_bytes.append(0)
        f.write(row_bytes)

print(f"Saved genuine VIC-II title screen screenshot to {bmp_path} ({os.path.getsize(bmp_path)} bytes)!")
