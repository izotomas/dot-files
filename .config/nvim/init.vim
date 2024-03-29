"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" #1 PLUGIN MANAGER
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')

"navigation & searching
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'vim-scripts/Tagbar', { 'on': 'TagbarToggle' }
Plug 'junegunn/fzf',  { 'dir': '~/.fzf',  'do': './install --all'  }
Plug 'junegunn/fzf.vim'
Plug 'tweekmonster/fzf-filemru'
Plug 'terryma/vim-smooth-scroll'
Plug 'vim-scripts/Tabmerge', { 'on': 'Tabmerge' }
Plug 'szw/vim-tags'
Plug 'kana/vim-arpeggio'
Plug 'christoomey/vim-tmux-navigator'
Plug 'easymotion/vim-easymotion'

"graphical improvements
Plug 'neomake/neomake'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'morhetz/gruvbox'
Plug 'matze/vim-move'
Plug 'tpope/vim-repeat'
Plug 'cespare/vim-toml'
Plug 'edkolev/tmuxline.vim'
Plug 'auwsmit/vim-active-numbers'
Plug 'ncm2/float-preview.nvim'
Plug 'voldikss/vim-floaterm'

"text completion & editing
Plug 'dag/vim-fish', {'for': 'fish'}
Plug 'tmux-plugins/vim-tmux', {'for': 'tmux'}
Plug 'Shougo/deoplete.nvim', { 'do': 'UpdateRemotePlugins' }
Plug 'deoplete-plugins/deoplete-jedi', { 'for': 'python' }
Plug 'ponko2/deoplete-fish', {'for': 'fish'}
Plug 'leafgarland/typescript-vim'
Plug 'dense-analysis/ale'
Plug 'jelera/vim-javascript-syntax',  {'for': 'javascript'}
Plug 'jvirtanen/vim-hcl', {'for': 'hcl'}
Plug 'vim-scripts/indentpython.vim', { 'for': 'python' }
Plug 'alfredodeza/khuno.vim', { 'for': 'python' }
Plug 'darfink/vim-plist', {'for': 'plist'}
Plug 'berdandy/AnsiEsc.vim'
Plug 'chunkhang/vim-mbsync'
Plug 'vim-scripts/auto-pairs'
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-obsession'
Plug 'Yggdroot/indentLine'
Plug 'djoshea/vim-autoread'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'benmills/vimux'
Plug 'tmhedberg/SimpylFold'

call plug#end()

call arpeggio#load()
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" #2 KEY BINDINGS & CONTROLL
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Buffers
nnoremap <silent><M-Tab> :bnext<CR>
nnoremap <silent><C-w>> :bnext<CR>
nnoremap <silent><C-w>< :bprev<CR>

"Tabs
nnoremap <C-w>tn :tabnew<Space>
" merge tabs to split
nnoremap <C-w>tm :Tabmerge left<Cr>

"Splits
"split horizontal/vertical
nnoremap <C-W>v :split<CR>
nnoremap <C-W>s :vs<CR>
"close current split
nnoremap <C-w>x <C-w>c
"next split
nnoremap <M-w> <C-w>w
nnoremap , <C-w>w
"previous split
nnoremap <M-q> <C-w>W
"split resizing
nnoremap <silent><Right> :vertical resize +5<CR>
nnoremap <silent><Left> :vertical resize -5<CR>
nnoremap <silent><Up> :res +5<CR>
nnoremap <silent><Down> :res -5<CR>
nnoremap <C-W>z <C-W>\| <C-W>_<CR>

"Leader bindings
let mapleader="\<space>"

noremap <silent><Leader>qq :confirm :qa<CR>
noremap <silent><Leader>qs :q!<CR>
nnoremap <silent><leader>qb :bp <BAR> bd #<CR>
nnoremap <Leader>w :w!<CR>
nnoremap <Leader>r :source ~/.vimrc<CR>
nnoremap <Leader>R :source ~/.vimrc<CR>:PlugInstall<CR>
"wrap text by comment
vnoremap <Leader>. :call NERDComment(0, "toggle")<CR>
nnoremap <Leader>. :call NERDComment(0, "toggle")<CR>

" increment number
nnoremap <C-n> :NERDTreeToggle<CR>
nnoremap <C-t> :TagbarToggle<CR>
nnoremap <C-p> :Files<CR>
nnoremap <C-f> :GFiles<CR>
nnoremap <C-m> :History<CR>
nnoremap <C-b> :Buffers<CR>
nnoremap <C-c> :Commits<CR>
nnoremap <C-g> :FloatermNew lazygit<CR>

noremap <silent> <C-u> :call smooth_scroll#up(&scroll,  10,  2)<CR>
noremap <silent> <C-d> :call smooth_scroll#down(&scroll,  10,  2)<CR>

" Arpeggio bingings
Arpeggio nnoremap vp :VimuxPromptCommand<CR>
Arpeggio nnoremap vc :VimuxCloseRunner<CR>
Arpeggio nnoremap vl :VimuxRunLastCommand<CR>

