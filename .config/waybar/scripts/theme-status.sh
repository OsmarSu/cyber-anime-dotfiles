#!/bin/bash
# Reads the active theme symlink and outputs JSON for waybar custom module.
target=$(readlink "$HOME/.config/waybar/theme.css" 2>/dev/null)
case "${target##*/}" in
  matrix.css) printf '{"text":"🐉","tooltip":"Tema attivo: Matrix Hacker","class":"matrix"}\n' ;;
  *)          printf '{"text":"󰔎","tooltip":"Tema attivo: Catppuccin Macchiato","class":"macchiato"}\n' ;;
esac
