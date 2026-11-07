-- Syntax-aware jumps between functions/classes (works in any language with a parser)
return {
	"nvim-treesitter/nvim-treesitter-textobjects",
	branch = "main",
	event = { "BufReadPost", "BufNewFile" },
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	config = function()
		require("nvim-treesitter-textobjects").setup({ move = { set_jumps = true } })
		local move = require("nvim-treesitter-textobjects.move")
		local function map(lhs, fn, query, desc)
			vim.keymap.set({ "n", "x", "o" }, lhs, function()
				fn(query, "textobjects")
			end, { desc = desc })
		end
		map("<leader>j", move.goto_next_start, "@function.outer", "Next function")
		map("<leader>k", move.goto_previous_start, "@function.outer", "Previous function")
		map("]f", move.goto_next_start, "@function.outer", "Next function")
		map("[f", move.goto_previous_start, "@function.outer", "Previous function")
		map("]c", move.goto_next_start, "@class.outer", "Next class")
		map("[c", move.goto_previous_start, "@class.outer", "Previous class")
	end,
}
