-- Extra autostart processes.
-- o.launch_on_start("my-service")
o.launch_on_start("kdeconnectd")
o.launch_on_start("kdeconnect-indicator")
if not IS_SURFACE then
	hl.exec_cmd("headsetcontrol -s 115")
end
