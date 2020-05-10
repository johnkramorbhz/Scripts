#!/bin/bash
function clean_all(){
rm -rf Ch*
rm -rf overview*
rm -rf Mid*
rm -rf *.ppt
rm -rf *.pdf
rm -rf *.pptx
}
if [ "$1" = "--clean" ]; then
clean_all
else
python3 dump.py
fi