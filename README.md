# My Linux Dotfiles

This is my personal linux and hyprland (Lua-based) configuration my Dotfiles for most of the stuff I use.
Hyprland config was initially based on [ML4W](https://github.com/mylinuxforwork/dotfiles) but I've rewritten it fully with the switch to lua.
> [!NOTE]
> Installer installs Dotfiles via symlinks. Packages are only installed automatically when using `--term` (Pacman only).
> `nvim` gets cloned from the `nvim` branch

## Installation

Clone the repository and run the installation script:

```bash
git clone https://github.com/Henriklmao/Hyprland-Dotfiles.git ~/Documents/Dotfiles
cd ~/Documents/Dotfiles
chmod +x install.sh
./istall.sh -h
```

For full installation:

```bash
./install.sh --all
```

For selective installation:

```bash
./install.sh --hypr --waybar --nvim
```

For terminal setup (configs + required packages via pacman):

```bash
./install.sh --term
```

>[!NOTE]
> The installer will always show all selected components and ask for confirmation before making changes.

## Neovim

Neovim configuration based on LazyVim can be found in the [nvim branch](https://github.com/Henriklmao/Hyprland-Dotfiles/tree/nvim).

Quick Install:

```bash
git clone --branch nvim https://github.com/Henriklmao/Hyprland-Dotfiles.git ~/.config/nvim
```

### Headless nvim

My Headless/VPS nvim configurations are located in the [server branch](https://github.com/Henriklmao/Hyprland-Dotfiles/tree/server).
