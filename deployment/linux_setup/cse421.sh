#!/bin/bash
echo "INFO: Checking your release..."
release_name=$(lsb_release -c -s)
if [ $release_name = "bionic" ]; then
echo "Please only run this ONCE! ONLY USE IT ON UBUNTU BIONIC BEAVER(18.04), since Ubuntu REMOVES i386 support on the later release!"
else
echo "WARNING: You are using a distro that is not supported by this script. I urge you stop this installation unless you know what you are doing."
echo "Press [ENTER] to continue"
read
fi
if hash pintos 2>/dev/null; then
echo "WARNING: Already installed"
exit 0
fi
echo "export PINTOSDIR=$HOME/pintos" >> $HOME/.bashrc
echo "export BXSHARE=/usr/local/share/bochs" >> $HOME/.bashrc
source  $HOME/.bashrc
sudo apt install libncurses5-dev:i386 libncursesw5-dev:i386 libx11-6:i386 libxpm4:i386 perl build-essential gdb
wget https://github.com/johnkramorbhz/Scripts/raw/master/deployment/linux_setup/pintosbin.tar
wget https://github.com/johnkramorbhz/Scripts/raw/master/deployment/linux_setup/ubpintos.tar
tar -xvf ubpintos.tar -C $HOME
tar -xvf pintosbin.tar
cd pintosbin
sudo cp -R bin/* /usr/local/bin/
sudo mkdir -R /usr/local/share/bochs/
sudo cp -R bochs /usr/local/share/bochs/
echo "Starting initial test in 5 secs"
sleep 5
cd $PINTOSDIR && make clean
cd $PINTOSDIR/src/threads && make
cd build && pintos run alarm-multiple