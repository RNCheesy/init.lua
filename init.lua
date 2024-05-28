-- Custom options
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smarttab = true

-- Remove auto comment insertion
-- https://vim.fandom.com/wiki/Disable_automatic_comment_insertion#Comments
-- NOTE: this solution doesn't work because of the order of files sourced
-- vim.opt.formatoptions:remove { "c", "r", "o" }

-- using autocmd instead
-- from https://stackoverflow.com/a/78501693
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = vim.api.nvim_create_augroup("FormatOptions", { clear = true }),
  pattern = { "*" },
  callback = function()
    vim.opt_local.fo:remove("o")
    vim.opt_local.fo:remove("r")
  end,
})


-- lazy.nvim plugin manager
-- from https://lsp-zero.netlify.app/v3.x/tutorial.html

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
local uv = vim.uv or vim.loop

-- Auto-install lazy.nvim if not present
if not uv.fs_stat(lazypath) then
  print('Installing lazy.nvim....')
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
  print('Done.')
end

vim.opt.rtp:prepend(lazypath)

-- Plugins
require('lazy').setup({

-- Uncomment the two plugins below if you want to manage the language servers from neovim
-- TODO: Use this later (used npm to install tsserver manually)
-- {'williamboman/mason.nvim'},
-- {'williamboman/mason-lspconfig.nvim'},

-- LSP client setup for NeoVim
-- Read that LSP Zero is a good out of the box solution
-- with minimal effort on my end
-- https://github.com/VonHeikemen/lsp-zero.nvim
	{'VonHeikemen/lsp-zero.nvim', branch = 'v3.x'},
	{'neovim/nvim-lspconfig'},
	{'hrsh7th/cmp-nvim-lsp'},
	{'hrsh7th/nvim-cmp'},
	{'L3MON4D3/LuaSnip'},


	{'feline-nvim/feline.nvim'}, -- status bar
	{'nvim-telescope/telescope-file-browser.nvim', dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' }},
	{
  		'nvim-tree/nvim-tree.lua',
  		version = '*',
  		lazy = false,
  		dependencies = {
  		  'nvim-tree/nvim-web-devicons',
  		},
  		config = function()
  		  require('nvim-tree').setup {}
  		end, 
  	}
})

vim.opt.termguicolors = true

-- display line numbers and relative line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- status bar feline
require('feline').setup()

-- LSP ZERO setup
local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp_zero.default_keymaps({buffer = bufnr})
end)

-- LANGUAGE SERVERS SETUP

-- lua setup (for this init.lua)
require'lspconfig'.lua_ls.setup{}

-- javascript/typescript setup
require'lspconfig'.tsserver.setup{}

-- python setup
require'lspconfig'.pyright.setup{}

-- Customizing lsp-cmp
-- TODO: Consider adding cmp-buffer for extracting suggestions from current buffer
local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action() -- for tab completion

cmp.setup({
  -- preselect first item in completion menu
  preselect = 'item',
  completion = {
    completeopt = 'menu,menuone,noinsert'
  },

  -- CUSTOM MAPPING
  mapping = cmp.mapping.preset.insert({
    -- confirm completion
    ['<C-y>'] = cmp.mapping.confirm({select = true}),

    -- scroll up and down the documentation window
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),

    -- use <CR> to confirm completion
    ['<CR>'] = cmp.mapping.confirm({select = false}),

    -- tab completion
    ['<Tab>'] = cmp_action.tab_complete(),
    ['<S-Tab>'] = cmp_action.select_prev_or_fallback(),
  }),
})

-- colorscheme
vim.cmd[[colorscheme elflord]]

-- telescope file browser
-- open file_browser with the path of the current buffer
vim.keymap.set('n', '<space>fb', ':Telescope file_browser path=%:p:h select_buffer=true<CR>')

-- nvim-tree stuff
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

-- h, j, k, l Style Navigation And Editing
-- https://github.com/nvim-tree/nvim-tree.lua/wiki/Recipes
-- global
local function my_on_attach(bufnr)
  local api = require('nvim-tree.api')

  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  local function edit_or_open()
    local node = api.tree.get_node_under_cursor()

    if node.nodes ~= nil then
      -- expand or collapse folder
      api.node.open.edit()
    else
      -- open file
      api.node.open.edit()
      -- Close the tree if file was opened
      api.tree.close()
    end
  end

  -- open as vsplit on current node
  local function vsplit_preview()
    local node = api.tree.get_node_under_cursor()
  
    if node.nodes ~= nil then
      -- expand or collapse folder
      api.node.open.edit()
    else
      -- open file as vsplit
      api.node.open.vertical()
    end
  
    -- Finally refocus on tree if it was lost
    api.tree.focus()
  end

  -- default mappings
  api.config.mappings.default_on_attach(bufnr)

  --custom mappings
  -- global
  
  -- on_attach
  vim.keymap.set('n', 'l', edit_or_open,          opts('Edit Or Open'))
  vim.keymap.set('n', 'L', vsplit_preview,        opts('Vsplit Preview'))
  vim.keymap.set('n', 'h', api.tree.close,        opts('Close'))
  vim.keymap.set('n', 'H', api.tree.collapse_all, opts('Collapse All'))

end

vim.api.nvim_set_keymap('n', '<C-h>', ':NvimTreeToggle<cr>', {silent = true, noremap = true})

-- pass to setup along with your other options
require('nvim-tree').setup {
  on_attach = my_on_attach,
}

