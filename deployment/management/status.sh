#!/bin/bash
dt=$(date '+%d %h %Y %H:%M:%S');
echo "INFO: Hello there, $USER@$HOSTNAME!"
echo "INFO: Script started at $dt"
echo "INFO: Battery Status"
acpi -i
echo -e "INFO: International internet reachability: \c"
wget -q --spider http://google.com
if [ $? -eq 0 ]; then
echo -e "\e[32mPass\e[0m"
else
echo -e "\e[31mFail\e[0m"
fi
echo -e "INFO: Chinese internet reachability: \c"
wget -q --spider http://www.baidu.com
if [ $? -eq 0 ]; then
echo -e "\e[32mPass\e[0m"
else
echo -e "\e[31mFail\e[0m"
fi
echo "INFO: NAT Status"
pystun
