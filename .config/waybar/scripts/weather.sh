#!/usr/bin/env bash
# Fetch current weather from wttr.in, cache 30min in /tmp/waybar-weather.json.
# Outputs JSON for waybar custom module.

set -euo pipefail

CITY="${WAYBAR_WEATHER_CITY:-London}"
CACHE=/tmp/waybar-weather.json
TTL=1800

if [ -f "$CACHE" ]; then
  AGE=$(( $(date +%s) - $(stat -c %Y "$CACHE") ))
  if [ "$AGE" -lt "$TTL" ]; then
    cat "$CACHE"
    exit 0
  fi
fi

RESP=$(curl -fsSL --max-time 5 "https://wttr.in/${CITY}?format=j1" 2>/dev/null || echo "")
if [ -z "$RESP" ]; then
  jq -nc '{text:"", tooltip:"weather offline"}'
  exit 0
fi

TEMP=$(echo "$RESP" | jq -r '.current_condition[0].temp_C')
ICON_CODE=$(echo "$RESP" | jq -r '.current_condition[0].weatherCode')

case "$ICON_CODE" in
  113)                                              ICON="☀";;
  116|119|122)                                      ICON="⛅";;
  143|248|260)                                      ICON="🌫";;
  176|263|266|293|296|299|302|305|308|353|356|359)  ICON="🌧";;
  179|185|227|230|320|323|326|329|332|335|338|350|362|365|368|371|374|377|392|395) ICON="❄";;
  200|386|389)                                      ICON="⛈";;
  *)                                                ICON="☁";;
esac

TOOLTIP=$(echo "$RESP" | jq -r --arg city "$CITY" '
  ($city | ascii_upcase) as $c |
  "<b>" + $c + "</b>\n" +
  (.current_condition[0] | "Ora: \(.temp_C)° \(.weatherDesc[0].value)\nFeel: \(.FeelsLikeC)° · Umid: \(.humidity)%") + "\n\n" +
  (.weather[0:3] | map("• \(.date): \(.maxtempC)°/\(.mintempC)° \(.hourly[4].weatherDesc[0].value)") | join("\n"))
')

jq -nc --arg t "${ICON} ${TEMP}°" --arg tip "$TOOLTIP" '{text:$t, tooltip:$tip}' > "$CACHE"
cat "$CACHE"
