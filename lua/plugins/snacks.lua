return {
  "folke/snacks.nvim",
  config = {
    terminal = {
      shell = "bash",
      win = {
        wo = {
          winbar = "%y %n %f",
          conceallevel = 2,
        },
        height = 0,
        width = 0,
        position = "float",
        border = "rounded",
      }
    }
  },
}
