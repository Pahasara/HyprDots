#!/bin/sh

class=$(playerctl metadata --player=spotify --format '{{lc(status)}}')
icon=" "

if [[ $class == "playing" ]]; then
  info=$(playerctl metadata --player=spotify --format '{{artist}} - {{title}}')
  # Check if title length exceeds 28 characters
  if [[ ${#info} -gt 28 ]]; then
    # Trim title to 28 characters and add "..."
    trimmed_title="${info:0:28}.."
  else
    # Keep full title if less than or equal to 28 characters
    trimmed_title="$info"
  fi
  text="$icon  $trimmed_title"
elif [[ $class == "paused" ]]; then
  text="$icon"
elif [[ $class == "stopped" ]]; then
  text=""
fi

echo -e "{\"text\":\""$text"\", \"class\":\""$class"\"}"
