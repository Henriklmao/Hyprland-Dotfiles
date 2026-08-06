-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")

-- App bindings
hl.unbind("SUPER + ALT + T")
o.bind("SHIFT + ALT + T", "Tmux", 'uwsm-app -- xdg-terminal-exec --dir="$(omarchy-cmd-terminal-cwd)" tmux new')
hl.unbind("SUPER + SHIFT + T")
o.bind("SUPER + SHIFT + T", "Terminal", 'uwsm-app -- xdg-terminal-exec --dir="$(omarchy-cmd-terminal-cwd)"')
hl.unbind("SUPER + SHIFT + F")
o.bind("SUPER + SHIFT + F", "File manager", "kitty fish -c z && y &")
hl.unbind("SUPER + SHIFT + B")
o.bind("SUPER + SHIFT + B", "Browser", "qutebrowser")
hl.unbind("SUPER + SHIFT + ALT + B")
o.bind("SUPER + SHIFT + ALT + B", "Browser (private)", "qutebrowser --private")
hl.unbind("SUPER + SHIFT + M")
o.bind("SUPER + SHIFT + M", "Music", 'omarchy-launch-or-focus "deezer-enhanced %"')
hl.unbind("SUPER + SHIFT + N")
hl.bind("SUPER + SHIFT + N", hl.dsp.exec_cmd("kitty -- tmux new-session -A -s editor nvim"))
hl.unbind("SUPER + RETURN")
o.bind("SUPER + RETURN", "Activity", "omarchy-launch-tui btop")
hl.unbind("SUPER + SHIFT + G")
o.bind("SUPER + SHIFT + G", "Github", 'qutebrowser "https://Github.com/"')
hl.unbind("SUPER + SHIFT + D")
o.bind("SUPER + SHIFT + D", "Discord", "uwsm-app -- equibop")
hl.unbind("SUPER + SHIFT + O")
o.bind("SUPER + SHIFT + O", "Obsidian", 'omarchy-launch-or-focus "obsidian$" "uwsm-app -- obsidian"')
hl.unbind("SUPER + SHIFT + E")
o.bind("SUPER + SHIFT + E", "E-mail", "uwsm-app -- thunderbird")
hl.unbind("SUPER + SHIFT + A")
o.bind("SUPER + SHIFT + A", "Odysseus", "qutebrowser http://localhost:7000/")
hl.unbind("SUPER + SHIFT + Y")
o.bind("SUPER + SHIFT + Y", "YouTube", 'qutebrowser "https://youtube.com/"')
hl.unbind("SUPER + SHIFT + X")
o.bind("SUPER + SHIFT + X", "Twitter", 'qutebrowser "https://x.com/"')
hl.unbind("SUPER + DELETE")
o.bind("SUPER + DELETE", "Color picker", "pkill hyprpicker || hyprpicker -a")
hl.unbind("SUPER + CTRL + GRAVE")
o.bind("SUPER + CTRL + GRAVE", "Extract text (OCR) from screenshot", "omarchy-capture-text-extraction")
