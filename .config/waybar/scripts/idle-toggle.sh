#!/usr/bin/env bash
# Toggle hypridle on/off and notify the user.

set -euo pipefail

if pgrep -x hypridle &>/dev/null; then
  pkill hypridle
  notify-send -i system-suspend "Idle inhibitor" "ATTIVO — schermo non si blocca"
else
  hypridle &
  disown
  notify-send -i system-shutdown "Idle inhibitor" "DISATTIVO — lock/sleep normali"
fi

# Aggiorna icona waybar
pkill -SIGRTMIN+8 waybar 2>/dev/null || true
