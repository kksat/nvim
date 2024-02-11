return {
	"aaronhallaert/advanced-git-search.nvim",
	config = function()
		-- optional: setup telescope before loading the extension
		require("telescope").setup({
			-- move this to the place where you call the telescope setup function
			extensions = {
				advanced_git_search = {
					-- See Config    -- fugitive or diffview
					diff_plugin = "fugitive",
					-- customize git in previewer
					-- e.g. flags such as { "--no-pager" }, or { "-c", "delta.side-by-side=false" }
					git_flags = {},
					-- customize git diff in previewer
					-- e.g. flags such as { "--raw" }
					git_diff_flags = {},
					-- Show builtin git pickers when executing "show_custom_functions" or :AdvancedGitSearch
					show_builtin_git_pickers = false,
					entry_default_author_or_date = "author", -- one of "author" or "date"

					-- Telescope layout setup
					telescope_theme = {
						function_name_1 = {
							-- Theme options
						},
						function_name_2 = "dropdown",
						-- e.g. realistic example
						show_custom_functions = {
							layout_config = { width = 0.4, height = 0.4 },
						},
					},
				},
			},
		})

		require("telescope").load_extension("advanced_git_search")
		vim.api.nvim_set_keymap(
			"n",
			"<leader>gl",
			"<cmd>AdvancedGitSearch search_log_content<cr>",
			{ noremap = true, silent = true, desc = "Search git log content (advanced)" }
		)
		vim.api.nvim_set_keymap(
			"n",
			"<leader>gc",
			"<cmd>AdvancedGitSearch diff_commit_file<cr>",
			{ noremap = false, silent = true, desc = "Search file commits (advanced)" }
		)
		vim.api.nvim_set_keymap(
			"v",
			"<leader>gc",
			"<cmd>'<,'>AdvancedGitSearch diff_commit_line<cr>",
			{ noremap = false, silent = true, desc = "Search file commits (advanced)" }
		)
		-- vim.api.nvim_set_keymap(
		-- 	"n",
		-- 	"<leader>gc",
		-- 	'<cmd>lua require("telescope").extensions.advanced_git_search.git_commits()<cr>',
		-- 	{ noremap = true, silent = true }
		-- )
		-- vim.api.nvim_set_keymap(
		-- 	"n",
		-- 	"<leader>gs",
		-- 	'<cmd>lua require("telescope").extensions.advanced_git_search.git_status()<cr>',
		-- 	{ noremap = true, silent = true }
		-- )
	end,
	dependencies = {
		"nvim-telescope/telescope.nvim",
		-- to show diff splits and open commits in browser
		"tpope/vim-fugitive",
		-- to open commits in browser with fugitive
		"tpope/vim-rhubarb",
		-- optional: to replace the diff from fugitive with diffview.nvim
		-- (fugitive is still needed to open in browser)
		-- "sindrets/diffview.nvim",
	},
}
-- configured  key mapppings for advanced git search
