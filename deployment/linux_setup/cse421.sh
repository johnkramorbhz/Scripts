#!/bin/bash
echo "Please only run this ONCE! ONLY USE IT ON UBUNTU BIONIC(18.04), since Ubuntu REMOVES i386 support on the later release!"
if hash pintos 2>/dev/null; then
echo "WARNING: Already installed"
exit 0
fi
echo "export PINTOSDIR=$HOME/pintos" >> $HOME/.bashrc
echo "export BXSHARE=/usr/local/share/bochs" >> $HOME/.bashrc
source  ~/.bashrc
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