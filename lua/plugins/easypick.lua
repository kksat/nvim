return {
  'axkirillov/easypick.nvim',
  enabled = false,
  requires = 'nvim-telescope/telescope.nvim',
  config = function()
    local easypick = require("easypick")
    local list_make_targets = [[
    make -qp |
    awk -F':' '/^[a-zA-Z0-9][^$#\/\t=]*:([^=]|$)/ {split($1,A,/ /);for(i in A)print A[i]}' |
    grep -wv Makefile
    ]]

    easypick.setup({
      pickers = {
        {
          name = "make_targets",
          command = list_make_targets,
          action = easypick.actions.nvim_commandf("TermExec cmd='make %s'"),
          opts = require('telescope.themes').get_dropdown({})
        }
      }
    })
  end
}
