-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
	{ "akinsho/toggleterm.nvim", tag = '*', config = function()
		require("toggleterm").setup {
			direction = 'float',
		}
	end }
	,
	{
		"windwp/nvim-autopairs",
		config = function() require("nvim-autopairs").setup {
		} end
	},
	--[[ {
		'nvim-tree/nvim-tree.lua',
		requires = {
			'nvim-tree/nvim-web-devicons', -- optional, for file icons
		}
	} ]]
}
