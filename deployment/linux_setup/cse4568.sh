#!/bin/bash
# This will setup ROS on your system.
set -x
release_name=$(lsb_release -c -s)
function install_pre_req(){
sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
apt update -y
apt install -y python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential
}
echo -e "INFO: Are you running this script as root or sudo? \c"
if [[ $EUID -ne 0 ]]; then
   echo -e "\e[31mNo \e[0m"
   echo "ERROR: This script must be run as root since it installs some packages necessary for deployment"
   echo "INFO: Restart it as 'sudo $0 $1 $2' instead" 
   exit 1
else
echo -e "\e[32mYes \e[0m"
fi
if [ $release_name = "focal" ]; then
echo "INFO: This will install ROS Noetic"
install_pre_req
apt install ros-noetic-desktop-full
source /opt/ros/noetic/setup.bash
elif [ $release_name = "bionic" ]; then
install_pre_req
apt install ros-melodic-desktop-full
echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc
source ~/.bashrc
rosdep init
rosdep update
else
echo "ERROR: Not supported!"
fi