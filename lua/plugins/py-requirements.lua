return {
  'MeanderingProgrammer/py-requirements.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  config = function()
    require('py-requirements').setup({
      file_patterns = {
        'requirements.txt',
        'requirements-*.txt',
      }
    })
    local requirements = require('py-requirements')
    vim.keymap.set('n', '<leader>ru', requirements.upgrade, { silent = true, desc = 'Requirements: Upgrade' })
    vim.keymap.set('n', '<leader>rU', requirements.upgrade_all, { silent = true, desc = 'Requirements: Upgrade All' })
    vim.keymap.set('n', '<leader>rK', requirements.show_description,
      { silent = true, desc = 'Requirements: Show package description' })
  end,
}
