return {
	"nvim-telescope/telescope.nvim",
	branch = "master",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		vim.keymap.set(
			"n",
			"<leader>b/",
			"<cmd>Telescope current_buffer_fuzzy_find<cr>",
			{ desc = "Current buffer fuzzy find" }
		)
	end,
}
