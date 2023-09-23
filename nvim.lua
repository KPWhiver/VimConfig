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

vim.opt.foldlevel = 1
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldtext = 'getline(v:foldstart)'
vim.cmd('set nofoldenable')
vim.api.nvim_set_keymap("n", "<Tab>", "za", {noremap = true })
vim.api.nvim_set_keymap("n", "<S-Tab>", "z0", {noremap = true })
vim.api.nvim_set_keymap("n", "[[", "zk", { noremap = true })
vim.api.nvim_set_keymap("n", "]]", "zj", { noremap = true })

vim.opt.number = true         -- Show line numbers
vim.opt.showmatch = true      -- Show matching parenthesis
vim.opt.autoindent = true     -- Always autoindent
vim.opt.copyindent = true     -- Copy the previous indentation on autoindenting

vim.opt.expandtab = true     -- Use spaces instead of tabs
vim.opt.tabstop = 4           -- Tab width = 4 spaces
vim.opt.shiftwidth = 4        -- Number of spaces to use for autoindenting
vim.opt.softtabstop = 4       -- When backspacing, treat spaces like tabs, clear 4 spaces per backspace
vim.opt.shiftround = true     -- Indent to to nearest multiple of shiftwidth when using << and >>
vim.opt.smarttab = true       -- Use shiftwidth at start of lines instead of tabstop

vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.wildignorecase = true -- Case insensitive filename completion

vim.opt.cindent = true    -- Use C-indenting rules for C (probably set already
vim.opt.cinoptions = 'g0' -- Don't indent access specifiers (public, private)

vim.opt.clipboard = "unnamedplus" -- Copy to system clipboard

vim.api.nvim_set_keymap("n", ";", ":", {noremap = true })
vim.api.nvim_set_keymap("i", "<C-w>", "<Esc><C-w>", {})

vim.api.nvim_set_keymap("n", "<C-f>", ":FZF<CR>", {})
vim.api.nvim_set_keymap("i", "<C-f>", "<Esc> :FZF<CR>", {})

-- Load old style vim
vim.cmd([[
autocmd FileType python setlocal foldmethod=indent
autocmd FileType karel setlocal foldmethod=indent

" Write file using sudo
command SUw w !sudo tee "%" > /dev/null

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
nmap +n <Plug>(GitGutterNextHunk)    " git next
nmap +p <Plug>(GitGutterPrevHunk)    " git previous

nmap +d <Plug>(GitGutterPreviewHunk) " git diff

nmap +a <Plug>(GitGutterStageHunk)   " git add (chunk)
nmap +u <Plug>(GitGutterUndoHunk)    " git undo (chunk)
" }}} "
]])

require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true
  }
}

local sign = function(opts)
  vim.fn.sign_define(opts.name, {
    texthl = opts.name,
    text = opts.text,
    numhl = ''
  })
end

sign({name = 'DiagnosticSignError', text = '✘'})
sign({name = 'DiagnosticSignWarn', text = '▲'})
sign({name = 'DiagnosticSignHint', text = '⚑'})
sign({name = 'DiagnosticSignInfo', text = ''})

local lspconfig = require('lspconfig')
local lsp_defaults = lspconfig.util.default_config
lsp_defaults.capabilities = vim.tbl_deep_extend(
  'force',
  lsp_defaults.capabilities,
  require('cmp_nvim_lsp').default_capabilities()
)

lspconfig.clangd.setup{}
lspconfig.lua_ls.setup{ single_file_support = true }
lspconfig.nil_ls.setup{}

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function()
    --require('clangd_extensions.inlay_hints').setup_autocmd()
    --require('clangd_extensions.inlay_hints').set_inlay_hints()

    local opts = { buffer = true }
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', 'go', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, opts)
    --vim.keymap.set('n', '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>')
    --vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>')
    --vim.keymap.set('x', '<F4>', '<cmd>lua vim.lsp.buf.range_code_action()<cr>')
    vim.keymap.set('n', 'gl', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '<S-Tab>', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', '<Tab>', vim.diagnostic.goto_next, opts)
    vim.keymap.set('n', 'gf', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

local cmp = require('cmp')
vim.opt.completeopt = {'menu', 'menuone', 'noselect'}
cmp.setup {
  mapping = cmp.mapping.preset.insert({
    ['<C-u>'] = cmp.mapping.scroll_docs(-4), -- Up
    ['<C-d>'] = cmp.mapping.scroll_docs(4), -- Down
    -- C-b (back) C-f (forward) for snippet placeholder navigation.
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sorting = {
    comparators = {
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.recently_used,
      require("clangd_extensions.cmp_scores"),
      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },
  window = {
    documentation = cmp.config.window.bordered()
  },
  formatting = {
    fields = {'menu', 'abbr', 'kind'}
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'treesitter' },
    { name = 'path' },
    { name = 'buffer' },
  },
}
