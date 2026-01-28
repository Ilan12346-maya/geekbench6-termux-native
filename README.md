# Geekbench 6 Native Termux Patch

This package allows you to run **Geekbench 6.5.0 (Linux AArch64 Preview)** natively on Termux without the need for `proot`, `chroot`, or a full Linux distribution.

## Features
- **Native Performance:** Runs directly on Termux (Android) using bundled glibc libraries.
- **Portable:** No need to install `glibc-repo` or other external dependencies.
- **Easy Setup:** A single script handles downloading, patching, and configuration.
- **No Root Required:** Works on any ARM64 (AArch64) Android device.

## Prerequisites
- An Android device with an **ARM64 (AArch64)** processor.
- **Termux** installed.
- Internet connection (for the initial download).

## Quick Start

### One-line Install (Recommended)
Run this command in your Termux terminal to install everything automatically:
```bash
curl -sL https://raw.githubusercontent.com/Ilan12346-maya/geekbench6-termux-native/main/setup.sh | bash
```

### Manual Installation
1. **Copy the files:**
   Place `setup.sh` and the `lib/` folder into an empty directory in your Termux home.

2. **Run the installer:**
   ```bash
   chmod +x setup.sh
   ./setup.sh
   ```

3. **Follow the prompt:**
   The script will download the official Geekbench preview and apply the native patch. Once finished, you can start the benchmark immediately.

## Usage
After the initial setup, you can run the benchmark at any time using:
```bash
./geekbench6
```

## How it works
Standard Linux binaries expect a `glibc` environment, which Android (Bionic) does not provide. This patch:
1. Bundles the necessary GNU C libraries in a local `lib/` folder.
2. Uses a wrapper script to unset incompatible Android environment variables (`LD_PRELOAD`).
3. Forces the binary to use the local loader and libraries.

## Credits
- **Geekbench 6** is a product of [Primate Labs](https://www.primatelabs.com/).
- Patching method developed for the Termux community.
- AI-assisted with **gemini-cli**.

---
*Disclaimer: This is an unofficial patch. Please use the official Geekbench website for support regarding the benchmark itself.*
