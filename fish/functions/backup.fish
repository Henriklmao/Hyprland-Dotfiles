function backup
    set -l REPO (test (hostname) = surfacebtw; and echo /mnt/Massenspeicher/restic-repo; or echo /mnt/ssd-vault/restic-repo)
    set -l PW ~/.config/restic/password

    if test (count $argv) -eq 0
        backup-ssd
        return
    end

    switch $argv[1]
        case snap snaps snapshots
            RESTIC_REPOSITORY=$REPO RESTIC_PASSWORD_FILE=$PW restic snapshots --latest 10
        case ls list
            RESTIC_REPOSITORY=$REPO RESTIC_PASSWORD_FILE=$PW restic snapshots
        case restore
            test (count $argv) -lt 2; and echo "Usage: backup restore <id> [target]"; and return 1
            set -l target (test (count $argv) -ge 3; and echo $argv[3]; or echo /tmp/restore)
            RESTIC_REPOSITORY=$REPO RESTIC_PASSWORD_FILE=$PW restic restore $argv[2] --target $target
            echo "✓ Restore nach $target"
        case check
            RESTIC_REPOSITORY=$REPO RESTIC_PASSWORD_FILE=$PW restic check
        case diff
            test (count $argv) -lt 2; and echo "Usage: backup diff <id>"; and return 1
            RESTIC_REPOSITORY=$REPO RESTIC_PASSWORD_FILE=$PW restic diff $argv[2]
        case unlock
            RESTIC_REPOSITORY=$REPO RESTIC_PASSWORD_FILE=$PW restic unlock
        case size
            RESTIC_REPOSITORY=$REPO RESTIC_PASSWORD_FILE=$PW restic stats
        case help '*'
            echo "backup          - Starte Backup"
            echo "backup snap     - Letzte 10 Snapshots"
            echo "backup ls       - Alle Snapshots"
            echo "backup restore  - Snapshot wiederherstellen"
            echo "backup check    - Repository prüfen"
            echo "backup diff     - Änderungen anzeigen"
            echo "backup unlock   - Locks entfernen"
            echo "backup size     - Statistiken"
    end
end
