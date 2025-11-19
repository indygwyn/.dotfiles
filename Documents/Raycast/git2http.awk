#!/usr/bin/awk -f

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title git2http
# @raycast.mode silent
# @raycast.packageName System

# Optional parameters:
# @raycast.icon 🔃
# @raycast.currentDirectoryPath ~

# Documentation:
# @raycast.description Convert git SSH URL to HTTPS URL
# @raycast.author Thomas W. Holt Jr.

BEGIN {
  # Read git URL from clipboard using system command
  cmd = "pbpaste"
  if ((cmd | getline giturl) <= 0) {
    print "Error: Could not read from clipboard" > "/dev/stderr"
    exit 1
  }
  close(cmd)

  # Validate it's a git SSH URL format: git@domain.com:user/repo.git
  if (giturl !~ /^git@[a-zA-Z0-9.-]+:[a-zA-Z0-9._\/-]+\.git$/) {
    print "Error: Invalid git SSH URL format" > "/dev/stderr"
    print "Expected format: git@github.com:user/repo.git" > "/dev/stderr"
    exit 1
  }

  # Convert: git@github.com:user/repo.git -> https://github.com/user/repo.git
  # Split on ':' to separate host from path
  split(giturl, parts, ":")
  hostpart = parts[1]        # git@github.com
  pathpart = parts[2]        # user/repo.git

  # Extract domain from git@domain.com
  sub(/^git@/, "", hostpart)
  domain = hostpart

  # Remove .git suffix from path
  gsub(/\.git$/, "", pathpart)

  httpsurl = "https://" domain "/" pathpart

  # Output URL and pipe to pbcopy
  pbcopy_cmd = "pbcopy"
  print httpsurl
  print httpsurl | pbcopy_cmd
  close(pbcopy_cmd)

  # Open the URL
  system("open '" httpsurl "'")
}
