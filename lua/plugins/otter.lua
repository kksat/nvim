return {
	"jmbuhr/otter.nvim",
	lazy = true,
	config = function()
		local cmp = require("cmp")
		cmp.setup({
			sources = {
				{ name = "otter" },
			},
		})
	end,
}
