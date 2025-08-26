-- SPDX-FileCopyrightText: 2024 Kirill Satarin (@kksat) <22549266+kksat@users.noreply.github.com>
-- SPDX-License-Identifier: MIT

-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
--

vim.api.nvim_create_autocmd("User", {
  pattern = "GitConflictDetected",
  callback = function()
    vim.notify("Conflict detected in " .. vim.fn.expand("<afile>"))
    vim.keymap.set("n", "cww", function()
      engage.conflict_buster()
      create_buffer_local_mappings()
    end)
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("FixBicepCommentString", { clear = true }),
  callback = function(ev)
    vim.bo[ev.buf].commentstring = "// %s"
  end,
  pattern = { "bicep", "bicepparam" },
})

-- Vimwiki auto-commit on save
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "~/vimwiki/*",
  callback = function()
    local filename = vim.fn.expand("%:t")
    local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    local commit_msg = string.format("%s - %s", filename, timestamp)
    vim.fn.system(string.format('cd "%s" && git add . && git commit -m "%s" && git push origin', vim.fn.expand("%:p:h"),
      commit_msg))
  end,
})
