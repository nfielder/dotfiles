local helpers = require 'custom.helpers'
local methods = vim.lsp.protocol.Methods

-----------------------
-- [[ LSP ]]
-----------------------

-- NOTE: To debug LSP use below line
-- vim.lsp.set_log_level 'debug'

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

  if client:supports_method(methods.textDocument_typeDefinition) then
    -- Jump to the definition of the word under your cursor.
    --  To jump back, press <C-t>.
    map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
  end

  if client:supports_method(methods.textDocument_references) then
    -- Find references for the word under your cursor.
    map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  end

  -- Jump to the implementation of the word under your cursor.
  --  Useful when your language has ways of declaring types without an actual implementation.
  map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

  -- Jump to the type of the word under your cursor.
  --  Useful when you're not sure what type a variable is and you want to see
  --  the definition of its *type*, not where it was *defined*.
  map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')

  if client:supports_method(methods.textDocument_documentSymbol) then
    -- Fuzzy find all the symbols in your current document.
    --  Symbols are things like variables, functions, types, etc.
    map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')
  end

  -- Fuzzy find all the symbols in your current workspace.
  --  Similar to document symbols, except searches over your entire project.
  map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')

  -- Rename the variable under your cursor.
  --  Most Language Servers support renaming across files, etc.
  map('grn', vim.lsp.buf.rename, '[R]e[N]ame')

  -- Execute a code action, usually your cursor needs to be on top of an error
  -- or a suggestion from your LSP for this to activate.
  local code_action_binds = {
    { lhs = 'gra', desc = '[G]oto Code [A]ction' },
    { lhs = '<leader>ca', desc = '[C]ode [A]ction' },
  }
  for _, bind in ipairs(code_action_binds) do
    map(bind.lhs, vim.lsp.buf.code_action, bind.desc, { 'n', 'x' })
  end

  map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

  -- Show full diagnostic for the current line in floating window. Helpful for when the diagnostic bleeds off screen
  map('<leader>cd', vim.diagnostic.open_float, 'Show full line [D]iagnostic')

  -- The following two autocommands are used to highlight references of the
  -- word under your cursor when your cursor rests there for a little while.
  --    See `:help CursorHold` for information about when this is executed
  --
  -- When you move your cursor, the highlights will be cleared (the second autocommand).
  if client:supports_method(methods.textDocument_documentHighlight) then
    local under_cursor_highlight_group = vim.api.nvim_create_augroup('nfielder/lsp_highlight', { clear = false })
    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI', 'InsertLeave' }, {
      buffer = bufnr,
      group = under_cursor_highlight_group,
      callback = vim.lsp.buf.document_highlight,
      desc = 'Highlight references under the cursor',
    })

    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI', 'InsertEnter', 'BufLeave' }, {
      buffer = bufnr,
      group = under_cursor_highlight_group,
      callback = vim.lsp.buf.clear_references,
      desc = 'Clear highlight references',
    })

    vim.api.nvim_create_autocmd('LspDetach', {
      group = vim.api.nvim_create_augroup('nfielder/lsp_detach', { clear = true }),
      callback = function(args)
        vim.lsp.buf.clear_references()
        vim.api.nvim_clear_autocmds { group = under_cursor_highlight_group, buffer = args.buf }
      end,
      desc = 'Clear highlight references and autocmds on LSP detach',
    })
  end

  -- The following autocommand is used to enable inlay hints in your
  -- code, if the language server you are using supports them
  --
  -- This may be unwanted, since they displace some of your code
  if client:supports_method(methods.textDocument_inlayHint) then
    map('<leader>th', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = bufnr }) end, '[T]oggle Inlay [H]ints')
  end
end

-- Diagnostic Config
-- See :help vim.diagnostic.Opts
vim.diagnostic.config {
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = vim.diagnostic.severity.ERROR },
  signs = vim.g.have_nerd_font and {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰅚 ',
      [vim.diagnostic.severity.WARN] = '󰀪 ',
      [vim.diagnostic.severity.INFO] = '󰋽 ',
      [vim.diagnostic.severity.HINT] = '󰌶 ',
    },
  } or {},
  virtual_text = {
    source = 'if_many',
    spacing = 2,
    format = function(diagnostic)
      local diagnostic_message = {
        [vim.diagnostic.severity.ERROR] = diagnostic.message,
        [vim.diagnostic.severity.WARN] = diagnostic.message,
        [vim.diagnostic.severity.INFO] = diagnostic.message,
        [vim.diagnostic.severity.HINT] = diagnostic.message,
      }
      return diagnostic_message[diagnostic.severity]
    end,
  },
}

