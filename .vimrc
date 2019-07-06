"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" #1 PLUGIN MANAGER
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')

"navigation & searching
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'junegunn/fzf',  { 'dir': '~/.fzf',  'do': './install --all'  }
Plug 'junegunn/fzf.vim'
Plug 'tweekmonster/fzf-filemru'
Plug 'vim-scripts/Tagbar', { 'on': 'TagbarToggle' }
Plug 'terryma/vim-smooth-scroll'
Plug 'vim-scripts/Tabmerge'
Plug 'wesQ3/vim-windowswap'
Plug 'szw/vim-tags'

"graphical improvements
Plug 'neomake/neomake'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'morhetz/gruvbox'
Plug 'tmux-plugins/vim-tmux', {'for': 'tmux'}
Plug 'matze/vim-move'
Plug 'tpope/vim-repeat'
Plug 'edkolev/tmuxline.vim'

"text completion & editing
Plug 'Valloric/YouCompleteMe', { 'do': './install.py --all'}
Plug 'leafgarland/typescript-vim'
Plug 'w0rp/ale'
Plug 'jelera/vim-javascript-syntax',  {'for': 'javascript'}
Plug 'vim-scripts/indentpython.vim', { 'for': 'python' }
Plug 'tmhedberg/SimpylFold', {'for': 'python' }
Plug 'alfredodeza/khuno.vim', { 'for': 'python' }
Plug 'darfink/vim-plist', {'for': 'plist'}
Plug 'berdandy/AnsiEsc.vim'
Plug 'vim-scripts/auto-pairs'
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-obsession'
Plug 'SirVer/ultisnips'
Plug 'Yggdroot/indentLine'
Plug 'djoshea/vim-autoread'

"git plugin
Plug 'tpope/vim-fugitive'

call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" #2 KEY BINDINGS & CONTROLL
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Tab navigation
nnoremap <silent>≥ :tabnext<CR>
nnoremap <silent>≤ :tabprev<CR>
nnoremap <silent>tn :tabnew<Space>
nnoremap <silent>˘ :tabm +<CR>
nnoremap <silent>¯ :tabm -<CR>
nnoremap <silent><tab> :>><CR>
nnoremap <silent><S-tab> :<<<CR>
"current tab merge to split
nnoremap <silent>ts :Tabmerge left<Cr>
"current split to new tab
nnoremap <silent>st <C-W>T

"Splits
"split horizontal/vertical
nnoremap <silent>sv :vs<CR>
nnoremap <silent>sh :split<CR>
"circle between splits by Alt-comma
nnoremap , <C-w><C-w>
nnoremap < <C-w>W
"Alt-W as Ctrl-W (C-W) used in tmux
nnoremap ∑ <C-W>
"split resizing
nnoremap <silent><Right> :vertical resize +5<CR>
nnoremap <silent><Left> :vertical resize -5<CR>
nnoremap <silent><Up> :res +5<CR>
nnoremap <silent><Down> :res -5<CR>

"Leader bindings
"leader to space
let mapleader =' '
nnoremap <Leader>j O<Esc>
nnoremap <Leader>k o<Esc>
nnoremap <Leader>l i<CR><Esc>
nnoremap <Leader>s :sv<CR>
nnoremap <Leader>v :vs<CR>
nnoremap <Leader>q :q!<CR>
nnoremap <Leader>w :w!<CR>
nnoremap <Leader>r :source ~/.vimrc<CR>
nnoremap <Leader>R :source ~/.vimrc<CR>:PlugInstall<CR>
"Enable methods folding with the spacebar
nnoremap <Leader><Leader> za
"wrap text by comment
vnoremap <Leader>. :call NERDComment(0, "toggle")<CR>
nnoremap <Leader>. :call NERDComment(0, "toggle")<CR>
"YouCompleteMe
map <Leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>

"Ctrl bindings
map <C-n> :NERDTreeToggle<CR>
map <C-t> :Tagbar<CR>
nnoremap <C-p> :Files<CR>
nnoremap <C-f> :GFiles<CR>
nnoremap <C-m> :History<CR>
nnoremap <C-b> :Buffers<CR>
nnoremap <C-g> :Commits<CR>
nnoremap <C-d> :Gdiff<CR>
noremap <silent> <C-k> :call smooth_scroll#up(&scroll,  10,  3)<CR>
noremap <silent> <C-j> :call smooth_scroll#down(&scroll,  10,  3)<CR>

"MISC bindings
nnoremap // :set hlsearch! hlsearch?<cr>
nnoremap <silent>~~ :set invpaste paste?<CR>
nnoremap <silent><Leader>n :set relativenumber? norelativenumber!<CR>
"python static syntax check
autocmd FileType python nmap <silent><Leader>x <Esc>:Khuno show<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" #3 VIM/NEOVIM & PLUGINS CONFIG
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim/neovim specific
if has('nvim')
    set termguicolors
    let g:python_host_prog = '/usr/local/bin/python'
    let g:python3_host_prog = '/usr/local/bin/python3'
