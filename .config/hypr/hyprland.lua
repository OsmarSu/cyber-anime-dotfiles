-- hyprland/hyprland.lua
-- Refer to the wiki: https://wiki.hypr.land/Configuring/Start/

--------------------
---- MONITORS ----
--------------------

hl.monitor({ output = "eDP-1", mode = "preferred", position = "auto",       scale = 1.25 })
hl.monitor({ output = "DP-1",  mode = "preferred", position = "auto-right", scale = 1    })
hl.monitor({ output = "",      mode = "preferred", position = "auto",       scale = "auto" })


----------------------
---- MY PROGRAMS ----
----------------------

local home        = os.getenv("HOME")
local terminal    = "kitty"
local fileManager = "yazi"
local menu        = home .. "/.local/bin/rofi-launcher -show drun -modi 'drun,window,clipboard:" .. home .. "/.local/bin/rofi-clipboard'"
local browser     = "sh -c 'command -v brave >/dev/null 2>&1 && exec brave || exec firefox'"
local notes       = "obsidian"
local editor      = "code"
local colorPicker = "hyprpicker"


--------------------------------
---- ENVIRONMENT VARIABLES ----
--------------------------------

hl.env("PATH", os.getenv("HOME") .. "/.local/bin:" .. (os.getenv("PATH") or ""))
hl.env("XCURSOR_SIZE",      "24")
hl.env("HYPRCURSOR_SIZE",   "24")

-- Firefox
hl.env("MOZ_ENABLE_WAYLAND", "1")

-- Nvidia (Comentado para compatibilidad híbrida AMD + NVIDIA)
-- hl.env("LIBVA_DRIVER_NAME",            "nvidia")
hl.env("XDG_SESSION_TYPE",             "wayland")
-- hl.env("GBM_BACKEND",                  "nvidia-drm")
-- hl.env("__GLX_VENDOR_LIBRARY_NAME",    "nvidia")
-- hl.env("NVD_BACKEND",                  "direct")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

-- Qt
hl.env("QT_QPA_PLATFORM",                    "wayland")
hl.env("QT_QPA_PLATFORMTHEME",               "qt5ct")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION","1")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR",        "1")
hl.env("QT_STYLE_OVERRIDE",                  "kvantum")

-- Toolkit backends
hl.env("GDK_BACKEND",    "wayland,x11,*")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")

-- XDG
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP",  "Hyprland")


-----------------
---- MODULES ----
-----------------

require("conf.autostart")
require("conf.appearance")
require("conf.input")
require("conf.keybinds")
require("conf.windowrules")

-- Overrides locales de hardware
pcall(dofile, '/home/oswi/.dotfiles-profiles/.hardware/persistent.lua')
