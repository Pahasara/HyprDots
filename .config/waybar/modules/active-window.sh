#!/usr/bin/bash

# --- CONFIGURATION ---
MAX_LENGTH=50
DEFAULT_ICON=""

ICON_GROUPS=(
# Terminals
    "kitty|"
    "alacritty foot|"

# File Managers
    "dolphin|󱢴"

# Web Browsers
    "firefox|󰈹"
    "zen|"
    "tor browser|"

# Development / IDEs
    "code|󰨞"
    "rider|"
    "postman|"
    "pgadmin|"
    "github|"

# Media / Audio / Video
    "mpv|"
    "vlc|󰕼"
    "obsproject.studio|"
    "kdenlive|"
    "spotify|"
    "lollypop|"
    "easyeffects|󰟌"

# Graphics / Images
    "imv nomacs|"
    "gimp|"

# Office / Documents
    "libreoffice-writer|"
    "libreoffice-calc|"
    "libreoffice-impress|"
    "okular zathura|"
    "foliate|"

# Communication / Chat
    "discord|"
    "telegram|"
    "signal|"
    "zoom|"

# Gaming
    "steam|󰓓"
    "lutris|"

# System / Utilities
    "ark|"
    "pupgui2|"
    "waypaper|󰋸"
    "protonvpn|"
    "virtualbox|󰢹"
    "qbittorrent|"
    "missioncenter|"
    "nwg-look qt6ct qt5ct kvantum|"

# Notes / Productivity
    "obsidian|"
    "timecanvas|"
    "gnomesubtitles|󰨖"

# Based on DE
    "kde|"
    "gnome|"
)

# --- INITIALIZATION ---
declare -A icons
for entry in "${ICON_GROUPS[@]}"; do
    IFS="|" read -r classes icon <<< "$entry"
    for class in $classes; do
        icons["$class"]="$icon"
    done
done

HYPR_SOCK="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

get_icon() {
    local full_class="${1,,}"
    
    # 1. OPTIMIZATION: Get the last part of the dot-notation (e.g., 'ark' from 'org.kde.ark')
    # This ensures specific apps beat generic desktop environment names.
    local app_name="${full_class##*.}"

    # 2. Fast: O(1) Exact Match on the specific app name
    if [[ -n "${icons[$app_name]}" ]]; then
        echo "${icons[$app_name]}"
        return
    fi

    # 3. Fast: O(1) Exact Match on the full string (in case it's not dot-notation)
    if [[ -n "${icons[$full_class]}" ]]; then
        echo "${icons[$full_class]}"
        return
    fi

    # 4. Fallback: O(n) Partial Match (for cases like "jetbrains-rider")
    for key in "${!icons[@]}"; do
        if [[ "$full_class" == *"$key"* ]]; then
            echo "${icons[$key]}"
            return
        fi
    done

    echo "$DEFAULT_ICON"
}

update_output() {
    local active_window
    active_window=$(hyprctl activewindow -j 2>/dev/null)
    
    local class=$(echo "$active_window" | jq -r '.class // empty')
    local title=$(echo "$active_window" | jq -r '.title // empty')

    if [[ -z "$class" || "$class" == "null" ]]; then
        echo ""
        return
    fi

    title="${title% — *}"
    title="${title% - *}"
    (( ${#title} > MAX_LENGTH )) && title="${title:0:MAX_LENGTH}…"
    
    echo "<span size='large'>$(get_icon "$class")</span>  $title"
}

# --- MAIN ---
update_output
socat -U - UNIX-CONNECT:"$HYPR_SOCK" | while read -r line; do
    case "$line" in
        activewindowv2*|windowtitle*) update_output ;;
    esac
done
