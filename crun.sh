#Variables
use_figlet=false
args=$1
args2=$2
##############################################################################################
function installcrun(){
    echo "Here" 
    # Check if figlet is installed   
    ! command -v cmatrix &>/dev/null || use_figlet=true
    
    # Prompt to user
    if [ $use_figlet=true ]
    then
        figlet "Figlet Running!"
    fi

    # Create a crun directory in the HOME directory of the user's device
    echo "Creating crun directory in $HOME"
    mkdir $HOME/.crun
    touch $HOME/.crun/.crun_config.txt
    echo "Installed=true" >> $HOME/.crun/.crun_config.txt

    # Move the script from the current directory and store in the crun directory
    cp crun.sh $HOME/.crun
    rm -f ./crun.sh

    # Look for a .rc file in the HOME directory
    if [ -f $HOME/.zshrc ]
    then 
        echo "alias crun=\"$HOME/.crun/crun.sh\"" >> $HOME/.zshrc
    elif [ -f $HOME/.bashrc ]
    then    
        echo "alias crun=\$HOME/.crun/crun.sh\"" >> $HOME./bashrc
    else
        echo "Could not find a rc file for aliasing the command"
        echo "Install failed"
        rm -rf $HOME/.crun/
        exit 1
    fi 

    echo "Installed Successfully!"
    exit 0

}

function check_first_install(){
    if [ ! -d $HOME/.crun ]
    then
        echo "INSTALLING CRUN!"
        installcrun
    fi    
}

function uninstall(){
    sudo -rf $HOME/.crun/
    echo "Cleared the crun directory"
    echo "Removed the crun script"
    echo "Removed the crun config file"
    exit 0
}
##############################################################################################
function create_makefile(){
    if [ "$use_figlet"=true ]
    then 
        figlet "Creating Makefile!"
    else
        echo "Creating Makefile"
    fi
    

    # Create a basic makefile in the current directory
    touch ./makefile
    echo "$args2: $args2.o" >> ./makefile
    echo "\tg++ -o $args2 $args2.o" >> ./makefile 
    echo "$args2.o: $args2.cpp" >> ./makefile 
    echo "\tg++ -c $args2.cpp" >> ./makefile
    echo "run:" >> ./makefile
    echo "\t./$args2" >> ./makefile
    echo "clean:" >> ./makefile
    echo "\trm *.o $args2" >> ./makefile
    
}

function build_makefile(){
   
    # User prompt
    if [ "$use_figlet"=true ]
    then 
        figlet "Making"
    else 
        echo "Making..."
    fi
    
    # Remove obj files before building
    objfiles=ls -1 *.o 2>/dev/null | wc -l
    if [ "$objfiles"!=0 ]
    then
        make clean &>/dev/null
        echo "Cleaning Object Files!"
    fi

    make 
    make run

}

##############################################################################################

function build_normal(){
    
    if [ "$use_figlet"=true ]
    then
        figlet "Build G++"
    else
        echo "Build G++"
    fi

    if [ -d ./src ]
    then
        build_project_g++    
    elif [ -f makefile ]
    then
        build_makefile
    else
    count=ls -1 *.cpp 2>/dev/null | wc -l
        if [ "$count"!=0 ]
        then    
            g++ -Wall -std=c++17 ./*.cpp
            if [ -f a.out ]
            then
                ./a.out
            else
                echo "Compile Error!"
            fi
        fi    
    fi    
}

function build_project_g(){
    
    if [ -d ./src/ ]
    then
        echo "Source directory found!"
    else
        echo "No Source Directory found!"
        exit -1
    fi

    if [ -d ./include/ ]
    then
        echo "Include directory found!"
    else
        echo "No Include Directory found"
        exit -1
    fi

    g++ -Wall -std=c++17 -I ./include/ ./src/*.cpp
    if [ -f a.out ]
    then
        ./a.out
    else
        echo "Compile Error!"
    fi    
    
}
##############################################################################################
function create_tar_file_no_text_file(){
    count=ls -1 ./*.cpp 2>/dev/null | wc -l

    if [ "$count" == 0 ]
    then 
        echo "No .cpp files found!"
        exit -1 
    else
        tar -cf "$args2".tar *.cpp makefile
        exit 0
    fi    
}

function create_atr_file_with_text_file(){
    
    count=ls -1 ./*.cpp 2>/dev/null | wc -l

    if [ "$count" == 0 ]
    then
        echo "No .cpp files found!"
        exit -1
    else
         tar -cf "$args2".tar *.cpp makefile *.txt
         exit 0
    fi

}


##############################################################################################

if [ "$args"="-i" ]
then
    check_first_install
elif [ "$args" ="-u" ]
then 
    uninstall
elif [ "$args"="-m" ]
then
    create_makefile
elif [ "$args"="-c" ]
then
    if [ -z "$args2" ]
    then
        create_tar_file_no_text_file
    else
        echo "Please specify tar file name"
    fi    
elif [ "$args"="-ct" ]
then
    if [ -z "$args2" ]
    then
        create_atr_file_with_text_file
    else
        echo "Please specify tar file name"
    fi    
fi

build_normal
    
    
