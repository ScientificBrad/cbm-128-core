with open('D:/Emulation/C128/z80bios.bin', 'rb') as f:
    rom = f.read()

# Let's inspect Page $01 table ($0100..$0182)
print("Page $01 vectors:")
for i in range(0, 0x82, 2):
    vec = rom[0x0100 + i] | (rom[0x0101 + i] << 8)
    print(f"  Vec 0x{i:02X}: 0x{vec:04X}")
