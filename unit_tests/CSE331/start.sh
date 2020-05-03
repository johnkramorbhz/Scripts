#!/bin/bash
# MIT License

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

# Version modified on 2019-07-10 

# extension is for beta only!
# Do not edit these parameters!
version=2.4
extension=0.1
beta=true
version_serversideURL="https://github.com/johnkramorbhz/Scripts/raw/master/versions/CSE331shell_version"
projectURL="https://github.com/johnkramorbhz/Scripts/"
fileURL="https://github.com/johnkramorbhz/Scripts/raw/master/unit_tests/CSE331/start.sh"
binary_name="a.out"
# End of parameters

# Prerequisite checks
wget_exists=false
gpp_exists=false
valgrind_exists=false
python3_exists=false
java_exists=false
javac_exists=false
# End of prerequisite checks
function prerequisite_check(){
if hash g++ 2>/dev/null; then
gpp_exists=true
fi
if hash wget 2>/dev/null; then
wget_exists=true
fi
if hash valgrind 2>/dev/null; then
valgrind_exists=true
fi
}
function print_prerequisite_check_results(){
echo "g++ $gpp_exists"
echo "wget $wget_exists"
echo "valgrind $valgrind_exists"
}
if [ "$1" = "--version" ]; then
echo "version $version, extension $extension"
exit $?
fi
if [ "$1" = "--version-friendly" ]; then
echo "$version"
exit $?
fi
if [ "$1" = "--version-ext" ]; then
echo "$extension"
exit $?
fi
if [ "$1" = "--status" ]; then
if [ "$beta" = true]; then
echo "Beta channel"
else
echo "Stable channel"
fi
exit $?
fi
function cleanup(){
rm -rf version_server
rm -rf extension_server
rm -rf extension_server.ver
rm -rf version_server.ver
rm -rf a.out
rm -rf $binary_name
}

# Regular update function
if [ "$1" = "--update" ]; then
prerequisite_check
if [ $wget_exists != true ]; then
echo "ERROR: wget does NOT exist! Exiting..."
echo "Updater requires wget as a prerequisite"
echo "You must have wget with Ubuntu 18.04 or later ready!"
exit 1
fi
if [ $beta = true ]; then
echo "enrolled in beta channel"
wget -O version_server.ver -q $version_serversideURL
if [ "`$0 --version-friendly`" != "`sed '2!d' version_server.ver`" ]; then
echo "Upgrade is needed."
echo -e "INFO: Upgrading... \c"
rm -rf $0
wget -O $0 -q $fileURL
cleanup
echo "done"
exit 0
else
if [ "`$0 --version-ext`" != "`sed '3!d' version_server.ver`" ]; then
echo "New Upgrade in beta channel is needed."
prerequisite_check
print_prerequisite_check_results
echo -e "INFO: Upgrading... \c"
rm -rf $0
wget -O $0 -q $fileURL
cleanup
echo "done"
./$0
exit 0
else
echo "Most current beta version"
prerequisite_check
print_prerequisite_check_results
cleanup
exit 0
fi
fi
else
echo "stable"
wget -O version_server -q $version_serversideURL
#echo $?
if [ "`$0 --version-friendly`" != "`sed '2!d' version_server.ver`" ]; then
echo "Upgrade is needed."
prerequisite_check
if [ $wget_exists != true ]; then
echo "ERROR: wget does NOT exist! Exiting..."
echo "You must have wget with Ubuntu 18.04 or later ready!"
exit 1
fi
print_prerequisite_check_results
echo -e "INFO: Upgrading... \c"
rm -rf $0
wget -O $0 -q $fileURL
cleanup
echo "done"
./$0
exit 0
else
echo "INFO: No need to update since you have the newest stable version of this Script."
prerequisite_check
print_prerequisite_check_results
cleanup
exit 0
fi
fi

fi
# Force update function
if [ "$1" = "--force-update" ]; then
echo -e "INFO: Checking if wget presents \c"
if hash wget 2>/dev/null; then
echo -e "\e[32mPresents\e[0m"
else
echo -e "\e[32mDo NOT present\e[0m"
echo "Upgrade failed due to lack of wget, which is a prerequisite."
exit 1
fi
echo "INFO: Replacing this script with what's available on the GitHub"
echo -e "INFO: Checking Internet connectivity \c"
wget -q --spider https://hbai.me/stat
exit_code_stat=$?
wget -q --spider https://hbai.me/newer331shell
exit_code_source=$?
wget -q --spider $fileURL
exit_code_source_link=$?
if [ "$exit_code_source" -eq 0 ] || [ "$exit_code_stat" -eq 0 ] || [ "$exit_code_source_link" -eq 0 ] ; then
echo -e "\e[32mPass\e[0m"
else
echo -e "\e[32mFail\e[0m"
echo "ERROR: Please check your internet connection. Please re-run this script when you resolved the problem"
exit 1
fi
echo -e "INFO: Upgrading... \c"
rm -rf $0
wget -O $0 -q $fileURL
echo "done"
clear
echo "INFO: Successfully upgraded this script. Running this shell script."
./$0
exit 0
fi

# Actual tests
prerequisite_check
case1="testcases/input1.txt"
case2="testcases/input2.txt"
case5="testcases/input5.txt"
customcase="testcases/dummy.txt"
dt=$(date '+%d %h %Y %H:%M:%S');
echo "CSE331 Automated test script"
echo "Author: Hanzhang Bai"
echo "Copyright sxht4 2019 under MIT Licence"
echo "INFO: Hello there, $USER@$HOSTNAME"
echo "INFO: Script started at $dt"

