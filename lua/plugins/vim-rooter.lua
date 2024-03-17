return {
	"airblade/vim-rooter",
	enabled = false,
	config = function()
		vim.g.rooter_patterns = { ".git" }
	end,
}
