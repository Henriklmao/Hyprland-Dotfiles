-- Keybindings
local mainMod = "SUPER"

-- Basic Actions
hl.bind(mainMod .. " + W", hl.dsp.window.kill())
hl.bind("CTRL + ALT + DELETE", hl.dsp.exec_cmd("pkill -9 hyprland"))

-- UI Toggles
hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd("~/.config/waybar/toggle.sh"))
hl.bind(mainMod .. " + ESCAPE", hl.dsp.exec_cmd("qs ipc call power toggle"))
hl.bind(mainMod .. " + CTRL + ESCAPE", hl.dsp.exec_cmd("wlshutdown"))

-- Launcher
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("~/.config/hypr/scripts/launcher.sh"))

-- Focus & Navigation
hl.bind("ALT + TAB", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + LEFT", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + RIGHT", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + UP", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + DOWN", hl.dsp.focus({ direction = "d" }))

-- Window Movement
hl.bind(mainMod .. " + SHIFT + LEFT", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + RIGHT", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + UP", hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + DOWN", hl.dsp.window.move({ direction = "d" }))

-- Layout Controls
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + T", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle", type = "real" }))
hl.bind(mainMod .. " + CTRL + F", hl.dsp.window.fullscreen({ action = "toggle", type = "internal" }))
hl.bind(mainMod .. " + ALT + F", hl.dsp.window.fullscreen({ action = "toggle", type = "internal" }))

-- Mouse Bindings
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Workspaces Loop
for i = 1, 10 do
	local code = 10 + (i - 1)

	-- Focus workspace
	hl.bind(mainMod .. " + code:" .. code, hl.dsp.focus({ workspace = tostring(i) }))

	-- Move to workspace
	hl.bind(mainMod .. " + SHIFT + code:" .. code, hl.dsp.window.move({ workspace = tostring(i) }))

	-- Move to workspace silent
	hl.bind(
		mainMod .. " + SHIFT + ALT + code:" .. code,
		hl.dsp.window.move({ workspace = tostring(i), follow = false })
	)
end

-- Media Controls
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s 5%+"), { repeating = true, locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 5%-"), { repeating = true, locked = true })
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"),
	{ repeating = true, locked = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ repeating = true, locked = true }
)
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })

hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Screenshots
hl.bind("Print", hl.dsp.exec_cmd("hyprshot -m output"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("hyprshot -m region"))

-- Zoom
hl.bind(mainMod .. " + CTRL + plus", hl.dsp.exec_cmd("~/.config/hypr/scripts/zoom.sh in"), { repeating = true })
hl.bind(mainMod .. " + CTRL + minus", hl.dsp.exec_cmd("~/.config/hypr/scripts/zoom.sh out"), { repeating = true })

-- App Launchers
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd("kitty btop"))
hl.bind(mainMod .. " + SHIFT + T", hl.dsp.exec_cmd("~/.config/ml4w/settings/terminal.sh"))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.exec_cmd("nautilus"))
hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd("firefox"))
hl.bind(mainMod .. " + SHIFT + ALT + B", hl.dsp.exec_cmd("firefox --private-window"))
hl.bind(mainMod .. " + SHIFT + G", hl.dsp.exec_cmd("firefox --new-tab https://Github.com/"))
hl.bind(mainMod .. " + SHIFT + D", hl.dsp.exec_cmd("org.equicord.equibop"))
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd("betterbird"))
hl.bind(mainMod .. " + SHIFT + X", hl.dsp.exec_cmd("firefox https://x.com/"))
hl.bind(mainMod .. " + SHIFT + Y", hl.dsp.exec_cmd("firefox https://youtube.com/"))
hl.bind(mainMod .. " + SHIFT + A", hl.dsp.exec_cmd("firefox https://gemini.google.com"))
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exec_cmd("deezer-enhanced"))
hl.bind(mainMod .. " + SHIFT + N", hl.dsp.exec_cmd("kitty nvim"))
hl.bind(mainMod .. " + ALT + B", hl.dsp.exec_cmd("btop"))
hl.bind(mainMod .. " + SHIFT + O", hl.dsp.exec_cmd("md.obsidian.Obsidian"))

-- Tools
hl.bind(mainMod .. " + DELETE", hl.dsp.exec_cmd("hyprpicker -a"))
hl.bind(mainMod .. " + CTRL + GRAVE", hl.dsp.exec_cmd("slurp -o | wl-copy"))
-- Systemwide Super+C/V/X
local function send_shortcut_once(mods, key)
	return function()
		hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "down", window = "activewindow" }))

		hl.timer(function()
			hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "up", window = "activewindow" }))
		end, { timeout = 50, type = "oneshot" })
	end
end

hl.bind("SUPER + C", send_shortcut_once("CTRL", "Insert"))
hl.bind("SUPER + V", send_shortcut_once("SHIFT", "Insert"))
hl.bind("SUPER + X", send_shortcut_once("CTRL", "X"))
hl.bind(mainMod .. " + CTRL + V", hl.dsp.exec_cmd("~/.config/ml4w/scripts/ml4w-cliphist"))
