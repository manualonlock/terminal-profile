-- Centralized keybindings configuration
-- Grouped by plugin/category

local M = {}

function M.setup()
	-- ============================================
	-- General
	-- ============================================
	-- Disable space default behavior (leader key)
	vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

	-- System clipboard
	vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
	vim.keymap.set("n", "<leader>Y", '"+Y', { desc = "Yank line to system clipboard" })
	vim.keymap.set({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste from system clipboard" })
	vim.keymap.set({ "n", "v" }, "<leader>P", '"+P', { desc = "Paste before from system clipboard" })

	-- ============================================
	-- Telescope
	-- ============================================
	local telescope_ok, telescope_builtin = pcall(require, "telescope.builtin")
	if telescope_ok then
		vim.keymap.set("n", "<leader>ff", telescope_builtin.find_files, { desc = "Telescope find files" })
		vim.keymap.set("n", "<leader>fg", telescope_builtin.live_grep, { desc = "Telescope live grep" })
	end

	-- ============================================
	-- Neo-tree
	-- ============================================
	vim.keymap.set("n", "<leader>b", ":Neotree filesystem reveal left<CR>", { desc = "Open file explorer" })
end

return M
