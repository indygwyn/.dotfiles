#!/usr/bin/env bash
#
# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title yumcheck
# @raycast.mode silent
# @raycast.packageName System
#
# Optional parameters:
# @raycast.icon 📦
# @raycast.currentDirectoryPath ~
#
# Documentation:
# @raycast.description Open Artifactory UI for kingdom RPM repository
# @raycast.author Thomas W. Holt Jr.
# @raycast.argument1 { "type": "text", "placeholder": "KINGDOM", "percentEncoded": true }
#

set -euo pipefail

# Validate kingdom argument (alphanumeric and hyphens only)
if [[ -z "${1:-}" ]]; then
  echo "Error: Kingdom name is required" >&2
  exit 1
fi

if ! [[ "${1}" =~ ^[a-zA-Z0-9-]+$ ]]; then
  echo "Error: Invalid kingdom name '${1}'" >&2
  exit 1
fi

# Open Artifactory UI for the kingdom's RPM repository
repourl="https://ops0-artifactrepo1-0-rz1.data.sfdc.net/ui/native/rpm-prod-${1}-v2/"
open "$repourl"
