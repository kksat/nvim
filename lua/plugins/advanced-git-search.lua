return {
  "aaronhallaert/advanced-git-search.nvim",
  cmd = "AdvancedGitSearch",
  keys = {
    {
      "<leader>gl",
      "<cmd>AdvancedGitSearch search_log_content<cr>",
      desc = "Search git log content (advanced)",
    },
    {
      "<leader>gc",
      "<cmd>AdvancedGitSearch diff_commit_file<cr>",
      desc = "Search file commits (advanced)",
      mode = "n",
    },
    {
      "<leader>gc",
      "<cmd>'<,'>AdvancedGitSearch diff_commit_line<cr>",
      desc = "Search file commits (advanced)",
      mode = "v",
    },
  },
  config = function()
    require("telescope").setup({
      extensions = {
        advanced_git_search = {
          diff_plugin = "diffview",
          git_flags = {},
          git_diff_flags = {},
          show_builtin_git_pickers = false,
          entry_default_author_or_date = "***",
          telescope_theme = {
            function_name_1 = {},
            function_name_2 = "dropdown",
            show_custom_functions = {
              layout_config = { width = 0.4, height = 0.4 },
            },
          },
        },
      },
    })

    require("telescope").load_extension("advanced_git_search")
  end,
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "tpope/vim-fugitive",
    "tpope/vim-rhubarb",
  },
}
