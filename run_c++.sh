use_figlet=true
! command -v figlet >/dev/null 2>&1 || (use_figlet=false)
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
    if [ "$use_figlet" = true ]
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
 if [ "$use_figlet" = true ]
    then  
        figlet "Make"
    else
        echo "Making Project"
    fi   
    objfiles=ls -1 *.o 2>/dev/null | wc -l
    if [ "$objfiles" != 0 ] # Remove object files from current directory
    then 
        make clean &>/dev/null
        echo "Cleaning Object Files!"
    fi
   
    make
    make run
}

# Run using g++ compiler with the appropriate flags
function run_normal(){
if [ "$use_figlet" = true ]
then     
    figlet "Run G++" # Prompt user
else
    echo "Run G++"
fi    
if [ -d ./src ] # Check if src directory exists
then
        
    # Remove object file stuff from include directory
    rm -f ./include/*.hpp.gch

    # Run the g++ compiler
    g++ -Wall -std=c++17 -I ./include/* ./src/* 

    # Run the binary file
    ./a.out
else            # If there is no src directory then we are in the directory with .cpp file
    count=ls -1 *.cpp 2>/dev/null | wc -l
    if [ "$count" == 0 ]
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

function setup_project(){

    if [ -d ./src/ ]
    then 
        echo "I have detected a source directory!"
        src=$(pwd)/src   # Save the path to the source directory 
    else
        echo "No source directory"
        subdircount=`find ./ -maxdepth 1 -type d | wc -l`
        if [ $subdircount -gt 2 ]
        then
            echo "I do detect the following child directories"
            ls -d */
            echo "Do you wish to set any of the above directories as the src directory?"
            read -p "> " src
            src=${src}
            found=`find "$src" -maxdepth 1 -type d 2>/dev/null | wc -l`
            if [ "$found" != 0 ]
            then
                echo "Found the directory!"
            else
                echo "Directory Not Found!"
                exit 1
            fi    
        else
            exit 1
        fi    
    fi    
    
    if [ -d ./include/ ]
    then
        echo "I have detected an include directory"
        echo "Project Setup Completed"
        echo "Please run again to execute" 
        include=$(pwd)/include  # Save the path to the source directory
        exit 0
        echo "EXIT"
    else
        echo "No include directory detected"
        subdircount=`find ./ -maxdepth 1 -type d | wc -l`
        if [ $subdircount -gt 2 ]
        then
            echo "Set the one of the below directories as the include directory?"
            ls -d */
            read -p "> " include
            include=${include}
            found=`find "$include" -maxdepth 1 -type d 2>/dev/null | wc -l`
            if [ "$found" != 0 ]
            then
                echo "Found the specified directory!"
                echo "Project Setup Completed!"
            else
                echo "Directory Not Found!"
            fi    

        fi    
        exit 1
    fi
}

function run_project(){
   
    if [ "$figlet" = true ]
    then
        figlet "Project Run"
    else
        echo "Project Run"
    fi
    
    g++ -std=c++17 -Wall -Werror -I ./include/ ./src/*.cpp 

    ./a.out
        
}




function create_tar_file_no_text_file(){
    count=ls -1 ./*.cpp 2>/dev/null | wc -l
    
    if [ "$count" != 0 ]
    then 
        tar -cf "$args2".tar *.cpp makefile 
    else
        echo "No .cpp files found to compress!"
    fi    
    
    exit 0
}

function create_tar_file_with_text_file(){
    count=ls -1 *.cpp 2>/dev/null | wc -l
    tar -cf "$args2".tar *.cpp makefile *.txt
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
elif [ "$1" = '-p' ]
then
    setup_project
fi 

count=`ls -1 *.cpp 2>/dev/null | wc -l`

if [ $count != 0 ]
then
    if [ -f "makefile" ] # Check if user wants to use makefile for compilation
    then   
        run_makefile
    else
        run_normal    
    fi
elif [ $count == 0 ]
then 
    run_project
fi    


