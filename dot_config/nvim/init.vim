" Neovim config

" Plugins (managed using vim-plug)
call plug#begin(stdpath('data') . '/plugged')

Plug 'itchyny/lightline.vim'
Plug 'preservim/nerdtree'
Plug 'preservim/nerdcommenter'

call plug#end()

colorscheme torte

" Detection, plugin and indent on
filetype plugin indent on

" Set tabs to expand to spaces. Death to tabs!
set expandtab

" Spaces for each step of (auto)indent
set shiftwidth=4

" Set virtual tab stop (compat for 8-wide tabs)
set softtabstop=4

" For proper display of files with tabs
set tabstop=4

" Setting spaces to 2 for yaml,yml,toml files
autocmd FileType yaml,yml,toml setlocal ts=2 sts=2 sw=2 expandtab

" Show line numbers and numbering mode to relative
set number
set relativenumber

" Allow hiding of buffers. See `:help hidden` for more info
set hidden

" Show lines above and below cursor (when possible)
set scrolloff=5

" No need for '--- INSERT ---' because of lightline.vim
set noshowmode

" Unbind some useless/annoying default bindings
nmap Q <Nop>

" Try to prevent bad habits like using arrow keys for movement.
" Do this in normal mode ...
nnoremap <Left>  :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <UP>    :echoe "Use k"<CR>
nnoremap <Down>  :echoe "Use j"<CR>
" ... and in insert mode
inoremap <Left>  <ESC>:echoe "Use h"<CR>
inoremap <Right> <ESC>:echoe "Use l"<CR>
inoremap <Up>    <ESC>:echoe "Use k"<CR>
inoremap <Down>  <ESC>:echoe "Use j"<CR>

" ----------------
"  Plugin config
" ----------------

" nerdtree
nnoremap <Leader>n :NERDTreeToggle<CR>
