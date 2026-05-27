-- Decoration
hl.config({
    decoration = {
        rounding = 2,
        shadow = {
            enabled = true,
            range = 2,
            render_power = 3,
            color = "rgba(1a1a1aee)"
        },
        blur = {
            enabled = true,
            size = 2,
            passes = 2,
            special = true,
            brightness = 0.60,
            contrast = 0.75
        }
    }
})

hl.layer_rule({
    match = { namespace = "waybar" },
    blur = true
})
