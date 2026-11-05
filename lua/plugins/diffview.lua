return {
	"sindrets/diffview.nvim",
	cmd = {
		"DiffviewOpen",
		"DiffviewClose",
		"DiffviewFileHistory",
		"DiffviewToggleFiles",
		"DiffviewFocusFiles",
		"DiffviewRefresh",
		"DiffviewLog",
	},
	keys = {
		{
			"<leader>gd",
			"<cmd>DiffviewOpen<CR>",
			desc = "Open Diffview",
		},
		{
			"<leader>gt",
			"<cmd>DiffviewFileHistory %<CR>",
			desc = "Open Diffview File History",
		},
	},
}
