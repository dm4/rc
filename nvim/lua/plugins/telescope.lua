return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  },
  config = function()
    require("telescope").load_extension("fzf")
    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>ff', builtin.find_files)
    vim.keymap.set('n', '<leader>fg', builtin.live_grep)
    vim.keymap.set('n', '<leader>fk', builtin.keymaps)
  end
}
