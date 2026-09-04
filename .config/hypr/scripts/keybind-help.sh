#!/bin/bash
# keybind-help.sh — floating cheat sheet (SUPER+I)
# Cyber-Anime Rice Cheatsheet

R=$'\e[0m'; B=$'\e[1m'
CYAN=$'\e[38;2;0;240;255m'
MAGENTA=$'\e[38;2;255;0;127m'
TEXT=$'\e[38;2;226;241;248m'
SUB=$'\e[38;2;143;168;184m'
SURF=$'\e[38;2;31;38;56m'

TOP=$(printf '═%.0s' {1..74})
DIV=$(printf '─%.0s' {1..76})

sec() { printf "\n  ${B}${MAGENTA}◈  %s${R}\n  ${SURF}${DIV}${R}\n" "$1"; }
row() { printf "  ${CYAN}%-26s${R}  ${TEXT}%s${R}\n" "$1" "$2"; }

main() {
printf "\n"
printf "  ${B}${CYAN}╔${TOP}╗${R}\n"
printf "  ${B}${CYAN}║${R}  ${B}${TEXT}CYBER://ANIME CHEATSHEET${R}%38s${SUB}%s${R}  ${B}${CYAN}║${R}\n" "" "$(hostname)"
printf "  ${B}${CYAN}╚${TOP}╝${R}\n"

sec "LANZADORES Y APPS"
row "SUPER + A"                "Caja de aplicaciones (Rofi)"
row "SUPER + E"                "Gestor de archivos GUI (Dolphin)"
row "SUPER + S"                "Gestor de archivos terminal (Yazi)"
row "SUPER + Enter / T"        "Terminal (Kitty)"
row "SUPER + B"                "Navegador web (Firefox)"
row "SUPER + C"                "Editor de codigo (VS Code)"
row "SUPER + V"                "Historial de portapapeles (Cliphist)"
row "SUPER + W"                "Selector Wallpaper Engine"
row "SUPER + Shift + W"        "Selector fondos estaticos"
row "SUPER + P"                "Selector de color (Eyedropper)"
row "SUPER + ."                "Selector de Emojis"

sec "VENTANAS DE TRABAJO (WORKSPACES)"
row "SUPER + 1..0"             "Ir a ventana de trabajo 1..10"
row "SUPER + Tab"              "Alternar rapido entre ventanas de trabajo"
row "SUPER + Shift + 1..0"     "Mover ventana activa a espacio 1..10"
row "SUPER + Ctrl + 1..0"      "Mover ventana silenciosamente"
row "SUPER + Rueda Raton"      "Ciclar ventanas de trabajo"

sec "GESTION DE VENTANAS"
row "SUPER + Q"                "Cerrar ventana activa"
row "SUPER + F"                "Pantalla completa (Fullscreen)"
row "SUPER + Shift + F"        "Alternar ventana flotante"
row "SUPER + Space"            "Centrar ventana flotante"
row "SUPER + J"                "Alternar orientacion split"
row "SUPER + D"                "Buscar ventana abierta (Rofi)"
row "ALT + Tab"                "Ciclar entre ventanas abiertas"
row "SUPER + Flechas / Vim"    "Cambiar foco entre ventanas"

sec "SISTEMA Y UTILIDADES"
row "SUPER + Shift + S"        "Captura de area con editor (Swappy)"
row "Print"                    "Captura de pantalla completa"
row "SUPER + N"                "Centro de control y notificaciones (SwayNC)"
row "SUPER + L"                "Bloquear pantalla (Hyprlock)"
row "SUPER + Escape"           "Menu de apagado / sesion (Wlogout)"
row "Ctrl + Escape"            "Ocultar / Mostrar Waybar"
row "SUPER + I"                "Abrir esta ayuda"

printf "\n  ${SUB}Presiona 'q' o cierra esta ventana para salir.${R}\n\n"
}

main
read -n 1 -s -r -p ""
