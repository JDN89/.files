require("config.lazy")
require("lsp")

-- test

-- vim.lsp.enable({ "rust_analyzer" })

--

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

-----------------------------
-- VIRTUAL LINES: Start with virtual lines diabled
-----------------------------
vim.diagnostic.config({
  virtual_lines = false,
})

-- Track virtual lines state
local virtual_lines_enabled = false

-- Toggle function
local function toggle_virtual_lines()
  virtual_lines_enabled = not virtual_lines_enabled

  vim.diagnostic.config({
    -- true {true} or false = true
    -- false and {true} -> false
    -- false 0r false -> false
    virtual_lines = virtual_lines_enabled and { current_line = true } or false,
  })
  print("Virtual lines: " .. (virtual_lines_enabled and "ON" or "OFF"))
end

-- Keymap: <leader>vt
vim.keymap.set(
  "n",
  "<leader>vt",
  toggle_virtual_lines,
  { desc = "[T]oggle [V]irtual diagnostic lines" }
)
----------------------------

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
