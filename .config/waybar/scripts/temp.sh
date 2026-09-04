#!/usr/bin/env bash
# Reads CPU temperature from sensors with fallback on thermal_zone0.
# Outputs JSON for waybar custom module.

set -euo pipefail

TEMP=""
if command -v sensors &>/dev/null; then
  TEMP=$(sensors -j 2>/dev/null | jq -r '
    [
      .[] | to_entries[] | .value | objects |
      to_entries[] | select(.key | test("temp[0-9]+_input"; "i")) | .value
    ] | first // empty
  ')
fi

if [ -z "$TEMP" ] && [ -r /sys/class/thermal/thermal_zone0/temp ]; then
  RAW=$(cat /sys/class/thermal/thermal_zone0/temp)
  TEMP=$(awk "BEGIN { printf \"%.0f\", $RAW/1000 }")
fi

if [ -z "$TEMP" ]; then
  jq -nc '{text:"--°", tooltip:"no sensor", class:"unknown"}'
  exit 0
fi

TEMP_INT=$(printf "%.0f" "$TEMP")
CLASS="cool"
if   [ "$TEMP_INT" -ge 80 ]; then CLASS="critical"
elif [ "$TEMP_INT" -ge 70 ]; then CLASS="hot"
elif [ "$TEMP_INT" -ge 50 ]; then CLASS="warm"
fi

jq -nc --arg t "${TEMP_INT}°" --arg tip "CPU: ${TEMP_INT}°C" --arg cls "$CLASS" \
  '{text:$t, tooltip:$tip, class:$cls}'