if [ $gpp_exists = true ]; then
g++ --version | head -4
else
echo "ERROR: C++ Compiler does NOT exist! Exiting..."
echo "You must have g++ with Ubuntu 18.04 or later ready!"
exit 1
fi
if [ $valgrind_exists = true ]; then
valgrind --version
else
echo "ERROR: valgrind does NOT exist! Exiting..."
echo "You must have valgrind with Ubuntu 18.04 or later ready!"
exit 1
fi
echo -e "INFO: Checking if Atri's testcases presents? \c"
if [[ -d testcases ]] && [[ -d outputs ]] && [[ -e "$case1" ]] && [ -e "$case2" ] && [ -e "$case5" ]; then
    echo -e "\e[32mYes \e[0m"
else
    echo -e "\e[31mNo \e[0m"
    echo -e 'ERROR: Either "testcases" OR "outputs" do not present.\nYou need to make sure all files are present in the correct folder! \nYou might put it in the wrong folder!\nERROR: Unable to start compiler and tester!' 
    echo 'INFO: Put this script where you can see Solution.cpp and two folders called "testcases" and "outputs" respectively'
    exit 1
fi
if [ -e "$binary_name" ];
then
echo -e '\e[33mWARNING: Cleaning up "\c'
echo -e "$binary_name\c"
echo -e '". You have leftover!\e[0m'
cleanup
fi
echo "INFO: Compiling"
STARTTIMEC=`date +%s.%N`
g++ -Wall -std=c++11 -O2 -o $binary_name Driver.cpp
ENDTIMEC=`date +%s.%N`
TIMEDIFFC=`echo "$ENDTIMEC - $STARTTIMEC" | bc | awk -F"." '{print $1"."substr($2,1,11)}'`
echo -e "INFO: Compiles successifully? \c"
if [ -e "a.out" ];
then
echo -e "\e[32mYes\e[0m\c"
echo ", and it takes $TIMEDIFFC second(s) to compile"
echo "INFO: Running Program"
else
echo -e "\e[31mNo\e[0m"
echo "ERROR: Failed to compile, exiting..."
echo "You may refer to error messages from g++ to fix the problem"
exit 1
fi
function performance_test(){
echo -e "INFO: Starting performance test. Please wait... \c"
STARTTIMEPRGM=`date +%s.%N`
./$binary_name $case1 > /dev/null 2>&1
./$binary_name $case2 > /dev/null 2>&1
./$binary_name $case5 > /dev/null 2>&1
ENDTIMEPRGM=`date +%s.%N`
TIMEDIFFPRGM=`echo "$ENDTIMEPRGM - $STARTTIMEPRGM" | bc | awk -F"." '{print $1"."substr($2,1,11)}'`
echo "done"
echo "INFO: Runtime combined for 'testcase 1', 'testcase 2', and 'testcase 5' are $TIMEDIFFPRGM"
}
function check_exit_code(){
ENDTIMEPRGM=`date +%s.%N`
TIMEDIFFPRGM=`echo "$ENDTIMEPRGM - $STARTTIMEPRGM" | bc | awk -F"." '{print $1"."substr($2,1,11)}'`
echo -e "\e[33m========================================================\e[0m"
if [ "$1" != "$2" ]; then
echo "INFO: Exit code $1, expected $2, use valgrind? $3, runtime $TIMEDIFFPRGM"
echo -e "\e[31mERROR: There might be some mistake or inproper configureation!\e[0m"
if [ "$3" = true ]; then
echo "INFO: Analysing memory leak is enabled for $4"
valgrind --log-fd=9 ./$4 $5 $6 $7 $8 $9 1>/dev/null
fi
echo "INFO: Terminating testing script"
exit $1
else
echo "INFO: Exit codes returned as expected, runtime $TIMEDIFFPRGM"
#echo "INFO: Exit code $1, expected $2, use valgrind? $3, runtime $TIMEDIFFPRGM"
fi
}
function print_runner_info(){
#echo "INFO: $1"
echo -e "\e[33m********************************************************\e[0m"
}
function run(){
echo -e "INFO: You can use \e[5m[Control] + [Z]\e[25m to cancel at anytime!"
read -sp "INFO: $2" 
echo ''
#print_runner_info $2
STARTTIMEPRGM=`date +%s.%N`
./$binary_name $1
check_exit_code $? 0 true ./$binary_name $1
}
if [ -e "$customcase" ]; then
echo "INFO: There exist a custom case!"
echo -e "INFO: You can use \e[5m[Control] + [Z]\e[25m to cancel at anytime! Type anything to start custom testcase"
read -sp 'INFO: Start custom case? ' val
echo ''
if [ -z "$val" ]; then
echo "INFO: User choose to ignore this testcase, continue on Atri's cases"
else
print_runner_info "Running custom case"
STARTTIMEPRGM=`date +%s.%N`
./$binary_name $customcase
check_exit_code $? 0 true ./$binary_name $customcase
fi
fi
run $case1 "Running the first case" 
run $case2 "Running the second case" 
run $case5 "Running the fifth case" 
performance_test
echo -e 'INFO: Cleaning up...\c '
cleanup
echo " done"