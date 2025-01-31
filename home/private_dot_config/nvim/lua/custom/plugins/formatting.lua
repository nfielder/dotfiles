return {
  -- Autoformat
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true }
        end,
        mode = 'n',
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
    opts = {
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
        local disable_filetypes = { c = true, cpp = true }
        local lsp_format_opt = 'fallback'
        if disable_filetypes[vim.bo[bufnr].filetype] then
          lsp_format_opt = 'never'
        end

        -- Disable autoformat for lazy-lock.json
        local buf_name = vim.api.nvim_buf_get_name(bufnr)
        if buf_name:match 'lazy%-lock%.json$' then
          lsp_format_opt = 'never'
        end

        return {
          timeout_ms = 500,
          lsp_format = lsp_format_opt,
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        templ = { 'templ' },
      },
    },
  },
}
