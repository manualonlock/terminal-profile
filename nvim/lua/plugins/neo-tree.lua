return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	lazy = false,
	opts = {
		close_if_last_window = true,
		popup_border_style = "rounded",
		filesystem = {
			filtered_items = { hide_dotfiles = false },
			follow_current_file = { enabled = true },
			use_libuv_file_watcher = true,
		},
		window = {
			mappings = {
				["o"] = { "open", nowait = true },
				["<leader>y"] = function(state)
					local name = state.tree:get_node().name
					vim.fn.setreg("+", name)
					vim.notify("Copied: " .. name)
				end,
				["<leader>Y"] = function(state)
					local path = state.tree:get_node():get_id()
					vim.fn.setreg("+", path)
					vim.notify("Copied: " .. path)
				end,
				["oc"] = "noop",
				["od"] = "noop",
				["og"] = "noop",
				["om"] = "noop",
				["on"] = "noop",
				["oo"] = "noop",
				["op"] = "noop",
				["os"] = "noop",
				["ot"] = "noop",
			},
		},
	},
}
