#!/bin/bash
# MIT License

# Copyright (c) 2020 johnkramorbhz

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

echo "Last Updated at 2021-04-04 23:22"
sleep 3
start=$SECONDS
echo -e "INFO: Are you running this script as root or sudo? \c"
if [[ $EUID -ne 0 ]]; then
   echo -e "\e[31mNo \e[0m"
   echo "ERROR: This script must be run as root since it installs some packages necessary for deployment"
   echo "INFO: Restart it as 'sudo $0 $1 $2' instead" 
   exit 1
else
echo -e "\e[32mYes \e[0m"
fi
echo -e "INFO: Are you running this script on x86_64 architecture? \c"
if [[ $(uname -m) != "x86_64" ]]; then
   echo -e "\e[31mNo \e[0m"
   echo "ERROR: You cannot use this script on a non x86_64 machines like ARM, x86, or etc."
   exit 2
else
echo -e "\e[32mYes \e[0m"
fi
function install_swift(){
swift_version="5.3.3"
wget https://swift.org/builds/swift-$swift_version-release/ubuntu2004/swift-$swift_version-RELEASE/swift-$swift_version-RELEASE-ubuntu20.04.tar.gz
tar xzf swift-$swift_version-RELEASE-ubuntu20.04.tar.gz
mv swift-$swift_version-RELEASE-ubuntu20.04 /usr/share/swift
echo "export PATH=/usr/share/swift/usr/bin:$PATH" >> /etc/bash.bashrc
source /etc/bash.bashrc
rm -rf swift-$swift_version-RELEASE-ubuntu20.04.tar.gz
}
function install_virtualbox_official(){
echo "deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian $(lsb_release -sc) contrib" | tee /etc/apt/sources.list.d/virtualbox.list
wget https://www.virtualbox.org/download/oracle_vbox_2016.asc
apt-key add oracle_vbox_2016.asc && rm -rf oracle_vbox_2016.asc
apt update -y
apt install -y --install-suggests virtualbox-6.1
}
function post_install_ROS(){
echo "INFO: Doing post-installation of ROS"
sleep 3
echo "source /opt/ros/noetic/setup.bash" >> /etc/bash.bashrc
source /etc/bash.bashrc
}
function common_pre_reqs(){
#ROS packages
sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
# ROS2 packages
sh -c 'echo "deb [arch=$(dpkg --print-architecture)] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros2-latest.list'
# END of ROS packages
apt update -y
apt upgrade -y
apt dist-upgrade -y
apt-get update -y
apt-get upgrade -y
apt install -y curl gnupg2 lsb-release --install-suggests
add-apt-repository -y universe
add-apt-repository -y restricted
add-apt-repository -y multiverse
curl -sL https://deb.nodesource.com/setup_14.x | bash -
curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
apt install -y curl python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool \
packagekit-gtk3-module libcanberra-gtk-module libcanberra-gtk3-module scala
snap install --classic kotlin
snap install htop tree
}
echo 'INFO: Installing all needed compilers packages'
if [ "$1" = "--no-GUI" ]; then
cat /proc/version | grep microsoft >> /dev/null
if [ "$?" -ne 0 ]; then
echo "ERROR: It is not WSL"
exit 1
fi
echo "INFO: Running in no GUI mode..."
sleep 3
common_pre_reqs
apt install -y utop ocaml iverilog wget libtool-bin cmake libproxy-dev uuid-dev liblzo2-dev autoconf automake bash bison \
bzip2 diffutils file flex m4 g++ gawk groff-base libncurses-dev libtool libslang2 make patch perl pkg-config shtool \
subversion tar texinfo zlib1g zlib1g-dev git-core gettext libexpat1-dev libssl-dev cvs gperf unzip \
libxml-parser-perl gcc-multilib gconf-editor libxml2-dev g++-multilib gitk libncurses5 mtd-utils open-cobol lua5.3 \
libncurses5-dev libvorbis-dev git autopoint autogen sed build-essential intltool libglib2.0-dev \
xutils-dev lib32z1-dev lib32stdc++6 xsltproc gtk-doc-tools clang gdb valgrind default-jdk ruby-full libglu1-mesa-dev \
texlive-full texmaker network-manager-openconnect-gnome vpnc ros-noetic-desktop-full \
network-manager-vpnc network-manager-vpnc-gnome nodejs ros-foxy-desktop\
gdebi-core libxmu-dev libxi-dev libglu1-mesa python3-pip \
libjpeg-dev libpng-dev libtiff-dev libavcodec-dev libavformat-dev libswscale-dev libv4l-dev libxvidcore-dev libx264-dev \
libgtk-3-dev libopenblas-dev libatlas-base-dev liblapack-dev gfortran libhdf5-serial-dev python3-dev python3-tk \
python-imaging-tk docker.io unattended-upgrades binutils bochs \
r-base gdb
# Post installation of ROS
post_install_ROS
cat /etc/bash.bashrc | grep "source /opt/ros/noetic/setup.bash" >> /dev/null || post_install_ROS
# End of post installation of ROS

