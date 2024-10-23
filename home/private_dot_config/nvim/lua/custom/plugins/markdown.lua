return {
  {
    -- TODO: Consider using the non-npm install method
    'iamcco/markdown-preview.nvim',
    enabled = function()
      if vim.fn.executable 'npm' == 1 then
        return true
      end
      return false
    end,
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = 'cd app && npm install && git restore .',
    init = function()
      vim.g.mkdp_filetypes = { 'markdown' }
    end,
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = { 'markdown' },
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'echasnovski/mini.icons',
    },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      enabled = false,
    },
    keys = {
      { '<leader>tm', '<cmd>RenderMarkdown toggle<cr>', ft = 'markdown', desc = '[T]oggle [M]arkdown render' },
    },
    -- TODO: Consider using function below for keymap instead. Possibly combine with config() to keep lazy loading?
    -- keys = function(_, _)
    --   local markdown = require 'render-markdown'
    --   return { { '<leader>tm', markdown.toggle, ft = 'markdown', desc = '[T]oggle [M]arkdown render' } }
    -- end,
  },
}
