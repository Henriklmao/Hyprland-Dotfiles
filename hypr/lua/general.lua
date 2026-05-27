-- General & Group Settings
hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 10,
        border_size = 2,
        ["col.active_border"] = {
            colors = { "rgba(33ccffee)", "rgba(00ff99ee)" },
            angle = 45
        },
        ["col.inactive_border"] = "rgba(595959aa)",
        resize_on_border = false,
        allow_tearing = false,
        layout = "dwindle"
    },
    group = {
        ["col.border_active"] = {
            colors = { "rgba(33ccffee)", "rgba(00ff99ee)" },
            angle = 45
        },
        ["col.border_inactive"] = "rgba(595959aa)",
        ["col.border_locked_active"] = "rgba(66ff5500)",
        ["col.border_locked_inactive"] = "rgba(66775500)",
        groupbar = {
            font_size = 12,
            font_family = "monospace",
            font_weight_active = "ultraheavy",
            font_weight_inactive = "normal",
            text_color = "rgba(ffffffff)"
        }
    }
})
