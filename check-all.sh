#!/bin/sh
# marxists.xyz text linter metascript
# forked from github.com/redtexts/mirror-tools 
# in the public domain, 2020-

find ./txt/ -name "*.md" -type f -print0 | \
    xargs -0 -L1 awk -f ./res/check.awk
