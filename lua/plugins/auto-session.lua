return {
  "rmagatti/auto-session",
  event = "VimEnter",
  ---@module "auto-session"
  ---@type AutoSession.Config
  opts = {
    suppressed_dirs = { "~/", "~/Downloads", "/" },
  },
}
