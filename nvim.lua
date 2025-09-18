-- File tree (netrw config needs to be first)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require('nvim-web-devicons').setup({
  default = true;
  strict = true;
})

local file_browser = require('nvim-tree.api')
require('nvim-tree').setup({
  on_attach = function (bufnr)
    local function opts(desc)
      return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    file_browser.config.mappings.default_on_attach(bufnr)
    vim.keymap.set('n', 'y', file_browser.fs.copy.node, opts('copy'))
    vim.keymap.set('n', 'i', file_browser.tree.toggle_gitignore_filter, opts('ignore'))
    vim.keymap.set('n', 'h', file_browser.tree.toggle_hidden_filter, opts('hidden'))
    vim.keymap.set('n', '<Esc>', '<C-w><C-w>', opts('cancel'))
    vim.keymap.set('n', '<BS>', file_browser.node.navigate.parent, opts('parent'))
    vim.keymap.set('n', '<S-Tab>', file_browser.tree.expand_all, opts('expand'))
  end
})
vim.keymap.set({'n', 'i'}, '<C-f>', file_browser.tree.focus)

-- Set leaders
vim.g.mapleader = " "
vim.keymap.set("n", "<space>", "<nop>", { noremap = true })

-- LSP & treesitter
require('nvim-treesitter.configs').setup({
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
        ['as'] = { query = '@local.scope', query_group = 'locals' },
      },
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        [']f'] = '@function.outer',
        [']c'] = '@class.outer',
        [']s'] = { query = '@local.scope', query_group = 'locals' }
      },
      goto_next_end = {
        [']F'] = '@function.outer',
        [']C'] = '@class.outer',
        [']S'] = { query = '@local.scope', query_group = 'locals' }
      },
      goto_previous_start = {
        ['[f'] = '@function.outer',
        ['[c'] = '@class.outer',
        ['[s'] = { query = '@local.scope', query_group = 'locals' }
      },
      goto_previous_end = {
        ['[F'] = '@function.outer',
        ['[C'] = '@class.outer',
        ['[S'] = { query = '@local.scope', query_group = 'locals' }
      },
    },
  },
})

local overseer = require('overseer')
overseer.setup({})
overseer.add_template_hook({ module = "^cargo$" }, function(task_defn, util)
  util.add_component(task_defn, { "on_output_quickfix", set_diagnostics = true })
  util.add_component(task_defn, { "on_result_diagnostics" })
end)
overseer.add_template_hook({ module = "^just$" }, function(task_defn, util)
  util.add_component(task_defn, { "on_output_quickfix", set_diagnostics = true })
  util.add_component(task_defn, { "on_result_diagnostics" })
end)
vim.keymap.set('n', '<leader>c', ':OverseerRun<CR>')
vim.keymap.set({'n', 'i'}, '<C-c>', '<Esc>:OverseerOpen<CR>')

local trouble = require('trouble')
trouble.setup({
  focus = true,
  keys = {
    ['<Tab>'] = 'jump',
    ['<S-Tab>'] = 'fold_open_recursive',
  },
})
vim.keymap.set({'n', 'i'}, '<C-e>', '<Esc>:Trouble quickfix<CR>')
vim.keymap.set({'n', 'i'}, '<C-r>', '<Esc>:Trouble lsp_references<CR>')
vim.keymap.set({'n', 'i'}, '<C-t>', '<Esc>:Trouble lsp_type_definitions<CR>')
vim.keymap.set({'n', 'i'}, '<C-d>', '<Esc>:Trouble lsp_definitions<CR>')
vim.keymap.set({'n', 'i'}, '<C-S-d>', '<Esc>:Trouble lsp_definitions<CR>')
vim.keymap.set({'n', 'i'}, '<C-s>', '<Esc>:Trouble lsp_document_symbols win.position=right<CR>')
vim.keymap.set({'n', 'i'}, '<C-/>', '<Esc>:Trouble telescope<CR>')
vim.keymap.set({'n', 'i'}, '<C-o>', '<Esc>:Trouble telescope_files<CR>')

