return {
	"Vigemus/iron.nvim",
	lazy = true,
	config = function()
		require("iron.core").setup({
			config = {
				scratch_repl = true,
				-- Your repl definitions come here
				repl_definition = {
					sh = {
						command = { "zsh" },
					},
				},
				python = {
					command = { "python" },
				},
			},
		})
		vim.keymap.set("n", "<space>rs", "<cmd>IronRepl<cr>", { desc = "Start REPL" })
		vim.keymap.set("n", "<space>rr", "<cmd>IronRestart<cr>", { desc = "Restart REPL" })
		vim.keymap.set("n", "<space>rf", "<cmd>IronFocus<cr>", { desc = "Focus REPL" })
		vim.keymap.set("n", "<space>rh", "<cmd>IronHide<cr>", { desc = "Hide REPL" })
	end,
}
