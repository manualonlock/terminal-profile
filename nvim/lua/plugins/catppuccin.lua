return {
	"catppuccin/nvim",
	name = "catppuccin",
	lazy = false,
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			flavour = "mocha",
			-- Let Ghostty's translucent + blurred background show through
			transparent_background = true,
			float = { transparent = false, solid = false },
			term_colors = true,
			styles = {
				comments = { "italic" },
				keywords = { "italic" },
			},
			integrations = {
				blink_cmp = true,
				dashboard = true,
				diffview = true,
				gitsigns = true,
				mason = true,
				neotree = true,
				noice = true,
				notify = true,
				telescope = { enabled = true },
				treesitter = true,
				treesitter_context = true,
				which_key = true,
				native_lsp = {
					enabled = true,
					underlines = {
						errors = { "undercurl" },
						hints = { "undercurl" },
						warnings = { "undercurl" },
						information = { "undercurl" },
					},
				},
			},
		})
		vim.cmd.colorscheme("catppuccin")
	end,
}
