return {
  'swaits/lazyjj.nvim',
  dependencies = 'nvim-lua/plenary.nvim',
  opts = {},
  setup = function()
    require('lazyjj').setup({
      mapping = '<leader>jj'
    })
  end,
}
