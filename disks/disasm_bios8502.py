import os

with open('D:/Emulation/C128/disks/bios8502_runtime.bin', 'rb') as f:
    code = f.read()

# Vector table starts after the first entry stub:
# $2600: A2 FF     LDX #$FF
# $2602: 9A        TXS
# $2603: 20 37 26  JSR $2637
# $2606: 78        SEI
# $2607: A2 3E     LDX #$3E
# $2609: 8E 00 FF  STX $FF00
# $260C: A2 82     LDX #$82
# $260E: 8E 0D DC  STX $DC0D
# $2611: 4C D6 FF  JMP $FFD6  ; (Switches to Z80!)

# Next is the jump/vector table at $2614:
print("Vector table at $2614:")
for i in range(0, 32, 2):
    vec = code[0x14 + i] | (code[0x15 + i] << 8)
    print(f"  Vec {i//2}: 0x{vec:04X}")

# What calls $FFDC?
# When Z80 calls $FFE0, 8502 wakes up at $FFDB (NOP) -> JMP $FFDC (JMP $2600)
# Then $2600 runs, does JSR $2637, and returns to Z80!
# What about subsequent calls? Look at $2637:
print("\nBytes at $2637 (hex):", code[0x37:0x37+32].hex(' '))
