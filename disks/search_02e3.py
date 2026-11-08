with open('D:/Emulation/C128/kernal.318020-03.bin', 'rb') as f:
    kernal = f.read()

# Let's search for E3 02 in kernal
hits = []
for i in range(len(kernal)-1):
    if kernal[i] == 0xE3 and kernal[i+1] == 0x02:
        hits.append(hex(0xC000 + i))
print("Hits for $02E3 in KERNAL:", hits)
