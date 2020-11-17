" ftplugin/chef.vim

" save cpo for reset at end
let s:cpo_save = &cpo
set cpo&vim

" Handle these cases:
" include_recipe 'current_cookbook::foo' => ./foo.rb
" include_recipe "#{cookbook_name}::foo" => ./foo.rb
" include_recipe 'apache2::ssl' => apache2/recipes/ssl.rb

" Make gf work on Chef include_recipe lines
" Add all cookbooks/*/recipe dirs to Vim's path variable
setlocal path+=.,**1/recipes;cookbooks,**1;cookbooks

" Add Berkshelf cookbooks to the search path
" TODO: Make this work on Windows
if isdirectory($BERKSHELF_PATH . '/cookbooks')
  setlocal path+=$BERKSHELF_PATH/cookbooks/**1/recipes,$BERKSHELF_PATH/cookbooks/**1
elseif isdirectory($HOME . '/.berkshelf/cookbooks')
  setlocal path+=$HOME/.berkshelf/cookbooks/**1/recipes,$HOME/.berkshelf/cookbooks/**1
endif

" make this case work:
" include_recipe 'apache2' => apache2/recipes/default.rb
setlocal suffixesadd+=/recipes/default.rb

let b:ale_linters = ['cookstyle']
let b:ale_fixers = ['cookstyle']

" reset cpo
let &cpo = s:cpo_save
unlet s:cpo_save
