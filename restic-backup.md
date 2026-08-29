# Restic Backup Setup

Restic-Backup mit lokalem Repository, Systemd-Timer und Fish-Funktion.

## Voraussetzungen

- `restic` installiert (`sudo pacman -S restic`)
- Ziel-Pfad erreichbar (lokal oder eingebunden)

## Schritt 1: Passwort generieren

```bash
mkdir -p ~/.config/restic
chmod 700 ~/.config/restic
head -c 32 /dev/urandom | base64 > ~/.config/restic/password
chmod 600 ~/.config/restic/password
cat ~/.config/restic/password
# → Passwort notieren!
```

## Schritt 2: Ausschlussdatei erstellen

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

## Schritt 3: Backup-Skript erstellen

```bash
cat > ~/.local/bin/backup-ssd.sh << 'SCRIPT'
#!/usr/bin/env bash
set -euo pipefail

# ─── ANPASSEN ─────────────────────────────────────────────────
REPO="/Pfad/zum/Repository"          # ← Hier ändern
PASSWORD_FILE="$HOME/.config/restic/password"
EXCLUDES="$HOME/.config/restic/excludes.txt"
LOGFILE="$HOME/.local/log/backup-restic.log"
SOURCE="$HOME/"                      # ← Quelle anpassen
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
echo "  Backup gestartet: $(date '+%Y-%m-%d %H:%M:%S')"
echo "═══════════════════════════════════════════════════════════════"

notify "normal" "Backup" "Backup gestartet..."

# Mount-Check (nur bei externen Zielen)
# mountpoint -q /Pfad/zum/Mount || { notify "critical" "Backup" "Mount fehlt!"; exit 1; }

# Repository initialisieren falls nötig
[[ ! -d "$REPO" ]] && restic init

# Backup
BACKUP_START=$(date +%s)
restic backup "$SOURCE" --exclude-file="$EXCLUDES" --compression=auto --tag "daily" --host="$(hostname)" || BACKUP_EXIT=$?
BACKUP_END=$(date +%s)
BACKUP_DURATION=$(( BACKUP_END - BACKUP_START ))

[[ "${BACKUP_EXIT:-0}" -eq 3 ]] && echo "⚠ Warnungen (Dateien nicht lesbar)"
[[ "${BACKUP_EXIT:-0}" -gt 3 ]] && notify "critical" "Backup" "Fehler!" && exit "${BACKUP_EXIT:-1}"

echo "✓ Backup: $(( BACKUP_DURATION / 60 ))m $(( BACKUP_DURATION % 60 ))s"

# Pruning
restic forget --keep-daily 7 --keep-weekly 4 --keep-monthly 6 --keep-yearly 2 --prune

# Snapshots
restic snapshots --latest 5

echo "═══════════════════════════════════════════════════════════════"
echo "  ✓ Fertig: $(date '+%Y-%m-%d %H:%M:%S')"
echo "═══════════════════════════════════════════════════════════════"

notify "normal" "Backup" "Fertig! ($(( BACKUP_DURATION / 60 ))m)"
SCRIPT

chmod +x ~/.local/bin/backup-ssd.sh
```

## Schritt 4: Beachte, es existiert bereits eine Fish-Funktion dank des Dotfile Repos

```bash
cat > ~/.config/fish/functions/backup.fish << 'FISH'
function backup
    set -l REPO "/Pfad/zum/Repository"   # ← Gleich wie im Skript
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

## Schritt 5: Systemd-Timer (optional)

```bash
# Service
cat > ~/.config/systemd/user/backup.service << EOF
[Unit]
Description=Restic Backup
After=local-fs.target

[Service]
Type=oneshot
ExecStart=/usr/bin/tmux new-session -d -s backup %h/.local/bin/backup-ssd.sh
TimeoutStartSec=7200
Nice=19
IOSchedulingClass=idle
EOF

# Timer
cat > ~/.config/systemd/user/backup.timer << EOF
[Unit]
Description=Backup – täglich 03:00

[Timer]
OnCalendar=*-*-* 03:00:00
Persistent=true
RandomizedDelaySec=300

[Install]
WantedBy=timers.target
EOF

# Aktivieren
systemctl --user daemon-reload
systemctl --user enable --now backup.timer
systemctl --user list-timers | grep backup
```

## Nutzung

```bash
backup              # Starte Backup
backup snap         # Zeige letzte 10 Snapshots
backup ls           # Alle Snapshots
backup restore <id> # Wiederherstellen
backup check        # Repository prüfen
backup size         # Statistiken
backup unlock       # Locks entfernen
```

## Restore

```bash
# Einzelne Datei
RESTIC_REPOSITORY=/Pfad/zum/Repo RESTIC_PASSWORD_FILE=~/.config/restic/password \
    restic latest --target /tmp/restore --include ".bashrc"

# Kompletter Restore
backup restore <snapshot-id> /tmp/restore
```
