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
		require("telescope").setup({
			defaults = {
				mappings = {
					n = {
						["<c-d>"] = require("telescope.actions").delete_buffer,
					},
					i = {
						["<C-h>"] = "which_key",
						["<c-d>"] = require("telescope.actions").delete_buffer,
					},
				},
			},
		})
	end,
}
