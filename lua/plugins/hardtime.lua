return {
	"m4xshen/hardtime.nvim",
	dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
	opts = {},
	config = function()
		require("hardtime").setup()
		vim.api.nvim_set_keymap(
			"n",
			"<leader>uh",
			"<cmd>Hardtime toggle<cr>",
			{ noremap = false, silent = true, desc = "Hardtime toggle" }
		)
	end,
}
