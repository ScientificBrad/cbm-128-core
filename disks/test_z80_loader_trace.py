import sys
sys.path.insert(0, 'D:/Emulation/C128')

# Let's verify how z80bios.bin executes RST $08
with open('D:/Emulation/C128/z80bios.bin', 'rb') as f:
    rom = f.read()

print("Length of z80bios.bin:", len(rom))
print("Bytes at $0008 (RST 08):", rom[8:16].hex(' '))
print("Bytes at $018C (CPM_BOOT_INIT):", rom[0x018C:0x018C+16].hex(' '))
