-- Autostart
hl.on("hyprland.start", function()
	-- From autostart.conf
	hl.exec_cmd("~/.config/ml4w/listeners.sh --startall")
	hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
	hl.exec_cmd("~/.config/ml4w/scripts/ml4w-wallpaper-app --restore")
	hl.exec_cmd("~/.config/ml4w/scripts/ml4w-autostart")
	hl.exec_cmd("~/.config/hypr/scripts/gtk.sh")
	hl.exec_cmd("swaync")
	hl.exec_cmd("hypridle")
	hl.exec_cmd("wl-paste --watch cliphist store")
	hl.exec_cmd("~/.config/hypr/scripts/cleanup.sh")
	hl.exec_cmd("~/.config/com.ml4w.hyprlandsettings/hyprctl.sh")

	-- Ensure QuickShell runs with the user's profile so Super+Esc targets the correct instance
	hl.exec_cmd("qs -p ~/.config/quickshell")

	-- From HenrikHyprkey_Standard.conf
	hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
	hl.exec_cmd("kdeconnect-indicator")
	hl.exec_cmd("/usr/bin/kdeconnectd")

	-- GTK Settings
	hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'")
	hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3'")
	hl.exec_cmd("cliphist wipe")
	hl.exec_cmd("tirith daemon start")
end)
