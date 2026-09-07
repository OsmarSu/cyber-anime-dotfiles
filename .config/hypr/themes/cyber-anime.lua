-- hyprland/themes/cyber-anime.lua
-- Aesthetic Cyber-Anime theme with Electric Cyan & Neon Magenta accents.

hl.config({
    general = {
        gaps_in  = 6,
        gaps_out = 12,

        border_size = 2,

        col = {
            active_border   = { colors = { "rgba(00f0ffff)", "rgba(ff007fff)" }, angle = 45 },
            inactive_border = "rgba(141726aa)",
        },

        resize_on_border = true,
        allow_tearing    = false,
        layout           = "dwindle",
    },

    decoration = {
        rounding = 14,

        active_opacity   = 0.91,
        inactive_opacity = 0.81,

        blur = {
            enabled        = true,
            size           = 6,
            passes         = 3,
            vibrancy       = 0.14,
            ignore_opacity = true,
            xray           = true,
            noise          = 0.01,
            contrast       = 1.0,
            brightness     = 1.0,
        },

        shadow = {
            enabled        = true,
            range          = 12,
            render_power   = 2,
            color          = "rgba(00f0ff14)",
            color_inactive = "rgba(00000044)",
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

-- Material 3 / End4 fluid bezier curves with cyber snappy speed
hl.curve("md3_standard", { type = "bezier", points = { { 0.2, 0.0 }, { 0.0, 1.0 } } })
hl.curve("md3_decel",    { type = "bezier", points = { { 0.05, 0.7 }, { 0.1, 1.0 } } })
hl.curve("md3_accel",    { type = "bezier", points = { { 0.3, 0.0 }, { 0.8, 0.15 } } })
hl.curve("overshot",     { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
hl.curve("liner",        { type = "bezier", points = { { 1.0, 1.0 }, { 1.0, 1.0 } } })

hl.animation({ leaf = "windows",          enabled = true, speed = 3.5, bezier = "md3_decel", style = "popin 80%" })
hl.animation({ leaf = "windowsIn",        enabled = true, speed = 3.5, bezier = "md3_decel", style = "popin 80%" })
hl.animation({ leaf = "windowsOut",       enabled = true, speed = 2.5, bezier = "md3_accel", style = "popin 80%" })
hl.animation({ leaf = "windowsMove",      enabled = true, speed = 3.5, bezier = "md3_decel" })
hl.animation({ leaf = "border",           enabled = true, speed = 2,   bezier = "liner" })
hl.animation({ leaf = "borderangle",      enabled = true, speed = 25,  bezier = "liner",     style = "loop" })
hl.animation({ leaf = "fade",             enabled = true, speed = 3,   bezier = "md3_decel" })
hl.animation({ leaf = "workspaces",       enabled = true, speed = 3.5, bezier = "md3_decel", style = "slide" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 3.5, bezier = "md3_decel", style = "slidevert" })
