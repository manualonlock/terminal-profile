local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.g.mapleader = " "
vim.cmd("set number")
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)
local  plugins = {
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },
	{
	    'nvim-telescope/telescope.nvim', version = '*',
	    dependencies = {
		'nvim-lua/plenary.nvim',
		{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
	    }
	},
	{
	  'nvim-treesitter/nvim-treesitter',
	  lazy = false,
	  build = ':TSUpdate'
	}
} 
local  opts = {}
require("lazy").setup(plugins, opts) 
require("catppuccin").setup()
vim.cmd.colorscheme("catppuccin-latte")
local builtin = require('telescope.builtin')
require('telescope').setup({
  defaults = {
    file_ignore_patterns = { 
      "%.git/", 
      "node_modules" 
    },
  },
  pickers = {
    find_files = {
      hidden = true, 
    },
  },
})
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
require'nvim-treesitter'.install { 'rust', 'javascript', 'zig' }

