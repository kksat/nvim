return {
  "folke/snacks.nvim",
  init = function()
    -- Patch the explorer's git status to show changes vs the diff base
    -- (see lua/config/explorer_git_base.lua). Scheduled so it runs after
    -- snacks.nvim (lazy = false) is fully set up.
    vim.schedule(function()
      require("config.explorer_git_base").setup()
    end)
  end,
  opts = {
    terminal = {
      shell = "bash",
      win = {
        wo = {
          winbar = "%y %n %f",
        },
        height = 0,
        width = 0,
        position = "float",
        border = "rounded",
      },
    },
  },
}
