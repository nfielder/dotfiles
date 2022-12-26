-- Set compatibility to Vim only.
vim.opt.compatible = false

-- Enable syntax highlighting
vim.opt.syntax = "enable"

-- Show matching braces when text indicator is over them
vim.opt.showmatch = true

-- Set background
vim.opt.background = "dark"

-- Detection, plugin and indent on
vim.cmd("filetype plugin indent on")

-- Better indenting
vim.opt.smartindent = true

-- Set tabs to expand to spaces. Death to tabs!
vim.opt.expandtab = true

-- Show any pesky tabs
vim.opt.showtabline = 0

-- Spaces for each step of (auto)indent
vim.opt.shiftwidth = 4

-- Set virtual tab stop (compat for 8-wide tabs)
vim.opt.softtabstop = 4

-- For proper display of files with tabs
vim.opt.tabstop = 4

-- Show line numbers and numbering mode to relative
vim.opt.number = true
vim.opt.relativenumber = true

-- Allow hiding of buffers. See `:help hidden` for more info
vim.opt.hidden = true

-- Show lines above and below cursor (when possible)
vim.opt.scrolloff = 8

-- Make backspace behave more reasonably. Can backspace over anything
vim.opt.backspace = { "indent", "eol", "start" }

-- No need for '--- INSERT ---' because of lightline.vim
vim.opt.showmode = false

-- Sane splits
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Enable searching as you type, rather than waiting until enter is pressed
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Set nice colours 🎨
vim.opt.termguicolors = true

-- Make search case-sensitive when all characters in a string being search on
-- are lowercase. However, the search becomes case-sensitive if it contains any
-- capital letters. This makes searching more convenient.
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Enable undo persistence
vim.opt.undofile = true
vim.opt.backup = false
vim.opt.swapfile = false

-- Always show sign column
vim.opt.signcolumn = "yes"

-- Fast update time
vim.opt.updatetime = 50

-- Turn off wrap
vim.opt.wrap = false

-- Width column to guide putting too much on one line
vim.opt.colorcolumn = "90"
