local hl = require("hyprland")
hl.bind({ "SUPER", "CTRL" }, "plus", hl.dsp.exec_cmd("~/.config/hypr/scripts/zoom.sh in"), { repeating = true })
hl.bind({ "SUPER", "CTRL" }, "minus", hl.dsp.exec_cmd("~/.config/hypr/scripts/zoom.sh out"), { repeating = true })
