-- hyprland/conf/windowrules.lua
--
-- Sintassi: hl.window_rule({ name = "id", match = { ... }, opzione = valore })
--
-- match — criteri (tutti devono essere soddisfatti):
--   class      = "regex"    classe della finestra  (hyprctl clients → "class")
--   title      = "regex"    titolo della finestra  (hyprctl clients → "title")
--   xwayland   = true/false finestra XWayland
--   float      = true/false finestra floating
--   fullscreen = true/false finestra fullscreen
--   modal      = true/false dialogo modale
--   pin        = true/false finestra pinnata
--
-- Azioni disponibili:
--   float      = true            forza floating
--   tile       = true            forza tiled
--   fullscreen = true            forza fullscreen
--   center     = true            centra la finestra
--   size       = { w, h }        dimensione in px
--   move       = "x y"           posizione (px o %, "monitor_h-120" per bordi)
--   pin        = true            pinna la finestra (visibile su tutti i workspace)
--   no_focus   = true            non riceve focus automatico
--   no_max_size = true           ignora la dimensione massima dichiarata dall'app
--   min_size   = { w, h }        dimensione minima
--   opacity    = 0.9             opacità (o { active=1.0, inactive=0.8 })
--   workspace  = "n"             apre su workspace specifico
--   monitor    = "DP-1"          apre su monitor specifico
--   suppress_event = "maximize"  blocca eventi specifici dall'app

-- Suppress maximize requests from all windows
hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

-- Fix XWayland drag issues (blank floating xwayland windows)
hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

-- hyprland-run: position at bottom-left
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },
    move  = "20 monitor_h-120",
    float = true,
})

-- Burp Suite: main window (no max size, minimum usable size)
hl.window_rule({
    name        = "burpsuite-main",
    match       = { class = "^(burp-StartBurp)$" },
    no_max_size = true,
    min_size    = { 600, 400 },
})

-- Burp Suite: modal dialogs
hl.window_rule({
    name   = "burpsuite-dialogs-modal",
    match  = { class = "^(burp-StartBurp)$", modal = true },
    float  = true,
    center = true,
    size   = { 1100, 760 },
})

-- Burp Suite: named dialogs (Settings, Preferences, Options…)
hl.window_rule({
    name   = "burpsuite-dialogs-title",
    match  = {
        class = "^(burp-StartBurp)$",
        title = "^(.*Settings.*|.*Preferences.*|.*Options.*|.*Dialog.*)$",
    },
    float  = true,
    center = true,
    size   = { 1100, 760 },
})

-- Spotify: floating, comfortable size
hl.window_rule({
    name   = "spotify-float",
    match  = { class = "^(Spotify)$" },
    float  = true,
    size   = { 1100, 720 },
    center = true,
})

-- NetworkManager connection editor
hl.window_rule({
    name   = "nm-connection-editor-popup",
    match  = { class = "^(nm-connection-editor|Nm-connection-editor)$" },
    float  = true,
    center = true,
    size   = { 980, 680 },
    min_size = { 740, 480 },
})

-- Estándar general de tamaño mínimo para ventanas flotantes
hl.window_rule({
    name     = "floating-standard-min-size",
    match    = { float = true },
    min_size = { 560, 380 },
})

-- Generic floating terminal tools and popups
hl.window_rule({
    name        = "floating-terminal-tools",
    match       = { class = "^(floating-tool|nmtui|bluetoothctl|btop-float)$" },
    float       = true,
    center      = true,
    size        = { 1000, 680 },
    min_size    = { 760, 480 },
    no_max_size = true,
})

-- Pavucontrol audio mixer popup
hl.window_rule({
    name     = "pavucontrol-float",
    match    = { class = "^(pavucontrol|org.pulseaudio.pavucontrol)$" },
    float    = true,
    center   = true,
    size     = { 960, 640 },
    min_size = { 760, 480 },
})

-- Swappy screenshot annotation tool
hl.window_rule({
    name   = "swappy-float",
    match  = { class = "^(swappy)$" },
    float  = true,
    center = true,
})

-- Keybind cheat sheet: floating, pinned, centered
hl.window_rule({
    name     = "keybind-help",
    match    = { class = "^(keybind-help)$" },
    float    = true,
    center   = true,
    size     = { 960, 840 },
    min_size = { 780, 560 },
    pin      = true,
})

-- Polkit authentication agent dialogs
hl.window_rule({
    name   = "polkit-auth-dialogs",
    match  = { class = "^(org.kde.polkit-kde-authentication-agent-1|polkit-gnome-authentication-agent-1|polkit-kde-authentication-agent-1)$" },
    float  = true,
    center = true,
})

-- Portal file pickers and dialogs
hl.window_rule({
    name     = "portal-dialogs",
    match    = { class = "^(xdg-desktop-portal-gtk|xdg-desktop-portal-hyprland|xdg-desktop-portal-kde)$" },
    float    = true,
    center   = true,
    size     = { 1000, 680 },
    min_size = { 760, 500 },
})

-- Steam auxiliary dialogs
hl.window_rule({
    name   = "steam-dialogs",
    match  = {
        class = "^(steam)$",
        title = "^(Friends List|Special Offers|Steam - News|Steam Guard|Settings)$",
    },
    float  = true,
})

-- Media viewers (imv, mpv floating by default)
hl.window_rule({
    name     = "media-viewers",
    match    = { class = "^(imv|mpv)$" },
    float    = true,
    center   = true,
    min_size = { 640, 400 },
})

-- Cyber settings and control panels
hl.window_rule({
    name        = "cyber-settings-float",
    match       = { class = "^(cyber-settings|CyberSettings)$" },
    float       = true,
    center      = true,
    size        = { 1180, 780 },
    min_size    = { 960, 620 },
    no_max_size = true,
    pin         = false,
})

