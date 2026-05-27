-- Main Hyprland Configuration (Lua)
-- Fully migrated from HenrikHyprkey_Standard.conf and ML4W configs

-- Environment
require("lua.env")

-- Core Settings
require("lua.general")
require("lua.keyboard")
require("lua.misc")
require("lua.layout")

-- Visuals
require("lua.decoration")
require("lua.animation")
require("lua.monitors")

-- Rules & Custom
require("lua.windows")
require("lua.ml4w")
-- Keybindings
require("lua.keybindings")

-- Autostart
require("lua.autostart")

-- Start command (Global environment update)
hl.on("hyprland.start", function()
	hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
	hl.exec_cmd("xdg-user-dirs-update")
end)
