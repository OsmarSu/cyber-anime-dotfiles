-- hyprland/themes/pastel-end4.lua
-- Aesthetic Monochromatic Pastel theme inspired by end-4 dots (Material You / Lavender).
-- Monochromatic light-sweep active border with smooth pastel gradient.

hl.config({
    general = {
        gaps_in  = 6,
        gaps_out = 12,

        border_size = 2,

        col = {
            -- Monochromatic lavender gradient: highlight -> primary -> deep iris -> primary
            active_border   = { colors = { "rgba(e8def8ff)", "rgba(d0bcffff)", "rgba(8570ecee)", "rgba(d0bcffff)" }, angle = 45 },
            inactive_border = "rgba(292538aa)",
        },

        resize_on_border = true,
        allow_tearing    = false,
        layout           = "dwindle",
    },

    decoration = {
        rounding = 16, -- Soft rounded corners characteristic of Material 3 / end-4

        active_opacity   = 0.94,
        inactive_opacity = 0.82,

        blur = {
            enabled        = true,
            size           = 8,
            passes         = 3,
            vibrancy       = 0.18,
            ignore_opacity = true,
            xray           = true,
            noise          = 0.01,
            contrast       = 1.0,
            brightness     = 1.0,
        },

        shadow = {
            enabled        = true,
            range          = 16,
            render_power   = 2,
            color          = "rgba(182, 157, 248, 0.18)", -- Gentle pastel aura without harsh neon burn
            color_inactive = "rgba(00000035)",
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

-- Material 3 / End4 fluid bezier curves
hl.curve("md3_standard", { type = "bezier", points = { { 0.2, 0.0 }, { 0.0, 1.0 } } })
hl.curve("md3_decel",    { type = "bezier", points = { { 0.05, 0.7 }, { 0.1, 1.0 } } })
hl.curve("md3_accel",    { type = "bezier", points = { { 0.3, 0.0 }, { 0.8, 0.15 } } })
hl.curve("overshot",     { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
hl.curve("liner",        { type = "bezier", points = { { 1.0, 1.0 }, { 1.0, 1.0 } } })

hl.animation({ leaf = "windows",          enabled = true, speed = 4.0, bezier = "md3_decel", style = "popin 80%" })
hl.animation({ leaf = "windowsIn",        enabled = true, speed = 4.0, bezier = "md3_decel", style = "popin 80%" })
hl.animation({ leaf = "windowsOut",       enabled = true, speed = 2.8, bezier = "md3_accel", style = "popin 80%" })
hl.animation({ leaf = "windowsMove",      enabled = true, speed = 3.8, bezier = "md3_decel" })
hl.animation({ leaf = "border",           enabled = true, speed = 2,   bezier = "liner" })
hl.animation({ leaf = "borderangle",      enabled = true, speed = 24,  bezier = "liner",     style = "loop" })
hl.animation({ leaf = "fade",             enabled = true, speed = 3,   bezier = "md3_decel" })
hl.animation({ leaf = "workspaces",       enabled = true, speed = 4.0, bezier = "md3_decel", style = "slide" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 4.0, bezier = "md3_decel", style = "slidevert" })
