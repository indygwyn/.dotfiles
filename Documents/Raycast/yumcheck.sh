#!/usr/bin/env bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title yumcheck
# @raycast.mode silent
# @raycast.packageName System

# Optional parameters:
# @raycast.icon 📦
# @raycast.currentDirectoryPath ~

# Documentation:
# @raycast.description Convert giturl to githttp
# @raycast.author Thomas W. Holt Jr.
# @raycast.argument1 { "type": "text", "placeholder": "KINGDOM", "percentEncoded": true }


myurl=https://ops0-artifactrepo1-0-rz1.data.sfdc.net/ui/native/rpm-prod-${1}-v2/
open "$myurl"
