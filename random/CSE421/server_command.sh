#!/bin/bash
filename=proj1.pdf
source_file=project1.pdf
if [ -e "$filename" ]; then
md5=($(md5sum $filename))
echo "$md5"
echo "Make sure these two MD5 value matches! Press any key to continue submission"
read -sp
submit_cse421 $filename
rm -rf $filename
else
echo "ERROR: File does not exist..."
fi