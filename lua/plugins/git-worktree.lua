return {
	"ThePrimeagen/git-worktree.nvim",
	dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
	config = function()
		require("git-worktree").setup()
		require("telescope").load_extension("git_worktree")
		vim.keymap.set(
			"n",
			"<leader>gw",
			"<cmd>lua require('telescope').extensions.git_worktree.git_worktree()<cr>",
			{ desc = "Git Worktree" }
		)
		vim.keymap.set(
			"n",
			"<leader>gW",
			"<cmd>lua require('telescope').extensions.git_worktree.create_git_worktree()<cr>",
			{ desc = "Create Git worktree" }
		)
	end,
}
