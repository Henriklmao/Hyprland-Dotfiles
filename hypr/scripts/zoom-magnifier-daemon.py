#!/usr/bin/env python3
"""
Hyprland Screen Magnifier Daemon
Hold Super+Ctrl+Shift+= (which produces +) to zoom in
Hold Super+Ctrl+- to zoom out
"""

import time
import subprocess
import threading
from pathlib import Path
from pynput import keyboard

ZOOM_FILE = Path("/tmp/hyprland_zoom_level")
ZOOM_MIN = 10  # 1.0x
ZOOM_MAX = 30  # 3.0x
ZOOM_STEP = 1  # 0.1x per step

if not ZOOM_FILE.exists():
    ZOOM_FILE.write_text("10")

keys_pressed = set()
daemon_running = True


def apply_zoom(level):
    """Apply zoom level to Hyprland"""
    level = max(ZOOM_MIN, min(ZOOM_MAX, level))
    ZOOM_FILE.write_text(str(level))
    
    zoom_decimal = level / 10.0
    try:
        subprocess.run(
            ["hyprctl", "keyword", "cursor:zoom_factor", str(zoom_decimal)],
            capture_output=True,
            timeout=1
        )
    except:
        pass
    
    try:
        subprocess.Popen(
            ["notify-send", f"🔍 {zoom_decimal:.1f}x", "--expire-time=300"],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL
        )
    except:
        pass


def zoom_thread():
    """Background thread for continuous zooming"""
    global daemon_running
    last_zoom_time = 0
    
    while daemon_running:
        # Check modifiers
        super_held = keyboard.Key.cmd in keys_pressed or keyboard.Key.cmd_r in keys_pressed
        ctrl_held = keyboard.Key.ctrl in keys_pressed or keyboard.Key.ctrl_r in keys_pressed
        
        # Check character keys
        plus_held = '+' in keys_pressed
        minus_held = '-' in keys_pressed
        
        if super_held and ctrl_held:
            current_time = time.time()
            current = int(ZOOM_FILE.read_text().strip())
            
            if plus_held and (current_time - last_zoom_time) > 0.05:
                new_level = min(current + ZOOM_STEP, ZOOM_MAX)
                apply_zoom(new_level)
                last_zoom_time = current_time
            elif minus_held and (current_time - last_zoom_time) > 0.05:
                new_level = max(current - ZOOM_STEP, ZOOM_MIN)
                apply_zoom(new_level)
                last_zoom_time = current_time
        
        time.sleep(0.01)


def on_press(key):
    """Handle key press"""
    try:
        # Add special keys
        if key in [keyboard.Key.cmd, keyboard.Key.cmd_r, keyboard.Key.ctrl, keyboard.Key.ctrl_r]:
            keys_pressed.add(key)
        # Add character keys
        elif hasattr(key, 'char'):
            keys_pressed.add(key.char)
    except:
        pass


def on_release(key):
    """Handle key release"""
    global daemon_running
    
    try:
        # Remove special keys
        if key in [keyboard.Key.cmd, keyboard.Key.cmd_r, keyboard.Key.ctrl, keyboard.Key.ctrl_r]:
            keys_pressed.discard(key)
        # Remove character keys
        elif hasattr(key, 'char'):
            keys_pressed.discard(key.char)
        
        # ESC to exit
        if key == keyboard.Key.esc:
            daemon_running = False
            return False
    except:
        pass


def main():
    """Main daemon loop"""
    print("🔍 Hyprland Zoom Daemon started")
    print("Hold Super+Ctrl+Shift+= (for +) to zoom in")
    print("Hold Super+Ctrl+- to zoom out")
    print("Press ESC to exit")
    
    zoom_t = threading.Thread(target=zoom_thread, daemon=True)
    zoom_t.start()
    
    with keyboard.Listener(on_press=on_press, on_release=on_release) as listener:
        listener.join()
    
    print("🔍 Daemon stopped")


if __name__ == "__main__":
    main()
