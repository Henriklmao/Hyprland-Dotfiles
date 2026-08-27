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
  "mimeapps|$DOTFILES_SRC/mimeapps.list|$HOME/.config/mimeapps.list"
)

TERM_COMPONENTS=(kitty fish starship tmux fastfetch yazi nvim)
TERM_PACKAGES=(kitty fish starship tmux fastfetch yazi neovim git)

HYPR_COMPONENTS=(hypr waybar swaync wlogout rofi mimeapps)

# Define packages: "DisplayName|Source|PkgName|PostHook"
PACKAGES=(
  "rbw|pacman|rbw|post:rbw setup"
  "deezer|yay|deezer-enhanced-bin|"
  "qutebrowser|pacman|qutebrowser|"
  "omarchy-fish|pacman|omarchy-fish|"
  "kitty|pacman|kitty|"
  "yazi|pacman|yazi|"
  "equibop|yay|equibop|"
)

add_component_if_missing() {
  local candidate="$1"
  for existing in "${TO_INSTALL[@]}"; do
    if [ "$existing" == "$candidate" ]; then
      return 0
    fi
  done
  TO_INSTALL+=("$candidate")
}

install_terminal_packages() {
  local packages=("$@")
  local package_list
  package_list="${packages[*]}"

  if ! command -v pacman >/dev/null 2>&1; then
    warn "Pacman not available. Skipping package installation btw."
    info "Install these packages manually: ${package_list}"
    return 0
  fi

  info "Installing terminal packages via pacman..."
  sudo pacman -S --needed "${packages[@]}"
  success "Terminal packages installed."
}

cleanup_broken_files() {
  local files=(
    "$HOME/.config/fish/conf.d/uv.env.fish"
  )
  for f in "${files[@]}"; do
    if [ -e "$f" ]; then
      # Only remove if the sourced file doesn't exist
      local src_file
      src_file=$(grep -oP 'source "\K[^"]+' "$f" 2>/dev/null | head -1)
      if [ -n "$src_file" ] && [ ! -e "$(eval echo "$src_file")" ]; then
        warn "Removing broken file: $f (sources non-existent $src_file)"
        rm "$f"
      fi
    fi
  done
}

add_package_if_missing() {
  local candidate="$1"
  for existing in "${TO_INSTALL_PKG[@]}"; do
    if [ "$existing" == "$candidate" ]; then
      return 0
    fi
  done
  TO_INSTALL_PKG+=("$candidate")
}

install_package() {
  local display_name="$1"
  for pkg_def in "${PACKAGES[@]}"; do
    IFS="|" read -r name source pkg_name post_hook <<<"$pkg_def"
    if [ "$name" == "$display_name" ]; then
      # Check if already installed
      if command -v "$pkg_name" >/dev/null 2>&1; then
        info "$pkg_name already installed, skipping."
        return 0
      fi

      info "Installing $pkg_name via $source..."
      case "$source" in
        pacman)
          sudo pacman -S --needed --noconfirm "$pkg_name"
          ;;
        yay)
          if ! command -v yay >/dev/null 2>&1; then
            error "yay is not installed. Cannot install $pkg_name."
          fi
          yay -S --needed --noconfirm "$pkg_name"
          ;;
        *)
          error "Unknown package source: $source"
          ;;
      esac
      success "Installed $pkg_name."

      # Run post-hook if specified
      if [ -n "$post_hook" ]; then
        local hook_cmd="${post_hook#post:}"
        info "Running post-install: $hook_cmd"
        eval "$hook_cmd"
      fi
      return 0
    fi
  done
  error "Package '$display_name' not found."
}

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

install_qute_readability() {
  if ! command -v npm >/dev/null 2>&1; then
    warn "npm not available. Skipping @mozilla/readability installation."
    return 0
  fi

  info "Installing @mozilla/readability and dependencies via npm..."
  npm install -g @mozilla/readability jsdom qutejs
  success "Installed @mozilla/readability, jsdom, and qutejs."
}

