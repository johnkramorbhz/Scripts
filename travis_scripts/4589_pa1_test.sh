#!/bin/bash

# This script is for testing python script only!

pathofpythonscript="./unit_tests/CSE489/testTemplate.py"
pathofbinary="./unit_tests/CSE489/testTemplate_bin"
filename="${ubitname}_pa1.tar"
csvlocation="./unit_tests/CSE489/PA1.csv"
version_number="Travis CI test"
export version_number

python3 $pathofpythonscript prompt
python3 $pathofpythonscript check-required-software
if [ $? -ne 0 ]; then
echo "Make sure UBITname, semester are configured!"
echo "Fail for python version"
exit 1
fi
chmod 777 $pathofbinary
$pathofbinary prompt
$pathofbinary check-required-software
if [ $? -ne 0 ]; then
echo "Make sure UBITname, semester are configured!"
echo "Fail for binary version"
exit 1
fi
unset version_number