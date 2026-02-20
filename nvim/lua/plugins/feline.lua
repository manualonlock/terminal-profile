return {
	"feline-nvim/feline.nvim",
	config = function()
		local feline = require("feline")
		local vi_mode = require("feline.providers.vi_mode")

		local components = {
			active = {
				{
					{
						provider = "vi_mode",
						hl = function()
							return {
								name = vi_mode.get_mode_highlight_name(),
								fg = vi_mode.get_mode_color(),
								style = "bold",
							}
						end,
						right_sep = " ",
					},
					{
						provider = "file_info",
						hl = { style = "bold" },
						right_sep = " ",
					},
					{
						provider = "git_branch",
						right_sep = " ",
					},
				},
				{
					{
						provider = "diagnostic_errors",
						hl = { fg = "red" },
					},
					{
						provider = "diagnostic_warnings",
						hl = { fg = "yellow" },
					},
					{
						provider = "diagnostic_hints",
						hl = { fg = "cyan" },
					},
					{
						provider = "diagnostic_info",
						hl = { fg = "skyblue" },
					},
				},
				{
					{
						provider = "file_encoding",
						right_sep = " ",
					},
					{
						provider = "position",
						right_sep = " ",
					},
					{
						provider = "line_percentage",
					},
				},
			},
			inactive = {
				{
					{
						provider = "file_info",
						hl = { fg = "gray" },
					},
				},
			},
		}

		feline.setup({
			components = components,
		})
	end,
}
