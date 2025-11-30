#!/bin/bash
## Active Window Display Script for Waybar with Nerd Font Icons (Event-Driven)
## Uses hyprctl --watch for instant updates with minimal CPU usage

## Requirements:
## - `hyprctl`: Hyprland IPC tool
## - `jq`: JSON parser

default_max_length=50

# Nerd Font Icons for different applications
ICON_KITTY=""
ICON_FIREFOX="󰈹"
ICON_ZEN=""
ICON_DISCORD=""
ICON_SPOTIFY=""
ICON_VSCODE="󰨞"
ICON_RIDER=""
ICON_DOLPHIN="󱢴"
ICON_LUTRIS=""
ICON_STEAM="󰓓"
ICON_LOLLYPOP=""
ICON_MISSIONCENTER=""
ICON_OBSIDIAN="󱞁"
ICON_QBITTORRENT="󰅢"
ICON_GITHUB=""
ICON_SIGNAL=""
ICON_TERMINAL=""
ICON_BROWSER=""
ICON_GENERIC=""

trim_info() {
    local info="$1"
    local max_length="$2"
    
    if [ ${#info} -gt $max_length ]; then
        local trim_length=$((max_length - 1))
        info="${info:0:$trim_length}…"
    fi
    echo "$info"
}

clean_title() {
    local title="$1"
    local class="$2"
    
    # Remove common app name suffixes from title
    title="${title% — Zen Browser}"
    title="${title% — Mozilla Firefox}"
    title="${title% - Mozilla Firefox}"
    title="${title% - Visual Studio Code}"
    title="${title% — Dolphin}"
    title="${title% - Discord}"
    title="${title% - Obsidian*}"
    title="${title% - JetBrains Rider*}"
    title="${title% - Signal}"
    title="${title% - qBittorrent*}"
    
    # If title is empty or just the app name, use class as fallback
    if [ -z "$title" ] || [ "$title" = "null" ]; then
        title="$class"
    fi
    
    echo "$title"
}

detect_icon() {
    local class="$1"
    local class_lower=$(echo "$class" | tr '[:upper:]' '[:lower:]')
    
    case "$class_lower" in
        *kitty*)            echo "$ICON_KITTY" ;;
        *firefox*)          echo "$ICON_FIREFOX" ;;
        *zen-browser*|*zen*)  echo "$ICON_ZEN" ;;
        *discord*)          echo "$ICON_DISCORD" ;;
        *spotify*)          echo "$ICON_SPOTIFY" ;;
        *code*|*vscode*)    echo "$ICON_VSCODE" ;;
        jetbrains-rider*)            echo "$ICON_RIDER" ;;
        *dolphin*)          echo "$ICON_DOLPHIN" ;;
        *lutris*)           echo "$ICON_LUTRIS" ;;
        *steam*)            echo "$ICON_STEAM" ;;
        *lollypop*)         echo "$ICON_LOLLYPOP" ;;
        *missioncenter*)    echo "$ICON_MISSIONCENTER" ;;
        *obsidian*)         echo "$ICON_OBSIDIAN" ;;
        *qbittorrent*)      echo "$ICON_QBITTORRENT" ;;
        *github*)           echo "$ICON_GITHUB" ;;
        *signal*)           echo "$ICON_SIGNAL" ;;
        *alacritty*|*wezterm*|*foot*) echo "$ICON_TERMINAL" ;;
        *chromium*|*brave*|*chrome*) echo "$ICON_BROWSER" ;;
        *)                  echo "$ICON_GENERIC" ;;
    esac
}

get_active_window() {
    local max_length="$1"
    
    # Get active window info from hyprctl
    local window_info=$(hyprctl activewindow -j 2>/dev/null)
    
    if [ -z "$window_info" ] || [ "$window_info" = "Invalid" ]; then
        echo ""
        return
    fi
    
    # Parse JSON using jq - use current title, not initialTitle
    local class=$(echo "$window_info" | jq -r '.class // empty')
    local title=$(echo "$window_info" | jq -r '.title // empty')
    
    # If both are empty, show nothing
    if [ -z "$class" ] && [ -z "$title" ]; then
        echo ""
        return
    fi
    
    # Clean up the title (remove app name suffixes)
    local cleaned_title=$(clean_title "$title" "$class")
    
    # Get icon and trim title
    local icon=$(detect_icon "$class")
    local trimmed_title=$(trim_info "$cleaned_title" "$max_length")
    
    # Output format with larger icon
    echo "<span size='large'>$icon</span> $trimmed_title"
}

# Parse max_length argument
if [[ $1 =~ max_length=([0-9]+) ]]; then
    max_length="${BASH_REMATCH[1]}"
else
    max_length=$default_max_length
fi

# Print initial window
get_active_window "$max_length"

# Simple event loop that checks for changes
# This monitors the activewindow and only updates when it actually changes
previous_output=""
while true; do
    current_output=$(get_active_window "$max_length")
    
    # Only print if output changed (reduces unnecessary updates)
    if [ "$current_output" != "$previous_output" ]; then
        echo "$current_output"
        previous_output="$current_output"
    fi
    
    # Small sleep to avoid hammering the CPU (0.1s = 100ms for near-instant feel)
    sleep 0.1
done
