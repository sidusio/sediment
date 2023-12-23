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

echo '2. Downloading source'
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.13.1

echo '3. Install (for fish)'
echo 'source ~/.asdf/asdf.fish' >> ~/.config/fish/config.fish

echo '4. Add completions (for fish)'
mkdir -p ~/.config/fish/completions && ln -s ~/.asdf/completions/asdf.fish ~/.config/fish/completions