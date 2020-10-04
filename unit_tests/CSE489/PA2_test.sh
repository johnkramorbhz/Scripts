#!/bin/bash
# MIT License

# Copyright (c) 2019 johnkramorbhz

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
version_number="2.0.9_PA2_opensource"
pathofpythonscript="../framework/testTemplate.py"
pathofbinary="../framework/testTemplate_bin"
checksumFile=""
export version_number
if hash python3 2>/dev/null; then
use_binary=$(python3 $pathofpythonscript determine-whether-binary-is-needed)
else
use_binary="false"
fi
#use_binary="false" #Uncomment this line to force binary
#use_binary="force_script" #Uncomment this line to force Python3 interpreter
if [ "$use_binary" != "false" ]; then
python3 $pathofpythonscript prompt
python3 $pathofpythonscript check-required-software
python3 $pathofpythonscript check-parameter-PA2
if [ $? -ne 0 ]; then
echo "Make sure UBITname, person number, semester are configured!"
exit 1
fi
else
$pathofbinary prompt
$pathofbinary check-required-software
$pathofbinary check-parameter-PA2 ubitname_placeholder semester_placeholder personNumber_placeholder
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
# hosts=$(python3 $pathofpythonscript getHost personNumber_placeholder ubitname_placeholder)
function pinfo(){
    echo -e "\e[36mINFO: $1\e[0m"
}

function cleanup(){
python3 $pathofpythonscript clean-all-binaries
}
function get_checksum(){
md5sum "$1"
}
function version_string_friendly(){
echo "$version_number"
}
function checkErrorCode(){
if [ "$1" -ne 0 ]; then
echo "ERROR: Test script threw an error!"
exit 1
fi
}
# Launcher
if [ "$1" = "--build" ]; then
if [ "$use_binary" != "false" ]; then
python3 $pathofpythonscript build-PA2
else
$pathofbinary build-PA2 ubitname_placeholder
fi
elif [ "$1" = "--compile" ]; then
if [ "$use_binary" != "false" ]; then
python3 $pathofpythonscript compile-PA2 ubitname_placeholder
else
$pathofbinary compile-PA2 ubitname_placeholder
fi
elif [ "$1" = "--clean" ]; then
cleanup
elif [ "$1" = "--test-indv" ]; then
if [ "$2" = "basic" ]; then
if [ "$use_binary" != "false" ]; then
python3 $pathofpythonscript test-indv-PA2 "../framework/PA2_basic.csv" ubitname_placeholder "$3" basic
else
$pathofbinary test-indv-PA2 "../framework/PA2_basic.csv" ubitname_placeholder "$3" basic
fi
elif [ "$2" = "advanced" ]; then
if [ "$use_binary" != "false" ]; then
python3 $pathofpythonscript test-indv-PA2 "../framework/PA2_advanced.csv" ubitname_placeholder "$3" advanced
else
$pathofbinary test-indv-PA2 "../framework/PA2_advanced.csv" ubitname_placeholder "$3" advanced
fi
elif [ "$2" = "sanity" ]; then
if [ "$use_binary" != "false" ]; then
python3 $pathofpythonscript test-indv-PA2 "../framework/PA2_sanity.csv" ubitname_placeholder "$3" sanity
else
$pathofbinary test-indv-PA2 "../framework/PA2_sanity.csv" ubitname_placeholder "$3" sanity
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
python3 $pathofpythonscript test-all-PA2 ubitname_placeholder PA1
else
$pathofbinary test-all-PA2 ubitname_placeholder PA1
fi
cleanup
echo -e "INFO: Test finished on: \c"
date
elif [ "$1" = "--get-host" ]; then
python3 $pathofpythonscript getHost personNumber_placeholder ubitname_placeholder
cleanup
# elif [ "$1" = "--test-file" ]; then
# python3 $pathofpythonscript test-file-PA2 ubitname_placeholder $2
elif [ "$1" = "--test-experiment" ]; then
python3 $pathofpythonscript test-experiment-one ubitname_placeholder
elif [ "$1" = "--run-experiment-1" ]; then
python3 $pathofpythonscript run-experiments-batch "../framework/PA2_experiment1_10_ds.csv" ubitname_placeholder 1
checkErrorCode $?
python3 $pathofpythonscript run-experiments-batch "../framework/PA2_experiment1_50_ds.csv" ubitname_placeholder 1
checkErrorCode $?
python3 $pathofpythonscript add-headers-to-all-files ubitname_placeholder
checkErrorCode $?
elif [ "$1" = "--run-experiment-2" ]; then
python3 $pathofpythonscript run-experiments-batch "../framework/PA2_experiment2_0.2_ds.csv" ubitname_placeholder 2
checkErrorCode $?
python3 $pathofpythonscript run-experiments-batch "../framework/PA2_experiment2_0.5_ds.csv" ubitname_placeholder 2
checkErrorCode $?
python3 $pathofpythonscript run-experiments-batch "../framework/PA2_experiment2_0.8_ds.csv" ubitname_placeholder 2
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
python3 $pathofpythonscript run-experiments-batch "../framework/PA2_experiment1_10_ds.csv" ubitname_placeholder 1
checkErrorCode $?
python3 $pathofpythonscript run-experiments-batch "../framework/PA2_experiment1_50_ds.csv" ubitname_placeholder 1
checkErrorCode $?
python3 $pathofpythonscript run-experiments-batch "../framework/PA2_experiment2_0.2_ds.csv" ubitname_placeholder 2
checkErrorCode $?
python3 $pathofpythonscript run-experiments-batch "../framework/PA2_experiment2_0.5_ds.csv" ubitname_placeholder 2
checkErrorCode $?
python3 $pathofpythonscript run-experiments-batch "../framework/PA2_experiment2_0.8_ds.csv" ubitname_placeholder 2
checkErrorCode $?
python3 $pathofpythonscript add-headers-to-all-files ubitname_placeholder
checkErrorCode $?
elif [ "$1" = "--generate-json-config" ]; then
python3 $pathofpythonscript gc
elif [ "$1" = "--update" ]; then
python3 $pathofpythonscript update
elif [ "$1" = "--compile-binary" ]; then
python3 $pathofpythonscript autocompile
elif [ "$1" = "--version" ]; then
echo -e "INFO: Python script version: \c"
python3 $pathofpythonscript version
echo -e "INFO: Binary version: \c"
$pathofbinary version
else
pinfo "Usage can be found in the README file in GitHub"
echo "https://github.com/johnkramorbhz/Scripts/blob/main/unit_tests/CSE489/usage.md"
fi
unset version_number