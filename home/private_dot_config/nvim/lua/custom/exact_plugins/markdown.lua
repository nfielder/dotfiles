return {
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = function()
      ---@type vim.Option
      local rtp = vim.opt.rtp
      rtp:prepend(vim.fn.stdpath 'data' .. '/lazy/markdown-preview.nvim')
      vim.fn['mkdp#util#install']()
    end,
    keys = {
      { '<leader>mp', '<cmd>MarkdownPreview<CR>', ft = 'markdown', desc = '[M]arkdown [P]review' },
      { '<leader>ms', '<cmd>MarkdownPreviewStop<CR>', ft = 'markdown', desc = '[M]arkdown [S]top Preview' },
    },
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = { 'markdown' },
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-mini/mini.icons',
    },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      enabled = false,
    },
    keys = {
      { '<leader>tm', '<cmd>RenderMarkdown toggle<CR>', ft = 'markdown', desc = '[T]oggle [M]arkdown render' },
    },
    -- TODO: Consider using function below for keymap instead. Possibly combine with config() to keep lazy loading?
    -- keys = function(_, _)
    --   local markdown = require 'render-markdown'
    --   return { { '<leader>tm', markdown.toggle, ft = 'markdown', desc = '[T]oggle [M]arkdown render' } }
    -- end,
  },
}
