#!/bin/bash

# Dotfiles Installation Script
# Master Branch: Hyprland & nwg-dock-hyprland

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Function to link config
link_config() {
    local src="$1"
    local dest="$2"
    
    if [ -e "$dest" ]; then
        if [ -L "$dest" ]; then
            echo "Symlink for $dest already exists. Skipping."
            return
        else
            echo "Backing up existing $dest to ${dest}.bak"
            mv "$dest" "${dest}.bak"
        fi
    fi
    
    echo "Creating symlink: $dest -> $src"
    ln -s "$src" "$dest"
}

# Create .config if it doesn't exist
mkdir -p ~/.config

# Link Hyprland
link_config "$DOTFILES_DIR/hypr" "$HOME/.config/hypr"

# Link nwg-dock-hyprland
link_config "$DOTFILES_DIR/nwg-dock-hyprland" "$HOME/.config/nwg-dock-hyprland"

echo "Installation complete!"
