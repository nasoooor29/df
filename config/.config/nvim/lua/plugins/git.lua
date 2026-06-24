-- floating terminal without extentions
local function terminaly(cmd)
	local buf = vim.api.nvim_create_buf(false, true)
	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
	})

	vim.fn.termopen(cmd)
end

vim.keymap.set("n", "<leader>gh", function()
	local line = vim.fn.line(".")
	local file = vim.fn.expand("%")
	local text = vim.fn.getline(".")
	local pattern = vim.fn.escape(vim.trim(text), [[\]])
	terminaly(string.format("git log -L %d,%d:%s -- %s", line, line, pattern, file))
end, { desc = "Git line history popup" })

return {
	{ -- Adds git related signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		opts = {},

		event = "VimEnter", -- Plugin loads when Neovim starts
		-- NOTE: shortcuts PLZ
		keys = {
			{
				"<leader>gr",
				"<CMD>Gitsigns reset_hunk<CR>",
				desc = "Select hunk",
			},
			{
				"gb",
				"<CMD>Gitsigns blame_line<CR>",
				desc = "Blame line",
			},
			{
				"<leader>gb",
				"<CMD>Gitsigns blame<CR>",
				desc = "Blame",
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

			vim.keymap.set("n", "co", "<CMD>GitConflictChooseOurs<CR>", { desc = "Conflict: Git choose ours" })
			vim.keymap.set("n", "ct", "<CMD>GitConflictChooseTheirs<CR>", { desc = "Conflict: Git choose theirs" })
			vim.keymap.set("n", "cb", "<CMD>GitConflictChooseBoth<CR>", { desc = "Conflict: Git choose both" })
			vim.keymap.set(
				"n",
				"[x",
				"<CMD>GitConflictPrevConflict<CR>",
				{ desc = "Conflict: Go to previous conflict" }
			)
			vim.keymap.set("n", "]x", "<CMD>GitConflictNextConflict<CR>", { desc = "Conflict: Go to next conflict" })
		end,
	},
}
