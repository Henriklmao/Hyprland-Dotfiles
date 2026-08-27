-- Extra autostart processes.
-- o.launch_on_start("my-service")
o.launch_on_start("kdeconnectd")
o.launch_on_start("kdeconnect-indicator")

hl.exec_cmd([[bash -c '
  output=$(cd ~/Dotfiles && git pull 2>&1)
  if [ $? -ne 0 ]; then
    notify-send "Dotfiles Update" "Manual intervention required" -u critical
    kitty --class lazygit sh -c 'cd ~/Dotfiles && lazygit'
  elif echo "$output" | grep -q "Already up to date"; then
    true
  else
    notify-send "Dotfiles Update" "Updated successfully" -u low
  fi
']])
if not IS_SURFACE then
	hl.exec_cmd("headsetcontrol -s 115")
end
