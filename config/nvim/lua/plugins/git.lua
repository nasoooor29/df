-- vim.api.nvim_create_autocmd({ "BufEnter" }, {
-- 	callback = function()
-- 		local buf_name = vim.api.nvim_buf_get_name(0)
-- 		if not string.match(buf_name, "NeogitStatus") then
-- 			return
-- 		end
--
-- 		vim.keymap.set("n", "<leader>g", require("neogit").close, { desc = "close neogit" })
-- 	end,
-- })
--
-- vim.api.nvim_create_autocmd({ "BufLeave" }, {
-- 	callback = function()
-- 		local buf_name = vim.api.nvim_buf_get_name(0)
-- 		if not string.match(buf_name, "NeogitStatus") then
-- 			return
-- 		end
-- 		vim.keymap.set("n", "<leader>g", require("neogit").open, { desc = "open neogit" })
-- 	end,
-- })
--
return {

	-- {
	-- 	"NeogitOrg/neogit",
	-- 	dependencies = {
	-- 		"nvim-lua/plenary.nvim", -- required
	-- 		"sindrets/diffview.nvim", -- optional - Diff integration
	-- 		-- Only one of these is needed.
	-- 		"nvim-telescope/telescope.nvim", -- optional
	-- 	},
	-- 	opts = {
	-- 		kind = "floating",
	-- 	},
	-- 	keys = {
	-- 		{
	-- 			"<leader>g",
	-- 			function()
	-- 				require("neogit").open()
	-- 			end,
	-- 			desc = "Open neogit",
	-- 		},
	-- 	},
	-- },

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

			local function choose_ours()
				vim.cmd("GitConflictChooseOurs")
				vim.cmd("GitConflictNextConflict")
			end
			local function choose_theirs()
				vim.cmd("GitConflictChooseTheirs")
				vim.cmd("GitConflictNextConflict")
			end

			vim.keymap.set("n", "co", choose_ours)
			vim.keymap.set("n", "ct", choose_theirs)
		end,
	},
}
