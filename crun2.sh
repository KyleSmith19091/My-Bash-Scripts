# Variables
use_figlet=false
args=$1
args=$2
######################################################################################

# Compile program
# - Option 1: g++
#   -- cpp files only
#   -- cpp and hpp files
# - Option 2: makefile
#   -- Using existing makefile
#   -- Create makefile for just cpp files
#   -- Create makefile for cpp files in include dir
#   -- Create makefile for cpp all in same dir

function compile_cpp_only(){
    # Count cpp files
    count=`ls -1 ./*.cpp &>/dev/null | wc -l`
    if [ "$count" != 0 ]
    then
        echo "~ Compiling cpp files!"
        compile_statement="g++ -Wall -std=c++11 "
        for entry in "./"/*.cpp
        do
            filename=${entry##*/}
            echo "~ Found ${filename%.*}"
            compile_statement=$compile_statement"${filename} " 
        done
        compile_statement=$compile_statement" -o main" 
        $compile_statement
        echo "# Compile Done!"
        ./main
    else
        echo "* No cpp files found in current directory!"
    fi

}

######################################################################################



