session="Fun"

tmux new-session -d -s $session

tmux rename-window -t $session 'Main'

tmux split-window -h

tmux split-window -v

tmux send-keys -t 2 "Ranger" Enter

tmux send-keys -t 3 "gotop" Enter

tmux send-keys -t 1 "neofetch" Enter

tmux attach-session -t $session

