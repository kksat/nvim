return {
  "CopilotC-Nvim/CopilotChat.nvim",
  dependencies = {
    { "zbirenbaum/copilot.lua" },
    { "nvim-lua/plenary.nvim" },
  },
  opts = {
    debug = false,
  },
  keys = {
    {
      "<leader>ah",
      "<cmd>CopilotChatToggle<CR>",
      mode = { "n", "v" },
      desc = "GitHub Copilot Chat",
    },
  },
}
