#!/bin/sh

help2man -h "-hv" -v "-Vv" --no-info --name="generate snapshot backups with rsync" ./rsync_snapshots >| /tmp/rsync_snapshots.1

man -l /tmp/rsync_snapshots.1
