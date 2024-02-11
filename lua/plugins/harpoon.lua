return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local harpoon = require("harpoon")
		---@diagnostic disable-next-line: missing-parameter
		harpoon.setup()

		vim.keymap.set("n", "<leader>ha", function()
			harpoon:list():append()
		end, { desc = "Harpoon add mark" })

		vim.keymap.set("n", "<leader>hl", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, { desc = "Harpoon list" })
	end,
}
