#!/bin/bash
set -e
echo "INFO: Running make"
cd $PINTOSDIR/src/threads && make
echo "INFO: Starting pintos"
cd build && pintos run alarm-multiple