#!/usr/bin/env bash
# Sync the dotfiles repository when Hyprland starts.
# - Success: low-priority notification.
# - Merge conflicts: critical notification; clicking it opens lazygit in the repo.
set -uo pipefail

APP_NAME="Dotfiles Sync"
SCRIPT_DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"
REPO_DIR="${DOTFILES_SYNC_REPO:-$(dirname "$SCRIPT_DIR")}"

open_lazygit() {
  if command -v uwsm-app >/dev/null 2>&1; then
    setsid -f uwsm-app -- kitty --class lazygit -e lazygit -p "$REPO_DIR" >/dev/null 2>&1
  else
    setsid -f kitty --class lazygit -e lazygit -p "$REPO_DIR" >/dev/null 2>&1
  fi
}

if ! git -C "$REPO_DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  notify-send -a "$APP_NAME" -i dialog-error -u critical \
    "Dotfiles sync failed" "No git repository at $REPO_DIR"
  exit 1
fi

# Keep startup non-interactive: no credential prompts and no editor for merges.
if GIT_TERMINAL_PROMPT=0 GIT_MERGE_AUTOEDIT=no GIT_EDITOR=true \
  timeout 60s git -C "$REPO_DIR" pull --no-edit >/dev/null 2>&1; then
  notify-send -a "$APP_NAME" -i dialog-information -u low \
    "Dotfiles synced Successfully" "$REPO_DIR"
  exit 0
fi

if [ -n "$(git -C "$REPO_DIR" diff --name-only --diff-filter=U)" ]; then
  selected="$(notify-send -a "$APP_NAME" -i dialog-warning -u critical -t 0 \
    --action="default=Open lazygit" \
    "Merge conflicts" "Click to resolve them in lazygit")"
  if [ "$selected" = "default" ]; then
    open_lazygit
  fi
  exit 1
fi

# Network, authentication, diverged branch and other non-conflict failures.
selected="$(notify-send -a "$APP_NAME" -i dialog-error -u critical -t 0 \
  --action="default=Open lazygit" \
  "Dotfiles sync failed" "Click to inspect the repository in lazygit")"
if [ "$selected" = "default" ]; then
  open_lazygit
fi
exit 1
