return {
  'topaxi/pipeline.nvim',
  keys = {
    { '<leader>ci', '<cmd>Pipeline<cr>', desc = 'Open pipeline.nvim' },
  },
  build = 'make',
  ---@type pipeline.Config
  opts = {},
}
