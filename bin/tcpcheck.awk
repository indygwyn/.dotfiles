BEGIN {
  "/inet/tcp/0/localhost/22" |& getline
  print $0
  close("/inet/tcp/0/localhost/22")
}
