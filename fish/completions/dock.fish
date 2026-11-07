# Completions for the `dock` function.

function __fish_dock_containers --description 'List containers configured for dock'
    if set -q DOCK_CONTAINERS
        printf '%s\n' $DOCK_CONTAINERS
    else
        printf '%s\n' searxng
    end
    # Add currently visible containers when Docker is reachable without sudo.
    docker ps -a --format '{{.Names}}' 2>/dev/null
end

complete -c dock -f
complete -c dock -n '__fish_use_subcommand' -a start -d 'Start containers'
complete -c dock -n '__fish_use_subcommand' -a stop -d 'Stop containers'
complete -c dock -n '__fish_use_subcommand' -a restart -d 'Restart containers'
complete -c dock -n '__fish_use_subcommand' -a status -d 'Show container state'
complete -c dock -n '__fish_use_subcommand' -a logs -d 'Follow container logs'
complete -c dock -n '__fish_use_subcommand' -a add -d 'Add container to DOCK_CONTAINERS'
complete -c dock -n '__fish_use_subcommand' -a remove -d 'Remove container from DOCK_CONTAINERS'
complete -c dock -n '__fish_use_subcommand' -a list -d 'List configured containers'
complete -c dock -n '__fish_use_subcommand' -a help -d 'Show help'

complete -c dock -n 'not __fish_seen_subcommand_from help' -a '(__fish_dock_containers | sort -u)' -d 'Container'
