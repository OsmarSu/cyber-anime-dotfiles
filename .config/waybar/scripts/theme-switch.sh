#!/bin/bash
# theme-switch.sh <cyber-anime|matrix|macchiato>
theme="${1:-cyber-anime}"

export WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-wayland-1}"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"

case "$theme" in
    cyber-anime)
        wall_dir="$HOME/.config/assets/backgrounds/cyber"
        ;;
    matrix)
        wall_dir="$HOME/.config/assets/backgrounds/blackhat"
        ;;
    *)
        wall_dir="$HOME/.config/assets/backgrounds/whitehat"
        ;;
esac

mkdir -p "$wall_dir"

# ── Symlinks e file ─────────────────────────────────────────────────────────
ln -sf "$HOME/.config/waybar/themes/${theme}.css"     "$HOME/.config/waybar/theme.css"
ln -sf "$HOME/.config/fastfetch/config-${theme}.jsonc" "$HOME/.config/fastfetch/config.jsonc"
ln -sf "$HOME/.config/rofi/colors-${theme}.rasi"      "$HOME/.config/rofi/colors.rasi"
ln -sf "$HOME/.config/kitty/themes/${theme}.conf"     "$HOME/.config/kitty/theme.conf"
ln -sf "$HOME/.config/swaync/themes/${theme}.css"     "$HOME/.config/swaync/theme.css"
rm -f "$HOME/.config/swaync/style.css"
cp "$HOME/.config/swaync/themes/${theme}.css"         "$HOME/.config/swaync/style.css"
ln -sf "$HOME/.config/hypr/themes/${theme}.lua"       "$HOME/.config/hypr/theme.lua"
ln -sf "$HOME/.config/hypr/themes/hyprlock-${theme}.conf" "$HOME/.config/hypr/hyprlock.conf"
printf '%s' "$wall_dir" > "$HOME/.config/rofi/.wall_dir"

# If a Wallpaper Engine background is configured, keep it or apply fallback
wall=$(find "$wall_dir" -maxdepth 1 -type f \
    \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" -o -iname "*.gif" \) 2>/dev/null \
    | shuf -n1)

if [[ -z "$wall" ]]; then
    # Fallback to current wallpaper or first preview in Steam workshop
    wall=$(find "$HOME/.local/share/Steam/steamapps/workshop/content/431960" -maxdepth 2 -name "*preview*" 2>/dev/null | head -n1)
fi

if [[ -n "$wall" ]]; then
    ln -sf "$wall" "$HOME/.config/rofi/.current_wallpaper"
    setsid awww img "$wall" \
        --transition-type grow --transition-pos center --transition-duration 0.8 \
        >/tmp/theme-switch.log 2>&1 &
fi

# ── Reload/restart processes ────────────────────────────────────────────────
hyprctl reload >/tmp/hypr-theme-switch.log 2>&1 || true
pkill -SIGUSR1 -x kitty 2>/dev/null || true
setsid "$HOME/.config/swaync/restart" >/tmp/swaync-theme-switch.log 2>&1 &

# Waybar reload (o iniciar si no estaba corriendo)
pgrep -x waybar >/dev/null && killall -SIGUSR2 waybar 2>/dev/null || setsid waybar >/dev/null 2>&1 &
