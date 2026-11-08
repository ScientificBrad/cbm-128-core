with open('D:/Emulation/C128/disks/bios8502_runtime.bin', 'rb') as f:
    code = f.read()

def show_routine(name, addr):
    off = addr - 0x2600
    print(f"\n--- {name} at 0x{addr:04X} ---")
    print(code[off:off+32].hex(' '))

show_routine("Vec 6", 0x271C)
show_routine("Vec 7", 0x274E)
show_routine("Vec 8", 0x2784)
show_routine("Vec 9", 0x27E2)
show_routine("Vec 10", 0x2634)
