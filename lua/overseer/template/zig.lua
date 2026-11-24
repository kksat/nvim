local overseer = require("overseer")

-- Parse the output of `zig build --list-steps` (or the "Steps:" section of
-- `zig build -h` for older zig versions). Each line looks like:
--
--   install (default)            Copy build artifacts to prefix path
--   test                         Run unit tests
--
---@param lines string[]
---@param require_header boolean Output starts with a "Steps:" header (`-h` mode)
---@return { name: string, desc: string }[]
local function parse_steps(lines, require_header)
  local steps = {}
  local in_steps = not require_header
  for _, line in ipairs(lines) do
    if line == "Steps:" then
      in_steps = true
    elseif in_steps then
      local name, desc = line:match("^%s+(%S+)%s+%(default%)%s+(.-)%s*$")
      if not name then
        name, desc = line:match("^%s+(%S+)%s+(.-)%s*$")
      end
      if not name then
        name = line:match("^%s+(%S+)%s*$")
        desc = ""
      end
      if name then
        table.insert(steps, { name = name, desc = desc or "" })
      elseif not line:match("^%s*$") then
        -- A non-empty line that is not a step entry ends the section
        -- (e.g. "General Options:")
        break
      end
    end
  end
  return steps
end

---@param cwd string
---@param cb fun(tmpls_or_err: string|overseer.TemplateDefinition[])
local function fetch_templates(cwd, cb)
  local function add_templates(steps)
    local ret = {}
    for _, step in ipairs(steps) do
      local step = step
      table.insert(ret, {
        name = string.format("zig build %s", step.name),
        desc = step.desc,
        tags = { "zig" },
        params = {
          args = {
            type = "list",
            delimiter = " ",
            default = {},
            desc = "Additional arguments passed to `zig build`",
          },
        },
        builder = function(params)
          return {
            cmd = { "zig" },
            args = vim.list_extend({ "build", step.name }, params.args),
            cwd = cwd,
          }
        end,
      })
    end
    cb(ret)
  end

  local function run(args, handler)
    overseer.builtin.system(
      vim.list_extend({ "zig", "build" }, args),
      { cwd = cwd, text = true },
      vim.schedule_wrap(handler)
    )
  end

  run({ "--list-steps" }, function(out)
    if out.code == 0 and out.stdout and out.stdout ~= "" then
      add_templates(parse_steps(vim.split(out.stdout, "\n"), false))
      return
    end
    -- Older zig versions don't support --list-steps; fall back to the
    -- "Steps:" section of `zig build -h`.
    run({ "-h" }, function(h_out)
      if h_out.code ~= 0 then
        cb(h_out.stderr or h_out.stdout or "Error running 'zig build'")
        return
      end
      add_templates(parse_steps(vim.split(h_out.stdout or "", "\n"), true))
    end)
  end)
end

---@type overseer.TemplateFileProvider
local tmpl = {
  cache_key = function(opts)
    return vim.fs.find("build.zig", { upward = true, path = opts.dir })[1]
  end,
  generator = function(opts, cb)
    if vim.fn.executable("zig") == 0 then
      return 'Command "zig" not found'
    end
    local build_zig = vim.fs.find("build.zig", { upward = true, path = opts.dir })[1]
    if not build_zig then
      return "No build.zig found"
    end
    fetch_templates(vim.fs.dirname(build_zig), cb)
  end,
}

return tmpl
