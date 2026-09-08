#!/bin/bash
# theme-switch.sh <THEME_NAME> [--set-wallpaper <PATH>]
# Supported themes:
#   cyber-anime | silver-wolf | blue-archive | crimson-rose | furina-hydro
#   kurumi-tokisaki | firefly-starlight | keqing-electro | carlotta-ocean | alya-sakura
#   matrix | macchiato

theme="${1:-cyber-anime}"
shift || true

# Parse flags
NEW_WALL=""
while [[ $# -gt 0 ]]; do
    case "$1" in
        --set-wallpaper)
            NEW_WALL="$2"
            shift 2
            ;;
        --keep-wallpaper)
            NEW_WALL=""
            shift 1
            ;;
        *)
            shift 1
            ;;
    esac
done

export WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-wayland-1}"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"

# Validate theme exists
if [[ ! -f "$HOME/.config/waybar/themes/${theme}.css" ]]; then
    theme="cyber-anime"
fi

# ── Symlinks e file de tema ──────────────────────────────────────────────────
ln -sf "$HOME/.config/waybar/themes/${theme}.css"         "$HOME/.config/waybar/theme.css"
ln -sf "$HOME/.config/fastfetch/config-${theme}.jsonc"     "$HOME/.config/fastfetch/config.jsonc"
ln -sf "$HOME/.config/rofi/colors-${theme}.rasi"          "$HOME/.config/rofi/colors.rasi"
ln -sf "$HOME/.config/kitty/themes/${theme}.conf"         "$HOME/.config/kitty/theme.conf"
ln -sf "$HOME/.config/swaync/themes/${theme}.css"         "$HOME/.config/swaync/theme.css"
rm -f "$HOME/.config/swaync/style.css"
cp "$HOME/.config/swaync/themes/${theme}.css"             "$HOME/.config/swaync/style.css"
ln -sf "$HOME/.config/hypr/themes/${theme}.lua"           "$HOME/.config/hypr/theme.lua"
ln -sf "$HOME/.config/hypr/themes/hyprlock-${theme}.conf" "$HOME/.config/hypr/hyprlock.conf"
ln -sf "$HOME/.config/wlogout/themes/${theme}.css"        "$HOME/.config/wlogout/theme.css" 2>/dev/null || true
echo "$theme" > "$HOME/.config/rofi/.current_theme"

# Only touch wallpaper if explicitly requested via --set-wallpaper
if [[ -n "$NEW_WALL" && -f "$NEW_WALL" ]]; then
    ln -sf "$NEW_WALL" "$HOME/.config/rofi/.current_wallpaper"
    ln -sf "$NEW_WALL" "$HOME/.config/rofi/.current_wallpaper.png"
    
    # End-4 dots fluid elastic grow transition
    setsid awww img "$NEW_WALL" \
        --resize crop --filter Lanczos3 \
        --transition-type grow --transition-pos center \
        --transition-step 90 --transition-fps 120 --transition-duration 1.0 \
        --transition-bezier .43,1.19,1,1.01 \
        >/tmp/theme-switch.log 2>&1 &
fi

# ── Reload/restart processes ────────────────────────────────────────────────
hyprctl reload >/tmp/hypr-theme-switch.log 2>&1 || true
pkill -SIGUSR1 -x kitty 2>/dev/null || true
pkill -SIGUSR1 -f cyber-settings 2>/dev/null || true
setsid "$HOME/.config/swaync/restart" >/tmp/swaync-theme-switch.log 2>&1 &

# Waybar reload
pgrep -x waybar >/dev/null && killall -SIGUSR2 waybar 2>/dev/null || setsid "$HOME/.local/bin/waybar" >/dev/null 2>&1 &
