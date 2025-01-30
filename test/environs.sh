#!/bin/bash

REM_SRC="dan@10.10.130.19"
REM_DST="dan@10.10.130.143"
export REM_SRC REM_DST

LOC_SRC="/tmp/rsnap_source"
LOC_DST="/tmp/rsnap_dest"
export LOC_SRC LOC_DST

SOURCES="${LOC_SRC} ${LOC_REC}"
export SOURCES

FILES=$(echo file_{a..f})
export FILES

SRC=
DST=
export SRC DST

export EXCLUDE=
export EXPIRE="0"

DDIR=
