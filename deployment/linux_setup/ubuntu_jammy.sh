#!/bin/bash
# MIT License

# Copyright (c) 2023 johnkramorbhz

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

swift_version="5.7.3"
echo -e "Script Version: 0.1 \nLast Updated at 2023-01-31"
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
   echo -e "\e[31mNo\e[0m"
   echo "ERROR: You cannot use this script on a non x86_64 machines like ARM, x86, or etc."
   exit 2
else
echo -e "\e[32mYes\e[0m"
fi
function post_cleanup(){
echo "INFO: Cleaning up..."
apt-get clean -y
apt-get autoremove -y
rm -rf swift-$swift_version-RELEASE-ubuntu22.04.tar.gz
rm -rf /usr/share/applications/ocaml.desktop
rm -rf google-chrome-stable_current_amd64.deb
duration=$(( SECONDS - start ))
echo -e "\nINFO: Installing all packages is now finished"
echo "It takes $duration second(s) to finish above operations"
}
function install_swift(){
if [ -e "swift-$swift_version-RELEASE-ubuntu22.04.tar.gz" ]; then   
tar xzf swift-$swift_version-RELEASE-ubuntu22.04.tar.gz
mv swift-$swift_version-RELEASE-ubuntu22.04 /usr/share/swift
echo "export PATH=/usr/share/swift/usr/bin:$PATH" >> /etc/bash.bashrc
source /etc/bash.bashrc
else
echo "INFO: Cannot see the swift binaries, skip"
fi
}
function common_pre_reqs(){
wget -bqc https://swift.org/builds/swift-$swift_version-release/ubuntu2204/swift-$swift_version-RELEASE/swift-$swift_version-RELEASE-ubuntu22.04.tar.gz   
apt update -y
apt upgrade -y
apt dist-upgrade -y
apt install -y curl gnupg2 lsb-release --install-suggests
add-apt-repository -y universe
add-apt-repository -y restricted
add-apt-repository -y multiverse
curl -sL https://deb.nodesource.com/setup_18.x | bash -
snap install --classic kotlin
snap install htop tree
}
# Traditional WSL and WSL2 packages.
function install_headless_pkgs(){
echo "INFO: Running in no GUI mode..."
sleep 3
common_pre_reqs
apt install -y utop ocaml iverilog wget libtool-bin cmake libproxy-dev uuid-dev liblzo2-dev autoconf automake bash bison \
bzip2 diffutils file flex m4 g++ gawk groff-base libncurses-dev libtool libslang2 make patch perl pkg-config shtool \
subversion tar texinfo zlib1g zlib1g-dev git-core gettext libexpat1-dev libssl-dev cvs gperf unzip \
libxml-parser-perl gcc-multilib  libxml2-dev g++-multilib gitk libncurses5 mtd-utils  lua5.3 \
libncurses5-dev libvorbis-dev git autopoint autogen sed build-essential intltool libglib2.0-dev \
xutils-dev lib32z1-dev lib32stdc++6 xsltproc gtk-doc-tools clang gdb valgrind default-jdk ruby-full libglu1-mesa-dev \
texlive-full texmaker network-manager-openconnect-gnome vpnc  \
network-manager-vpnc network-manager-vpnc-gnome nodejs \
gdebi-core libxmu-dev libxi-dev libglu1-mesa python3-pip \
libjpeg-dev libpng-dev libtiff-dev libavcodec-dev libavformat-dev libswscale-dev libv4l-dev libxvidcore-dev libx264-dev \
libgtk-3-dev libopenblas-dev libatlas-base-dev liblapack-dev gfortran libhdf5-serial-dev python3-dev python3-tk docker.io unattended-upgrades binutils bochs \
r-base gdb
pip3 install numpy matplotlib


# Go to install_swift()
install_swift
# End of install_swift()
pip3 install --upgrade tensorflow requests

}
# The WSL2 with Windows 11 support both X.Org and Wayland display servers so just install standard packages and also CUDA WSL2 libraries.
function install_full_pkgs(){
common_pre_reqs
install_virtualbox_official

apt install -y utop ocaml iverilog wget libtool-bin cmake libproxy-dev uuid-dev liblzo2-dev autoconf automake bash bison \
bzip2 diffutils file flex m4 g++ gawk groff-base libncurses-dev libtool libslang2 make patch perl pkg-config shtool \
subversion tar texinfo zlib1g zlib1g-dev git-core gettext libexpat1-dev libssl-dev cvs gperf unzip  \
libxml-parser-perl gcc-multilib  libxml2-dev g++-multilib gitk libncurses5 mtd-utils \
libncurses5-dev libvorbis-dev git autopoint autogen sed build-essential intltool libglib2.0-dev \
xutils-dev lib32z1-dev lib32stdc++6 xsltproc gtk-doc-tools clang gdb valgrind default-jdk ruby-full libglu1-mesa-dev \
texlive-full texmaker network-manager-openconnect-gnome vpnc lua5.3  python3-wstool \
network-manager-vpnc network-manager-vpnc-gnome nodejs \
filezilla transmission gnome-shell-extensions gdebi-core libxmu-dev libxi-dev libglu1-mesa \
libjpeg-dev libpng-dev libtiff-dev libavcodec-dev libavformat-dev libswscale-dev libv4l-dev libxvidcore-dev libx264-dev \
libgtk-3-dev libopenblas-dev libatlas-base-dev liblapack-dev gfortran libhdf5-serial-dev python3-dev python3-tk \
docker.io unattended-upgrades binutils qemu-kvm qemu virt-manager bochs python3-pip \
r-base libncurses5-dev libncursesw5-dev gdb lm-sensors
pip3 install --upgrade tensorflow requests numpy matplotlib

# Go to install_swift()
install_swift
# End of install_swift()
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
gdebi --non-interactive google-chrome-stable_current_amd64.deb
snap install slack --classic
snap install libreoffice
snap install code --classic
snap install vlc
cat /proc/version | grep "5.15" >> /dev/null && cat /proc/version | grep "WSL2" >> /dev/null && CUDA_WSL2_pkgs
}
function install_nv_drivers_and_full_pkgs(){
# Everything else
install_full_pkgs
add-apt-repository ppa:graphics-drivers/ppa
ubuntu-drivers install
# wget -O nvidia_driver.run https://us.download.nvidia.com/XFree86/Linux-x86_64/455.23.04/NVIDIA-Linux-x86_64-455.23.04.run
# sh nvidia_driver.run
# wget -O cuda.run https://developer.download.nvidia.com/compute/cuda/11.2.0/local_installers/cuda_11.2.0_460.27.04_linux.run
# sh cuda.run
# echo 'export PATH=/usr/local/cuda/bin${PATH:+:${PATH}}' >> /etc/bash.bashrc
# source /etc/bash.bashrc
echo "INFO: Installing wireshark..."
apt install -y wireshark --install-suggests
}
# Start
echo 'INFO: Installing all needed compilers packages'
if [ "$1" = "--no-GUI" ]; then
cat /proc/version | grep microsoft >> /dev/null
if [ "$?" -ne 0 ]; then
echo "ERROR: It is not WSL"
exit 1
fi
install_headless_pkgs
# Skip CUDA installation if not in WSL2
cat /proc/version | grep "5.4" >> /dev/null || cat /proc/version | grep "5.15" >> /dev/null && cat /proc/version | grep "WSL2" >> /dev/null
if [ "$?" -ne 0 ]; then
echo "INFO: Your WSL 2 kernel is not up to date." 
echo "INFO: Here is your kernel version"
uname -r
exit 0
else
CUDA_WSL2_pkgs
fi
fi
if [ "$1" = "--nvidia" ]; then
install_nv_drivers_and_full_pkgs
fi
if [ "$1" = "--full-pkgs" ]; then
install_full_pkgs
fi