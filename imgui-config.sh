#!/usr/bin/env bash

output="$1"
sample="$2"
shift 2

for optname in "$@"; do
    echo "#define $optname" >> "$output"
done

cat "$sample" >> "$output"
