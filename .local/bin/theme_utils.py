#!/usr/bin/env python3
"""
theme_utils.py — Unified Theme Engine for Cyber Anime Dotfiles
Provides:
1. Curated color palettes for all 12 pre-established themes.
2. Fast visual palette extraction from ANY wallpaper (PIL Lanczos/MedianCut).
3. Franchise keyword detection heuristic.
4. Active theme detection and CSS injection for GTK Layer-Shell windows
   (cyber-settings, calendar-popup, volume-popup, wlogout).
"""

import os
import sys
import json
import glob
import colorsys
import argparse

THEMES = {
    "cyber-anime": {
        "display_name": "Cyber Anime (Tokyo Neon)",
        "accent": "#00f0ff",
        "accent_rgb": (0, 240, 255),
        "alt": "#ff007f",
        "alt_rgb": (255, 0, 127),
        "bg": "rgba(8, 9, 13, 0.94)",
        "bg_hex": "#08090d",
        "surface": "#0e111a",
        "surface_border": "rgba(0, 240, 255, 0.35)",
        "fg": "#e2f1f8",
        "fg_dim": "#8fa8b8",
        "glow": "rgba(0, 240, 255, 0.35)",
        "glow_alt": "rgba(255, 0, 127, 0.22)",
        "keywords": ["cyber", "neon", "tokyo", "edgerunners", "lucy", "cyberpunk", "hacker", "future"]
    },
    "silver-wolf": {
        "display_name": "Silver Wolf (Cyber Violet)",
        "accent": "#a855f7",
        "accent_rgb": (168, 85, 247),
        "alt": "#00f0ff",
        "alt_rgb": (0, 240, 255),
        "bg": "rgba(10, 8, 20, 0.94)",
        "bg_hex": "#0a0814",
        "surface": "#120e24",
        "surface_border": "rgba(168, 85, 247, 0.35)",
        "fg": "#f3e8ff",
        "fg_dim": "#bca7e8",
        "glow": "rgba(168, 85, 247, 0.35)",
        "glow_alt": "rgba(0, 240, 255, 0.22)",
        "keywords": ["silver wolf", "silverwolf", "punklorde", "honkai star rail", "bronya"]
    },
    "blue-archive": {
        "display_name": "Blue Archive (Kivotos Azure)",
        "accent": "#38bdf8",
        "accent_rgb": (56, 189, 248),
        "alt": "#ffd166",
        "alt_rgb": (255, 209, 102),
        "bg": "rgba(6, 14, 26, 0.94)",
        "bg_hex": "#060e1a",
        "surface": "#0e1c30",
        "surface_border": "rgba(56, 189, 248, 0.35)",
        "fg": "#f0f9ff",
        "fg_dim": "#93c5fd",
        "glow": "rgba(56, 189, 248, 0.35)",
        "glow_alt": "rgba(255, 209, 102, 0.22)",
        "keywords": ["blue archive", "yuuka", "azusa", "serika", "shiroko", "arona", "plana", "millenium", "kivotos", "sensei", "ganyu"]
    },
    "crimson-rose": {
        "display_name": "Crimson Rose (Blood & Rose)",
        "accent": "#ff0055",
        "accent_rgb": (255, 0, 85),
        "alt": "#ff758f",
        "alt_rgb": (255, 117, 143),
        "bg": "rgba(13, 6, 9, 0.94)",
        "bg_hex": "#0d0609",
        "surface": "#1a0c12",
        "surface_border": "rgba(255, 0, 85, 0.35)",
        "fg": "#fff0f3",
        "fg_dim": "#ff758f",
        "glow": "rgba(255, 0, 85, 0.35)",
        "glow_alt": "rgba(255, 117, 143, 0.22)",
        "keywords": ["camellya", "zero two", "phut hon", "blood", "rose", "crimson", "darling", "azur lane", "pixel lane"]
    },
    "furina-hydro": {
        "display_name": "Furina (Fontaine Hydro)",
        "accent": "#00c2cb",
        "accent_rgb": (0, 194, 203),
        "alt": "#ffd166",
        "alt_rgb": (255, 209, 102),
        "bg": "rgba(5, 10, 20, 0.94)",
        "bg_hex": "#050a14",
        "surface": "#0c172a",
        "surface_border": "rgba(0, 194, 203, 0.35)",
        "fg": "#f0f8ff",
        "fg_dim": "#a5d8ff",
        "glow": "rgba(0, 194, 203, 0.35)",
        "glow_alt": "rgba(255, 209, 102, 0.22)",
        "keywords": ["furina", "fontaine", "focalors", "hydro", "neuvillette", "archon", "opera"]
    },
    "kurumi-tokisaki": {
        "display_name": "Kurumi (Crimson & Gold)",
        "accent": "#dc2626",
        "accent_rgb": (220, 38, 38),
        "alt": "#fbbf24",
        "alt_rgb": (251, 191, 36),
        "bg": "rgba(9, 5, 7, 0.94)",
        "bg_hex": "#090507",
        "surface": "#140a0f",
        "surface_border": "rgba(220, 38, 38, 0.35)",
        "fg": "#fef2f2",
        "fg_dim": "#fca5a5",
        "glow": "rgba(220, 38, 38, 0.35)",
        "glow_alt": "rgba(251, 191, 36, 0.22)",
        "keywords": ["kurumi", "tokisaki", "zaphakiel", "date a live", "clock", "spirit"]
    },
    "firefly-starlight": {
        "display_name": "Firefly (Starlight Mint)",
        "accent": "#2dd4bf",
        "accent_rgb": (45, 212, 191),
        "alt": "#fb923c",
        "alt_rgb": (251, 146, 60),
        "bg": "rgba(7, 17, 19, 0.94)",
        "bg_hex": "#071113",
        "surface": "#0d1e22",
        "surface_border": "rgba(45, 212, 191, 0.35)",
        "fg": "#f0fdfa",
        "fg_dim": "#99f6e4",
        "glow": "rgba(45, 212, 191, 0.35)",
        "glow_alt": "rgba(251, 146, 60, 0.22)",
        "keywords": ["firefly", "sam", "starlight", "glamour", "titania", "iron cavalry"]
    },
    "keqing-electro": {
        "display_name": "Keqing (Electro Violet)",
        "accent": "#8b5cf6",
        "accent_rgb": (139, 92, 246),
        "alt": "#d946ef",
        "alt_rgb": (217, 70, 239),
        "bg": "rgba(10, 6, 20, 0.94)",
        "bg_hex": "#0a0614",
        "surface": "#130c26",
        "surface_border": "rgba(139, 92, 246, 0.35)",
        "fg": "#faf5ff",
        "fg_dim": "#d8b4fe",
        "glow": "rgba(139, 92, 246, 0.35)",
        "glow_alt": "rgba(217, 70, 239, 0.22)",
        "keywords": ["keqing", "fischl", "electro", "raiden", "ei", "shogun", "inazuma", "purple"]
    },
    "carlotta-ocean": {
        "display_name": "Carlotta (Sea Emerald & Teal)",
        "accent": "#10b981",
        "accent_rgb": (16, 185, 129),
        "alt": "#06b6d4",
        "alt_rgb": (6, 182, 212),
        "bg": "rgba(4, 15, 14, 0.94)",
        "bg_hex": "#040f0e",
        "surface": "#081a18",
        "surface_border": "rgba(16, 185, 129, 0.35)",
        "fg": "#ecfdf5",
        "fg_dim": "#a7f3d0",
        "glow": "rgba(16, 185, 129, 0.35)",
        "glow_alt": "rgba(6, 182, 212, 0.22)",
        "keywords": ["carlotta", "cartethyia", "iuno", "wuthering waves", "emerald", "ocean", "sea"]
    },
    "alya-sakura": {
        "display_name": "Alya (Pastel Sakura)",
        "accent": "#f472b6",
        "accent_rgb": (244, 114, 182),
        "alt": "#c084fc",
        "alt_rgb": (192, 132, 252),
        "bg": "rgba(18, 8, 15, 0.94)",
        "bg_hex": "#12080f",
        "surface": "#1e0e1a",
        "surface_border": "rgba(244, 114, 182, 0.35)",
        "fg": "#fff1f2",
        "fg_dim": "#fbcfe8",
        "glow": "rgba(244, 114, 182, 0.35)",
        "glow_alt": "rgba(192, 132, 252, 0.22)",
        "keywords": ["alya", "roshidere", "kujou", "sakura", "pink", "pastel", "masha"]
    },
    "matrix": {
        "display_name": "Matrix (BlackArch Red)",
        "accent": "#ff4455",
        "accent_rgb": (255, 68, 85),
        "alt": "#ff8040",
        "alt_rgb": (255, 128, 64),
        "bg": "rgba(8, 0, 0, 0.94)",
        "bg_hex": "#080000",
        "surface": "#160404",
        "surface_border": "rgba(255, 68, 85, 0.35)",
        "fg": "#cc3344",
        "fg_dim": "#aa3344",
        "glow": "rgba(255, 68, 85, 0.35)",
        "glow_alt": "rgba(255, 128, 64, 0.22)",
        "keywords": ["matrix", "blackhat", "blackarch", "terminal", "darknet"]
    },
    "macchiato": {
        "display_name": "Macchiato (Catppuccin Warm)",
        "accent": "#b7bdf8",
        "accent_rgb": (183, 189, 248),
        "alt": "#eed49f",
        "alt_rgb": (238, 212, 159),
        "bg": "rgba(36, 39, 58, 0.94)",
        "bg_hex": "#24273a",
        "surface": "#1e2030",
        "surface_border": "rgba(183, 189, 248, 0.35)",
        "fg": "#cad3f5",
        "fg_dim": "#8087a2",
        "glow": "rgba(183, 189, 248, 0.35)",
        "glow_alt": "rgba(238, 212, 159, 0.22)",
        "keywords": ["catppuccin", "macchiato", "mocha", "latte", "coffee"]
    },
    "pastel-end4": {
        "display_name": "Pastel End-4 (Material Lavender)",
        "accent": "#d0bcff",
        "accent_rgb": (208, 188, 255),
        "alt": "#e8def8",
        "alt_rgb": (232, 222, 248),
        "bg": "rgba(20, 18, 26, 0.94)",
        "bg_hex": "#14121a",
        "surface": "#1d1926",
        "surface_border": "rgba(208, 188, 255, 0.35)",
        "fg": "#f3eefc",
        "fg_dim": "#cac4d0",
        "glow": "rgba(208, 188, 255, 0.35)",
        "glow_alt": "rgba(232, 222, 248, 0.22)",
        "keywords": ["end4", "end-4", "pastel", "lavender", "material", "iris", "minimal"]
    }
}

