#!/bin/bash
version="0.1.0"
version_suffix="beta"
update_path="main"
# Default path
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
function compile_and_update_custom_dir(){
cd -L $1 && catkin_make && source $1/devel/setup.bash
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
cp $0 /bin/ros_bashtools
chmod 777 /bin/ros_bashtools
elif [ "$1" = "--compile" ] || [ "$1" = "-c" ]; then
compile_and_update
elif [ "$1" = "--version" ] || [ "$1" = "-v" ]; then
echo $version
elif [ "$1" = "--force-upgrade" ] || [ "$1" = "-fu" ]; then
echo -e "INFO: Are you running upgrade mode as root or sudo? \c"
if [[ $EUID -ne 0 ]]; then
   echo -e "\e[31mNo \e[0m"
   echo "ERROR: This script must be run as root since it installs some packages necessary for deployment"
   echo "INFO: Restart it as 'sudo $0 --force-upgrade' instead" 
   exit 1
else
echo -e "\e[32mYes \e[0m"
fi
wget --no-cache -O /bin/ros_bashtools -q https://raw.githubusercontent.com/johnkramorbhz/Scripts/main/ros_toolbox/ros_tools.sh
chmod 777 /bin/ros_bashtools
elif [ "$1" = "--launch-lab1-test" ] || [ "$1" = "-l1t" ]; then
compile_and_update
roslaunch lab1 lab1.launch
elif [ "$1" = "--compile-custom-dir" ] || [ "$1" = "-ccd" ]; then
compile_and_update_custom_dir $2
elif [ "$1" = "--launch-lab1" ] || [ "$1" = "-l1" ]; then
compile_and_update_custom_dir $2
roslaunch lab1 lab1.launch
elif [ "$1" = "--make-workspace" ] || [ "$1" = "-makews" ]; then
echo -e "INFO: Are you making this workspace as root or sudo? \c"
if [[ $EUID -ne 0 ]]; then
   echo -e "\e[31mNo \e[0m"
   echo "ERROR: This script must be run as root in init mode"
   echo "INFO: Restart it as 'sudo $0 --make-workspace' instead" 
   exit 1
else
echo -e "\e[32mYes \e[0m"
fi
mkdir -p $(pwd)/catkin_ws/src
chmod 777 -R $(pwd)/catkin_ws/
cd $(pwd)/catkin_ws/
release_name=$(lsb_release -c -s)
if [ "$release_name" = "bionic" ]; then
# Ubuntu 18.04 LTS
source /opt/ros/melodic/setup.bash
elif [ "$release_name" = "focal" ]; then
# Ubuntu 20.04 LTS
source /opt/ros/noetic/setup.bash
fi
catkin_make
chmod 777 -R $(pwd)/catkin_ws/
elif [ "$1" = "--print-directory" ] || [ "$1" = "-pwd" ]; then
pwd
else
# Literlly else
echo "ERROR: You need to provide an argument!"
fi
