# My Hyprland Dotfiles (Master Branch)

This is my personal Hyprland configuration (Lua-based), `nwg-dock-hyprland` configuration, and various other desktop utilities.

## Features

- **Hyprland:** Fully configured in Lua (`hyprland.lua`). Modular structure in the `lua/` subfolder. Optimized for Surface Go 2 (1920x1280, Scale 1.25).
- **Nwg-Dock:** Configuration for `nwg-dock-hyprland`.
- **Waybar:** Configuration for the status bar.
- **Rofi:** Configuration for the application launcher.
- **SwayNC:** Configuration for the notification center.
- **wlogout:** Configuration for the logout menu.
- **Kitty:** Configuration for the terminal emulator.
- **Fastfetch:** Configuration for system information fetching.
- **Starship:** Configuration for the shell prompt.

## Installation

Clone the repository and run the installation script:

```bash
git clone https://github.com/Henriklmao/Hyprland-Dotfiles.git ~/Documents/Dotfiles
cd ~/Documents/Dotfiles
chmod +x install.sh
./install.sh
```

## Neovim

My Neovim configuration can be found in the [nvim branch](https://github.com/Henriklmao/Dotfiles/tree/nvim).

## VPS Configurations

My VPS configurations are located in the [server branch](https://github.com/Henriklmao/Dotfiles/tree/server).

## Quick Install Neovim

```bash
git clone --branch nvim https://github.com/Henriklmao/Hyprland-Dotfiles.git ~/.config/nvim
```
