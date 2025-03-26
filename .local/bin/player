#!/bin/bash

## This script controls media playback for multiple players, including Spotify.
## It allows toggling playback, skipping tracks, and controlling specific players.

## Features:
## - Toggle playback for any active media player.
## - Skip to the next or previous track.
## - Control Spotify playback separately.

## Requirements:
## - `playerctl`: Used for media player control.

## Author: Pahasara Dewnith (https://github.com/Pahasara)

toggle_music() {
    player_status=$(playerctl status 2>/dev/null)
    if [ "$player_status" == "Playing" ]; then
        playerctl pause
    else
        playerctl play
    fi
}

previous_track() {
    spotify_status=$(playerctl --player=spotify status 2>/dev/null)
    if [ "$spotify_status" == "Playing" ]; then
        playerctl --player=spotify previous
    else
        playerctl previous
    fi
}

next_track() {
    spotify_status=$(playerctl --player=spotify status 2>/dev/null)
    if [ "$spotify_status" == "Playing" ]; then
        playerctl --player=spotify next
    else
        playerctl next
    fi
}

toggle_spotify() {
    spotify_status=$(playerctl --player=spotify status 2>/dev/null)
    if [ "$spotify_status" == "Playing" ]; then
        playerctl --player=spotify pause
    else
        playerctl --player=spotify play
    fi
}

toggle_play() {
    toggle_music
    toggle_spotify
}

usage() {
    echo "Usage: $0 {toggle_musikcube|previous_track|next_track|toggle_spotify|toggle_play}"
}

if [ $# -eq 0 ]; then
    usage
else
    case "$1" in
        previous_track) previous_track ;;
        next_track) next_track ;;
        toggle_play) toggle_play ;;
        *) usage ;;
    esac
fi
