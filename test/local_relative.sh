#!/bin/bash

TEST="Local Relative Dest"
CONF=`basename ${0%.*}`.conf

. environs.sh

LOC_DST=snap
DDIR=$LOC_SRC/$LOC_DST
mkdir -p $LOC_SRC/testdir/snap

RD=""
dst_ssh=""
SD=""
src_ssh=""

#RD="$REM_DST:"
#dst_ssh="ssh $REM_DST"
#SD="$REM_SRC:"
#src_ssh="ssh $REM_SRC"

_NO_PASS=1
RDIFF_OPTS="--exclude /snap"

. simple_test.sh 

if [ ! -d "$after/testdir/snap" ]; then
    echo "Failed to copy nested dir named 'snap'" >&2
    exit -1
fi

if [ -z "$KEEP" ]; then
    ds=`date +%Y%m%d`
    eval $dst_ssh rm -rf $DDIR/snap.${ds}*
    rmdir $DDIR
    rm -rf $LOC_SRC/testdir/snap
    rm -rf $LOC_SRC/testdir
fi

echo $TEST test passed

exit;
