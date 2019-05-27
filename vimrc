source ~/.vimrc_plugins     " Loads plugins, this is in a separate file because the different plugin loaders are used on different systems

" BEHAVIOUR {{{ "
" Hide buffers instead of closing them
" Absolutely essential since this allows multiple
" files to be open at the same time.
set hidden

" Enable mouse control, nice to have sometimes
set mouse=a

" Bash-like command completion
" First tab completes as much as possible
" Second tab shows a list of possible completions
set wildmode=longest,list,full
set wildmenu

" A lot of history
set history=1000
set undolevels=1000

" Don't make temporary/backup files
set nobackup
set noswapfile

" Airline config
set ttimeoutlen=50    " Less delay when switching modes

" Misc configs
set backspace=indent,eol,start " Allow backspacing over everything in insert mode

set number          " Show line numbers
set showmatch       " Show matching parenthesis
set autoindent      " Always autoindent
set copyindent      " Copy the previous indentation on autoindenting

set expandtab       " Use spaces instead of tabs
set tabstop=4       " Tab width = 4 spaces
set shiftwidth=4    " Number of spaces to use for autoindenting
set softtabstop=4   " When backspacing, treat spaces like tabs, clear 4 spaces per backspace
set shiftround      " Indent to to nearest multiple of shiftwidth when using << and >>
set smarttab        " Use shiftwidth at start of lines instead of tabstop

set ignorecase      " Case insensitive searching
if exists("&wildignorecase")
    set wildignorecase " Case insensitive filename completion (i.e. in :e)
endif
set hlsearch        " Highlight search terms
set incsearch       " Show search matches as you type

set cindent         " Use C-indenting rules for C (probably set already)
set cinoptions+=g0  " Don't indent access specifiers (public, private)

if has("clipboard")
    set clipboard=unnamed  " Copy to system clipboard
    if has("unnamedplus")
        set clipboard+=unnamedplus
    endif
endif

" Write file using sudo
command SUw w !sudo tee "%" > /dev/null

" Always open terminals in current window
command Term terminal ++curwin

" Make escape work in terminal mode
tnoremap <Esc> <C-\><C-n>

" Why cycle when you can fly
nnoremap <leader>l :ls<CR>:b<space>

" Use ; as an alias for : (skip the shift)
nnoremap ; :

" Quickly get out of insert mode without reaching for escape
inoremap jj <Esc>

" Use ENTER in normal mode to insert a newline
nmap <CR> a<CR><Esc>

" Allow usage of CTRL W in insert mode
imap <C-w> <Esc><C-w>

" Use CTRL F and to find files
map <C-f> :FZF<CR>
imap <C-f> <Esc> :FZF<CR>

" Change the cursor based on the mode (only works in konsole)
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_SR = "\<Esc>]50;CursorShape=2\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

" }}} BEHAVIOUR "

" APPEARANCE {{{ "
" Color theme
colorscheme molokai

" Use actual truecolor colors if available
if has("termguicolors")
    set termguicolors
endif

" Show command as it's being entered
" Also shows size of selection in visual mode
set showcmd

" Don't let cursor go all the way to the top of the screen,
" always show five lines above/below cursor
set scrolloff=5

" Highlight current line
set cursorline

" Always show status line
set laststatus=2

" }}} "

" PLUGINS {{{

" NERDTree
map <C-n> :NERDTreeToggle<CR>  " Use Ctrl^n to toggle NERDTree

" vim-auto-save
let g:auto_save = 1                  " Enable auto saving be default
let g:auto_save_in_insert_mode = 0   " Do not auto save in insert mode
let g:auto_save_silent = 1           " Do not display notification
" }}} "

