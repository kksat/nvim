-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- :LazyInstallAll — preinstall parsers, LSP servers and Mason tools (used by
-- the dotfiles install.sh so the first nvim session installs nothing)
require("config.install-all")

vim.opt.swapfile = false

vim.keymap.set({ "n", "v" }, "Q", "<cmd>quit<CR>", { desc = "Quit" })

if vim.g.neovide then
  vim.keymap.set({ "n", "v" }, "<C-+>", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>")
  vim.keymap.set({ "n", "v" }, "<C-->", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>")
  vim.keymap.set({ "n", "v" }, "<C-0>", ":lua vim.g.neovide_scale_factor = 1<CR>")

  vim.g.neovide_cursor_animation_length = 0.100
  vim.g.neovide_cursor_short_animation_length = 0.05
  vim.g.neovide_cursor_antialiasing = true
  vim.g.neovide_cursor_animate_in_insert_mode = true
  vim.g.neovide_cursor_animate_command_line = true
end

for i = 1, 9 do
  vim.api.nvim_set_keymap('n', '<leader>' .. i, i .. 'gt', { noremap = true, silent = true })
end
