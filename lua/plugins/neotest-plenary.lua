return {
	"nvim-neotest/neotest-plenary",
	config = function()
		require("neotest").setup({
			adapters = {
				require("neotest-plenary"),
			},
		})
	end,
}
