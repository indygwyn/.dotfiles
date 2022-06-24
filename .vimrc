" verify we have vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  " vint: next-line -ProhibitAutocmdWithNoGroup
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" pre-plugin config
let mapleader=','
set encoding=utf-8

" vim-plug is my plugin manager :PlugInstall, :PlugUpdate:, :PlugClean
call plug#begin('~/.vim/plugged')
Plug 'dracula/vim', { 'as': 'dracula' } " default colorscheme
Plug 'ghifarit53/daycula-vim' , {'branch' : 'main'}  " lightline uses daycula
Plug 'tpope/vim-sensible'               " Defaults everyone can agree on
" Plug 'Shougo/defx.nvim'
" Plug 'roxma/nvim-yarp'
" Plug 'roxma/vim-hug-neovim-rpc'
Plug 'prabirshrestha/asyncomplete.vim'  " background completion
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete-lsp.vim' " completion using lsp
Plug 'mattn/vim-lsp-settings'
Plug 'dense-analysis/ale'               " Asynchronous Lint Engine
Plug 'rhysd/vim-lsp-ale'                " ALE vim-lsp bridge
Plug 'sheerun/vim-polyglot'             " collection of language packs
Plug 'rhysd/vim-healthcheck'            " like neovim :CheckHealth
Plug 'ntpeters/vim-better-whitespace'   " Better whitespace highlighting
Plug 'tpope/vim-commentary'             " comment stuff out: gcc, gcap, gc visual
Plug 'tpope/vim-surround'               " quoting/parenthesizing made simple cs"'
Plug 'machakann/vim-sandwich'           " operators and textobjects to search/select/edit sandwiched texts
Plug 'tpope/vim-repeat'                 " enable repeating supported plugin maps with '.'
Plug 'tpope/vim-endwise'                " wisely add 'end' in ruby
Plug 'tpope/vim-fugitive'               " A Git wrapper so awesome, it should be illegal
Plug 'tpope/vim-eunuch'                 " Unix Helpers for vim
Plug 'tpope/vim-unimpaired'             " Pairs of handy bracket mappings
Plug 'tpope/vim-ragtag'                 " markup language helperrs
Plug 'tpope/vim-speeddating'            " use CTRL-A/CTRL-X to increment dates, times, and more
Plug 'ryanoasis/vim-devicons'
Plug 'tmsvg/pear-tree'                  " Close parenthesis, curly braces etc.
Plug 'lilydjwg/colorizer'               " colorize text #rrggbb or #rgb.
Plug 'AndrewRadev/switch.vim'           " :Switch
Plug 'AndrewRadev/splitjoin.vim'        " :SplitJoin
Plug 'junegunn/vim-easy-align'          " Align on = :gaip*=
Plug 'junegunn/limelight.vim'
Plug 'docunext/closetag.vim'            " close open HTML/XML tags
Plug 'mhinz/vim-signify'                " Show a diff in sign column
Plug 'maximbaz/lightline-ale'           " lightline ale support
Plug 'macthecadillac/lightline-gitdiff' " lightline git support
Plug 'skywind3000/asyncrun.vim'         " background runner
Plug 'albertomontesg/lightline-asyncrun' " lightline asyncrun support
Plug 'itchyny/lightline.vim'            " light and configurable statusline/tabline
Plug 'editorconfig/editorconfig-vim'    " respect project editorconfigs
Plug 'segeljakt/vim-silicon'            " carbon.sh clone
Plug 'airblade/vim-rooter'              " pwd root in git repo
Plug 'chrisbra/csv.vim'                 " filetype for columnar files csv, tsv
Plug 'vimwiki/vimwiki'                  " personal wiki for vim
Plug 'farmergreg/vim-lastplace'
Plug 'rodjek/vim-puppet'
Plug 'axvr/org.vim'
Plug 'dewyze/vim-tada'
Plug 'rizzatti/dash.vim'                " Dash.app integration
call plug#end()
runtime macros/sandwich/keymap/surround.vim

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
set signcolumn=number

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
set colorcolumn=72,79 " ruler in column 80 and 100
highlight ColorColumn guibg=#44475a

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

" :Marked to open current file in Marked
command Marked :silent !open -a Marked\ 2.app '%:p'

" extra ft settings for chef/shell are in ~/.vim/after/ft*/*.vim

function! SourceIfExists(file)
  if filereadable(expand(a:file))
    exe 'source' a:file
  endif
endfunction

set runtimepath+=/usr/local/opt/fzf

" Armor files
let g:GPGPreferArmor=1
" Set the default option
let g:GPGDefaultRecipients=['twh@pobox.com']

augroup GnuPG
  autocmd User GnuPG setl textwidth=72
augroup END

let g:markdown_fenced_languages = ['vim','help']

inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"

let g:ale_sign_error = '❌'
let g:ale_sign_warning = '⚠️'
let g:ale_sign_info = 'ℹ️'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

let g:ale_writegood_options = '--yes-eprime'

let g:ale_linters = {
      \   'ruby': ['standardrb', 'solargraph', 'reek'],
      \   'python': ['flake8', 'pylint', 'bandit', 'pylsp']
      \}

" vim-sandwich
let g:sandwich#recipes = deepcopy(g:sandwich#default_recipes)
let g:sandwich#recipes += [
      \   {
      \     'buns'    : ['%{', '}'],
      \     'filetype': ['elixir'],
      \     'input'   : ['m'],
      \     'nesting' : 1,
      \   },
      \   {
      \     'buns'    : 'StructInput()',
      \     'filetype': ['elixir'],
      \     'kind'    : ['add', 'replace'],
      \     'action'  : ['add'],
      \     'input'   : ['M'],
      \     'listexpr'    : 1,
      \     'nesting' : 1,
      \   },
      \   {
      \     'buns'    : ['%\w\+{', '}'],
      \     'filetype': ['elixir'],
      \     'input'   : ['M'],
      \     'nesting' : 1,
      \     'regex'   : 1,
      \   },
      \   {
      \     'buns':     ['<%= ', ' %>'],
      \     'filetype': ['eruby'],
      \     'input':    ['='],
      \     'nesting':  1
      \   },
      \   {
      \     'buns':     ['<% ', ' %>'],
      \     'filetype': ['eruby'],
      \     'input':    ['-'],
      \     'nesting':  1
      \   },
      \   {
      \     'buns':     ['<%# ', ' %>'],
      \     'filetype': ['eruby'],
      \     'input':    ['#'],
      \     'nesting':  1
      \   }
      \ ]

function! StructInput() abort
  let s:StructLast = input('Struct: ')
  if s:StructLast !=# ''
    let struct = printf('%%%s{', s:StructLast)
  else
    throw 'OperatorSandwichCancel'
  endif
  return [struct, '}']
endfunction

" load site specific settings
call SourceIfExists('~/.vimrc-local')
