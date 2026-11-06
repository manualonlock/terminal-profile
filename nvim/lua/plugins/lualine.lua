-- Statusline (replaces the archived feline.nvim)
return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		options = {
			theme = "catppuccin",
			globalstatus = true,
			component_separators = "",
			section_separators = { left = "", right = "" },
			disabled_filetypes = { statusline = { "dashboard" } },
		},
		sections = {
			lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
			lualine_b = { "branch", "diff" },
			lualine_c = { { "filename", path = 1 }, "diagnostics" },
			lualine_x = {
				{
					function()
						local names = vim.tbl_map(function(c)
							return c.name
						end, vim.lsp.get_clients({ bufnr = 0 }))
						return #names > 0 and (" " .. table.concat(names, ", ")) or ""
					end,
				},
				"filetype",
			},
			lualine_y = { "progress" },
			lualine_z = { { "location", separator = { right = "" }, left_padding = 2 } },
		},
		extensions = { "neo-tree", "lazy", "mason" },
	},
}
