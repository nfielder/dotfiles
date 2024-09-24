return {
  {
    'echasnovski/mini.statusline',
    opts = {},
    dependencies = {
      'echasnovski/mini.icons',
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
    'echasnovski/mini.icons',
    opts = {
      style = 'ascii',
    },
  },
  -- Add indentation guides even on blank lines
  {
    'lukas-reineke/indent-blankline.nvim',
    -- See `:help ibl`
    main = 'ibl',
    opts = {},
  },
  {
    'stevearc/oil.nvim',
    cmd = 'Oil',
    dependencies = {
      'echasnovski/mini.icons',
    },
    opts = {
      default_file_explorer = false,
      view_options = {
        show_hidden = true,
        is_always_hidden = function(name, _)
          return name == '.git'
        end,
      },
    },
  },
}
