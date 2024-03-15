return {
	"neovim/nvim-lspconfig",
	opts = {
		servers = {
			ansiblels = {},
		},
	},
	config = function()
		local bicep_lsp_bin = "/usr/local/bin/bicep-langserver/Bicep.LangServer.dll"
		require("lspconfig").bicep.setup({
			cmd = { "dotnet", bicep_lsp_bin },
		})
	end,
}
