# Clear the screen
clear

# Print out the date using figlet
date +"%y%y/%m/%d" | figlet -c

# Ask the user to startup tmux
echo "Startup Tmux?"
read -p "> " op

if [ "$op" = 'y' ]
then
    echo "[] Running tmux!"
    ~/Development/Non_IDE_Projects/bash_scripts/My_bash_scripts/tmux_startup.sh
else
    echo "[] Starting Normal Terminal Session"
    echo "[] All Systems Good!"
fi
    




