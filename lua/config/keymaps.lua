-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader>ug", ":Twilight<cr>", { desc = "Twilight" })
vim.keymap.set("n", "<cr>", require("hop").hint_words, { desc = "HopWord" })
vim.keymap.set("n", "<leader>uz", "<cmd>ZenMode<cr>", { desc = "Zen Mode" })
vim.keymap.set("v", "<leader>te", function()
	require("ansible").run()
end, { desc = "Run selected Ansible" })
vim.keymap.set("n", "<leader>te", "<cmd>:lua require('ansible').run()<CR>", { desc = "Run Ansible" })
vim.keymap.set("n", "<leader>m", "<cmd>Telescope make<cr>", { desc = "Makefile" })
vim.keymap.set("n", "<leader>cn", "<cmd>Neoformat<cr>", { desc = "Format with Neoformat" })