else
    set ttyfast
    set ttymouse=xterm2
    set t_Co=256
    set nocompatible
    filetype off
endif

" syntax enable
syntax on
filetype plugin indent on

set clipboard=unnamed                   " clipboard from system
set foldmethod=syntax                   " enable methods folding
set foldlevel=99
set hidden                              " enable switching buffers without save
set history=50		                " keep 50 lines of command line history
set ruler		                " show the cursor position all the time
set showcmd		                " display incomplete commands
set incsearch		                " do incremental searching
set relativenumber nu 	                " line numbering
set omnifunc=syntaxcomplete#Complete    " smart autocompletion
set backspace=indent,eol,start          " allow backspacing over everything in insert mode
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab
set autoindent

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
    set mouse=a
endif

if has("vms")
    set nobackup	" do not keep a backup file, use versions instead
else
    set backup		" keep a backup file (restore to previous version)
    set undofile	" keep an undo file (undo changes after closing)
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")
    autocmd BufRead,BufNewFile *.applescript setf applescript
    autocmd InsertEnter,FocusLost * :set norelativenumber
    autocmd InsertLeave,FocusGained * :set relativenumber

    augroup vimrcEx
        " clear the group
        autocmd!
        autocmd FileType text setlocal textwidth=78

        " when editing a file, always jump to the last known cursor position
        autocmd BufReadPost *
            \ if line("'\"") >= 1 && line("'\"") <= line("$") |
            \   exe "normal! g`\"" |
            \ endif
    augroup END

    " load autocomplete and code snippets at launch
    augroup load_us_ycm
        autocmd!
        autocmd InsertEnter * call plug#load('ultisnips', 'YouCompleteMe')
                    \| autocmd! load_us_ycm
    augroup END
endif

if has('langmap') && exists('+langnoremap')
  " Prevent that the langmap option applies to characters that result from a
  " mapping.  If unset (default), this may break plugins (but it's backward
  " compatible).
  set langnoremap
endif

let g:UltiSnipsExpandTrigger="<C-j>"
" youcompleteme
let g:ycm_key_list_select_completion = ['<TAB>', '<Down>']
let g:ycm_autoclose_preview_window_after_completion=1
let g:ycm_min_num_of_chars_for_completion=2
" ale
let g:ale_javascript_eslint_use_global = 1
" ultisnips
" fzf-vim
        let g:fzf_layout = { 'down': '~25%' }

" moving text via vim-move
let g:move_key_modifier = 'S'

"Python syntax
let g:SimpylFold_docstring_preview=1    "folding
let g:khuno_max_line_length=120         "python syntax check

" Plist editing syntax - (vim-plist converts plist to xml)
let g:plist_display_format = 'xml'

" hide .pyc files
let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree

" Ale
let g:ale_fixers = { 'javascript': ['eslint'], 'typescript': ['eslint'] }
let g:ale_linters = {
            \ 'javascript': ['eslint'],
            \ 'typescript': ['eslint'],
            \ 'ptrhon': ['flake8']
\}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" #4 COLOR SETTINGS & SYNTAX HIGHLIGHTING
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Color Scheme
colors gruvbox
set background=dark
set noshowmode

let g:airline_theme='gruvbox'
let g:airline_left_sep="\uE0B4"
let g:airline_left_alt_sep="\uE0B5"
let g:airline_right_sep="\uE0B6"
let g:airline_right_alt_sep="\uE0B7"
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = "\uE0B4"
let g:airline#extensions#tabline#left_alt_sep = "\uE0B5"
let g:airline#extensions#tabline#right_sep = "\uE0B6"
let g:airline#extensions#tabline#right_alt_sep = "\uE0B7"

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.notexists = '[+]'

" tmuxline
let g:tmuxline_preset = {
      \'a'    : '#S',
      \'b'    : '#W',
      \'c'    : ['#(whoami)', '#(uptime | grep -ohe "up.*, [0-9] u" | sed "s/, [0-9] u//")'],
      \'win'  : ['#I', '#W'],
      \'cwin' : ['#I', '#W', '#F'],
      \'x'    : '#(cmus-remote -Q | grep "stream" | sed "s/stream/♬/")',
      \'y'    : ['%R', '%a  %b %d', '%Y'],
      \'z'    : '#(hostname | sed "s/Tomass-MacBook.local/macbook/")'}

let g:tmuxline_separators = {
    \ 'left' : '\uE0B4',
    \ 'left_alt': '\uE0B5',
    \ 'right' : '\uE0B6',
    \ 'right_alt' : '\uE0B7',
    \ 'space' : ' '}

" Flagging Unnecessary Whitespace and syntax checking
highlight BadWhitespace ctermbg=red guibg=darkred
autocmd BufRead,BufNewFile * match BadWhitespace /\s\+$/

" Line and numbers highlighting
set cursorline
autocmd BufRead,BufNewFile * hi LineNr ctermbg=237
set numberwidth=6
