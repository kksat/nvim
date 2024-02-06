return {
  "pwntester/octo.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("octo").setup({
      use_local_fs = false, -- use local files on right side of reviews
      enable_builtin = false, -- shows a list of builtin actions when no action is provided
      default_remote = { "upstream", "origin" }, -- order to try remotes
      default_merge_method = "commit", -- default merge method which should be used when calling `Octo pr merge`, could be `commit`, `rebase` or `squash`
      ssh_aliases = {}, -- SSH aliases. e.g. `ssh_aliases = {["github.com-work"] = "github.com"}`
      picker = "telescope", -- or "fzf-lua"
      picker_config = {
        use_emojis = false, -- only used by "fzf-lua" picker for now
        mappings = { -- mappings for the pickers
          open_in_browser = { lhs = "<C-b>", desc = "open issue in browser" },
          copy_url = { lhs = "<C-y>", desc = "copy url to system clipboard" },
          checkout_pr = { lhs = "<C-o>", desc = "checkout pull request" },
          merge_pr = { lhs = "<C-r>", desc = "merge pull request" },
        },
      },
      comment_icon = "▎", -- comment marker
      outdated_icon = "󰅒 ", -- outdated indicator
      resolved_icon = " ", -- resolved indicator
      reaction_viewer_hint_icon = " ", -- marker for user reactions
      user_icon = " ", -- user icon
      timeline_marker = " ", -- timeline marker
      timeline_indent = "2", -- timeline indentation
      right_bubble_delimiter = "", -- bubble delimiter
      left_bubble_delimiter = "", -- bubble delimiter
      github_hostname = "", -- GitHub Enterprise host
      snippet_context_lines = 4, -- number or lines around commented lines
      gh_env = {}, -- extra environment variables to pass on to GitHub CLI, can be a table or function returning a table
      timeout = 5000, -- timeout for requests between the remote server
      default_to_projects_v2 = false, -- use projects v2 for the `Octo card ...` command by default. Both legacy and v2 commands are available under `Octo cardlegacy ...` and `Octo cardv2 ...` respectively.
      ui = {
        use_signcolumn = true, -- show "modified" marks on the sign column
      },
      issues = {
        order_by = { -- criteria to sort results of `Octo issue list`
          field = "CREATED_AT", -- either COMMENTS, CREATED_AT or UPDATED_AT (https://docs.github.com/en/graphql/reference/enums#issueorderfield)
          direction = "DESC", -- either DESC or ASC (https://docs.github.com/en/graphql/reference/enums#orderdirection)
        },
      },
      pull_requests = {
        order_by = { -- criteria to sort the results of `Octo pr list`
          field = "CREATED_AT", -- either COMMENTS, CREATED_AT or UPDATED_AT (https://docs.github.com/en/graphql/reference/enums#issueorderfield)
          direction = "DESC", -- either DESC or ASC (https://docs.github.com/en/graphql/reference/enums#orderdirection)
        },
        always_select_remote_on_create = false, -- always give prompt to select base remote repo when creating PRs
      },
      file_panel = {
        size = 10, -- changed files panel rows
        use_icons = true, -- use web-devicons in file panel (if false, nvim-web-devicons does not need to be installed)
      },
      colors = { -- used for highlight groups (see Colors section below)
        white = "#ffffff",
        grey = "#2A354C",
        black = "#000000",
        red = "#fdb8c0",
        dark_red = "#da3633",
        green = "#acf2bd",
        dark_green = "#238636",
        yellow = "#d3c846",
        dark_yellow = "#735c0f",
        blue = "#58A6FF",
        dark_blue = "#0366d6",
        purple = "#6f42c1",
      },
      mappings = {
        issue = {
          close_issue = { lhs = "<space>oic", desc = "close issue" },
          reopen_issue = { lhs = "<space>oio", desc = "reopen issue" },
          list_issues = { lhs = "<space>oil", desc = "list open issues on same repo" },
          reload = { lhs = "<C-r>", desc = "reload issue" },
          open_in_browser = { lhs = "<C-b>", desc = "open issue in browser" },
          copy_url = { lhs = "<C-y>", desc = "copy url to system clipboard" },
          add_assignee = { lhs = "<space>oaa", desc = "add assignee" },
          remove_assignee = { lhs = "<space>oad", desc = "remove assignee" },
          create_label = { lhs = "<space>olc", desc = "create label" },
          add_label = { lhs = "<space>ola", desc = "add label" },
          remove_label = { lhs = "<space>old", desc = "remove label" },
          goto_issue = { lhs = "<space>ogi", desc = "navigate to a local repo issue" },
          add_comment = { lhs = "<space>oca", desc = "add comment" },
          delete_comment = { lhs = "<space>ocd", desc = "delete comment" },
          next_comment = { lhs = "]c", desc = "go to next comment" },
          prev_comment = { lhs = "[c", desc = "go to previous comment" },
          react_hooray = { lhs = "<space>orp", desc = "add/remove 🎉 reaction" },
          react_heart = { lhs = "<space>orh", desc = "add/remove ❤️ reaction" },
          react_eyes = { lhs = "<space>ore", desc = "add/remove 👀 reaction" },
          react_thumbs_up = { lhs = "<space>or+", desc = "add/remove 👍 reaction" },
          react_thumbs_down = { lhs = "<space>or-", desc = "add/remove 👎 reaction" },
          react_rocket = { lhs = "<space>orr", desc = "add/remove 🚀 reaction" },
          react_laugh = { lhs = "<space>orl", desc = "add/remove 😄 reaction" },
          react_confused = { lhs = "<space>orc", desc = "add/remove 😕 reaction" },
        },
        pull_request = {
          checkout_pr = { lhs = "<space>opo", desc = "checkout PR" },
          merge_pr = { lhs = "<space>opm", desc = "merge commit PR" },
          squash_and_merge_pr = { lhs = "<space>opsm", desc = "squash and merge PR" },
          list_commits = { lhs = "<space>opc", desc = "list PR commits" },
          list_changed_files = { lhs = "<space>opf", desc = "list PR changed files" },
          show_pr_diff = { lhs = "<space>opd", desc = "show PR diff" },
          add_reviewer = { lhs = "<space>ova", desc = "add reviewer" },
          remove_reviewer = { lhs = "<space>ovd", desc = "remove reviewer request" },
          close_issue = { lhs = "<space>oic", desc = "close PR" },
          reopen_issue = { lhs = "<space>oio", desc = "reopen PR" },
          list_issues = { lhs = "<space>oil", desc = "list open issues on same repo" },
          reload = { lhs = "<C-r>", desc = "reload PR" },
          open_in_browser = { lhs = "<C-b>", desc = "open PR in browser" },
          copy_url = { lhs = "<C-y>", desc = "copy url to system clipboard" },
          goto_file = { lhs = "gf", desc = "go to file" },
          add_assignee = { lhs = "<space>oaa", desc = "add assignee" },
          remove_assignee = { lhs = "<space>oad", desc = "remove assignee" },
          create_label = { lhs = "<space>olc", desc = "create label" },
          add_label = { lhs = "<space>ola", desc = "add label" },
          remove_label = { lhs = "<space>old", desc = "remove label" },
          goto_issue = { lhs = "<space>ogi", desc = "navigate to a local repo issue" },
          add_comment = { lhs = "<space>oca", desc = "add comment" },
          delete_comment = { lhs = "<space>ocd", desc = "delete comment" },
          next_comment = { lhs = "]c", desc = "go to next comment" },
          prev_comment = { lhs = "[c", desc = "go to previous comment" },
          react_hooray = { lhs = "<space>orp", desc = "add/remove 🎉 reaction" },
          react_heart = { lhs = "<space>orh", desc = "add/remove ❤️ reaction" },
          react_eyes = { lhs = "<space>ore", desc = "add/remove 👀 reaction" },
          react_thumbs_up = { lhs = "<space>or+", desc = "add/remove 👍 reaction" },
          react_thumbs_down = { lhs = "<space>or-", desc = "add/remove 👎 reaction" },
          react_rocket = { lhs = "<space>orr", desc = "add/remove 🚀 reaction" },
          react_laugh = { lhs = "<space>orl", desc = "add/remove 😄 reaction" },
          react_confused = { lhs = "<space>orc", desc = "add/remove 😕 reaction" },
        },
        review_thread = {
          goto_issue = { lhs = "<space>ogi", desc = "navigate to a local repo issue" },
          add_comment = { lhs = "<space>oca", desc = "add comment" },
          add_suggestion = { lhs = "<space>osa", desc = "add suggestion" },
          delete_comment = { lhs = "<space>ocd", desc = "delete comment" },
          next_comment = { lhs = "]c", desc = "go to next comment" },
          prev_comment = { lhs = "[c", desc = "go to previous comment" },
          select_next_entry = { lhs = "]q", desc = "move to previous changed file" },
          select_prev_entry = { lhs = "[q", desc = "move to next changed file" },
          select_first_entry = { lhs = "[Q", desc = "move to first changed file" },
          select_last_entry = { lhs = "]Q", desc = "move to last changed file" },
          close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
          react_hooray = { lhs = "<space>orp", desc = "add/remove 🎉 reaction" },
          react_heart = { lhs = "<space>orh", desc = "add/remove ❤️ reaction" },
          react_eyes = { lhs = "<space>ore", desc = "add/remove 👀 reaction" },
          react_thumbs_up = { lhs = "<space>or+", desc = "add/remove 👍 reaction" },
          react_thumbs_down = { lhs = "<space>or-", desc = "add/remove 👎 reaction" },
          react_rocket = { lhs = "<space>orr", desc = "add/remove 🚀 reaction" },
          react_laugh = { lhs = "<space>orl", desc = "add/remove 😄 reaction" },
          react_confused = { lhs = "<space>orc", desc = "add/remove 😕 reaction" },
        },
        submit_win = {
          approve_review = { lhs = "<C-a>", desc = "approve review" },
          comment_review = { lhs = "<C-m>", desc = "comment review" },
          request_changes = { lhs = "<C-r>", desc = "request changes review" },
          close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
        },
        review_diff = {
          add_review_comment = { lhs = "<space>oca", desc = "add a new review comment" },
          add_review_suggestion = { lhs = "<space>osa", desc = "add a new review suggestion" },
          focus_files = { lhs = "<leader>e", desc = "move focus to changed file panel" },
          toggle_files = { lhs = "<leader>b", desc = "hide/show changed files panel" },
          next_thread = { lhs = "]t", desc = "move to next thread" },
          prev_thread = { lhs = "[t", desc = "move to previous thread" },
          select_next_entry = { lhs = "]q", desc = "move to previous changed file" },
          select_prev_entry = { lhs = "[q", desc = "move to next changed file" },
          select_first_entry = { lhs = "[Q", desc = "move to first changed file" },
          select_last_entry = { lhs = "]Q", desc = "move to last changed file" },
          close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
          toggle_viewed = { lhs = "<leader><space>", desc = "toggle viewer viewed state" },
          goto_file = { lhs = "gf", desc = "go to file" },
        },
        file_panel = {
          next_entry = { lhs = "j", desc = "move to next changed file" },
          prev_entry = { lhs = "k", desc = "move to previous changed file" },
          select_entry = { lhs = "<cr>", desc = "show selected changed file diffs" },
          refresh_files = { lhs = "R", desc = "refresh changed files panel" },
          focus_files = { lhs = "<leader>e", desc = "move focus to changed file panel" },
          toggle_files = { lhs = "<leader>b", desc = "hide/show changed files panel" },
          select_next_entry = { lhs = "]q", desc = "move to previous changed file" },
          select_prev_entry = { lhs = "[q", desc = "move to next changed file" },
          select_first_entry = { lhs = "[Q", desc = "move to first changed file" },
          select_last_entry = { lhs = "]Q", desc = "move to last changed file" },
          close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
          toggle_viewed = { lhs = "<leader><space>", desc = "toggle viewer viewed state" },
        },
      },
    })
  end,
}
