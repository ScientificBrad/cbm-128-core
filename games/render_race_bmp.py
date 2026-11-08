import os, struct
from PIL import Image

WORKSPACE = r'D:\Emulation\C128'
with open(os.path.join(WORKSPACE, 'games', 'kik_race_ram.bin'), 'rb') as f:
    ram = f.read()

with open(os.path.join(WORKSPACE, 'games', 'kik_race_color.bin'), 'rb') as f:
    color_ram = f.read()

# Authentic C64 / C128 Pepto palette
PALETTE = [
    (0x00, 0x00, 0x00), # 0 Black
    (0xFF, 0xFF, 0xFF), # 1 White
    (0x88, 0x00, 0x00), # 2 Red
    (0xAA, 0xFF, 0xEE), # 3 Cyan
    (0xCC, 0x44, 0xCC), # 4 Purple
    (0x00, 0xCC, 0x55), # 5 Green
    (0x00, 0x00, 0xAA), # 6 Blue
    (0xEE, 0xEE, 0x77), # 7 Yellow
    (0xDD, 0x88, 0x55), # 8 Orange
    (0x66, 0x44, 0x00), # 9 Brown
    (0xFF, 0x77, 0x77), # 10 Light Red
    (0x33, 0x33, 0x33), # 11 Dark Grey
    (0x77, 0x77, 0x77), # 12 Medium Grey
    (0xAA, 0xFF, 0x66), # 13 Light Green
    (0x00, 0x88, 0xFF), # 14 Light Blue
    (0xBB, 0xBB, 0xBB), # 15 Light Grey
]

# VIC parameters from Frame 200:
# DD00: 0xD6 -> VIC Bank 1 ($4000-$7FFF)
# D018: 0x12 -> Screen at $4400, Char base at $4000 + 1 * 2048 = $4800
# D021: 0x0E (Light Blue)
# D022: 0x01 (White)
# D023: 0x00 (Black)

vic_bank = 0x4000
screen_base = 0x4400
char_base = 0x4800

bg0 = 0x0E # Light blue (sky / track background)
mc1 = 0x01 # White
mc2 = 0x00 # Black

width, height = 320, 200
img = Image.new('RGB', (width, height))
pixels = img.load()

# Render 40x25 character grid
for r in range(25):
    for c in range(40):
        ch = ram[screen_base + r * 40 + c]
        col_attr = color_ram[r * 40 + c] & 0x0F
        is_multicolor = (col_attr >= 8)

        for py in range(8):
            y = r * 8 + py
            pattern = ram[char_base + ch * 8 + py]

            if not is_multicolor:
                for px in range(8):
                    bit = (pattern >> (7 - px)) & 1
                    col_idx = col_attr if bit else bg0
                    pixels[c * 8 + px, y] = PALETTE[col_idx & 0x0F]
            else:
                for px in range(4):
                    bits = (pattern >> (6 - px * 2)) & 3
                    if bits == 0:
                        col_idx = bg0
                    elif bits == 1:
                        col_idx = mc1
                    elif bits == 2:
                        col_idx = mc2
                    else:
                        col_idx = col_attr & 7

                    rgb = PALETTE[col_idx & 0x0F]
                    pixels[c * 8 + px * 2, y] = rgb
                    pixels[c * 8 + px * 2 + 1, y] = rgb

# Render Sprites
# Sprites are enabled: $D015 = 0xFF
# Sprite pointers are at screen_base + 1016 ($47F8..$47FF)
spr_x = [80, 80, 0, 0, 0, 0, 0, 0]
spr_y = [114, 114, 0, 0, 0, 0, 0, 0]
# Read sprite coordinates from VIC registers in I/O space or stored memory
# On Kikstart, sprite 0 & 1 are the motorcycles!
for s in range(8):
    ptr = ram[screen_base + 1016 + s]
    spr_addr = vic_bank + ptr * 64
    sx = spr_x[s]
    sy = spr_y[s]
    if sx > 0 and sy > 0 and sy >= 30:
        # Draw sprite (24x21)
        for srow in range(21):
            row_addr = spr_addr + srow * 3
            b0 = ram[row_addr]
            b1 = ram[row_addr + 1]
            b2 = ram[row_addr + 2]
            row_bits = (b0 << 16) | (b1 << 8) | b2
            for col in range(24):
                if (row_bits >> (23 - col)) & 1:
                    px = sx - 24 + col
                    py = sy - 50 + srow
                    if 0 <= px < 320 and 0 <= py < 200:
                        pixels[px, py] = PALETTE[1] # White / Sprite color

out_png = os.path.join(WORKSPACE, 'screenshots', 'kikstart_race.png')
out_bmp = os.path.join(WORKSPACE, 'screenshots', 'kikstart_race.bmp')
img.save(out_png, 'PNG')
img.save(out_bmp, 'BMP')
print(f"Generated {out_png} ({os.path.getsize(out_png)} bytes) and {out_bmp} ({os.path.getsize(out_bmp)} bytes)!")
