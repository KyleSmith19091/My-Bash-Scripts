# Clear the terminal window
clear

# Read in a location from the user
read -p "Location > " loc
loc=${loc:-location}

figlet "$loc"

curl wttr.in/"$loc" -0
