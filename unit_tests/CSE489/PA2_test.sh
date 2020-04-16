#!/bin/bash
# Change it to YOUR UBITName and your full legal name.
ubitname=""
fullname=""
semester=""
personNumber=""
debug="" # Put anything inside "" to set it to be true
suppressHeader="" # Put anything inside "" to set it to be true
quiet="" # Put anything inside "" to set it to be true
timeout=200
# End of personalisation section

filename="${ubitname}_pa2.tar"
version_number="2.0.5_PA2_opensource"
pathofpythonscript="../framework/testTemplate.py"
pathofbinary="../framework/testTemplate_bin"
checksumFile=""
export ubitname
export fullname
export semester
export debug
export suppressHeader
export timeout
export personNumber
export quiet
export version_number
if hash python3 2>/dev/null; then
use_binary=$(python3 $pathofpythonscript determine-whether-binary-is-needed)
else
use_binary="false"
fi
#use_binary="false" #This line allows a static python library to be used. Hence, no need to worry about the python version
#use_binary="force_script" #Uncomment this line to force Python3 interpreter
if [ "$use_binary" != "false" ]; then
python3 $pathofpythonscript prompt
python3 $pathofpythonscript check-required-software
python3 $pathofpythonscript check-parameter-PA2 $ubitname $semester $personNumber
if [ $? -ne 0 ]; then
echo "Make sure UBITname, person number, semester are configured!"
exit 1
fi
else
$pathofbinary prompt
$pathofbinary check-required-software
$pathofbinary check-parameter-PA2 $ubitname $semester $personNumber
if [ $? -ne 0 ]; then
echo "Make sure UBITname, person number, semester are configured!"
exit 1
fi
fi
if [ "$use_binary" != "false" ]; then
python3 $pathofpythonscript pre-auth
if [ $? -ne 0 ]; then
echo "ERROR: You are not allowed to use this version of the test script!"
echo "INFO:  Use the open source version instead!"
exit 1
fi
else
$pathofbinary pre-auth
if [ $? -ne 0 ]; then
echo "ERROR: You are not allowed to use this version of the test script!"
echo "INFO:  Use the open source version instead!"
exit 1
fi
fi
hosts=$(python3 $pathofpythonscript getHost $personNumber $ubitname)
function pinfo(){
    echo -e "\e[36mINFO: $1\e[0m"
}

