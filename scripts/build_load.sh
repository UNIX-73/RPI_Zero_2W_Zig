#!/usr/bin/env bash
set -euo pipefail

BIN_DIR="./zig-out/bin"
IMG_NAME="kernel8.img"
MOUNT_POINT="/run/media/unai/RPI SD"
DEVICE="/dev/sdb1"

echo "[*] Building kernel..."
zig build || { echo "❌ Error: build failed"; exit 1; }

# Comprobar que existe el binario
if [[ ! -f "$BIN_DIR/$IMG_NAME" ]]; then
    echo "❌ Error: $BIN_DIR/$IMG_NAME not found"
    exit 1
fi

echo "[*] Verificando si la SD está montada..."
if ! mountpoint -q "$MOUNT_POINT"; then
    echo "[*] Montando SD en $MOUNT_POINT..."
    sudo mkdir -p "$MOUNT_POINT"
    sudo mount "$DEVICE" "$MOUNT_POINT" || {
        echo "❌ Error: no se pudo montar $DEVICE en $MOUNT_POINT"
        exit 1
    }
else
    echo "[✓] SD ya está montada."
fi

echo "[*] Copiando kernel a la SD..."
sudo cp "$BIN_DIR/$IMG_NAME" "$MOUNT_POINT/" || {
    echo "❌ Error al copiar el kernel"
    exit 1
}

echo "[*] Sincronizando..."
sync

echo "[✓] Kernel actualizado correctamente en la SD."
