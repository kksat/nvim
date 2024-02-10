-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

if vim.g.neovide then
	vim.o.guifont = "CaskaydiaCove Nerd Font:h18"
end

if vim.g.gui_vimr then
	vim.o.guifont = "CaskaydiaCove Nerd Font:h18"
end

if vim.g.goneovim then
	vim.o.guifont = "CaskaydiaCove Nerd Font:h18"
end
