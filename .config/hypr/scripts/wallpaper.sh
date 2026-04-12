#!/bin/bash

WALLPAPER="$1"
[ -z "$WALLPAPER" ] && exit 1

EXTENSION="${WALLPAPER##*.}"
EXTENSION="${EXTENSION,,}"

if [[ "$EXTENSION" == "gif" ]]; then
    TMPIMG="/tmp/wallpaper_frame.png"
    ffmpeg -y -i "$WALLPAPER" -vframes 1 "$TMPIMG" 2>/dev/null
    cp "$TMPIMG" /home/zishan/.cache/wallpaper-static.png
    swww img "$WALLPAPER" --transition-type fade --transition-duration 1
    matugen image "$TMPIMG"
else
    cp "$WALLPAPER" /home/zishan/.cache/wallpaper-static.png
    swww img "$WALLPAPER" --transition-type fade --transition-duration 1
    matugen image "$WALLPAPER"
fi

echo "$WALLPAPER" > /home/zishan/.cache/current-wallpaper
EOF
