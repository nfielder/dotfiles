-- Set <space> as the leader key
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Enable nerdfont if installed
require 'custom.nerdfont'

-----------------------
-- [[ OPTIONS ]]
-----------------------
-- See `:help vim.opt`

-- Make line numbers default
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- Folds using treesitter
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

-- Do not take up room with extra column with fold info
vim.opt.foldcolumn = '0'

-- Keep syntax highlighting for first line of a fold
-- TODO: Improve logic to add custom fold text that adds number of lines within a fold
vim.opt.foldtext = ''

-- Do not have any folds closed by default
vim.opt.foldenable = false
vim.opt.foldlevel = 99

-- Remove trailing chars in folds
vim.opt.fillchars = {
  foldopen = '',
  foldclose = '',
  fold = ' ',
  foldsep = ' ',
  diff = '╱',
  eob = ' ',
}

-----------------------
-- [[ KEYMAPS ]]
-----------------------
--  See `:help vim.keymap.set()`

-- Disable some default keymaps that conflict with plugins
--   - Comment.nvim
vim.keymap.set('n', 'gc', '<Nop>')
vim.keymap.set('n', 'gb', '<Nop>')
--   - mini.surround
vim.keymap.set({ 'n', 'x' }, 's', '<Nop>')

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- diagnostic list
vim.keymap.set('n', '<leader>xd', vim.diagnostic.setloclist, { desc = 'Open [D]iagnostic list' })

-- location list
vim.keymap.set('n', '<leader>xl', function()
  local success, err = pcall(vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and vim.cmd.lclose or vim.cmd.lopen)
  if not success and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = 'Open [L]ocation list' })

-- quickfix list
vim.keymap.set('n', '<leader>xq', function()
  local success, err = pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen)
  if not success and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = 'Open [Q]uickfix list' })

vim.keymap.set('n', '[q', vim.cmd.cprev, { desc = 'Previous Quickfix' })
vim.keymap.set('n', ']q', vim.cmd.cnext, { desc = 'Next Quickfix' })

-- Quickly save a file
vim.keymap.set('n', '<leader>,', '<cmd>update<CR>', { desc = 'Update file if there are changes' })

-- Exit all buffers
vim.keymap.set('n', '<leader>qq', '<cmd>quitall<CR>', { desc = '[Q]uit all buffers' })
vim.keymap.set('n', '<leader>qf', '<cmd>quitall!<CR>', { desc = '[Q]uit all buffers [F]orcefully' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- better up / down. Scroll by screen instead of by line
vim.keymap.set({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { desc = 'Down', expr = true, silent = true })
vim.keymap.set({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { desc = 'Up', expr = true, silent = true })

-- buffers
vim.keymap.set('n', '<S-h>', '<cmd>bprevious<CR>', { desc = 'Prev Buffer' })
vim.keymap.set('n', '<S-l>', '<cmd>bnext<CR>', { desc = 'Next Buffer' })
vim.keymap.set('n', '[b', '<cmd>bprevious<CR>', { desc = 'Prev Buffer' })
vim.keymap.set('n', ']b', '<cmd>bnext<CR>', { desc = 'Next Buffer' })
vim.keymap.set('n', '<leader>bb', '<cmd>e #<CR>', { desc = 'Switch to Other Buffer' })
vim.keymap.set('n', '<leader>`', '<cmd>e #<CR>', { desc = 'Switch to Other Buffer' })

-- Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')
-- ... and in insert mode
vim.keymap.set('i', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('i', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('i', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('i', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Visual line select matching pair
vim.keymap.set('n', '<leader>vm', '<S-v>$%', { desc = '[V]isual line select [M]atching' })

-- Better indentation
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

-- Centre line after paging up/down
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')

-- Toggle diagnostics. Helpful for when a linter is very noisy.
vim.keymap.set('n', '<leader>td', function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = '[T]oggle [D]iagnostics', silent = true })

-- Keymap to open Lazy UI
vim.keymap.set('n', '<leader>pl', '<cmd>Lazy home<CR>', { desc = '[L]azy home' })

-----------------------
-- [[ AUTOCOMMANDS ]]
-----------------------
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('aug-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Setting spaces to 2 for yaml,yml,toml files
vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = { 'yaml', 'yml', 'toml', 'lua' },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
  end,
})

-- Use tabs in go files
vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = { 'go', 'templ' },
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.tabstop = 4
  end,
})

-----------------------
-- [[ USERCOMMANDS ]]
-----------------------

-- User commands to toggle format on save
vim.api.nvim_create_user_command('FormatDisable', function(opts)
  local current_buf = vim.api.nvim_get_current_buf()
  if opts.bang then
    -- FormatDisable! will disable formatting just for this buffer
    vim.b[current_buf].disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, {
  desc = 'Disable autoformat-on-save',
  bang = true,
})
vim.api.nvim_create_user_command('FormatEnable', function()
  local current_buf = vim.api.nvim_get_current_buf()
  vim.b[current_buf].disable_autoformat = false
  vim.g.disable_autoformat = false
end, {
  desc = 'Re-enable autoformat-on-save',
})

-----------------------
-- [[ FILETYPE ]]
-----------------------

-- Associate templ files. Fixed in Neovim > v0.10.0-dev-3070+gcf9f002f3
vim.filetype.add {
  extension = {
    templ = 'templ',
  },
}

-----------------------
-- [[ LSP ]]
-----------------------

-- NOTE: To debug LSP use below line
-- vim.lsp.set_log_level 'debug'

-----------------------
-- [[ PLUGIN MANAGER ]]
-----------------------

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
local plugins = 'custom.plugins'
require('lazy').setup {
  spec = { import = plugins },
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
