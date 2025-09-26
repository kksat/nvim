return {
  "greggh/claude-code.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("claude-code").setup({
      window = {
        position = "float",
        float = {
          width = "100%",
          height = "100%",
          row = "center",
          col = "center",
          relative = "editor",
          border = "double",
        },
      },
    })
  end,
  keys = {
    { "<leader>cc", "<cmd>ClaudeCode<cr>", desc = "ClaudeCode" },
  }
}