function cleanup(){
python3 $pathofpythonscript clean-all-binaries
}
function get_checksum(){
md5sum $1
}
function version_string_friendly(){
echo "$version_number"
}
function checkErrorCode(){
if [ $1 -ne 0 ]; then
echo "ERROR: Test script threw an error!"
exit 1
fi
}
# Launcher
if [ "$1" = "--submit" ]; then
pinfo "Building tarball for $ubitname"
python3 $pathofpythonscript build-PA2 $ubitname
python3 $pathofpythonscript checksum $filename
elif [ "$1" = "--build" ]; then
if [ "$use_binary" != "false" ]; then
python3 $pathofpythonscript build-PA2 $ubitname
else
$pathofbinary build-PA2 $ubitname
fi
elif [ "$1" = "--compile" ]; then
if [ "$use_binary" != "false" ]; then
python3 $pathofpythonscript compile-PA2 $ubitname
else
$pathofbinary compile-PA2 $ubitname
fi
elif [ "$1" = "--clean" ]; then
cleanup
elif [ "$1" = "--test-indv" ]; then
if [ "$2" = "basic" ]; then
if [ "$use_binary" != "false" ]; then
python3 $pathofpythonscript test-indv-PA2 "../framework/PA2_basic.csv" $ubitname $3 basic
else
$pathofbinary test-indv-PA2 "../framework/PA2_basic.csv" $ubitname $3 basic
fi
elif [ "$2" = "advanced" ]; then
if [ "$use_binary" != "false" ]; then
python3 $pathofpythonscript test-indv-PA2 "../framework/PA2_advanced.csv" $ubitname $3 advanced
else
$pathofbinary test-indv-PA2 "../framework/PA2_advanced.csv" $ubitname $3 advanced
fi
elif [ "$2" = "sanity" ]; then
if [ "$use_binary" != "false" ]; then
python3 $pathofpythonscript test-indv-PA2 "../framework/PA2_sanity.csv" $ubitname $3 sanity
else
$pathofbinary test-indv-PA2 "../framework/PA2_sanity.csv" $ubitname $3 sanity
fi
else
echo "ERROR: Cannot find your test type!"
echo "['basic', 'advanced', 'sanity'] are available to test. You may run the example below..."
echo "./test.sh --test-indv basic ABT"
fi
cleanup
echo -e "INFO: Test finished on: \c"
date
elif [ "$1" = "--test-basic" ]; then
if [ "$use_binary" != "false" ]; then
python3 $pathofpythonscript test-category-PA2 basic
else
$pathofbinary test-category-PA2 basic
fi
cleanup
echo -e "INFO: Test finished on: \c"
date
elif [ "$1" = "--test-advanced" ]; then
if [ "$use_binary" != "false" ]; then
python3 $pathofpythonscript test-category-PA2 advanced
else
$pathofbinary test-category-PA2 advanced
fi
cleanup
echo -e "INFO: Test finished on: \c"
date
elif [ "$1" = "--test-sanity" ]; then
if [ "$use_binary" != "false" ]; then
python3 $pathofpythonscript test-category-PA2 sanity
else
$pathofbinary test-category-PA2 sanity
fi
cleanup
echo -e "INFO: Test finished on: \c"
date
elif [ "$1" = "--test-all" ]; then
if [ "$use_binary" != "false" ]; then
python3 $pathofpythonscript test-all-PA2 $ubitname PA1
else
$pathofbinary test-all-PA2 $ubitname PA1
fi
cleanup
echo -e "INFO: Test finished on: \c"
date
elif [ "$1" = "--get-host" ]; then
python3 $pathofpythonscript getHost $personNumber $ubitname
cleanup
elif [ "$1" = "--get-checksum" ]; then
python3 $pathofpythonscript checksum "../cse489589_assignment2/$filename" $ubitname
elif [ "$1" = "--test-file" ]; then
python3 $pathofpythonscript test-file-PA2 $ubitname $2
elif [ "$1" = "--test-experiment" ]; then
python3 $pathofpythonscript test-experiment-one $ubitname
elif [ "$1" = "--run-experiment-1" ]; then
python3 $pathofpythonscript run-experiments-batch "../framework/PA2_experiment1_10_ds.csv" $ubitname 1
checkErrorCode $?
python3 $pathofpythonscript run-experiments-batch "../framework/PA2_experiment1_50_ds.csv" $ubitname 1
checkErrorCode $?
python3 $pathofpythonscript add-headers-to-all-files $ubitname
checkErrorCode $?
elif [ "$1" = "--run-experiment-2" ]; then
python3 $pathofpythonscript run-experiments-batch "../framework/PA2_experiment2_0.2_ds.csv" $ubitname 2
checkErrorCode $?
python3 $pathofpythonscript run-experiments-batch "../framework/PA2_experiment2_0.5_ds.csv" $ubitname 2
checkErrorCode $?
python3 $pathofpythonscript run-experiments-batch "../framework/PA2_experiment2_0.8_ds.csv" $ubitname 2
checkErrorCode $?
python3 $pathofpythonscript add-headers-to-all-files
checkErrorCode $?
elif [ "$1" = "--trim-all-reports" ]; then
python3 $pathofpythonscript trim-all-reports
checkErrorCode $?
elif [ "$1" = "--trim-all-headers" ]; then
python3 $pathofpythonscript trim-all-headers
checkErrorCode $?
elif [ "$1" = "--add-all-headers" ]; then
python3 $pathofpythonscript add-headers-to-all-files
checkErrorCode $?
elif [ "$1" = "--clean-all" ]; then
python3 $pathofpythonscript clean-all-binaries
elif [ "$1" = "--run-all-experiments" ]; then
python3 $pathofpythonscript run-experiments-batch "../framework/PA2_experiment1_10_ds.csv" $ubitname 1
checkErrorCode $?
python3 $pathofpythonscript run-experiments-batch "../framework/PA2_experiment1_50_ds.csv" $ubitname 1
checkErrorCode $?
python3 $pathofpythonscript run-experiments-batch "../framework/PA2_experiment2_0.2_ds.csv" $ubitname 2
checkErrorCode $?
python3 $pathofpythonscript run-experiments-batch "../framework/PA2_experiment2_0.5_ds.csv" $ubitname 2
checkErrorCode $?
python3 $pathofpythonscript run-experiments-batch "../framework/PA2_experiment2_0.8_ds.csv" $ubitname 2
checkErrorCode $?
python3 $pathofpythonscript add-headers-to-all-files $ubitname
checkErrorCode $?
elif [ "$1" = "--compile-binary" ]; then
python3 $pathofpythonscript autocompile
elif [ "$1" = "--version" ]; then
echo -e "INFO: Python script version: \c"
python3 $pathofpythonscript version
echo -e "INFO: Binary version: \c"
$pathofbinary version
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