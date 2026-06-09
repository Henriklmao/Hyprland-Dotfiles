# Agent Instructions

This repository manages personal dotfiles using symlinks to `~/.config`.

## Setup & Installation

- Run `./install.sh` to link configuration files from this directory to `~/.config`.
- **Arguments:**
    - `--all`: Install all configurations.
    - `--<name>`: Install a specific configuration (e.g., `--hypr`, `--waybar`).
    - Run without arguments to see available options.
- The script automatically handles backing up existing configurations (`.bak`).
- **Adding new configurations:**
    - To add a new directory or file, add its entry to the `COMPONENTS` array in `install.sh` using the format `"Name|SourcePath|TargetPath"`.

## Structure

- **Core Configs:** Located in subdirectories corresponding to the application name (e.g., `hypr/`, `waybar/`, `kitty/`, `fish/`).
- **File Symlinks:** Files like `starship.toml` are symlinked directly into `~/.config`.

## Development Notes

- **Hyprland:** Main configuration is in `hypr/`.
- **Neovim / VPS:** These are managed in separate branches (`nvim` and `server`, respectively). If you need to work on those, ensure you are on the correct branch.
- **Paths:** Always assume configuration is managed via symlinks. Do not edit files in `~/.config` directly if you want changes to persist; edit them in this repository and (re)run `install.sh` if necessary.
