#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
THUMB_DIR="$HOME/.cache/wallpaper-thumbs"

# Create thumbnail directory
mkdir -p "$THUMB_DIR"

# Generate thumbnails for all wallpapers
find "$WALLPAPER_DIR" -type f \( \
    -iname "*.jpg" -o -iname "*.jpeg" -o \
    -iname "*.png" -o -iname "*.gif" -o \
    -iname "*.webp" \) | while read -r file; do
    
    # Create a unique thumbnail name based on file path
    THUMB_NAME=$(echo "$file" | md5sum | cut -d' ' -f1).png
    THUMB_PATH="$THUMB_DIR/$THUMB_NAME"
    
    # Generate thumbnail if it doesn't exist
    if [ ! -f "$THUMB_PATH" ]; then
        if [[ "${file,,}" == *.gif ]]; then
            ffmpeg -y -i "$file" -vframes 1 -vf "scale=200:-1" "$THUMB_PATH" 2>/dev/null
        else
            ffmpeg -y -i "$file" -vf "scale=200:-1" "$THUMB_PATH" 2>/dev/null
        fi
    fi
done

# Build rofi input with icon paths
SELECTED=$(find "$WALLPAPER_DIR" -type f \( \
    -iname "*.jpg" -o -iname "*.jpeg" -o \
    -iname "*.png" -o -iname "*.gif" -o \
    -iname "*.webp" \) | sort | while read -r file; do
    
    THUMB_NAME=$(echo "$file" | md5sum | cut -d' ' -f1).png
    THUMB_PATH="$THUMB_DIR/$THUMB_NAME"
    DISPLAY_NAME=$(basename "$file")
    
    echo -en "$DISPLAY_NAME\x00icon\x1f$THUMB_PATH\n"
done | rofi -dmenu \
    -p "Wallpaper" \
    -theme "~/.config/rofi/theme.rasi" \
    -show-icons \
    -i)

[ -z "$SELECTED" ] && exit 0

# Find the full path from the selected filename
WALLPAPER=$(find "$WALLPAPER_DIR" -name "$SELECTED" | head -1)
[ -z "$WALLPAPER" ] && exit 0

~/.config/hypr/scripts/wallpaper.sh "$WALLPAPER"
