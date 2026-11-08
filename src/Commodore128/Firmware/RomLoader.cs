using System;
using System.IO;

namespace Commodore128.Firmware;

public sealed record C128FirmwareSet(
    byte[] BasicLow,
    byte[] BasicHigh,
    byte[] Kernal,
    byte[] Characters,
    byte[] Z80Bios);

public static class RomLoader
{
    public static C128FirmwareSet LoadFromDirectory(string directoryPath, bool strictChecksum = false)
    {
        if (string.IsNullOrWhiteSpace(directoryPath) || !Directory.Exists(directoryPath))
            throw new DirectoryNotFoundException($"ROM directory not found: '{directoryPath}'. Supply a valid path via CLI argument or C128_ROM_DIR.");

        byte[] bLo = LoadAndVerify(directoryPath, "basic-4000.318018-02.bin", 16384, strictChecksum);
        byte[] bHi = LoadAndVerify(directoryPath, "basic-8000.318019-02.bin", 16384, strictChecksum);
        byte[] krn = LoadAndVerify(directoryPath, "kernal.318020-03.bin", 16384, strictChecksum);
        byte[] chr = LoadAndVerify(directoryPath, "characters.390059-01.bin", 8192, strictChecksum);

        string z80Path = Path.Combine(directoryPath, "z80bios.bin");
        byte[] z80;
        if (File.Exists(z80Path))
        {
            z80 = LoadAndVerify(directoryPath, "z80bios.bin", 4096, strictChecksum);
        }
        else
        {
            z80 = new byte[4096];
            Array.Copy(krn, 0x1000, z80, 0, 4096);
        }

        return new C128FirmwareSet(bLo, bHi, krn, chr, z80);
    }

    private static byte[] LoadAndVerify(string dir, string fileName, int expectedLen, bool strictChecksum)
    {
        string fullPath = Path.Combine(dir, fileName);
        if (!File.Exists(fullPath))
            throw new FileNotFoundException($"Required Commodore 128 ROM file missing: '{fullPath}'", fullPath);

        byte[] data = File.ReadAllBytes(fullPath);
        var report = RomVerifier.Verify(fileName, data, expectedLen, strictChecksum);
        if (report.ErrorMessage is not null)
            throw new InvalidDataException(report.ErrorMessage);

        return data;
    }
}
