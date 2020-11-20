function go_to_include(){
    echo "Include"
    cd ../include/    
}

function go_to_src(){
    echo "src"
    cd ../src/
}

#####################################################################################################################################
# Check in which directory we are currently in
# Go back one step and check parent directory if the src directory exists
echo $PWD
if [ $PWD="*/src/" ]
then 
    # Then we know that we need to switch to the include directory
    go_to_include
elif [ $PWD="*/include/" ]
then 
    # Then we know we need to switch to the src directory
    go_to_src
else
    echo "Can not find src or include directories"
fi    


