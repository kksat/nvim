return {
	"akinsho/toggleterm.nvim",
	config = function()
		require("toggleterm").setup({
			direction = "float",
			float_opts = {
				-- The border key is *almost* the same as 'nvim_open_win'
				-- see :h nvim_open_win for details on borders however
				-- the 'curved' border is a custom border type
				-- not natively supported but implemented in this plugin.
				border = "double",
				-- like `size`, width, height, row, and col can be a number or function which is passed the current terminal
				width = 100,
				height = 100,
				-- row = <value>,
				-- col = <value>,
				-- winblend = 3,
				-- zindex = <value>,
				title_pos = "center",
			},
		})
		local Terminal = require("toggleterm.terminal").Terminal
		local lazygit = Terminal:new({ cmd = "lazydocker", hidden = true })

		function _lazydocker_toggle()
			lazygit:toggle()
		end

		vim.api.nvim_set_keymap(
			"n",
			"<leader>Dl",
			"<cmd>lua _lazydocker_toggle()<CR>",
			{ desc = "Lazydocker", noremap = true, silent = true }
		)
	end,
}
