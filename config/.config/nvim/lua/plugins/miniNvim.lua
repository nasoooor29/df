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
		require("mini.extra").setup()
		require("mini.pairs").setup()
		require("mini.cursorword").setup()
		require("mini.indentscope").setup()

		-- require("mini.tabline").setup()
		require("mini.starter").setup()

		-- NOTE: check later if u use it or not
		require("mini.surround").setup()
		require("mini.comment").setup({
			options = {
				custom_commentstring = function()
					return require("ts_context_commentstring").calculate_commentstring() or vim.bo.commentstring
				end,
			},
		})

		local hipatterns = require("mini.hipatterns")
		hipatterns.setup({
			highlighters = {
				todo = { pattern = "%f[%w]()TODO:.*", group = "MiniHipatternsTodo" },
				fixme = { pattern = "%f[%w]()FIXME:.*", group = "MiniHipatternsFixme" },
				test = { pattern = "%f[%w]()TEST:.*", group = "MiniHipatternsHack" },
				note = { pattern = "%f[%w]()NOTE:.*", group = "MiniHipatternsNote" },
				info = { pattern = "%f[%w]()INFO:.*", group = "MiniHipatternsNote" },
				source = { pattern = "%f[%w]()SOURCE:", group = "MiniHipatternsNote" },
				small_source = { pattern = "%f[%w]()source:", group = "MiniHipatternsNote" },
				-- note = hi_words({ "NOTE", "INFO" }, "MiniHipatternsNote"),
				-- source = hi_words({ "SOURCE", "source" }, "MiniHipatternsNote"),

				hex_color = hipatterns.gen_highlighter.hex_color(),
			},
		})

		local function pasty()
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-r>+", true, true, true), "n", true)
		end

		local pick = require("mini.pick")
		pick.setup({
			mappings = {
				sys_paste2 = {
					char = "<C-S-v>",
					func = pasty,
				},
				sys_paste = {
					char = "<C-v>",
					func = pasty,
				},
			},
		})

		vim.keymap.set("n", "<leader>z", function()
			require("mini.misc").zoom()
		end, { noremap = true, silent = true, desc = "MINI: Zoom in/out buffer" })

		vim.keymap.set("n", "<leader>ff", "<CMD>Pick files<CR>", { desc = "[F]ind [F]iles" })
		-- Replace Telescope live_grep with mini.pick live_grep
		vim.keymap.set("n", "<leader>fg", "<CMD>Pick grep_live<CR>", { desc = "[F]ind [G]rep" })
		vim.keymap.set("n", "<leader>fk", "<CMD>Pick keymaps<CR>", { desc = "[F]ind [K]eymaps" })
		vim.keymap.set("n", "<leader>fc", "<CMD>Pick commands<CR>", { desc = "[F]ind [C]ommands" })
		vim.keymap.set("n", "<leader>fh", "<CMD>Pick help<CR>", { desc = "[F]ind [H]elp" })
		vim.keymap.set("n", "<leader>fp", ":Pick hipatterns<CR>", {
			desc = "Find search hipatterns",
		})

		vim.keymap.set(
			"n",
			"<leader>fd",
			"<CMD>Pick diagnostic scope='current' sort_by='severity'<CR>",
			{ desc = "[F]ind [D]iagnostic in current buffer" }
		)

		vim.keymap.set(
			"n",
			"<leader>fD",
			"<CMD>Pick diagnostic scope='all' sort_by='severity'<CR>",
			{ desc = "[F]ind [D]iagnostic in all buffers" }
		)
	end,
}
