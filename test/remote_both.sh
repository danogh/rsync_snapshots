#!/bin/bash

TEST="Simple Remote Both"
CONF=`basename ${0%.*}`.conf

. environs.sh

RD=""
dst_ssh=""
SD=""
src_ssh=""

RD="$REM_DST:"
dst_ssh="ssh $REM_DST"
SD="$REM_SRC:"
src_ssh="ssh $REM_SRC"

SRC=$SD$LOC_SRC
DST=$RD$LOC_DST
export SRC DST

FF=${FILES%% *}
LF=${FILES##* }

if [ -n "$SD" ]; then
    if ! $src_ssh test -d $LOC_SRC; then
	rsync $V -xaSH $LOC_SRC/ $SD$LOC_SRC/
    fi
fi
   
$dst_ssh mkdir -p $LOC_DST

if ! $dst_ssh ls -d $LOC_DST 2>/dev/null >/dev/null ; then
    echo Failed to create $RD$LOC_DST >&2
    exit -1
fi

eval $src_ssh dd if=/dev/random of=$LOC_SRC/$FF bs=1024 count=2048 status=none

$dst_ssh rm -rf $LOC_DST/snap.`date +%Y%m%d`*

before=`$dst_ssh find $LOC_DST -maxdepth 1 -mindepth 1 -type d | sort -V | tail -n 1`

if [ -z "$V" ]; then
    ../rsync_snapshots $V --conf $CONF 2>/dev/null
else
    ../rsync_snapshots $V --conf $CONF
fi
if [ $? -ne 0 ]; then
    echo $TEST test correctly failed!
    exit;
else
    echo ERROR: $TEST test did NOT fail!  This is an error! >&2
    exit -1
fi

