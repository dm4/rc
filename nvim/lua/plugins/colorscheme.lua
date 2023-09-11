return {
  "metalelf0/jellybeans-nvim",
  lazy = false,
  priority = 1000,
  dependencies = {
    "rktjmp/lush.nvim",
  },
  config = function()
    vim.cmd.colorscheme("jellybeans-nvim")
  end,
}
