-- ML4W Config

-- SwayNC Layer Rules
hl.layer_rule({
    match = { namespace = "swaync-control-center" },
    blur = true,
    ignore_alpha = 0.5
})
hl.layer_rule({
    match = { namespace = "swaync-notification-window" },
    blur = true,
    ignore_alpha = 0.5
})

-- Window Rules Helper
local function add_ml4w_window(args)
    hl.window_rule({
        name = args.name,
        match = { class = args.class, title = args.title },
        float = true,
        center = args.center,
        pin = true,
        size = args.size,
        move = args.move
    })
end

add_ml4w_window({ name = "pavucontrol", class = ".*org.pulseaudio.pavucontrol.*", size = "700 600", center = true })
add_ml4w_window({ name = "waypaper", class = ".*waypaper.*", size = "900 700", center = true })
add_ml4w_window({ name = "newelle", class = "io.github.qwersyk.Newelle", size = "1000 700", center = true })
add_ml4w_window({ name = "ml4w-calendar", class = "com.ml4w.calendar", size = "400 400", move = "21 76" })
add_ml4w_window({ name = "ml4w-sidebar", class = "com.ml4w.sidebar", size = "400 660", move = "monitor_w-window_w-21 76" })
add_ml4w_window({ name = "ml4w-welcome", class = "com.ml4w.welcome", size = "700 600", center = true })
add_ml4w_window({ name = "ml4w-welcome-app", title = "ML4W Welcome", size = "700 600", center = true })
add_ml4w_window({ name = "ml4w-settings", class = "com.ml4w.settings", size = "900 600", move = "monitor_w*0.5-window_w*0.5 86" })
add_ml4w_window({ name = "ml4w-settings-app", title = "ML4W Dotfiles Settings", size = "900 600", move = "monitor_w*0.5-window_w*0.5 86" })
add_ml4w_window({ name = "blueman-manager", class = "blueman-manager", size = "800 600", center = true })
add_ml4w_window({ name = "nwg-look", class = "nwg-look", size = "700 600", center = true })
add_ml4w_window({ name = "nwg-displays", class = "nwg-displays", size = "900 600", center = true })
add_ml4w_window({ name = "missioncenter", class = "io.missioncenter.MissionCenter", size = "900 600", center = true })
add_ml4w_window({ name = "gnome-calculator", class = "org.gnome.Calculator", size = "700 600", center = true })
add_ml4w_window({ name = "hyprland-share-picker", class = "hyprland-share-picker", size = "600 400", center = true })
add_ml4w_window({ name = "nm-connection-editor", class = "nm-connection-editor", size = "800 700", center = true })
add_ml4w_window({ name = "dotfiles-floating", class = "dotfiles-floating", size = "1000 700", center = true })
add_ml4w_window({ name = "dotfiles-sidepad", class = "dotfiles-sidepad", size = "1000 700", center = true })

-- Picture-in-Picture
hl.window_rule({
    name = "Picture-in-Picture",
    match = { title = "^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$" },
    float = true,
    pin = true,
    center = true
})

-- PATHS
hl.env("PATH", os.getenv("PATH") .. ":" .. os.getenv("HOME") .. "/.cargo/bin:" .. os.getenv("HOME") .. "/.local/bin")

-- XDG Desktop Portal
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

-- QT
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")

-- GDK
hl.env("GDK_SCALE", "1")

-- Toolkit Backend
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("CLUTTER_BACKEND", "wayland")

-- Mozilla
hl.env("MOZ_ENABLE_WAYLAND", "1")

-- Set the cursor size for xcursor
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- Ozone
hl.env("OZONE_PLATFORM", "wayland")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")

-- SDL version
hl.env("SDL_VIDEODRIVER", "wayland")

-- Quickshell debug
hl.env("QS_NO_RELOAD_POPUP", "1")

-- XWayland
hl.config({
    xwayland = {
        force_zero_scaling = true
    }
})
