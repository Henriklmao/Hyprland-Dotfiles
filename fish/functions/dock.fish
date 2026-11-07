function dock --description 'Start, stop, restart and inspect configured Docker containers'
    # Containers started by `dock` without arguments.
    #
    # Either edit this array directly, or use the array helper:
    #   dock add myapp other
    #   dock remove myapp
    #   dock list
    #
    # The helpers persist to the fish universal array DOCK_CONTAINERS:
    #   set -U DOCK_CONTAINERS searxng myapp
    set -l default_containers searxng

    set -l containers $default_containers
    if set -q DOCK_CONTAINERS
        set containers $DOCK_CONTAINERS
    end

    # First argument may be a subcommand; everything else is a container name.
    set -l cmd start
    set -l targets $argv
    if test (count $argv) -gt 0
        switch $argv[1]
            case start stop restart status logs add remove rm list ls help -h --help
                set cmd $argv[1]
                set targets $argv[2..-1]
        end
    end

    if contains -- $cmd help -h --help
        echo "Usage: dock [start|stop|restart|status|logs|add|remove|list] [container...]"
        echo
        echo "Without arguments, starts: $containers"
        echo
        echo "Examples:"
        echo "  dock                    # start configured containers"
        echo "  dock status             # show their state"
        echo "  dock stop               # stop configured containers"
        echo "  dock logs searxng       # follow logs of one container"
        echo "  dock start myapp        # start any container ad hoc"
        echo "  dock add myapp          # persist myapp in DOCK_CONTAINERS"
        echo "  dock remove myapp       # remove it from DOCK_CONTAINERS"
        echo "  dock list               # show configured containers"
        echo
        echo "The container list is the fish array DOCK_CONTAINERS:"
        echo "  set -Ua DOCK_CONTAINERS another"
        return 0
    end

    switch $cmd
        case add
            if test (count $targets) -eq 0
                echo "Usage: dock add <container...>" >&2
                return 1
            end
            set -l current $containers
            for name in $targets
                if not contains -- $name $current
                    set -a current $name
                end
            end
            set -U DOCK_CONTAINERS $current
            echo "✓ added: $targets"
            echo "  DOCK_CONTAINERS: $current"
            return 0
        case remove rm
            if test (count $targets) -eq 0
                echo "Usage: dock remove <container...>" >&2
                return 1
            end
            set -l current $containers
            for name in $targets
                if contains -- $name $current
                    set current (string match -v -- $name $current)
                else
                    echo "dock: $name is not configured" >&2
                end
            end
            set -U DOCK_CONTAINERS $current
            echo "✓ DOCK_CONTAINERS: $current"
            return 0
        case list ls
            if test (count $containers) -eq 0
                echo "dock: no containers configured" >&2
                return 1
            end
            printf '%s\n' $containers
            return 0
    end

    # `logs` needs an explicit container; it must not fall back to the defaults.
    if test "$cmd" = logs
        if test (count $targets) -ne 1
            echo "Usage: dock logs <container>" >&2
            return 1
        end
    end

    if test (count $targets) -eq 0
        set targets $containers
    end

    if test (count $targets) -eq 0
        echo "dock: no containers configured (try: dock add <name>)" >&2
        return 1
    end

    if not command -sq docker
        echo "dock: docker not found on PATH" >&2
        return 1
    end

    # Docker access without a docker-group membership: only use sudo when needed.
    set -l docker docker
    if not docker info >/dev/null 2>&1
        if not command -sq sudo
            echo "dock: no access to the Docker socket and sudo is unavailable" >&2
            return 1
        end
        set docker sudo docker
    end

    if not $docker info >/dev/null 2>&1
        echo "dock: cannot reach the Docker daemon" >&2
        return 1
    end

    set -l failed 0

    if test "$cmd" = status
        set -l existing
        for container in $targets
            if $docker container inspect $container >/dev/null 2>&1
                set -a existing $container
            else
                echo "✗ $container: container not found" >&2
                set failed 1
            end
        end
        if test (count $existing) -gt 0
            set -l filters
            for name in $existing
                set -a filters --filter "name=^$name\$"
            end
            $docker ps -a $filters --format 'table {{.Names}}\t{{.State}}\t{{.Status}}\t{{.Ports}}'
        end
        return $failed
    end

    if test "$cmd" = logs
        if not $docker container inspect $targets[1] >/dev/null 2>&1
            echo "✗ $targets[1]: container not found" >&2
            return 1
        end
        $docker logs -f --tail 100 $targets[1]
        return $status
    end

    for container in $targets
        if not $docker container inspect $container >/dev/null 2>&1
            echo "✗ $container: container not found" >&2
            set failed 1
            continue
        end

        set -l action_ok 0
        switch $cmd
            case start
                $docker start $container >/dev/null 2>&1
                set action_ok $status
            case stop
                $docker stop $container >/dev/null 2>&1
                set action_ok $status
            case restart
                $docker restart $container >/dev/null 2>&1
                set action_ok $status
        end

        if test $action_ok -eq 0
            set -l state ($docker inspect --format '{{.State.Status}}' $container)
            echo "✓ $container: $state"
        else
            echo "✗ $container: $cmd failed" >&2
            set failed 1
        end
    end

    return $failed
end
