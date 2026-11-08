with open('D:/Emulation/C128/kernal.318020-03.bin', 'rb') as f:
    kernal = f.read()

# In 16 KB KERNAL, $C000 is at offset 0, so $F890 is at offset $F890 - $C000 = $3890
off = 0xF890 - 0xC000
bytes_f890 = kernal[off:off+128]
print("$F890 in KERNAL (hex):", bytes_f890[:32].hex(' '))

# Let's see string at $E2C4 ("CBM"):
off_cbm = 0xE2C4 - 0xC000
print("String at $E2C4:", kernal[off_cbm:off_cbm+16])
