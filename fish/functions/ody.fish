function ody --description 'Starts or attaches odysseus server in a tmux session.'
    if ss -tulpn 2>/dev/null | grep -q ":7000 "
        if tmux has-session -t odysseus 2>/dev/null
            tmux attach-session -t odysseus
        else
            echo "Port 7000 is in use with no tmux session found."
            echo "kill with 'fuser -k 7000/tcp'"
        end
        return 0
    end

    set -l cmd "source venv/bin/activate.fish && python -m uvicorn app:app --host 0.0.0.0 --port 7000; bash"

    if set -q TMUX
        tmux new-window -c ~/odysseus/ -n odysseus $cmd
    else
        tmux new-session -d -s odysseus -c ~/odysseus/ -n server $cmd
        tmux attach-session -t odysseus
    end
end
