#!/usr/bin/env python3
"""Event-driven active-window title for Hyprland and Waybar."""

from __future__ import annotations

import html
import json
import os
import re
import socket
import subprocess
import time
from pathlib import Path

MAX_LENGTH = 50
DEFAULT_ICON = ""

# fmt: off
# Keep application aliases grouped for easy maintenance.
ICON_GROUPS = {
    # Terminals
    "": ("kitty",),
    "": ("alacritty", "foot"),

    # File Managers
    "󱢴": ("dolphin",),

    # Web Browsers
    "󰈹": ("firefox",),
    "": ("zen",),
    "": ("tor browser",),

    # Development / IDEs
    "󰨞": ("code",),
    "": ("rider",),
    "": ("postman",),
    "": ("pgadmin",),
    "": ("desktop",),
    "": ("java",),

    # Media / Audio / Video
    "": ("mpv",),
    "󰕼": ("vlc",),
    "": ("obsproject.studio",),
    "": ("kdenlive",),
    "": ("spotify",),
    "": ("lollypop",),
    "󰟌": ("easyeffects",),

    # Graphics / Images
    "": ("unity",),
    "": ("imv", "nomacs"),
    "": ("gimp",),

    # Office / Documents
    "": ("libreoffice-writer",),
    "": ("libreoffice-calc",),
    "": ("libreoffice-impress",),
    "": ("okular", "zathura"),
    "": ("foliate",),

    # Communication / Chat
    "": ("discord",),
    "": ("telegram",),
    "": ("signal",),
    "": ("zoom",),

    # Gaming
    "󰓓": ("steam",),
    "": ("faugus",),
    "󱢾": ("heroic",),
    "": ("exe",),

    # Utilities
    "": ("ark",),
    "": ("protonplus",),
    "󰋸": ("waypaper",),
    "": ("protonvpn",),
    "󰢹": ("virtualbox",),
    "": ("qbittorrent",),
    "": ("missioncenter",),
    "": ("nwg-look", "qt6ct", "qt5ct", "kvantum"),

    # System
    "": ("hyprland",),
    "": ("share-picker",),

    # Notes / Productivity
    "": ("obsidian",),
    "": ("timecanvas",),
    "󰨖": ("gnomesubtitles",),

    # Based on DE
    "": ("kde",),
    "": ("gnome",),
}

# Explicit priority: earlier entries win.
PRIORITY_MATCHES = (
    ("batman", "󰭟"),
)

# fmt: on

ICONS = {name.lower(): icon for icon, names in ICON_GROUPS.items() for name in names}

# Longest aliases win during substring matching.
PARTIAL_MATCHES = sorted(ICONS, key=len, reverse=True)

SUFFIX_PATTERNS = (
    re.compile(r"(\)) - [^-]+ - [^-]+$"),
    re.compile(r"(\)) - [^-]+$"),
    re.compile(r"(\)) — [^—]+ — [^—]+$"),
    re.compile(r"(\)) — [^—]+$"),
)

PLAIN_SUFFIX_PATTERNS = (
    re.compile(r" - [^-]+$"),
    re.compile(r" — [^—]+$"),
)


def get_icon(app_class: str) -> str:
    full_class = app_class.casefold()

    # 1. Explicit overrides, in declared priority order.
    for name, icon in PRIORITY_MATCHES:
        if name in full_class:
            return icon

    # 2. Exact match for the full class or final dot-separated component.
    app_name = full_class.rsplit(".", 1)[-1]

    if icon := ICONS.get(full_class):
        return icon

    if icon := ICONS.get(app_name):
        return icon

    # 3. Remaining aliases, longest match first.
    for name in PARTIAL_MATCHES:
        if name in full_class:
            return ICONS[name]

    # 4. Fallback.
    return DEFAULT_ICON


def clean_title(title: str, app_class: str) -> str:
    if "lollypop" in app_class.lower():
        return "Lollypop"

    for pattern in SUFFIX_PATTERNS:
        title = pattern.sub(r"\1", title)

    if ")" not in title:
        for pattern in PLAIN_SUFFIX_PATTERNS:
            title = pattern.sub("", title)

    if len(title) > MAX_LENGTH:
        title = title[:MAX_LENGTH] + "…"

    return title


def render(app_class: str, title: str) -> str:
    if not app_class:
        return ""

    icon = get_icon(app_class)
    safe_title = html.escape(clean_title(title, app_class), quote=False)

    return f"<span size='large'>{icon}</span>  {safe_title} "


def emit(app_class: str, title: str) -> None:
    print(render(app_class, title), flush=True)


def get_socket_path(name: str) -> Path:
    runtime_dir = os.environ.get("XDG_RUNTIME_DIR")
    signature = os.environ.get("HYPRLAND_INSTANCE_SIGNATURE")

    if not runtime_dir or not signature:
        raise RuntimeError("Missing Hyprland runtime environment")

    return Path(runtime_dir) / "hypr" / signature / name


def get_initial_window() -> dict:
    try:
        result = subprocess.run(
            ["hyprctl", "-j", "activewindow"],
            capture_output=True,
            text=True,
            timeout=2,
            check=True,
        )
        return json.loads(result.stdout)
    except (OSError, subprocess.SubprocessError, json.JSONDecodeError):
        return {}


def main() -> None:
    socket_path = get_socket_path(".socket2.sock")
    window = get_initial_window()

    app_class = window.get("class") or ""
    title = window.get("title") or ""
    address = window.get("address") or ""

    emit(app_class, title)

    while True:
        try:
            with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as sock:
                sock.connect(str(socket_path))
                reader = sock.makefile("r", encoding="utf-8")

                for line in reader:
                    event, separator, data = line.rstrip("\n").partition(">>")
                    if not separator:
                        continue

                    if event == "activewindow":
                        app_class, _, title = data.partition(",")
                        emit(app_class, title)

                    elif event == "activewindowv2":
                        address = data

                    elif event == "windowtitlev2":
                        event_address, separator, event_title = data.partition(",")

                        if separator and event_address == address:
                            title = event_title
                            emit(app_class, title)

                    elif event == "windowtitle":
                        # Compatibility fallback for older event formats.
                        if data == address:
                            window = get_initial_window()
                            app_class = window.get("class") or app_class
                            title = window.get("title") or ""
                            emit(app_class, title)

        except (OSError, UnicodeError):
            time.sleep(1)


if __name__ == "__main__":
    main()
