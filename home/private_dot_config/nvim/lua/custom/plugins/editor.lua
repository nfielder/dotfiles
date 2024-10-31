return {
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  -- See `:help gitsigns` to understand what the configuration keys do
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, { desc = 'Jump to next git [c]hange' })

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, { desc = 'Jump to previous git [c]hange' })

        -- Actions
        -- visual mode
        map('v', '<leader>hs', function()
          gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'stage git hunk' })
        map('v', '<leader>hr', function()
          gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'reset git hunk' })
        -- normal mode
        map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
        map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
        map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
        map('n', '<leader>hu', gitsigns.undo_stage_hunk, { desc = 'git [u]ndo stage hunk' })
        map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
        map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
        map('n', '<leader>hb', gitsigns.blame_line, { desc = 'git [b]lame line' })
        map('n', '<leader>hd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
        map('n', '<leader>hD', function()
          gitsigns.diffthis '@'
        end, { desc = 'git [D]iff against last commit' })
        -- Toggles
        map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line' })
        map('n', '<leader>tD', gitsigns.toggle_deleted, { desc = '[T]oggle git show [D]eleted' })
      end,
    },
  },
  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    dependencies = {
      'echasnovski/mini.icons',
    },
    event = 'VeryLazy',
    ---@class wk.Opts
    opts = {
      icons = {
        rules = false,
      },
      triggers = {
        { '<auto>', mode = 'nxso' },
        { 's', mode = 'n' }, -- Trigger for mini.surround
      },
    },
    keys = {
      {
        '<leader>?',
        function()
          require('which-key').show { global = false }
        end,
        desc = 'Buffer Local Keymaps (which-key)',
      },
    },
    config = function(_, opts) -- This is the function that runs, AFTER loading
      local wk = require 'which-key'
      wk.setup(opts)

      -- Document existing key chains
      wk.add {
        { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
        { '<leader>d', group = '[D]ocument' },
        { '<leader>r', group = '[R]ename' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>sg', group = '[S]earch [G]it' },
        { '<leader>w', group = '[W]orkspace' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>x', group = 'E[X]it' },
        { '<leader>p', group = '[P]lugin' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
        { 's', group = '+Surround' },
      }

      -- Only create markdown group after opening a markdown file
      vim.api.nvim_create_autocmd('FileType', {
        desc = 'Register which-key group when entering markdown file',
        group = vim.api.nvim_create_augroup('aug-register-markdown-map-group', { clear = true }),
        pattern = { 'markdown' },
        callback = function(event)
          wk.add {
            { '<leader>m', group = '[M]arkdown', buffer = event.buf },
          }
        end,
      })
    end,
  },
  {
    'mbbill/undotree',
    cmd = {
      'UndotreeToggle',
      'UndotreeHide',
      'UndotreeShow',
      'UndotreeFocus',
      'UndotreePersistUndo',
    },
    keys = {
      { '<leader>u', '<cmd>UndotreeToggle<CR><cmd>UndotreeFocus<CR>', desc = 'Toggle [U]ndotree' },
    },
  },
}
