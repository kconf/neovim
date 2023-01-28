vim.g.mapleader = ' '

-- UI
vim.o.cmdheight  = 2
vim.o.updatetime = 300
vim.o.signcolumn = 'number'

-- Colors
vim.o.termguicolors = true
vim.o.background = 'dark'
vim.cmd 'colorscheme gruvbox-material'

vim.o.cursorline = true

vim.o.number = true
vim.o.relativenumber = true

vim.o.incsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.clipboard = 'unnamed'

-- Indent
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.smarttab = true
vim.o.softtabstop = 4
vim.o.expandtab = true

require("plugins")
