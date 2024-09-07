------------------------------------------------------------
--
-- File: init.lua
--
-- Config file for NeoVim
--
-- This file is meant to be used as a reference for future 
-- self. As such, there'll be lots of comments scattered
-- throughout.
--
-- You're welcome future me.
--
-- TODO: Refactor plugins to separate files
------------------------------------------------------------

-- OPTIONS

-- Style
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smarttab = true

-- Appearance
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true

-- VARS
vim.g.mapleader = ' '

require('rncheesy.lazy_init')

local augroup = vim.api.nvim_create_augroup
local lsp_group = augroup('LspGroup', {})

local autocmd = vim.api.nvim_create_autocmd

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

-- status bar feline
require('feline').setup()

autocmd('LspAttach', {
    group = lsp_group,
    callback = function(e)
        local opts = { buffer = e.buf }
        vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set('n', '<leader>vws', function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set('n', '<leader>vd', function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set('n', '<leader>vca', function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set('n', '<leader>vrr', function() vim.lsp.buf.references() end, opts)
        vim.keymap.set('n', '<leader>vrn', function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set('i', '<C-h>', function() vim.lsp.buf.signature_help() end, opts)
        vim.keymap.set('n', '[d', function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set('n', ']d', function() vim.diagnostic.goto_prev() end, opts)
    end
})

-- local cmp = require('cmp')
-- local cmp_action = require('lsp-zero').cmp_action() -- for tab completion
-- 
-- cmp.setup({
--   -- preselect first item in completion menu
--   preselect = 'item',
--   completion = {
--     completeopt = 'menu,menuone,noinsert'
--   },
-- 
--   -- CUSTOM MAPPING
--   mapping = cmp.mapping.preset.insert({
--     -- confirm completion
--     ['<C-y>'] = cmp.mapping.confirm({select = true}),
-- 
--     -- scroll up and down the documentation window
--     ['<C-u>'] = cmp.mapping.scroll_docs(-4),
--     ['<C-d>'] = cmp.mapping.scroll_docs(4),
-- 
--     -- use <CR> to confirm completion
--     ['<CR>'] = cmp.mapping.confirm({select = false}),
-- 
--     -- tab completion
--     ['<Tab>'] = cmp_action.tab_complete(),
--     ['<S-Tab>'] = cmp_action.select_prev_or_fallback(),
--   }),
-- })

-- nvim-tree stuff
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

vim.keymap.set('i', '<C-c>', '<Esc>')

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

