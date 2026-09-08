#!/bin/bash
# Reads the active theme symlink and outputs JSON for waybar custom module.
target=$(readlink "$HOME/.config/waybar/theme.css" 2>/dev/null)
case "${target##*/}" in
  cyber-anime.css)       printf '{"text":"󰄛","tooltip":"Tema: Cyber Anime (Tokyo Neon)","class":"cyber-anime"}\n' ;;
  silver-wolf.css)       printf '{"text":"🐺","tooltip":"Tema: Silver Wolf (Cyber Violet)","class":"silver-wolf"}\n' ;;
  blue-archive.css)      printf '{"text":"🕊️","tooltip":"Tema: Blue Archive (Kivotos Azure)","class":"blue-archive"}\n' ;;
  crimson-rose.css)      printf '{"text":"🌹","tooltip":"Tema: Camellya (Crimson Rose)","class":"crimson-rose"}\n' ;;
  furina-hydro.css)      printf '{"text":"💧","tooltip":"Tema: Furina (Fontaine Hydro)","class":"furina-hydro"}\n' ;;
  kurumi-tokisaki.css)   printf '{"text":"⏳","tooltip":"Tema: Kurumi (Crimson & Gold)","class":"kurumi-tokisaki"}\n' ;;
  firefly-starlight.css) printf '{"text":"✨","tooltip":"Tema: Firefly (Starlight Mint)","class":"firefly-starlight"}\n' ;;
  keqing-electro.css)    printf '{"text":"⚡","tooltip":"Tema: Keqing (Electro Violet)","class":"keqing-electro"}\n' ;;
  carlotta-ocean.css)    printf '{"text":"🌿","tooltip":"Tema: Carlotta (Sea Emerald)","class":"carlotta-ocean"}\n' ;;
  alya-sakura.css)       printf '{"text":"🌸","tooltip":"Tema: Alya (Pastel Sakura)","class":"alya-sakura"}\n' ;;
  matrix.css)            printf '{"text":"󰌨","tooltip":"Tema: Matrix Blackhat","class":"matrix"}\n' ;;
  macchiato.css)         printf '{"text":"☕","tooltip":"Tema: Catppuccin Macchiato","class":"macchiato"}\n' ;;
  *)                     printf '{"text":"󰄛","tooltip":"Tema: Cyber Anime","class":"cyber-anime"}\n' ;;
esac
