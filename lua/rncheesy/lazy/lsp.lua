-- LSP
-- Purpose: For linting, autocomplete, IDE

return {
    'neovim/nvim-lspconfig',

    dependencies = {
        'williamboman/mason.nvim', -- auto manages outside editor packages
        'williamboman/mason-lspconfig.nvim',

	    'hrsh7th/nvim-cmp', -- autocomplete engine
	    'hrsh7th/cmp-nvim-lsp', -- source

	    'hrsh7th/cmp-buffer', -- suggestions within buffer (file)
        'hrsh7th/cmp-path', -- suggestions within file path
        'hrsh7th/cmp-cmdline', -- suggestions within vim's cmdline (:)

        'L3MON4D3/LuaSnip', -- snippet engine
        'saadparwaiz1/cmp_luasnip',

        "j-hui/fidget.nvim", -- lsp UI components
    },

    config = function()
        local cmp = require('cmp')
        local cmp_lsp = require('cmp_nvim_lsp')

        local capabilities = vim.tbl_deep_extend( -- vim features
            'force',
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        require('fidget').setup({})
        require('mason').setup()
        require('mason-lspconfig').setup({
            ensure_installed = {
                'lua_ls',
            },

            handlers = {
                ['lua_ls'] = function()
                    local lspconfig = require('lspconfig')
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                runtime = { version = "LuaJIT" },

                                -- Runtime files (docs) for neovim
                                workspace = {
                                    library = {
                                        vim.env.VIMRUNTIME
                                    },
                                },
                                diagnostics = {
                                    globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                                }
                            }
                        }
                    }
                end,
            }
        })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({

            -- Preselects first item in completion menu
            preselect = 'item',
            completion = {
              completeopt = 'menu,menuone,noinsert'
            },

            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)
                end,
            },

            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),

                -- Safely select entries with <CR>
                -- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#safely-select-entries-with-cr
                ['<CR>'] = cmp.mapping({
                    i = function(fallback)
                        if cmp.visible() and cmp.get_active_entry() then
                            cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                        else
                            fallback()
                        end
                    end,
                    s = cmp.mapping.confirm({ select = true }),
                    c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
                }),

                -- IntelliJ-like mapping
                -- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#intellij-like-mapping
                ['<Tab>'] = cmp.mapping(function(fallback)
                    -- This little snippet will confirm with tab, and if no entry is selected, will confirm the first item
                    if cmp.visible() then
                        local entry = cmp.get_selected_entry()
                        if not entry then
                            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                        end
                        cmp.confirm()
                    else
                        fallback()
                    end
                end, {'i', 's', 'c',}),
            }),

            sources = cmp.config.sources({

                { name = 'nvim_lsp' },
                { name = 'luasnip' },

            }, {

                { name = 'buffer' },

            }),
        })

        vim.diagnostic.config({
            float = {
                focusable = false,
                style = 'minimal',
                border = 'rounded',
                header = '',
                prefix = '',

            },
        })


    end
}
