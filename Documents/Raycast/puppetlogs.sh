#!/usr/bin/env bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title puppetlogs
# @raycast.mode silent
# @raycast.packageName System

# Optional parameters:
# @raycast.icon 🤡
# @raycast.currentDirectoryPath ~
# @raycast.argument1 { "type": "text", "placeholder": "fqdn", "optional": false }

# Documentation:
# @raycast.description Open Splunk Query for Puppet run logs for host
# @raycast.author Thomas W. Holt Jr.

set -euo pipefail

# Validate fqdn argument (alphanumeric, hyphens, and dots only)
if ! [[ "${1}" =~ ^[a-zA-Z0-9.-]+$ ]]; then
  echo "Error: Invalid FQDN '${1}'" >&2
  exit 1
fi

# URL decode function (pure bash)
urldecode() {
  local url_encoded="${1//+/ }"
  printf '%b' "${url_encoded//%/\\x}"
}

# Splunk configuration
SPLUNK_BASE="https://splunk-web-noncore.log-analytics.monitoring.aws-esvc1-useast2.aws.sfdc.cl/en-US/app/search/search"

# Build Splunk URL - searches for puppet run logs in last 60 minutes
splunkurl="${SPLUNK_BASE}?earliest=-60m@m&latest=now&q=search%20index%3Ddistapps%20sourcetype%3Dpuppet%20host%3D${1}&display.page.search.mode=smart&dispatch.sample_ratio=1&display.prefs.events.offset=60"

#open "$(urldecode "$splunkurl")"
echo "$(urldecode "$splunkurl")"
