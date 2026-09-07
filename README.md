# Cyber-Anime Dotfiles 󱗼

[![Arch Linux](https://img.shields.io/badge/Arch%20Linux-Hyprland%200.56+-00f0ff?logo=archlinux&logoColor=white)](https://archlinux.org)
[![Theme](https://img.shields.io/badge/Theme-Cyber%20Anime%20Neon-ff007f)](https://github.com)
[![Status](https://img.shields.io/badge/Status-Personal%20Daily%20Driver-00ff9f)](#)

Entorno de escritorio cyberpunk y anime de alto rendimiento para **Arch Linux** y **Hyprland** (configuración modular en **Lua**), diseñado para ser estético, rápido y completamente interactivo sin necesidad de widgets pesados en el escritorio.

---

## 󰀻 Características Principales

- **Estética Cyber-Anime (Tokyo Night Neon):**
  - Paleta de color basada en Cyan Eléctrico (`#00f0ff`), Magenta Neón (`#ff007f`), Negro Obsidiana (`#08090d`) y Verde Matrix (`#00ff9f`).
  - Curvas de aceleración ergonómicas estilo Material 3, desenfoque dual de ventanas y resplandor sutil sin fatiga visual.
- **Centro de Control y Configuración (`cyber-settings`):**
  - Panel flotante GTK3 Layer-Shell accesible con `Super + ,` o `Super + S`.
  - Pestaña de **Apariencia**: Opacidad, desenfoque y filtro de luz nocturna cálida en tiempo real.
  - Pestaña de **Hardware y Sistema**: Monitoreo de CPU, GPU (Nvidia GTX / AMD iGPU), Memoria RAM y Batería.
  - Pestaña de **Audio y Red**: Control de volumen por software y gestión de Wi-Fi.
  - Pestaña de **Atajos Dinámicos**: Visor de atajos del sistema con creador interactivo de nuevos atajos (con asignación en vivo en Hyprland y borrado instantáneo).
- **Cajón de Aplicaciones Amplio (`Super + A`):**
  - Ventana amplia de 980x620px con íconos prominentes de 3.2em (~48px) y tipografía nítida JetBrainsMono Nerd Font.
  - **Fondo dinámico Wallpaper Engine**: Cada vez que abres el cajón de apps, se selecciona un fondo aleatorio de Wallpaper Engine recortado a escala 1:1 sin pixelado.
- **Integración Nativa con Wallpaper Engine (`wpe-picker`):**
  - Selector interactivo en Rofi (`Super + W`) que escanea automáticamente tus fondos descargados de Steam Workshop (`431960`).
  - Reproducción de fondos de video mediante `mpvpaper`.
  - Soporte de fondos 3D y escenas interactivas con `linux-wallpaperengine`.
  - Menú de ajuste de efectos (partículas, efecto parallax, velocidad, shaders) en vivo.
- **Terminal Kitty & Fastfetch (Alya Kujou):**
  - Terminal GPU Kitty configurada con colores neón.
  - Saludo al abrir la terminal con imagen fija y cuadrada ($n \times n$) en alta definición de **Alya Kujou** (*Roshidere*) renderizada vía `kitty-icat`.
- **Barra Waybar Flotante:**
  - Diseño modular con píldoras de cristal translúcido, puente dinámico IPC con Hyprland, indicadores de audio, red, batería y menú de energía.
- **Centro de Notificaciones SwayNC (`Super + N`):**
  - Panel deslizante con controles rápidos, control multimedia y no molestar.
- **Bloqueo y Energía:**
  - `hyprlock` con reloj cyberpunk y desenfoque dinámico.
  - `wlogout` con botones translúcidos y efecto neón.

---

## ⌨ Atajos de Teclado Esenciales

| Combinación | Acción |
|---|---|
| `Super + A` | Cajón de aplicaciones (Rofi amplio + fondo dinámico) |
| `Super + Enter` / `Super + T` | Terminal Kitty |
| `Super + S` / `Super + ,` | Centro de Control y Ajustes (`cyber-settings`) |
| `Super + /` | Hoja interactiva de atajos de teclado (Rofi) |
| `Super + W` | Selector Wallpaper Engine (Steam Workshop) |
| `Super + Shift + W` | Selector de Fondos Estáticos |
| `Super + E` | Gestor de archivos gráfico (Dolphin) |
| `Super + Y` | Gestor de archivos de terminal (Yazi) |
| `Super + B` | Navegador Web (Brave / Firefox) |
| `Super + C` | Editor de Código (VS Code) |
| `Super + V` | Historial del Portapapeles (Cliphist + Rofi) |
| `Super + Q` | Cerrar ventana activa |
| `Super + F` | Alternar pantalla completa |
| `Super + Shift + F` | Alternar ventana flotante |
| `Super + Space` | Centrar ventana activa |
| `Super + N` | Centro de Control & Notificaciones (SwayNC) |
| `Super + Escape` | Menú de energía y apagado (Wlogout) |
| `Super + L` | Bloquear pantalla (Hyprlock) |
| `Super + Shift + S` | Captura de pantalla de área (Swappy) |
| `Print` | Captura de pantalla completa al portapapeles |
| `Ctrl + Escape` | Ocultar / Mostrar barra superior (Waybar) |

> 💡 *Puedes añadir más atajos personalizados en cualquier momento abriendo `cyber-settings` (`Super + ,`) en la pestaña "Atajos".*

---

## 📦 Componentes y Dependencias

| Rol | Paquete / Herramienta |
|---|---|
| Compositor | Hyprland 0.56+ (Configuración en Lua) |
| Bar | Waybar |
| Panel de Ajustes | `cyber-settings` (GTK3 + Layer Shell + Python) |
| Terminal | Kitty |
| Lanzador | Rofi (Wayland fork) |
| Notificaciones | SwayNC (sway-notification-center) |
| Fetch | Fastfetch |
| Lockscreen | Hyprlock |
| Live Wallpapers | mpvpaper + linux-wallpaperengine |
| Fondos estáticos | awww |
| Capturas | Grimblast + Slurp + Swappy |
| Portapapeles | Cliphist + wl-clipboard |
| Fuentes | JetBrainsMono Nerd Font |

---

## 🚀 Instalación Rápida

1. Clonar el repositorio en tu máquina:
   ```bash
   git clone <URL_DE_TU_REPOSITORIO> ~/.dotfiles-profiles/cyber-anime
   ```

2. Ejecutar el instalador automático:
   ```bash
   cd ~/.dotfiles-profiles/cyber-anime
   bash install.sh
   ```

3. El script se encargará de:
   - Verificar e instalar las dependencias necesarias mediante `yay`.
   - Crear los enlaces simbólicos en `~/.config/` y `~/.local/bin/`.
   - Inicializar el tema Cyber-Anime.

---

## 🛠 Estructura del Repositorio

```
cyber-anime/
├── .config/
│   ├── hypr/               Configuración Hyprland en Lua, shaders, hyprlock, scripts
│   ├── waybar/             Barra superior, módulos CSS, puente hyprland-waybar
│   ├── rofi/               Lanzador amplio, selector wallpaper, colores neón
│   ├── fastfetch/          Configuración de fetch con imagen fija de Alya Kujou
│   ├── swaync/             Centro de notificaciones
│   ├── kitty/              Temas y configuración de terminal
│   ├── wlogout/            Menú de sesión y apagado
│   ├── btop/               Monitor de sistema
│   └── swappy/             Editor de capturas
├── .local/
│   └── bin/                cyber-settings, wpe-picker, rofi-launcher, rofi-keybinds...
├── assets/                 Fondos e íconos
├── install.sh              Script de instalación automatizado
├── uninstall.sh            Script de desinstalación limpia
└── README.md
```
