with open('D:/Emulation/C128/kernal.318020-03.bin', 'rb') as f:
    kernal = f.read()

# Let's see instructions from $F8FB to $F9A0
# $F8FB offset is $F8FB - $C000 = $38FB
off = 0xF8FB - 0xC000
chunk = kernal[off:off+150]
print("Bytes $F8FB.. (hex):", chunk.hex(' '))
