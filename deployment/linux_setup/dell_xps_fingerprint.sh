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
if [ "$(lsb_release -c -s)" = "focal" ]; then
sh -c 'cat > /etc/apt/sources.list.d/focal-dell.list << EOF
deb http://dell.archive.canonical.com/updates/ focal-dell public
# deb-src http://dell.archive.canonical.com/updates/ focal-dell public

deb http://dell.archive.canonical.com/updates/ focal-oem public
# deb-src http://dell.archive.canonical.com/updates/ focal-oem public

deb http://dell.archive.canonical.com/updates/ focal-somerville public
# deb-src http://dell.archive.canonical.com/updates/ focal-somerville public

deb http://dell.archive.canonical.com/updates/ focal-somerville-melisa public
# deb-src http://dell.archive.canonical.com/updates focal-somerville-melisa public
EOF'
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F9FDA6BED73CDC22
apt update
apt install oem-somerville-melisa-meta libfprint-2-tod1-goodix oem-somerville-meta tlp-config -y
else
echo "This script is only intended for Ubuntu 20.04 LTS"
echo "Exit this script for your safety"
exit 1
fi