#!/usr/bin/env bash

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

set -euo pipefail

# Parse clipboard content (YAML format with :git: and :ref: fields)
compare_url=$(pbpaste | awk '
  /:git:/ {
    # Extract git URL and convert to https
    url = $2
    gsub(/^git@/, "https://", url)
    gsub(/:/, "/", url)
    gsub(/\.git$/, "", url)
  }
  /:ref:/ {
    # Collect refs
    refs[ref_count++] = $2
  }
  END {
    # Validate we have URL and at least 2 refs
    if (!url || ref_count < 2) {
      print "Error: Invalid input. Expected YAML with :git: URL and at least 2 :ref: entries" > "/dev/stderr"
      exit 1
    }
    # Build and print compare URL
    printf "%s/compare/%s..%s\n", url, refs[0], refs[1]
  }
') || exit 1

open "$compare_url"
