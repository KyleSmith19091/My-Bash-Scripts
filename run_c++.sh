use_figlet=false
! command -v figlet >/dev/null 2>&1 || (use_figlet=true)
args1="$1" # Quick and dirty solution for some errors I have been having when providing args to the script
args2="$2"

# Install script that adds a config file and aliases the command to the user's rc file
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

# Script to remove the hidden directory with script and config file
# Two possible problems here: User moving the directory and not being able to remove the alias from the rc file
function uninstall(){
    sudo -rf ~/.crun
    echo "Cleared Settings Directory"
    echo "Please remove command from .bashrc file"
    exit 0
}

# Create a basic makefile with for functions: run clean 
function create_makefile(){
    if [ use_figlet = true ]
    then
        figlet "Creating makefile!"
    else
        echo "Creating makefile!"
    fi

    if [ -z "$args2" ]
    then 
        echo "Please enter a project name!"
        exit 1
    else
        touch ./makefile
        echo "$args2: $args2.o" >> ./makefile
        echo "\tg++ -o $args2 $args2.o" >> ./makefile 
        echo "$args2.o: $args2.cpp" >> ./makefile 
        echo "\tg++ -c $args2.cpp" >> ./makefile
        echo "run:" >> ./makefile
        echo "\t./$args2" >> ./makefile
        echo "clean:" >> ./makefile
        echo "\trm *.o $args2" >> ./makefile
    fi   
}

# Compile the project using the makefile method
function run_makefile(){
 if [ use_figlet = true ]
    then  
        figlet "Make"
    else
        echo "Making Project"
    fi   
    objfiles=ls -1 *.o 2>/dev/null | wc -l
    if [ "$objfiles" != 0 ] # Remove object files from current directory
    then 
        make clean
    fi
   
    count=ls -1 *.cpp 2>/dev/null | wc -l

    if [ "$count" != 0 ]
    then     
        make
        make run
    else
        echo "No .cpp files found!"
    fi
}

# Run using g++ compiler with the appropriate flags
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
    count=ls -1 *.cpp 2>/dev/null | wc -l
    if [ $count == 0 ]
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

function create_tar_file_no_text_file(){
    count=ls -1 *.cpp 2>/dev/null | wc -l
    
    if [ $count != 0 ]
    then 
        tar -cf "$args2".tar *.cpp makefile 
    else
        echo "No .cpp files found to compress!"
    fi    
    
    exit 0
}

function create_tar_file_with_text_file(){
    count=ls -1 *.cpp 2>/dev/null | wc -l
    
    if [ $count != 0 ]
    then 
        tar -cf "$args2".tar *.cpp makefile *.txt
    else
        echo "No .cpp files found to compress!"
    fi    

    exit 0
}

######################################################################################################################################
if [ "$1" = 'install' ] 
then 
    check_first_install
elif [ "$1" = '-uuu' ]
then
    uninstall
elif [ "$1" = '-m' ]
then 
    create_makefile
elif [ "$1" = '-c' ]
then 
    create_tar_file_no_text_file
elif [ "$1" = '-ct' ]
then    
    create_tar_file_with_text_file
fi 

presCount=ls -1 *.cpp 2>/dev/null | wc -l

if [ "$presCount" != 0 ]
then
    if [ -f "makefile" ] # Check if user wants to use makefile for compilation
    then   
        run_makefile
    else
        run_normal    
    fi
else
    echo "No .cpp files found!"
fi    


