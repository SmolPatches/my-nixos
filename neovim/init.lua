-- Set tab width to 4 spaces
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4

-- Use tabs for indentation
vim.o.expandtab = false

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
-- use editorconfig
vim.g.editorconfig = true;
-- relative line number 
vim.wo.relativenumber = true;
vim.cmd("colorscheme gruvbox");
--autosave zig fmt
vim.g.zig_fmt_autosave = 1
require('gitsigns').setup {
signs = {
add = { text = '+' },
change = { text = '~' },
delete = { text = '_' },
topdelete = { text = '‾' },
changedelete = { text = '~' },
}
}
