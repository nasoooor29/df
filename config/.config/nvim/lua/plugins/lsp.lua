return {
	-- Main LSP Configuration
	"neovim/nvim-lspconfig",
	dependencies = { -- Automatically install LSPs and related tools to stdpath for Neovim
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"saghen/blink.cmp",
	},
	config = function()
		local servers = require("servers")
		require("mason").setup()
		---@diagnostic disable-next-line: unused-local
		local on_attach = function(client, bufnr)
			local bufopts = { noremap = true, silent = true, buffer = bufnr }
			local position_encoding = client and client.offset_encoding or "utf-16"

			if client.supports_method("textDocument/foldingRange") then
				vim.wo.foldmethod = "expr"
				vim.wo.foldexpr = "v:lua.vim.lsp.foldexpr()"
				vim.wo.foldlevel = 99
			end
			-- local t = require("telescope.builtin")

			-- vim.keymap.set("n", "gd", "<cmd>Pick lsp scope='definition'<cr>", bufopts)
			vim.keymap.set("n", "gd", function()
				local params = vim.lsp.util.make_position_params(0, position_encoding)
				vim.lsp.buf_request(0, "textDocument/definition", params, function(err, result)
					if err or not result or vim.tbl_isempty(result) then
						return
					end

					-- normalize to list
					if not vim.islist(result) then
						result = { result }
					end

					if #result == 1 then
						-- jump directly
						vim.lsp.util.show_document(result[1], position_encoding)
					else
						-- open mini.pick
						vim.cmd("Pick lsp scope='definition'")
					end
				end)
			end, bufopts)
			-- vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
			vim.keymap.set("n", "gr", "<cmd>Pick lsp scope='references'<cr>", bufopts) -- added for references
			vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
			vim.keymap.set("n", "[d", function()
				vim.diagnostic.jump({ count = -1, float = true })
			end, bufopts)
			vim.keymap.set("n", "]d", function()
				vim.diagnostic.jump({ count = 1, float = true })
			end, bufopts)
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, bufopts)
			vim.keymap.set("n", "<leader>e", function()
				vim.diagnostic.open_float({ border = "rounded" })
			end, { noremap = true, silent = true })
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

		local lsp_attach_group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true })
		vim.api.nvim_create_autocmd("LspAttach", {
			group = lsp_attach_group,
			callback = function(ev)
				local client = vim.lsp.get_client_by_id(ev.data.client_id)
				if not client then
					return
				end
				on_attach(client, ev.buf)
			end,
		})

		require("mason-lspconfig").setup({
			ensure_installed = vim.tbl_keys(servers),
			automatic_installation = true,
		})
	end,
}
