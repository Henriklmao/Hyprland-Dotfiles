# Restic Backup Setup

Restic backup with local repository, systemd timer, and fish function.

## Prerequisites

- `restic` installed (`sudo pacman -S restic`)
- Target path accessible (local or mounted)

## Step 1: Generate Password

```bash
mkdir -p ~/.config/restic
chmod 700 ~/.config/restic
head -c 32 /dev/urandom | base64 > ~/.config/restic/password
chmod 600 ~/.config/restic/password
cat ~/.config/restic/password
# → Save this password somewhere safe!
```

## Step 2: Create Exclude File

```bash
cat > ~/.config/restic/excludes.txt << 'EOF'
.cache
.local
.thumbnails
*.tmp
*~
*.swp
EOF
chmod 600 ~/.config/restic/excludes.txt
```

## Step 3: Create Backup Script

```bash
cat > ~/.local/bin/backup-ssd.sh << 'SCRIPT'
#!/usr/bin/env bash
set -euo pipefail

# ─── CONFIGURE ────────────────────────────────────────────────
REPO="/path/to/repository"             # ← Change this
PASSWORD_FILE="$HOME/.config/restic/password"
EXCLUDES="$HOME/.config/restic/excludes.txt"
LOGFILE="$HOME/.local/log/backup-restic.log"
SOURCE="$HOME/"                        # ← Change source if needed
# ─────────────────────────────────────────────────────────────

export RESTIC_REPOSITORY="$REPO"
export RESTIC_PASSWORD_FILE="$PASSWORD_FILE"
export RESTIC_CACHE_DIR="$HOME/.cache/restic"
export DISPLAY="${DISPLAY:-:0}"
export DBUS_SESSION_BUS_ADDRESS="${DBUS_SESSION_BUS_ADDRESS:-unix:path=/run/user/$(id -u)/bus}"

notify() {
    command -v notify-send &>/dev/null && notify-send -u "$1" -i "drive-harddisk" "$2" "$3" 2>/dev/null || true
}

mkdir -p "$(dirname "$LOGFILE")" "$RESTIC_CACHE_DIR"
[[ -f "$LOGFILE" ]] && (( $(stat -c%s "$LOGFILE" 2>/dev/null || echo 0) > 5242880 )) && mv "$LOGFILE" "${LOGFILE}.$(date +%Y%m%d-%H%M%S).old"
exec > >(tee -a "$LOGFILE") 2>&1

echo "═══════════════════════════════════════════════════════════════"
echo "  Backup started: $(date '+%Y-%m-%d %H:%M:%S')"
echo "═══════════════════════════════════════════════════════════════"

notify "normal" "Backup" "Backup started..."

# Mount check (only for external targets)
# mountpoint -q /path/to/mount || { notify "critical" "Backup" "Mount missing!"; exit 1; }

# Initialize repository if needed
[[ ! -d "$REPO" ]] && restic init

# Backup
BACKUP_START=$(date +%s)
restic backup "$SOURCE" --exclude-file="$EXCLUDES" --compression=auto --tag "daily" --host="$(hostname)" || BACKUP_EXIT=$?
BACKUP_END=$(date +%s)
BACKUP_DURATION=$(( BACKUP_END - BACKUP_START ))

[[ "${BACKUP_EXIT:-0}" -eq 3 ]] && echo "⚠ Warnings (some files not readable)"
[[ "${BACKUP_EXIT:-0}" -gt 3 ]] && notify "critical" "Backup" "Failed!" && exit "${BACKUP_EXIT:-1}"

echo "✓ Backup: $(( BACKUP_DURATION / 60 ))m $(( BACKUP_DURATION % 60 ))s"

# Pruning
restic forget --keep-daily 7 --keep-weekly 4 --keep-monthly 6 --keep-yearly 2 --prune

# Snapshots
restic snapshots --latest 5

echo "═══════════════════════════════════════════════════════════════"
echo "  ✓ Done: $(date '+%Y-%m-%d %H:%M:%S')"
echo "═══════════════════════════════════════════════════════════════"

notify "normal" "Backup" "Done! ($(( BACKUP_DURATION / 60 ))m)"
SCRIPT

chmod +x ~/.local/bin/backup-ssd.sh
```

## Step 4: Fish Function

Note: A fish function already exists in this dotfiles repo.

```bash
cat > ~/.config/fish/functions/backup.fish << 'FISH'
function backup
    set -l REPO "/path/to/repository"   # ← Same as in the script
    set -l PW ~/.config/restic/password

    if test (count $argv) -eq 0
        backup-ssd
        return
    end

    switch $argv[1]
        case snap snapshots
            RESTIC_REPOSITORY=$REPO RESTIC_PASSWORD_FILE=$PW restic snapshots --latest 10
        case ls list
            RESTIC_REPOSITORY=$REPO RESTIC_PASSWORD_FILE=$PW restic snapshots
        case restore
            test (count $argv) -lt 2; and echo "Usage: backup restore <id>"; and return 1
            set -l target (test (count $argv) -ge 3; and echo $argv[3]; or echo /tmp/restore)
            RESTIC_REPOSITORY=$REPO RESTIC_PASSWORD_FILE=$PW restic restore $argv[2] --target $target
        case check
            RESTIC_REPOSITORY=$REPO RESTIC_PASSWORD_FILE=$PW restic check
        case size
            RESTIC_REPOSITORY=$REPO RESTIC_PASSWORD_FILE=$PW restic stats
        case unlock
            RESTIC_REPOSITORY=$REPO RESTIC_PASSWORD_FILE=$PW restic unlock
    end
end
FISH
```

## Step 5: Systemd Timer (optional)

> **Important:** Run the script directly, **not** via `tmux new-session -d`.
> tmux exits immediately (exit 0), systemd thinks "success" — but the actual
> backup inside tmux fails silently. The script already handles logging
> (`~/.local/log/backup-restic.log`) and desktop notifications, so tmux is unnecessary.

```bash
# Service
cat > ~/.config/systemd/user/backup.service << EOF
[Unit]
Description=Restic Backup
After=local-fs.target

[Service]
Type=oneshot
ExecStart=%h/.local/bin/backup-ssd.sh
TimeoutStartSec=7200
Nice=19
IOSchedulingClass=idle
EOF

# Timer
cat > ~/.config/systemd/user/backup.timer << EOF
[Unit]
Description=Backup – daily at 03:00

[Timer]
OnCalendar=*-*-* 03:00:00
Persistent=true
RandomizedDelaySec=300

[Install]
WantedBy=timers.target
EOF

# Enable
systemctl --user daemon-reload
systemctl --user enable --now backup.timer
systemctl --user list-timers | grep backup
```

### Debugging

```bash
# Check service status
systemctl --user status backup.service

# Logs from recent runs
journalctl --user -u backup.service --since "7 days ago"

# Test manually
systemctl --user start backup.service
```

## Usage

```bash
backup              # Start backup
backup snap         # Show last 10 snapshots
backup ls           # All snapshots
backup restore <id> # Restore snapshot
backup check        # Check repository
backup size         # Statistics
backup unlock       # Remove locks
```

## Restore

```bash
# Single file
RESTIC_REPOSITORY=/path/to/repo RESTIC_PASSWORD_FILE=~/.config/restic/password \
    restic latest --target /tmp/restore --include ".bashrc"

# Full restore
backup restore <snapshot-id> /tmp/restore
```
