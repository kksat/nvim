local gemini_term = nil

return {
  'kiddos/gemini.nvim',
  dependencies = { 'akinsho/toggleterm.nvim' },
  config = function()
    require('gemini').setup()
  end,
  opts = {
    completion = {
      enable = false,
      insert_result_key = '<C-v>',
    },
    hints = {
      enable = false,
      insert_result_key = '<C-v>',
    },
  },
  keys = {
    { '<leader>agr', '<cmd>GeminiCodeReview<cr>',  desc = 'Gemini Code Review' },
    { '<leader>age', '<cmd>GeminiCodeExplain<cr>', desc = 'Gemini Code Explain' },
    { '<leader>agu', '<cmd>GeminiUnitTest<cr>',    desc = 'Gemini Unit Test' },
    {
      '<leader>agc',
      function()
        local Terminal = require("toggleterm.terminal").Terminal
        if not gemini_term then
          gemini_term = Terminal:new({
            cmd = "gemini",
            direction = "float",
            size = 1.0,
            float_opts = {
              border = "curved",
              title = "Gemini CLI",
            },
          })
        end
        gemini_term:toggle()
      end,
      desc = 'Toggle Gemini CLI'
    },
  },


}
