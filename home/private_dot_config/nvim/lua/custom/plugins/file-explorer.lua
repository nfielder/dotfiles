return {
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
    init = function()
      vim.api.nvim_create_autocmd('BufEnter', {
        group = vim.api.nvim_create_augroup('RemoteFileInit', { clear = true }),
        callback = function()
          local f = vim.fn.expand '%:p'
          for _, v in ipairs { 'dav', 'fetch', 'ftp', 'http', 'rcp', 'rsync', 'scp', 'sftp' } do
            local p = v .. '://'
            if f:sub(1, #p) == p then
              vim.cmd [[
              unlet g:loaded_netrw
              unlet g:loaded_netrwPlugin
              runtime! plugin/netrwPlugin.vim
              silent Explore %
            ]]
              break
            end
          end
          vim.api.nvim_clear_autocmds { group = 'RemoteFileInit' }
        end,
      })
      vim.api.nvim_create_autocmd('BufEnter', {
        group = vim.api.nvim_create_augroup('NeoTreeInit', { clear = true }),
        callback = function()
          local f = vim.fn.expand '%:p'
          if vim.fn.isdirectory(f) ~= 0 then
            vim.cmd('Neotree current dir=' .. f)
            vim.api.nvim_clear_autocmds { group = 'NeoTreeInit' }
          end
        end,
      })
    end,
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
        hijack_netrw_behavior = 'open_current',
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
