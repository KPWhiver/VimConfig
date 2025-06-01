-- Set leaders
-- Potential leaders: , - + <space> \ ` @ <cr>
vim.g.mapleader = " "
vim.g.maplocalleader = ","
vim.api.nvim_set_keymap("n", "<space>", "<nop>", { noremap = true })
vim.api.nvim_set_keymap("n", ",", "<nop>", { noremap = true })

-- Enable mouse control
vim.opt.mouse = "a"

-- Bash-like command completion
-- First tab completes as much as possible
-- Second tab shows a list of possible completions
vim.opt.wildmode = { 'longest', 'list', 'lastused' }
vim.opt.wildmenu = true

-- History
vim.opt.history = 1000
vim.opt.undolevels = 1000
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- Don't make temporary/backup files
vim.opt.backup = false
vim.opt.swapfile = false

-- Terminal interaction
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

-- Visual cues
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

vim.opt.number = true         -- Show line numbers
vim.opt.relativenumber = true -- Show relative line numbers
vim.opt.showmatch = true      -- Show matching parenthesis
vim.opt.cursorline = true     -- Highlight line with cursor on it
vim.opt.showcmd = true        -- Show command being typed
vim.opt.winborder = 'rounded'

-- Scrolling
vim.opt.scrolloff = 5         -- Keep the cursor 5 lines away max

-- Indenting and spacing
vim.opt.autoindent = true     -- Always autoindent
vim.opt.copyindent = true     -- Copy the previous indentation on autoindenting
vim.opt.expandtab = true      -- Use spaces instead of tabs
vim.opt.tabstop = 4           -- Tab width = 4 spaces
vim.opt.shiftwidth = 4        -- Number of spaces to use for autoindenting
vim.opt.softtabstop = 4       -- When backspacing, treat spaces like tabs, clear 4 spaces per backspace
vim.opt.shiftround = true     -- Indent to to nearest multiple of shiftwidth when using << and >>
vim.opt.smarttab = true       -- Use shiftwidth at start of lines instead of tabstop

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true      -- Override ignorecase if there are capitals in the query
vim.opt.wildignorecase = true -- Case insensitive filename completion

-- Clipboard
vim.opt.clipboard = "unnamedplus" -- Copy to system clipboard
vim.g.clipboard = {
    name = "OSC 52",
    copy = {
        ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
        ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
        ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
        ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
    },
}

-- Some nice keymaps
vim.api.nvim_set_keymap("n", ";", ":", {noremap = true })
vim.api.nvim_set_keymap("i", "<C-w>", "<Esc><C-w>", {})

-- FZF
vim.api.nvim_set_keymap("n", "<C-f>", ":FZF<CR>", {})
vim.api.nvim_set_keymap("i", "<C-f>", "<Esc> :FZF<CR>", {})

-- Format using =
vim.api.nvim_set_keymap("n", "=", "gq", {noremap = true })
vim.api.nvim_set_keymap("n", "==", "gqq", {noremap = true })
vim.api.nvim_set_keymap("v", "=", "gq", {noremap = true })

-- Load old style vim
vim.cmd([[
autocmd FileType python setlocal foldmethod=indent

" Write file using sudo
command SUw w !sudo tee "%" > /dev/null

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

vim.lsp.enable({
  'lua_ls',
  'clangd',
  'nil_ls',
  'marksman',
  'cmake',
  'yamlls',
  'jsonls',
  'dockerls',
  'bashls',
  'pylsp',
})
vim.lsp.config('lua_ls', {
  -- Disable vim warnings
  settings = { Lua = { diagnostics = { globals = { 'vim' } } } }
})
vim.lsp.config('yamlls', {
  settings = {
    redhat = { telemetry = { enabled = false } },
    yaml = { keyOrdering = false },
  }
})
vim.lsp.config('jsonls', {
  cmd = { "vscode-json-languageserver", "--stdio" },
})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
  end,
})

-- local lspconfig = require('lspconfig')
-- local lsp_defaults = lspconfig.util.default_config
-- lsp_defaults.capabilities = vim.tbl_deep_extend(
--   'force',
--   lsp_defaults.capabilities,
--   require('cmp_nvim_lsp').default_capabilities()
-- )
--
-- require('luasnip.loaders.from_vscode').lazy_load()
--
-- local cmp = require('cmp')
-- local luasnip = require('luasnip')
-- vim.opt.completeopt = {'menu', 'menuone', 'noselect'}
-- cmp.setup {
--   snippet = {
--     expand = function(args)
--       luasnip.lsp_expand(args.body)
--     end
--   },
--   mapping = cmp.mapping.preset.insert({
--     ['<C-u>'] = cmp.mapping.scroll_docs(-4), -- Up
--     ['<C-d>'] = cmp.mapping.scroll_docs(4), -- Down
--     -- C-b (back) C-f (forward) for snippet placeholder navigation.
--     ['<C-Space>'] = cmp.mapping.complete(),
--     ['<CR>'] = cmp.mapping.confirm {
--       behavior = cmp.ConfirmBehavior.Replace,
--       select = true,
--     },
--     ['<Tab>'] = cmp.mapping(function(fallback)
--       if cmp.visible() then
--         cmp.select_next_item()
--       elseif luasnip.expand_or_jumpable() then
--         luasnip.expand_or_jump()
--       else
--         fallback()
--       end
--     end, { 'i', 's' }),
--     ['<S-Tab>'] = cmp.mapping(function(fallback)
--       if cmp.visible() then
--         cmp.select_prev_item()
--       elseif luasnip.jumpable(-1) then
--         luasnip.jump(-1)
--       else
--         fallback()
--       end
--     end, { 'i', 's' }),
--   }),
--   sorting = {
--     comparators = {
--       cmp.config.compare.offset,
--       cmp.config.compare.exact,
--       cmp.config.compare.recently_used,
--       require("clangd_extensions.cmp_scores"),
--       cmp.config.compare.kind,
--       cmp.config.compare.sort_text,
--       cmp.config.compare.length,
--       cmp.config.compare.order,
--     },
--   },
--   window = {
--     documentation = cmp.config.window.bordered()
--   },
--   formatting = {
--     fields = {'menu', 'abbr', 'kind'}
--   },
--   sources = {
--     { name = 'nvim_lsp' },
--     { name = 'treesitter' },
--     { name = 'path' },
--     { name = 'luasnip' },
--     { name = 'buffer' },
--   },
-- }
