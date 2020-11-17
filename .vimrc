let mapleader=','
set encoding=utf-8

" vim-plug is my plugin manager :PlugInstall, :PlugUpdate:, :PlugClean
call plug#begin('~/.vim/plugged')

" colorschemes
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'ghifarit53/daycula-vim' , {'branch' : 'main'}
Plug 'NLKNguyen/papercolor-theme'
Plug 'tpope/vim-vividchalk'
"
Plug 'tpope/vim-sensible'
" syntax
Plug 'rizzatti/dash.vim'
Plug 'Shougo/deoplete.nvim'
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'
Plug 'lilydjwg/colorizer'
Plug 'xu-cheng/brew.vim'
" linters
Plug 'dense-analysis/ale'
" code
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-jdaddy'                 " JSON aj, gqaj, gwaj, ij
Plug 'kristijanhusak/vim-carbon-now-sh'
" helpers
Plug 'vifm/vifm.vim'
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
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
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
    return branch !=# '' ? ''.branch : ''
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
\ 'colorscheme': 'daycula',
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
  set macligatures
  set guifont=Fira\ Code:h18
  " set guifont=JuliaMono:h18
else
  set background=dark
endif

if $TERM_PROGRAM isnot# 'Apple_Terminal'
  set termguicolors
endif

colorscheme dracula


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

" Visual mode tweaks
nmap <S-Up> V
nmap <S-Down> V
vmap <S-Up> k
vmap <S-Down> j

" Esc remaps
imap jj <Esc>
imap jk <Esc>
imap kj <Esc>

" use ag for grep if available
if executable('ag')
    set grepprg=ag\ --nogroup\ --nocolor\ --ignore-case\ --column
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

augroup vimrc
  autocmd!
  autocmd BufNewFile,BufRead .vimrc set filetype=vim
  let b:ale_linters = ['vint']
augroup END

" TOOD: fix shell ftdetect/ftplugin
"call add(b:ale_linters, 'shellcheck')

" site specific
source ~/.vimrc-local
