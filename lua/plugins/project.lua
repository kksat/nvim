return {
  "coffebar/neovim-project",
  enable = false,
  opts = {
    projects = { -- define project roots
      "~/dev/*",
    },
  },
  keys = {
    {
      "<leader>jl",
      "<cmd>Telescope neovim-project discover<CR>",
      desc = "Project Discover",
    },
    {
      "<leader>jh",
      "<cmd>Telescope neovim-project history<CR>",
      desc = "Project History",
    },
  },
  init = function()
    -- enable saving the state of plugins in the session
    vim.opt.sessionoptions:append("globals") -- save global variables that start with an uppercase letter and contain at least one lowercase letter.
    vim.opt.sessionoptions:append("buffers")
    vim.opt.sessionoptions:append("curdir")
    vim.opt.sessionoptions:append("tabpages")
    vim.opt.sessionoptions:append("terminal")
  end,
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope.nvim" },
    { "Shatur/neovim-session-manager" },
  },
  lazy = false,
  priority = 100,
}
