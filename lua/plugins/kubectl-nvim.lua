return {
  {
    "ramilito/kubectl.nvim",
    enabled = false,
    config = function()
      require("kubectl").setup()
      vim.keymap.set(
        "n",
        "<leader>k",
        '<cmd>:lua require("kubectl").toggle()<cr>',
        { noremap = true, silent = true }
      )
    end,
  },
}
