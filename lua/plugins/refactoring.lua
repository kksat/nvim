-- SPDX-FileCopyrightText: 2024 Kirill Satarin (@kksat) <22549266+kksat@users.noreply.github.com>
-- SPDX-License-Identifier: MIT

return {
	"ThePrimeagen/refactoring.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		require("refactoring").setup({
			show_success_message = true,
		})

		vim.keymap.set("n", "<leader>cp", function()
			---@diagnostic disable-next-line: missing-parameter
			require("refactoring").select_refactor()
		end, { desc = "Primeagen Refactoring" })
	end,
}
