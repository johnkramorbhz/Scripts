#!/bin/bash
# This will setup ROS on your system.

# MIT License

# Copyright (c) 2020-2021 johnkramorbhz

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

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
