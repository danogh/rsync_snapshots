#!/bin/bash

TEST="Local Simple"
CONF=`basename ${0%.*}`.conf

. environs.sh

RD=""
dst_ssh=""
SD=""
src_ssh=""

#RD="$REM_DST:"
#dst_ssh="ssh $REM_DST"
#SD="$REM_SRC:"
#src_ssh="ssh $REM_SRC"

. simple_test.sh
