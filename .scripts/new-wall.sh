#!/bin/bash

nbg=$(ls -d ~/Pictures/Wallpapers/* | shuf -n 1)
wal -ni $nbg
swaybg -m fill -i "$nbg"
