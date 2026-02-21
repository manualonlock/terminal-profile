return {
	"nvimdev/dashboard-nvim",
	event = "VimEnter",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local header_ns = vim.api.nvim_create_namespace("dashboard_header_colors")

		vim.api.nvim_set_hl(0, "DashboardHeaderRed", { fg = "#E63946", bold = true })
		vim.api.nvim_set_hl(0, "DashboardHeaderWhite", { fg = "#F1F5F9", bold = true })
		vim.api.nvim_set_hl(0, "DashboardHeaderBlue", { fg = "#1D4ED8", bold = true })

		vim.api.nvim_create_augroup("DashboardHeaderColors", { clear = true })
		vim.api.nvim_create_autocmd("User", {
			pattern = "DashboardLoaded",
			group = "DashboardHeaderColors",
			callback = function()
				local buf = vim.api.nvim_get_current_buf()
				if vim.bo[buf].filetype ~= "dashboard" then
					return
				end

				local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
				vim.api.nvim_buf_clear_namespace(buf, header_ns, 0, -1)

				local in_header = false
				for row, line in ipairs(lines) do
					if line:match("%S") then
						in_header = true
						local first = line:find("%S") - 1
						local last = line:match(".*()%S")
						local width = last - first
						local third = math.max(1, math.floor(width / 3))
						local red_end = first + third
						local white_end = first + (third * 2)

						vim.api.nvim_buf_add_highlight(buf, header_ns, "DashboardHeaderRed", row - 1, first, red_end)
						vim.api.nvim_buf_add_highlight(
							buf,
							header_ns,
							"DashboardHeaderWhite",
							row - 1,
							red_end,
							white_end
						)
						vim.api.nvim_buf_add_highlight(buf, header_ns, "DashboardHeaderBlue", row - 1, white_end, -1)

						local title_col = line:find("N E O V I M", 1, true)
						if title_col then
							vim.api.nvim_buf_add_highlight(
								buf,
								header_ns,
								"DashboardHeaderBlue",
								row - 1,
								title_col - 1,
								title_col
							)
						end
					elseif in_header then
						break
					end
				end
			end,
		})

		require("dashboard").setup({
			theme = "doom",
			config = {
				center = {
					{
						icon = "  ",
						desc = "Find file",
						key = "f",
						action = "Telescope find_files",
					},
					{
						icon = "󰱼  ",
						desc = "Live grep",
						key = "g",
						action = "Telescope live_grep",
					},
					{
						icon = "󰚰  ",
						desc = "Open explorer",
						key = "b",
						action = "Neotree toggle",
					},
					{
						icon = "󰅙  ",
						desc = "Quit",
						key = "q",
						action = "qa",
					},
				},
				header = vim.split(
					[[
=================     ===============     ===============   ========  ========
\\ . . . . . . .\\   //. . . . . . .\\   //. . . . . . .\\  \\. . .\\// . . //
||. . ._____. . .|| ||. . ._____. . .|| ||. . ._____. . .|| || . . .\/ . . .||
|| . .||   ||. . || || . .||   ||. . || || . .||   ||. . || ||. . . . . . . ||
||. . ||   || . .|| ||. . ||   || . .|| ||. . ||   || . .|| || . | . . . . .||
|| . .||   ||. _-|| ||-_ .||   ||. . || || . .||   ||. _-|| ||-_.|\ . . . . ||
||. . ||   ||-'  || ||  `-||   || . .|| ||. . ||   ||-'  || ||  `|\_ . .|. .||
|| . _||   ||    || ||    ||   ||_ . || || . _||   ||    || ||   |\ `-_/| . ||
||_-' ||  .|/    || ||    \|.  || `-_|| ||_-' ||  .|/    || ||   | \  / |-_.||
||    ||_-'      || ||      `-_||    || ||    ||_-'      || ||   | \  / |  `||
||    `'         || ||         `'    || ||    `'         || ||   | \  / |   ||
||            .===' `===.         .==='.`===.         .===' /==. |  \/  |   ||
||         .=='   \_|-_ `===. .==='   _|_   `===. .===' _-|/   `==  \/  |   ||
||      .=='    _-'    `-_  `='    _-'   `-_    `='  _-'   `-_  /|  \/  |   ||
||   .=='    _-'          '-__\._-'         '-_./__-'         `' |. /|  |   ||
||.=='    _-'                                                     `' |  /==.||
=='    _-'                        N E O V I M                         \/   `==
\   _-'                                                                `-_   /
 `''                                                                      ```
					]],
					"\n",
					{ trimempty = true }
				),

			},
		})
	end,
}
