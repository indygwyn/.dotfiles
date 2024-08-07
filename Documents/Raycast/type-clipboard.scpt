#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Type Clipboard
# @raycast.mode silent
# @raycast.packageName System

# Optional parameters:
# @raycast.icon 📋

# Documentation:
# @raycast.description Types out the Clipboard
# @raycast.author Thomas W. Holt Jr.

set textToType to the clipboard
set chars to count textToType
if chars > 500 then
	do shell script "afplay /System/Library/Sounds/Funk.aiff"
else
	tell application "System Events"
		delay 0.25
		keystroke textToType
	end tell
end if

