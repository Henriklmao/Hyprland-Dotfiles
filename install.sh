#!/bin/bash

# Dotfiles Installation Script
# Master Branch: Full Desktop Config (Hyprland, Waybar, Rofi, Kitty, etc.)

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Function to link config
link_config() {
    local src="$1"
    local dest="$2"
    
    if [ -e "$dest" ]; then
        if [ -L "$dest" ]; then
            echo "Removing existing symlink for $dest"
            rm "$dest"
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

# List of configs to link
configs=(
    "hypr"
    "nwg-dock-hyprland"
    "waybar"
    "rofi"
    "swaync"
    "wlogout"
    "kitty"
    "fastfetch"
)

# Link directories
for config in "${configs[@]}"; do
    link_config "$DOTFILES_DIR/$config" "$HOME/.config/$config"
done

# Link individual files
link_config "$DOTFILES_DIR/starship.toml" "$HOME/.config/starship.toml"

echo "Installation complete!"
