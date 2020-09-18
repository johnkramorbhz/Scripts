#!/bin/bash
version="0.0.1"
version_suffix="beta"
update_path="main"
catkin_path="$HOME/catkin_ws"
function compile_and_update(){
cd $catkin_path && catkin_make && source $catkin_path/devel/setup.bash
if [ "$?" = "0" ]; then
echo "INFO: Compiled and updated package(s) successfully"
else
echo "ERROR: Failed to compile or update!"
exit 1
fi
}
if [ "$1" = "--install" ]; then
# Since it's not so feasible to keep the shell script in lots of directories, I provide --install option
echo -e "INFO: Are you running installation mode as root or sudo? \c"
if [[ $EUID -ne 0 ]]; then
   echo -e "\e[31mNo \e[0m"
   echo "ERROR: This script must be run as root since it installs some packages necessary for deployment"
   echo "INFO: Restart it as 'sudo $0 --install' instead" 
   exit 1
else
echo -e "\e[32mYes \e[0m"
fi
cp $0 /bin/ros_tools
chmod 777 /bin/ros_tools
elif [ "$1" = "--compile" ]; then
compile_and_update
elif [ "$1" = "--version" ]; then
echo $version
elif [ "$1" = "--force-upgrade" ]; then
echo "TODO"
else
echo "ERROR: You need to provide an argument!"
fi