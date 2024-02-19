return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{
			"SmiteshP/nvim-navbuddy",
			dependencies = {
				"SmiteshP/nvim-navic",
				"MunifTanjim/nui.nvim",
			},
			opts = { lsp = { auto_attach = true } },
			-- config = function()
			-- 	vim.api.nvim_set_keymap(
			-- 		"n",
			-- 		"<leader>cb",
			-- 		"<cmd>Navbuddy<cr>",
			-- 		{ noremap = false, silent = true, desc = "NavBuddy" }
			-- 	)
			-- end,
		},
	},
}
