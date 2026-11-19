-- PR review mode for gitsigns: diff the working tree (HEAD) against a base
-- branch instead of the git index, so hunk signs and ]h/[h hunk navigation
-- walk HEAD..base changes.
--
-- - The base defaults to the repo's default branch, resolved via
--   origin/HEAD with fallbacks (init.defaultBranch, main, master).
-- - Change it with `<leader>ghf` (prompt) or `:GitsignsBase <ref>` (branch
--   completion). A manual base is global and applies to all buffers.
-- - Reset to the repo default with `<leader>ghF`, `:GitsignsBase` (no arg),
--   or an empty answer at the prompt.
-- - `<leader>ghd` toggles a side-by-side review diff: base on the left,
--   HEAD (working file) on the right.
--
-- Note: staging signs (`signs_staged`) don't apply while diffing against a
-- base revision; staging hunk keymaps still work normally.
return {
  "lewis6991/gitsigns.nvim",
  opts = function(_, opts)
    -- Regenerate the comparison text on every update. Without this,
    -- change_base() racing the attach-time update can leave a stale
    -- compare_text (computed against the index) and show no hunks.
    opts._refresh_staged_on_update = true

    local base_ref -- manual base override; nil = use repo default branch

    local default_cache = {} -- toplevel -> default branch ref (false = not found)
    local toplevel_cache = {} -- dir -> repo toplevel (false = not a repo)

    local function git(dir, ...)
      local out = vim.fn.system({ "git", "-C", dir, ... })
      if vim.v.shell_error ~= 0 then
        return nil
      end
      return vim.trim(out)
    end

    --- Repo default branch ref (e.g. "origin/main"), or nil if not resolvable.
    local function default_branch(toplevel)
      if default_cache[toplevel] == nil then
        local ref = git(toplevel, "symbolic-ref", "--short", "refs/remotes/origin/HEAD")
        if ref then
          ref = ref:gsub("^remotes/", "")
        else
          local candidates = { "main", "master" }
          local configured = git(toplevel, "config", "--get", "init.defaultBranch")
          if configured and configured ~= "" then
            table.insert(candidates, 1, configured)
          end
          for _, branch in ipairs(candidates) do
            if git(toplevel, "rev-parse", "--verify", "--quiet", "origin/" .. branch) then
              ref = "origin/" .. branch
              break
            elseif git(toplevel, "rev-parse", "--verify", "--quiet", branch) then
              ref = branch
              break
            end
          end
        end
        default_cache[toplevel] = ref or false
      end
      return default_cache[toplevel] or nil
    end

    local function toplevel_of(dir)
      if toplevel_cache[dir] == nil then
        toplevel_cache[dir] = git(dir, "rev-parse", "--show-toplevel") or false
      end
      return toplevel_cache[dir] or nil
    end

    local function buf_toplevel(bufnr)
      local name = vim.api.nvim_buf_get_name(bufnr)
      local dir = name ~= "" and vim.fn.fnamemodify(name, ":p:h") or vim.uv.cwd()
      return toplevel_of(dir)
    end

    --- Effective diff base for a buffer: manual override, else repo default.
    local function base_for(bufnr)
      if base_ref then
        return base_ref
      end
      local toplevel = buf_toplevel(bufnr)
      return toplevel and default_branch(toplevel) or nil
    end

    --- Set the base of one buffer (no-op for buffers gitsigns isn't attached
    --- to yet). Deferred because gitsigns runs on_attach before the buffer is
    --- in its cache, which change_base() requires.
    local function apply_base(bufnr, ref)
      if not ref then
        return
      end
      vim.schedule(function()
        vim.api.nvim_buf_call(bufnr, function()
          require("gitsigns").change_base(ref, false)
        end)
      end)
    end

    --- Apply {ref} (or per-repo default when nil) to every buffer.
    local function set_base(ref)
      if ref then
        local toplevel = buf_toplevel(0)
        if toplevel and not git(toplevel, "rev-parse", "--verify", "--quiet", ref) then
          vim.notify(("gitsigns: invalid base %q"):format(ref), vim.log.levels.ERROR, { title = "gitsigns" })
          return
        end
      end
      base_ref = ref
      for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        apply_base(bufnr, ref or base_for(bufnr))
      end
      vim.notify("Diff base: " .. (ref or "repo default"), vim.log.levels.INFO, { title = "gitsigns" })
    end

    local function prompt_base()
      local current = base_ref or base_for(0) or ""
      vim.ui.input({
        prompt = "Diff base (empty = repo default branch): ",
        default = current,
        completion = "customlist,v:lua.gitsigns_base_branches",
      }, function(input)
        if input == nil then
          return -- cancelled
        end
        set_base(input ~= "" and input or nil)
      end)
    end

    -- Branch completion for the prompt and the :GitsignsBase command.
    _G.gitsigns_base_branches = function()
      local dir = vim.fn.getcwd()
      local out = git(dir, "branch", "--all", "--format=%(refname:short)")
      if not out or out == "" then
        return {}
      end
      local branches = {}
      for _, line in ipairs(vim.split(out, "\n")) do
        if line ~= "" then
          table.insert(branches, line)
        end
      end
      table.sort(branches)
      return branches
    end

    vim.api.nvim_create_user_command("GitsignsBase", function(cmd)
      local arg = vim.trim(cmd.args)
      if arg == "" then
        set_base(nil)
      else
        set_base(arg)
      end
    end, {
      nargs = "?",
      complete = function()
        return _G.gitsigns_base_branches()
      end,
      desc = "Set gitsigns diff base (empty = repo default branch)",
    })

    --- Toggle a side-by-side diff for the current buffer: base on the
    --- left, HEAD (working file) on the right, cursor stays on the right.
    local function diff_vs_base()
      local gs = require("gitsigns")
      -- Already open? Close the revision pane and leave diff mode.
      local closed = false
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.startswith(vim.api.nvim_buf_get_name(buf), "gitsigns://") then
          vim.api.nvim_win_close(win, false)
          closed = true
        end
      end
      if closed then
        return
      end
      local ref = base_for(0)
      if not ref then
        vim.notify("gitsigns: no diff base for this buffer", vim.log.levels.WARN, { title = "gitsigns" })
        return
      end
      gs.diffthis(ref, { vertical = true })
    end

    -- `q` closes the read-only base pane opened by diff_vs_base().
    vim.api.nvim_create_autocmd("BufWinEnter", {
      pattern = "gitsigns://*",
      group = vim.api.nvim_create_augroup("gitsigns-diff-base", { clear = true }),
      callback = function(args)
        vim.keymap.set("n", "q", function()
          vim.api.nvim_win_close(0, false)
        end, { buffer = args.buf, desc = "Close diff pane" })
      end,
    })

    local lazyvim_on_attach = opts.on_attach
    opts.on_attach = function(buffer)
      if lazyvim_on_attach then
        lazyvim_on_attach(buffer)
      end

      local function map(l, r, desc)
        vim.keymap.set("n", l, r, { buffer = buffer, desc = desc, silent = true })
      end

      map("<leader>ghf", prompt_base, "Set Diff Base")
      map("<leader>ghF", function()
        set_base(nil)
      end, "Reset Diff Base")
      -- Replaces LazyVim's <leader>ghd (diff vs index): with a base set, the
      -- interesting diff is HEAD vs base.
      map("<leader>ghd", diff_vs_base, "Diff vs Base")

      -- Point this buffer's hunks at HEAD..base instead of the index.
      apply_base(buffer, base_for(buffer))
    end
  end,
}
