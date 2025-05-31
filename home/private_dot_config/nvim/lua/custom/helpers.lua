local M = {}

---Run any available linters if the buffer is modifiable.
function M.run_linter()
  -- Only run the linter in buffers that you can modify in order to
  -- avoid superfluous noise, notably within the handy LSP pop-ups that
  -- describe the hovered symbol using Markdown.
  if vim.bo.modifiable then
    require('lint').try_lint()
  end
end

---Return true if provided item is executable on the system
---@param binary any
---@return boolean
function M.is_executable(binary)
  return vim.fn.executable(binary) == 1
end

---Return true if provided item is *not* executable on the system
---@param binary any
---@return boolean
function M.is_not_executable(binary)
  return vim.fn.executable(binary) == 0
end

---Return true if the plugin exists within the LazySpec
---@param name string
---@return boolean
function M.has_plugin(name)
  return require('lazy.core.config').spec.plugins[name] ~= nil
end

---Return a table of LSP servers that are in `<config>/lsp/` directory
function M.get_lsp_servers_from_rtp()
  return vim
    .iter(vim.api.nvim_get_runtime_file('lsp/*.lua', true))
    :map(function(file)
      return vim.fn.fnamemodify(file, ':t:r')
    end)
    :totable()
end

return M
