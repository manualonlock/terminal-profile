-- nvim-treesitter `main` branch: it only installs parsers; highlighting is started
-- by Neovim itself. Compiling parsers needs the `tree-sitter` CLI (brew install tree-sitter-cli).
local parsers = {
	"bash", "css", "diff", "dockerfile", "go", "gomod", "html", "java", "javascript", "json",
	"lua", "luadoc", "markdown", "markdown_inline", "python", "query", "regex", "rust", "sql",
	"toml", "tsx", "typescript", "vim", "vimdoc", "xml", "yaml",
}

return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		local ts = require("nvim-treesitter")
		if vim.fn.executable("tree-sitter") == 1 then
			local installed = ts.get_installed()
			local missing = vim.tbl_filter(function(p)
				return not vim.list_contains(installed, p)
			end, parsers)
			if #missing > 0 then
				ts.install(missing)
			end
		end

		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true }),
			callback = function(args)
				if pcall(vim.treesitter.start, args.buf) then
					vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end
			end,
		})
	end,
}