usage() {
  echo "Usage: $0 [options]"
  echo "Options:"
  for comp in "${COMPONENTS[@]}"; do
    IFS="|" read -r name src dest <<<"$comp"
    echo "  --${name}        Install ${name} config"
  done
  echo "  -t, --term         Install all terminal related configs and required packages"
  echo "  --qute             Install qutebrowser config and @mozilla/readability
  --hypr             Install Hyprland configs (hypr, waybar, swaync, wlogout, rofi, mimeapps)"
  echo "  --packages <list>  Install packages (comma-separated, e.g. --packages rbw,deezer)"
  echo "  --all-packages     Install all packages"
  echo "  -a, --all          Install all configs"
  echo "  -h, --help         Show this help"
  echo ""
  echo "Available packages:"
  for pkg_def in "${PACKAGES[@]}"; do
    IFS="|" read -r name source pkg_name post_hook <<<"$pkg_def"
    echo "  $name ($source: $pkg_name)"
  done
  exit 1
}

# --- Parsing Arguments ---
if [ $# -eq 0 ]; then
  usage
fi

INSTALL_ALL=false
INSTALL_TERM=false
INSTALL_HYPR=false
INSTALL_ALL_PACKAGES=false
TO_INSTALL=()
TO_INSTALL_PKG=()

while [[ $# -gt 0 ]]; do
  case "$1" in
  --all | -a)
    INSTALL_ALL=true
    shift
    ;;
  --term | -t)
    INSTALL_TERM=true
    shift
    ;;
  --hypr)
    INSTALL_HYPR=true
    shift
    ;;
  --qute)
    add_component_if_missing "qutebrowser"
    shift
    ;;
  --all-packages)
    INSTALL_ALL_PACKAGES=true
    shift
    ;;
  --packages)
    IFS="," read -ra pkg_list <<<"$2"
    for p in "${pkg_list[@]}"; do
      add_package_if_missing "$p"
    done
    shift 2
    ;;
  --help | -h) usage ;;
  --*)
    comp_name="${1#--}"
    # Verify it exists
    found=false
    for comp in "${COMPONENTS[@]}"; do
      IFS="|" read -r name src dest <<<"$comp"
      if [ "$name" == "$comp_name" ]; then
        add_component_if_missing "$name"
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
    add_component_if_missing "$name"
  done
fi

if [ "$INSTALL_TERM" = true ]; then
  for component in "${TERM_COMPONENTS[@]}"; do
    add_component_if_missing "$component"
  done
fi

if [ "$INSTALL_HYPR" = true ]; then
  for component in "${HYPR_COMPONENTS[@]}"; do
    add_component_if_missing "$component"
  done
fi

if [ "$INSTALL_ALL_PACKAGES" = true ]; then
  for pkg_def in "${PACKAGES[@]}"; do
    IFS="|" read -r name source pkg_name post_hook <<<"$pkg_def"
    add_package_if_missing "$name"
  done
fi

if [ "${#TO_INSTALL[@]}" -eq 0 ] && [ "${#TO_INSTALL_PKG[@]}" -eq 0 ]; then
  error "No components or packages selected."
fi

# Confirm components
if [ "${#TO_INSTALL[@]}" -gt 0 ]; then
  info "The following components will be installed:"
  for name in "${TO_INSTALL[@]}"; do
    echo "  - $name"
  done
fi

# Confirm packages
if [ "${#TO_INSTALL_PKG[@]}" -gt 0 ]; then
  info "The following packages will be installed:"
  for name in "${TO_INSTALL_PKG[@]}"; do
    echo "  - $name"
  done
fi

read -r -p "Continue? [y/N]: " confirm
case "$confirm" in
y | Y | yes | YES | Yes) ;;
*)
  warn "Installation aborted."
  exit 0
  ;;
esac

if [ "$INSTALL_TERM" = true ]; then
  install_terminal_packages "${TERM_PACKAGES[@]}"
fi

cleanup_broken_files

for name in "${TO_INSTALL[@]}"; do
  install_component "$name"
done

# Install @mozilla/readability if qutebrowser is being installed
for name in "${TO_INSTALL[@]}"; do
  if [ "$name" == "qutebrowser" ]; then
    install_qute_readability
    break
  fi
done

for name in "${TO_INSTALL_PKG[@]}"; do
  install_package "$name"
done

success "Configuration finished!"
