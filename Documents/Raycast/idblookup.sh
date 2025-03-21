#!/usr/bin/env bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title idblookup
# @raycast.mode silent
# @raycast.packageName System

# Optional parameters:
# @raycast.icon ℹ️
# @raycast.currentDirectoryPath ~

# Documentation:
# @raycast.description look up host in IDB
# @raycast.author Thomas W. Holt Jr.

checkhost=$(pbpaste | awk -F. '{print $1}')
kingdom=$(echo "${checkhost}" | awk -F- '{print $NF}')
myurl="https://cfg0-cidbapik1-0-prd.data.sfdc.net/cidb-api/${kingdom}/1.04/hosts?name=${checkhost}"
echo "$myurl" | pbcopy
open "$myurl"
