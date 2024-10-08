#!/usr/bin/env bash
#
# Adapted/stolen from:
# https://github.com/blue-build/modules/blob/main/modules/fonts
#

set -euo pipefail

FONTS=($@)
URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download"
DEST="/usr/share/fonts/nerd-fonts"

echo "Installation of nerd-fonts started"
rm -rf "$DEST"

mkdir -p /tmp/fonts
for FONT in "${FONTS[@]}"; do
    FONT=${FONT// /} # remove spaces
    if [ ${#FONT} -gt 0 ]; then
        mkdir -p "${DEST}/${FONT}"

        echo "Downloading ${FONT} from ${URL}/${FONT}.tar.xz"

        curl "${URL}/${FONT}.tar.xz" -L -o "/tmp/fonts/${FONT}.tar.xz"
        tar -xf "/tmp/fonts/${FONT}.tar.xz" -C "${DEST}/${FONT}"
    fi
done
rm -rf /tmp/fonts

fc-cache -f "${DEST}"
