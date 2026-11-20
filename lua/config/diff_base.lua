-- Shared diff-base state: the git ref that gitsigns (and the snacks
-- explorer patch, see lua/config/explorer_git_base.lua) compare the
-- working tree against.
--
-- The default is the repo's default branch, resolved via origin/HEAD with
-- fallbacks (init.defaultBranch, main, master). A global manual override
-- can be set with M.set() (see :GitsignsBase / <leader>ghf in
-- lua/plugins/gitsigns.lua).
--
-- Hot paths (buffer attach, explorer refresh) use the *_async APIs so no
-- synchronous git process ever runs while opening a file. Sync APIs remain
-- for user-invoked commands (prompt, validation).
local M = {}

local override ---@type string? manual base; nil = per-repo default branch

local default_cache = {} ---@type table<string, string|false> toplevel -> default branch (false = not found)
local toplevel_cache = {} ---@type table<string, string|false> dir -> repo toplevel (false = not a repo)
local ancestry_warned = {} ---@type table<string, true> toplevel|ref -> warned this session
local listeners = {} ---@type fun()[]

--- Run git in {dir}, returning trimmed output or nil on failure.
--- Synchronous: only for user-invoked commands, never on the attach path.
---@param dir string
function M.git(dir, ...)
  local out = vim.fn.system({ "git", "-C", dir, ... })
  if vim.v.shell_error ~= 0 then
    return nil
  end
  return vim.trim(out)
end

--- Run git in {dir} asynchronously; calls cb(trimmed output) on success or
--- cb(nil) on failure, from the main loop.
---@param dir string
---@param args string[]
---@param cb fun(out: string?)
local function git_async(dir, args, cb)
  vim.system({ "git", "-C", dir, unpack(args) }, { text = true }, function(res)
    vim.schedule(function()
      cb(res.code == 0 and vim.trim(res.stdout or "") or nil)
    end)
  end)
end

--- Exposed for other config modules (e.g. gitsigns.lua cat-file check).
M.git_async = git_async

--- Repo toplevel for a path inside it, or nil. Uses the filesystem (no
--- git process), so it is cheap enough for the attach path.
---@param path string
function M.toplevel_of(path)
  if toplevel_cache[path] == nil then
    local root = vim.fs.root(path, ".git")
    toplevel_cache[path] = root or false
  end
  return toplevel_cache[path] or nil
end

--- Default branch ref for a repo (e.g. "origin/main"), or nil.
--- Synchronous: only for user-invoked commands.
---@param toplevel string
function M.default_branch(toplevel)
  if default_cache[toplevel] == nil then
    local ref = M.git(toplevel, "symbolic-ref", "--short", "refs/remotes/origin/HEAD")
    if ref then
      ref = ref:gsub("^remotes/", "")
    else
      local candidates = { "main", "master" }
      local configured = M.git(toplevel, "config", "--get", "init.defaultBranch")
      if configured and configured ~= "" then
        table.insert(candidates, 1, configured)
      end
      for _, branch in ipairs(candidates) do
        if M.git(toplevel, "rev-parse", "--verify", "--quiet", "origin/" .. branch) then
          ref = "origin/" .. branch
          break
        elseif M.git(toplevel, "rev-parse", "--verify", "--quiet", branch) then
          ref = branch
          break
        end
      end
    end
    default_cache[toplevel] = ref or false
  end
  return default_cache[toplevel] or nil
end

--- Async resolution of the repo default branch (same fallbacks as
--- M.default_branch), cached in the same table.
---@param toplevel string
---@param cb fun(ref: string?)
local function resolve_default_async(toplevel, cb)
  local function try(candidates, i)
    if i > #candidates then
      return cb(nil)
    end
    local branch = candidates[i]
    git_async(toplevel, { "rev-parse", "--verify", "--quiet", "origin/" .. branch }, function(out)
      if out then
        return cb("origin/" .. branch)
      end
      git_async(toplevel, { "rev-parse", "--verify", "--quiet", branch }, function(out2)
        if out2 then
          return cb(branch)
        end
        try(candidates, i + 1)
      end)
    end)
  end

  git_async(toplevel, { "symbolic-ref", "--short", "refs/remotes/origin/HEAD" }, function(ref)
    if ref then
      return cb(ref:gsub("^remotes/", ""))
    end
    git_async(toplevel, { "config", "--get", "init.defaultBranch" }, function(configured)
      local candidates = { "main", "master" }
      if configured and configured ~= "" then
        table.insert(candidates, 1, configured)
      end
      try(candidates, 1)
    end)
  end)
end

--- Effective diff base for a path: manual override, else repo default.
--- Synchronous: only for user-invoked commands.
---@param path string
function M.base_for(path)
  if override then
    return override
  end
  local toplevel = M.toplevel_of(path)
  return toplevel and M.default_branch(toplevel) or nil
end

--- Async version of M.base_for for hot paths (buffer attach, explorer).
--- Always calls cb (possibly nil) from the main loop.
---@param path string
---@param cb fun(ref: string?)
function M.base_for_async(path, cb)
  if override then
    return cb(override)
  end
  local toplevel = M.toplevel_of(path)
  if not toplevel then
    return cb(nil)
  end
  local cached = default_cache[toplevel]
  if cached ~= nil then
    return cb(cached or nil)
  end
  resolve_default_async(toplevel, function(ref)
    default_cache[toplevel] = ref or false
    cb(ref)
  end)
end

--- The manual override, or nil when using per-repo defaults.
function M.get_override()
  return override
end

--- Set (or clear, with nil) the manual override and notify listeners.
---@param ref string?
function M.set(ref)
  override = ref
  for _, fn in ipairs(listeners) do
    pcall(fn)
  end
end

--- Register a callback run after every M.set().
---@param fn fun()
function M.on_change(fn)
  listeners[#listeners + 1] = fn
end

--- Is {ref} an ancestor of HEAD in the repo at {toplevel}? Async.
---@param toplevel string
---@param ref string
---@param cb fun(is_ancestor: boolean)
function M.is_ancestor_async(toplevel, ref, cb)
  git_async(toplevel, { "merge-base", "--is-ancestor", ref, "HEAD" }, function(out)
    cb(out ~= nil)
  end)
end

--- Warn (once per session per repo+ref) when {ref} is not an ancestor of
--- HEAD, i.e. the base has commits HEAD is missing and a rebase is needed
--- for a clean diff. Async, safe on hot paths.
---@param toplevel string
---@param ref string
function M.warn_unless_ancestor(toplevel, ref)
  local key = toplevel .. "|" .. ref
  if ancestry_warned[key] then
    return
  end
  ancestry_warned[key] = true
  M.is_ancestor_async(toplevel, ref, function(is_ancestor)
    if not is_ancestor then
      vim.notify(
        ("diff base %s is not an ancestor of HEAD: rebase onto it for a clean diff"):format(ref),
        vim.log.levels.WARN,
        { title = "gitsigns" }
      )
    end
  end)
end

return M
