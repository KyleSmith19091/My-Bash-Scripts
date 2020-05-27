# Run with standard compiler or makefile
# Check if foo command exists on the system
use_figlet=true
! command -v figlet >/dev/null 2>&1 || use_figlet=false

function check_first_install(){
    if [ ! -d ~/.crun ]
    then
        echo "Creating crun directory"
        mkdir ~/.crun
        touch ~/.crun/crun_config.txt
        echo "Installed=true" >> ~/.crun/crun_config.txt
        cp run_c++.sh ~/.crun
        rm -f ./run_c++.sh
        if [ -f ~/.zshrc ]
        then 
            echo "alias crun=\"~/.crun/run_c++.sh\"" >> ~/.zshrc
        elif [ -f ~/.bashrc ]
        then 
            echo "alias crun=\"~/.crun/run_c++.sh\"" >> ~/.bashrc
        else 
            echo "Could not add command to rc file please add this manually"
        fi
        echo "Install Successful!"
        exit 0
    fi
}

function uninstall(){
    sudo -rf ~/.crun
    echo "Cleared Settings Directory"
    echo "Please remove command from .bashrc file"
    exit 0
}

function create_makefile(){
    if [ use_figlet = true ]
    then
        figlet "Creating makefile!"
    else
        echo "Creating makefile!"
    fi
    
    word=$2
    touch makefile
    echo "$word: $word.o" >> makefile
    echo "\tg++ -o $word $word.o" >> makefile
    echo "$word.o: $word.cpp" >> makefile 
    echo "\tg++ -c $word.cpp" >> makefile
    echo "run:" >> makefile
    echo "\t./$word" >> makefile
    echo "clean:" >> makefile
    echo "\trm *.o $word" >> makefile 

}

function run_makefile(){
 if [ use_figlet = true ]
    then  
        figlet "Make"
    else
        echo "Making Project"
    fi    
    if [ -f ".o" ] # Remove object files from current directory
    then 
        make clean
    fi    
    make
    make run   
}

function run_normal(){
if [ use_figlet = true ]
then     
    figlet "Run G++" # Prompt user
else
    echo "Run G++"
fi    
if [ -d "./src" ] # Check if src directory exists
then
    if [ -f "./src/*.cpp " ] 
    then 
        echo "No .cpp files found!"
        exit 1 
    fi    

    # Remove object file stuff from include directory
    rm -f ./include/*.hpp.gch

    # Run the g++ compiler
    g++ -Wall -std=c++17 -I ./include/* ./src/* 

    # Run the binary file
    ./a.out
else            # If there is no src directory then we are in the directory with .cpp file
    if [ ! -f "*.cpp" ]
    then 
        echo "No .cpp files found!"
        exit 1
    fi    

    if [ -z "$1" ] # Check if any arguments were set when running the command
    then     
         g++ -Wall -Werror -std=c++14 ./*.cpp -o main 
    else            # Run the compiler and link the spefied file
          g++ -Wall -Werror -std=c++14 -l$1 ./*.cpp -o main
    fi
    ./main # Run the binary file
fi
}

######################################################################################################################################

check_first_install
uninstall
if [ "$1" = '-uuu' ]
then 
    uninstall
fi    

if [ "$1" = '-m' ]   
then
    create_makefile
fi

if [ -f "makefile" ] # Check if user wants to use makefile for compilation
then
   run_makefile
else
    run_normal    
fi
