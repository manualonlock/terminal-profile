return {
	"nvim-telescope/telescope.nvim",
	version = "*",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	config = function()
		require("telescope").setup({
			defaults = {
				file_ignore_patterns = {
					"%.git/",
					"node_modules",
				},
			},
			pickers = {
				find_files = {
					hidden = true,
				},
			},
		})
	end,
}
