return {
  "folke/snacks.nvim",
  config = {
    terminal = {
      shell = "bash",
      win = {
        wo = {
          winbar = "%{get(b:, 'term_title', '')}",
        },
        height = 0,
        width = 0,
        position = "float",
        border = "rounded",
      }
    }
  },
}
