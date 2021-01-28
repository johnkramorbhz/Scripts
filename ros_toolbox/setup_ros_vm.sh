#!/bin/bash
# Check if it is sudo or root first
echo -e "INFO: Are you running this script as root or sudo? \c"
if [[ $EUID -ne 0 ]]; then
   echo -e "\e[31mNo \e[0m"
   echo "ERROR: This script must be run as root since it installs some packages necessary for deployment"
   echo "INFO: Restart it as 'sudo $0 $1 $2' instead" 
   exit 1
else
echo -e "\e[32mYes \e[0m"
fi
# First up by removing these useless pkgs that are unrelated at all
apt remove -y  --purge libreoffice* rhythmbox cheese remmina gnome-mahjongg gnome-mines gnome-sudoku
apt clean
apt autoremove
