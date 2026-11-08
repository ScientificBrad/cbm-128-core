using System;
using System.IO;

namespace Commodore128.Disk;

/// <summary>
/// Commodore 1541 / 1571 Floppy Disk Drive Emulation for D64 (174,848 bytes) and D71 (349,696 bytes).
/// Implements standard GCR radial speed zones, sector interleaving, and direct sector read/write.
/// </summary>
public sealed class DiskDrive1571
{
    private readonly byte[] _diskData;
    public string ImagePath { get; }
    public bool IsD71 { get; }
    public int TotalTracks { get; }

    // Sectors per track for 1541/1571 GCR Speed Zones
    // Tracks 1-17 (Zone 0): 21 sectors/track
    // Tracks 18-24 (Zone 1): 19 sectors/track
    // Tracks 25-30 (Zone 2): 18 sectors/track
    // Tracks 31-35 (Zone 3): 17 sectors/track
    private static readonly int[] SectorsPerTrackZone =
    [
        0, // Track 0 (unused)
        21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, // 1-17
        19, 19, 19, 19, 19, 19, 19,                                         // 18-24
        18, 18, 18, 18, 18, 18,                                             // 25-30
        17, 17, 17, 17, 17                                                  // 31-35
    ];

    public DiskDrive1571(byte[] diskData, string imagePath = "in-memory.d64")
    {
        ImagePath = imagePath;
        _diskData = diskData;
        if (_diskData.Length == 174848 || _diskData.Length == 175531)
        {
            IsD71 = false;
            TotalTracks = 35;
        }
        else if (_diskData.Length == 349696 || _diskData.Length == 351062)
        {
            IsD71 = true;
            TotalTracks = 70;
        }
        else
        {
            throw new InvalidOperationException($"Unsupported disk image size: {_diskData.Length} bytes.");
        }
    }

    public DiskDrive1571(string imagePath)
        : this(File.ReadAllBytes(imagePath), imagePath)
    {
    }

    public static int GetSectorsForTrack(int track)
    {
        if (track < 1 || track > 70) return 0;
        int t = track > 35 ? track - 35 : track;
        return SectorsPerTrackZone[t];
    }

    public int GetSectorByteOffset(int track, int sector)
    {
        if (track < 1 || track > TotalTracks)
            throw new ArgumentOutOfRangeException(nameof(track), $"Track {track} out of range (1..{TotalTracks})");

        int maxSec = GetSectorsForTrack(track);
        if (sector < 0 || sector >= maxSec)
            throw new ArgumentOutOfRangeException(nameof(sector), $"Sector {sector} out of range for Track {track} (0..{maxSec - 1})");

        int totalSectorsBefore = 0;

        // Side 0 tracks
        int targetSide = track > 35 ? 1 : 0;
        int physicalTrackOnSide = track > 35 ? track - 35 : track;

        // If on Side 1, add all 683 sectors of Side 0
        if (targetSide == 1)
        {
            totalSectorsBefore += 683;
        }

        for (int t = 1; t < physicalTrackOnSide; t++)
        {
            totalSectorsBefore += SectorsPerTrackZone[t];
        }

        totalSectorsBefore += sector;
        return totalSectorsBefore * 256;
    }

    public byte[] ReadSector(int track, int sector)
    {
        int offset = GetSectorByteOffset(track, sector);
        var buffer = new byte[256];
        Array.Copy(_diskData, offset, buffer, 0, 256);
        return buffer;
    }

    public void ReadSectorInto(int track, int sector, byte[] destination, int destOffset)
    {
        int offset = GetSectorByteOffset(track, sector);
        Array.Copy(_diskData, offset, destination, destOffset, 256);
    }

    public void WriteSector(int track, int sector, byte[] source, int srcOffset = 0)
    {
        int offset = GetSectorByteOffset(track, sector);
        Array.Copy(source, srcOffset, _diskData, offset, 256);
    }

    public void SaveToFile(string? path = null)
    {
        File.WriteAllBytes(path ?? ImagePath, _diskData);
    }

    public List<D64DirectoryEntry> ReadDirectory()
    {
        var entries = new List<D64DirectoryEntry>();
        int curTrack = 18;
        int curSector = 1;
        var visited = new HashSet<(int, int)>();

        while (curTrack > 0 && curTrack <= TotalTracks && visited.Add((curTrack, curSector)))
        {
            byte[] sec = ReadSector(curTrack, curSector);
            int nextTrack = sec[0];
            int nextSector = sec[1];

            for (int e = 0; e < 8; e++)
            {
                int off = e * 32;
                byte ftype = sec[off + 2];
                if (ftype == 0x00) continue; // Scratched / empty

                int firstTrack = sec[off + 3];
                int firstSector = sec[off + 4];

                var nameChars = new char[16];
                for (int i = 0; i < 16; i++)
                {
                    byte b = sec[off + 5 + i];
                    if (b == 0xA0) b = (byte)' ';
                    nameChars[i] = (char)b;
                }
                string rawName = new string(nameChars).TrimEnd();

                int blockCount = sec[off + 30] | (sec[off + 31] << 8);
                string typeStr = (ftype & 0x07) switch
                {
                    0 => "DEL",
                    1 => "SEQ",
                    2 => "PRG",
                    3 => "USR",
                    4 => "REL",
                    _ => "???"
                };

                entries.Add(new D64DirectoryEntry(ftype, typeStr, firstTrack, firstSector, rawName, blockCount));
            }

            curTrack = nextTrack;
            curSector = nextSector;
        }

        return entries;
    }

    public (ushort loadAddress, byte[] data) LoadPrg(string? filename = null)
    {
        var dir = ReadDirectory();
        D64DirectoryEntry? entry = null;

        if (string.IsNullOrEmpty(filename))
        {
            entry = dir.Find(e => (e.FileType & 0x07) == 2);
        }
        else
        {
            entry = dir.Find(e => (e.FileType & 0x07) == 2 &&
                (e.FileName.Equals(filename, StringComparison.OrdinalIgnoreCase) ||
                 e.FileName.StartsWith(filename.TrimEnd('*'), StringComparison.OrdinalIgnoreCase)));
        }

        if (entry is null)
            throw new FileNotFoundException($"PRG file '{(filename ?? "*")}' not found in disk image '{ImagePath}'.");

        int t = entry.Track;
        int s = entry.Sector;
        var bytes = new List<byte>();
        var visited = new HashSet<(int, int)>();

        while (t != 0 && t <= TotalTracks && visited.Add((t, s)))
        {
            byte[] sec = ReadSector(t, s);
            int nextTrack = sec[0];
            int nextSector = sec[1];

            if (nextTrack == 0)
            {
                int validCount = nextSector;
                if (validCount >= 1 && validCount <= 255)
                {
                    for (int i = 2; i <= validCount; i++)
                    {
                        bytes.Add(sec[i]);
                    }
                }
                break;
            }
            else
            {
                for (int i = 2; i < 256; i++)
                {
                    bytes.Add(sec[i]);
                }
                t = nextTrack;
                s = nextSector;
            }
        }

        if (bytes.Count < 2)
            throw new InvalidDataException("PRG file contains fewer than 2 bytes (no load address).");

        ushort loadAddr = (ushort)(bytes[0] | (bytes[1] << 8));
        byte[] payload = bytes.Skip(2).ToArray();
        return (loadAddr, payload);
    }
}

public sealed record D64DirectoryEntry(
    byte FileType,
    string TypeName,
    int Track,
    int Sector,
    string FileName,
    int SectorCount);
