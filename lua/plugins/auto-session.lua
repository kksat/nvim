return {
  "rmagatti/auto-session",
  event = "VimEnter",
  ---@module "auto-session"
  ---@type AutoSession.Config
  opts = {
    -- Don't auto-restore on startup. Restoring a session reopens buffers,
    -- which fires BufReadPost and pulls in LSP/treesitter/gitsigns/etc., adding
    -- ~200ms to startup. Restore manually with :SessionRestore / :SessionSearch.
    auto_restore = false,
    suppressed_dirs = { "~/", "~/Downloads", "/" },
  },
}
