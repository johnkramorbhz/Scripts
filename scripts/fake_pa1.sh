#!/bin/bash

# This script is for testing python script only!

# Change it to YOUR UBITName and your full legal name.
ubitname="abcde"
fullname="AFFF"
semester="Fall_2020"
personNumber="50308888"
debug="" # Put anything inside "" to set it to be true
timeout=190
quiet="" # Put anything inside "" to set it to be true
# End of personalisation section
pathofpythonscript="./unit_tests/CSE489/testTemplate.py"
pathofbinary="./unit_tests/CSE489/testTemplate_bin"
filename="${ubitname}_pa1.tar"
csvlocation="./unit_tests/CSE489/PA1.csv"
version_number="1.4.4_PA1_opensource"
export ubitname
export fullname
export semester
export debug
export timeout
export quiet
export personNumber
export version_number

python3 $pathofpythonscript prompt
python3 $pathofpythonscript check-required-software
if [ $? -ne 0 ]; then
echo "Make sure UBITname, semester are configured!"
echo "Fail for python version"
exit 1
fi

$pathofbinary prompt
$pathofbinary check-required-software
if [ $? -ne 0 ]; then
echo "Make sure UBITname, semester are configured!"
echo "Fail for binary version"
exit 1
fi
# Launcher
unset ubitname
unset fullname
unset semester
unset debug
unset timeout
unset quiet
unset personNumber
unset version_number