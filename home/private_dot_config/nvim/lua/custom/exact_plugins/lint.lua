---@module 'lazy'
---@type LazySpec
return {
  -- Linting
  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'

      local available_linters = {}

      --- Add the linter for a filetype if it is available on the system.
      ---@param filetype string
      ---@param linters string|string[]
      local function add_linters(filetype, linters)
        if type(linters) == 'string' then
          linters = { linters }
        end

        local valid_linters = {}
        for _, linter_name in pairs(linters) do
          -- TODO: Add a warning if a desired linter isn't installed
          if require('custom.helpers').is_executable(linter_name) then
            table.insert(valid_linters, linter_name)
          end
        end

        -- NOTE: Return early if no linters available_linters
        local next = next
        if next(valid_linters) == nil then
          return
        end

        available_linters = vim.tbl_extend('force', available_linters, { [filetype] = valid_linters })
      end

      -- Add linters for filetypes
      add_linters('markdown', 'markdownlint-cli2')
      add_linters('yaml', 'yamllint')

      -- Set linters
      lint.linters_by_ft = available_linters

      -- Create autocommand which carries out the actual linting
      -- on the specified events.
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = require('custom.helpers').run_linter,
      })
    end,
  },
}
