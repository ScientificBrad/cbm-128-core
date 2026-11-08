import os

with open('D:/Emulation/C128/kernal.318020-03.bin', 'rb') as f:
    kernal = f.read()

# Let's disassemble KERNAL $F890-$F9A0
# $F890 offset in kernal is $F890 - $C000 = $3890
start = 0xF890 - 0xC000
bytes_code = kernal[start:start+180]

print("Length:", len(bytes_code))
# Let's see instructions around $F890:
# We know:
# $F890: 85 BF       STA $BF
# $F892: 86 BA       STX $BA
# $F894: 8A          TXA
# $F895: 20 3D F2    JSR $F23D (CLOSE all channels)
# Then it opens channel 15 on device 8 and reads Track 1 Sector 0!
# Where does it check the CBM signature?
# Let's search for E2 C4 ($E2C4 is "CBM")
cbm_ref = bytes_code.find(b'\xc4\xe2')
print("Reference to $E2C4 ('CBM'): offset", hex(cbm_ref) if cbm_ref != -1 else "not found")
if cbm_ref != -1:
    print("Around CBM check:", bytes_code[cbm_ref-8:cbm_ref+24].hex(' '))
