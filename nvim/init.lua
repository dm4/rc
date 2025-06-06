-- dm4's config
vim.g.mapleader = ","
vim.g.is_bash = 1
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.number = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.undofile = true
vim.opt.wrap = false
vim.opt.mouse = ""
vim.keymap.set("n", ";", ":")
vim.keymap.set("n", "<Leader>l", "<Cmd>set nu!<CR>", { desc = "Toggle line number" })
vim.keymap.set("n", "<Leader>w", "<Cmd>set wrap!<CR>", { desc = "Toggle line wrapping" })
vim.keymap.set("n", "<C-N>", "gt", { desc = "Next tab" })
vim.keymap.set("n", "<C-P>", "gT", { desc = "Previous tab" })
vim.keymap.set("n", "<C-J>", "<Cmd>:m +1<CR>", { desc = "Move line down" })
vim.keymap.set("n", "<C-K>", "<Cmd>:m -2<CR>", { desc = "Move line up" })

vim.api.nvim_create_autocmd({'BufWinEnter'}, {
  desc = 'save last cursor position',
  pattern = '*',
  command = 'silent! normal! g`"zv',
})


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
vim.keymap.set("n", "<Leader>L", "<Cmd>Lazy<CR>", { desc = "Open Lazy dashboard" })
