-- PR review mode for gitsigns: diff the working tree (HEAD) against a base
-- branch instead of the git index, so hunk signs and ]h/[h hunk navigation
-- walk base..working-tree changes (committed and uncommitted alike).
--
-- - The base defaults to the repo's default branch and can be changed with
--   `<leader>ghf` (prompt) or `:GitsignsBase <ref>` (branch completion).
--   A manual base is global and applies to all buffers. Reset it with
--   `<leader>ghF`, `:GitsignsBase` (no arg), or an empty prompt answer.
-- - Selecting a base that is not an ancestor of HEAD warns that a rebase
--   is required (also checked once per repo when using the default base).
-- - `<leader>ghd` toggles a side-by-side review diff: base on the left,
--   working file on the right, panes kept unfolded.
-- - The same base drives the snacks explorer's git highlights; the shared
--   state lives in lua/config/diff_base.lua.
-- - Everything on the buffer-attach path is asynchronous (vim.system
--   callbacks), so opening files never blocks on git.
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

    local DiffBase = require("config.diff_base")

    -- Global fallback for ]h/[h in diff-mode windows that gitsigns never
    -- attached to (e.g. Diffview panes or the gitsigns:// base pane):
    -- route to vim's ]c/[c. Buffer-local gitsigns maps (set by LazyVim's
    -- on_attach below) take precedence wherever they exist.
    for _, dir in ipairs({ { "]h", "]c" }, { "[h", "[c" } }) do
      vim.keymap.set("n", dir[1], function()
        if vim.wo.diff then
          vim.cmd.normal({ dir[2], bang = true })
        end
      end, { desc = dir[2] == "]c" and "Next Hunk (diff)" or "Prev Hunk (diff)" })
    end

    --- Directory of a buffer (or cwd for unnamed buffers).
    local function buf_path(bufnr)
      local name = vim.api.nvim_buf_get_name(bufnr)
      return name ~= "" and vim.fn.fnamemodify(name, ":p:h") or vim.uv.cwd()
    end

    --- Point one buffer's gitsigns at {ref}. All git work is async; the
    --- buffer may be gone by the time callbacks run, so re-check at every
    --- step. {ref} nil (after resolution) is a no-op.
    local function set_buf_base(bufnr, ref)
      if not ref or not vim.api.nvim_buf_is_valid(bufnr) then
        return
      end
      vim.api.nvim_buf_call(bufnr, function()
        require("gitsigns").change_base(ref, false)
      end)

      -- Files that don't exist in {ref} (whole-file adds) get no hunks:
      -- gitsigns' Obj:refresh() aborts when ls_tree fails and keeps
      -- object_name pointing at the index blob, so the buffer diffs
      -- against its own content. Clearing object_name makes gitsigns
      -- treat the file like an untracked one and highlight the whole
      -- file as added.
      local bcache = require("gitsigns.cache").cache[bufnr]
      local obj = bcache and bcache.git_obj
      local toplevel = obj and obj.repo and obj.repo.toplevel
      if not (obj and obj.relpath and toplevel) then
        return
      end
      DiffBase.git_async(toplevel, { "cat-file", "-e", ref .. ":" .. obj.relpath }, function(exists)
        if exists or not vim.api.nvim_buf_is_valid(bufnr) then
          return
        end
        local bc = require("gitsigns.cache").cache[bufnr]
        if bc and bc.git_obj and bc.git_obj.object_name then
          bc.git_obj.object_name = nil
          bc.force_next_update = true
          -- manager.update must run inside a gitsigns async context.
          require("gitsigns.async").run(function()
            require("gitsigns.manager").update(bufnr)
          end):raise_on_error()
        end
      end)
    end

    --- Resolve and apply the effective base for one buffer: {ref} when
    --- given (manual override), else the repo default (async resolution).
    --- Deferred because gitsigns runs on_attach before the buffer is in
    --- its cache, which change_base() requires.
    local function apply_base(bufnr, ref)
      vim.schedule(function()
        if not vim.api.nvim_buf_is_valid(bufnr) then
          return
        end
        if ref then
          return set_buf_base(bufnr, ref)
        end
        DiffBase.base_for_async(buf_path(bufnr), function(resolved)
          if resolved then
            set_buf_base(bufnr, resolved)
          end
        end)
      end)
    end

    --- Apply {ref} (or per-repo default when nil) to every buffer, and
    --- warn when {ref} is not an ancestor of HEAD (rebase needed).
    local function set_base(ref)
      local toplevel = DiffBase.toplevel_of(buf_path(0))
      if ref then
        if toplevel and not DiffBase.git(toplevel, "rev-parse", "--verify", "--quiet", ref) then
          vim.notify(("gitsigns: invalid base %q"):format(ref), vim.log.levels.ERROR, { title = "gitsigns" })
          return
        end
        if toplevel then
          DiffBase.warn_unless_ancestor(toplevel, ref)
        end
      end
      DiffBase.set(ref) -- also updates the explorer highlights
      for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        apply_base(bufnr, ref)
      end
      vim.notify("Diff base: " .. (ref or "repo default"), vim.log.levels.INFO, { title = "gitsigns" })
    end

    --- Prompt for a diff base with completion (branches, tags, recent
    --- commits) -- anything else (full hashes, HEAD~3, ...) can be typed
    --- freely, just like :GitsignsBase.
    local function prompt_base()
      local current = DiffBase.get_override() or DiffBase.base_for(buf_path(0)) or ""
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

    -- Completion for the prompt and the :GitsignsBase command: branches,
    -- tags, and recent commit hashes.
    _G.gitsigns_base_branches = function()
      local cwd = vim.fn.getcwd()
      local refs = {}
      for _, out in ipairs({
        DiffBase.git(cwd, "branch", "--all", "--format=%(refname:short)"),
        DiffBase.git(cwd, "tag", "--format=%(refname:short)"),
        DiffBase.git(cwd, "log", "-50", "--pretty=format:%h"),
      }) do
        for _, line in ipairs(vim.split(out or "", "\n")) do
          if line ~= "" then
            refs[#refs + 1] = line
          end
        end
      end
      table.sort(refs)
      return refs
    end

    vim.api.nvim_create_user_command("GitsignsBase", function(cmd)
      local arg = vim.trim(cmd.args)
      set_base(arg ~= "" and arg or nil)
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
      local ref = DiffBase.get_override() or DiffBase.base_for(buf_path(0))
      if not ref then
        vim.notify("gitsigns: no diff base for this buffer", vim.log.levels.WARN, { title = "gitsigns" })
        return
      end
      gs.diffthis(ref, { vertical = true })
    end

    -- Diff panes: `q` closes the read-only base pane, and nothing is ever
    -- folded -- vim's diff folds (and any syntax folds the base buffer
    -- picks up) make files look selected/hidden otherwise.
    vim.api.nvim_create_autocmd("BufWinEnter", {
      pattern = "gitsigns://*",
      group = vim.api.nvim_create_augroup("gitsigns-diff-base", { clear = true }),
      callback = function(args)
        vim.keymap.set("n", "q", function()
          vim.api.nvim_win_close(0, false)
        end, { buffer = args.buf, desc = "Close diff pane" })
        -- Open (and prevent) folds in every diff window of this tabpage:
        -- the file pane as well, since diffthis sets foldmethod=diff on it.
        -- Deferred passes because the file pane's 'diff' option settles
        -- after the base pane opens, and fold plugins may run late.
        local function unfold_diff_wins()
          for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
            if vim.wo[win].diff then
              vim.wo[win].foldenable = false
              vim.wo[win].foldlevel = 99
              pcall(vim.api.nvim_win_call, win, function()
                -- Stop diff/syntax folds from being recreated and erase
                -- existing ones: with no folds, nothing can appear folded.
                vim.wo.foldmethod = "manual"
                vim.cmd("normal! zE")
              end)
            end
          end
        end
        unfold_diff_wins()
        vim.schedule(unfold_diff_wins)
        vim.defer_fn(unfold_diff_wins, 100)
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

      -- Point this buffer's hunks at HEAD..base instead of the index, and
      -- warn once if the default base is not an ancestor of HEAD.
      local dir = buf_path(buffer)
      local toplevel = DiffBase.toplevel_of(dir)
      if toplevel then
        DiffBase.base_for_async(dir, function(ref)
          if ref then
            DiffBase.warn_unless_ancestor(toplevel, ref)
          end
        end)
      end
      apply_base(buffer, nil)
    end
  end,
}
