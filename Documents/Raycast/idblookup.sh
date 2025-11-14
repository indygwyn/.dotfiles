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
# @raycast.description Look up host in IDB
# @raycast.author Thomas W. Holt Jr.

set -euo pipefail

# Parse hostname and kingdom from clipboard
clipboard=$(pbpaste)

if [[ -z "$clipboard" ]]; then
  echo "Error: Clipboard is empty" >&2
  exit 1
fi

# Extract hostname (first part before first dot)
checkhost=$(echo "$clipboard" | awk -F. '{print $1}')

if [[ -z "$checkhost" ]]; then
  echo "Error: Could not parse hostname from clipboard" >&2
  exit 1
fi

# Extract kingdom (last part after last hyphen)
kingdom=$(echo "$checkhost" | awk -F- '{print $NF}')

# Build IDB lookup URL
idburl="https://cfg0-cidbapik1-0-prd.data.sfdc.net/cidb-api/${kingdom}/1.04/hosts?name=${checkhost}"

# Copy to clipboard and open
open "$(echo "$idburl" | tee >(pbcopy))"
