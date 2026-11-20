return {
	"ellisonleao/glow.nvim",
	cmd = "Glow",
	opts = {
		-- Keep a tiny margin so the floating window and its border fit on screen.
		style = vim.fn.stdpath("config") .. "/glow-style.json",
		width = 9999,
		height = 9999,
		width_ratio = 0.98,
		height_ratio = 0.90,
		border = "rounded",
	},
}
