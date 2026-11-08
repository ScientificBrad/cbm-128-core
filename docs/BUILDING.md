# Building & Compilation Guide
**Project 002: Commodore 128 Dual-CPU Reconstruction**  
**Author:** ScientificBrad Research & Digital Preservation

---

## 1. Prerequisites

To build and run the Commodore 128 emulator and verification toolchains, ensure your environment meets the following specifications:

- **Operating System:** Windows 10/11 x64, Ubuntu 22.04+ LTS, or macOS 13+ (Apple Silicon or Intel).
- **.NET SDK:** .NET 8.0 SDK or newer (`dotnet --version`).
- **Python:** Python 3.10 or higher (`python --version`).
- **Git:** Git 2.30+ (`git --version`).

---

## 2. Building the C# Emulator

The primary high-performance Commodore 128 emulator is written in modern C# (.NET 8).

### 2.1 Standard Debug & Release Builds
From the root repository directory:

```bash
# Restore dependencies and build solution
dotnet build -c Release

# The compiled binary will be located at:
# src/Commodore128/bin/Release/net8.0-windows/Commodore128.exe
```

### 2.2 Publishing a Self-Contained Executable
To generate an optimized single-file distribution binary with zero runtime prerequisites:

```bash
dotnet publish src/Commodore128/Commodore128.csproj \
  -c Release \
  -r win-x64 \
  --self-contained true \
  -p:PublishSingleFile=true \
  -p:IncludeNativeLibrariesForSelfExtract=true \
  -p:EnableCompressionInSingleFile=true \
  -o releases/
```

This outputs `Commodore128.exe` directly into the `releases/` folder.

---

## 3. Running the Verification Suite

### 3.1 Executing Automated C# xUnit Tests
The project features 13 automated unit tests validating CPU instruction semantics, MMU banking boundaries, CIA timers, and 1571 GCR sector speed zones:

```bash
dotnet test tests/Commodore128.Tests/Commodore128.Tests.csproj -v normal
```

### 3.2 Executing Python Architectural Tests
The Python test harness tests dual-CPU instruction execution, memory relocation, and milestone verification:

```bash
# Run ROM-free unit tests (Clean room CI mode)
python -m pytest tests/test_romfree_architecture.py

# Run full milestone and regression suite (Requires ROM dumps)
python -m pytest tests/
```

---

## 4. Building the Technical Documentation & Whitepaper

The project includes an automated script that compiles the complete technical report into a publication-grade PDF whitepaper using ReportLab:

```bash
# Install reportlab
pip install reportlab

# Generate publication PDF
python scripts/build_pdf_report.py
```
This produces `Commodore_128_Dual_CPU_Reconstruction_Report.pdf` in the root repository.
