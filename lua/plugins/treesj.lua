return {
  'Wansmer/treesj',
  keys = {
    { '<leader>js', '<cmd>TSJToggle<cr>', desc = 'Treesj Toggle' },
  },
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  config = function()
    require('treesj').setup({})
  end,
}
