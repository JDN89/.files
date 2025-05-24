require("config.lazy")

-- test

vim.opt.shiftwidth = 4

-- vim.opt.colorcolumn = "100"

vim.keymap.set("n", "<space><space>x", "<cmd>source %<CR>")
vim.keymap.set("n", "<space>x", ":.lua<CR>")
vim.keymap.set("v", "<space>x", ":lua<CR>")

vim.keymap.set("n", "<M-j>", "<cmd>cnext<CR>")
vim.keymap.set("n", "<M-k>", "<cmd>cprev<CR>")

-- Map 'jj' to Escape in insert mode
vim.keymap.set("i", "jj", "<Esc>", { desc = "Remap  [E]sc" })

vim.wo.relativenumber = true
vim.wo.number = true

vim.opt.clipboard = "unnamedplus"

vim.o.guicursor = "n:block-blinkwait100-blinkon100-blinkoff100,i:ver10"

-- show virtual diagnostics
vim.diagnostic.config({
  -- Use the default configuration
  -- virtual_lines = true

  -- Alternatively, customize specific options
  virtual_lines = {
    -- Only show virtual line diagnostics for the current cursor line
    current_line = true,
  },
})

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking text",
  group = vim.api.nvim_create_augroup("jan-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- when you call TermOPen don't set relativenumber
vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("custom-term-open", { clear = true }),
  desc = "Open neovim terminal",
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
  end,
})

-- open a small terminal in the bottom of neovim
vim.keymap.set("n", "<space>st", function()
  vim.cmd.vnew()
  vim.cmd.term()
  vim.cmd.wincmd("J")
  vim.api.nvim_win_set_height(0, 15)
end, { desc = "[S]mall [T]terminal" })

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- LSP SETUP
-- vim.lsp.enable({ "lua_ls", "rust-analyzer" })

--https://www.youtube.com/watch?v=ooTcnx066Do
--example on who to send commands to the terminal when openening the terminal
-- vim.keymap.set("n", "<space>example", function()
--     vim.fn.chansend(job_id, { "la\r\n" })
-- end)
