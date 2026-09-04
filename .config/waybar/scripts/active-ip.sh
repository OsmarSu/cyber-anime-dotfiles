#!/bin/bash
# Mostra VPN IP se attiva, altrimenti LAN IP dell'interfaccia di default.
# Interfacce VPN riconosciute: tun*, wg*, proton*
vpn_iface=$(ip -o link show 2>/dev/null \
  | awk -F': ' '/: (tun|wg|proton)/{print $2}' | head -1)
vpn_ip=""
if [ -n "$vpn_iface" ]; then
  vpn_ip=$(ip -o -4 addr show "$vpn_iface" 2>/dev/null \
    | awk '{print $4}' | cut -d/ -f1 | head -1)
fi

if [ -n "$vpn_ip" ]; then
  echo "󰒃 $vpn_ip"
  exit 0
fi

iface=$(ip route show default 2>/dev/null | awk '/default/ {print $5}' | head -1)
if [ -n "$iface" ]; then
  lan_ip=$(ip addr show "$iface" 2>/dev/null \
    | grep "inet " | awk '{print $2}' | cut -d/ -f1 | head -1)
  [ -n "$lan_ip" ] && echo "󰀂 $lan_ip"
fi
