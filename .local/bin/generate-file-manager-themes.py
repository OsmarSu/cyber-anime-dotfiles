#!/usr/bin/env python3
"""
generate_themes.py — Generate synchronized Cyber-Anime themes for Yazi and Thunar (GTK-3.0)
Generates high-definition, glowing neon RGB palettes matching all 12 system themes.
"""

import os
import re
import glob

PROFILE_DIR = "/home/oswi/.dotfiles-profiles/cyber-anime"
WAYBAR_THEMES = os.path.join(PROFILE_DIR, ".config/waybar/themes")
YAZI_THEMES_DIR = os.path.join(PROFILE_DIR, ".config/yazi/themes")
GTK_THEMES_DIR = os.path.join(PROFILE_DIR, ".config/gtk-3.0/themes")

os.makedirs(YAZI_THEMES_DIR, exist_ok=True)
os.makedirs(GTK_THEMES_DIR, exist_ok=True)

def hex_to_rgb(hex_str):
    hex_str = hex_str.lstrip('#')
    if len(hex_str) == 3:
        hex_str = ''.join([c*2 for c in hex_str])
    if len(hex_str) >= 6:
        return tuple(int(hex_str[i:i+2], 16) for i in (0, 2, 4))
    return (0, 0, 0)

def parse_waybar_theme(filepath):
    colors = {}
    with open(filepath, 'r') as f:
        content = f.read()
    
    # First pass: direct definitions
    for m in re.finditer(r'@define-color\s+([a-zA-Z0-9_-]+)\s+([^;]+);', content):
        val = m.group(2).strip()
        colors[m.group(1)] = val
    
    # Second pass: resolve references like @lavender
    for _ in range(3):
        for k, v in colors.items():
            if v.startswith('@'):
                ref = v[1:].strip()
                if ref in colors and not colors[ref].startswith('@'):
                    colors[k] = colors[ref]
    return colors

def get_theme_palette(theme_name, raw_colors):
    def c(key, default):
        val = raw_colors.get(key, default)
        if isinstance(val, str) and val.startswith('#'):
            return val
        return default

    # Specific overrides or parsed values
    base = c('base', '#08090d')
    surface0 = c('surface0', '#0e111a')
    surface1 = c('surface1', '#161b28')
    surface2 = c('surface2', '#1f2638')
    text = c('text', '#e2f1f8')
    subtext0 = c('subtext0', '#8fa8b8')
    accent = c('accent-active', c('accent', '#00f0ff'))
    alt = c('accent-hover', c('pink', '#ff007f'))
    red = c('red', '#ff0055')
    green = c('green', '#00ff9f')
    yellow = c('yellow', '#ffd166')
    blue = c('blue', '#38bdf8')
    mauve = c('mauve', '#a855f7')
    peach = c('peach', '#ff9e64')

    # Ensure clean hex
    for var, name in [('base', base), ('accent', accent), ('alt', alt)]:
        if not name.startswith('#'):
            if theme_name == 'macchiato':
                base, accent, alt = '#24273a', '#b7bdf8', '#f5bde6'
            elif theme_name == 'matrix':
                base, accent, alt = '#080000', '#ff4455', '#ff6677'
            else:
                base, accent, alt = '#060e1a', '#38bdf8', '#ffd166'

    # Compute subtle border color (blend base + accent)
    br, bg, bb = hex_to_rgb(base)
    ar, ag, ab = hex_to_rgb(accent)
    border_rgb = (int(br * 0.65 + ar * 0.35), int(bg * 0.65 + ag * 0.35), int(bb * 0.65 + ab * 0.35))
    border_hex = f"#{border_rgb[0]:02x}{border_rgb[1]:02x}{border_rgb[2]:02x}"

    return {
        'base': base,
        'surface0': surface0,
        'surface1': surface1,
        'surface2': surface2,
        'text': text,
        'subtext0': subtext0,
        'accent': accent,
        'alt': alt,
        'red': red,
        'green': green,
        'yellow': yellow,
        'blue': blue,
        'mauve': mauve,
        'peach': peach,
        'border_hex': border_hex,
        'base_rgb': hex_to_rgb(base),
        'accent_rgb': hex_to_rgb(accent),
        'alt_rgb': hex_to_rgb(alt),
        'surface_rgb': hex_to_rgb(surface0),
    }

