#!/bin/bash

if [ -z "$LOC_SRC" ]; then echo Do not call $0 directly! >&2; exit -1; fi

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

if [ -z "$DDIR" ]; then DDIR=$LOC_DST; fi

$dst_ssh mkdir -p $DDIR

if ! $dst_ssh ls -d $DDIR 2>/dev/null >/dev/null ; then
    echo $TEST: Failed to create $RD$DDIR >&2
    exit -1
fi

eval $src_ssh dd if=/dev/random of=$LOC_SRC/$FF bs=1024 count=2048 status=none

$dst_ssh rm -rf $DDIR/snap.`date +%Y%m%d`*

before=`$dst_ssh find $DDIR -maxdepth 1 -mindepth 1 -type d | sort -V | tail -n 1`

../rsync_snapshots $V --conf $CONF
if [ $? -ne 0 ]; then
    echo ERROR: $TEST: rsync_snapshots returned an error! >&2
    exit -1
fi

after=`$dst_ssh find $DDIR -maxdepth 1 -mindepth 1 -type d | sort -V | tail -n 1`

if [ -z "$after" -o "$after" = "$before" ]; then
    echo $TEST: Failed to sync to $RD$DDIR >&2
    echo $TEST: Before: $before >&2
    echo $TEST: After: $after >&2
    exit -1
fi

diff=`rsync -ni -xaSH $RDIFF_OPTS --delete $SD$LOC_SRC/ $RD$after/`
if [ -n "$diff" ]; then
    echo $TEST: Snapshot does NOT match the source! >&2
    exit -1
fi

eval $src_ssh dd if=/dev/random of=$LOC_SRC/$FF bs=1024 count=4096 status=none

../rsync_snapshots $V --conf $CONF
if [ $? -ne 0 ]; then
    echo ERROR: $TEST: rsync_snapshots returned an error! >&2
    exit -1
fi

post=`$dst_ssh find $DDIR -maxdepth 1 -mindepth 1 -type d | sort -V | tail -n 1`

if [ -z "$post" -o "$post" = "$after" ]; then
    echo $TEST: Failed to sync to $RD$DDIR >&2
    echo "After: $after" >&2
    echo "Post: $post" >&2
    exit -1
fi

post_c_first=`$dst_ssh ls -l $post/$FF | awk '{print $2}'`

if [ $post_c_first -ne 1 ]; then
    echo "$TEST: Link count is wrong on $post/$FF ($post_c_first)" >&2
    echo "Post: $post_c_first" >&2
    exit -1
fi

after_c_last=`$dst_ssh ls -l $after/$LF | awk '{print $2}'`
post_c_last=`$dst_ssh ls -l $post/$LF | awk '{print $2}'`

if [ $post_c_last -ne $after_c_last ]; then
    echo $TEST: Link count is wrong on $post/$LF >&2
    echo "After: $after_c_last" >&2
    echo "Post: $post_c_last" >&2
    exit -1
fi

if [ -z "$_NO_PASS" ]; then
    if [ -z "$KEEP" ]; then
	ds=`date +%Y%m%d`
	eval $dst_ssh rm -rf $DDIR/snap.${ds}*
    fi

    echo $TEST test passed
    exit;
fi
