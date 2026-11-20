-- Mason specs. Both plugins stay lazy-loaded:
--   * mason.nvim: lazy via cmd = "Mason" / <leader>cm from LazyVim's spec
--   * mason-lspconfig.nvim: lazy = true, so it only loads as a dependency of
--     nvim-lspconfig (event = BufReadPre/BufNewFile) instead of at startup.
--
-- Server installation is unchanged: LazyVim's nvim-lspconfig config calls
-- mason-lspconfig.setup() and merges opts.ensure_installed below, and
-- :LazyInstallAll (config/install-all.lua) preinstalls everything for fresh
-- setups.
return {
	{
		"mason-org/mason.nvim",
		-- use opts instead of a custom config so LazyVim's config (stylua/shfmt
		-- ensure_installed + install hooks) is kept
		opts = {},
	},
	{
		-- Do not call `mason-lspconfig.setup()` here. LazyVim calls it with the
		-- merged `opts.servers` and `automatic_enable.exclude`, which is what makes
		-- `enabled = false` on a server (e.g. `ansiblels` while testing `zals`)
		-- actually take effect. An early `setup()` auto-enables every installed
		-- server before LazyVim can exclude any of them.
		"mason-org/mason-lspconfig.nvim",
		lazy = true,
		opts = {
			ensure_installed = {
				"bashls",
				"ansiblels",
				"bicep",
				"dockerls",
				"lua_ls",
				"marksman",
				"yamlls",
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				-- Not provided by any enabled LazyVim extra, so declare it here to have
				-- LazyVim install it through mason-lspconfig.
				bicep = {},
			},
		},
	},
}