def get_active_theme():
    """Detects currently active theme from config symlinks or state file."""
    theme_state = os.path.expanduser("~/.config/rofi/.current_theme")
    if os.path.isfile(theme_state):
        try:
            with open(theme_state, "r", encoding="utf-8") as f:
                th = f.read().strip()
                if th in THEMES:
                    return th
        except Exception:
            pass

    waybar_link = os.path.expanduser("~/.config/waybar/theme.css")
    if os.path.islink(waybar_link):
        try:
            target = os.path.basename(os.readlink(waybar_link))
            name = target.replace(".css", "")
            if name in THEMES:
                return name
        except Exception:
            pass

    return "cyber-anime"

def get_palette(theme_name=None):
    """Returns palette dict for given theme or active theme."""
    if not theme_name or theme_name not in THEMES:
        theme_name = get_active_theme()
    return THEMES.get(theme_name, THEMES["cyber-anime"])

def color_distance(c1, c2):
    """Computes weighted perceptual distance between two RGB colors using HSV."""
    r1, g1, b1 = [x / 255.0 for x in c1]
    r2, g2, b2 = [x / 255.0 for x in c2]
    h1, s1, v1 = colorsys.rgb_to_hsv(r1, g1, b1)
    h2, s2, v2 = colorsys.rgb_to_hsv(r2, g2, b2)
    # Hue circular difference
    dh = min(abs(h1 - h2), 1.0 - abs(h1 - h2)) * 2.0
    ds = abs(s1 - s2)
    dv = abs(v1 - v2)
    return (dh * 3.0) + (ds * 1.6) + (dv * 0.8)

