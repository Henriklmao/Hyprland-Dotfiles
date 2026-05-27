#!/bin/bash
# Simple zoom script for Hyprland
# Works with repeatbind for continuous scrolling

ZOOM_FILE="/tmp/hyprland_zoom_level"
ZOOM_MIN=10   # 1.0x
ZOOM_MAX=30   # 3.0x
ZOOM_STEP=1   # 0.1x

[ -f "$ZOOM_FILE" ] || echo "10" > "$ZOOM_FILE"

CURRENT=$(cat "$ZOOM_FILE")

case "$1" in
    in)
        NEW=$((CURRENT + ZOOM_STEP))
        [ $NEW -gt $ZOOM_MAX ] && NEW=$ZOOM_MAX
        ;;
    out)
        NEW=$((CURRENT - ZOOM_STEP))
        [ $NEW -lt $ZOOM_MIN ] && NEW=$ZOOM_MIN
        ;;
    *)
        echo "Usage: $0 {in|out}"
        exit 1
        ;;
esac

echo "$NEW" > "$ZOOM_FILE"
ZOOM_DECIMAL=$(awk "BEGIN {printf \"%.1f\", $NEW/10}")

# Apply zoom
hyprctl keyword cursor:zoom_factor "$ZOOM_DECIMAL" 2>/dev/null

# Optional notification
notify-send "🔍 ${ZOOM_DECIMAL}x" --expire-time=300 2>/dev/null
