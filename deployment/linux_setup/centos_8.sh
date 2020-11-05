#!/bin/bash

# Unlike Ubuntu shell scripts, this is a server deployment script.

# Copyright (c) 2020 johnkramorbhz

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
echo -e "INFO: Are you running this script as root or sudo? \c"
if [[ $EUID -ne 0 ]]; then
echo -e "\e[31mNo \e[0m"
echo "ERROR: This script must be run as root since it installs some packages necessary for deployment"
echo "INFO: Restart it as 'sudo $0 $1 $2' instead" 
exit 1
else
echo -e "\e[32mYes \e[0m"
fi
if [ $(cat /etc/centos-release | tr -dc '0-9.'|cut -d \. -f1) = "8" ]; then
dnf update -y
# Enable EPEL repo
dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
# Enable PowerTools since Fedora wiki recommends it.
dnf config-manager --set-enabled PowerTools
# LAMP Stack
dnf install -y php php-opcache php-gd php-curl php-mysqlnd mariadb-server httpd python3 wget htop php-devel php-pear make automake gcc gcc-c++
pecl install imagick
echo "extension=imagick.so" > /etc/php.d/20-imagick.ini
# Allow PHP code to be executed on SELinux, even though it does not solve the problem. 
# It looks like disabling SELinux is necessary.
setsebool -P httpd_execmem 1 
if [ -e "domains.txt" ]; then
wget -O generate_httpd_config.py https://raw.githubusercontent.com/johnkramorbhz/Scripts/main/deployment/linux_setup/generate_httpd_config.py
python3 generate_httpd_config.py --bulk domains.txt centos
apachectl configtest
if [ $? -ne 0 ]; then
echo "ERROR: httpd config test failed"
exit 1
fi
firewall-cmd --permanent --add-service=http
firewall-cmd --reload
systemctl start httpd
systemctl enable httpd
systemctl start mariadb
systemctl enable mariadb
mysql_secure_installation
systemctl restart mariadb
fi
else
# If major version is something else, return this error msg
echo "ERROR: Your CentOS major version is NOT supported by this script."
exit 1
fi
