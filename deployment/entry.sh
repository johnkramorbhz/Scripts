#!/bin/bash
dt=$(date '+%d %h %Y %H:%M:%S');
echo "INFO: Hello there, $USER@$HOSTNAME!"
echo "INFO: Script started at $dt"
echo -e "INFO: Getting info about your OS\c"
unameOut="$(uname -s)"
OSID=$(cat /etc/os-release | grep -w "ID")
OSLIKE=$(cat /etc/os-release | grep -w "ID_LIKE")
echo -e "\e[32m done \e[0m"
echo "INFO: Your OS type string: $unameOut, OSID: $OSID, OSLIKE: $OSLIKE"
if [ "$1" = "--update" ]; then
echo "INFO: User choose to update this script to the most current version on the GitHub."
wget -q --spider https://github.com/johnkramorbhz/Scripts/raw/master/deployment/entry.sh
if [ "$?" -eq 0]; then
rm -rf entry.sh
echo -e "INFO: Upgrading... \c"
wget -q https://github.com/johnkramorbhz/Scripts/raw/master/deployment/entry.sh
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
wget -q --spider https://hbai.me/stat
exit_code_stat=$?
wget -q --spider https://github.com/johnkramorbhz/Scripts/raw/master/deployment/entry.sh
exit_code_source=$?
wget -q --spider https://github.com/johnkramorbhz/Scripts/raw/master/deployment/linux_setup/ubuntu_setup.sh
exit_code_source_link=$?
if [ "$exit_code_source" -eq 0 ] || [ "$exit_code_stat" -eq 0 ] || [ "$exit_code_source_link" -eq 0 ] ; then
echo -e "\e[32mPass\e[0m"
else
echo -e "\e[32mFail\e[0m"
echo "ERROR: Please check your internet connection. Please re-run this script when you resolved the problem"
exit 1
fi
if [ "$OSID" = "ID=ubuntu" ] || [ "$OSID" = "ID=debian" ] || [ "$OSLIKE" = "ID_LIKE=debian" ]; then
echo "INFO: Starting installer for Ubuntu systems"
echo "INFO: Checking your release..."
release_name=$(lsb_release -c -s)
if [ $release_name = "bionic" ]; then
wget https://github.com/johnkramorbhz/Scripts/raw/master/deployment/linux_setup/ubuntu_setup.sh
fi
if [ $release_name = "focal" ]; then
wget -O ubuntu_setup.sh https://github.com/johnkramorbhz/Scripts/raw/master/deployment/linux_setup/ubuntu_focal_fossa.sh
fi
wget -q --spider https://hbai.me/deployment-debian
if [ -e "ubuntu_setup.sh" ]; then
if [ "$1" = "--nvidia" ]; then
chmod u+x ubuntu_setup.sh
./ubuntu_setup.sh --nvidia
echo "INFO: Cleaning up..."
rm -rf entry.sh
rm -rf ubuntu_setup.sh
exit 0
fi
if [ "$1" = "--no-GUI" ]; then
chmod u+x ubuntu_setup.sh
./ubuntu_setup.sh --no-GUI
echo "INFO: Cleaning up..."
rm -rf entry.sh
rm -rf ubuntu_setup.sh
exit 0
fi
chmod u+x ubuntu_setup.sh
./ubuntu_setup.sh
echo "INFO: Cleaning up..."
rm -rf entry.sh
rm -rf ubuntu_setup.sh
exit 0
else
echo "INFO: Failed to download from GitHub. Trying alternative site"
wget https://github.com/johnkramorbhz/Scripts/raw/master/deployment/linux_setup/ubuntu_setup.sh
wget -q --spider https://hbai.me/deployment-debian-alternative
if [ -e "ubuntu_setup.sh" ]; then
if [ "$1" = "--nvidia" ]; then
chmod u+x ubuntu_setup.sh
./ubuntu_setup.sh --nvidia
echo "INFO: Cleaning up..."
rm -rf entry.sh
rm -rf ubuntu_setup.sh
exit 0
fi
chmod u+x ubuntu_setup.sh
./ubuntu_setup.sh
echo "INFO: Cleaning up..."
rm -rf entry.sh
rm -rf ubuntu_setup.sh
exit 0
else
echo "ERROR: Failed to download from both GitHub and the alternative site."
echo "Terminating this script..."
rm -rf $0
exit 1
fi
fi
elif [ '$OSID" = "ID="centos"' ] || [ '$OSID" = "ID="rhel"' ]; then
echo "INFO: Starting installer for Red Hat based Linux systems"
wget -O rhel_setup.sh https://hbai.me/deployment-rhel
if [ -e "rhel_setup.sh" ]; then
chmod u+x rhel_setup.sh
./rhel_setup.sh
echo "INFO: Cleaning up..."
rm -rf entry.sh
rm -rf rhel_setup.sh
exit 0
else
echo "INFO: Failed to download from GitHub. Trying alternative site"
wget -O rhel_setup.sh https://hbai.me/deployment-rhel-alternative
if [ -e "rhel_setup.sh" ]; then
chmod u+x rhel_setup.sh
./rhel_setup.sh
echo "INFO: Cleaning up..."
rm -rf entry.sh
rm -rf rhel_setup.sh
exit 0
else
echo "ERROR: Failed to download from both GitHub and the alternative site."
echo "Terminating this script..."
#rm -rf entry.sh
exit 1
fi
fi
else
echo "ERROR: Unsupported Operating Systems"
fi