vim.lsp.enable({
  'lua_ls',
  'clangd',
  'nil_ls',
  'marksman',
  'mesonlsp',
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
vim.keymap.set('n', ']d', function()
  vim.diagnostic.goto_next()
  vim.schedule(function()
    vim.diagnostic.open_float({ source = true })
  end)
end)
vim.keymap.set('n', '[d', function()
  vim.diagnostic.goto_prev()
  vim.schedule(function()
    vim.diagnostic.open_float({ source = true })
  end)
end)

local lspconfig = require('lspconfig')
local lsp_defaults = lspconfig.util.default_config
lsp_defaults.capabilities = vim.tbl_deep_extend(
   'force',
   lsp_defaults.capabilities,
   require('cmp_nvim_lsp').default_capabilities()
)

require('luasnip.loaders.from_vscode').lazy_load()

local cmp = require('cmp')
local luasnip = require('luasnip')
vim.opt.completeopt = {'menu', 'menuone', 'noselect'}
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end
  },
  mapping = cmp.mapping({
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
    { name = 'luasnip' },
    { name = 'buffer' },
 },
}

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

vim.opt.foldlevel = 20
vim.opt.foldlevelstart = 1
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldtext = ''
vim.opt.foldnestmax = 4
vim.keymap.set("n", "<Tab>", "za", {noremap = true })
vim.keymap.set("n", "<S-Tab>", "zA", {noremap = true })
vim.keymap.set({'n', 'v'}, "]<Tab>", "zj", { noremap = true })
vim.keymap.set({'n', 'v'}, "[<Tab>", "zk", { noremap = true })

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

-- Scrolling
vim.opt.scrolloff = 5         -- Keep the cursor 5 lines away max

-- Indenting and spacing
vim.opt.autoindent = true     -- Always autoindent
vim.opt.copyindent = true     -- Copy the previous indentation on autoindenting
vim.opt.expandtab = true      -- Use spaces instead of tabs
vim.opt.tabstop = 4           -- Tab width = 4 spaces
vim.opt.shiftwidth = 4        -- Number of spaces to use for autoindenting
vim.opt.softtabstop = 4       -- When backspacing, treat spaces like tabs, clear 4 spaces per backspace
vim.opt.shiftround = true     -- Indent to to nearest multiple of hiftwidth when using << and >>
vim.opt.smarttab = true       -- Use shiftwidth at start of lines instead of tabstop
require('guess-indent').setup({})
require('ibl').setup({})

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
vim.keymap.set({'n', 'v'}, ";", ":", { noremap = true })
vim.keymap.set("i", "<C-w>", "<Esc><C-w>")
vim.keymap.set('n', '<S-u>', ":redo")
vim.keymap.set('n', 'q:', ':q<CR>')

-- Motion
vim.keymap.set("n", "<BS>", "<C-o>")
vim.keymap.set("n", "<S-Del>", "<C-i>")  -- Shift Backspace (send by foot)
vim.keymap.set({'c', 'i', 'v'}, "<S-Del>", "<BS>")   -- Shift Backspace (send by foot)

-- Write file using sudo
vim.api.nvim_create_user_command('SUw', 'w !sudo -S tee "%" > /dev/null', {})

-- Auto saving
require('auto-save').setup({})

-- Git integration
local gitsigns = require('gitsigns')
gitsigns.setup({
  current_line_blame = true,
  on_attach = function()
    vim.keymap.set("n", "-d", gitsigns.preview_hunk_inline)
    vim.keymap.set("n", "-a", gitsigns.stage_hunk)
    vim.keymap.set("v", "-a", function()
      gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end)
    vim.keymap.set("n", "-u", gitsigns.reset_hunk)
    vim.keymap.set("v", "-u", function()
      gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end)
    vim.keymap.set("n", "-b", gitsigns.blame)
    vim.api.nvim_create_user_command("Gedit", function(opts)
      gitsigns.show(opts.args)
    end, { nargs = "*" })
    vim.keymap.set("n", "]-", function()
      gitsigns.nav_hunk('next')
    end)
    vim.keymap.set("v", "]-", function()
      gitsigns.nav_hunk('next')
    end)
    vim.keymap.set("n", "[-", function()
      gitsigns.nav_hunk('prev')
    end)
    vim.keymap.set("v", "[-", function()
      gitsigns.nav_hunk('prev')
    end)
  end
})
require('toggleterm').setup({
  shade_terminals = false,
  direction = 'float',
  float_opts = {
    border = {''},
  },
  highlights = {
    NormalFloat = {
      link = "TelescopeNormal",
    },
  },
})
local Terminal = require('toggleterm.terminal').Terminal
local lazygit = Terminal:new({
  cmd = 'lazygit',
  hidden = true,
})
vim.keymap.set('n', '<leader>-', function()
  lazygit:toggle()
end)

-- Telescope
local telescope = require('telescope')
local telescope_actions = require('telescope.actions')
local telescope_actions_state = require('telescope.actions.state')
local telescope_trouble = require('trouble.sources.telescope')
telescope.load_extension('fzf')
telescope.load_extension('remote-sshfs')
telescope.setup({
  defaults = {
    border = false,
    color_devicons = true,
    mappings = {
      i = {
        ['<Esc>'] = telescope_actions.close,
        ['<CR>'] = function (prompt_bufnr)
          local picker = telescope_actions_state.get_current_picker(prompt_bufnr)
          local multi_selection = picker:get_multi_selection()
            if #multi_selection > 1 then
              telescope_trouble.open(prompt_bufnr)
            else
              telescope_actions.select_default(prompt_bufnr)
            end
          end
      }
    },
  }
})
local telescope_builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>f', telescope_builtin.find_files)
vim.keymap.set('n', '<leader>*', telescope_builtin.grep_string)
vim.keymap.set('n', '<leader>/', function()
  telescope_builtin.grep_string{shorten_path = true, word_match = '-w', only_sort_text = true, search = ''}
end)
vim.keymap.set('n', '<leader><BS>', telescope_builtin.jumplist)
vim.keymap.set('n', '<leader>p', telescope_builtin.registers)

-- require('remote-sshfs').setup({
--   ui = { confirm = false },
-- })
vim.api.nvim_create_user_command('SSH', 'RemoteSSHFSConnect <args>', { nargs = '*'})

-- Highlight trailing whitespace
vim.api.nvim_set_hl(0, 'TrailingWhitespace', { bg='LightRed' })
vim.api.nvim_create_autocmd('BufEnter', {
	pattern = '*',
	command = [[
		syntax clear TrailingWhitespace |
		syntax match TrailingWhitespace "\_s\+$"
	]]}
)

-- CamelCaseMotion
vim.keymap.set('n', '\'', '<Plug>CamelCaseMotion_w')
vim.keymap.set({'o', 'x'}, 'i\'', '<Plug>CamelCaseMotion_ie')
vim.keymap.set({'o', 'x'}, '\'', '<Plug>CamelCaseMotion_e')

-- Open new window
local clone_window = function ()
  local esc_code = vim.api.nvim_replace_termcodes('<Esc>', true, false, true)
  vim.api.nvim_feedkeys(esc_code, 'n', false)
  vim.api.nvim_feedkeys(esc_code, 'n', false)

  local file_path = vim.fn.expand('%:p')
  local command = {'foot', 'nvim'}
  if file_path ~= '' then
    vim.cmd(':w')
    table.insert(command, file_path)
  end
  vim.fn.jobstart(command, {detach = true})
end
vim.keymap.set({'i', 'n', 'v'}, '<C-n>', clone_window)

-- Theme
require('monokai-pro').setup({
  transparent_background = true,
  devicons = true,
  background_clear = {},
  filter = 'octagon',
  override = function(c)
    return {
      IblIndent = { fg = c.base.gray },
      IblWhitespace = { fg = c.base.gray },
    }
  end,
})
vim.cmd.colorscheme 'monokai-pro'

-- Status line
require('lualine').setup({
  options = { theme = 'monokai-pro' }
})

