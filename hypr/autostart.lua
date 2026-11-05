-- Extra autostart processes.
-- o.launch_on_start("my-service")
o.launch_on_start("kdeconnectd")
o.launch_on_start("kdeconnect-indicator")
hl.exec_cmd("omarchy shell io.github.elevate08.qs-bitwarden-cli open")
hl.exec_cmd("bash " .. (os.getenv("HOME") or "~") .. "/.config/hypr/dotfiles-sync.sh")
if not IS_SURFACE then
	hl.exec_cmd("headsetcontrol -s 115")
end
