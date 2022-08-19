#!/usr/bin/env awk -f
BEGIN {
if (ARGC == 1) {
  print "Usage: sshprobe.awk [hostname]"
  connect = "/inet/tcp/0/localhost/22"
} else
  connect = "/inet/tcp/0/" ARGV[1] "/22"
connect |& getline
print $0
close(connect)
}

