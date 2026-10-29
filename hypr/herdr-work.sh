#!/usr/bin/env bash
# herdr-work: ensure herdr workspace "Work" (cwd ~/Work) exists, then attach.
# - Neuerstellung: workspace "Work" mit Tab/Pane "~Work agent" + opencode
# - Falls vorhanden: nur fokussieren, nichts anfassen
# Wird von bindings.lua via `kitty --class herdr-work -- ~/.config/hypr/herdr-work.sh` gestartet.
set -euo pipefail

WORK_DIR="$HOME/Work"
WORK_LABEL="Work"
PANE_LABEL="~Work agent"
AGENT_NAME="work-agent"
AGENT_KIND="opencode"

mkdir -p "$WORK_DIR"

# Existierenden Workspace anhand Label suchen (jq ist vorhanden, siehe omarchy-launch-or-focus).
WS_ID="$(herdr workspace list 2>/dev/null | jq -r --arg l "$WORK_LABEL" '.result.workspaces[] | select(.label == $l) | .workspace_id' | head -n1 || true)"

if [[ -z "${WS_ID:-}" || "$WS_ID" == "null" ]]; then
  CREATED="$(herdr workspace create --cwd "$WORK_DIR" --label "$WORK_LABEL")"
  WS_ID="$(echo "$CREATED" | jq -r '.result.workspace.workspace_id')"
  PANE_ID="$(echo "$CREATED" | jq -r '.result.root_pane.pane_id')"
  TAB_ID="$(echo "$CREATED" | jq -r '.result.tab.tab_id')"

  herdr tab rename "$TAB_ID" "$PANE_LABEL" >/dev/null

  # opencode als erkannter Agent starten; Fallback: einfach `opencode` in die Pane tippen.
  if ! herdr agent start "$AGENT_NAME" --kind "$AGENT_KIND" --pane "$PANE_ID" >/dev/null 2>&1; then
    herdr pane run "$PANE_ID" "$AGENT_KIND" >/dev/null 2>&1 || true
  fi
fi

# Neues kitty-Fenster soll direkt im Work-Workspace landen.
herdr workspace focus "$WS_ID" >/dev/null 2>&1 || true

exec herdr
