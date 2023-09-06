-- BEHAVIOUR
-- Hide buffers instead of closing them
-- Absolutely essential since this allows multiple
-- files to be open at the same time.
vim.opt.hidden = true

-- Set leaders
-- Potential leaders: , - + <space> \ ` @ <cr>
vim.g.mapleader = " "
vim.g.maplocalleader = ","
vim.api.nvim_set_keymap("n", "<space>", "<nop>", { noremap = true })
vim.api.nvim_set_keymap("n", ",", "<nop>", { noremap = true })

-- Enable mouse control, nice to have sometimes
vim.opt.mouse = "a"

-- Bash-like command completion
-- First tab completes as much as possible
-- Second tab shows a list of possible completions
vim.opt.wildmode = { 'longest', 'list', 'full' }
vim.opt.wildmenu = true

-- A lot of history
vim.opt.history = 1000
vim.opt.undolevels = 1000
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- Don't make temporary/backup files
vim.opt.backup = false
vim.opt.swapfile = false

-- Airline config
vim.opt.ttimeoutlen = 50    -- Less delay when switching modes

-- Misc configs
vim.opt.backspace = { 'indent', 'eol', 'start' } -- Allow backspacing over everything in insert mode

vim.opt.foldmethod = 'syntax'
vim.opt.foldlevel = 1
vim.api.nvim_set_keymap("n", "[[", "zk", { noremap = true })
vim.api.nvim_set_keymap("n", "]]", "zj", { noremap = true })

vim.opt.number = true         -- Show line numbers
vim.opt.showmatch = true      -- Show matching parenthesis
vim.opt.autoindent = true     -- Always autoindent
vim.opt.copyindent = true     -- Copy the previous indentation on autoindenting

vim.opt.expandtabs = true     -- Use spaces instead of tabs
vim.opt.tabstop = 4           -- Tab width = 4 spaces
vim.opt.shiftwidth = 4        -- Number of spaces to use for autoindenting
vim.opt.softtabstop = 4       -- When backspacing, treat spaces like tabs, clear 4 spaces per backspace
vim.opt.shiftround = true     -- Indent to to nearest multiple of shiftwidth when using << and >>
vim.opt.smarttab = true       -- Use shiftwidth at start of lines instead of tabstop

-- Load old style vim
vim.cmd([[
set foldtext=getline(v:foldstart)
autocmd FileType python setlocal foldmethod=indent
autocmd FileType karel setlocal foldmethod=indent

set ignorecase      " Case insensitive searching
if exists("&wildignorecase")
    set wildignorecase " Case insensitive filename completion (i.e. in :e)
endif
set hlsearch        " Highlight search terms
set incsearch       " Show search matches as you type

set cindent         " Use C-indenting rules for C (probably set already)
set cinoptions+=g0  " Don't indent access specifiers (public, private)

if has("clipboard")
    set clipboard+=unnamed  " Copy to system clipboard
    if has("unnamedplus")
        set clipboard+=unnamedplus
    endif
endif

" Write file using sudo
command SUw w !sudo tee "%" > /dev/null

" Always open terminals in current window
command Term terminal ++curwin

" Use ; as an alias for : (skip the shift)
nnoremap ; :

" Use tab as the fold cycle key
nnoremap <Tab> za
nnoremap <S-Tab> zO

" Quickly get out of insert mode without reaching for escape
inoremap jj <Esc>

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
function! MyHighlights() abort
    highlight Normal guibg=none ctermbg=none

    " Highlight trailing whitespace characters.
    highlight ExtraWhitespace ctermbg=red guibg=red
    match ExtraWhitespace /\s\+$/
endfunction

augroup MyColors
    autocmd!
    autocmd ColorScheme * call MyHighlights()
augroup END


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
" Color theme
colorscheme molokai

" CamelCaseMotion
let g:camelcasemotion_key = '<leader>'

" FZF
let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -g ""'

nmap <leader>* :Ag <C-r><C-w><CR>
nmap <leader>/ :Ag<CR>

" NERDTree
map <C-n> :NERDTreeToggle<CR>  " Use Ctrl^n to toggle NERDTree
let NERDTreeMapActivateNode="<Tab>"
let NERDTreeMapOpenRecursively="<S-Tab>"

" vim-auto-save
let g:auto_save = 1                  " Enable auto saving be default
let g:auto_save_in_insert_mode = 0   " Do not auto save in insert mode
let g:auto_save_silent = 1           " Do not display notification
autocmd FileType magit let b:auto_save = 0

" GitGutter
nmap gn <Plug>(GitGutterNextHunk)    " git next
nmap gp <Plug>(GitGutterPrevHunk)    " git previous

nmap gd <Plug>(GitGutterPreviewHunk) " git diff

nmap ga <Plug>(GitGutterStageHunk)   " git add (chunk)
nmap gu <Plug>(GitGutterUndoHunk)    " git undo (chunk)

" deoplete
let g:deoplete#enable_at_startup = 1
inoremap <expr> <Tab>     pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab>   pumvisible() ? "\<C-p>" : "\<S-Tab>"
" }}} "
]])

vim.lsp.start({
  name = 'clangd',
  cmd = {'clangd'},
  root_dir = vim.fs.dirname(vim.fs.find({'CMakeLists.txt'}, { upward = true })[1]),
})
