-- SPDX-FileCopyrightText: 2024 Kirill Satarin (@kksat) <22549266+kksat@users.noreply.github.com>
-- SPDX-License-Identifier: MIT

-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
--

-- When nvim is started with a file argument (e.g. `nvim playbook.yml`),
-- LazyVim's LSP setup runs before VimEnter, and nvim then skips the
-- retroactive LSP attach for that first buffer (vim.lsp.enable only
-- re-attaches existing buffers when vim_did_enter or did_filetype is
-- already set). This file loads on VeryLazy, after startup, so re-run
-- nvim's own attach pass here; it is idempotent and only affects buffers
-- that were missed.
vim.defer_fn(function()
  if next(vim.lsp._enabled_configs or {}) then
    vim.cmd.doautoall("nvim.lsp.enable FileType")
  end
end, 100)

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

vim.api.nvim_create_autocmd("BufReadCmd", {
  pattern = "*.duckdb",
  callback = function(opts)
    -- Close the buffer opened by nvim
    vim.api.nvim_command("bwipeout " .. opts.buf)
    vim.cmd("terminal duckdb -ui " .. vim.fn.fnameescape(opts.match))
    vim.cmd("startinsert")
  end,
})
