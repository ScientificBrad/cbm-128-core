using System;
using System.Collections.Generic;
using System.IO.Hashing;
using System.Security.Cryptography;

namespace Commodore128.Firmware;

public sealed record RomVerificationReport(
    string FileName,
    int ActualLength,
    int ExpectedLength,
    string Sha256,
    bool LengthValid,
    bool ChecksumMatchesKnown1985,
    string? ErrorMessage);

public static class RomVerifier
{
    public static readonly IReadOnlyDictionary<string, (int Length, string Sha256)> Known1985Roms =
        new Dictionary<string, (int, string)>(StringComparer.OrdinalIgnoreCase)
        {
            ["basic-4000.318018-02.bin"] = (16384, "c5ddb7c57dd0b6f259b95b9dd0494ba807cbe6dce8f1f19410a0a05833aa0b5e"),
            ["basic-8000.318019-02.bin"] = (16384, "e1432465b8abafd3397b0e6cb4eb8422449fb3f85c6366e8616b48c35a86ad79"),
            ["kernal.318020-03.bin"]     = (16384, "dcb17b5ce33c2490005b5d0f2a4d767ae56e8ab7ed41d6aa20c43173449e4786"),
            ["characters.390059-01.bin"] = (8192,  "f08d8f525b44f5cbb3f5776739fcdff737886e1813f1eb7a20aedb128db1d4a8"),
            ["z80bios.bin"]              = (4096,  "39c7656b326e4ad724ff4b50c995cb3b2b8ff9ed3bb2b4d277eb0ecd3cac062f"),
        };

    public static RomVerificationReport Verify(string fileName, byte[] data, int expectedLength, bool enforceChecksum = false)
    {
        string sha256 = Convert.ToHexString(SHA256.HashData(data)).ToLowerInvariant();
        bool lenOk = data.Length == expectedLength;
        bool hashOk = Known1985Roms.TryGetValue(fileName, out var known) && known.Sha256 == sha256;

        string? err = null;
        if (!lenOk)
            err = $"Invalid ROM length for '{fileName}': expected {expectedLength} bytes, got {data.Length} bytes.";
        else if (enforceChecksum && !hashOk)
            err = $"SHA-256 mismatch for '{fileName}': got {sha256}.";

        return new RomVerificationReport(fileName, data.Length, expectedLength, sha256, lenOk, hashOk, err);
    }
}
