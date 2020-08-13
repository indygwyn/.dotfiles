let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_disable_lsp = 1

call plug#begin('~/.vim/plugged')       " Plugins managed with vim-plug
Plug 'tpope/vim-sensible'               " start with sensible defaults
Plug 'tpope/vim-fugitive'               " git :Gedit, :Gdiff, :Gstatus
Plug 'mhinz/vim-signify'                " diff in sign column
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
Plug 'itchyny/lightline.vim'
Plug 'NLKNguyen/papercolor-theme'       " I like this color theme
Plug 'lilydjwg/colorizer'               " colorize the #79f or rgb(252,34,43)
Plug 'dougireton/vim-chef'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'dense-analysis/ale'               " linting
Plug 'maximbaz/lightline-ale'
call plug#end()

set encoding=utf-8
set autoindent
set relativenumber
filetype plugin indent on

set listchars=eol:¶,tab:→‒,trail:~,extends:>,precedes:<,space:␣

set nofoldenable                        " folding is stupid
set updatetime=250                      "
scriptencoding utf-8
"set t_Co=256                           " This is may or may not needed.
if has('gui_running')
    set background=light                " light in gui
else
    set background=dark                 " dark otherwise
endif
colorscheme PaperColor
set number                              " numbers on to start
set hlsearch                            " highlight my searches
nmap <S-Up> V                           " shift-arrow start visual mode
nmap <S-Down> V
vmap <S-Up> k
vmap <S-Down> j

if executable('ag')
    set grepprg=ag\ --nogroup\ --nocolor\ --ignore-case\ --column
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

let g:github_enterprise_urls = ['https://github.exacttarget.com']

augroup Chef " make cheffy ruby cheffy
  autocmd!
  autocmd BufNewFile,BufRead */\(attributes\|definitions\|libraries\|providers\|recipes\|resources\)/*.rb set filetype=ruby.chef
  autocmd BufNewFile,BufRead */templates/*/*.erb set filetype=eruby.chef
  autocmd BufNewFile,BufRead */metadata.rb set filetype=ruby.chef
  autocmd BufNewFile,BufRead */chef-repo/environments/*.rb set filetype=ruby.chef
  autocmd BufNewFile,BufRead */chef-repo/roles/*.rb set filetype=ruby.chef
  let b:ale_linters = ['cookstyle']
  let b:ale_fixers = ['cookstyle']
augroup END

source ~/.vimrc-local                   " anything local needed?

