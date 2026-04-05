return {
  "ThePrimeagen/99",
  keys = {
    {
      "<leader>9v",
      function()
        require("99").visual()
      end,
      mode = "v",
      desc = "99 visual",
    },
    {
      "<leader>9s",
      function()
        require("99").stop_all_requests()
      end,
      mode = "v",
      desc = "99 stop requests",
    },
    {
      "<leader>9f",
      function()
        require("99").fill_in_function()
      end,
      mode = "n",
      desc = "99 fill function",
    },
  },
  config = function()
    local _99 = require("99")
    local cwd = vim.uv.cwd()
    local basename = vim.fs.basename(cwd)

    _99.setup({
      logger = {
        level = _99.DEBUG,
        path = "/tmp/" .. basename .. ".99.debug",
        print_on_error = true,
      },
      md_files = {
        "AGENT.md",
      },
    })
  end,
}
