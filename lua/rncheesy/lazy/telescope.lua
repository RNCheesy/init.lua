-- File browser extension
-- Purpose: Finder for file hopping

return {
    'nvim-telescope/telescope-file-browser.nvim',

    dependencies = {
        'nvim-telescope/telescope.nvim',
        'nvim-lua/plenary.nvim'
    },

    config = function()
        require('telescope').setup({})

        -- Mappings: Pickers 

        local builtin = require('telescope.builtin')

        -- "project find"
        vim.keymap.set('n', '<leader>pf', builtin.find_files, {})

        vim.keymap.set('n', '<C-p>', builtin.git_files, {})

        -- Searches for word under cursor in cwd: "project word search"
        -- Note: telescope uses `ripgrep` as backend
        vim.keymap.set('n', '<leader>pws', function()
            local word = vim.fn.expand("<cword>")
            builtin.grep_string({ search = word })
        end)

        -- Searches for WORD under cursor in cwd
        vim.keymap.set('n', '<leader>pWs', function()
            local word = vim.fn.expand("<cWORD>")
            builtin.grep_string({ search = word })
        end)

        -- Searches for string specified in command line in cwd: "project search"
        vim.keymap.set('n', '<leader>ps', function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end)

        -- View relevant help tags: "view help"
        vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})

        -- Mappings: telescope-file-browser

        local fb = require('telescope').extensions.file_browser

        -- Open file_browser with the path of the current buffer
        vim.keymap.set('n', '<leader>fb', function()
            local path = vim.fn.expand('%:p:h')
            fb.file_browser({ path = path, select_buffer = true })
        end)

    end
}
