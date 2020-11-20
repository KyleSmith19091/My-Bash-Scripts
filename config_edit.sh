# Script -> Quick way to open a specified config file
# Step 1. Use the default parameter variables ->> $1 $2 etc.
# Step 2. Evaluate the string that was passed
# Step 3. Change to the appropriate dir
# Step 4. Open nvim to edit specified config file
function cd {
    builtin cd "$@"
}

if [ $1 = 'neofetch' ]
then
    nvim ~/.config/neofetch/config.conf
elif [ $1 = 'nvim' ]
then
    nvim ~/.config/nvim/init.vim
elif [ $1 = 'ranger' ]
then
   nvim ~/.config/ranger/rc.conf 
elif [ $1 = 'tmux' ]
then 
   nvim ~/.config/tmux/.tmux.conf 
elif [ $1 = 'zsh' ]
then 
    nvim ~/.zshrc
elif [ $1 = 'vim' ]
then
    nvim ~/.config/nvim/init.vim 
elif [ $1 = 'config' ]
then 
    echo "cd /Users/kylesmith/.config"
elif [ $1 = 'alacritty' ]
then 
    nvim ~/.config/alacritty/alacritty.yml
elif [ $1 = 'kitty' ]
then
    nvim ~/.config/kitty/kitty.conf
elif [ $1 = 'hammerspoon' ] 
then
    nvim ~/.hammerspoon/init.lua
else
   echo "Please enter valid config file name" 
fi    


