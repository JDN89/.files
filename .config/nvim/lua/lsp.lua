--
-- vim.lsp.enable({ "clangd" })
vim.lsp.enable({ "lua_ls", "rust_analyzer", "gopls", "clangd", "prettier" })

-- Disable inlay hints initially (and enable if needed with my ToggleInlayHints command).
vim.g.inlay_hints = false

--test
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
  callback = function(event)
    -- NOTE: Remember that Lua is a real programming language, and as such it is possible
    -- to define small helper and utility functions so you don't have to repeat yourself.
    --
    -- In this case, we create a function that lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    local map = function(keys, func, desc)
      vim.keymap.set(
        "n",
        keys,
        func,
        { buffer = event.buf, desc = "LSP: " .. desc }
      )
    end

    map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

    map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

    map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

    local client = vim.lsp.get_client_by_id(event.data.client_id)

    if not client then
      return
    end

    if
        client
        and client:supports_method(
          vim.lsp.protocol.Methods.textDocument_inlayHint
        )
    then
      map("<leader>th", function()
        vim.lsp.inlay_hint.enable(
          not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf })
        )
      end, "[T]oggle Inlay [H]ints")
    end

    if client:supports_method("textDocument/formatting") then
      -- Format current buffer on save
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = event.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = event.buf, id = client.id })
        end,
      })
    end

    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(ev)
        if client:supports_method("textDocument/completion") then
          vim.lsp.completion.enable(
            true,
            client.id,
            ev.buf,
            { autotrigger = true }
          )
        end
      end,
    })

    if
        client
        and client:supports_method(
          vim.lsp.protocol.Methods.textDocument_documentHighlight
        )
    then
      local highlight_augroup =
          vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd("LspDetach", {
        group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds({
            group = "lsp-highlight",
            buffer = event2.buf,
          })
        end,
      })
    end
  end,
})
