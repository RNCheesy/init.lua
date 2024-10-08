return {
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
        		-- "nvim-treesitter/nvim-treesitter",
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
