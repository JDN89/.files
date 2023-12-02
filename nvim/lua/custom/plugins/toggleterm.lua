return
    {
	    "akinsho/toggleterm.nvim",
	    config = function()
		    require("toggleterm").setup {
			    direction = 'float',
		    }
		    -- Bind `Shift + K` to toggle the terminal
		    vim.api.nvim_set_keymap('n', '<leader>tt', '<CMD>ToggleTerm<CR>',
			    { noremap = true, silent = true })
	    end
    }
    ,
    {
	    "windwp/nvim-autopairs",
	    config = function()
		    require("nvim-autopairs").setup {
		    }
	    end
    }
