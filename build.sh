#!/usr/bin/env bash
set -euo pipefail

# Pepa OS - Custom Arch Linux ISO Build Script
# Requires: archiso (pacman -S archiso)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROFILE_DIR="${SCRIPT_DIR}/archlive"
OUT_DIR="${SCRIPT_DIR}/out"

if ! command -v mkarchiso &>/dev/null; then
    echo "Error: mkarchiso not found. Install archiso: sudo pacman -S archiso"
    exit 1
fi

echo "[*] Building Pepa OS ISO..."
rm -rf "${OUT_DIR}"
mkdir -p "${OUT_DIR}"
mkarchiso -v -w "${OUT_DIR}/work" -o "${OUT_DIR}" "${PROFILE_DIR}"

echo "[✓] Build complete!"
echo "    ISO located in: ${OUT_DIR}/"
ls -lh "${OUT_DIR}"/*.iso 2>/dev/null || true
