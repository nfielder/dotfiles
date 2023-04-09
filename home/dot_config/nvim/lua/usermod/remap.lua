-- Shorten function name
local keymap = vim.keymap.set

-- Remap space key as leader
keymap("", "<Space>", "", { silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Unbind some useless/annoying default bindings
keymap("", "Q", "")

-- Try to prevent bad habits like using arrow keys for movement.
-- Do this in normal mode ...
keymap("n", "<Left>", ":echoe 'Use h'<CR>")
keymap("n", "<Right>", ":echoe 'Use l'<CR>")
keymap("n", "<Up>", ":echoe 'Use k'<CR>")
keymap("n", "<Down>", ":echoe 'Use j'<CR>")
-- ... and in insert mode
keymap("i", "<Left>", "<ESC>:echoe 'Use h'<CR>")
keymap("i", "<Right>", "<ESC>:echoe 'Use l'<CR>")
keymap("i", "<Up>", "<ESC>:echoe 'Use k'<CR>")
keymap("i", "<Down>", "<ESC>:echoe 'Use j'<CR>")

-- Normal --
-- Append below line but keep cursor in place
keymap("n", "J", "mzJ`z")

-- Keep cursor in middle of screen when paging up/down
keymap("n", "<C-d>", "<C-d>zz")
keymap("n", "<C-u>", "<C-u>zz")

-- Keep cursor in middle of screen when cycling through searches
keymap("n", "n", "nzzzv")
keymap("n", "N", "Nzzzv")

-- Yank into system clipboard
keymap({ "n", "v" }, "<leader>y", [["+y]])
keymap("n", "<leader>Y", [["+Y]])

-- Visual --
-- Shift selected lines up and down
keymap("v", "J", ":m '>+1<CR>gv=gv")
keymap("v", "K", ":m '<-2<CR>gv=gv")

-- Magic
-- Don't overwrite when pasting
keymap("x", "<leader>p", [["_dP]])

-- Delete into void register
keymap({ "n", "v" }, "<leader>d", "\"_d")
