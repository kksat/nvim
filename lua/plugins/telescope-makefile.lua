return {
	"sopa0/telescope-makefile",
	dependencies = {
		"telescope.nvim",
		"akinsho/toggleterm.nvim",
		config = function()
			require("telescope").load_extension("make")
		end,
	},
}
