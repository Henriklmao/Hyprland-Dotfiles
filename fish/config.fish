if status is-interactive
    # Commands to run in interactive sessions can go here
    set -x EDITOR nvim
    alias vi="nvim"
    alias vim="nvim"
    alias cop="copilot"
    alias oc="opencode"
    alias e="nautilus ."
    alias se="sudoedit"
    alias chx="sudo chmod +x"
    alias prev="bun run build && bun run preview --open"
    alias pretty="npx prettier --write \"**/*.{js,jsx,ts,tsx,json,css,scss,md,mdx,html,yml,yaml,svelte}\" --ignore-path .gitignore"
    alias watch60="watch -n 60 -t"
    alias lg="lazygit"
    alias reflect="sudo reflector --country Germany --latest 20 --protocol https --sort rate --save /etc/pacman.d/mirrorlist"
    # Servers
    alias indigo="ssh root@87.106.191.54"
    alias vps="ssh root@217.154.224.224"
    # Bun
    set -x BUN_INSTALL "$HOME/.bun"
    set -x PATH "$BUN_INSTALL/bin:$PATH"
    # Cargo
    set -gx PATH $HOME/.cargo/bin $PATH

end

# FRITZ!Box WireGuard Toggle
function fritz
    # Überprüfen, ob das Interface 'fritz' bereits existiert
    if ip link show fritz >/dev/null 2>&1
        echo "Disconnect FRITZ@Home VPN... "
        sudo wg-quick down fritz
    else
        echo "Connect FRITZ@Home VPN via WireGuard..."
        sudo wg-quick up fritz
    end
end
function vi
    set session_name (basename (pwd))
    tmux new-session -A -c (pwd) -s "$session_name" nvim -c Explore
end

# Created by `pipx` on 2026-03-31 14:21:26
set PATH $PATH /home/henrik/.local/bin
# starship
source (/usr/bin/starship init fish --print-full-init | psub)
# =============================================================================
#
# Utility functions for zoxide.
#

# pwd based on the value of _ZO_RESOLVE_SYMLINKS.
function __zoxide_pwd
    builtin pwd -L
end

# A copy of fish's internal cd function. This makes it possible to use
# `alias cd=z` without causing an infinite loop.
if ! builtin functions --query __zoxide_cd_internal
    if status list-files functions/cd.fish &>/dev/null
        status get-file functions/cd.fish | string replace --regex -- '^function cd\s' 'function __zoxide_cd_internal ' | source
    else
        string replace --regex -- '^function cd\s' 'function __zoxide_cd_internal ' <$__fish_data_dir/functions/cd.fish | source
    end
end

# cd + custom logic based on the value of _ZO_ECHO.
function __zoxide_cd
    if set -q __zoxide_loop
        builtin echo "zoxide: infinite loop detected"
        builtin echo "Avoid aliasing `cd` to `z` directly, use `zoxide init --cmd=cd fish` instead"
        return 1
    end
    __zoxide_loop=1 __zoxide_cd_internal $argv
end

# =============================================================================
#
# Hook configuration for zoxide.
#

# Initialize hook to add new entries to the database.
function __zoxide_hook --on-variable PWD
    test -z "$fish_private_mode"
    and command zoxide add -- (__zoxide_pwd)
end

# =============================================================================
#
# When using zoxide with --no-cmd, alias these internal functions as desired.
#

# Jump to a directory using only keywords.
function __zoxide_z
    set -l argc (builtin count $argv)
    if test $argc -eq 0
        __zoxide_cd $HOME
    else if test "$argv" = -
        __zoxide_cd -
    else if test $argc -eq 1 -a -d $argv[1]
        __zoxide_cd $argv[1]
    else if test $argc -eq 2 -a $argv[1] = --
        __zoxide_cd -- $argv[2]
    else
        set -l result (command zoxide query --exclude (__zoxide_pwd) -- $argv)
        and __zoxide_cd $result
    end
end

# Completions.
function __zoxide_z_complete
    set -l tokens (builtin commandline --current-process --tokenize)
    set -l curr_tokens (builtin commandline --cut-at-cursor --current-process --tokenize)

    if test (builtin count $tokens) -le 2 -a (builtin count $curr_tokens) -eq 1
        # If there are < 2 arguments, use `cd` completions.
        complete --do-complete "'' "(builtin commandline --cut-at-cursor --current-token) | string match --regex -- '.*/$'
    else if test (builtin count $tokens) -eq (builtin count $curr_tokens)
        # If the last argument is empty, use interactive selection.
        set -l query $tokens[2..-1]
        set -l result (command zoxide query --exclude (__zoxide_pwd) --interactive -- $query)
        and __zoxide_cd $result
        and builtin commandline --function cancel-commandline repaint
    end
end
complete --command __zoxide_z --no-files --arguments '(__zoxide_z_complete)'

# Jump to a directory using interactive search.
function __zoxide_zi
    set -l result (command zoxide query --interactive -- $argv)
    and __zoxide_cd $result
end
# tirith
tirith init --shell fish | source
# =============================================================================
#
# Commands for zoxide. Disable these using --no-cmd.
#

abbr --erase z &>/dev/null
complete --erase --command z
alias z=__zoxide_z

abbr --erase zi &>/dev/null
complete --erase --command zi
alias zi=__zoxide_zi

# =============================================================================
