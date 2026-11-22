-- Deferred loading: plugins triggered by `ft = "markdown"` load
-- synchronously inside :edit and delay the first display of the buffer.
-- Instead, a short timer lets nvim paint the file first; the User event
-- then loads the plugin, and re-firing FileType lets the plugin's own
-- FileType handler attach to the already-open buffer (guarded so the
-- re-fire does not schedule another deferred load).
local load_event = "User RenderMarkdownDeferred"
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  group = vim.api.nvim_create_augroup("render-markdown-defer", { clear = true }),
  callback = function(args)
    if package.loaded["render-markdown"] then
      return
    end
    vim.defer_fn(function()
      if package.loaded["render-markdown"] then
        return
      end
      vim.api.nvim_exec_autocmds("User", { pattern = "RenderMarkdownDeferred" })
      -- plugin is loaded now; let its FileType autocmd attach this buffer
      vim.api.nvim_exec_autocmds("FileType", { buffer = args.buf })
    end, 200)
  end,
})

return {
  "MeanderingProgrammer/render-markdown.nvim",
  event = load_event,
  -- Clear the ft = markdown trigger that the LazyVim markdown extra
  -- merges in (spec list values can only be replaced, not removed,
  -- except by returning a new list from a function).
  ft = function()
    return {}
  end,
  opts = {
    -- Do not render (and thus conceal links/comments) when opening markdown;
    -- <leader>um toggles rendering on demand.
    enabled = false,
  },
}
