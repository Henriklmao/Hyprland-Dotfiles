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
o.bind("SUPER + SHIFT + F", "File manager", 'kitty --class yazi-float fish -c "y; exec fish"')
hl.unbind("SUPER + SHIFT + B")
o.bind("SUPER + SHIFT + B", "Browser", "firefox")
hl.unbind("SUPER + SHIFT + ALT + B")
o.bind("SUPER + SHIFT + ALT + B", "Browser (private)", "firefox --private-window")
hl.unbind("SUPER + SHIFT + M")
o.bind("SUPER + SHIFT + M", "Music", 'omarchy-launch-or-focus "deezer-enhanced %"')
hl.unbind("SUPER + SHIFT + N")
hl.bind("SUPER + SHIFT + N", hl.dsp.exec_cmd("kitty -- tmux new-session -A -s editor nvim"))
hl.unbind("SUPER + RETURN")
o.bind("SUPER + RETURN", "Activity", "omarchy-launch-tui btop")
hl.unbind("SUPER + SHIFT + G")
o.bind("SUPER + SHIFT + G", "Github", 'firefox "https://Github.com/"')
hl.unbind("SUPER + SHIFT + D")
o.bind("SUPER + SHIFT + D", "Discord", "uwsm-app -- equibop")
hl.unbind("SUPER + SHIFT + O")
o.bind("SUPER + SHIFT + O", "Herdr", 'omarchy-launch-or-focus "herdr-work" "kitty --class herdr-work -- ~/.config/hypr/herdr-work.sh"')
hl.unbind("SUPER + SHIFT + E")
o.bind("SUPER + SHIFT + E", "E-mail", "uwsm-app -- thunderbird")
hl.unbind("SUPER + SHIFT + Y")
o.bind("SUPER + SHIFT + Y", "YouTube", 'firefox "https://youtube.com/"')
hl.unbind("SUPER + SHIFT + X")
o.bind("SUPER + SHIFT + X", "Twitter", 'firefox "https://x.com/"')
hl.unbind("SUPER + DELETE")
o.bind("SUPER + DELETE", "Color picker", "pkill hyprpicker || hyprpicker -a")
-- fast note todo plugin
o.bind("SUPER + SHIFT + s", "Fast-note-todo", "omarchy-shell io.github.viganogabriele.fast-note-todo open")
-- AI Chatbot binding
hl.unbind("SUPER + SHIFT + A")
if IS_SURFACE then
  o.bind("SUPER + SHIFT + A", "Chatbot: Gemini", "firefox https://gemini.google.com/app")
else
  o.bind("SUPER + SHIFT + A", "Odysseus", "firefox http://localhost:7000/")
end
-- Omarchy bitwarden binding
hl.unbind("SUPER + SHIFT + P")
o.bind("SUPER + SHIFT + P", "Bitwarden", "omarchy shell io.github.elevate08.qs-bitwarden-cli open")

-- Dictation keys from before Alt + Space and Right Alt became the defaults.
-- Remove these lines to give the keys back to applications.
if o.dictation_installed and o.dictation_installed() then
  o.bind("SUPER + CTRL + X", "Toggle dictation", "omarchy-dictation toggle")
  o.bind_hold("F9", "Start dictation (push-to-talk)", "omarchy-dictation start", "Stop dictation (push-to-talk)", "omarchy-dictation stop")
end

-- Universal clipboard ---------------------------------------------------------
-- Omarchy 4.5 sends Ctrl+Shift+C/V to windows that carry the "terminal" tag.
-- That breaks two cases for us:
--   * Windows started with a custom class (herdr-work, yazi-float, lazygit, ...)
--     never get the tag, so Super+C/V fall back to Ctrl+C/V. In herdr that is
--     SIGINT instead of copy.
--   * Ctrl+Shift+C/V is exact-matched by some terminals (e.g. foot) and
--     swallowed by full-screen TUIs (e.g. Codex CLI).
-- Recognize terminals by class and initial class too, and use the pre-4.5
-- Insert chords, which every terminal emulator and TUI supports.
local function send_shortcut_once(mods, key)
  return function()
    hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "down" }))

    hl.timer(function()
      hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "up" }))
    end, { timeout = 50, type = "oneshot" })
  end
end

-- Same set Omarchy tags, plus the class names other terminals report and the
-- literal WezTerm app id (Omarchy only matches "wezterm").
local terminal_classes = {
  "^Alacritty$",
  "^kitty$",
  "^com%.mitchellh%.ghostty$",
  "^wezterm$",
  "^org%.wezfurlong%.wezterm$",
  "^foot$",
  "^org%.codeberg%.dnkl%.foot$",
  "^st$",
  "^xterm$",
  "^urxvt.*$",
  "^contour$",
  "^org%.omarchy%..*$",
  "^TUI%..*$",
}

-- A custom --class hides the terminal from the rules above (the window class
-- becomes e.g. "herdr-work" and even initial_class follows it), so also look at
-- the process that owns the window.
local terminal_processes = {
  kitty = true,
  alacritty = true,
  foot = true,
  ghostty = true,
  wezterm = true,
  ["wezterm-gui"] = true,
  st = true,
  xterm = true,
  urxvt = true,
  contour = true,
  konsole = true,
  ["gnome-terminal-"] = true,
  tilix = true,
  sakura = true,
}

local function window_process_name(window)
  if not window.pid then
    return nil
  end

  local file = io.open("/proc/" .. window.pid .. "/comm", "r")
  if not file then
    return nil
  end

  local name = file:read("l")
  file:close()
  return name
end

local function active_window_is_terminal()
  local window = hl.get_active_window()
  if not window then
    return false
  end

  for _, tag in ipairs(window.tags or {}) do
    if tag:gsub("%*$", "") == "terminal" then
      return true
    end
  end

  for _, class in ipairs({ window.class or "", window.initial_class or "" }) do
    for _, pattern in ipairs(terminal_classes) do
      if class:match(pattern) then
        return true
      end
    end
  end

  local process = window_process_name(window)
  return process ~= nil and terminal_processes[process] == true
end

local function universal_clipboard_shortcut(default_mods, default_key, terminal_mods, terminal_key)
  return function()
    if active_window_is_terminal() then
      send_shortcut_once(terminal_mods, terminal_key)()
    else
      send_shortcut_once(default_mods, default_key)()
    end
  end
end

-- Keep the same helper shape as Omarchy's default so the keybindings menu and
-- any future default changes still work.
local universal_copy = universal_clipboard_shortcut("CTRL", "C", "CTRL", "Insert")
local universal_paste = universal_clipboard_shortcut("CTRL", "V", "SHIFT", "Insert")
o.rebind("SUPER + C", "Universal copy", universal_copy)
o.rebind("SUPER + V", "Universal paste", universal_paste)
