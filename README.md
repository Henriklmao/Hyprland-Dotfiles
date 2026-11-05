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

## Firefox

A minimal, qutebrowser-inspired UI lives in `firefox/`:

- The top bar autohides to a 3px strip; it opens on hover/focus and for
  2 seconds after switching tabs (like qutebrowser's `tabs.show = switching`)
- Small tabs (max. 170 px) on the left, pinned extension icons plus hamburger
  menu and extension panel on the right
- URL bar hidden until focused (`Ctrl+L` / `Alt+D`)
- No new-tab button, tab close buttons, bookmarks bar or window controls
- Colors follow the current Omarchy theme via the generated
  `chrome/omarchy-mode.css` from `omarchy-firefox-mode` (retro-82 fallback)

`--uc-pinned-slots` at the top of `userChrome.css` controls how much room the
tab strip reserves for pinned extension icons (default: 4).

Install it with:

```bash
./install.sh --firefox
```

This links `chrome/` and `user.js` into the default Firefox profile
(`~/.config/mozilla/firefox/profiles.ini`), backing up anything that already
exists. Restart Firefox afterwards.

## Neovim

Neovim configuration based on LazyVim can be found in the [nvim branch](https://github.com/Henriklmao/Hyprland-Dotfiles/tree/nvim).

Quick Install:

```bash
git clone --branch nvim https://github.com/Henriklmao/Hyprland-Dotfiles.git ~/.config/nvim
```

### Headless nvim

My Headless/VPS nvim configurations are located in the [server branch](https://github.com/Henriklmao/Hyprland-Dotfiles/tree/server).
