#!/bin/bash
source ~/.config/dunst/colors

# Remove old urgency sections if they exist
sed -i '/^\[urgency/,/^$/d' ~/.config/dunst/dunstrc

# Append fresh urgency sections with current colors
cat >> ~/.config/dunst/dunstrc << EOF

[urgency_low]
    background = "$BG"
    foreground = "$TEXT"
    frame_color = "$OUTLINE"
    timeout = 4

[urgency_normal]
    background = "$BG"
    foreground = "$TEXT"
    frame_color = "$PRIMARY"
    timeout = 6

[urgency_critical]
    background = "$BG"
    foreground = "$TEXT"
    frame_color = "$ERROR"
    timeout = 0
EOF

pkill dunst || true
sleep 0.2
dunst &
