#!/bin/bash
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
wget https://swift.org/builds/swift-5.3-release/ubuntu2004/swift-5.3-RELEASE/swift-5.3-RELEASE-ubuntu20.04.tar.gz
tar xzf swift-5.3-RELEASE-ubuntu20.04.tar.gz && rm -rf /usr/share/swift && mv -f swift-5.3-RELEASE-ubuntu20.04 /usr/share/swift && echo "export PATH=/usr/share/swift/usr/bin:$PATH" >> /etc/bash.bashrc && source /etc/bash.bashrc
