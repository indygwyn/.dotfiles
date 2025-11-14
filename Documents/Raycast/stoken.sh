#!/usr/bin/env bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Get RSA Token
# @raycast.mode silent
# @raycast.packageName System

# Optional parameters:
# @raycast.icon 🪙
# @raycast.currentDirectoryPath ~

# Documentation:
# @raycast.description Get RSA token and copy to clipboard
# @raycast.author Thomas W. Holt Jr.

set -euo pipefail

# Get token from stoken and remove newlines/carriage returns
if ! token=$(stoken 2>/dev/null | tr -d "\n\r"); then
  echo "Error: Failed to generate RSA token" >&2
  exit 1
fi

if [[ -z "$token" ]]; then
  echo "Error: Generated token is empty" >&2
  exit 1
fi

echo "$token" | pbcopy
