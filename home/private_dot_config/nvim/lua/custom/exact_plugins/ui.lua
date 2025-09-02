return {
  {
    'nvim-mini/mini.statusline',
    opts = {},
    dependencies = {
      'nvim-mini/mini.icons',
    },
    config = function()
      -- Simple and easy statusline.
      local statusline = require 'mini.statusline'

      -- set use_icons to true if you have a Nerd Font
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },
  {
    -- Simple Icons provider
    'nvim-mini/mini.icons',
    opts = {
      -- Use glyphs if a Nerd font is installed
      style = (vim.g.have_nerd_font and { 'glyph' } or { 'ascii' })[1],
    },
  },
  {
    -- Show trailing whitespace
    'nvim-mini/mini.trailspace',
    opts = {},
  },
  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- See `:help ibl`
    main = 'ibl',
    opts = {},
  },
  {
    -- Pretty start screen
    -- TODO: Customise start screen
    'nvim-mini/mini.starter',
    opts = {},
  },
  {
    'stevearc/dressing.nvim',
    opts = {},
  },
}