def extract_dominant_colors(img_path):
    """Extracts top prominent vibrant colors from an image using PIL."""
    try:
        from PIL import Image
        with Image.open(img_path) as im:
            im.seek(0)
            if im.mode != "RGB":
                im = im.convert("RGB")
            im.thumbnail((120, 120))
            q = im.quantize(colors=16, method=Image.Quantize.MEDIANCUT)
            palette = q.getpalette()[:48]
            colors = [(palette[i * 3], palette[i * 3 + 1], palette[i * 3 + 2]) for i in range(16)]
            counts = q.histogram()[:16]

            scored = []
            for rgb, count in zip(colors, counts):
                r, g, b = [x / 255.0 for x in rgb]
                h, s, v = colorsys.rgb_to_hsv(r, g, b)
                # Ignore pitch black or blinding white
                if v < 0.10 or v > 0.96 or s < 0.12:
                    continue
                score = (s ** 1.3) * (v ** 0.8) * (count ** 0.5)
                scored.append((score, rgb))
            scored.sort(reverse=True)
            return [rgb for _, rgb in scored[:4]]
    except Exception:
        return []

def detect_theme_for_wallpaper(img_path=None, title="", folder=""):
    """
    Intelligently determines the best fitting theme among the 12 pre-established themes:
    1. Franchise/character keywords in title/path.
    2. Dominant color extraction from image/frame.
    """
    text = f"{title} {folder}".lower()
    for theme_id, meta in THEMES.items():
        if any(kw in text for kw in meta.get("keywords", [])):
            return theme_id

    if img_path and os.path.isfile(img_path):
        dominant = extract_dominant_colors(img_path)
        if dominant:
            best_score = float("inf")
            best_theme = "cyber-anime"
            for theme_id, meta in THEMES.items():
                acc = meta["accent_rgb"]
                alt = meta["alt_rgb"]
                score = 0
                for i, col in enumerate(dominant[:3]):
                    weight = 1.0 / (i + 1)
                    dist_acc = color_distance(col, acc)
                    dist_alt = color_distance(col, alt)
                    score += min(dist_acc, dist_alt * 1.1) * weight
                if score < best_score:
                    best_score = score
                    best_theme = theme_id
            return best_theme

    return "cyber-anime"

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Cyber Anime Theme Utils")
    parser.add_argument("action", choices=["current", "detect", "palette", "list"], help="Action to perform")
    parser.add_argument("target", nargs="?", default="", help="Image path or theme name")
    parser.add_argument("--title", default="", help="Wallpaper title")
    parser.add_argument("--folder", default="", help="Wallpaper folder")

    args = parser.parse_args()

    if args.action == "current":
        print(get_active_theme())
    elif args.action == "list":
        for k in THEMES:
            print(k)
    elif args.action == "palette":
        p = get_palette(args.target if args.target else None)
        print(json.dumps(p, indent=2))
    elif args.action == "detect":
        detected = detect_theme_for_wallpaper(args.target, args.title, args.folder)
        print(detected)