# Go to install_swift()
install_swift
# End of install_swift()
pip3 install --upgrade tensorflow requests
# Skip CUDA installation if not in WSL2
cat /proc/version | grep "5.4" >> /dev/null
if [ "$?" -ne 0 ]; then
echo "INFO: Not in WSL2 or your WSL2 kernel is not up to date." 
echo "INFO: Here is your kernel version"
uname -r
exit 0
fi
sh -c 'echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64 /" > /etc/apt/sources.list.d/cuda.list'
apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/7fa2af80.pub
apt update
apt install -y cuda-toolkit-11-0 --install-suggests
exit 0
fi
if [ "$1" = "--init-ROS" ]; then
cat /etc/bash.bashrc | grep "source /opt/ros/noetic/setup.bash" >> /dev/null || post_install_ROS
fi
# Everything else
common_pre_reqs
install_virtualbox_official

apt install -y utop ocaml iverilog wget libtool-bin cmake libproxy-dev uuid-dev liblzo2-dev autoconf automake bash bison \
bzip2 diffutils file flex m4 g++ gawk groff-base libncurses-dev libtool libslang2 make patch perl pkg-config shtool \
subversion tar texinfo zlib1g zlib1g-dev git-core gettext libexpat1-dev libssl-dev cvs gperf unzip ros-foxy-desktop \
libxml-parser-perl gcc-multilib gconf-editor libxml2-dev g++-multilib gitk libncurses5 mtd-utils \
libncurses5-dev libvorbis-dev git autopoint autogen sed build-essential intltool libelf1:i386 libglib2.0-dev \
xutils-dev lib32z1-dev lib32stdc++6 xsltproc gtk-doc-tools clang gdb valgrind default-jdk ruby-full libglu1-mesa-dev \
texlive-full texmaker network-manager-openconnect-gnome vpnc open-cobol lua5.3 python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool \
network-manager-vpnc network-manager-vpnc-gnome nodejs gnome-tweak-tool gnome-shell-extension-system-monitor ros-noetic-desktop-full \
filezilla transmission gnome-shell-extensions gdebi-core grub-customizer libxmu-dev libxi-dev libglu1-mesa \
libjpeg-dev libpng-dev libtiff-dev libavcodec-dev libavformat-dev libswscale-dev libv4l-dev libxvidcore-dev libx264-dev \
libgtk-3-dev libopenblas-dev libatlas-base-dev liblapack-dev gfortran libhdf5-serial-dev python3-dev python3-tk \
python-imaging-tk docker.io unattended-upgrades binutils qemu-kvm qemu virt-manager bochs python3-pip \
r-base libncurses5-dev libncursesw5-dev libncurses5-dev:i386 libncursesw5-dev:i386 libx11-6:i386 libxpm4:i386 gdb lm-sensors
pip3 install --upgrade tensorflow requests
# Post installation of ROS
post_install_ROS
cat /etc/bash.bashrc| grep "source /opt/ros/noetic/setup.bash" >> /dev/null || post_install_ROS
# End of post installation of ROS
# Go to install_swift()
install_swift
# End of install_swift()
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
gdebi --non-interactive google-chrome-stable_current_amd64.deb
snap install slack --classic
snap install libreoffice
snap install code --classic
snap install vlc
if [ "$1" = "--nvidia" ]; then
add-apt-repository ppa:graphics-drivers/ppa
ubuntu-drivers install
# wget -O nvidia_driver.run https://us.download.nvidia.com/XFree86/Linux-x86_64/455.23.04/NVIDIA-Linux-x86_64-455.23.04.run
# sh nvidia_driver.run
# wget -O cuda.run https://developer.download.nvidia.com/compute/cuda/11.2.0/local_installers/cuda_11.2.0_460.27.04_linux.run
# sh cuda.run
# echo 'export PATH=/usr/local/cuda/bin${PATH:+:${PATH}}' >> /etc/bash.bashrc
# source /etc/bash.bashrc
fi
echo "INFO: Installing wireshark..."
apt install -y wireshark --install-suggests
echo "INFO: Cleaning up..."
apt-get clean -y
apt-get autoremove -y
rm -rf /usr/share/applications/ocaml.desktop
rm -rf google-chrome-stable_current_amd64.deb
duration=$(( SECONDS - start ))
echo -e "\nINFO: Installing all packages is now finished"
echo "It takes $duration second(s) to finish above operations"
