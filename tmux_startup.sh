# Session Name
session="Dev"

# Start New session with our name
tmux new-session -d -s $session

tmux rename-window -t $session 'Main'

tmux split-window -h

tmux split-window -v

tmux send-keys -t 2 "cd ~/Development" Enter "clear" Enter

tmux send-keys -t 1 "cd ~/Development" Enter "clear" Enter

tmux send-keys -t 3 "cd" Enter "clear" Enter

tmux attach-session -t $session
