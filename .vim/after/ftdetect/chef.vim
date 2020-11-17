" ftdetect/chef
autocmd BufNewFile,BufRead */metadata.rb set filetype=ruby.chef
autocmd BufNewFile,BufRead */Policyfile.rb set filetype=ruby.chef
autocmd BufNewFile,BufRead */\(attributes\|definitions\|libraries\|providers\|recipes\|resources\)/*.rb set filetype=ruby.chef
autocmd BufNewFile,BufRead */test/integration/*/*.rb set filetype=ruby.chef
autocmd BufNewFile,BufRead */templates/*/*.erb set filetype=eruby.chef
autocmd BufNewFile,BufRead */chef-repo/roles/*.rb set filetype=ruby.chef
autocmd BufNewFile,BufRead */chef-repo/environments/*.rb set filetype=ruby.chef
autocmd BufNewFile,BufRead */chef-repo/environments/*/*.rb set filetype=ruby.chef
