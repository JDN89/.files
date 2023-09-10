-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
	{
		'saecki/crates.nvim',
		requires = { 'nvim-lua/plenary.nvim' },
		config = function()
			require('crates').setup {

			}
		end,
	},
	{
		-- RUST LSP
		"simrat39/rust-tools.nvim",
		dependencies = "neovim/nvim-lspconfig",
		config = function()
			require("rust-tools").setup({
				tools = {
					autoSetHints = true,
					inlay_hints = {
						show_parameter_hints = true,
						parameter_hints_prefix = "<- ",
						other_hints_prefix = "=> "
					}
				},
				--
				-- all the opts to send to nvim-lspconfig
				-- these override the defaults set by rust-tools.nvim
				--
				-- REFERENCE:
				-- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
				-- https://rust-analyzer.github.io/manual.html#configuration
				-- https://rust-analyzer.github.io/manual.html#features
				--
				-- NOTE: The configuration format is `rust-analyzer.<section>.<property>`.
				--       <section> should be an object.
				--       <property> should be a primitive.
				--
				--
				server = {
					on_attach = function(client, bufnr)
						require("shared/lsp")(client, bufnr)
						require("illuminate").on_attach(client)
					end,
					["rust-analyzer"] = {
						assist = {
							importEnforceGranularity = true,
							importPrefix = "create"
						},
						cargo = { allFeatures = true },
						checkOnSave = {
							-- default: `cargo check`
							command = "clippy",
							allFeatures = true
						}
					},
					inlayHints = {
						auto = true,
						only_current_line = false,
						show_parameter_hints = true,
						highlight = "Comment",
						-- NOT SURE THIS IS VALID/WORKS 😬
						lifetimeElisionHints = {
							enable = true,
							useParameterNames = true
						}
					}
				}
			})
		end
	},
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
	},
}
