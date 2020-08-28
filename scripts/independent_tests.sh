#!/bin/bash
pyFilePath="./unit_tests/CSE489/testTemplate.py"
echo "INFO: running python script"
python3 $pyFilePath version
echo "INFO: checking revision"
python3 $pyFilePath revision