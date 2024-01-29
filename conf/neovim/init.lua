-- set up mapleader(must be done before lazy)
vim.g.mapleader = " "
--
-- lazy nvim install
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup("plugins")
-- lazy nvim install end
--
vim.opt.rtp:prepend(lazypath)
-- my options 
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.opt.termguicolors = true
vim.o.relativenumber = true
vim.o.nowrapscan = true
vim.o.background = "dark"
--vim.cmd("colorscheme oxocarbon") 
--vim.cmd("colorscheme kanagawa") 
vim.cmd("colorscheme citruszest") 
-- my options end
-- key binds
-- fzf keybinds
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
-- autocmds
vim.cmd([[
    autocmd filetype go nnoremap <leader>x :w <bar> exec '!go build '.shellescape('%').' && ./'.shellescape('%:r')<CR>
    autocmd filetype py nnoremap <leader>x :w <bar> exec '!python3 '.shellescape('%').'<CR>
    autocmd filetype rust nnoremap <leader>x :w <bar> exec '!cargo run'<CR>
]])
-- key binds end
-- additional notes
-- install fzf for neovim
-- notes end
