#!/bin/bash
# Change it to YOUR UBITName and your full legal name.
ubitname=""
fullname=""
semester=""
personNumber=""
debug="" # Put anything inside "" to set it to be true
timeout=190
quiet="" # Put anything inside "" to set it to be true
# End of personalisation section
pathofpythonscript="../framework/testTemplate.py"
pathofbinary="../framework/testTemplate"
filename="${ubitname}_pa1.tar"
csvlocation="../framework/PA1.csv"
version_number="1.4.2_PA1"
export ubitname
export fullname
export semester
export debug
export timeout
export quiet
export personNumber
export version_number
if hash python3 2>/dev/null; then
use_binary=$(python3 $pathofpythonscript determine-whether-binary-is-needed)
else
use_binary="false"
fi
#use_binary="false" #This option allows a static python library to be used. Hence, no need to worry about the python version
use_binary="force"
if hash nc 2>/dev/null; then
echo -e "\c"
else
echo "ERROR: netcat is not found on your system!"
exit 1
fi
if [ "$use_binary" != "false" ]; then
python3 $pathofpythonscript prompt
python3 $pathofpythonscript check-required-software
python3 $pathofpythonscript check-parameter-PA1
if [ $? -ne 0 ]; then
echo "Make sure UBITname, semester are configured!"
exit 1
fi
else
echo "INFO: Showing the following line means python binary cannot use exit() function"
echo "NameError: name 'exit' is not defined" 
echo "INFO: Auto Test will start in 2 seconds"
sleep 2
$pathofbinary prompt
$pathofbinary check-required-software
$pathofbinary check-parameter-PA1
if [ $? -ne 0 ]; then
echo "Make sure UBITname, semester are configured!"
exit 1
fi
fi
if [ "$use_binary" != "false" ]; then
python3 $pathofpythonscript check-PA1-grader-cfg
if [ $? -ne 0 ]; then
exit 1
fi
else
$pathofbinary check-PA1-grader-cfg
if [ $? -ne 0 ]; then
exit 1
fi
fi
function pinfo(){
    echo -e "\e[36mINFO: $1\e[0m"
}
function cleanup(){
python3 $pathofpythonscript clean-all-binaries
}
function get_checksum(){
md5sum $1
}
# Launcher
if [ "$1" = "--submit" ]; then
pinfo "Building tarball for $ubitname"
if [ "$use_binary" != "false" ]; then
python3 $pathofpythonscript build-PA1 $ubitname
else
$pathofbinary build-PA1 $ubitname
fi
elif [ "$1" = "--build" ]; then
if [ "$use_binary" != "false" ]; then
python3 $pathofpythonscript build-PA1 $ubitname
else
$pathofbinary build-PA1 $ubitname
fi
elif [ "$1" = "--compile" ]; then
if [ "$use_binary" != "false" ]; then
python3 $pathofpythonscript compile-PA1 $ubitname
else
$pathofbinary compile-PA1 $ubitname
fi
elif [ "$1" = "--clean" ]; then
cleanup
elif [ "$1" = "--test-indv" ]; then
if [ "$use_binary" != "false" ]; then
python3 $pathofpythonscript test-indv-PA1 $csvlocation $ubitname $2
cleanup
echo "INFO: Test finished on:"
date
else
$pathofbinary test-indv-PA1 $csvlocation $ubitname $2
cleanup
echo "INFO: Test finished on:"
date
fi
elif [ "$1" = "--test-score" ]; then
if [ "$use_binary" != "false" ]; then
python3 $pathofpythonscript test-all-PA1 $csvlocation $ubitname PA1
cleanup
echo "INFO: Test finished on:"
date
else
$pathofbinary test-all-PA1 $csvlocation $ubitname PA1
cleanup
echo "INFO: Test finished on:"
date
fi
elif [ "$1" = "--test-all" ]; then
if [ "$use_binary" != "false" ]; then
python3 $pathofpythonscript test-all-PA1 $csvlocation $ubitname PA1
cleanup
echo "INFO: Test finished on:"
date
else
$pathofbinary test-all-PA1 $csvlocation $ubitname PA1
cleanup
echo "INFO: Test finished on:"
date
fi
elif [ "$1" = "--repeat" ]; then
if [ "$use_binary" != "false" ]; then
python3 $pathofpythonscript repeat-PA1 $csvlocation $ubitname $2 $3 PA1
cleanup
echo "INFO: Test finished on:"
date
else
$pathofbinary repeat-PA1 $csvlocation $ubitname $2 $3 PA1
cleanup
echo "INFO: Test finished on:"
date
fi
elif [ "$1" = "--repeat-all" ]; then
if [ "$use_binary" != "false" ]; then
python3 $pathofpythonscript repeat-test-all-PA1 $csvlocation $ubitname PA1 $2
cleanup
echo "INFO: Test finished on:"
date
else
$pathofbinary repeat-test-all-PA1 $csvlocation $ubitname PA1 $2
cleanup
echo "INFO: Test finished on:"
date
fi
elif [ "$1" = "--clean-all" ]; then
if [ "$use_binary" != "false" ]; then
python3 $pathofpythonscript clean-all-binaries
else
$pathofbinary clean-all-binaries
fi
elif [ "$1" = "--test-shell" ]; then
python3 $pathofpythonscript retrieve-sys-info
elif [ "$1" = "--verify-config" ]; then
if [ "$use_binary" != "false" ]; then
python3 $pathofpythonscript check-PA1-grader-cfg
else
$pathofbinary check-PA1-grader-cfg
fi
elif [ "$1" = "--compile-binary" ]; then
python3 $pathofpythonscript autocompile
else
pinfo "Usage can be found in the README file in GitHub"
fi
unset ubitname
unset fullname
unset semester
unset debug
unset timeout
unset quiet
unset personNumber
unset version_number