#!/usr/bin/env bash
#
# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title awscreds
# @raycast.mode silent
# @raycast.packageName System

# Optional parameters:
# @raycast.icon ☁️
# @raycast.currentDirectoryPath ~

# Documentation:
# @raycast.description Format AWS creds
# @raycast.author Thomas W. Holt Jr.

set -euo pipefail

# Read and format from clipboard
pbpaste | awk '
    {
        if (NF < 4) {
            print "Error: Expected at least 4 fields" > "/dev/stderr"
            exit 1
        }
        printf "export %s\nexport %s\nexport %s\n", $2, $3, $4
    }
' | tee >(pbcopy) > ~/.aws/AWS
