" pre-plugin config
let mapleader=','
set encoding=utf-8

" vim-plug is my plugin manager :PlugInstall, :PlugUpdate:, :PlugClean
call plug#begin('~/.vim/plugged')
Plug 'dracula/vim', { 'as': 'dracula' } " default colorscheme
Plug 'ghifarit53/daycula-vim' , {'branch' : 'main'}  " lightline uses daycula
Plug 'tpope/vim-sensible'               " Defaults everyone can agree on
Plug 'rizzatti/dash.vim'                " :Dash for Dash Documentation Browser
Plug 'Shougo/deoplete.nvim'             " asynchronous completion framework
" Deoplete requires python3.6+ and the pynvim module
" see https://github.com/Shougo/deoplete.nvim#requirements
Plug 'roxma/nvim-yarp'                  " rpc framework - dep for deoplete
Plug 'roxma/vim-hug-neovim-rpc'         " neovim rpc client - dep for deoplete
Plug 'lilydjwg/colorizer'               " colorize text #rrggbb or #rgb.
Plug 'dense-analysis/ale'               " Asynchronous Lint Engine
Plug 'sheerun/vim-polyglot'             " collection of language packs
Plug 'tpope/vim-jdaddy'                 " JSON aj, gqaj, gwaj, ij
Plug 'vifm/vifm.vim'                    " use vifm as file chooser
Plug 'tpope/vim-sleuth'                 " Heuristically set buffer options
Plug 'ntpeters/vim-better-whitespace'   " Better whitespace highlighting
Plug 'tpope/vim-commentary'             " comment stuff out: gcc, gcap
Plug 'tpope/vim-surround'               " quoting/parenthesizing made simple cs"'
Plug 'tpope/vim-repeat'                 " enable repeating supported plugin maps with '.'
Plug 'tpope/vim-endwise'                " wisely add 'end' in ruby
Plug 'tpope/vim-unimpaired'             " Pairs of handy bracket mappings
Plug 'docunext/closetag.vim'            " close open HTML/XML tags
Plug 'guns/vim-sexp'                    " Precision Editing for S-expressions
Plug 'tpope/vim-sexp-mappings-for-regular-people' " make sexp usable
Plug 'tpope/vim-fugitive'               " A Git wrapper so awesome, it should be illegal
Plug 'mhinz/vim-signify'                " Show a diff in sign column
Plug 'ctrlpvim/ctrlp.vim'               " Full path fuzzy file, buffer, mru, tag finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " A command-line fuzzy finder
Plug 'maximbaz/lightline-ale'           " lightline ale support
Plug 'macthecadillac/lightline-gitdiff' " lightline git support
Plug 'skywind3000/asyncrun.vim'         " background runner
Plug 'albertomontesg/lightline-asyncrun' " lightline asyncrun support
Plug 'itchyny/lightline.vim'            " light and configurable statusline/tabline
call plug#end()

" post plugin config

" branch name function for lightline
function! LightlineFugitive()
  if exists('*FugitiveHead')
    let branch = FugitiveHead()
    return branch !=# '' ? ''.branch : ''
  endif
  return ''
endfunction

" readonly indicator function for lightline
function! LightlineReadonly()
  return &readonly ? '' : ''
endfunction

" globals for plugin options
let g:ale_sign_column_always = 1            " always show the sign column
let g:deoplete#enable_at_startup = 1        " deoplete on open

" lightline config
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

set listchars=eol:¶,tab:→‒,trail:~,extends:>,precedes:<,space:␣ " :set list

" cli vs gui options
if has('gui_running')
  set background=light
  set macligatures
  set guifont=Fira\ Code:h18
else
  set background=dark
endif

" 32 bit color except in Terminal.app
if $TERM_PROGRAM isnot# 'Apple_Terminal'
  set termguicolors
endif

colorscheme dracula

set noshowmode        " lightline indicator used instead

filetype plugin indent on
scriptencoding utf-8

set autoindent
set nofoldenable
set updatetime=250
set number            " number lines
set relativenumber    " relative to cursor position
set hlsearch          " highlight search matches
set colorcolumn=80,100 " ruler in column 80 and 100
highlight ColorColumn guibg=SlateBlue

" Visual mode mappings
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

" extra ft settings for chef/shell are in ~/.vim/after/ft*/*.vim

function! SourceIfExists(file)
  if filereadable(expand(a:file))
    exe 'source' a:file
  endif
endfunction

" load site specific settings
call SourceIfExists('~/.vimrc-local')
