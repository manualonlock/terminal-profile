-- Auto-close brackets and quotes: ( → (), " → ""
return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	opts = {
		check_ts = true, -- use treesitter: don't pair inside strings/comments
	},
}
