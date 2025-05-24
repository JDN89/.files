local M = {}
-- vim.lsp.enable({ "clangd" })
vim.lsp.enable({ "lua_ls", "rust_analyzer" })

-- Disable inlay hints initially (and enable if needed with my ToggleInlayHints command).
vim.g.inlay_hints = false
return M
