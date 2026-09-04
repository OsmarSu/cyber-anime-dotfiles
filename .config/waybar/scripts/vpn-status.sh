#!/usr/bin/env bash
# Detect active VPN (wireguard or openvpn).
# Empty output hides the waybar module automatically.

set -euo pipefail

if command -v wg &>/dev/null; then
  WG_IFACES=$(wg show interfaces 2>/dev/null || true)
  if [ -n "$WG_IFACES" ]; then
    FIRST=$(echo "$WG_IFACES" | head -n1 | awk '{print $1}')
    echo "🛡 ${FIRST}"
    exit 0
  fi
fi

if pgrep -x openvpn &>/dev/null; then
  echo "🛡 ovpn"
  exit 0
fi

if command -v nmcli &>/dev/null; then
  NM_VPN=$(nmcli -t -f NAME,TYPE connection show --active 2>/dev/null | awk -F: '$2 ~ /vpn|wireguard/ {print $1; exit}')
  if [ -n "$NM_VPN" ]; then
    echo "🛡 ${NM_VPN}"
    exit 0
  fi
fi

exit 0
