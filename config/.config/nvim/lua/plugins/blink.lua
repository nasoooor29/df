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
	{
		-- NOTE: for configuration options refer to this link:
		-- https://github.com/MeanderingProgrammer/render-markdown.nvim/wiki
		"MeanderingProgrammer/render-markdown.nvim",
		opts = { file_types = { "markdown", "Avante", "codecompanion" } },
		ft = { "markdown", "Avante", "codecompanion" },
	},
	{
		"sudo-tee/opencode.nvim",
		config = function()
			require("opencode").setup({
				keymap = {
					editor = {
						["<leader>ae"] = { "quick_chat", mode = { "n", "x" } }, -- Open quick chat input with selection context in visual mode or current line context in normal mode
					},
				},
				ui = {
					zoom_width = 1, -- Zoom width as percentage of editor width
				},
			})
		end,

		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"MeanderingProgrammer/render-markdown.nvim",
				opts = {
					anti_conceal = { enabled = false },
					file_types = { "markdown", "opencode_output" },
				},
				ft = { "markdown", "Avante", "copilot-chat", "opencode_output" },
			},
			-- Optional, for file mentions and commands completion, pick only one
			"saghen/blink.cmp",
			-- 'hrsh7th/nvim-cmp',

			-- Optional, for file mentions picker, pick only one
			"folke/snacks.nvim",
			-- 'nvim-telescope/telescope.nvim',
			-- 'ibhagwan/fzf-lua',
			-- 'nvim_mini/mini.nvim',
		},
	},
	{
		"zbirenbaum/copilot.lua",
		requires = {
			"williamboman/mason.nvim",
			{
				"copilotlsp-nvim/copilot-lsp",
				config = function()
					vim.g.copilot_nes_debounce = 500
				end,
			}, -- (optional) for NES functionality
		},
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				suggestion = {
					auto_trigger = true,
					debounce = 100,
					keymap = {
						accept = "<c-s>",
						accept_word = false, -- Use <Tab> to accept the whole suggestion
						accept_line = false, -- Use <Tab> to accept the whole line
						next = "<c-j>",
						prev = "<c-k>",
						dismiss = "<Esc>",
					},
				},
				-- nes = {
				-- 	enabled = true,
				-- 	keymap = {
				-- 		accept_and_goto = "<M-Enter>",
				-- 		accept = false,
				-- 		dismiss = "<M-Esc>",
				-- 	},
				-- },
				panel = {
					enabled = false, -- Disable the Copilot panel
				},
			})
		end,
	},
	{
		"folke/sidekick.nvim",
		config = function()
			require("sidekick").setup({})
			print("sidekick is loaded")
		end,
		opts = {},
		keys = {
			{
				"<M-Enter>",
				function()
					-- if there is a next edit, jump to it, otherwise apply it if any
					if not require("sidekick").nes_jump_or_apply() then
						return "<M-Enter>" -- fallback to normal tab
					end
				end,
				expr = true,
				mode = { "i", "n" },
				desc = "Goto/Apply Next Edit Suggestion",
			},
		},
	},
}
