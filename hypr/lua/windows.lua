-- Window Rules
hl.window_rule({
    match = { class = "org.pulseaudio.pavucontrol" },
    float = true,
    size = "700 600",
    center = true,
    pin = true
})

-- Scroll settings (Note: syntax might vary for specific rules)
hl.window_rule({
    match = { class = "Alacritty|kitty" },
    ["scroll_touchpad"] = 1.5
})

hl.window_rule({
    match = { class = "com.mitchellh.ghostty" },
    ["scroll_touchpad"] = 0.2
})

-- Workspace assignments
hl.window_rule({
    match = { class = "equibop" },
    workspace = "2"
})
