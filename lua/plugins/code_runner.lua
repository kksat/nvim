return {
  "CRAG666/code_runner.nvim",
  enabled = false,
  config = function()
    require("code_runner").setup({
      mode = "tab",
      filetype = {
        ["yaml.ansible"] = "echo Hello",
      },
    })
  end,
}
