has_gem() {
  if gem list -i ^$1$ > /dev/null ; then
		log_status "using $1 gem"
	else
		log_status "missing $1 gem"
	fi
}
