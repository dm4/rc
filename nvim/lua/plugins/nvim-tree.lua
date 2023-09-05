return {
  "nvim-tree/nvim-tree.lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("nvim-tree").setup({})
    vim.keymap.set("n", "<leader>n", "<cmd>NvimTreeToggle<CR>")
    vim.cmd.highlight("NvimTreeIndentMarker guifg=#3FC5FF");
  end,
}
