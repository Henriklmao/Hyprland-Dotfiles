#!/usr/bin/env bash

entries="Shutdown
Reboot
Logout"

selected=$(echo -e $entries | rofi -dmenu -p "Power Menu" -i -theme-str '@import "main.rasi"')

case $selected in
    "Shutdown")
        ~/.config/hypr/scripts/power.sh shutdown
        ;;
    "Reboot")
        ~/.config/hypr/scripts/power.sh reboot
        ;;
    "Logout")
        ~/.config/hypr/scripts/power.sh exit
        ;;
esac
