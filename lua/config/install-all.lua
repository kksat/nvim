-- Preinstall everything LazyVim would otherwise download on first use, so a
-- freshly installed setup never installs anything when nvim is first started.
-- Invoked headlessly by the dotfiles install.sh:
--   nvim --headless "+LazyInstallAll" +qa
--
-- Covers:
--   * LSP servers (the merged server list LazyVim passes to
--     mason-lspconfig.setup(); mason-lspconfig skips its ensure_installed
--     processing when headless, so we read the list back and install it
--     ourselves)
--   * Mason tools (opts.ensure_installed of mason.nvim and its spec
--     fragments, e.g. the Go extra's delve)
--   * treesitter parsers (LazyVim installs missing opts.ensure_installed
--     parsers when nvim-treesitter loads, after ensuring tree-sitter-cli)
--
-- Blocks until everything is installed or the timeout is hit. Intended for
-- headless use; interactively it will freeze the UI while downloading.

local TIMEOUT_MS = 30 * 60 * 1000
-- Registry/parsers must stay quiet for this long before we report success,
-- so installs started slightly after our own (e.g. by mason.nvim's config)
-- are still picked up.
local IDLE_MS = 10 * 1000

local function wanted_packages()
  local map = require("mason-lspconfig.mappings").get_mason_map().lspconfig_to_package

  local wanted = {} ---@type table<string, boolean>
  for _, server in ipairs(require("mason-lspconfig.settings").current.ensure_installed or {}) do
    local pkg = map[server]
    if pkg then
      wanted[pkg] = true
    end
  end
  for _, tool in ipairs(LazyVim.opts("mason.nvim").ensure_installed or {}) do
    wanted[tool] = true
  end
  return vim.tbl_keys(wanted)
end

local function preinstall()
  -- Plugins are lazy-loaded; force-load what we need. Loading nvim-lspconfig
  -- also runs LazyVim's lsp setup, which computes the merged server list via
  -- mason-lspconfig.setup(). Loading nvim-treesitter starts LazyVim's
  -- automatic install of missing ensure_installed parsers.
  require("lazy").load({ plugins = { "nvim-lspconfig", "nvim-treesitter" } })

  local TS = require("nvim-treesitter")
  local mr = require("mason-registry")

  -- Install the configured LSP servers and Mason tools. The registry must be
  -- refreshed over the network before packages can be installed.
  local refresh_done = false
  mr.refresh(function()
    for _, pkg in ipairs(wanted_packages()) do
      local ok, p = pcall(mr.get_package, pkg)
      if ok and not p:is_installed() then
        p:install()
      end
    end
    refresh_done = true
  end)

  -- Wait until nothing is installing anywhere in the registry (this also
  -- covers installs started by mason.nvim's own config, like delve) and all
  -- wanted parsers are present.
  local wanted_parsers = LazyVim.opts("nvim-treesitter").ensure_installed or {}
  local idle_since ---@type number?
  local done = vim.wait(TIMEOUT_MS, function()
    if not refresh_done then
      idle_since = nil
      return false
    end
    local busy = false
    for _, name in ipairs(mr.get_all_package_names()) do
      local ok, p = pcall(mr.get_package, name)
      if ok and p:is_installing() then
        busy = true
        break
      end
    end
    if not busy then
      local installed_parsers = TS.get_installed("parsers")
      for _, lang in ipairs(wanted_parsers) do
        if not vim.tbl_contains(installed_parsers, lang) then
          busy = true
          break
        end
      end
    end
    if busy then
      idle_since = nil
      return false
    end
    idle_since = idle_since or vim.uv.now()
    return (vim.uv.now() - idle_since) > IDLE_MS
  end, 500)

  -- Report (shows up in install.sh logs / :messages).
  local failed_parsers = vim.tbl_filter(function(lang)
    return not vim.tbl_contains(TS.get_installed("parsers"), lang)
  end, wanted_parsers)
  local failed_pkgs = vim.tbl_filter(function(pkg)
    local ok, p = pcall(mr.get_package, pkg)
    return not (ok and p:is_installed())
  end, wanted_packages())
  if done and #failed_parsers == 0 and #failed_pkgs == 0 then
    print(("LazyInstallAll: ok (%d parsers, %d mason packages ensured)")
      :format(#wanted_parsers, #wanted_packages()))
  else
    print(("LazyInstallAll: INCOMPLETE (timed out: %s; missing parsers: %s; missing packages: %s)")
      :format(tostring(not done), table.concat(failed_parsers, ", "), table.concat(failed_pkgs, ", ")))
  end
end

vim.api.nvim_create_user_command("LazyInstallAll", function()
  preinstall()
end, {})
