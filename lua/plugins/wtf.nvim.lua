return {
  "piersolenski/wtf.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-telescope/telescope.nvim",
  },
  opts = {
    provider = "copilot",
    search_engine = "google",
    picker = "telescope",
  },
  keys = {
    {
      "<leader>aw",
      nil,
      desc = "WTF AI",
    },
    {
      "<leader>awd",
      mode = { "n", "x" },
      function()
        require("wtf").diagnose()
      end,
      desc = "Debug diagnostic with AI",
    },
    {
      "<leader>awf",
      mode = { "n", "x" },
      function()
        require("wtf").fix()
      end,
      desc = "Fix diagnostic with AI",
    },
    {
      mode = { "n" },
      "<leader>aws",
      function()
        require("wtf").search()
      end,
      desc = "Search diagnostic with Google",
    },
    {
      mode = { "n" },
      "<leader>awp",
      function()
        require("wtf").pick_provider()
      end,
      desc = "Pick provider",
    },
    {
      mode = { "n" },
      "<leader>awh",
      function()
        require("wtf").history()
      end,
      desc = "Populate the quickfix list with previous chat history",
    },
    {
      mode = { "n" },
      "<leader>awg",
      function()
        require("wtf").grep_history()
      end,
      desc = "Grep previous chat history with Telescope",
    },
  },
}
