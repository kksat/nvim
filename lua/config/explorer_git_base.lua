-- Make the snacks explorer's git status reflect changes vs the diff base
-- (lua/config/diff_base.lua), not just uncommitted changes.
--
-- Wraps snacks.explorer.git so that, next to `git status --porcelain`, it
-- also fetches `git diff --name-status <base>` (which covers committed and
-- uncommitted changes alike) and merges both into the tree. Highlight
-- legend in the explorer:
--   * "M "/"A " (green, staged-style) - changed vs the base branch
--   * " M"/" A" (orange)              - has uncommitted changes
--   * "??"                            - untracked
-- A file with both gets " M", since it still has uncommitted work.
local M = {}

local TTL = 10 -- seconds to cache the base diff per repo

function M.setup()
  if M.done then
    return
  end
  M.done = true

  local DiffBase = require("config.diff_base")
  local Git = require("snacks.explorer.git")
  local uv = vim.uv or vim.loop

  -- root -> { pending?: boolean, last: number, diffs: table[], results?: table[], cwd?: string, on_update?: fun() }
  local state = {}

  local orig_update = Git.update
  local orig__update = Git._update
  local orig_refresh = Git.refresh

  --- Translate a `git diff --name-status` letter into a porcelain-style
  --- status. Staged-style codes (e.g. "M ") keep files changed vs the
  --- base visually distinct from uncommitted ones (" M").
  local function porcelain(status)
    if status == "A" then
      return "A "
    elseif status == "D" then
      return " D"
    elseif status == "U" then
      return "UU"
    end
    return "M " -- M, T, C, and anything else
  end

  local function st_for(root)
    local st = state[root]
    if not st then
      st = { last = 0, diffs = {} }
      state[root] = st
    end
    return st
  end

  --- Re-apply the recorded git status results merged with the base diffs,
  --- then re-render the explorer if anything changed.
  local function reapply(root)
    local st = state[root]
    if st and st.results and st.cwd then
      local changed = Git._update(st.cwd, st.results)
      if changed and st.on_update then
        vim.schedule(st.on_update)
      end
    end
  end

  --- Async fetch of files changed vs the base; re-applies when done.
  local function refresh_diffs(root)
    local st = st_for(root)
    if st.pending or os.time() - st.last < TTL then
      return
    end
    DiffBase.base_for_async(root, function(base)
      if not base or st.pending or os.time() - st.last < TTL then
        return
      end
      st.pending = true
      st.last = os.time()
      local output = ""
      local stdout = assert(uv.new_pipe())
      local handle ---@type uv.uv_process_t
      handle = uv.spawn("git", {
        stdio = { nil, stdout, nil },
        cwd = root,
        hide = true,
        args = {
          "--no-pager",
          "--no-optional-locks",
          "diff",
          "--name-status",
          "-z",
          "--no-renames",
          base,
        },
      }, function()
        handle:close()
      end)
      if not handle then
        st.pending = false
        return
      end
      stdout:read_start(function(err, data)
        assert(not err, err)
        if data then
          output = output .. data
          return
        end
        stdout:close()
        st.pending = false
        st.diffs = {}
        local fields = vim.split(output, "\0")
        for i = 1, #fields - 1, 2 do
          local status, file = fields[i], fields[i + 1]
          if status ~= "" and file ~= "" then
            st.diffs[#st.diffs + 1] = { status = porcelain(status), file = root .. "/" .. file }
          end
        end
        reapply(root)
      end)
    end)
  end

  Git.update = function(cwd, opts)
    local root = Snacks.git.get_root(cwd)
    if root then
      local st = st_for(root)
      st.cwd = cwd
      st.on_update = opts and opts.on_update
      refresh_diffs(root)
    end
    return orig_update(cwd, opts)
  end

  Git._update = function(cwd, results)
    local root = Snacks.git.get_root(cwd)
    if not root then
      return orig__update(cwd, results)
    end
    local st = st_for(root)
    st.results = results
    -- Merge the base diffs into a copy of the porcelain results; the
    -- original _update merges per-node statuses for files in both lists.
    local merged = vim.list_extend({}, results)
    vim.list_extend(merged, st.diffs)
    return orig__update(cwd, merged)
  end

  -- Invalidate the cached base diff whenever the repo changes (watcher
  -- events: commits, checkout, ...).
  Git.refresh = function(path)
    for _, st in pairs(state) do
      st.last = 0
    end
    return orig_refresh(path)
  end

  -- ]g/[g (explorer_git_next/prev): skip status files that are filtered
  -- out of the explorer list -- hidden paths (e.g. .config/*, .github/*)
  -- when hidden files aren't shown, or gitignored paths when ignored files
  -- aren't shown. The stock actions target such files, fail to reveal
  -- them, and then appear to do nothing at all.
  local Actions = require("snacks.explorer.actions")

  ---@param picker snacks.Picker
  ---@param node table
  local function listable(picker, node)
    if node.ignored and not picker.opts.ignored then
      return false
    end
    if not picker.opts.hidden then
      local n = node
      while n and n.parent do
        if n.hidden then
          return false
        end
        n = n.parent
      end
    end
    return true
  end

  for _, act in ipairs({ "explorer_git_next", "explorer_git_prev" }) do
    Actions.actions[act] = function(picker, item)
      local cwd = picker:cwd()
      local pos = item and item.file
      local first
      for _ = 1, 1000 do
        local node = Git.next(cwd, pos, act == "explorer_git_prev")
        if not node then
          return
        end
        if not first then
          first = node.path
        elseif node.path == first then
          return -- wrapped around, nothing listable
        end
        if listable(picker, node) then
          return Actions.update(picker, { target = node.path })
        end
        pos = node.path
      end
    end
  end

  -- "Only changed files" toggle (C): filter the explorer tree to files
  -- with git status (changed vs the diff base, or uncommitted) plus the
  -- directories leading to them.
  local Tree = require("snacks.explorer.tree")
  local Source = require("snacks.picker.source.explorer")

  ---@param item table
  local function keep_item(item)
    if not item.dir then
      return item.status ~= nil
    end
    if item.parent == nil then
      return true -- tree roots
    end
    local node = Tree:node(item.file)
    return (node ~= nil and (node.status ~= nil or node.dir_status ~= nil))
      or item.status ~= nil
      or item.dir_status ~= nil
  end

  local function wrap_finder(orig)
    return function(opts, ctx)
      local ret = orig(opts, ctx)
      if not opts.changed or type(ret) ~= "function" then
        return ret
      end
      return function(cb)
        ret(function(item)
          if keep_item(item) then
            cb(item)
          end
        end)
      end
    end
  end
  Source.explorer = wrap_finder(Source.explorer)
  Source.search = wrap_finder(Source.search)

  -- Register the toggle on the explorer source defaults so the
  -- toggle_changed action and the title indicator exist.
  local sources = require("snacks.picker.config.sources")
  sources.explorer.toggles = vim.tbl_deep_extend("force", sources.explorer.toggles or {}, {
    changed = { icon = "󰦒" },
  })
  sources.explorer.win.list.keys = vim.tbl_deep_extend(
    "force",
    sources.explorer.win.list.keys or {},
    { ["C"] = "toggle_changed" }
  )

  -- Follow manual base overrides (<leader>ghf / :GitsignsBase).
  DiffBase.on_change(function()
    for root, st in pairs(state) do
      st.last = 0
      st.diffs = {}
      refresh_diffs(root)
    end
  end)
end

return M
