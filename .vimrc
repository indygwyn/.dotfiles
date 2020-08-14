let mapleader=","

" vim-plug is my plugin manager :PlugInstall, :PlugUpdate:, :PlugClean
call plug#begin('~/.vim/plugged')

" colorschemes
Plug 'NLKNguyen/papercolor-theme'
Plug 'tpope/vim-sensible'
" syntax
Plug 'Shougo/deoplete.nvim'
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'
Plug 'lilydjwg/colorizer'
" linters
Plug 'dense-analysis/ale'
" code
Plug 'dougireton/vim-chef'
" helpers
Plug 'tpope/vim-sleuth'
Plug 'ntpeters/vim-better-whitespace'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'godlygeek/tabular'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-endwise'
Plug 'docunext/closetag.vim'
" git
Plug 'itchyny/vim-gitbranch'
Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-signify'
" ui
Plug 'tpope/vim-vinegar'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'junegunn/fzf.vim'
Plug 'itchyny/lightline.vim'
Plug 'maximbaz/lightline-ale'
Plug 'itchyny/lightline-powerful'

call plug#end()

" globals for plugin options
"let g:ale_set_loclist = 0
"let g:ale_set_quickfix = 1
let g:ale_sign_column_always = 1
let g:deoplete#enable_at_startup = 1

" ui config
set listchars=eol:¶,tab:→‒,trail:~,extends:>,precedes:<,space:␣
"set t_Co=256
if has('gui_running')
    set background=light
else
    set background=dark
endif
colorscheme PaperColor

filetype plugin indent on
scriptencoding utf-8

set autoindent
set encoding=utf-8
set nofoldenable
set updatetime=250
set number
set relativenumber
set hlsearch

nmap <S-Up> V
nmap <S-Down> V
vmap <S-Up> k
vmap <S-Down> j

" use ag for grep if available
if executable('ag')
    set grepprg=ag\ --nogroup\ --nocolor\ --ignore-case\ --column
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

" chef ruby filetype and ale
augroup Chef
  autocmd!
  autocmd BufNewFile,BufRead */\(attributes\|definitions\|libraries\|providers\|recipes\|resources\)/*.rb set filetype=ruby.chef
  autocmd BufNewFile,BufRead */templates/*/*.erb set filetype=eruby.chef
  autocmd BufNewFile,BufRead */metadata.rb set filetype=ruby.chef
  autocmd BufNewFile,BufRead */chef-repo/environments/*.rb set filetype=ruby.chef
  autocmd BufNewFile,BufRead */chef-repo/roles/*.rb set filetype=ruby.chef
  let b:ale_linters = ['cookstyle']
  let b:ale_fixers = ['cookstyle']
augroup END

" site specific
source ~/.vimrc-local

