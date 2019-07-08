call plug#begin('~/.vim/plugged')       " Plugins managed with vim-plug
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-fugitive'               " git :Gedit, :Gdiff, :Gstatus
Plug 'tpope/vim-rhubarb'                " github for fugitive :Gbrowse
Plug 'shumphrey/fugitive-gitlab.vim'    " gitlab for fugitive :Gbrowse
"Plug 'airblade/vim-gitgutter'           " git diff statuses in the gutter
Plug 'mhinz/vim-signify'
Plug 'rhysd/git-messenger.vim'          " git commit messages :GitMessenger
Plug 'tpope/vim-vinegar'                " netrw - ~
Plug 'ctrlpvim/ctrlp.vim'               " find file fast :CtrlP ctrl-p
Plug 'junegunn/fzf.vim'                 " fuzzy finder wrapper :Files
Plug 'tpope/vim-sleuth'                 " detect shiftwidth,expandtab
Plug 'tpope/vim-commentary'             " commenting gcc# gcap
Plug 'tpope/vim-surround'               " change surrounders easily cs[}
Plug 'ntpeters/vim-better-whitespace'   " whitespace fixer :StripWhitespace
Plug 'godlygeek/tabular'                " line up text :Tabularize
Plug 'tpope/vim-repeat'                 " fix . for plugins
Plug 'tpope/vim-endwise'                " wisely add ends to my begins and more
Plug 'docunext/closetag.vim'            " html/xml close tags
"Plug 'vim-airline/vim-airline'          " nice status line
Plug 'itchyny/lightline.vim'
Plug 'NLKNguyen/papercolor-theme'
Plug 'lilydjwg/colorizer'               " colorize the #79f or rgb(252,34,43)
Plug 'editorconfig/editorconfig-vim'    " https://editorconfig.org/
Plug 'vim-syntastic/syntastic'          " lint all the things synchronously
Plug 'dougireton/vim-chef'              " cheffy ruby is cheffy
Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}} "
" Future, at some point I want to start moving lint/style/completion stuff
" to things that support LSP http://langserver.org/ the stuff below does that
"Plug 'w0rp/ale'                        " ALE?
"Plug 'prabirshrestha/async.vim'        " or vim-lsp?
"Plug 'prabirshrestha/vim-lsp'
"Plug 'prabirshrestha/asyncomplete.vim'
"Plug 'prabirshrestha/asyncomplete-gocode.vim'
"Plug 'prabirshrestha/asyncomplete-lsp.vim'
call plug#end()
set encoding=utf-8

set autoindent
filetype plugin indent on

"set listchars=eol:$,nbsp:_,tab:>-,trail:~,extends:>,precedes:<
set listchars=eol:¶,tab:→‒,trail:~,extends:>,precedes:<,space:␣

"if has('gui_running')
"  set list listchars=tab:▶‒,nbsp:∙,trail:∙,extends:▶,precedes:◀
"  let &showbreak = '↳'
"else
"  set list listchars=tab:>-,nbsp:.,trail:.,extends:>,precedes:<
"  let &showbreak = '^'
"endif

set list
set nofoldenable                        " folding is stupid
set updatetime=250                      "
scriptencoding utf-8
colorscheme PaperColor
if has('gui_running')
    set background=light                " light in gui
else
    set background=dark                 " dark otherwise
endif
set number                              " numbers on to start
set hlsearch                            " highlight my searches
nmap <S-Up> V                           " shift-arrow start visual mode
nmap <S-Down> V
vmap <S-Up> k
vmap <S-Down> j

" ALE stuff commented since not using it yet
" let g:ale_open_list = 1
" let g:ale_keep_list_window_open = 1
" let g:ale_list_window_size = 3
" let g:ale_completion_enabled = 1
" let g:ale_sign_column_always = 1
" let g:ale_statusline_format = ['⨉ %d', '⚠ %d', '⬥ ok']
" let g:airline#extensions#ale#enabled = 1

set statusline+=%#warningmsg#           " syntastic
set statusline+=%{SyntasticStatuslineFlag()} " syntastic
set statusline+=%*                      " syntastic

if executable('ag')
    set grepprg=ag\ --nogroup\ --nocolor\ --ignore-case\ --column
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

let g:syntastic_auto_loc_list = 1       " auto open the loc list
let g:syntastic_loc_list_height = 3     " loc list is 3 lines high
let g:syntastic_check_on_open = 0       " do not lint on open
let g:syntastic_check_on_wq = 0         " do not lint on wq
let g:syntastic_stl_format = '[%E{Err: %fe #%e}%B{, }%W{Warn: %fw #%w}]'
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_aggregate_errors = 1
let g:syntastic_id_checkers = 0
let g:syntastic_auto_jump = 1
" the linting/styling programs must be installed on your workstation
let g:syntastic_vim_checkers = ['vint']
let g:syntastic_chef_checkers = ['foodcritic']
let g:syntastic_chef_foodcritic_args ='--no-progress'
let g:syntastic_ruby_checkers = ['rubocop']
let g:syntastic_ruby_rubocop_exec = '/usr/local/bin/cookstyle'
let g:syntastic_ansible_checkers = ['ansible_lint']
let g:syntastic_python_checkers = ['flake8']
let g:syntastic_sh_checkers = ['shellcheck']
let g:syntastic_sh_shellcheck_args ='-x'
let g:syntastic_yaml_checkers = ['yamllint']
let g:syntastic_javascript_checkers=['standard']
let g:github_enterprise_urls = ['https://github.exacttarget.com']
augroup Cheffy " make cheffy ruby cheffy
  autocmd BufNewFile,BufRead */\(attributes\|definitions\|libraries\|providers\|recipes\|resources\)/*.rb set filetype=ruby.chef
  autocmd BufNewFile,BufRead */templates/*/*.erb set filetype=eruby.chef
  autocmd BufNewFile,BufRead */metadata.rb set filetype=ruby.chef
  autocmd BufNewFile,BufRead */chef-repo/environments/*.rb set filetype=ruby.chef
  autocmd BufNewFile,BufRead */chef-repo/roles/*.rb set filetype=ruby.chef
augroup END
source ~/.vimrc-local                   " anything local needed?
