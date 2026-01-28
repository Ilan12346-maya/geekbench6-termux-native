#!/data/data/com.termux/files/usr/bin/bash
# Native Geekbench 6 - Termux "Flat" Installer
# This script installs and patches Geekbench directly into the current directory.

set -e

INSTALL_DIR="."

# Detect if we should create a subdirectory
# If 'lib' is missing, we assume a fresh one-liner install and create a folder.
if [ ! -d "lib" ]; then
    echo "[*] Fresh installation detected. Creating 'geekbench6' directory..."
    mkdir -p geekbench6
    cd geekbench6
    INSTALL_DIR="geekbench6"
fi

# Change to the script's directory (handle path execution if not piped)
if [ -n "$BASH_SOURCE" ] && [ -f "$BASH_SOURCE" ]; then
    DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    cd "$DIR"
fi

URL="https://cdn.geekbench.com/Geekbench-6.5.0-LinuxARMPreview.tar.gz"
GITHUB_RAW="https://raw.githubusercontent.com/Ilan12346-maya/geekbench6-termux-native/main"

# Check if already installed (Check for .bin file)
if [ -f "geekbench6.bin" ]; then
    echo "[*] Geekbench is already installed."
    if [ -t 0 ]; then
        exec ./geekbench6 "$@"
    else
        exit 0
    fi
fi

echo "=========================================="
echo "   Geekbench 6 Native Termux Setup"
echo "=========================================="

# 1. Download & Extract (Flat - no subfolders)
if [ ! -f "geekbench.plar" ]; then
    echo "[*] Downloading Geekbench 6.5.0 Preview..."
    curl -L "$URL" | tar xz --strip-components=1
fi

# 2. Verify or Download Bundled Libs
if [ ! -d "lib" ] || [ ! -f "lib/ld-linux-aarch64.so.1" ]; then
    echo "[*] 'lib' folder missing or incomplete. Downloading from GitHub..."
    mkdir -p lib
    for libfile in ld-linux-aarch64.so.1 libc.so.6 libdl.so.2 libgcc_s.so.1 libm.so.6 libpthread.so.0 libstdc++.so.6; do
        echo "    - Downloading $libfile..."
        curl -sL "$GITHUB_RAW/lib/$libfile" -o "lib/$libfile"
    done
    chmod +x lib/*.so*
fi

# 3. Prepare Binaries
echo "[*] Preparing binaries..."
[ -f "geekbench6" ] && mv geekbench6 geekbench6.bin
[ -f "geekbench_aarch64" ] && mv geekbench_aarch64 geekbench_aarch64.bin

# 4. Integrate Workloads into the lib folder
echo "[*] Integrating workload archives into 'lib'..."
mv *.plar lib/ 2>/dev/null || true

# 5. Install Wrappers
echo "[*] Installing start scripts..."
cat <<EOF > geekbench6
#!/data/data/com.termux/files/usr/bin/bash
DIR="\$(cd "\$(dirname "\${BASH_SOURCE[0]}")" && pwd)"
unset LD_PRELOAD
exec "\$DIR/lib/ld-linux-aarch64.so.1" --library-path "\$DIR/lib" "\$DIR/geekbench_aarch64.bin" "\$@"
EOF

cat <<EOF > geekbench_aarch64
#!/data/data/com.termux/files/usr/bin/bash
DIR="\$(cd "\$(dirname "\${BASH_SOURCE[0]}")" && pwd)"
unset LD_PRELOAD
exec "\$DIR/lib/ld-linux-aarch64.so.1" --library-path "\$DIR/lib" "\$DIR/geekbench_aarch64.bin" "\$@"
EOF

chmod +x geekbench6 geekbench_aarch64

# 6. Optimization (optional)
if command -v patchelf &> /dev/null; then
    echo "[*] Optimizing binaries (patchelf)..."
    patchelf --set-rpath '\$ORIGIN/lib' geekbench6.bin || true
    patchelf --set-rpath '\$ORIGIN/lib' geekbench_aarch64.bin || true
fi

echo ""
echo "=========================================="
echo " Setup complete!"
echo "=========================================="
echo ""

# Only ask to start if running in an interactive terminal (not piped)
if [ -t 0 ]; then
    read -p "Do you want to start Geekbench now? (y/n): " choice
    case "$choice" in 
      y|Y ) ./geekbench6 ;;
      * ) 
        if [ "$INSTALL_DIR" = "geekbench6" ]; then
            echo "Done! Start it with: cd geekbench6 && ./geekbench6"
        else
            echo "Done! Start it with: ./geekbench6"
        fi
        ;;
    esac
else
    if [ "$INSTALL_DIR" = "geekbench6" ]; then
        echo "Done! Start Geekbench with: cd geekbench6 && ./geekbench6"
    else
        echo "Done! Start Geekbench with: ./geekbench6"
    fi
fi