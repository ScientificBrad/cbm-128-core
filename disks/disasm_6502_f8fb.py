with open('D:/Emulation/C128/kernal.318020-03.bin', 'rb') as f:
    kernal = f.read()

# Disassemble from $F8FB
start_pc = 0xF8FB
off = start_pc - 0xC000
chunk = kernal[off:off+140]

import dis
# 6502 simple disasm
opcodes = {
    0xBD: ("LDA abs,X", 3), 0xDD: ("CMP abs,X", 3), 0xD0: ("BNE rel", 2),
    0xE8: ("INX", 1), 0xE0: ("CPX imm", 2), 0x90: ("BCC rel", 2),
    0x20: ("JSR abs", 3), 0x95: ("STA zpg,X", 2), 0xA5: ("LDA zpg", 2),
    0x85: ("STA zpg", 2), 0xF0: ("BEQ rel", 2), 0xC6: ("DEC zpg", 2),
    0xE6: ("INC zpg", 2), 0xA6: ("LDX zpg", 2), 0x2C: ("BIT abs", 3),
    0xA9: ("LDA imm", 2), 0x9D: ("STA abs,X", 3), 0xCA: ("DEX", 1),
    0xAA: ("TAX", 1), 0x8A: ("TXA", 1), 0xA0: ("LDY imm", 2),
    0x18: ("CLC", 1), 0x60: ("RTS", 1), 0x4C: ("JMP abs", 3),
    0x6C: ("JMP (abs)", 3), 0x08: ("PHP", 1), 0x48: ("PHA", 1)
}

pc = start_pc
idx = 0
while idx < len(chunk):
    op = chunk[idx]
    if op in opcodes:
        name, length = opcodes[op]
        operands = chunk[idx+1:idx+length]
        print(f"${pc:04X}: {chunk[idx:idx+length].hex(' '):10} {name} {operands.hex(' ')}")
        idx += length
        pc += length
    else:
        print(f"${pc:04X}: {op:02X} (unknown)")
        idx += 1
        pc += 1
