return {
  {
    'echasnovski/mini.files',
    dependencies = {
      'echasnovski/mini.icons',
    },
    opts = {},
  },
  {
    'nvim-neo-tree/neo-tree.nvim',
    version = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-tree/nvim-web-devicons', cond = vim.g.have_nerd_font }, -- not strictly required, but recommended
      'MunifTanjim/nui.nvim',
    },
    cmd = 'Neotree',
    keys = {
      { '\\', '<cmd>Neotree reveal<CR>', desc = 'Neotree reveal', silent = true },
    },
    opts = {
      event_handlers = {
        {
          event = 'file_open_requested',
          handler = function()
            -- autoclose
            require('neo-tree.command').execute { action = 'close' }
          end,
        },
      },
      filesystem = {
        filtered_items = {
          visible = false,
          hide_dotfiles = false,
          hide_gitignored = true,
          never_show = {
            '.git',
          },
        },
        window = {
          mappings = {
            ['\\'] = 'close_window',
          },
        },
      },
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
  },
}
