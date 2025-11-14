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
# @raycast.description Convert git SSH URL to HTTPS URL
# @raycast.author Thomas W. Holt Jr.

set -euo pipefail

# Read git URL from clipboard
giturl=$(pbpaste)

# Validate it's a git SSH URL
if ! [[ "$giturl" =~ ^git@[a-zA-Z0-9.-]+:[a-zA-Z0-9._/-]+\.git$ ]]; then
  echo "Error: Invalid git SSH URL format" >&2
  echo "Expected format: git@github.com:user/repo.git" >&2
  exit 1
fi

# Convert: git@github.com:user/repo.git -> https://github.com/user/repo.git
httpsurl=$(echo "$giturl" | sed -e 's/^git@/https:\/\//' -e 's/:/\//')

# Copy to clipboard and open
open "$(echo "$httpsurl" | tee >(pbcopy))"
