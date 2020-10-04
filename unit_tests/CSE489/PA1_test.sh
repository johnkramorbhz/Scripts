#!/bin/bash
pathofpythonscript="../framework/testTemplate.py"
pathofbinary="../framework/testTemplate_bin"
csvlocation="../framework/PA1.csv"
version_number="1.4.7_PA1_opensource"
export version_number
if hash python3 2>/dev/null; then
use_binary=$(python3 $pathofpythonscript determine-whether-binary-is-needed)
else
use_binary="false"
fi
#use_binary="false" #Uncomment this line to force binary
#use_binary="force_script" #Uncomment this line to force Python3 interpreter
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
$pathofbinary prompt
$pathofbinary check-required-software
$pathofbinary check-parameter-PA1
if [ $? -ne 0 ]; then
echo "Make sure UBITname, semester are configured!"
exit 1
fi
fi
function config_check(){
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
}
function pinfo(){
    echo -e "\e[36mINFO: $1\e[0m"
}
function cleanup(){
python3 $pathofpythonscript clean-all-binaries
}
function get_checksum(){
md5sum "$1"
}
# Launcher
if [ "$1" = "--submit" ]; then
pinfo "Building tarball for placeholder_ubitname"
if [ "$use_binary" != "false" ]; then
python3 $pathofpythonscript build-PA1 placeholder_ubitname
else
$pathofbinary build-PA1 placeholder_ubitname
fi
elif [ "$1" = "--build" ]; then
if [ "$use_binary" != "false" ]; then
python3 $pathofpythonscript build-PA1 placeholder_ubitname
else
$pathofbinary build-PA1 placeholder_ubitname
fi
elif [ "$1" = "--compile" ]; then
if [ "$use_binary" != "false" ]; then
python3 $pathofpythonscript compile-PA1 placeholder_ubitname
else
$pathofbinary compile-PA1 placeholder_ubitname
fi
elif [ "$1" = "--clean" ]; then
cleanup
elif [ "$1" = "--test-indv" ]; then
config_check
if [ "$use_binary" != "false" ]; then
python3 $pathofpythonscript test-indv-PA1 $csvlocation placeholder_ubitname "$2"
cleanup
echo "INFO: Test finished on:"
date
else
$pathofbinary test-indv-PA1 $csvlocation placeholder_ubitname "$2"
cleanup
echo "INFO: Test finished on:"
date
fi
elif [ "$1" = "--test-score" ]; then
config_check
if [ "$use_binary" != "false" ]; then
python3 $pathofpythonscript test-all-PA1 $csvlocation placeholder_ubitname PA1
cleanup
echo "INFO: Test finished on:"
date
else
$pathofbinary test-all-PA1 $csvlocation placeholder_ubitname PA1
cleanup
echo "INFO: Test finished on:"
date
fi
elif [ "$1" = "--test-all" ]; then
config_check
if [ "$use_binary" != "false" ]; then
python3 $pathofpythonscript test-all-PA1 $csvlocation placeholder_ubitname PA1
cleanup
echo "INFO: Test finished on:"
date
else
$pathofbinary test-all-PA1 $csvlocation placeholder_ubitname PA1
cleanup
echo "INFO: Test finished on:"
date
fi
elif [ "$1" = "--repeat" ]; then
config_check
if [ "$use_binary" != "false" ]; then
python3 $pathofpythonscript repeat-PA1 $csvlocation placeholder_ubitname "$2" "$3" PA1
cleanup
echo "INFO: Test finished on:"
date
else
$pathofbinary repeat-PA1 $csvlocation placeholder_ubitname "$2" "$3" PA1
cleanup
echo "INFO: Test finished on:"
date
fi
elif [ "$1" = "--repeat-all" ]; then
config_check
if [ "$use_binary" != "false" ]; then
python3 $pathofpythonscript repeat-test-all-PA1 $csvlocation placeholder_ubitname PA1 "$2"
cleanup
echo "INFO: Test finished on:"
date
else
$pathofbinary repeat-test-all-PA1 $csvlocation placeholder_ubitname PA1 "$2"
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
elif [ "$1" = "--AIS" ]; then
if [ "$use_binary" != "false" ]; then
python3 $pathofpythonscript clean-all-binaries
else
$pathofbinary clean-all-binaries
fi
if [ "$use_binary" != "false" ]; then
python3 $pathofpythonscript compile-PA1 placeholder_ubitname
else
$pathofbinary compile-PA1 placeholder_ubitname
fi
if [ "$use_binary" != "false" ]; then
python3 $pathofpythonscript test-AIS-PA1
else
$pathofbinary test-AIS-PA1
fi
elif [ "$1" = "--generate-json-config" ]; then
python3 $pathofpythonscript gc
elif [ "$1" = "--update" ]; then
python3 $pathofpythonscript update
else
pinfo "Usage can be found in the README file in GitHub"
fi
unset version_number