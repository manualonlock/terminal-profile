-- LSP: Mason installs servers, mason-lspconfig (v2) enables them via vim.lsp.enable(),
-- nvim-lspconfig ships the server configs, blink.cmp provides completion.
local servers = { "pyright", "ts_ls", "gopls", "lua_ls", "bashls" }

return {
	{
		"mason-org/mason.nvim",
		build = ":MasonUpdate",
		opts = {
			ui = {
				border = "rounded",
				icons = { package_installed = "✓", package_pending = "➜", package_uninstalled = "✗" },
			},
		},
	},

	{
		"mason-org/mason-lspconfig.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
			"saghen/blink.cmp",
		},
		config = function()
			-- Completion capabilities for every server
			vim.lsp.config("*", {
				capabilities = require("blink.cmp").get_lsp_capabilities(),
			})

			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						completion = { callSnippet = "Replace" },
						diagnostics = { globals = { "vim" } },
					},
				},
			})

			require("mason-lspconfig").setup({
				ensure_installed = servers,
				-- stylua is a formatter, not something we want running as an LSP
				automatic_enable = { exclude = { "stylua" } },
			})

			-- Diagnostics: show them inline (Neovim 0.11 hides virtual text by default)
			vim.diagnostic.config({
				severity_sort = true,
				underline = true,
				update_in_insert = false,
				virtual_text = { spacing = 2, source = "if_many", prefix = "●" },
				float = { border = "rounded", source = "if_many" },
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "",
						[vim.diagnostic.severity.WARN] = "",
						[vim.diagnostic.severity.INFO] = "",
						[vim.diagnostic.severity.HINT] = "󰌵",
					},
				},
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspKeys", { clear = true }),
				callback = function(args)
					local map = function(lhs, rhs, desc)
						vim.keymap.set("n", lhs, rhs, { buffer = args.buf, desc = "LSP: " .. desc })
					end
					local tb = require("telescope.builtin")
					map("gd", tb.lsp_definitions, "Go to definition")
					map("gD", vim.lsp.buf.declaration, "Go to declaration")
					map("gi", tb.lsp_implementations, "Go to implementation")
					map("gy", tb.lsp_type_definitions, "Go to type definition")
					-- `grr`, not `gr`: a buffer-local `gr` would make Neovim 0.11's
					-- built-in gr* maps (grn, gra, gri) wait for timeoutlen
					map("grr", tb.lsp_references, "References")
					map("K", function()
						vim.lsp.buf.hover({ border = "rounded" })
					end, "Hover docs")
					map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
					map("<leader>ca", vim.lsp.buf.code_action, "Code action")
					map("<leader>ci", vim.lsp.buf.incoming_calls, "Incoming calls")
					map("<leader>co", vim.lsp.buf.outgoing_calls, "Outgoing calls")
					map("<leader>cf", function()
						vim.lsp.buf.format({ async = true })
					end, "Format buffer")
					map("<leader>e", vim.diagnostic.open_float, "Line diagnostics")
					map("<leader>fs", tb.lsp_document_symbols, "Document symbols")
					map("<leader>fd", tb.diagnostics, "Workspace diagnostics")

					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if client and client:supports_method("textDocument/inlayHint") then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = args.buf }))
						end, "Toggle inlay hints")
					end
				end,
			})
		end,
	},

	-- Completion
	{
		"saghen/blink.cmp",
		version = "1.*", -- release tag => prebuilt fuzzy-matcher binary
		event = { "InsertEnter", "CmdlineEnter" },
		dependencies = { "rafamadriz/friendly-snippets" },
		opts = {
			keymap = { preset = "default" }, -- <C-y> accept, <C-n>/<C-p> navigate, <C-space> open
			appearance = { nerd_font_variant = "mono" },
			completion = {
				menu = { border = "rounded" },
				documentation = { auto_show = true, auto_show_delay_ms = 200, window = { border = "rounded" } },
				ghost_text = { enabled = true },
			},
			signature = { enabled = true, window = { border = "rounded" } },
			sources = {
				default = { "lazydev", "lsp", "path", "snippets", "buffer" },
				providers = {
					lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
				},
			},
			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
	},

	-- Proper `vim.*` completion and types when editing this config
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = { { path = "${3rd}/luv/library", words = { "vim%.uv" } } },
		},
	},
}
