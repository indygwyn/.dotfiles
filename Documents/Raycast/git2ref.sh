#!/usr/bin/env bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title git2ref
# @raycast.mode silent
# @raycast.packageName System

# Optional parameters:
# @raycast.icon 🔃
# @raycast.currentDirectoryPath ~

# Documentation:
# @raycast.description Convert git SSH URL + ref to HTTPS commit URL
# @raycast.author Thomas W. Holt Jr.

set -euo pipefail

# Parse clipboard content and build commit URL
commit_url=$(pbpaste | awk '
  /:git:/ {
    # Extract and convert git SSH URL to HTTPS
    url = $NF
    gsub(/^git@/, "https://", url)
    gsub(/:/, "/", url)
    gsub(/\.git$/, "", url)
  }
  /:ref:/ {
    # Extract the commit/ref hash
    ref = $NF
  }
  END {
    # Validate we have both URL and ref
    if (!url || !ref) {
      print "Error: Invalid input. Expected :git: URL and :ref: commit hash" > "/dev/stderr"
      exit 1
    }
    # Build and print commit URL
    printf "%s/commit/%s\n", url, ref
  }
') || exit 1

# Copy to clipboard and open
open "$(echo "$commit_url" | tee >(pbcopy))"
