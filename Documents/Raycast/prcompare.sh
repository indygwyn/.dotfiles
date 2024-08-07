#!/usr/local/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title prcompare
# @raycast.mode silent
# @raycast.packageName System

# Optional parameters:
# @raycast.icon ⤵️
# @raycast.currentDirectoryPath ~

# Documentation:
# @raycast.description Compare CMG modules.yaml PR
# @raycast.author Thomas W. Holt Jr.

open "$(pbpaste | awk '/:git:/ {gsub(/:/,"/",$2);gsub(/git@/,"http://",$2);gsub(/\.git$/,"",$2);url=$2}
         /:ref:/ {len=length(refs);refs[len++]=$2}
         END {printf "%s/compare/%s..%s\n",url,refs[0],refs[1]}')"
