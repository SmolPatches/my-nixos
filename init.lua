vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.editorconfig = true;
vim.wo.relativenumber = true;
vim.cmd("colorscheme gruvbox");
require('gitsigns').setup {
signs = {
  add = { text = '+' },
  change = { text = '~' },
  delete = { text = '_' },
  topdelete = { text = '‾' },
  changedelete = { text = '~' },
  }
}