-- Update mappings when registering dynamic capabilities.
local register_capability = vim.lsp.handlers[methods.client_registerCapability]
vim.lsp.handlers[methods.client_registerCapability] = function(err, res, ctx)
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  if not client then
    return
  end

  on_attach(client, vim.api.nvim_get_current_buf())

  return register_capability(err, res, ctx)
end

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('nfielder/lsp_attach', { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if not client then
      return
    end

    on_attach(client, args.buf)
  end,
})

---Table containing a map of the LSP name to the executable that provides it.
---
---e.g., lua_ls = 'lua-language-server'
local lsp_server_to_executable = {
  ansiblels = 'ansible-language-server',
  denols = 'deno',
  gopls = 'gopls',
  html = 'vscode-html-language-server',
  jsonls = 'vscode-json-language-server',
  lua_ls = 'lua-language-server',
  pyright = 'pyright-langserver',
  templ = 'templ',
  terraformls = 'terraform-ls',
  yamlls = 'yaml-language-server',
}

-- Set up LSP servers
vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile' }, {
  once = true,
  callback = function()
    local server_configs = helpers.get_lsp_servers_from_rtp()
    -- vim.notify(vim.inspect(server_configs), vim.log.levels.INFO, nil)
    for server_name, lsp_executable in pairs(lsp_server_to_executable) do
      if vim.tbl_contains(server_configs, server_name) and helpers.is_executable(lsp_executable) then
        vim.lsp.enable(server_name)
      else
        local msg = string.format("Executable '%s' for server '%s' not found! Server will not be enabled", lsp_executable, server_name)
        vim.notify(msg, vim.log.levels.WARN, nil)
      end
    end
  end,
})

-- Start, Stop, Restart, Log commands {{{
vim.api.nvim_create_user_command('LspStart', function() vim.cmd.e() end, { desc = 'Starts LSP clients in the current buffer' })

vim.api.nvim_create_user_command('LspStop', function(opts)
  for _, client in ipairs(vim.lsp.get_clients { bufnr = 0 }) do
    if opts.args == '' or opts.args == client.name then
      client:stop(true)
      vim.notify(client.name .. ': stopped')
    end
  end
end, {
  desc = 'Stop all LSP clients or a specific client attached to the current buffer.',
  nargs = '?',
  complete = function(_, _, _)
    local clients = vim.lsp.get_clients { bufnr = 0 }
    local client_names = {}
    for _, client in ipairs(clients) do
      table.insert(client_names, client.name)
    end
    return client_names
  end,
})

vim.api.nvim_create_user_command('LspRestart', function()
  local detach_clients = {}
  for _, client in ipairs(vim.lsp.get_clients { bufnr = 0 }) do
    client:stop(true)
    if vim.tbl_count(client.attached_buffers) > 0 then
      detach_clients[client.name] = { client, vim.lsp.get_buffers_by_client_id(client.id) }
    end
  end
  local timer = vim.uv.new_timer()
  if not timer then
    return vim.notify 'Servers are stopped but havent been restarted'
  end
  timer:start(
    100,
    50,
    vim.schedule_wrap(function()
      for name, client in pairs(detach_clients) do
        local client_id = vim.lsp.start(client[1].config, { attach = false })
        if client_id then
          for _, buf in ipairs(client[2]) do
            vim.lsp.buf_attach_client(buf, client_id)
          end
          vim.notify(name .. ': restarted')
        end
        detach_clients[name] = nil
      end
      if next(detach_clients) == nil and not timer:is_closing() then
        timer:close()
      end
    end)
  )
end, {
  desc = 'Restart all the language client(s) attached to the current buffer',
})

vim.api.nvim_create_user_command('LspLog', function() vim.cmd.vsplit(vim.lsp.log.get_filename()) end, {
  desc = 'Get all the lsp logs',
})

vim.api.nvim_create_user_command('LspInfo', function() vim.cmd 'silent checkhealth vim.lsp' end, {
  desc = 'Get all the information about all LSP attached',
})
