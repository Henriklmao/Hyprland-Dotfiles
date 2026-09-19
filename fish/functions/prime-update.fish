function prime-update -d "Rebase opencode-fix onto main and rebuild prime-agent"
    if not test (hostname) = surfacebtw
        set repo_dir /mnt/ssd-vault/Projects/prime-agent
    else
        echo "This script is not intended to be run on Surface" >&2
        return 1
    end
    if not test -d "$repo_dir"
        echo "prime-agent repo not found at $repo_dir" >&2
        return 1
    end

    echo "==> Fetching latest from origin..."
    git -C "$repo_dir" fetch origin || begin
        echo "Failed to fetch from origin" >&2
        return 1
    end

    echo "==> Rebasing opencode-fix onto origin/main..."
    git -C "$repo_dir" checkout opencode-fix || begin
        echo "Failed to checkout opencode-fix" >&2
        return 1
    end

    git -C "$repo_dir" rebase origin/main
    set -l rebase_status $status
    if test $rebase_status -ne 0
        echo "ERROR: Merge conflict during rebase. Resolve manually:" >&2
        echo "  cd $repo_dir" >&2
        echo "  git status" >&2
        echo "  git rebase --abort  # to cancel" >&2
        return 1
    end

    echo "==> Rebuilding..."
    cd "$repo_dir" && bun run build && bun link prime-agent || begin
        echo "Build or link failed" >&2
        return 1
    end

    echo "==> Done! prime-agent updated and linked."
end
