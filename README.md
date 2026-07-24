# My Hyprland Dotfiles (Master Branch)

This is my personal Arch Linux Hyprland configuration (Lua-based) my Dotfiles for most of the stuff I use.
Initially based on ML4W's Hyprland configuration, but heavily modified to suit my needs.
> [!NOTE]
> Installer installs Dotfiles via symlinks only. Packages are not installed automatically.
> `nvim` is the exception and gets cloned from the `nvim` branch into `~/.config/nvim`.
>
## Installation

Clone the repository and run the installation script:

```bash
git clone https://github.com/Henriklmao/Hyprland-Dotfiles.git ~/Documents/Dotfiles
cd ~/Documents/Dotfiles
chmod +x install.sh
```

For full installation:

```bash
./install.sh --all
```

For selective installation:

```bash
./install.sh --hypr # can be chained
```

The installer will always show all selected components and ask for confirmation before making changes.

## Neovim

My Neovim configuration can be found in the [nvim branch](https://github.com/Henriklmao/Dotfiles/tree/nvim).

### Quick Install Neovim

```bash
git clone --branch nvim https://github.com/Henriklmao/Hyprland-Dotfiles.git ~/.config/nvim
```

## VPS Configurations

My VPS configurations are located in the [server branch](https://github.com/Henriklmao/Dotfiles/tree/server).
