-- Popup listing available keymaps after pressing <leader> (or any prefix)
return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		preset = "modern",
		spec = {
			{ "<leader>f", group = "find" },
			{ "<leader>g", group = "git" },
			{ "<leader>c", group = "code" },
			{ "<leader>t", group = "toggle" },
		},
	},
}
