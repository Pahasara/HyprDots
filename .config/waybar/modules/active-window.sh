#!/usr/bin/bash

MAX_LENGTH=50
DEFAULT_ICON=""

ICON_GROUPS=(
    "kitty|"
    "alacritty foot|"
    "firefox|󰈹"
    "zen|"
    "dolphin|󱢴"
    "code|󰨞"
    "jetbrains-rider|"
    "discord|"
    "spotify|"
    "steam|󰓓"
    "lutris|"
    "nwg-look qt6ct qt5ct kvantum|"
    "lollypop|"
    "missioncenter|"
    "mpv|"
    "vlc|󰕼"
    "obsidian|󱞁"
    "qbittorrent|"
    "signal|"
    "github|"
    "virtualbox|󰢹"
    "kde|"
    "gnome|"
)

declare -A icons
for entry in "${ICON_GROUPS[@]}"; do
    IFS="|" read -r classes icon <<< "$entry"
    for class in $classes; do
        icons["$class"]="$icon"
    done
done

HYPR_SOCK="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

get_icon() {
    local class_name="${1,,}"
    if [[ -n "${icons[$class_name]}" ]]; then
        echo "${icons[$class_name]}"
        return
    fi
    for key in "${!icons[@]}"; do
        if [[ "$class_name" == *"$key"* ]]; then
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

update_output
socat -U - UNIX-CONNECT:"$HYPR_SOCK" | while read -r line; do
    case "$line" in
        activewindowv2*|windowtitle*) update_output ;;
    esac
done
