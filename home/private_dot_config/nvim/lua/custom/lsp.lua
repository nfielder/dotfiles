-----------------------
-- [[ LSP ]]
-----------------------

-- NOTE: To debug LSP use below line
-- vim.lsp.set_log_level 'debug'

local methods = vim.lsp.protocol.Methods

local M = {}

local clear_highlight_on_lsp_detach = function(hl_group, args)
  vim.lsp.buf.clear_references()
  vim.api.nvim_clear_autocmds { group = hl_group, buffer = args.buf }
end

-- Sets up LSP keymaps and autocommands for the given buffer
---@param client vim.lsp.Client
---@param bufnr integer
local on_attach = function(client, bufnr)
  ---@param lhs string
  ---@param rhs string | function
  ---@param desc string
  ---@param mode? string | string[]
  local map = function(lhs, rhs, desc, mode)
    mode = mode or 'n'
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = 'LSP: ' .. desc })
  end

  -- Jump to the definition of the word under your cursor.
  --  To jump back, press <C-t>.
  map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

  -- Find references for the word under your cursor.
  map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

  -- Jump to the implementation of the word under your cursor.
  --  Useful when your language has ways of declaring types without an actual implementation.
  map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

  -- Jump to the type of the word under your cursor.
  --  Useful when you're not sure what type a variable is and you want to see
  --  the definition of its *type*, not where it was *defined*.
  map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

  -- Fuzzy find all the symbols in your current document.
  --  Symbols are things like variables, functions, types, etc.
  map('<leader>fs', require('telescope.builtin').lsp_document_symbols, 'Document [s]ymbols')

  -- Fuzzy find all the symbols in your current workspace.
  --  Similar to document symbols, except searches over your entire project.
  map('<leader>fS', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Workspace [S]ymbols')

  -- Rename the variable under your cursor.
  --  Most Language Servers support renaming across files, etc.
  map('<leader>cr', vim.lsp.buf.rename, '[R]ename')

  -- Execute a code action, usually your cursor needs to be on top of an error
  -- or a suggestion from your LSP for this to activate.
  map('<leader>ca', vim.lsp.buf.code_action, '[A]ction', { 'n', 'x' })

  map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

  -- Show full diagnostic for the current line in floating window. Helpful for when the diagnostic bleeds off screen
  map('<leader>cd', vim.diagnostic.open_float, 'Show full line [D]iagnostic')

  -- The following two autocommands are used to highlight references of the
  -- word under your cursor when your cursor rests there for a little while.
  --    See `:help CursorHold` for information about when this is executed
  --
  -- When you move your cursor, the highlights will be cleared (the second autocommand).
  if client:supports_method(methods.textDocument_documentHighlight) then
    local under_cursor_highlight_group = vim.api.nvim_create_augroup('nfielder/aug_lsp_highlight', { clear = false })
    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI', 'InsertLeave' }, {
      buffer = bufnr,
      group = under_cursor_highlight_group,
      callback = vim.lsp.buf.document_highlight,
    })

    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI', 'InsertEnter', 'BufLeave' }, {
      buffer = bufnr,
      group = under_cursor_highlight_group,
      callback = vim.lsp.buf.clear_references,
    })

    vim.api.nvim_create_autocmd('LspDetach', {
      group = vim.api.nvim_create_augroup('nfielder/aug_lsp_detach', { clear = true }),
      callback = clear_highlight_on_lsp_detach,
    })
  end

  -- The following autocommand is used to enable inlay hints in your
  -- code, if the language server you are using supports them
  --
  -- This may be unwanted, since they displace some of your code
  if client:supports_method(methods.textDocument_inlayHint) then
    map('<leader>th', function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = bufnr })
    end, '[T]oggle Inlay [H]ints')
  end
end

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('nfielder/aug_lsp_attach', { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if not client then
      return
    end

    on_attach(client, args.buf)
  end,
})
