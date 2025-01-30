#!/bin/bash

./make_dirs.sh

error=""

#for t in local_simple.sh remote_dest.sh remote_src.sh remote_both.sh local_nest.sh local_relative.sh local_expire.sh remote_expire.sh config_error.sh
for t in local_simple.sh remote_dest.sh remote_src.sh remote_both.sh local_nest.sh local_relative.sh
do
    ./$t
    if [ $? -ne 0 ]; then error=true; fi
done

if [ -n "$error" ]; then
    echo "" >&2
    echo "ERROR: Some tests failed" >&2
    exit -1
fi

echo ""
echo "All tests passed!"
