#!/bin/bash
# MIT License

# Copyright (c) 2018-2021 johnkramorbhz

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
echo "Last Updated at 2021-08-09 22:17"
sleep 3
echo "INFO: Hello there, $USER@$HOSTNAME!"
echo -e "INFO: Script started at $(date '+%d %h %Y %H:%M:%S')"
echo -e "INFO: Getting info about your OS\c"
OSID=$(cat /etc/os-release | grep -w "ID")
echo -e "\e[32m done \e[0m"
echo -e "INFO: Your OS type string: $(uname -s), OSID: $(cat /etc/os-release | grep -w "ID"), OSLIKE: $(cat /etc/os-release | grep -w "ID_LIKE")"
function warning_eol(){
echo "WARNING: This distro is having less than a year of support."
echo "Process will continue in 15 seconds"
sleep 15
}
function end_of_life(){
echo "WARNING: This distro is marked as EOL. You should only continue installation if you know what you are doing."
echo "Press [ENTER] to continue."
read -r
}
if [ "$1" = "--update" ]; then
echo "INFO: User choose to update this script to the most current version on the GitHub."
wget -q --spider https://github.com/johnkramorbhz/Scripts/raw/main/deployment/entry.sh
if [ "$?" -eq 0 ]; then
rm -rf entry.sh
echo -e "INFO: Upgrading... \c"
wget -q https://github.com/johnkramorbhz/Scripts/raw/main/deployment/entry.sh
echo "done"
./entry.sh
exit 0
else
echo "ERROR: Failed to update. Terminating this script."
exit 1
fi
fi
echo -e "INFO: Are you running this script as root or sudo? \c"
if [[ $EUID -ne 0 ]]; then
   echo -e "\e[31mNo \e[0m"
   echo "ERROR: This script must be run as root since it installs some packages necessary for deployment"
   echo "INFO: Restart it as 'sudo $0 $1 $2' instead" 
   exit 1
else
echo -e "\e[32mYes \e[0m"
fi
echo -e "INFO: Checking if wget presents \c"
if hash wget 2>/dev/null; then
echo -e "\e[32mPresents\e[0m"
else
echo -e "\e[32mDo NOT present\e[0m"
echo "Upgrade failed due to lack of wget, which is a prerequisite."
exit 1
fi
echo "INFO: Replacing entry.sh with what's available on the GitHub"
echo -e "INFO: Checking Internet connectivity \c"
wget -q --spider https://github.com/johnkramorbhz/Scripts/raw/main/deployment/entry.sh
exit_code_source=$?
wget -q --spider https://github.com/johnkramorbhz/Scripts/raw/main/deployment/linux_setup/ubuntu_bionic.sh
exit_code_source_link=$?
if [ "$exit_code_source" -eq 0 ] || [ "$exit_code_source_link" -eq 0 ] ; then
echo -e "\e[32mPass\e[0m"
else
echo -e "\e[32mFail\e[0m"
echo "ERROR: Please check your internet connection. Please re-run this script when you resolved the problem"
exit 1
fi
if [ "$(cat /etc/os-release | grep -w "ID")" = "ID=ubuntu" ]; then
echo "INFO: Starting installer for Ubuntu systems"
echo "INFO: Checking your release..."
if [ -e ubuntu_setup.sh ]; then
rm -rf ubuntu_setup.sh*
fi
wget -O ubuntu_setup.sh https://github.com/johnkramorbhz/Scripts/raw/main/deployment/linux_setup/ubuntu_$(lsb_release -c -s).sh
if [ "$?" -ne 0 ]; then
# Not supported release
echo "ERROR: Your Ubuntu release is not supported."
lsb_release -a
exit 1
fi
if [ -e "ubuntu_setup.sh" ]; then
if [ "$1" = "--nvidia" ]; then
bash ./ubuntu_setup.sh --nvidia
echo "INFO: Cleaning up installation scripts..."
rm -rf entry.sh
rm -rf ubuntu_setup.sh
exit 0
fi
if [ "$1" = "--no-GUI" ]; then
bash ./ubuntu_setup.sh --no-GUI
echo "INFO: Cleaning up installation scripts..."
rm -rf entry.sh
rm -rf ubuntu_setup.sh
exit 0
fi
bash ./ubuntu_setup.sh --full-pkgs
echo "INFO: Cleaning up installation scripts..."
rm -rf entry.sh
rm -rf ubuntu_setup.sh
rm -rf "$0"
exit 0
else
echo "ERROR: Failed to download"
exit 1
fi
# Only CentOS is officially supported
elif [ "$OSID" = "ID=\"centos\"" ]; then
echo -e "INFO: Starting installer for CentOS $(cat /etc/centos-release | tr -dc '0-9.'|cut -d \. -f1)"
wget -O centos_setup.sh https://github.com/johnkramorbhz/Scripts/raw/main/deployment/linux_setup/centos_$(cat /etc/centos-release | tr -dc '0-9.'|cut -d \. -f1).sh
if [ "$?" -ne 0 ]; then
echo "ERROR: Your CentOS version is not supported."
echo -e "Your major version is $(cat /etc/centos-release | tr -dc '0-9.'|cut -d \. -f1), and I support 8 at this time."
exit 1
fi
# As CentOS announced in 8th December 2020, CentOS 8 retires at the end of 2021.
# https://blog.centos.org/2020/12/future-is-centos-stream/
warning_eol
if [ -e "centos_setup.sh" ]; then
bash ./centos_setup.sh
echo "INFO: Cleaning up..."
rm -rf entry.sh
rm -rf centos_setup.sh
exit 0
else
echo "INFO: Failed to download from GitHub!"
exit 1
fi
else
echo "ERROR: Unsupported Operating Systems"
fi
