" verify we have vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  " vint: next-line -ProhibitAutocmdWithNoGroup
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" pre-plugin config
let mapleader=','
" Note: encoding=utf-8 handled by vim-sensible

" vim-plug is my plugin manager :PlugInstall, :PlugUpdate:, :PlugClean
call plug#begin('~/.vim/plugged')
Plug 'dracula/vim', { 'as': 'dracula' } " default colorscheme
Plug 'ghifarit53/daycula-vim' , {'branch' : 'main'}  " lightline uses daycula
Plug 'tpope/vim-sensible'               " Defaults everyone can agree on
if has('timers')
  Plug 'prabirshrestha/asyncomplete.vim'  " async completion
  Plug 'prabirshrestha/vim-lsp'           " async language server protocol plugin
  Plug 'prabirshrestha/asyncomplete-lsp.vim' " autocompletion sources for vim-lsp
  Plug 'mattn/vim-lsp-settings'           " Auto configurations for Language Server
endif
Plug 'dense-analysis/ale'               " Asynchronous Lint Engine
Plug 'rhysd/vim-lsp-ale'                " ALE vim-lsp bridge
"Plug 'sheerun/vim-polyglot'             " collection of language packs
Plug 'z0mbix/vim-shfmt', { 'for': 'sh' }
Plug 'rhysd/vim-healthcheck'            " like neovim :CheckHealth
Plug 'ntpeters/vim-better-whitespace'   " Better whitespace highlighting
Plug 'tpope/vim-commentary'             " comment stuff out: gcc, gcap, gc visual
Plug 'tpope/vim-surround'               " quoting/parenthesizing made simple
Plug 'tpope/vim-repeat'                 " enable repeating supported plugin maps with '.'
Plug 'tpope/vim-endwise'                " wisely add 'end' in ruby
Plug 'tpope/vim-fugitive'               " A Git wrapper so awesome, it should be illegal
Plug 'tpope/vim-eunuch'                 " Unix Helpers for vim
Plug 'tpope/vim-unimpaired'             " Pairs of handy bracket mappings
Plug 'tpope/vim-ragtag'                 " markup language helperrs
Plug 'tpope/vim-speeddating'            " use CTRL-A/CTRL-X to increment dates, times, and more
Plug 'michaeljsmith/vim-indent-object'  " adds indentation level textobjects
Plug 'noprompt/vim-yardoc'              " syntax highlight yard tags
Plug 'lilydjwg/colorizer'               " colorize text #rrggbb or #rgb.
Plug 'AndrewRadev/switch.vim'           " :Switch
Plug 'AndrewRadev/splitjoin.vim'        " :SplitJoin
Plug 'alvan/vim-closetag'
Plug 'mhinz/vim-signify'                " Show a diff in sign column
Plug 'maximbaz/lightline-ale'           " lightline ale support
Plug 'macthecadillac/lightline-gitdiff' " lightline git support
Plug 'skywind3000/asyncrun.vim'         " background runner
Plug 'albertomontesg/lightline-asyncrun' " lightline asyncrun support
Plug 'itchyny/lightline.vim'            " light and configurable statusline/tabline
Plug 'editorconfig/editorconfig-vim'    " respect project editorconfigs
Plug 'chrisbra/csv.vim'                 " filetype for columnar files csv, tsv
Plug 'farmergreg/vim-lastplace'         " reopen files at your last edit position
Plug 'rodjek/vim-puppet', { 'for': 'puppet' }
Plug 'jvdmeulen/json-fold.nvim', { 'for': 'json' }
Plug 'jgdavey/vim-blockle', { 'for': 'ruby' }
Plug 'Yggdroot/indentLine'
Plug 'digitalrounin/vim-yaml-folds', { 'for': 'yaml' }
Plug 'dbakker/vim-lint'
Plug 'rochacbruno/claude-code.vim'
call plug#end()

" post plugin config

" make yaml tabs correct - use augroup for safety
augroup yaml_settings
  autocmd!
  autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
augroup END

let g:indentLine_char = '⦙'


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

" Note: autoindent, backspace, smarttab, incsearch, laststatus, ruler,
" wildmenu, and other basics handled by vim-sensible
set nofoldenable      " disable folding by default

set updatetime=250    " faster updates for gitgutter/signify
set number            " number lines
set relativenumber    " relative to cursor position
set hlsearch          " highlight search matches
set colorcolumn=80,100,120,140 " column rulers
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

" use modern grep alternatives: ripgrep > ag > grep
if executable('rg')
    set grepprg=rg\ --vimgrep\ --smart-case\ --hidden
    set grepformat=%f:%l:%c:%m
elseif executable('ag')
    set grepprg=ag\ --nogroup\ --nocolor\ --ignore-case\ --column
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

" :Marked to open current file in Marked
command Marked :silent !open -a Marked\ 2.app '%:p'

command StripANSI :%s/[\x1B]\[[0-9;]*m//g

function! SourceIfExists(file)
  if filereadable(expand(a:file))
    exe 'source' a:file
  endif
endfunction

let g:markdown_fenced_languages = ['vim','help']

" Popup menu configuration
set completeopt=menuone,noinsert,noselect
set pumheight=10      " limit popup menu height

inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"
nnoremap <leader>dd :Lexplore %:p:h<CR>
nnoremap <Leader>da :Lexplore<CR>

" silly python comment shortcut
vnoremap <silent> # :s/^/# /<cr>:noh<cr>
vnoremap <silent> -# :s/^# //<cr>:noh<cr>

call ale#linter#Define('awk', {
\   'name': 'awk-language-server',
\   'lsp': 'stdio',
\   'executable': 'awk-language-server',
\   'command': '%e',
\   'project_root': { _ -> expand('%p:h') }
\})

let g:ale_sign_error = '❌'
let g:ale_sign_warning = '⚠️'
let g:ale_sign_info = 'ℹ️'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_writegood_options = '--yes-eprime'
let g:ale_python_mypy_options = '--strict'
let g:ale_disable_lsp = 1
let g:ale_virtualtext_cursor = 'current'
let g:ale_linters = {
    \   'markdown': ['mdl', 'writegood'],
    \   'ruby': ['rubocop'],
    \   'sh': ['shellcheck', 'shell',],
    \   'python': ['ruff'],
    \   'htmldjango': ['j2lint'],
    \   'awk': ['awk-language-server'],
    \ }


" SECURITY: Load API key from environment variable instead
let g:claude_api_key = get(environ(), 'ANTHROPIC_AUTH_TOKEN', '')
let g:claude_api_url = get(environ(), 'ANTHROPIC_BEDROCK_BASE_URL', '')
let g:claude_use_bedrock = 1
let g:claude_bedrock_model_id = 'us.anthropic.claude-3-5-haiku-20241022-v1:0'
let g:claude_code_cli = '/Users/tholt/.local/bin/claude'

let g:claude_map_implement = '<Leader>ci'
let g:claude_map_open_chat = '<Leader>cc'
let g:claude_map_send_chat_message = '<C-]>'
let g:claude_map_cancel_response = '<Leader>cx'

" vim-lsp-settings handles LSP server configuration automatically
" Remove this manual configuration if mattn/vim-lsp-settings works well
" Only keep custom configs if you need to override defaults

" load site specific settings
call SourceIfExists('~/.vimrc-local')
