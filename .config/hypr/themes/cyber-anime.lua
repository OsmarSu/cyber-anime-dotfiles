-- hyprland/themes/cyber-anime.lua
-- Aesthetic Cyber-Anime theme with Electric Cyan & Neon Magenta accents.

hl.config({
    general = {
        gaps_in  = 4,
        gaps_out = 8,

        border_size = 2,

        col = {
            active_border   = { colors = { "rgba(00f0ffff)", "rgba(ff007fff)" }, angle = 45 },
            inactive_border = "rgba(080b14aa)",
        },

        resize_on_border = true,
        allow_tearing    = false,
        layout           = "dwindle",
    },

    decoration = {
        rounding = 8,

        active_opacity   = 0.98,
        inactive_opacity = 0.86,

        blur = {
            enabled        = true,
            size           = 6,
            passes         = 2,
            vibrancy       = 0.16,
            ignore_opacity = false,
            xray           = true,
        },

        shadow = {
            enabled      = true,
            range        = 14,
            render_power = 3,
            color        = "rgba(00f0ff22)",
            color_inactive = "rgba(00000055)",
        },
    },

    animations = { enabled = true },

    dwindle = { preserve_split = true },

    misc = {
        force_default_wallpaper  = 0,
        disable_hyprland_logo    = true,
        disable_splash_rendering = true,
        vrr                      = 0,
        size_limits_tiled        = true,
    },
})

-- Snappy, fluid cyber animations
hl.curve("cyberEase", { type = "bezier", points = { { 0.16, 1.0 }, { 0.3, 1.0 } } })
hl.curve("cyberIn",   { type = "bezier", points = { { 0.1,  0.9 }, { 0.2, 1.0 } } })
hl.curve("cyberOut",  { type = "bezier", points = { { 0.25, 0.0 }, { 0.1, 1.0 } } })
hl.curve("liner",     { type = "bezier", points = { { 1.0,  1.0 }, { 1.0, 1.0 } } })

hl.animation({ leaf = "windows",      enabled = true, speed = 4, bezier = "cyberEase", style = "slide" })
hl.animation({ leaf = "windowsIn",    enabled = true, speed = 4, bezier = "cyberIn",   style = "slide" })
hl.animation({ leaf = "windowsOut",   enabled = true, speed = 3, bezier = "cyberOut",  style = "slide" })
hl.animation({ leaf = "windowsMove",  enabled = true, speed = 4, bezier = "cyberEase", style = "slide" })
hl.animation({ leaf = "border",       enabled = true, speed = 1, bezier = "liner" })
hl.animation({ leaf = "borderangle",  enabled = true, speed = 16, bezier = "liner",   style = "loop" })
hl.animation({ leaf = "fade",         enabled = true, speed = 6, bezier = "default" })
hl.animation({ leaf = "workspaces",   enabled = true, speed = 4, bezier = "cyberEase" })
