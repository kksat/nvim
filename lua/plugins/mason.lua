return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"bashls",
					"ansiblels",
					"bicep",
					"cmake",
					"neocmake",
					"dockerls",
					"lua_ls",
					"marksman",
					"pylsp",
					"yamlls",
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
	},
}
