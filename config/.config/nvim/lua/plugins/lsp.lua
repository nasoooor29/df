return {
	-- Main LSP Configuration
	"saghen/blink.cmp",
	dependencies = { -- Automatically install LSPs and related tools to stdpath for Neovim
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"neovim/nvim-lspconfig",
	},
	config = function()
		local servers = require("servers")
		require("mason").setup()
		---@diagnostic disable-next-line: unused-local
		local on_attach = function(client, bufnr)
			local bufopts = { noremap = true, silent = true, buffer = bufnr }
			local t = require("telescope.builtin")
			vim.keymap.set("n", "gd", t.lsp_definitions, bufopts)
			vim.keymap.set("n", "gi", t.lsp_implementations, bufopts)
			vim.keymap.set("n", "gr", t.lsp_references, bufopts) -- added for references
			vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
			vim.keymap.set("n", "[d", function()
				vim.diagnostic.jump({ count = -1, float = true })
			end, bufopts)
			vim.keymap.set("n", "]d", function()
				vim.diagnostic.jump({ count = 1, float = true })
			end, bufopts)
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, bufopts)
			vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { noremap = true, silent = true })
		end

		local capabilities = {
			textDocument = {
				foldingRange = {
					dynamicRegistration = false,
					lineFoldingOnly = true,
				},
			},
		}

		capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

		for name, config in pairs(servers) do
			vim.lsp.enable(name)
			config = config or {}
			config.on_attach = on_attach
			config.capabilities = capabilities
			vim.lsp.config(name, config)
		end

		require("mason-lspconfig").setup({
			ensure_installed = vim.tbl_keys(servers),
			automatic_installation = true,
		})
	end,
}
