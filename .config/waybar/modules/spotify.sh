#!/bin/sh

class=$(playerctl metadata --player=spotify --format '{{lc(status)}}')
icon=" "

if [[ $class == "playing" ]]; then
  info=$(playerctl metadata --player=spotify --format '{{artist}} - {{title}}')
  
  # Check if the info length exceeds 28 characters
  if (( ${#info} > 28 )); then
    # Trim info to 28 characters and add ".."
    info="${info:0:28}.."
  fi

  text="$icon $info"
elif [[ $class == "paused" ]]; then
  text="$icon"
else
  text=""
fi

echo -e "{\"text\":\"$text\", \"class\":\"$class\"}"
