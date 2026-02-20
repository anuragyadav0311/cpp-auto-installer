# cpp-auto-installer

A one-click, cross-platform C/C++ compiler installer for Windows, Linux, and macOS. This tool automatically downloads, installs, and configures the necessary C++ build environments (GCC, MinGW, or Clang) and updates your system's PATH.

## Getting Started

To download the scripts to your local machine, open your terminal and run:

```bash
git clone [https://github.com/anuragyadav0311/cpp-auto-installer.git](https://github.com/anuragyadav0311/cpp-auto-installer.git)
cd cpp-auto-installer
```

---

## Supported Platforms & Usage

### Windows
**What it does:** Detects your system architecture (32-bit or 64-bit), downloads the appropriate standalone WinLibs MinGW-w64 release, extracts it directly to the `C:\` drive, and permanently updates your global `Machine` PATH variable so `gcc` and `g++` are immediately available in any terminal.

**How to run:**
1. Open **PowerShell as an Administrator**.
2. Navigate to the cloned repository folder.
3. Run the installation script:
   ```powershell
   .\windows\install_cpp.ps1
   ```

### Linux (Ubuntu, Debian, Arch)
**What it does:** Automatically detects your specific Linux distribution. For Ubuntu/Debian, it updates package lists and installs `build-essential` and `gdb` via `apt`. For Arch Linux, it installs the `base-devel` group and `gdb` via `pacman`.

**How to run:**
1. Open your terminal.
2. Navigate to the cloned repository folder.
3. Make the script executable and run it with `root` privileges:
   ```bash
   chmod +x ./linux/install_cpp.sh
   sudo ./linux/install_cpp.sh
   ```

### macOS
**What it does:** Verifies if Apple's Command Line Tools are already present. If not, it triggers the native macOS installation sequence to download and install Clang (aliased as GCC) and essential development headers.

**How to run:**
1. Open your terminal.
2. Navigate to the cloned repository folder.
3. Make the script executable and run it:
   ```bash
   chmod +x ./macos/install_cpp.sh
   ./macos/install_cpp.sh
   ```

---

## Automated Testing
This repository includes a Continuous Integration (CI) pipeline via GitHub Actions. Every push to the `main` branch automatically boots up fresh Windows, Ubuntu, and macOS virtual environments to test the installer scripts, ensuring cross-platform reliability.