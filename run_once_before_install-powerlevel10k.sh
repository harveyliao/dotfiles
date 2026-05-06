#!/bin/bash
# Clone powerlevel10k if not already present
set -e

P10K_DIR="$HOME/.local/share/powerlevel10k"

if [ ! -d "$P10K_DIR" ]; then
    echo "Cloning powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
else
    echo "powerlevel10k already exists at $P10K_DIR"
fi
