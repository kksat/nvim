return {
	"CopilotC-Nvim/CopilotChat.nvim",
	branch = "canary",
	dependencies = {
		{ "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
		{ "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
	},
	opts = {
		debug = false,
		-- See Configuration section for rest
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			require("which-key").register({
				a = {
					name = "ChatGPT",
					h = { "<cmd>CopilotChatToggle<CR>", "GitHub copilot Chat" },
				},
			}, { prefix = "<leader>" }),
		},
	},
}
