#!/bin/bash
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
echo 'INFO: Installing all needed compilers packages'
if [ "$1" = "--no-GUI" ]; then
echo "INFO: Running in no GUI mode..."
sleep 3
apt update -y
apt upgrade -y
apt dist-upgrade -y
apt-get update -y
apt-get upgrade -y
#add-apt-repository -y ppa:wireshark-dev/stable
add-apt-repository -y ppa:kelleyk/emacs
apt install -y curl
curl -sL https://deb.nodesource.com/setup_12.x | bash -
#apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
apt install -y utop ocaml iverilog wget libtool-bin cmake libproxy-dev uuid-dev liblzo2-dev autoconf automake bash bison \
bzip2 diffutils file flex m4 g++ gawk groff-base libncurses-dev libtool libslang2 make patch perl pkg-config shtool \
subversion tar texinfo zlib1g zlib1g-dev git-core gettext libexpat1-dev libssl-dev cvs gperf unzip \
libxml-parser-perl gcc-multilib gconf-editor libxml2-dev g++-multilib gitk libncurses5 mtd-utils open-cobol lua5.3 \
libncurses5-dev libvorbis-dev git autopoint autogen sed build-essential intltool libglib2.0-dev \
xutils-dev lib32z1-dev lib32stdc++6 xsltproc gtk-doc-tools clang gdb valgrind default-jdk ruby-full libglu1-mesa-dev \
texlive-full texmaker network-manager-openconnect-gnome vpnc \
network-manager-vpnc network-manager-vpnc-gnome nodejs \
gdebi-core libxmu-dev libxi-dev libglu1-mesa python3-pip \
libjpeg-dev libpng-dev libtiff-dev libavcodec-dev libavformat-dev libswscale-dev libv4l-dev libxvidcore-dev libx264-dev \
libgtk-3-dev libopenblas-dev libatlas-base-dev liblapack-dev gfortran libhdf5-serial-dev python3-dev python3-tk \
python-imaging-tk docker.io unattended-upgrades binutils bochs \
r-base gdb
snap install --classic kotlin
pip3 install --upgrade tensorflow requests
exit 0
fi
# Everything else
apt update -y
apt upgrade -y
apt dist-upgrade -y
apt-get update -y
apt-get upgrade -y
#add-apt-repository -y ppa:videolan/master-daily
#add-apt-repository -y ppa:wireshark-dev/stable
#add-apt-repository -y ppa:kelleyk/emacs
add-apt-repository -y universe
#add-apt-repository -y ppa:communitheme/ppa
#add-apt-repository -y ppa:danielrichter2007/grub-customizer
apt install -y curl
curl -sL https://deb.nodesource.com/setup_12.x | bash -
#apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
#add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/'
apt install -y utop ocaml iverilog wget libtool-bin cmake libproxy-dev uuid-dev liblzo2-dev autoconf automake bash bison \
bzip2 diffutils file flex m4 g++ gawk groff-base libncurses-dev libtool libslang2 make patch perl pkg-config shtool \
subversion tar texinfo zlib1g zlib1g-dev git-core gettext libexpat1-dev libssl-dev cvs gperf unzip \
libxml-parser-perl gcc-multilib gconf-editor libxml2-dev g++-multilib gitk libncurses5 mtd-utils \
libncurses5-dev libvorbis-dev git autopoint autogen sed build-essential intltool libelf1:i386 libglib2.0-dev \
xutils-dev lib32z1-dev lib32stdc++6 xsltproc gtk-doc-tools clang gdb valgrind default-jdk ruby-full libglu1-mesa-dev \
texlive-full texmaker network-manager-openconnect-gnome vpnc open-cobol lua5.3 \
network-manager-vpnc network-manager-vpnc-gnome nodejs gnome-tweak-tool gnome-shell-extension-system-monitor \
filezilla transmission gnome-shell-extensions gdebi-core grub-customizer libxmu-dev libxi-dev libglu1-mesa \
libjpeg-dev libpng-dev libtiff-dev libavcodec-dev libavformat-dev libswscale-dev libv4l-dev libxvidcore-dev libx264-dev \
libgtk-3-dev libopenblas-dev libatlas-base-dev liblapack-dev gfortran libhdf5-serial-dev python3-dev python3-tk \
python-imaging-tk docker.io unattended-upgrades binutils qemu-kvm qemu virt-manager bochs python3-pip \
r-base libncurses5-dev libncursesw5-dev libncurses5-dev:i386 libncursesw5-dev:i386 libx11-6:i386 libxpm4:i386 gdb
pip3 install --upgrade tensorflow requests
wget -4 https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
gdebi --non-interactive google-chrome-stable_current_amd64.deb
snap install --classic kotlin
snap install slack --classic
snap install libreoffice
snap install code --classic
snap install vlc
#npm install -g npm mocha chai mocha-simple-html-reporter
if [ "$1" = "--nvidia" ]; then
# echo "Not supported at this time. Skip!"
add-apt-repository -y ppa:graphics-drivers/ppa
apt update
apt install -y build-essential libglvnd-dev pkg-config
ubuntu-drivers autoinstall
# echo "INFO: Installing prerequisite packages for Tensorflow GPU"
# apt install -y gcc-6 g++-6
# wget -4 http://developer.download.nvidia.com/compute/cuda/10.2/Prod/local_installers/cuda_10.2.89_440.33.01_linux.run
# chmod u+x cuda_10.2.89_440.33.01_linux.run
# echo "INFO: Starting the CUDA installer..."
# ./cuda_10.2.89_440.33.01_linux.run --override
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