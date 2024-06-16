#!/bin/bash

wall=$(find ~/Pictures/Wallpapers/ -type f -name "*.jpg" -o -name "*.png" | shuf -n 1)

swaybg -m fill -i $wall
