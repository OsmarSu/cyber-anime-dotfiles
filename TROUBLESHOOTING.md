# Troubleshooting

Common issues and fixes after installing this rice. These are problems encountered during real configuration - if you run into something not covered here, open an issue.

---

## yay not found / AUR packages fail

yay must be installed before running `install.sh`. Bootstrap it manually:

```bash
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si
```

If AUR packages fail mid-install with a GPG error:

```bash
gpg --recv-keys <key-id>
```

The missing key ID is printed in the error. Then re-run `install.sh` — it skips already-installed packages.

---

## Hyprland does not start / black screen after login

Hyprland is launched via `uwsm`. Make sure uwsm is configured correctly for your setup — see the [Arch wiki page on uwsm](https://wiki.archlinux.org/title/Hyprland#With_uwsm).

Common causes:

- **Missing polkit agent** - `polkit-kde-agent` must be installed and is autostarted in `.config/hypr/conf/autostart.lua`. Verify it is running: `pgrep polkit-kde-agent`.
- **XDG portal conflict** - only `xdg-desktop-portal-hyprland` should be active. Remove other portal packages if present: `yay -Rns xdg-desktop-portal-gtk xdg-desktop-portal-wlr`.
- **GPU driver missing** - install your driver before starting Hyprland (e.g. `mesa` for AMD/Intel, `nvidia-dkms` + `nvidia-utils` for Nvidia).

Check the Hyprland log for the exact error:

```bash
cat /tmp/hypr/$(ls -t /tmp/hypr | head -1)/hyprland.log | tail -50
```

---

## Waybar does not appear

If Waybar crashes on launch, run it manually to see the error:

```bash
waybar 2>&1 | head -30
```

Common causes:

- **JSON syntax error in config** - validate with: `jq . ~/.config/waybar/config.jsonc`
- **Missing module binary** - e.g. `grimblast`, `cliphist`, `wl-paste` not installed. Check `packages-core.txt`.
- **Wrong Hyprland IPC socket** - make sure `HYPRLAND_INSTANCE_SIGNATURE` is set in the environment. It is set automatically by uwsm.

---

## Rofi does not open

Check that `rofi` (Wayland fork) is installed and not the X11 version:

```bash
rofi -version
```

It should print `wayland` in the build flags. If not, remove the X11 package and install the correct one:

```bash
yay -Rns rofi
yay -S rofi-wayland
```

---

## Theme not applied / wrong colors after theme-switch

If `theme-switch.sh` runs but colors do not update:

1. **Waybar** - the script sends `SIGUSR2` to reload. If Waybar is not running, start it first.
2. **Kitty** - receives `SIGUSR1`. If Kitty windows do not update, close and reopen them.
3. **swaync** - the script restarts it via `~/.config/swaync/restart`. Check that file is executable: `ls -la ~/.config/swaync/restart`.
4. **Hyprland** - `hyprctl reload` is called. Check `/tmp/hypr-theme-switch.log` for errors.
5. **Wallpaper** - `awww` must be running. Verify: `pgrep awww`. It is autostarted in `autostart.lua`.

Run the switch manually to see output:

```bash
bash ~/.config/waybar/scripts/theme-switch.sh macchiato
```

---

## Fonts look wrong / icons are missing boxes

Missing Nerd Font or emoji font. Verify the fonts are installed:

```bash
fc-list | grep -i "JetBrains"
fc-list | grep -i "Noto.*Emoji"
```

If missing, install them:

```bash
yay -S ttf-jetbrains-mono-nerd noto-fonts-emoji
```

Then rebuild the font cache:

```bash
fc-cache -fv
```

Log out and back in - some apps (Waybar, Kitty) cache the font list at startup.

---

## Zsh / Powerlevel10k prompt looks broken

- **First login after install** - `p10k configure` runs automatically on the first Zsh launch. Complete the wizard to generate `~/.p10k.zsh`.
- **Prompt characters are boxes** - the JetBrainsMono Nerd Font is not active in your terminal. Set it in Kitty: `font_family JetBrainsMono Nerd Font`.
- **Oh My Zsh plugins missing** - `zsh-autosuggestions` and `zsh-syntax-highlighting` must be installed as system packages (they are in `packages-optional.txt`) and referenced in `.zshrc`. Check that the symlink is correct: `ls -la ~/.zshrc`.

---

## Neovim: Mason fails to install LSP servers

Mason needs the runtime dependencies from `packages-optional.txt` (`nodejs`, `npm`, `python-pip`) plus `gcc` and `make` from core. If you skipped Neovim during install and later want it:

```bash
yay -S neovim lazygit nodejs npm python-pip
bash ~/my-hyprland-dotfiles/install.sh   # re-run - it skips already-done steps
```

Inside Neovim, run `:Mason` to check server status and `:MasonInstall <server>` to install individually.

---

## Uninstaller leaves something behind

`uninstall.sh` only removes symlinks that point into the repo. If a config directory was backed up (e.g. `~/.config/hypr.bak`) during install, remove it manually:

```bash
rm -rf ~/.config/hypr.bak
```

The uninstaller does not touch `~/.p10k.zsh` or any file not created by the installer.

---

## Gestor Wi-Fi (`rofi-wifi`) no detecta redes o no conecta

- **Servicio NetworkManager inactivo**: Verifica que el demonio del sistema esté corriendo:
  ```bash
  systemctl status NetworkManager
  ```
  Si está detenido: `sudo systemctl enable --now NetworkManager`.
- **Radio inalámbrica apagada**: Asegúrate de que no esté bloqueada por hardware o software (`rfkill list`):
  ```bash
  nmcli radio wifi on
  ```
- **Re-escaneo manual**: Si una red recién creada no aparece en la lista, selecciona la opción `󰑐 Escanear redes` al final del menú o ejecuta `nmcli dev wifi rescan`.

---

## Fondos animados (`wpe-picker`) o transiciones estáticas (`awww`)

- **Demonio `awww` ausente**: `awww` es el gestor encargado del renderizado y las transiciones elásticas. Si el fondo no cambia:
  ```bash
  pgrep awww || awww-daemon &
  ```
- **Extracción de fotogramas**: `wpe-picker` genera automáticamente miniaturas en 1080p en `~/.cache/rofi-wpe-wallpapers/hq_frames/`. Si falta `ffmpeg`, instálalo con `sudo pacman -S ffmpeg`.
- **Cambio de tema sin alterar el fondo**: El script `theme-switch.sh` mantiene intacto tu fondo actual por defecto gracias al argumento `--keep-wallpaper`. Si deseas que aplique un fondo aleatorio del tema, pasa `--set-wallpaper`.

---

## Detección Automática de Temas y Armonización Cromática

- **Diagnosticar el tema detectado para una imagen**:
  Si deseas comprobar qué paleta asigna el algoritmo de cuantización a una imagen o fondo:
  ```bash
  theme_utils.py detect /ruta/al/fondo.jpg
  ```
- **Comprobar la paleta activa en tiempo real**:
  ```bash
  theme_utils.py current
  theme_utils.py palette
  ```
- **Ventana de Cyber Settings o popups desincronizados**:
  Si cambiaste de tema por consola y `cyber-settings` estaba abierto:
  ```bash
  pkill -SIGUSR1 -f cyber-settings
  ```
  Esto recarga los estilos CSS en caliente instantáneamente sin cerrar el panel.
- **Forzar regeneración de miniaturas de Wallpaper Engine**:
  Si un video se descargó recientemente y no tiene fotograma de alta definición:
  ```bash
  rm -rf ~/.cache/rofi-wpe-wallpapers/hq_frames/
  ```
  Al abrir `wpe-picker` (`Super + W`), se regenerarán automáticamente los fotogramas en 1080p nítidos.
