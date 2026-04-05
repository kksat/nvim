return {
  "FabijanZulj/blame.nvim",
  cmd = { "BlameToggle", "BlameEnable", "BlameDisable" },
  config = function()
    require("blame").setup()
  end
}
