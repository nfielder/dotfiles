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
        map('n', ']gc', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, { desc = 'Jump to next [g]it [c]hange' })

        map('n', '[gc', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, { desc = 'Jump to previous [g]it [c]hange' })

        -- Actions
        -- visual mode
        map('v', '<leader>ghs', function()
          gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'stage git hunk' })
        map('v', '<leader>ghr', function()
          gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'reset git hunk' })
        -- normal mode
        map('n', '<leader>ghs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
        map('n', '<leader>ghr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
        map('n', '<leader>ghS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
        map('n', '<leader>ghR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
        map('n', '<leader>ghp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
        map('n', '<leader>ghi', gitsigns.preview_hunk_inline, { desc = 'git preview hunk [i]nline' })
        map('n', '<leader>ghb', gitsigns.blame_line, { desc = 'git [b]lame line' })
        map('n', '<leader>ghd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
        map('n', '<leader>ghD', function()
          gitsigns.diffthis '@'
        end, { desc = 'git [D]iff against last commit' })
        -- Toggles
        map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line' })
        map('n', '<leader>tw', gitsigns.toggle_word_diff, { desc = '[T]oggle git [w]ord diff' })
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
      preset = 'modern',
      -- delay between pressing a key and opening which-key (milliseconds)
      -- this setting is independent of vim.opt.timeoutlen
      delay = 120,
      icons = {
        -- set icon mappings to true if you have a Nerd Font
        mappings = vim.g.have_nerd_font,
        -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
        -- default which-key.nvim defined Nerd Font icons, otherwise define a string table
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },
      triggers = {
        { '<auto>', mode = 'nxso' },
        { 's', mode = 'n' }, -- Trigger for mini.surround
      },
      spec = {
        { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
        { '<leader>f', group = '[F]ile/[F]ind' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>sg', group = '[S]earch [G]it' },
        { '<leader>w', group = '[W]orkspace' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>q', group = '[Q]uit' },
        { '<leader>x', group = 'Quickfi[X]' },
        { '<leader>p', group = '[P]lugin' },
        { '<leader>g', group = '[G]it' },
        { '<leader>gh', group = '[H]unks', mode = { 'n', 'v' } },
        { '<leader>v', group = '[V]isual' },
        { '[', group = 'Prev' },
        { ']', group = 'Next' },
        { 'g', group = '[G]oto' },
        { 'z', group = '[F]old' },
        { 's', group = '[S]urround' },
        { '[g', group = '[G]it' },
        { ']g', group = '[G]it' },
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
