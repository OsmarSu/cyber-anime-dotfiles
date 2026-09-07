-- hyprland/conf/keybinds.lua
-- Cyber-Anime custom keybindings configuration.

local home    = os.getenv("HOME")
local mainMod = "SUPER"

local terminal    = "kitty"
local fileManager = "dolphin"
local termFileManager = "kitty -e yazi"
local browser     = "sh -c 'command -v brave >/dev/null 2>&1 && exec brave || exec firefox'"
local editor      = "code"
local colorPicker = "hyprpicker"
local menu        = home .. "/.local/bin/rofi-launcher -show drun -modi 'drun,window,clipboard:" .. home .. "/.local/bin/rofi-clipboard'"

-- ── 1. Lanzadores principales ────────────────────────────────────────────────
-- Caja de aplicaciones (App Launcher)
hl.bind(mainMod .. " + A",           hl.dsp.exec_cmd(menu))

-- Gestor de archivos GUI (Dolphin)
hl.bind(mainMod .. " + E",           hl.dsp.exec_cmd(fileManager))

-- Gestor de archivos de terminal (Yazi)
hl.bind(mainMod .. " + Y",           hl.dsp.exec_cmd(termFileManager))

-- Panel de Control y Configuración (Cyber Settings)
hl.bind(mainMod .. " + S",           hl.dsp.exec_cmd(home .. "/.local/bin/cyber-settings"))
hl.bind(mainMod .. " + comma",       hl.dsp.exec_cmd(home .. "/.local/bin/cyber-settings"))

-- Hoja de atajos de teclado interactiva (<)
hl.bind(mainMod .. " + slash",       hl.dsp.exec_cmd(home .. "/.local/bin/rofi-keybinds"))

