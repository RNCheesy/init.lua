return {
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
    {
        	'projekt0n/github-nvim-theme',
        	lazy = false, -- make sure we load this during startup if it is your main colorscheme
        	priority = 1000, -- make sure to load this before all the other start plugins
        	config = function()
            		require('github-theme').setup({
            	})

            	vim.cmd('colorscheme github_dark_high_contrast')
        	end,
    },
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
  	},
    	{
    		'kawre/leetcode.nvim',
    		build = ":TSUpdate html",
    		dependencies = {
        		"nvim-telescope/telescope.nvim",
        		"nvim-lua/plenary.nvim", -- required by telescope
        		"MunifTanjim/nui.nvim",

        		-- optional
        		"nvim-treesitter/nvim-treesitter",
        		"rcarriga/nvim-notify",
        		"nvim-tree/nvim-web-devicons",
    		},
    		opts = {
        	-- configuration goes here
    		},
            plugins = {
                non_standalone = true,
            },
	}
}
