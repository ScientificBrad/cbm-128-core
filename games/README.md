# Commodore 128 Commercial Game Compatibility

> **LEGAL NOTICE**  
> Commercial game disk images and copyrighted binaries are **not** included in this repository. Users must dump their own physical media.

---

## Verified Commercial Game: Kikstart 128 (1986)

- **Title:** Kikstart 128 (Expanded Commodore 128 Edition)
- **Developer / Publisher:** Shaun Southern / Mr. Chip Software / Mastertronic (1986)
- **Disk Image:** `KIK128.D64` (174,848 bytes, 35 tracks D64)
- **SHA-256 Hash:** `98a222af8000da47fd45441e7be0309e85387ea8749d7d5582ec46b9b1c1db19`

### Execution Profile

1. **Boot Mode:** Native Commodore 128 mode loader executing from `$1C01` (BASIC 7.0 stub) switching memory configurations.
2. **Decompression:** Unpacks 35 KB machine-language race engine and multi-part data into Bank 0 RAM.
3. **Execution Vector:** Entry point reached at `$5CC4` (Race engine loop).
4. **Display Architecture:**
   - Title screen: Standard 320x200 multicolor bitmap graphics mode (`$2000-$3F3F`), screen memory at `$0400`, color RAM at `$D800`.
   - Race screen: Dual split-screen horizontal scrolling motorcycle obstacle course, rendering Player 1 and Player 2 viewports with custom character graphics and sprite overlays.

### Running Commercial Games

To mount and boot a commercial game disk:
```bash
Commodore128.exe --disk games/KIK128.D64
```

### Current Status & Known Limitations

- **Engine Execution:** Native C128 decompression, memory configuration, and race engine loop run accurately at `$5CC4`.
- **Renderer Performance:** The standalone graphical rendering window renders the multicolor bitmap title screen and race viewports. In complex split-screen raster interrupts, frame rendering runs at ~31.6 FPS on standard host threads. Further cycle-exact raster interrupt optimization is planned in Phase 10.
