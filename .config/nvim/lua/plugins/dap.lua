return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "williamboman/mason.nvim",
    "jay-babu/mason-nvim-dap.nvim",
    "leoluz/nvim-dap-go",
    --
    -- Virtual text.
    {
      'theHamsta/nvim-dap-virtual-text',
      opts = { virt_text_pos = 'eol' },
    },

  },
  keys = function(_, keys)
    local dap = require("dap")
    local dapui = require("dapui")
    return {
      -- TODO doesn't work?
      -- { "<A-5>", function() dapui.toggle() end, desc = "Toggle Debugger UI" },
      { "<F9>",  dap.continue,  desc = "Debug: Start/Continue" },
      { "<F7>",  dap.step_into, desc = "Debug: Step Into" },
      { "<F8>",  dap.step_over, desc = "Debug: Step Over" },
      { "<F12>", dap.step_out,  desc = "Debug: Step Out" },
      {
        '<leader>db',
        function()
          require('dap').toggle_breakpoint()
        end,
        desc = 'Toggle breakpoint',
      },
      {
        '<leader>dB',
        '<cmd>FzfLua dap_breakpoints<cr>',
        desc = 'List breakpoints',
      },
      {
        "<C-S-F8>",
        function()
          dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end,
        desc = "Debug: Set Conditional Breakpoint",
      },
      { "<A-5>", dapui.toggle, desc = "Debug: Toggle Debugger UI" },
      unpack(keys),
    }
  end,
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    -- use nvim-dap events to open and close the windows automatically
    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end

    vim.fn.sign_define('DapBreakpoint', { text = '⏺', texthl = 'DiagnosticSignError', linehl = '', numhl = '' })
    vim.fn.sign_define('DapStopped', { text = '➡', texthl = 'DiagnosticSignInfo', linehl = 'Visual', numhl = '' })
    vim.fn.sign_define('DapBreakpointRejected', { text = '✖', texthl = 'DiagnosticSignError', linehl = '', numhl = '' })
    vim.fn.sign_define('DapLogPoint', { text = '🛈', texthl = 'DiagnosticSignHint', linehl = '', numhl = '' })

    require("mason-nvim-dap").setup({
      automatic_installation = true,
      handlers = {},
      ensure_installed = {
        "delve",
        "codelldb",
      },
    })

    -- Setup virtual text plugin
    require("nvim-dap-virtual-text").setup({
      virt_text_pos = 'eol',
    })

    dapui.setup({
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
            { id = "scopes",  size = 0.33 },
            { id = "stacks",  size = 0.33 },
            { id = "watches", size = 0.34 },
          },
          position = "left",
          size = 30,
        },
      },
    })

    -- Go config
    require("dap-go").setup({
      delve = {
        detached = vim.fn.has("win32") == 0,
      },
    })

    -- C/C++ and Rust using codelldb
    dap.adapters.codelldb = {
      type = "server",
      port = "${port}",
      executable = {
        command = "codelldb",
        args = { "--port", "${port}" },
      },
    }

    dap.configurations.cpp = {
      {
        name = "Launch file",
        type = "codelldb",
        request = "launch",
        program = function()
          local build_dir = "build"
          local files = vim.fn.readdir(build_dir)
          local executables = {}
          for _, file in ipairs(files) do
            local full_path = build_dir .. "/" .. file
            if vim.fn.executable(full_path) == 1 and not file:match("%.o$") then
              table.insert(executables, full_path)
            end
          end
          local default = executables[1] or build_dir .. "/"
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

    dap.configurations.c = dap.configurations.cpp

    dap.configurations.rust = {
      {
        name = "Debug executable (Rust)",
        type = "codelldb",
        request = "launch",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        args = function()
          local input = vim.fn.input("Program arguments: ")
          return vim.split(input, " ")
        end,
      },
    }
  end,
}
