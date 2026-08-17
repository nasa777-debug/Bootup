#!/bin/bash
# ==============================================================================
# BootUp — Mobile Linux Simulation Launcher
# ==============================================================================

set -e

# Option 1: Launch using pmbootstrap runner (Standard postmarketOS method)
if command -v pmbootstrap &> /dev/null; then
    echo "Starting BootUp OS environment via pmbootstrap..."
    pmbootstrap qemu --display=gtk
    exit 0
fi

# Option 2: Fallback direct QEMU execution if standalone image exists
IMAGE_PATH="qemu-amd64.img"

if [ -f "$IMAGE_PATH" ]; then
    echo "Starting BootUp OS environment via direct QEMU boot..."
    qemu-system-x86_64 \
        -enable-kvm \
        -m 2048 \
        -smp 2 \
        -vga virtio \
        -display gtk,gl=on \
        -drive file="$IMAGE_PATH",format=raw \
        -net user,hostfwd=tcp::2222-:22 \
        -net nic
else
    echo "Error: Could not find system image ($IMAGE_PATH) or pmbootstrap."
    echo "Please run 'pmbootstrap init' and 'pmbootstrap install' to generate the image."
    exit 1
fi
