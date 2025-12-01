-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader>ug", ":Twilight<cr>", { desc = "Twilight" })
vim.keymap.set("n", "<leader><cr>", require("hop").hint_words, { desc = "HopWord" })
vim.keymap.set("n", "<leader>m", "<cmd>Telescope make<cr>", { desc = "Makefile" })

vim.keymap.set("n", "<leader>bt", "<cmd>Telescope buffers<cr>", { desc = "Telescope list buffers" })

local Terminal = require("toggleterm.terminal").Terminal

local k9s_terminal = nil
vim.keymap.set("n", "<leader>k", function()
  if not k9s_terminal then
    k9s_terminal = Terminal:new({
      cmd = "k9s",
      direction = "float",
      size = 1.0,
      float_opts = {
        border = "curved",
        title = "K9S",
      },
    })
  end
  k9s_terminal:toggle()
end, { desc = "Toggle K9S CLI" })
