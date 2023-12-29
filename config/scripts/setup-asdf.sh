#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

# This script automates the setup of asdf as described 
# at: https://asdf-vm.com/guide/getting-started.html

echo '1. Checking prerequisits'
if [[ ! -f $(which git) || ! -f $(which curl) ]]; then
    echo 'missing prerequisits'
    exit 1
fi

ASDF_DIR=/usr/opt/asdf
FISH_DIR=/usr/etc/fish

echo '2. Downloading source'
git clone https://github.com/asdf-vm/asdf.git $ASDF_DIR --branch v0.13.1

echo '3. Install (for fish)'
mkdir -p $FISH_DIR
echo "source $ASDF_DIR/asdf.fish" >> $FISH_DIR/config.fish

echo '4. Add completions (for fish)'
mkdir -p $FISH_DIR/completions
ln -s $ASDF_DIR/completions/asdf.fish $FISH_DIR/completions
