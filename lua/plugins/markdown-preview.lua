return {
	"iamcco/markdown-preview.nvim",
	-- cmd-only: loading on every markdown buffer is wasted work when the
	-- preview is never opened; the commands trigger the load instead.
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	build = function()
		vim.fn["mkdp#util#install"]()
	end,
}
