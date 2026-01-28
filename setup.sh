#!/data/data/com.termux/files/usr/bin/bash
# Native Geekbench 6 - Termux "Flat" Installer
# This script installs and patches Geekbench directly into the current directory.

set -e

# Change to the script's directory
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

URL="https://cdn.geekbench.com/Geekbench-6.5.0-LinuxARMPreview.tar.gz"

# Check if already installed (Check for .bin file)
if [ -f "geekbench6.bin" ]; then
    echo "[*] Geekbench is already installed."
    exec ./geekbench6 "$@"
fi

echo "=========================================="
echo "   Geekbench 6 Native Termux Setup"
echo "=========================================="

# 1. Download & Extract (Flat - no subfolders)
if [ ! -f "geekbench.plar" ]; then
    echo "[*] Downloading Geekbench 6.5.0 Preview..."
    # --strip-components=1 ensures no subfolder is created
    curl -L "$URL" | tar xz --strip-components=1
fi

# 2. Verify Bundled Libs
if [ ! -d "lib" ] || [ ! -f "lib/ld-linux-aarch64.so.1" ]; then
    echo "[!] Error: The required 'lib' folder is missing or incomplete!"
    exit 1
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

# 7. Start Prompt
read -p "Do you want to start Geekbench now? (y/n): " choice
case "$choice" in 
  y|Y ) ./geekbench6 ;;
  * ) echo "You can start Geekbench later with ./geekbench6" ;;
esac
