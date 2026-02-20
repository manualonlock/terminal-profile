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
	vim.keymap.set("n", "<leader>j", "]m", { remap = true, desc = "Next function/method" })
	vim.keymap.set("n", "<leader>k", "[m", { remap = true, desc = "Previous function/method" })

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
	require("neo-tree").setup({
	  filesystem = {
	    filtered_items = {
	      hide_dotfiles = false,
	    },
	  },
	  window = {
	    mappings = {
	      ["o"] = { "open", nowait = true },
      ["<leader>y"] = function(state)
        local node = state.tree:get_node()
        local name = node.name
        vim.fn.setreg("+", name)
        vim.notify("Copied: " .. name)
      end,
      ["<leader>Y"] = function(state)
        local node = state.tree:get_node()
        local path = node:get_id()
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
	})

end

return M
