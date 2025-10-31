-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader>ug", ":Twilight<cr>", { desc = "Twilight" })
vim.keymap.set("n", "<leader><cr>", require("hop").hint_words, { desc = "HopWord" })
vim.keymap.set("n", "<leader>uz", "<cmd>ZenMode<cr>", { desc = "Zen Mode" })
vim.keymap.set("v", "<leader>te", function()
  require("ansible").run()
end, { desc = "Run selected Ansible" })
vim.keymap.set("n", "<leader>te", "<cmd>:lua require('ansible').run()<CR>", { desc = "Run Ansible" })
vim.keymap.set("n", "<leader>m", "<cmd>Telescope make<cr>", { desc = "Makefile" })
vim.keymap.set("n", "<leader>cn", "<cmd>Neoformat<cr>", { desc = "Format with Neoformat" })

vim.keymap.set("n", "<leader>bt", "<cmd>Telescope buffers<cr>", { desc = "Telescope list buffers" })

local Terminal = require("toggleterm.terminal").Terminal

local opencode_term = nil
vim.keymap.set("n", "<leader>oc", function()
  if not opencode_term then
    opencode_term = Terminal:new({
      cmd = "opencode",
      direction = "float",
      size = 1.0,
      float_opts = {
        border = "curved",
        title = "Opencode CLI",
      },
    })
  end
  opencode_term:toggle()
end, { desc = "Toggle Opencode CLI" })

vim.keymap.set("n", "<leader>k", function()
  if not gemini_term then
    gemini_term = Terminal:new({
      cmd = "k9s",
      direction = "float",
      size = 1.0,
      float_opts = {
        border = "curved",
        title = "K9S",
      },
    })
  end
  gemini_term:toggle()
end, { desc = "Toggle K9S CLI" })

local github_copilot_terminal = nil
vim.keymap.set("n", "<leader>at", function()
  if not github_copilot_terminal then
    github_copilot_terminal = Terminal:new({
      cmd = "copilot",
      direction = "float",
      size = 1.0,
      float_opts = {
        border = "curved",
        title = "Opencode CLI",
      },
    })
  end
  github_copilot_terminal:toggle()
end, { desc = "Toggle GitHub Copilot CLI" })
