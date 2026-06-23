#!/usr/bin/env bash

# Selective Dotfiles Installer with Backup
set -e

# --- Colors ---
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# --- UI ---
info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() {
  echo -e "${RED}[ERROR]${NC} $1"
  exit 1
}

# --- Definitions ---
DOTFILES_SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Define components: "Name|SourcePath|TargetPath"
COMPONENTS=(
  "hypr|$DOTFILES_SRC/hypr|$HOME/.config/hypr"
  "nwg-dock-hyprland|$DOTFILES_SRC/nwg-dock-hyprland|$HOME/.config/nwg-dock-hyprland"
  "waybar|$DOTFILES_SRC/waybar|$HOME/.config/waybar"
  "rofi|$DOTFILES_SRC/rofi|$HOME/.config/rofi"
  "swaync|$DOTFILES_SRC/swaync|$HOME/.config/swaync"
  "wlogout|$DOTFILES_SRC/wlogout|$HOME/.config/wlogout"
  "kitty|$DOTFILES_SRC/kitty|$HOME/.config/kitty"
  "fastfetch|$DOTFILES_SRC/fastfetch|$HOME/.config/fastfetch"
  "starship|$DOTFILES_SRC/starship.toml|$HOME/.config/starship.toml"
  "tmux|$DOTFILES_SRC/tmux|$HOME/.config/tmux"
  "fish|$DOTFILES_SRC/fish|$HOME/.config/fish"
  "qutebrowser|$DOTFILES_SRC/qutebrowser|$HOME/.config/qutebrowser"
  "quickshell|$DOTFILES_SRC/quickshell|$HOME/.config/quickshell"
)

backup_and_link() {
  local name="$1"
  local src="$2"
  local dest="$3"
  local dest_dir
  dest_dir=$(dirname "$dest")

  mkdir -p "$dest_dir"

  if [ -L "$dest" ]; then
    warn "Existing symlink found at $dest. Removing it."
    rm "$dest"
  elif [ -e "$dest" ]; then
    local backup="${dest}-"
    warn "Existing $name config found at $dest. Creating backup: $backup"
    # Remove existing backup if it exists to avoid error
    [ -e "$backup" ] && rm -rf "$backup"
    mv "$dest" "$backup"
  fi

  ln -s "$src" "$dest"
  success "Linked $name: $src -> $dest"
}

install_component() {
  local name_to_install="$1"
  for comp in "${COMPONENTS[@]}"; do
    IFS="|" read -r name src dest <<<"$comp"
    if [ "$name" == "$name_to_install" ]; then
      info "Installing $name..."
      backup_and_link "$name" "$src" "$dest"
      return 0
    fi
  done
  error "Component '$name_to_install' not found."
}

usage() {
  echo "Usage: $0 [options]"
  echo "Options:"
  for comp in "${COMPONENTS[@]}"; do
    IFS="|" read -r name src dest <<<"$comp"
    echo "  --${name}        Install ${name} config"
  done
  echo "  -a, --all     Install all configs"
  echo "  -h, --help    Show this help"
  exit 1
}

# --- Parsing Arguments ---
if [ $# -eq 0 ]; then
  usage
fi

INSTALL_ALL=false
TO_INSTALL=()

while [[ $# -gt 0 ]]; do
  case "$1" in
  --all | -a)
    INSTALL_ALL=true
    shift
    ;;
  --help | -h) usage ;;
  --*)
    comp_name="${1#--}"
    # Verify it exists
    found=false
    for comp in "${COMPONENTS[@]}"; do
      IFS="|" read -r name src dest <<<"$comp"
      if [ "$name" == "$comp_name" ]; then
        TO_INSTALL+=("$name")
        found=true
      fi
    done
    if [ "$found" = false ]; then
      error "Unknown component: $comp_name"
    fi
    shift
    ;;
  *) error "Unknown option: $1" ;;
  esac
done

if [ "$INSTALL_ALL" = true ]; then
  for comp in "${COMPONENTS[@]}"; do
    IFS="|" read -r name src dest <<<"$comp"
    install_component "$name"
  done
else
  for name in "${TO_INSTALL[@]}"; do
    install_component "$name"
  done
fi

success "Configuration finished!"
