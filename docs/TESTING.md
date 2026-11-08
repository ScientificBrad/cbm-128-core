# Automated Testing & Verification Suite

---

## 1. Testing Philosophy & Clean-Room CI Architecture

The Commodore 128 reconstruction relies on a rigorous dual-layer test methodology:
1. **Low-Level Micro-Architecture Tests:** Unit testing of individual CPU instructions, register pairs, MMU page translation boundaries, and peripheral clock timings.
2. **System Integration & Milestone Tests:** End-to-end execution of genuine Commodore firmware routines, memory banking, disk sector transfers, and application execution.

### Clean-Room CI Invariant
Proprietary Commodore ROM images cannot be stored on public source control hosts like GitHub. Consequently, the test suite is partitioned into:
- **ROM-Free Unit Tests:** Executed automatically on every pull request and GitHub Actions runner using synthetic buses and memory mocks.
- **ROM-Dependent Milestone Tests:** Executed on development machines equipped with verified dumps of the original Commodore 128 firmware.

---

## 2. C# xUnit Test Suite (`tests/Commodore128.Tests/`)

The C# test project (`Commodore128.Tests.csproj`) targets .NET 8 and validates the core emulator components without external dependencies:

```bash
dotnet test tests/Commodore128.Tests/Commodore128.Tests.csproj
```

### Test Inventory (13 Tests, 100% Passing)

| Test Fixture | Test Name | Invariant Verified |
| :--- | :--- | :--- |
| `Cpu8502Tests` | `Adc_Immediate_ComputesSumAndSetsFlagsCorrectly` | Verifies ADC addition, carry propagation, zero detection, and sign bit calculation. |
| `Cpu8502Tests` | `Nmi_PushesPcAndStatus_AndVectorsCorrectly` | Validates non-maskable interrupt vector fetching from `$FFFA-$FFFB`, stack push order, and break flag suppression. |
| `CpuZ80Tests` | `RegisterPairs_GetAndSet_HighAndLowBytesCorrectly` | Tests 16-bit register pairs (BC, DE, HL, AF) packing and unpacking. |
| `CpuZ80Tests` | `Ldir_TransfersBlockOfMemory_UntilBcIsZero` | Validates repetitive block copy instruction (`ED B0`), decrementing BC to zero, HL/DE pointer updates, and cycle accounting. |
| `MmuAndMemoryBusTests` | `BankSwitching_ReadsFromSelectedRamBank` | Tests MMU `$D500` register toggling between Bank 0 (64 KB) and Bank 1 (64 KB). |
| `MmuAndMemoryBusTests` | `CommonRam_TopPage_AlwaysAccessesBank0` | Confirms that writes to `$FFD0-$FFEF` map to shared common RAM across both banks. |
| `MmuAndMemoryBusTests` | `C64ModeBit_PreventsMmuAccess` | Validates hardware interlock where activating C64 mode suppresses C128 MMU register manipulation. |
| `CiaTimerAndTodTests` | `TimerA_Underflow_GeneratesInterrupt` | Tests down-counting clock cycles, latch reloading, and IRQ line assertion. |
| `CiaTimerAndTodTests` | `TodClock_TicksTenthsAndRollsOverSeconds` | Validates 60 Hz prescaler, tenths-of-second advancement, and BCD second rollover. |
| `VicIIeRendererTests` | `Palette_Has16DistinctOpaqueColors` | Validates standard 16-color palette constants, non-zero alpha, and color distinctness. |
| `VicIIeRendererTests` | `RenderFrame_Generates320x200PixelBuffer` | Confirms 320 × 200 frame buffer dimension, pitch alignment, and byte count (64,000 pixels). |
| `DiskDrive1571Tests` | `GetTrackSectorCount_ReturnsAuthenticGcrZones` | Validates 1571 4-speed GCR zones (Tracks 1-17: 21, 18-24: 19, 25-30: 18, 31-35: 17 sectors). |
| `DiskDrive1571Tests` | `ReadSector_ParsesD64SectorData` | Validates synthetic D64 disk image sector offset calculations and track/sector seeking. |

---

## 3. Python Test Harness (`tests/`)

The Python test suite provides comprehensive hardware simulation and milestone verification:

### 3.1 ROM-Free Suite (`tests/test_romfree_architecture.py`)
```bash
python -m pytest tests/test_romfree_architecture.py -v
```
Validates Python MOS 8502 arithmetic, Z80 LDIR execution, 1571 speed zones, and MMU stub boundaries using `MockBus`.

### 3.2 Full Milestone Verification (`tests/test_phase7_milestones.py`)
```bash
python -m pytest tests/test_phase7_milestones.py -v
```
Validates:
- Cold reset initialization through `$FFFC`.
- Screen RAM initialization at `$0400`.
- BASIC 7.0 token parser execution and variable storage in Bank 1.
- Matrix rain execution milestone (80+ million simulated cycles).
- CP/M 3.0 sector loader handover to Z80 BIOS at `$018C`.
