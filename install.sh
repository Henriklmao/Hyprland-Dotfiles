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
  "yazi|$DOTFILES_SRC/yazi|$HOME/.config/yazi"
  "nvim|nvim-branch|$HOME/.config/nvim"
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
      if [ "$name" == "nvim" ]; then
        install_nvim
      else
        backup_and_link "$name" "$src" "$dest"
      fi
      return 0
    fi
  done
  error "Component '$name_to_install' not found."
}

install_nvim() {
  local nvim_target="$HOME/.config/nvim"
  local nvim_backup="${nvim_target}-"
  local nvim_repo="https://github.com/Henriklmao/Hyprland-Dotfiles.git"

  mkdir -p "$(dirname "$nvim_target")"

  if [ -L "$nvim_target" ]; then
    warn "Existing symlink found at $nvim_target. Removing it."
    rm "$nvim_target"
  elif [ -e "$nvim_target" ]; then
    warn "Existing nvim config found at $nvim_target. Creating backup: $nvim_backup"
    [ -e "$nvim_backup" ] && rm -rf "$nvim_backup"
    mv "$nvim_target" "$nvim_backup"
  fi

  git clone --branch nvim --single-branch "$nvim_repo" "$nvim_target"
  success "Cloned nvim branch to $nvim_target"
}

confirm_installation() {
  local components=("$@")

  info "The following components will be installed:"
  for name in "${components[@]}"; do
    echo "  - $name"
  done

  read -r -p "Continue? [y/N]: " confirm
  case "$confirm" in
  y | Y | yes | YES | Yes) ;;
  *)
    warn "Installation aborted."
    exit 0
    ;;
  esac
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
  TO_INSTALL=()
  for comp in "${COMPONENTS[@]}"; do
    IFS="|" read -r name src dest <<<"$comp"
    TO_INSTALL+=("$name")
  done
fi

if [ "${#TO_INSTALL[@]}" -eq 0 ]; then
  error "No components selected."
fi

confirm_installation "${TO_INSTALL[@]}"

for name in "${TO_INSTALL[@]}"; do
  install_component "$name"
done

success "Configuration finished!"
