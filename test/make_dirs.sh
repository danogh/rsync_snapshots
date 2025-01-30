#!/bin/bash

. environs.sh

for s in $SOURCES; do

    if [ ! -d "$s" ]; then mkdir $s; fi
    for f in $FILES; do
	dd if=/dev/random of=$s/$f bs=1048576 count=2 status=none
    done

done


