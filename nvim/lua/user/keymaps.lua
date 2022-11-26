-- Shorten function name
local keymap = vim.keymap.set
-- Silent keymap option
local opts = { silent = true }

-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Set space as leader
keymap("n", "<leader>e", ":NvimTreeToggle<CR>", opts)

-- Comment
keymap("n", "<leader>/", "<cmd>lua require('Comment.api').toggle_current_linewise()<CR>", opts)
keymap("x", "<leader>/", '<ESC><CMD>lua require("Comment.api").toggle_linewise_op(vim.fn.visualmode())<CR>')

keymap("n", "<leader>rh", "<cmd>RustSetInlayHints<Cr>", opts)
keymap("n", "<leader>rhd", "<cmd>RustDisableInlayHints<Cr>", opts)
keymap("n", "<leader>th", "<cmd>RustToggleInlayHints<Cr>", opts)
keymap("n", "<leader>rr", "<cmd>RustRunnables<Cr>", opts)
keymap("n", "<leader>rem", "<cmd>RustExpandMacro<Cr>", opts)
keymap("n", "<leader>roc", "<cmd>RustOpenCargo<Cr>", opts)
keymap("n", "<leader>rpm", "<cmd>RustParentModule<Cr>", opts)
keymap("n", "<leader>rjl", "<cmd>RustJoinLines<Cr>", opts)
keymap("n", "<leader>rha", "<cmd>RustHoverActions<Cr>", opts)
keymap("n", "<leader>rhr", "<cmd>RustHoverRange<Cr>", opts)
keymap("n", "<leader>rmd", "<cmd>RustMoveItemDown<Cr>", opts)
keymap("n", "<leader>rmu", "<cmd>RustMoveItemUp<Cr>", opts)
keymap("n", "<leader>rsb", "<cmd>RustStartStandaloneServerForBuffer<Cr>", opts)
keymap("n", "<leader>rd", "<cmd>RustDebuggables<Cr>", opts)
keymap("n", "<leader>rv", "<cmd>RustViewCrateGraph<Cr>", opts)
keymap("n", "<leader>rw", "<cmd>RustReloadWorkspace<Cr>", opts)
keymap("n", "<leader>rss", "<cmd>RustSSR<Cr>", opts)
keymap("n", "<leader>rxd", "<cmd>RustOpenExternalDocs<Cr>", opts)

-- Telescope
keymap("n", "<leader>ff", ":Telescope find_files<CR>", opts)
keymap("n", "<leader>ft", ":Telescope live_grep<CR>", opts)
keymap("n", "<leader>fp", ":Telescope projects<CR>", opts)
keymap("n", "<leader>fb", ":Telescope buffers<CR>", opts)

