return {
  -- Autoformat
  {
    'stevearc/conform.nvim',
    dependencies = {
      'mfussenegger/nvim-lint',
    },
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format({ async = true }, function()
            -- Run linting if available
            local ok, _ = pcall(require, 'lint')
            if ok then
              require('custom.helpers').run_linter()
            end
          end)
        end,
        mode = { 'n', 'v' },
        desc = '[F]ormat buffer',
      },
      {
        '<leader>tf',
        function()
          if vim.g.disable_autoformat or vim.b[vim.api.nvim_get_current_buf()].disable_autoformat then
            vim.cmd [[FormatEnable]]
          else
            vim.cmd [[FormatDisable]]
          end
        end,
        mode = 'n',
        desc = '[T]oggle [F]ormat on save',
      },
    },
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
      formatters_by_ft = {
        lua = { 'stylua' },
        sh = { 'shfmt' },
        templ = { 'templ' },
        yaml = { 'yamlfmt' },
      },
      notify_on_error = false,
      default_format_opts = {
        lsp_format = 'fallback',
      },
      format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end

        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local ignore_filetypes = { 'c', 'cpp', 'yaml' }
        if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
          return
        end

        -- Disable autoformat for lazy-lock.json
        local buf_name = vim.api.nvim_buf_get_name(bufnr)
        if buf_name:match 'lazy%-lock%.json$' then
          return
        end

        return {
          timeout_ms = 500,
          lsp_format = 'fallback',
        }
      end,
    },
  },
}