def generate_yazi_theme(theme_name, pal):
    base = pal['base']
    surface0 = pal['surface0']
    surface1 = pal['surface1']
    text = pal['text']
    subtext0 = pal['subtext0']
    accent = pal['accent']
    alt = pal['alt']
    red = pal['red']
    green = pal['green']
    yellow = pal['yellow']
    blue = pal['blue']
    mauve = pal['mauve']
    peach = pal['peach']
    border = pal['border_hex']

    return f'''# Theme: {theme_name} (Cyber-Anime RGB)

[mgr]
cwd = {{ fg = "{accent}", bold = true }}

# Hovered item
hovered = {{ bg = "{surface1}", fg = "{accent}", bold = true }}
preview_hovered = {{ underline = true }}

# Find
find_keyword  = {{ fg = "{yellow}", bold = true, italic = true }}
find_position = {{ fg = "{yellow}", bg = "reset", bold = true }}

# Marker
marker_copied   = {{ fg = "{green}", bg = "{green}" }}
marker_cut      = {{ fg = "{red}", bg = "{red}" }}
marker_selected = {{ fg = "{accent}", bg = "{accent}" }}

# Tab
tab_active   = {{ bg = "{accent}", fg = "{base}", bold = true }}
tab_inactive = {{ bg = "{surface0}", fg = "{subtext0}" }}
tab_width    = 1

# Count
count_copied   = {{ fg = "{base}", bg = "{green}", bold = true }}
count_cut      = {{ fg = "{base}", bg = "{red}", bold = true }}
count_selected = {{ fg = "{base}", bg = "{accent}", bold = true }}

# Border
border_symbol = "│"
border_style  = {{ fg = "{border}" }}

[mode]
normal_main = {{ bg = "{accent}", fg = "{base}", bold = true }}
normal_alt  = {{ bg = "{surface0}", fg = "{accent}" }}

select_main = {{ bg = "{alt}", fg = "{base}", bold = true }}
select_alt  = {{ bg = "{surface0}", fg = "{alt}" }}

unset_main  = {{ bg = "{yellow}", fg = "{base}", bold = true }}
unset_alt   = {{ bg = "{surface0}", fg = "{yellow}" }}

[status]
separator_open  = ""
separator_close = ""

# Progress
progress_label  = {{ fg = "{text}", bold = true }}
progress_normal = {{ fg = "{accent}", bg = "{surface0}" }}
progress_error  = {{ fg = "{red}", bg = "{surface0}" }}

# Permissions
permissions_t = {{ fg = "{accent}" }}
permissions_r = {{ fg = "{yellow}" }}
permissions_w = {{ fg = "{red}" }}
permissions_x = {{ fg = "{green}" }}
permissions_s = {{ fg = "{subtext0}" }}

[which]
cols            = 3
mask            = {{ bg = "{base}" }}
cand            = {{ fg = "{accent}" }}
rest            = {{ fg = "{subtext0}" }}
desc            = {{ fg = "{text}" }}
separator       = " ➜ "
separator_style = {{ fg = "{border}" }}

[filetype]
rules = [
    # Directories
    {{ url = "*/", fg = "{accent}", bold = true }},

    # Media with vibrant RGB
    {{ mime = "**/image/*", fg = "{alt}" }},
    {{ mime = "**/{"{audio,video}"}/*", fg = "{mauve}" }},

    # Archives
    {{ mime = "**/application/{"{zip,rar,7z*,tar,gzip,xz,zstd,bzip*,lzma,compress,archive,cpio,arj,xar,ms-cab*}"}", fg = "{red}" }},

    # Documents & Code
    {{ mime = "**/application/{"{pdf,doc,rtf}"}", fg = "{peach}" }},
    {{ mime = "application/json", fg = "{yellow}" }},
    {{ mime = "text/markdown", fg = "{accent}" }},

    # Special files
    {{ url = "*", is = "orphan", bg = "{red}" }},
    {{ url = "*", is = "exec", fg = "{green}", bold = true }},

    # Fallback
    {{ url = "*", fg = "{text}" }},
]

[icon]
prepend_conds = [
    {{ if = "dir & hovered", text = "󰝰", fg = "{accent}" }},
    {{ if = "dir", text = "󰉋", fg = "{accent}" }},
    {{ if = "link", text = "", fg = "{alt}" }},
    {{ if = "exec", text = "", fg = "{green}" }},
]
prepend_dirs = [
    # Spanish Common Folders
    {{ name = "Descargas", text = "󰉍", fg = "{alt}" }},
    {{ name = "Documentos", text = "󱔗", fg = "{blue}" }},
    {{ name = "Escritorio", text = "󰍹", fg = "{yellow}" }},
    {{ name = "Imágenes", text = "󰉏", fg = "{red}" }},
    {{ name = "Música", text = "󱍙", fg = "{mauve}" }},
    {{ name = "Vídeos", text = "󰉐", fg = "{green}" }},
    {{ name = "Juegos", text = "󰊴", fg = "{alt}" }},
    {{ name = "Proyectos", text = "󱘗", fg = "{accent}" }},
    {{ name = "Plantillas", text = "󱁿", fg = "{yellow}" }},
    {{ name = "Público", text = "󰉎", fg = "{peach}" }},

    # English Common Folders
    {{ name = "Downloads", text = "󰉍", fg = "{alt}" }},
    {{ name = "Documents", text = "󱔗", fg = "{blue}" }},
    {{ name = "Desktop", text = "󰍹", fg = "{yellow}" }},
    {{ name = "Pictures", text = "󰉏", fg = "{red}" }},
    {{ name = "Music", text = "󱍙", fg = "{mauve}" }},
    {{ name = "Videos", text = "󰉐", fg = "{green}" }},
    {{ name = "Movies", text = "󰉐", fg = "{green}" }},
    {{ name = "Games", text = "󰊴", fg = "{alt}" }},
    {{ name = "Development", text = "󱘗", fg = "{accent}" }},
    {{ name = "Public", text = "󰉎", fg = "{peach}" }},
    {{ name = "Templates", text = "󱁿", fg = "{yellow}" }},

    # Dev & Config Folders
    {{ name = "dotfiles", text = "󰌠", fg = "{yellow}" }},
    {{ name = ".config", text = "󱁿", fg = "{accent}" }},
    {{ name = ".git", text = "󰊢", fg = "{peach}" }},
    {{ name = "Arduino", text = "", fg = "#00979d" }},
    {{ name = "lost+found", text = "󰟢", fg = "{red}" }},
]
prepend_exts = [
    # Documents & Markdown
    {{ name = "md", text = "󰍔", fg = "{accent}" }},
    {{ name = "markdown", text = "󰍔", fg = "{accent}" }},
    {{ name = "txt", text = "󰈙", fg = "{text}" }},
    {{ name = "pdf", text = "󰈦", fg = "{red}" }},
    {{ name = "doc", text = "󰈬", fg = "{blue}" }},
    {{ name = "docx", text = "󰈬", fg = "{blue}" }},
    {{ name = "xls", text = "󰈛", fg = "{green}" }},
    {{ name = "xlsx", text = "󰈛", fg = "{green}" }},

    # Programming
    {{ name = "py", text = "󰌠", fg = "{yellow}" }},
    {{ name = "rs", text = "󱘗", fg = "{peach}" }},
    {{ name = "js", text = "󰌞", fg = "{yellow}" }},
    {{ name = "ts", text = "󰛦", fg = "{accent}" }},
    {{ name = "jsx", text = "󰌞", fg = "{yellow}" }},
    {{ name = "tsx", text = "󰛦", fg = "{accent}" }},
    {{ name = "json", text = "󰘦", fg = "{yellow}" }},
    {{ name = "toml", text = "󰅪", fg = "{alt}" }},
    {{ name = "yaml", text = "󰅪", fg = "{alt}" }},
    {{ name = "yml", text = "󰅪", fg = "{alt}" }},
    {{ name = "lua", text = "󰢱", fg = "{accent}" }},
    {{ name = "c", text = "", fg = "{blue}" }},
    {{ name = "cpp", text = "", fg = "{blue}" }},
    {{ name = "h", text = "", fg = "{blue}" }},
    {{ name = "hpp", text = "", fg = "{blue}" }},
    {{ name = "go", text = "󰟓", fg = "{blue}" }},
    {{ name = "sh", text = "󰞷", fg = "{green}" }},
    {{ name = "bash", text = "󰞷", fg = "{green}" }},
    {{ name = "zsh", text = "󰞷", fg = "{green}" }},

    # Images
    {{ name = "png", text = "󰋩", fg = "{alt}" }},
    {{ name = "jpg", text = "󰋩", fg = "{alt}" }},
    {{ name = "jpeg", text = "󰋩", fg = "{alt}" }},
    {{ name = "webp", text = "󰋩", fg = "{alt}" }},
    {{ name = "gif", text = "󰋩", fg = "{alt}" }},
    {{ name = "svg", text = "󰋩", fg = "{yellow}" }},

    # Media
    {{ name = "mp3", text = "󰎆", fg = "{yellow}" }},
    {{ name = "flac", text = "󰎆", fg = "{yellow}" }},
    {{ name = "wav", text = "󰎆", fg = "{yellow}" }},
    {{ name = "mp4", text = "󰕧", fg = "{mauve}" }},
    {{ name = "mkv", text = "󰕧", fg = "{mauve}" }},
    {{ name = "webm", text = "󰕧", fg = "{mauve}" }},

    # Archives
    {{ name = "zip", text = "", fg = "{red}" }},
    {{ name = "tar", text = "", fg = "{red}" }},
    {{ name = "gz", text = "", fg = "{red}" }},
    {{ name = "7z", text = "", fg = "{red}" }},
    {{ name = "rar", text = "", fg = "{red}" }},
]
'''

