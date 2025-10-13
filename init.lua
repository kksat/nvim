-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.opt.swapfile = false

if vim.g.neovide then
  vim.o.guifont = "Fira Code"

  vim.keymap.set({ "n", "v" }, "<C-+>", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>")
  vim.keymap.set({ "n", "v" }, "<C-->", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>")
  vim.keymap.set({ "n", "v" }, "<C-0>", ":lua vim.g.neovide_scale_factor = 1<CR>")
end

if vim.g.gui_vimr then
	vim.o.guifont = "CaskaydiaCove Nerd Font:h18"
end

if vim.g.goneovim then
	vim.o.guifont = "CaskaydiaCove Nerd Font:h18"
end
