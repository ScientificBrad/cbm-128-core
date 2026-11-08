with open('D:/Emulation/C128/kernal.318020-03.bin', 'rb') as f:
    kernal = f.read()

# Let's search for CD 02 ($02CD) in kernal
hits = []
for i in range(len(kernal)-2):
    if kernal[i] == 0xCD and kernal[i+1] == 0x02:
        hits.append(hex(0xC000 + i))
print("Hits for $02CD in KERNAL:", hits)
