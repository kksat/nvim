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

local function async_git_commit_vimwiki()
  -- Get the current file path
  local filepath = vim.fn.expand('%:p')
  local filename = vim.fn.expand('%:t')

  -- Run git commands asynchronously
  vim.fn.jobstart({
    'sh', '-c',
    string.format([[
      cd "%s" &&
      git add "%s" &&
      git commit -m "%s - %s" 2>/dev/null &&
      git push origin || true
    ]], vim.fn.expand('%:p:h'), filepath, filename, os.date('%Y-%m-%d %H:%M:%S'))
  }, {
    on_exit = function(_, exit_code)
      if exit_code == 0 then
        -- Silently committed
        vim.notify('Git commit and push successful' .. filename, vim.log.levels.INFO)
      else
        vim.notify('Git commit and push failed for ' .. filename, vim.log.levels.ERROR)
      end
    end,
    stdout_buffered = true,
    stderr_buffered = true,
  })
end

-- Create autocommand group
local vimwiki_git_group = vim.api.nvim_create_augroup('VimwikiGitAuto', { clear = true })

-- Autocommand for vimwiki files
vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
  group = vimwiki_git_group,
  pattern = { vim.fn.expand('~/vimwiki/*.wiki'), },
  callback = async_git_commit_vimwiki,
  desc = 'Auto-commit vimwiki files to git asynchronously'
})

-- Optional: Add a command to manually trigger the commit
vim.api.nvim_create_user_command('VimwikiGitCommit', async_git_commit_vimwiki, {
  desc = 'Manually commit current vimwiki file to git'
})
