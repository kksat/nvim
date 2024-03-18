return {
	"ThePrimeagen/git-worktree.nvim",
	lazy = true,
	dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
	keys = {
		{
			"<leader>gw",
			"<cmd>lua require('telescope').extensions.git_worktree.git_worktree()<cr>",
			desc = "Git Worktree",
		},
		{
			"<leader>gW",
			"<cmd>lua require('telescope').extensions.git_worktree.create_git_worktree()<cr>",
			desc = "Create Git worktree",
		},
	},
	config = function()
		require("git-worktree").setup()
		require("telescope").load_extension("git_worktree")
	end,
}
