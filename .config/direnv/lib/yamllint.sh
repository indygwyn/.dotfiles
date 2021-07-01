use_yamllint() {
  if ! has yamllint ; then
		log_status "yamllint missing"
	fi
}
