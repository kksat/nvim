return {
	"kksat/pi-review-nvim",
	lazy = false,
	opts = {
		-- Default configuration (mirrors the plugin defaults):
		-- relative path, just line number and comment.
		include_symbol = false, -- no "(symbol `word`)"
		include_line_text = false, -- no "line: `text`"
		include_col = false, -- no column in the location
		batch_header = "Review comments ({count}):", -- {count} is replaced
	},
}
