" === vim-plug ===
call plug#begin('~/.local/share/nvim/plugged')

" Visual
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
Plug 'nvim-lualine/lualine.nvim'
Plug 'akinsho/bufferline.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-tree/nvim-tree.lua'
Plug 'lukas-reineke/indent-blankline.nvim'

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

" Hide statusline (lualine handles it)
set noshowmode
set laststatus=3

" === Colorscheme ===
try
  colorscheme onedark-custom
catch
  colorscheme desert
endtry

" === Plugin Config ===

" Lualine
lua << EOF
require('lualine').setup {
  options = {
    theme = 'onedark',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    globalstatus = true,
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
}
EOF

" Bufferline
lua << EOF
require('bufferline').setup {
  options = {
    mode = "buffers",
    diagnostics = "nvim_lsp",
    show_close_icon = false,
    show_buffer_close_icons = true,
    separator_style = "thin",
    offsets = {
      {
        filetype = "NvimTree",
        text = "File Explorer",
        highlight = "Directory",
        separator = true,
      }
    },
  },
}
EOF

" NvimTree
lua << EOF
require('nvim-tree').setup {
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
    icons = {
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
      },
    },
  },
  filters = {
    dotfiles = false,
  },
}
EOF

" Indent Blankline
lua << EOF
require('ibl').setup {
  indent = {
    char = '│',
  },
  scope = {
    enabled = true,
    show_start = true,
    show_end = false,
  },
}
EOF

" === Keymaps ===
" NvimTree toggle
nnoremap <C-n> :NvimTreeToggle<CR>
nnoremap <leader>e :NvimTreeFocus<CR>

" Buffer navigation
nnoremap <S-l> :bnext<CR>
nnoremap <S-h> :bprevious<CR>
nnoremap <leader>bd :bdelete<CR>

" Window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
