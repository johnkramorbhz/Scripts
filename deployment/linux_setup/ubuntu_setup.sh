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
if [ "$1" = "--nvidia--driver--only" ]; then
echo "INFO: Installing NVIDIA Display drivers only"
add-apt-repository -y ppa:graphics-drivers/ppa
apt update
dpkg --add-architecture i386
apt update
apt install build-essential libc6:i386 -y
ubuntu-drivers autoinstall
duration=$(( SECONDS - start ))
echo "It takes $duration second(s) to finish above operations"
exit 0
fi
echo 'INFO: Installing all needed compilers packages'
apt update -y
apt upgrade -y
apt dist-upgrade -y
apt-get update -y
apt-get upgrade -y
add-apt-repository -y "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
add-apt-repository -y ppa:videolan/master-daily
add-apt-repository -y ppa:wireshark-dev/stable
add-apt-repository -y ppa:kelleyk/emacs
add-apt-repository -y universe
add-apt-repository -y ppa:communitheme/ppa
add-apt-repository -y ppa:danielrichter2007/grub-customizer
apt install -y curl
curl -sL https://deb.nodesource.com/setup_10.x | bash -
apt install -y utop ocaml iverilog wget cmake libtool-bin cmake libproxy-dev uuid-dev liblzo2-dev autoconf automake bash bison \
bzip2 diffutils file flex m4 g++ gawk groff-base libncurses-dev libtool libslang2 make patch perl pkg-config shtool \
subversion tar texinfo zlib1g zlib1g-dev git-core gettext libexpat1-dev libssl-dev cvs gperf unzip \
python libxml-parser-perl gcc-multilib gconf-editor libxml2-dev g++-multilib gitk libncurses5 mtd-utils \
libncurses5-dev libvorbis-dev git autopoint autogen sed build-essential intltool libelf1:i386 libglib2.0-dev \
xutils-dev lib32z1-dev lib32stdc++6 xsltproc gtk-doc-tools build-essential clang gdb valgrind default-jdk ruby-full \
texlive-full texmaker code vlc wireshark network-manager-openconnect-gnome vpnc ubuntu-communitheme-session \
network-manager-vpnc network-manager-vpnc-gnome emacs26 nodejs gnome-tweak-tool gnome-shell-extension-system-monitor \
filezilla transmission gnome-shell-extensions gdebi-core grub-customizer
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
gdebi --non-interactive google-chrome-stable_current_amd64.deb
snap install slack --classic
snap install libreoffice
npm install -g npm mocha chai mocha-simple-html-reporter
if [ "$1" = "--nvidia" ]; then
add-apt-repository -y ppa:graphics-drivers/ppa
apt update
dpkg --add-architecture i386
apt update
apt install build-essential libc6:i386
ubuntu-drivers autoinstall
fi
echo "INFO: Cleaning up..."
apt-get clean
apt-get autoremove
rm -rf /usr/share/applications/ocaml.desktop
rm -rf google-chrome-stable_current_amd64.deb
duration=$(( SECONDS - start ))
echo -e "\nINFO: Installing all packages is now finished"
echo "It takes $duration second(s) to finish above operations"