#!/bin/bash

# Check if dunstctl is installed
if ! command -v dunstctl &> /dev/null; then
    echo "dunstctl could not be found. Please install dunst and ensure dunstctl is in your PATH."
    exit 1
fi

# Check if notify-send is installed
if ! command -v notify-send &> /dev/null; then
    echo "notify-send could not be found. Please install notify-send and ensure it is in your PATH."
    exit 1
fi

# Function to resend a notification using notify-send
resend_notification() {
    local notification="$1"
    local summary=$(echo "$notification" | grep -oP '(?<="summary":")[^"]*')
    local body=$(echo "$notification" | grep -oP '(?<="body":")[^"]*')
    local appname=$(echo "$notification" | grep -oP '(?<="appname":")[^"]*')
    local urgency=$(echo "$notification" | grep -oP '(?<="urgency":")[^"]*')
    local icon=$(echo "$notification" | grep -oP '(?<="icon":")[^"]*')

    notify-send -u "$urgency" -a "$appname" -i "$icon" "$summary" "$body"
}

# Pop notifications from history and resend them
while true; do
    notification=$(dunstctl history-pop)
    if [ -z "$notification" ] || [ "$notification" == "No history available." ]; then
        echo "No more notifications found."
        break
    fi
    resend_notification "$notification"
done

