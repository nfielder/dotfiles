---@type vim.lsp.Config
return {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua', 'lua.chezmoitmpl' },
  root_markers = { '.luarc.json', '.luarc.jsonc' },
  settings = {
    Lua = {
      completion = {
        callSnippet = 'Replace',
      },
      -- Using stylua for formatting
      format = { enable = false },
    },
  },
}
