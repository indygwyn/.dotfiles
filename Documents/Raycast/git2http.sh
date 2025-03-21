#!/usr/bin/env bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title git2http
# @raycast.mode silent
# @raycast.packageName System

# Optional parameters:
# @raycast.icon 🔃
# @raycast.currentDirectoryPath ~

# Documentation:
# @raycast.description Convert giturl to githttp
# @raycast.author Thomas W. Holt Jr.

myurl=$(pbpaste | sed -e 's/\:/\//' -e 's/git@/https:\/\//')
echo "$myurl" | pbcopy
open "$myurl"
