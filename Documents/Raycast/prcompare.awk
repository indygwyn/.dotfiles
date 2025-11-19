#!/usr/bin/awk -f

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

BEGIN {
  # Read YAML from clipboard
  cmd = "pbpaste"
  ref_count = 0

  while ((cmd | getline line) > 0) {
    # Look for :git: lines
    if (line ~ /:git:/) {
      # Extract git URL (everything after :git:)
      sub(/.*:git:[[:space:]]*/, "", line)
      url = line
      gsub(/\.git$/, "", url)
      gsub(/^git@/, "https://", url)
      # Replace colons after protocol with forward slashes
      protocol = substr(url, 1, 8)
      rest = substr(url, 9)
      gsub(/:/, "/", rest)
      url = protocol rest
    }
    # Look for :ref: lines
    if (line ~ /:ref:/) {
      # Extract ref value (everything after :ref:)
      sub(/.*:ref:[[:space:]]*/, "", line)
      refs[ref_count++] = line
    }
  }
  close(cmd)

  # Validate we have URL and at least 2 refs
  if (!url || ref_count < 2) {
    print "Error: Invalid input. Expected YAML with :git: URL and at least 2 :ref: entries" > "/dev/stderr"
    exit 1
  }

  # Build compare URL
  compare_url = sprintf("%s/compare/%s..%s", url, refs[0], refs[1])

  # Output and open URL
  print compare_url
  system("open '" compare_url "'")
}
