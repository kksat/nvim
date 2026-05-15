return {
  "folke/sidekick.nvim",
  opts = {
    cli = {
      tools = {
        ["claude-yolo"] = {
          cmd = { "claude", "--dangerously-skip-permissions" },
        },
        ["hermes"] = {
          cmd = { "hermes" },
        },
        ["hermes new worktree"] = {
          cmd = { "hermes", "--worktree" },
        },
        ["kimi"] = {
          cmd = { "kimi" },
        },
        ["kimi-yolo"] = {
          cmd = { "kimi", "--yolo" },
        },
        ["agent"] = {
          cmd = { "agent" },
        },
      },
    }
  }
}
