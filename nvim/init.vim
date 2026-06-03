" === vim-plug ===
call plug#begin('~/.local/share/nvim/plugged')

" Treesitter
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }

call plug#end()

" === Basic Settings ===
set number
set relativenumber
set mouse=a
set clipboard=unnamedplus
set ignorecase
set smartcase
set tabstop=4
set shiftwidth=4
set expandtab
set termguicolors
syntax on
filetype plugin indent on

" === Colorscheme ===
try
  colorscheme onedark-custom
catch
  colorscheme desert
endtry

" === Plugin Config ===
