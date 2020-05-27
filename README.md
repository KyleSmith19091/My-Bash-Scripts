# My-Bash-Scripts
My shell scripts are solutions to problems that I found tedious in my use of the terminal. I created these scripts
as way to streamline and increase my productivity in the terminal

# What is there?
- C++ Run command
- Weather forcast script
- Clear downloads folder script
- A versatile script to quickly open config files
- A script to create an empty C++ project and open my editor
- Tmux Startup script for development
- Tmux script to show off how cool my terminal looks

## Let's start off with C++
This is a script that I wrote because I found it extremely irritating having to first run

    ```
    g++ -Wall -Werror -lsomelib myfile.cpp -o main 
    ./main
    ```
So I condensed this and so much more into one easy command.
This script can
1. Run a simple makefile project
2. Execute a C++ project with header files
3. Execute a C++ project with library files

### How would one install this?
1. Download the run c++.sh file or the entire bash scripts folder
```
# If you want to do this from the terminal enter the following command
$ git clone https://github.com/sKorpion19091/My-Bash-Scripts.git/run_c++.sh
```
The above command requires that the git command be installed and will install the directory in
your home directory if run in that directory.

2. Open your terminal application of choice
3. Change into the directory where the file was downloaded to
```
$ cd path/to/file
```
4. Then type in the following
```
$ chmod +x run_c++.sh
```
5. Followed by
```
$ ./run_c++.sh -install
```
6. All set!

### How do I use it?
- Makefile project




