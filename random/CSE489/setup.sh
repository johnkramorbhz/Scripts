#!/bin/bash
function get_system_info(){
    #Full distribution info
    cat /etc/*-release | grep ID=ubuntu >> /dev/null
    

}
function prerequisite_test(){
    echo "INFO: Running as '$USER'"
    echo "INFO: Checking whether packages that are required for this course presents..."
    # g++ valgrind 

}
function install_all_packages(){
    echo "INFO: Running as '$USER'"
    
}
function start_test(){
    echo "INFO: Running as '$USER'"

}