def generate_gtk_theme(theme_name, pal):
    base = pal['base']
    surface0 = pal['surface0']
    surface1 = pal['surface1']
    text = pal['text']
    subtext0 = pal['subtext0']
    accent = pal['accent']
    alt = pal['alt']
    br, bg, bb = pal['base_rgb']
    ar, ag, ab = pal['accent_rgb']
    altr, altg, altb = pal['alt_rgb']
    sr, sg, sb = pal['surface_rgb']

    return f'''/* Theme: {theme_name} (Cyber-Anime RGB Frosted Glass) */

/* Standard GTK theme variables */
@define-color theme_base_color {base};
@define-color theme_bg_color {base};
@define-color theme_fg_color {text};
@define-color theme_text_color {text};
@define-color theme_selected_bg_color {accent};
@define-color theme_selected_fg_color {base};
@define-color base_color {base};
@define-color bg_color {base};
@define-color text_color {text};
@define-color fg_color {text};
@define-color selected_bg_color {accent};
@define-color selected_fg_color {base};
@define-color insensitive_bg_color {surface0};
@define-color insensitive_fg_color {subtext0};

/* Custom Cyber Variables */
@define-color theme_accent {accent};
@define-color theme_alt {alt};
@define-color theme_bg rgba({br}, {bg}, {bb}, 0.94);
@define-color theme_bg_opaque {base};
@define-color theme_surface {surface0};
@define-color theme_surface_border rgba({ar}, {ag}, {ab}, 0.35);
@define-color theme_fg {text};
@define-color theme_fg_dim {subtext0};
@define-color theme_glow rgba({ar}, {ag}, {ab}, 0.35);
@define-color theme_glow_alt rgba({altr}, {altg}, {altb}, 0.25);

/* Base Window Styling */
window,
window.background,
#ThunarWindow,
.thunar,
.thunar-window {{
    background-color: rgba({br}, {bg}, {bb}, 0.94);
    color: {text};
    font-family: "JetBrainsMono Nerd Font", "Noto Sans", sans-serif;
}}

/* Views & TreeViews */
view,
treeview,
iconview,
ExoIconView,
ExoTreeView,
.view,
.standard-view {{
    background-color: transparent;
    color: {text};
}}

/* Top RGB accent glow strip */
menubar,
#ThunarWindow toolbar:first-child {{
    border-top: 2px solid transparent;
    border-image: linear-gradient(90deg, {accent}, {alt}, #00f0ff, #ff007f, #00ff9f, {accent}) 1;
}}

/* Menubar */
menubar {{
    background-color: rgba({br}, {bg}, {bb}, 0.88);
    color: {text};
    padding: 2px 4px;
    border-bottom: 1px solid rgba(255, 255, 255, 0.06);
}}

menubar > menuitem {{
    padding: 3px 8px;
    border-radius: 4px;
    color: {subtext0};
}}

menubar > menuitem:hover {{
    background: rgba({ar}, {ag}, {ab}, 0.25);
    color: {accent};
}}

/* Toolbar with frosted styling */
toolbar {{
    background-color: rgba({sr}, {sg}, {sb}, 0.75);
    border-bottom: 1px solid rgba({ar}, {ag}, {ab}, 0.25);
    padding: 2px 4px;
    color: {text};
}}

toolbar button {{
    background: rgba({sr}, {sg}, {sb}, 0.65);
    border: 1px solid rgba(255, 255, 255, 0.08);
    border-radius: 6px;
    color: {subtext0};
    padding: 3px 6px;
    margin: 1px 2px;
    transition: all 0.2s ease;
}}

toolbar button image {{
    padding: 0;
    margin: 0;
    min-width: 16px;
    min-height: 16px;
}}

toolbar button:hover {{
    background: rgba({ar}, {ag}, {ab}, 0.25);
    border-color: {accent};
    color: {accent};
    box-shadow: 0 0 8px rgba({ar}, {ag}, {ab}, 0.35);
}}

/* Pathbar / Breadcrumbs */
.path-bar-box,
.location-bar {{
    background-color: rgba({sr}, {sg}, {sb}, 0.70);
    border-bottom: 1px solid rgba({ar}, {ag}, {ab}, 0.20);
    padding: 3px 6px;
}}

.path-bar button {{
    background: rgba({sr}, {sg}, {sb}, 0.80);
    border: 1px solid rgba({ar}, {ag}, {ab}, 0.25);
    border-radius: 6px;
    color: {text};
    padding: 3px 8px;
    margin: 1px 2px;
}}

.path-bar button:hover {{
    background: rgba({ar}, {ag}, {ab}, 0.30);
    border-color: {accent};
    color: {accent};
}}

.path-bar button:checked,
.path-bar button:active {{
    background: {accent};
    color: {base};
    font-weight: bold;
}}

/* Sidebar (Bookmarks, Places, Drives) */
scrolledwindow.sidebar,
.sidebar {{
    background-color: rgba({sr}, {sg}, {sb}, 0.45);
    border-right: 1px solid rgba({ar}, {ag}, {ab}, 0.25);
}}

.sidebar treeview {{
    background-color: transparent;
    color: {text};
    padding: 6px;
}}

.sidebar treeview:hover {{
    background-color: transparent;
}}

/* Main Icon & Details View */
scrolledwindow,
viewport,
scrolledwindow > viewport {{
    background-color: transparent;
}}

/* Notebook & Tabs (Thunar Multi-tab & Split-view) */
notebook,
notebook.frame,
notebook > stack,
notebook > stack:backdrop,
notebook.frame > stack,
notebook.frame > stack:backdrop {{
    background-color: transparent;
    border: none;
    box-shadow: none;
    padding: 0;
}}

notebook > header {{
    background-color: rgba({br}, {bg}, {bb}, 0.85);
    border-bottom: 1px solid rgba({ar}, {ag}, {ab}, 0.25);
    padding: 2px 4px 0 4px;
}}

notebook > header tab {{
    background-color: rgba({sr}, {sg}, {sb}, 0.55);
    color: {subtext0};
    border: 1px solid rgba(255, 255, 255, 0.08);
    border-bottom: none;
    border-radius: 8px 8px 0 0;
    padding: 5px 14px;
    margin: 2px 3px 0 3px;
    transition: all 0.2s ease;
}}

notebook > header tab:hover {{
    background-color: rgba({ar}, {ag}, {ab}, 0.20);
    color: {accent};
}}

notebook > header tab:checked {{
    background-color: rgba({sr}, {sg}, {sb}, 0.90);
    color: {accent};
    border-color: {accent};
    border-bottom: 2px solid {accent};
    font-weight: bold;
    box-shadow: 0 -2px 8px rgba({ar}, {ag}, {ab}, 0.25);
}}

notebook > header tab:backdrop {{
    background-color: rgba({br}, {bg}, {bb}, 0.50);
    color: {subtext0};
}}

notebook > header tab:checked:backdrop {{
    background-color: rgba({sr}, {sg}, {sb}, 0.70);
    color: {accent};
    border-bottom: 2px solid {accent};
}}

/* Close button inside tab */
notebook > header tab button {{
    padding: 2px;
    margin: 0 0 0 6px;
    min-width: 16px;
    min-height: 16px;
    border-radius: 4px;
    background: transparent;
    color: {subtext0};
    border: none;
}}

notebook > header tab button:hover {{
    background: rgba(255, 0, 85, 0.40);
    color: #ffffff;
}}

/* Paned & Split View */
paned,
paned > separator {{
    background-color: transparent;
}}

paned > separator {{
    min-width: 4px;
    min-height: 4px;
    background-color: rgba({ar}, {ag}, {ab}, 0.25);
}}

paned > separator:hover {{
    background-color: {accent};
    box-shadow: 0 0 8px {accent};
}}

/* Ensure backdrop never turns white anywhere in the window */
window:backdrop,
window.background:backdrop,
#ThunarWindow:backdrop,
.thunar:backdrop,
.thunar-window:backdrop {{
    background-color: rgba({br}, {bg}, {bb}, 0.94);
    color: {text};
}}

view:backdrop,
treeview:backdrop,
iconview:backdrop,
ExoIconView:backdrop,
ExoTreeView:backdrop,
.view:backdrop,
.standard-view:backdrop,
scrolledwindow:backdrop,
viewport:backdrop,
scrolledwindow > viewport:backdrop,
grid:backdrop,
box:backdrop,
paned:backdrop {{
    background-color: transparent;
    color: {text};
}}

/* Selected & Hover Items */
view:selected,
treeview.view:selected,
iconview:selected,
ExoIconView:selected,
ExoTreeView:selected,
.view:selected {{
    background-color: {accent};
    color: {base};
    border-radius: 6px;
    font-weight: bold;
}}

view:hover,
treeview.view:hover,
iconview:hover,
ExoIconView:hover,
ExoTreeView:hover,
.view:hover {{
    background-color: rgba({ar}, {ag}, {ab}, 0.15);
}}

/* Context Menus & Popups */
menu,
.menu,
popover {{
    background-color: rgba({br}, {bg}, {bb}, 0.96);
    border: 1px solid {accent};
    border-radius: 10px;
    padding: 6px;
    box-shadow: 0 4px 20px rgba({ar}, {ag}, {ab}, 0.35);
}}

menu menuitem,
.menu menuitem {{
    border-radius: 6px;
    padding: 5px 10px;
    color: {text};
}}

menu menuitem:hover,
.menu menuitem:hover {{
    background: {accent};
    color: {base};
}}

/* Thin Cyber Scrollbar */
scrollbar {{
    background-color: transparent;
    transition: all 0.2s ease;
}}

scrollbar slider {{
    background-color: rgba({ar}, {ag}, {ab}, 0.35);
    border-radius: 4px;
    min-width: 6px;
    min-height: 6px;
    border: none;
}}

scrollbar slider:hover {{
    background-color: {accent};
    box-shadow: 0 0 8px {accent};
}}

/* Statusbar */
statusbar {{
    background-color: rgba({br}, {bg}, {bb}, 0.88);
    border-top: 1px solid rgba({ar}, {ag}, {ab}, 0.25);
    color: {subtext0};
    padding: 3px 10px;
}}
'''

def main():
    themes = sorted(glob.glob(os.path.join(WAYBAR_THEMES, "*.css")))
    print(f"Found {len(themes)} themes to generate.")
    
    for theme_path in themes:
        theme_name = os.path.basename(theme_path).replace(".css", "")
        raw_colors = parse_waybar_theme(theme_path)
        pal = get_theme_palette(theme_name, raw_colors)
        
        # Generate Yazi theme
        yazi_content = generate_yazi_theme(theme_name, pal)
        yazi_file = os.path.join(YAZI_THEMES_DIR, f"{theme_name}.toml")
        with open(yazi_file, 'w') as f:
            f.write(yazi_content)
            
        # Generate GTK theme
        gtk_content = generate_gtk_theme(theme_name, pal)
        gtk_file = os.path.join(GTK_THEMES_DIR, f"{theme_name}.css")
        with open(gtk_file, 'w') as f:
            f.write(gtk_content)
            
        print(f"Generated {theme_name}: Yazi TOML + GTK3 CSS")

    print("\nAll 12 themes generated successfully!")

if __name__ == "__main__":
    main()
