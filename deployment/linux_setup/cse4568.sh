#!/bin/bash
# This will setup ROS on your system.
function install_pre_req(){
sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
apt update -y
apt upgrade -y
apt install -y python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential
}
function post_install_ROS(){
echo "source /opt/ros/$1/setup.bash" >> /etc/bash.bashrc
source /etc/bash.bashrc
}
if [ "$(cat /etc/os-release | grep -w "ID")" = "ID=ubuntu" ]; then
echo -e "INFO: Are you running this script as root or sudo? \c"
if [[ $EUID -ne 0 ]]; then
   echo -e "\e[31mNo \e[0m"
   echo "ERROR: This script must be run as root since it installs some packages necessary for deployment"
   echo "INFO: Restart it as 'sudo $0 $1 $2' instead" 
   exit 1
else
echo -e "\e[32mYes \e[0m"
fi
if [ "$(lsb_release -c -s)" = "focal" ]; then
echo "INFO: This will install ROS Noetic"
install_pre_req
apt install -y ros-noetic-desktop-full
post_install_ROS noetic
elif [ "$(lsb_release -c -s)" = "bionic" ]; then
install_pre_req
apt install -y ros-melodic-desktop-full
post_install_ROS melodic
else
echo "ERROR: Not supported!"
exit 1
fi
else
# If not Ubuntu
echo "ERROR: You are not using Ubuntu"
exit 1
fi
