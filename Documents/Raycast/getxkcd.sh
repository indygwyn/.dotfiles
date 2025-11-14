#!/usr/bin/env bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title getxkcd
# @raycast.mode silent
# @raycast.packageName System

# Optional parameters:
# @raycast.icon https://xkcd.com/s/919f27.ico
# @raycast.currentDirectoryPath ~
# @raycast.argument1 { "type": "text", "placeholder": "bobby", "optional": true }

# Documentation:
# @raycast.description Get xkcd comic
# @raycast.author Thomas W. Holt Jr.

set -euo pipefail

# Map comic names to URLs
case "${1:-}" in
  'standards')
    url='https://xkcd.com/927/'
    ;;
  'nebraska')
    url='https://xkcd.com/2347/'
    ;;
  'correct')
    url='https://xkcd.com/936/'
    ;;
  *)
    url='https://xkcd.com/327/'
    ;;
esac

echo "$url" | pbcopy
