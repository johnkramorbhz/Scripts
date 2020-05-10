#!/bin/bash
function get_system_info(){
    #Full distribution info
    cat /etc/*-release | grep ID=ubuntu >> /dev/null
    

}
function prerequisite_test(){
    echo "INFO: Running as '$USER'"
    echo "INFO: Checking whether packages that are required for this course presents..."
    # g++ valgrind gcc

}
function install_all_packages(){
    echo "INFO: Running as '$USER'"
    
}
function start_test(){
    echo "INFO: Running as '$USER'"
    wget https://github.com/johnkramorbhz/Scripts/raw/master/deployment/management/cse421_setup.sh
    chmod u+x cse421_setup.sh
    ./cse421_setup.sh


}
function build_cpp_and_c(){
    g++ -o cpp.bin hello.cpp
    gcc -o c.bin hello.c
}
function pintos_test(){
    cd $PINTOSDIR && make clean
    cd $PINTOSDIR/src/threads && make
    cd build && pintos run alarm-multiple
}
if [ "$1" = "pintos" ]; then
pintos_test
fi