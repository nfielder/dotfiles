local M = {}

---Run any available linters if the buffer is modifiable.
function M.run_linter()
  -- Only run the linter in buffers that you can modify in order to
  -- avoid superfluous noise, notably within the handy LSP pop-ups that
  -- describe the hovered symbol using Markdown.
  if vim.opt_local.modifiable:get() then
    require('lint').try_lint()
  end
end

return M
