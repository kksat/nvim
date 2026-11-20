-- zals — Zig Ansible Language Server, configured through the zals.nvim
-- plugin (https://github.com/kksat/zals.nvim): Ansible/Jinja filetype
-- detection, LSP defaults, and interactive commands (:ZalsCreateRole, ...).
--
-- The plugin registers the config but does not enable it; LazyVim enables
-- zals through its `servers` table instead. The server binary is installed
-- separately (brew/pip), not via Mason.
--
-- zals is the only LSP for Ansible buffers:
--   * ansiblels is disabled — requires that mason-lspconfig.setup() is not
--     called before LazyVim configures it (see lua/plugins/mason.lua)
--   * yamlls is restricted to non-Ansible YAML filetypes
--
-- Verify with :LspInfo while a playbook is open.
return {
  {
    "kksat/zals.nvim",
    main = "zals",
    lazy = false,
    opts = { enabled = false }, -- LazyVim enables it below
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        zals = { mason = false }, -- install the binary separately
        ansiblels = { enabled = false },
        yamlls = {
          filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab", "yaml.helm-values" },
        },
      },
    },
  },
}
