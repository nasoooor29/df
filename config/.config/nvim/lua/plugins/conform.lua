return { -- Autoformat
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>f",
			function()
				require("conform").format({ async = true, lsp_format = "fallback" })
			end,
			mode = "",
			desc = "conform: format buffer",
		},
	},
	opts = {
		notify_on_error = false,
		format_on_save = function(bufnr)
			-- Disable "format_on_save lsp_fallback" for languages that don't
			-- have a well standardized coding style. You can add additional
			-- languages here or re-enable it for the disabled ones.
			local disable_filetypes = { c = true, cpp = true }
			local lsp_format_opt
			if disable_filetypes[vim.bo[bufnr].filetype] then
				lsp_format_opt = "never"
			else
				lsp_format_opt = "fallback"
			end
			return {
				timeout_ms = 2500,
				lsp_format = lsp_format_opt,
			}
		end,
		formatters_by_ft = {
			lua = { "stylua" },
			astro = { "prettierd", "prettier", stop_after_first = true },
			javascriptreact = { "prettier" },
			typescriptreact = { "prettier" },
			javascript = { "prettier" },
			json = { "prettier" },
			jsonc = { "prettier" },
			html = { "prettier" },
			htmlangular = { "prettier" },
			typescript = { "prettier" },
			graphql = { "prettier" },
			go = { "goimports", "gofumpt" },
			bash = { "shfmt" },
			zsh = { "shfmt" },
			sh = { "shfmt" },
			php = { "php", "easy-coding-standard" },
			sql = { "sql_formatter" },
			yaml = { "prettier" },
		},

		formatters = {
			php = {
				command = "php-cs-fixer",
				args = {
					"fix",
					"--rules=@PSR12", -- Formatting preset. Other presets are available, see the php-cs-fixer docs.
					"$FILENAME",
				},
				env = {
					PHP_CS_FIXER_IGNORE_ENV = "1",
				},
				stdin = false,
			},
		},
	},
}
