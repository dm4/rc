-- dm4's config
vim.g.mapleader = ","
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.number = true
vim.keymap.set("n", ";", ":")

-- init lazy.nvim
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

-- setup lazy.nvim
require("lazy").setup("plugins")
vim.keymap.set("n", "<leader>l", "<cmd>Lazy<CR>")
