-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
-- No concealing by default; stock LazyVim's <leader>uc toggles it per-window
vim.opt.conceallevel = 0
-- Diagnostics virtual lines (built into nvim >= 0.11, replaces lsp_lines.nvim)
vim.diagnostic.config({ virtual_lines = { only_current_line = true } })

vim.filetype.add {
  extension = {
    jinja = 'jinja',
    jinja2 = 'jinja',
    j2 = 'jinja',
  },
}
