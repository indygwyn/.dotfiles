let mapleader=','
set encoding=utf-8

" vim-plug is my plugin manager :PlugInstall, :PlugUpdate:, :PlugClean
call plug#begin('~/.vim/plugged')

" colorschemes
Plug 'NLKNguyen/papercolor-theme'
Plug 'tpope/vim-vividchalk'
"
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
Plug 'tpope/vim-jdaddy'                 " JSON aj, gqaj, gwaj, ij
" helpers
Plug 'tpope/vim-sleuth'
Plug 'ntpeters/vim-better-whitespace'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'godlygeek/tabular'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-unimpaired'
Plug 'docunext/closetag.vim'
Plug 'guns/vim-sexp'
Plug 'tpope/vim-sexp-mappings-for-regular-people'
" git
Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-signify'
Plug 'airblade/vim-gitgutter'

" ui
Plug 'tpope/vim-vinegar'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'junegunn/fzf.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'maximbaz/lightline-ale'
Plug 'itchyny/vim-gitbranch'
Plug 'macthecadillac/lightline-gitdiff'
Plug 'skywind3000/asyncrun.vim'
Plug 'albertomontesg/lightline-asyncrun'
Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-rails'

call plug#end()

function! LightlineFugitive()
  if exists('*FugitiveHead')
    let branch = FugitiveHead()
    return branch !=# '' ? ''.branch : ''
  endif
  return ''
endfunction

function! LightlineReadonly()
  return &readonly ? '' : ''
endfunction


" globals for plugin options
"let g:ale_set_loclist = 0
"let g:ale_set_quickfix = 1
let g:ale_sign_column_always = 1
let g:deoplete#enable_at_startup = 1

let g:lightline = {
\ 'colorscheme': 'PaperColor',
\ 'active': {
\   'left': [['mode', 'paste'],
\            ['fugitive', 'readonly', 'filename']],
\   'right': [['percent', 'lineinfo'],
\             ['fileformat', 'fileencoding', 'filetype'],
\             ['linter_checking', 'linter_errors', 'linter_warnings', 'linter_infos', 'linter_ok'],
\             ['asyncrun_status']]
\ },
\ 'separator': { 'left': '', 'right': '' },
\ 'subseparator': { 'left': '', 'right': '' },
\ 'component_expand': {
\   'asyncrun_status': 'lightline#asyncrun#status',
\   'linter_checking': 'lightline#ale#checking',
\   'linter_infos': 'lightline#ale#infos',
\   'linter_warnings': 'lightline#ale#warnings',
\   'linter_errors': 'lightline#ale#errors',
\   'linter_ok': 'lightline#ale#ok',
\ },
\ 'component_function': {
\   'readonly': 'LightlineReadonly',
\   'fugitive': 'LightlineFugitive',
\ },
\ 'component_type': {
\   'linter_checking': 'right',
\   'linter_infos': 'right',
\   'linter_warnings': 'warning',
\   'linter_errors': 'error',
\   'linter_ok': 'right',
\ },
\}

let g:ale_linters = {
      \ 'vim': ['vimls'],
      \}

" ui config
set listchars=eol:¶,tab:→‒,trail:~,extends:>,precedes:<,space:␣
if has('gui_running')
  set background=light
else
  "set t_Co=256 " turn on trucolor
  set background=dark
endif
colorscheme PaperColor
set noshowmode

filetype plugin indent on
scriptencoding utf-8

set autoindent
set nofoldenable
set updatetime=250
set number
set relativenumber
set hlsearch
set colorcolumn=80

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

augroup vimrc
  autocmd!
  autocmd BufNewFile,BufRead .vimrc set filetype=vim
  let b:ale_linters = ['vint']
augroup END

call add(b:ale_linters, 'shellcheck')

" site specific
source ~/.vimrc-local

