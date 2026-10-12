function prime-update -d "Rebase opencode-fix onto main, then rebuild and install prime-agent"
    if test (hostname) = surfacebtw
        echo "This script is not intended to be run on Surface" >&2
        return 1
    end

    set -l repo_dir /mnt/ssd-vault/Projects/prime-agent
    if set -q PRIME_AGENT_REPO
        set repo_dir $PRIME_AGENT_REPO
    end

    if not test -d "$repo_dir"
        echo "prime-agent repo not found at $repo_dir (set PRIME_AGENT_REPO to override)" >&2
        return 1
    end

    if not command -sq cargo
        echo "cargo not found on PATH (install Rust from https://rustup.rs)" >&2
        return 1
    end

    echo "==> Fetching latest from origin..."
    git -C "$repo_dir" fetch origin --prune || begin
        echo "Failed to fetch from origin" >&2
        return 1
    end

    echo "==> Rebasing opencode-fix onto origin/main..."
    git -C "$repo_dir" checkout opencode-fix || begin
        echo "Failed to checkout opencode-fix" >&2
        return 1
    end

    git -C "$repo_dir" rebase origin/main
    if test $status -ne 0
        echo "ERROR: Merge conflict during rebase. Resolve manually:" >&2
        echo "  cd $repo_dir" >&2
        echo "  git status" >&2
        echo "  git rebase --abort  # to cancel" >&2
        return 1
    end

    echo "==> Building and installing prime-agent (release)..."
    cargo install --path "$repo_dir/crates/pa-cli" --locked --force || begin
        echo "Build or install failed" >&2
        return 1
    end

    set -l installed (command -v prime-agent)
    if test -z "$installed"
        echo "prime-agent is not on PATH after install" >&2
        echo "Add ~/.cargo/bin to PATH (or run 'cargo install --path $repo_dir/crates/pa-cli --locked --force' manually)" >&2
        return 1
    end

    # The running daemon and its workers are separate processes that may be a
    # same-version binary from an older build (the managed install under
    # ~/.local/share/prime-agent/releases) — the TUI reuses a version-matching
    # daemon, so the rebuilt code would never run. Stop it; the next launch
    # spawns the daemon from this freshly installed binary.
    echo "==> Stopping any running daemon so the rebuilt binary takes over..."
    command prime-agent shutdown --force >/dev/null 2>&1

    echo "==> Done! prime-agent updated at $installed"
    prime-agent --version
end
