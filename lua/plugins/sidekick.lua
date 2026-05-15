return {
  "folke/sidekick.nvim",
  opts = {
    cli = {
      tools = {
        ["claude-yolo"] = {
          cmd = { "claude", "--dangerously-skip-permissions" },
        },
        ["hermes"] = {
          cmd = { "hermes"},
        },
        ["hermes new worktree"] = {
          cmd = { "hermes", "--worktree" },
        },
      },
    }
  }
}
