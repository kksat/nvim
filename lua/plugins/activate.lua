return {
  "roobert/activate.nvim",
  enabled = false,
  keys = {
    {
      "<leader>P",
      '<CMD>lua require("activate").list_plugins()<CR>',
      desc = "Plugins",
    },
  },
  dependencies = {
    { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  },
}
