use_shellcheck() {
  if ! has shellcheck ; then
		log_status "shellcheck missing"
	fi
}
