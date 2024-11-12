return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{
			"SmiteshP/nvim-navbuddy",
			dependencies = {
        "neovim/nvim-lspconfig",
        "SmiteshP/nvim-navic",
        "MunifTanjim/nui.nvim",
			},
			opts = {
				lsp = { auto_attach = true },
				window = {
					border = "single", -- "rounded", "double", "solid", "none"
					size = { height = "100%", width = "100%" },
					position = { row = "100%", col = "0%" },
					sections = {
						left = {
							size = "20%",
							border = nil,
						},
						mid = {
							size = "30%",
							border = nil,
						},
						right = {
							border = nil,
							preview = "leaf",
						},
					},
				},
			},
			keys = {
				{
					"<leader>cb",
					"<cmd>Navbuddy<cr>",
					desc = "NavBuddy",
				},
			},
		},
	},
}
