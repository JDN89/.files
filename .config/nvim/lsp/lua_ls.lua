-- Download the .gz file that meets your architecture, don't build from source
-- Add to ~/.local/share/lua-lang-server. 
-- mkdir -p ~/.local/share/lua-lang-server && \
-- tar --extract --file <YOUR .gz FILE> -av -C ~/.local/share/lua-lang-server
-- Create a symbolic link in ~/.local/bin to the executable.
-- ln -s ~/.local/share/lua-lang-server/bin/lua-language-server ~/.local/bin/lua-language-server
-- Test if it works by executing lua-language-server.
-- (Optional) If step 4 fails since bash cannot find the executable lua-language-server, then you have to append ~/.local/bin to the environment variable PATH.

---@type vim.lsp.Config
return {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = { ".luarc.json", ".luarc.jsonc" },
  -- NOTE: These will be merged with the configuration file.
  settings = {
    Lua = {
      completion = { callSnippet = "Replace" },
      -- Using stylua for formatting.
      format = { enable = false },
      hint = {
        enable = true,
        arrayIndex = "Disable",
      },
      runtime = {
        version = "LuaJIT",
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          "${3rd}/luv/library",
        },
      },
    },
  },
}
