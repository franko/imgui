#!/usr/bin/env bash

output="$1"
shift

for optname in "$@"; do
    echo "#define $optname" >> "$output"
done
