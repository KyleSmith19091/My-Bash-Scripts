# Create directory in current directory
# Use the value given as first argument as the name of the directory
touch ./Main.cpp
echo "#include <iostream>" >> Main.cpp
echo ""
echo "using namespace std;" >> Main.cpp
echo "" >> Main.cpp
echo "int main(){" >> Main.cpp
echo "\tcin.tie(0);" >> Main.cpp
echo "" >> Main.cpp
echo "\treturn 0;" >> Main.cpp
echo "}" >> Main.cpp
nvim ./Main.cpp

