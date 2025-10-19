#!/usr/bin/env bash
set -euo pipefail

BIN_DIR="./zig-out/bin"
SD_DIR="/run/media/unab/RPI SD"

echo "[*] Building kernel..."
cd .. & zig build || { echo "❌ Error: build failed"; exit 1; }

# Check if the binary exists
if [[ ! -f "$BIN_DIR/kernel8.img" ]]; then
    echo "❌ Error: $BIN_DIR/kernel8.img not found"
    exit 1
fi

# Check if the SD card is mounted
if [[ ! -d "$SD_DIR" ]]; then
    echo "❌ Error: SD directory not found ($SD_DIR)"
    exit 1
fi

echo "[*] Copying kernel8.img to SD card..."
rm -f "$SD_DIR/kernel8.img" || true
cp "$BIN_DIR/kernel8.img" "$SD_DIR/kernel8.img"

sync  # ensure all writes are flushed before removing the SD
echo "✅ Kernel copied successfully."
