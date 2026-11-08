using Xunit;
using Commodore128.Disk;

namespace Commodore128.Tests;

public class DiskDrive1571Tests
{
    [Fact]
    public void GcrSpeedZones_ReturnAccurateSectorCounts()
    {
        // Tracks 1-17: 21 sectors
        Assert.Equal(21, DiskDrive1571.GetSectorsForTrack(1));
        Assert.Equal(21, DiskDrive1571.GetSectorsForTrack(17));

        // Tracks 18-24: 19 sectors (Directory track 18)
        Assert.Equal(19, DiskDrive1571.GetSectorsForTrack(18));
        Assert.Equal(19, DiskDrive1571.GetSectorsForTrack(24));

        // Tracks 25-30: 18 sectors
        Assert.Equal(18, DiskDrive1571.GetSectorsForTrack(25));
        Assert.Equal(18, DiskDrive1571.GetSectorsForTrack(30));

        // Tracks 31-35: 17 sectors
        Assert.Equal(17, DiskDrive1571.GetSectorsForTrack(31));
        Assert.Equal(17, DiskDrive1571.GetSectorsForTrack(35));
    }

    [Fact]
    public void SyntheticDisk_ReadDirectory_FindsFormattedEntries()
    {
        // Create 174,848 byte synthetic D64
        byte[] d64 = new byte[174848];

        var drive = new DiskDrive1571(d64, "synthetic.d64");
        Assert.Equal(35, drive.TotalTracks);
        Assert.False(drive.IsD71);

        // Track 18 Sector 0 (BAM block)
        byte[] bam = new byte[256];
        bam[0] = 18; // Next track (18)
        bam[1] = 1;  // Next sector (first directory block)
        bam[2] = 0x41; // DOS version
        drive.WriteSector(18, 0, bam);

        // Track 18 Sector 1 (First directory block)
        byte[] dirBlock = new byte[256];
        dirBlock[0] = 0; // Next track 0 = end of directory chain
        dirBlock[1] = 0xFF; // Next sector offset

        // First directory entry at offset +2: File "TEST", PRG (0x82), Track 1, Sector 0, 5 blocks
        dirBlock[2] = 0x82; // PRG, closed
        dirBlock[3] = 1;    // Track 1
        dirBlock[4] = 0;    // Sector 0

        // Filename "TEST" padded with $A0 (Shift-Space in Commodore DOS)
        byte[] nameBytes = [(byte)'T', (byte)'E', (byte)'S', (byte)'T'];
        for (int i = 0; i < 16; i++)
        {
            dirBlock[5 + i] = (i < nameBytes.Length) ? nameBytes[i] : (byte)0xA0;
        }
        dirBlock[30] = 5; // Block count low
        dirBlock[31] = 0; // Block count high

        drive.WriteSector(18, 1, dirBlock);

        var entries = drive.ReadDirectory();
        Assert.Single(entries);
        Assert.Equal("TEST", entries[0].FileName);
        Assert.Equal("PRG", entries[0].TypeName);
        Assert.Equal(1, entries[0].Track);
        Assert.Equal(0, entries[0].Sector);
        Assert.Equal(5, entries[0].SectorCount);
    }
}
