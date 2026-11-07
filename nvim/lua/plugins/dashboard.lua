-- Minimal start screen: one small line on top, muted grey items, a red accent,
-- and a slightly bleak one-liner at the bottom.
local quotes = {
	"it worked yesterday.",
	"nothing compiles forever.",
	"the bug is not in the code. it is in you.",
	"ship it. regret it later.",
	"every abstraction leaks eventually.",
	"you will rewrite this in six months.",
	"there is no such thing as a quick fix.",
	"the tests pass. that proves nothing.",
	"legacy code is just code that survived.",
	"close the laptop. it will still be broken tomorrow.",
}

local function set_highlights()
	local hl = vim.api.nvim_set_hl
	hl(0, "DashboardHeader", { fg = "#585b70", bold = true })
	hl(0, "DashboardIcon", { fg = "#6c7086" })
	hl(0, "DashboardDesc", { fg = "#a6adc8" })
	hl(0, "DashboardKey", { fg = "#f38ba8", bold = true })
	hl(0, "DashboardFooter", { fg = "#585b70", italic = true })
end

return {
	"nvimdev/dashboard-nvim",
	event = "VimEnter",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		set_highlights()
		vim.api.nvim_create_autocmd("ColorScheme", {
			group = vim.api.nvim_create_augroup("UserDashboardColors", { clear = true }),
			callback = set_highlights,
		})

		math.randomseed(os.time())
		local quote = quotes[math.random(#quotes)]

		local function item(icon, desc, key, action)
			return { icon = icon .. "  ", desc = desc, key = key, key_format = "  %s", action = action }
		end

		require("dashboard").setup({
			theme = "doom",
			hide = { statusline = true, tabline = true },
			config = {
				vertical_center = true,
				header = { "n e o v i m", "", "" },
				center = {
					item("", "find file", "f", "Telescope find_files"),
					item("", "recent", "r", "Telescope oldfiles"),
					item("", "grep", "g", "Telescope live_grep"),
					item("", "explorer", "b", "Neotree toggle"),
					item("", "diff", "d", "DiffviewOpen"),
					item("", "quit", "q", "qa"),
				},
				footer = function()
					local stats = require("lazy").stats()
					return {
						"",
						"",
						quote,
						"",
						string.format("%d plugins · %.0f ms", stats.loaded, stats.startuptime),
					}
				end,
			},
		})
	end,
}