-- Terminal (Kitty) - Soporta tanto Super+Enter como Super+T
hl.bind(mainMod .. " + Return",      hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + T",           hl.dsp.exec_cmd(terminal))

-- Navegador web (Firefox)
hl.bind(mainMod .. " + B",           hl.dsp.exec_cmd(browser))

-- Editor de código (VS Code)
hl.bind(mainMod .. " + C",           hl.dsp.exec_cmd(editor))

-- Historial del Portapapeles (Cliphist + Rofi)
hl.bind(mainMod .. " + V",           hl.dsp.exec_cmd(home .. "/.local/bin/rofi-clipboard"))

-- Wallpaper Engine & Fondos
hl.bind(mainMod .. " + W",           hl.dsp.exec_cmd(home .. "/.local/bin/wpe-picker"))
hl.bind(mainMod .. " + SHIFT + W",   hl.dsp.exec_cmd(home .. "/.local/bin/rofi-wallpaper"))

-- Selector de color (Eyedropper)
hl.bind(mainMod .. " + P",           hl.dsp.exec_cmd("sh -c '" .. colorPicker .. " | wl-copy'"))

-- Selector de Emojis
hl.bind(mainMod .. " + period",      hl.dsp.exec_cmd(home .. "/.local/bin/rofi-launcher -show emoji"))

-- ── 2. Gestión de ventanas ───────────────────────────────────────────────────
-- Cerrar ventana activa
hl.bind(mainMod .. " + Q",           hl.dsp.window.close())

-- Alternar pantalla completa
hl.bind(mainMod .. " + F",           hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind(mainMod .. " + ALT + F",     hl.dsp.window.fullscreen({ mode = "maximized",  action = "toggle" }))

-- Alternar ventana flotante
hl.bind(mainMod .. " + SHIFT + F",   hl.dsp.window.float({ action = "toggle" }))

-- Centrar ventana flotante
hl.bind(mainMod .. " + SPACE",       hl.dsp.window.center())

-- Alternar división de split (Dwindle layout)
hl.bind(mainMod .. " + J",           hl.dsp.layout("togglesplit"))

-- Dimensiones flotantes preestablecidas
hl.bind(mainMod .. " + M", function()
    hl.dispatch(hl.dsp.window.resize({ x = 1100, y = 720, relative = false }))
    hl.dispatch(hl.dsp.window.center())
end)
hl.bind(mainMod .. " + SHIFT + M", function()
    hl.dispatch(hl.dsp.window.resize({ x = 1500, y = 820, relative = false }))
    hl.dispatch(hl.dsp.window.center())
end)

-- Alt-Tab: ciclar ventanas abiertas
hl.bind("ALT + Tab",                 hl.dsp.window.cycle_next())
hl.bind("ALT + SHIFT + Tab",         hl.dsp.window.cycle_next({ next = false }))

-- Selector de ventanas abiertas con Rofi
hl.bind(mainMod .. " + D",           hl.dsp.exec_cmd("rofi -show window -theme " .. home .. "/.config/rofi/launcher.rasi"))

-- Navegación de foco con flechas
hl.bind(mainMod .. " + left",        hl.dsp.focus({ direction = "left"  }))
hl.bind(mainMod .. " + right",       hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",          hl.dsp.focus({ direction = "up"    }))
hl.bind(mainMod .. " + down",        hl.dsp.focus({ direction = "down"  }))

-- Mover ventanas en el layout
hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.move({ direction = "left"  }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.window.move({ direction = "up"    }))
hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.window.move({ direction = "down"  }))
hl.bind(mainMod .. " + SHIFT + H",     hl.dsp.window.move({ direction = "left"  }))
hl.bind(mainMod .. " + SHIFT + L",     hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + K",     hl.dsp.window.move({ direction = "up"    }))
hl.bind(mainMod .. " + SHIFT + J",     hl.dsp.window.move({ direction = "down"  }))

-- Redimensionar ventanas con CTRL + flechas / vim
hl.bind(mainMod .. " + CTRL + right", hl.dsp.window.resize({ x =  30, y =   0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + left",  hl.dsp.window.resize({ x = -30, y =   0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + up",    hl.dsp.window.resize({ x =   0, y = -30, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + down",  hl.dsp.window.resize({ x =   0, y =  30, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + L",     hl.dsp.window.resize({ x =  30, y =   0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + H",     hl.dsp.window.resize({ x = -30, y =   0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + K",     hl.dsp.window.resize({ x =   0, y = -30, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + J",     hl.dsp.window.resize({ x =   0, y =  30, relative = true }), { repeating = true })

-- Arrastre y redimensionamiento con ratón
hl.bind(mainMod .. " + mouse:272",   hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273",   hl.dsp.window.resize(), { mouse = true })

-- ── 3. Ventanas / Espacios de trabajo (Workspaces) ───────────────────────────
-- Alternar rápido entre las dos últimas ventanas de trabajo (Super + Tab)
hl.bind(mainMod .. " + Tab",         hl.dsp.focus({ workspace = "previous" }))
hl.bind(mainMod .. " + SHIFT + Tab", hl.dsp.focus({ workspace = "e+1" }))

-- Cambiar a ventana de trabajo (Super + 1..0)
-- Mover ventana a ventana de trabajo (Super + Shift + 1..0)
-- Mover ventana silenciosamente sin cambiar de espacio (Super + Ctrl + 1..0)
for i = 1, 10 do
    local key = i % 10  -- 10 → key 0
    hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
    hl.bind(mainMod .. " + CTRL + " .. key,      hl.dsp.window.move({ workspace = i, follow = false }))
end

-- Desplazamiento por espacios de trabajo con rueda del ratón
hl.bind(mainMod .. " + mouse_down",  hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",    hl.dsp.focus({ workspace = "e-1" }))

-- ── 4. Sistema, Notificaciones y Capturas ────────────────────────────────────
-- Bloquear pantalla (Hyprlock)
hl.bind(mainMod .. " + L",           hl.dsp.exec_cmd(home .. "/.local/bin/hypr-lock"))

-- Menú de energía / cerrar sesión (Wlogout)
hl.bind(mainMod .. " + Escape",      hl.dsp.exec_cmd(home .. "/.local/bin/hypr-power-menu"))

-- Alternar centro de control de notificaciones (SwayNC)
hl.bind(mainMod .. " + N",           hl.dsp.exec_cmd("swaync-client -t"))

-- Alternar visibilidad de Waybar
hl.bind("CTRL + ESCAPE",             hl.dsp.exec_cmd("sh -c 'killall waybar || ~/.local/bin/waybar'"))

-- Capturas de pantalla
-- Super + Shift + S: Selección de área (Swappy si está instalado, o grimblast directo)
hl.bind(mainMod .. " + SHIFT + S",   hl.dsp.exec_cmd("sh -c 'if command -v swappy >/dev/null 2>&1; then grim -g \"$(slurp)\" - | swappy -f -; else grimblast --notify copysave area; fi'"))
-- Print: Pantalla completa al portapapeles
hl.bind("Print",                     hl.dsp.exec_cmd("grimblast --notify copysave screen"))
hl.bind(mainMod .. " + Print",       hl.dsp.exec_cmd("grimblast --notify copysave active"))

-- Controles de volumen
hl.bind("XF86AudioRaiseVolume",      hl.dsp.exec_cmd(home .. "/.config/hypr/scripts/osd-volume up"),   { locked = true })
hl.bind("XF86AudioLowerVolume",      hl.dsp.exec_cmd(home .. "/.config/hypr/scripts/osd-volume down"), { locked = true })
hl.bind("XF86AudioMicMute",          hl.dsp.exec_cmd(home .. "/.config/hypr/scripts/osd-volume mic"),  { locked = true })
hl.bind("XF86AudioMute",             hl.dsp.exec_cmd(home .. "/.config/hypr/scripts/osd-volume mute"), { locked = true })

-- Controles multimedia (Playerctl)
hl.bind("XF86AudioPlay",             hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause",            hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext",             hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPrev",             hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

-- Controles de brillo
hl.bind("XF86MonBrightnessUp",       hl.dsp.exec_cmd(home .. "/.config/hypr/scripts/osd-brightness up"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",     hl.dsp.exec_cmd(home .. "/.config/hypr/scripts/osd-brightness down"), { locked = true, repeating = true })

-- Hoja de trucos de atajos
hl.bind(mainMod .. " + I",           hl.dsp.exec_cmd(
    "kitty --class keybind-help --override font_size=10 -e " ..
    home .. "/.config/hypr/scripts/keybind-help.sh"
))
