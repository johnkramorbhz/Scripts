#!/bin/bash
filename=proj1.pdf
source_file=project1.pdf
if [ -z "$1" ] || [ -z "$2" ]; then
echo "Run this script as $0 ubit_name option"
echo "It supports 'ssh' for login, and 'copy' for copying design doc"
echo "And most importantly, 'submit' for subit the design doc"
echo "Exit!"
exit 1
fi
if [ "$2" = "copy" ]; then
scp ../projects/Design_Doc/$source_file $1@timberlake.cse.buffalo.edu:/home/csdue/$1/$filename
fi
if [ "$2" = "ssh" ]; then
echo "INFO: Logging you in timberlake..."
echo "To submit: 'submit_cse421 $filename'"
ssh $1@timberlake.cse.buffalo.edu
fi
if [ "$2" = "submit" ]; then
md5=($(md5sum $filename))
echo "INFO: Logging you in timberlake..."
echo "Submit using command: 'submit_cse421 $filename'"
echo "$md5"
scp ../projects/Design_Doc/$source_file $1@timberlake.cse.buffalo.edu:/home/csdue/$1/$filename
cat server_command.sh | ssh $1@timberlake.cse.buffalo.edu
fi