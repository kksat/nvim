-- SPDX-FileCopyrightText: 2024 Kirill Satarin (@kksat) <22549266+kksat@users.noreply.github.com>
-- SPDX-License-Identifier: MIT

-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
--
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile", "BufEnter" }, {
	group = vim.api.nvim_create_augroup("Ansible", { clear = true }),
	pattern = {
		"*.yml",
		"*.yaml",
	},
	callback = function()
		vim.opt.filetype = "yaml.ansible"
	end,
})

-- vim.g.copilot_filetypes = { "*" = true }

vim.api.nvim_create_autocmd("User", {
	pattern = "GitConflictDetected",
	callback = function()
		vim.notify("Conflict detected in " .. vim.fn.expand("<afile>"))
		vim.keymap.set("n", "cww", function()
			engage.conflict_buster()
			create_buffer_local_mappings()
		end)
	end,

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("FixBicepCommentString", { clear = true }),
  callback = function(ev)
    vim.bo[ev.buf].commentstring = "// %s"
  end,
  pattern = { "bicep", "bicepparam" },
})
