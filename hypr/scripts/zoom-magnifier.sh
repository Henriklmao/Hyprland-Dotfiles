#!/bin/bash
# Screen Magnifier Script for Hyprland
# Manages zoom in/out with Super+Ctrl+Plus and Super+Ctrl+Minus

ZOOM_FILE="/tmp/hyprland_zoom_level"

# Initialize zoom level if not exists
if [ ! -f "$ZOOM_FILE" ]; then
    echo "10" > "$ZOOM_FILE"  # Using integer steps: 10 = 1.0x
fi

CURRENT=$(cat "$ZOOM_FILE")

case "$1" in
    "in")
        # Add 1 step (0.1x)
        NEW=$((CURRENT + 1))
        # Cap max zoom at 30 (3.0x)
        [ $NEW -gt 30 ] && NEW=30
        ;;
    "out")
        # Subtract 1 step (0.1x)
        NEW=$((CURRENT - 1))
        # Cap min zoom at 10 (1.0x = no zoom)
        [ $NEW -lt 10 ] && NEW=10
        ;;
    "reset")
        NEW=10
        ;;
    *)
        echo "Usage: $0 {in|out|reset}"
        exit 1
        ;;
esac

echo "$NEW" > "$ZOOM_FILE"

# Convert to decimal: 10 -> 1.0, 11 -> 1.1, 12 -> 1.2, etc.
ZOOM_DECIMAL=$(awk "BEGIN {printf \"%.1f\", $NEW/10}")

# Apply zoom using hyprctl
hyprctl --batch "keyword cursor:zoom_factor $ZOOM_DECIMAL"

# Send notification
notify-send "🔍 Zoom: ${ZOOM_DECIMAL}x" --expire-time=800 2>/dev/null || true

