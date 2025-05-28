-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  -- NOTE: Yes, you can install new plugins here!
  "mfussenegger/nvim-dap",
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    "rcarriga/nvim-dap-ui",

    -- Required dependency for nvim-dap-ui
    "nvim-neotest/nvim-nio",

    -- Installs the debug adapters for you
    "williamboman/mason.nvim",
    "jay-babu/mason-nvim-dap.nvim",

    -- Add your own debuggers here
    "leoluz/nvim-dap-go",
  },
  keys = function(_, keys)
    local dap = require("dap")
    local dapui = require("dapui")
    local widgets = require("dap.ui.widgets")
    return {
      -- Updated debugging keymaps to match IntelliJ IDEA's defaults
      { "<F9>", dap.continue, desc = "Debug: Start/Continue" },
      { "<F7>", dap.step_into, desc = "Debug: Step Into" },
      { "<F8>", dap.step_over, desc = "Debug: Step Over" },
      { "<S-F8>", dap.step_out, desc = "Debug: Step Out" }, -- <S-F8> means Shift+F8
      { "<leader>b", dap.toggle_breakpoint, desc = "Debug: Toggle Breakpoint" },
      {
        "<C-S-F8>",
        function()
          dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end,
        desc = "Debug: Set Conditional Breakpoint",
      },
      -- Toggle UI for debugging output or session results
      { "<A-5>", dapui.toggle, desc = "Debug: Toggle Debugger UI" },
      unpack(keys),
    }
  end,
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    require("mason-nvim-dap").setup({
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        "delve",
        "codelldb", -- C/C++ debugger
      },
    })

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup({
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
      controls = {
        icons = {
          pause = "⏸",
          play = "▶",
          step_into = "⏎",
          step_over = "⏭",
          step_out = "⏮",
          step_back = "b",
          run_last = "▶▶",
          terminate = "⏹",
          disconnect = "⏏",
        },
      },
      layouts = {
        {
          elements = {
            { id = "scopes", size = 0.33 },
            -- { id = "breakpoints", size = 0.33 },
            { id = "stacks", size = 0.33 },
            { id = "watches", size = 0.34 },
          },
          position = "left",
          size = 30, -- Use 30–40 cols for side panel (not 80)
        },
        {
          elements = {
            { id = "repl", size = 0.5 },
            { id = "console", size = 0.5 },
          },
          position = "bottom",
          size = 10, -- 8–15 lines is enough
        },
      },
    })

    dap.listeners.after.event_initialized["dapui_config"] = dapui.open
    dap.listeners.before.event_terminated["dapui_config"] = dapui.close
    dap.listeners.before.event_exited["dapui_config"] = dapui.close

    -- Install golang specific config
    require("dap-go").setup({
      delve = {
        -- On Windows delve must be run attached or it crashes.
        -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
        detached = vim.fn.has("win32") == 0,
      },
    })

    -- Setup for C/C++ debugging
    dap.adapters.codelldb = {
      type = "server",
      port = "${port}",
      executable = {
        command = "codelldb", -- Ensure 'codelldb' is installed and in your PATH
        args = { "--port", "${port}" },
      },
    }
    -- Setup for Rust debugging (reuses codelldb)
    dap.configurations.rust = {
      {
        name = "Debug executable (Rust)",
        type = "codelldb",
        request = "launch",
        program = function()
          return vim.fn.input(
            "Path to executable: ",
            vim.fn.getcwd() .. "/target/debug/",
            "file"
          )
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        args = function()
          local input = vim.fn.input("Program arguments: ")
          return vim.split(input, " ")
        end,
      },
    }

    dap.configurations.cpp = {
      {
        name = "Launch file",
        type = "codelldb",
        request = "launch",
        program = function()
          -- Directory where your compiled binaries are located
          local build_dir = "build"

          -- Get all file names inside the build directory
          local files = vim.fn.readdir(build_dir)

          -- Prepare a table to store only the executables (not .o files)
          local executables = {}

          for _, file in ipairs(files) do
            local full_path = build_dir .. "/" .. file

            -- Filter:
            -- 1. File must be executable (not just present)
            -- 2. File must NOT end in '.o' (object files)
            if vim.fn.executable(full_path) == 1 and not file:match("%.o$") then
              table.insert(executables, full_path)
            end
          end

          -- If at least one executable is found, use the first as the default suggestion
          -- Otherwise, just suggest the build directory as a fallback
          local default = executables[1] or build_dir .. "/"

          -- Prompt the user to pick the executable (can be edited or accepted as-is)
          return vim.fn.input("Path to executable: ", default, "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        args = function()
          local input = vim.fn.input("Program arguments: ")
          return vim.split(input, " ")
        end,
      },
    }

    -- For C programs, you can reuse the same configuration
    dap.configurations.c = dap.configurations.cpp
  end,
}
