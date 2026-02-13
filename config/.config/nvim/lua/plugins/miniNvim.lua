local StatusLineOpts = {
	use_icons = vim.g.have_nerd_font,
	content = {
		active = function()
			local check_macro_recording = function()
				if vim.fn.reg_recording() ~= "" then
					return "Reg @" .. vim.fn.reg_recording()
				else
					return ""
				end
			end

			local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 200 })

			local filename = MiniStatusline.section_filename({ trunc_width = 140 })
			local location = MiniStatusline.section_location({ trunc_width = 400 })
			local search = MiniStatusline.section_searchcount({ trunc_width = 75 })
			local macro = check_macro_recording()
			-- local git = MiniStatusline.section_git({ trunc_width = 40 })
			-- local diff = MiniStatusline.section_diff({ trunc_width = 75 })
			-- local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
			-- local lsp = MiniStatusline.section_lsp({ trunc_width = 75 })
			-- local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })

			return MiniStatusline.combine_groups({
				{ hl = mode_hl, strings = { mode } },
				-- { hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics } },
				"%<", -- Mark general truncate point
				{ hl = "MiniStatuslineFilename", strings = { filename } },
				"%=", -- End left alignment
				{ hl = "MiniStatuslineFilename", strings = { macro } },
				-- { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
				{ hl = mode_hl, strings = { search, location } },
			})
		end,
	},
}

return { -- Collection of various small independent plugins/modules
	"echasnovski/mini.nvim",
	dependencies = {
		"JoosepAlviste/nvim-ts-context-commentstring",
	},
	version = false,
	config = function()
		require("mini.ai").setup()
		require("mini.statusline").setup(StatusLineOpts)
		require("mini.surround").setup()
		require("mini.move").setup()
		-- require("mini.tabline").setup()
		-- require("mini.starter").setup()
		require("mini.pairs").setup()
		require("mini.cursorword").setup()
		require("mini.indentscope").setup()

		-- local clue = require("mini.clue")
		-- clue.setup({
		-- 	triggers = {
		-- 		-- Leader triggers
		-- 		{ mode = "n", keys = "<Leader>" },
		-- 		{ mode = "x", keys = "<Leader>" },
		--
		-- 		-- Built-in completion
		-- 		{ mode = "i", keys = "<C-x>" },
		--
		-- 		-- `g` key
		-- 		{ mode = "n", keys = "g" },
		-- 		{ mode = "x", keys = "g" },
		-- 		-- NOTE: in the future
		-- 		-- -- Marks https://github.com/chentoast/marks.nvim
		-- 		-- { mode = "n", keys = "'" },
		-- 		-- { mode = "n", keys = "`" },
		-- 		-- { mode = "x", keys = "'" },
		-- 		-- { mode = "x", keys = "`" },
		-- 		-- -- Registers
		-- 		-- { mode = "n", keys = '"' },
		-- 		-- { mode = "x", keys = '"' },
		-- 		-- { mode = "i", keys = "<C-r>" },
		-- 		-- { mode = "c", keys = "<C-r>" },
		-- 		-- -- Window commands
		-- 		-- { mode = "n", keys = "<C-w>" },
		-- 		-- -- `z` key
		-- 		-- { mode = "n", keys = "z" },
		-- 		-- { mode = "x", keys = "z" },
		-- 	},
		--
		-- 	clues = {
		-- 		clue.gen_clues.builtin_completion(),
		-- 		clue.gen_clues.g(),
		-- 		clue.gen_clues.marks(),
		-- 		clue.gen_clues.registers(),
		-- 		clue.gen_clues.windows(),
		-- 		clue.gen_clues.z(),
		-- 	},
		-- 	window = {
		-- 		config = { width = 50 },
		-- 	},
		-- })

		require("mini.hipatterns").setup({
			highlighters = {
				hex_color = require("mini.hipatterns").gen_highlighter.hex_color(),
			},
		})
		require("mini.comment").setup({
			options = {
				custom_commentstring = function()
					return require("ts_context_commentstring").calculate_commentstring() or vim.bo.commentstring
				end,
			},
		})

		vim.keymap.set("n", "<leader>z", function()
			require("mini.misc").zoom()
		end, { noremap = true, silent = true, desc = "MINI: Zoom in/out buffer" })
	end,
}
