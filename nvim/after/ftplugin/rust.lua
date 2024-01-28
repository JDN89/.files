local bufnr = vim.api.nvim_get_current_buf()
print("hello form rust.lua")

vim.keymap.set(
	"n",
	"<leader>ra",
	function()
		vim.cmd.RustLsp('codeAction') -- supports rust-analyzer's grouping
		-- or vim.lsp.buf.codeAction() if you don't want grouping.
	end,

	{ silent = true, buffer = bufnr }
)

vim.keymap.set(
	"n",
	"<leader>re",
	function()
		vim.cmd.RustLsp('explainError')
	end,

	{ silent = true, buffer = bufnr }
)
vim.keymap.set(
	"n",
	"<leader>rx",
	function()
		vim.cmd.RustLsp('externalDocs')
	end,

	{ silent = true, buffer = bufnr }
)

vim.keymap.set(
	"n",
	"<leader>rd",
	function()
		vim.cmd.RustLsp('renderDiagnostic')
	end,

	{ silent = true, buffer = bufnr }
)
