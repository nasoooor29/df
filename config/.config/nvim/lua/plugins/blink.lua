return {
	-- add blink.compat
	{
		"saghen/blink.compat",
		-- use the latest release, via version = '*', if you also use the latest release for blink.cmp
		version = "*",
		-- lazy.nvim will automatically load the plugin when it's required by blink.cmp
		lazy = true,
		-- make sure to set opts so that lazy.nvim calls blink.compat's setup
	},
	{
		"Saghen/blink.cmp",
		-- optional: provides snippets for the snippet source
		dependencies = {
			"rafamadriz/friendly-snippets",
			{ "L3MON4D3/LuaSnip", version = "v2.*" },
			{
				"stevearc/vim-vscode-snippets",
				config = function()
					require("luasnip.loaders.from_vscode").lazy_load()
					require("luasnip.loaders.from_vscode").lazy_load({ paths = "./my_snippets" })
				end,
			},
		},

		-- use a release tag to download pre-built binaries
		version = "1.*",
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			keymap = {
				preset = "enter",
				["<C-k>"] = { "select_prev", "fallback" },
				["<C-j>"] = { "select_next", "fallback" },

				["<A-k>"] = { "select_prev", "fallback" },
				["<A-j>"] = { "select_next", "fallback" },
				["<C-Space>"] = { "show", "hide" },
			},

			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = "mono",
			},

			fuzzy = {
				sorts = {
					"exact",
					"score",
					"sort_text",
				},
			},

			sources = {
				-- default = { "lsp", "path", "snippets", "copilot", "html-css" },
				default = { "lsp", "path", "snippets", "html-css" },

				providers = {
					snippets = {
						max_items = 10,
						-- score_offset = 10,
					},
					buffer = {
						max_items = 10,
					},

					-- copilot = {
					-- 	name = "copilot",
					-- 	module = "blink-cmp-copilot",
					-- 	kind = "Copilot",
					-- 	score_offset = -100,
					-- 	async = true,
					-- },
					["html-css"] = {
						name = "html-css",
						module = "blink.compat.source",
					},
				},
			},
			snippets = { preset = "luasnip" },
			completion = {
				list = {
					selection = {
						preselect = function(ctx)
							return ctx.mode ~= "cmdline"
						end,
						auto_insert = false,
					},
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 1,
				},
			},
		},
		opts_extend = { "sources.default" },
	},
}
