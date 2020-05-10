#!/bin/bash
cd $PINTOSDIR && make clean
cd $PINTOSDIR/src/threads && make
cd build && pintos run alarm-multiple
echo "Your exit code: $?"
echo "Exit code should be 0."