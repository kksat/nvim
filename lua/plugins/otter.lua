return {
  "jmbuhr/otter.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  -- cmd-only: loading otter on every markdown buffer eagerly pulls in the
  -- completion stack (blink.cmp, friendly-snippets, vim-dadbod-completion),
  -- which made first-time markdown opens noticeably slow. Run
  -- :OtterActivate in a buffer when LSP inside code blocks is wanted.
  cmd = { "OtterActivate", "OtterDeactivate", "OtterExport", "OtterExportAs" },
  opts = {},
}
