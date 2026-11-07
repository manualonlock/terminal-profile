-- Centralized keybindings configuration
-- Grouped by plugin/category

local M = {}

function M.setup()
	-- ============================================
	-- General
	-- ============================================
	-- Disable space default behavior (leader key)
	vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

	-- Exit insert mode
	vim.keymap.set("i", "jj", "<Esc>", { silent = true })

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
		vim.keymap.set("n", "<leader>fb", telescope_builtin.buffers, { desc = "Telescope buffers" })
		vim.keymap.set("n", "<leader>fr", telescope_builtin.oldfiles, { desc = "Telescope recent files" })
		vim.keymap.set("n", "<leader>fh", telescope_builtin.help_tags, { desc = "Telescope help" })
	end

	-- ============================================
	-- Window navigation
	-- ============================================
	vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
	vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to below window" })
	vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to above window" })
	vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

	-- ============================================
	-- Function/class navigation
	-- ============================================
	-- <leader>j / <leader>k (next/previous function) live in plugins/treesitter-textobjects.lua

	-- ============================================
	-- Diffview
	-- ============================================
	vim.keymap.set("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "Open diff view" })
	vim.keymap.set("n", "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", { desc = "File history" })
	vim.keymap.set("n", "<leader>gq", "<cmd>DiffviewClose<cr>", { desc = "Close diff view" })

	-- ============================================
	-- Neo-tree
	-- ============================================
	vim.keymap.set("n", "<leader>b", "<cmd>Neotree toggle<cr>", { desc = "Open file explorer" })

	-- Clear search highlight
	vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>", { silent = true })
end

return M
