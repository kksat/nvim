return {
  {
    "mason-org/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "bashls",
          "ansiblels",
          "bicep",
          "dockerls",
          "lua_ls",
          "marksman",
          "yamlls",
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
  },
}
