return {
  "epwalsh/obsidian.nvim",
  version = "*",  -- recommended, use latest release instead of latest commit
  lazy = true,
  -- Only load for markdown files inside a vault, so README.md in code
  -- repositories does not pay obsidian's (plenary/nui) load cost.
  event = {
    "BufReadPre " .. vim.fn.expand("~/vaults/personal") .. "/*.md",
    "BufNewFile " .. vim.fn.expand("~/vaults/personal") .. "/*.md",
    "BufReadPre " .. vim.fn.expand("~/vaults/work") .. "/*.md",
    "BufNewFile " .. vim.fn.expand("~/vaults/work") .. "/*.md",
  },
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",

    -- see below for full list of optional dependencies 👇
  },
  opts = {
    workspaces = {
      {
        name = "personal",
        path = "~/vaults/personal",
      },
      {
        name = "work",
        path = "~/vaults/work",
      },
    },

    -- see below for full list of options 👇
  },
}
