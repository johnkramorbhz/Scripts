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
echo "Last Updated at 2020-09-14 03:43 EDT/EST"
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
function install_swift(){
wget https://swift.org/builds/swift-5.2.5-release/ubuntu2004/swift-5.2.5-RELEASE/swift-5.2.5-RELEASE-ubuntu20.04.tar.gz
tar xzf swift-5.2.5-RELEASE-ubuntu20.04.tar.gz
mv swift-5.2.5-RELEASE-ubuntu20.04 /usr/share/swift
echo "export PATH=/usr/share/swift/usr/bin:$PATH" >> ~/.bashrc
source  ~/.bashrc   
}
function post_install_ROS(){
echo "INFO: Doing post-installation of ROS"
sleep 3
echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc
source ~/.bashrc
}
function common_pre_reqs(){
#ROS packages
sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
# END of ROS packages
apt update -y
apt upgrade -y
apt dist-upgrade -y
apt-get update -y
apt-get upgrade -y
apt install -y curl
add-apt-repository -y universe
add-apt-repository -y restricted
add-apt-repository -y multiverse
curl -sL https://deb.nodesource.com/setup_14.x | bash -
apt install -y curl python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool
snap install --classic kotlin
}
echo 'INFO: Installing all needed compilers packages'
if [ "$1" = "--no-GUI" ]; then
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
network-manager-vpnc network-manager-vpnc-gnome nodejs \
gdebi-core libxmu-dev libxi-dev libglu1-mesa python3-pip \
libjpeg-dev libpng-dev libtiff-dev libavcodec-dev libavformat-dev libswscale-dev libv4l-dev libxvidcore-dev libx264-dev \
libgtk-3-dev libopenblas-dev libatlas-base-dev liblapack-dev gfortran libhdf5-serial-dev python3-dev python3-tk \
python-imaging-tk docker.io unattended-upgrades binutils bochs \
r-base gdb
# Post installation of ROS
post_install_ROS
cat ~/.bashrc | grep "source /opt/ros/noetic/setup.bash" >> /dev/null || post_install_ROS
# End of post installation of ROS

# Go to install_swift()
install_swift
# End of install_swift()
pip3 install --upgrade tensorflow requests
exit 0
fi
if [ "$1" = "--init-ROS" ]; then
cat ~/.bashrc | grep "source /opt/ros/noetic/setup.bash" >> /dev/null || post_install_ROS
fi
# Everything else
common_pre_reqs

apt install -y utop ocaml iverilog wget libtool-bin cmake libproxy-dev uuid-dev liblzo2-dev autoconf automake bash bison \
bzip2 diffutils file flex m4 g++ gawk groff-base libncurses-dev libtool libslang2 make patch perl pkg-config shtool \
subversion tar texinfo zlib1g zlib1g-dev git-core gettext libexpat1-dev libssl-dev cvs gperf unzip \
libxml-parser-perl gcc-multilib gconf-editor libxml2-dev g++-multilib gitk libncurses5 mtd-utils \
libncurses5-dev libvorbis-dev git autopoint autogen sed build-essential intltool libelf1:i386 libglib2.0-dev \
xutils-dev lib32z1-dev lib32stdc++6 xsltproc gtk-doc-tools clang gdb valgrind default-jdk ruby-full libglu1-mesa-dev \
texlive-full texmaker network-manager-openconnect-gnome vpnc open-cobol lua5.3 python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool \
network-manager-vpnc network-manager-vpnc-gnome nodejs gnome-tweak-tool gnome-shell-extension-system-monitor ros-noetic-desktop-full \
filezilla transmission gnome-shell-extensions gdebi-core grub-customizer libxmu-dev libxi-dev libglu1-mesa \
libjpeg-dev libpng-dev libtiff-dev libavcodec-dev libavformat-dev libswscale-dev libv4l-dev libxvidcore-dev libx264-dev \
libgtk-3-dev libopenblas-dev libatlas-base-dev liblapack-dev gfortran libhdf5-serial-dev python3-dev python3-tk \
python-imaging-tk docker.io unattended-upgrades binutils qemu-kvm qemu virt-manager bochs python3-pip \
r-base libncurses5-dev libncursesw5-dev libncurses5-dev:i386 libncursesw5-dev:i386 libx11-6:i386 libxpm4:i386 gdb
pip3 install --upgrade tensorflow requests
# Post installation of ROS
post_install_ROS
cat ~/.bashrc | grep "source /opt/ros/noetic/setup.bash" >> /dev/null || post_install_ROS
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
# echo "Not supported at this time. Skip!"
add-apt-repository -y ppa:graphics-drivers/ppa
apt update
apt install -y build-essential libglvnd-dev pkg-config
ubuntu-drivers autoinstall
fi
echo "INFO: Installing wireshark..."
apt install -y wireshark
echo "INFO: Cleaning up..."
apt-get clean -y
apt-get autoremove -y
rm -rf /usr/share/applications/ocaml.desktop
rm -rf google-chrome-stable_current_amd64.deb
duration=$(( SECONDS - start ))
echo -e "\nINFO: Installing all packages is now finished"
echo "It takes $duration second(s) to finish above operations"