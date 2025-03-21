#!/usr/bin/env bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title getbastion
# @raycast.mode silent
# @raycast.packageName System

# Optional parameters:
# @raycast.icon 🏰
# @raycast.currentDirectoryPath ~
# @raycast.argument1 { "type": "text", "placeholder": "kingdom", "optional": true }

# Documentation:
# @raycast.description Get a Bastion
# @raycast.author Thomas W. Holt Jr.

if [[ -z "$1" ]]; then
  echo ops0-bastion2-1-XXX | pbcopy;
else
  echo ops0-bastion2-1-XXX | sed "s/XXX/$1/" | pbcopy;
fi
