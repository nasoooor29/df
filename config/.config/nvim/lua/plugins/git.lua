return {
	{ -- Adds git related signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		opts = {},

		event = "VimEnter", -- Plugin loads when Neovim starts
		-- NOTE: shortcuts PLZ
		keys = {
			{
				"gv",
				"<CMD>Gitsigns select_hunk<CR>",
				desc = "Select hunk",
			},

			{
				"<leader>gr",
				"<CMD>Gitsigns reset_hunk<CR>",
				desc = "Select hunk",
			},
			{
				"gs",
				"<CMD>Gitsigns stage_hunk<CR><CMD>Gitsigns next_hunk<CR>",
				desc = "Stage hunk",
			},
			{
				"gp",
				"<CMD>Gitsigns preview_hunk<CR>",
				desc = "Preview hunk",
			},
			{
				"[g",
				"<CMD>Gitsigns prev_hunk<CR>",
				desc = "Go to previous hunk",
			},
			{
				"]g",
				"<CMD>Gitsigns next_hunk<CR>",
				desc = "Go to next hunk",
			},
		},
	},
	{
		"akinsho/git-conflict.nvim",
		version = "*",
		config = function()
			-- vim.api.nvim_set_hl(0, "CurrentCustom", { bg = "#89b4fa", fg = "#1e1e2e" })
			-- vim.api.nvim_set_hl(0, "IncomingCustom", { bg = "#f38ba8", fg = "#1e1e2e" })

			vim.api.nvim_set_hl(0, "CurrentCustom", { fg = "#7daea3", bg = "#404946" })
			vim.api.nvim_set_hl(0, "IncomingCustom", { fg = "#7daea3", bg = "#542937" })

			require("git-conflict").setup({
				default_mappings = false,
				default_commands = true,
				disable_diagnostics = true,
				list_opener = "copen",
				highlights = {
					incoming = "IncomingCustom",
					current = "CurrentCustom",
				},
			})

			vim.keymap.set("n", "co", "<CMD>GitConflictChooseOurs<CR>", { desc = "Git choose ours" })
			vim.keymap.set("n", "ct", "<CMD>GitConflictChooseTheirs<CR>", { desc = "Git choose theirs" })
			vim.keymap.set("n", "cb", "<CMD>GitConflictChooseBoth<CR>", { desc = "Git choose both" })
			vim.keymap.set("n", "[x", "<CMD>GitConflictPrevConflict<CR>", { desc = "Go to previous conflict" })
			vim.keymap.set("n", "]x", "<CMD>GitConflictNextConflict<CR>", { desc = "Go to next conflict" })
		end,
	},
}
