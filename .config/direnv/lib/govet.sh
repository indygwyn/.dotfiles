
use_chef_lint_tools() {
	log_status "Overriding default Ruby environment to use Chef Workstation"
	RUBY_ABI_VERSION=$(ls /opt/chef-workstation/embedded/lib/ruby/gems)
	export GEM_ROOT="/opt/chef-workstation/embedded/lib/ruby/gems/$RUBY_ABI_VERSION"
	EXPANDED_HOME=$(expand_path ~)
	export GEM_HOME="$EXPANDED_HOME/.chef-workstation/gem/ruby/$RUBY_ABI_VERSION"
	export GEM_PATH="$EXPANDED_HOME/.chef-workstation/gem/ruby/$RUBY_ABI_VERSION:/opt/chef-workstation/embedded/lib/ruby/gems/$RUBY_ABI_VERSION"
	log_status "Ensuring Chef Workstation and it's embedded tools are first in the PATH"
	PATH_add $EXPANDED_HOME/.chef-workstation/gem/ruby/$RUBY_ABI_VERSION/bin/
	PATH_add /opt/chef-workstation/embedded/bin
	PATH_add /opt/chef-workstation/bin
	log_status "Using 🍳 chef-workstation 🍳 Happy Cheffing"
}

# eslint --version
# go version
# yamllint --version
# jsonlint --version
# shellcheck --version
# mdl --version
# reek --version
# cookstyle --version
# ruby --version
# gem list -i ^git$