"MISC bindings
nnoremap <C-i> <C-a>
nnoremap <leader>/ :set hlsearch! hlsearch?<cr>
nnoremap <silent>~~ :set invpaste paste?<CR>
nnoremap <silent><Leader>n :set relativenumber? norelativenumber!<CR>
"python static syntax check
autocmd FileType python nmap <silent><Leader>x <Esc>:Khuno show<CR>
" deoplete navigate through completions
inoremap <expr><Tab>  pumvisible() ? "\<C-n>" : "\<Tab>"

noremap <silent><expr><S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr><C-g> deoplete#undo_completion()

map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-sn)
map  n <Plug>(easymotion-next)
map  N <Plug>(easymotion-prev)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" #3 VARIABLES, PLUGINS & FUNCTIONS
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:NERDTreeWinPos="right"

let g:UltiSnipsExpandTrigger="<S-Tab>"
let g:UltiSnipsJumpForwardTrigger="<C-j>"
let g:UltiSnipsJumpBackwardTrigger="<C-k>"

let g:actnum_exclude =
      \ [ 'tagbar', 'vimshell', 'w3m', 'nerdtree', 'fzf' ]

" vim/neovim specific
if has('nvim')
    let g:deoplete#enable_at_startup = 1
    if $TERM_PROGRAM != 'Apple_Terminal'
        set termguicolors
    endif
    let g:python3_host_prog = '/opt/homebrew/Caskroom/miniconda/base/bin/python3'
    let g:python_host_prog = '/opt/homebrew/Caskroom/miniconda/base/bin/python'
else
    let g:deoplete#enable_at_startup = 0
    set ttyfast
    set ttymouse=xterm2
    set t_Co=256
    set nocompatible
    filetype off
endif
" autocompletion
set completeopt-=preview
let g:float_preview#docked = 0
" syntax enable
syntax on
filetype plugin indent on

set shell=/opt/homebrew/bin/fish
set clipboard=unnamed                   " clipboard from system
set foldmethod=syntax                   " enable methods folding
set foldlevel=99
set hidden                              " enable switching buffers without save
set history=50		                    " keep 50 lines of command line history
set ruler		                        " show the cursor position all the time
set showcmd		                        " display incomplete commands
set incsearch		                    " do incremental searching
set relativenumber nu 	                " line numbering
set omnifunc=syntaxcomplete#Complete    " smart autocompletion
set backspace=indent,eol,start          " allow backspacing over everything in insert mode
set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab
set autoindent

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
    set mouse=a
endif

set backupdir=/tmp
set backup		    " keep a backup file (restore  previous version)
set undofile	    " keep an undo file (undo changes after closing)

" Only do this part when compiled with support for autocommands.
if has("autocmd")
    autocmd BufRead,BufNewFile *.applescript setf applescript
    autocmd InsertEnter,FocusLost * :set norelativenumber
    autocmd InsertLeave,FocusGained * :set relativenumber
    autocmd FileType help noremap <buffer>q :q<CR>

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


endif

if has('langmap') && exists('+langnoremap')
  " Prevent that the langmap option applies to characters that result from a
  " mapping.  If unset (default), this may break plugins (but it's backward
  " compatible).
  set langnoremap
endif

let $FZF_DEFAULT_OPTS='--layout=reverse'
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }

if has('nvim') && !exists('g:fzf_layout')
  autocmd! FileType fzf
  autocmd  FileType fzf set laststatus=0 noshowmode noruler
    \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
endif

function! s:list_buffers()
  redir => list
  silent ls
  redir END
  return split(list, "\n")
endfunction

function! s:delete_buffers(lines)
  execute 'bwipeout' join(map(a:lines, {_, line -> split(line)[0]}))
endfunction

command! BD call fzf#run(fzf#wrap({
  \ 'source': s:list_buffers(),
  \ 'sink*': { lines -> s:delete_buffers(lines) },
  \ 'options': '--multi --reverse --bind ctrl-a:select-all+accept'
  \ }))

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
let g:ale_javascript_eslint_use_global = 1
let g:ale_fixers = { 'javascript': ['eslint'], 'typescript': ['eslint'] }
let g:ale_linters = {
            \ 'javascript': ['eslint'],
            \ 'typescript': ['eslint'],
            \ 'ptrhon': ['flake8']
\}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" #4 COLOR SETTINGS & SYNTAX HIGHLIGHTING:
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Color Scheme
let g:gruvbox_number_column='bg1'
colors gruvbox
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
let g:airline#extensions#tabline#formatter = 'unique_tail'

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_symbols.branch = ''
let g:airline_symbols.notexists = '[+]'

" tmuxline
let g:tmuxline_preset = {
      \'a'    : '#S',
      \'b'    : '#W',
      \'c'    : ['#(whoami)', '#(uptime | grep -ohe "up.*, [0-9] u" | sed "s/, [0-9] u//")'],
      \'win'  : ['#I', '#W'],
      \'cwin' : ['#I', '#W', '#F'],
      \'x'    : '#(cmus-remote -Q | grep "stream" | sed "s/stream/♬/")',
      \'y'    : ['%R', '%a', '%b %d', '%Y'],
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
set numberwidth=6
