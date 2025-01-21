return {
  {
    'echasnovski/mini.files',
    dependencies = {
      'echasnovski/mini.icons',
    },
    opts = {
      mappings = {
        go_in_plus = '<CR>',
        go_out = 'H',
        go_out_plus = 'h',
      },
      content = {
        --- Custom filter to hide '.git' directory in file explorer
        ---@param fs_entry { fs_type: 'file'|'directory', name: string, path: string }
        ---@return boolean
        filter = function(fs_entry)
          if fs_entry.fs_type == 'directory' and fs_entry.name == '.git' then
            return false
          end
          return true
        end,
      },
      windows = {
        preview = true,
        width_focus = 35,
        width_preview = 50,
      },
    },
    keys = {
      -- TODO: Move common logic for mini.files into util module
      {
        '<leader>e',
        function()
          local mini_files = require 'mini.files'
          -- close explorer if it is opened
          if mini_files.close() then
            return
          end
          -- use cwd if filetype is ministarter
          local use_cwd = false
          if vim.bo.filetype:match 'ministarter' then
            use_cwd = true
          end
          local buf_path = vim.api.nvim_buf_get_name(0)
          local path = not use_cwd and buf_path or vim.uv.cwd()
          mini_files.open(path, true)
        end,
        desc = 'Open file [E]xplorer (Dir of current file)',
      },
      {
        '<leader>E',
        function()
          local mini_files = require 'mini.files'
          if not mini_files.close() then
            mini_files.open(vim.uv.cwd(), true)
          end
        end,
        desc = 'Open file [E]xplorer (cwd)',
      },
    },
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
        hijack_netrw_behavior = 'disabled',
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
  },
}
