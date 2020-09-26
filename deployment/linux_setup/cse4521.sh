#!/bin/bash
# MIT License

# Copyright (c) 2019 johnkramorbhz

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
echo "INFO: Checking your release..."
if [ $(lsb_release -c -s) = "bionic" ]; then
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
sudo apt install libncurses5-dev:i386 libncursesw5-dev:i386 libx11-6:i386 libxpm4:i386 perl build-essential gcc make libcunit1-dev libcunit1-doc libcunit1 wget python qemu xorg-dev libncurses5-dev gdb git
wget https://github.com/johnkramorbhz/Scripts/raw/main/deployment/linux_setup/pintosbin.tar
wget https://github.com/johnkramorbhz/Scripts/raw/main/deployment/linux_setup/ubpintos.tar
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