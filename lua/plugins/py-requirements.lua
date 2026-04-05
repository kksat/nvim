return {
  "MeanderingProgrammer/py-requirements.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  keys = {
    {
      "<leader>ru",
      function()
        require("py-requirements").upgrade()
      end,
      desc = "Requirements: Upgrade",
    },
    {
      "<leader>rU",
      function()
        require("py-requirements").upgrade_all()
      end,
      desc = "Requirements: Upgrade All",
    },
    {
      "<leader>rK",
      function()
        require("py-requirements").show_description()
      end,
      desc = "Requirements: Show package description",
    },
  },
  config = function()
    require("py-requirements").setup({
      file_patterns = {
        "requirements.txt",
        "requirements-*.txt",
      },
    })
  end,
}
