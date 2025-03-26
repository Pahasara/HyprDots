#!/bin/bash

## This script adjusts the screen brightness using `brightnessctl`
## and displays a notification with the updated brightness level.

## Requirements:
## - `brightnessctl`: Controls screen brightness.
## - `dunst`: Sends notifications.

## Usage:
## - Run with `up` to increase brightness.
## - Run with `down` to decrease brightness.

## Author: Pahasara Dewnith (https://github.com/Pahasara)

msgTag="brightness"

if [[ $# -ne 1 ]] || [[ "$1" != "up" && "$1" != "down" ]]; then
    echo "Usage: $0 [up/down]"
    exit 1
fi

if [[ "$1" == "up" ]]; then
    brightnessctl -e4 set +1%
else
    brightnessctl -e4 set 1%-
fi

current=$(brightnessctl get)
max=$(brightnessctl max)
percentage=$((current * 100 / max))

dunstify -t 2000 \
         -a "Brightness" -u low -I "$HOME/.local/share/icons/dunst/brightness.png" \
         -h string:x-dunst-stack-tag:$msgTag \
         -h int:value:"$percentage" \
         "Brightness: ${percentage}%"
