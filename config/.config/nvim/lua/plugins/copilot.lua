return {
	{

		"copilotlsp-nvim/copilot-lsp",
		config = function()
			vim.g.copilot_nes_debounce = 500
			vim.lsp.enable("copilot_ls")
			-- vim.keymap.set("n", "<esc>", function()
			-- 	if not require("copilot-lsp.nes").clear() then
			-- 		return "<esc>"
			-- 		-- fallback to other functionality
			-- 	end
			-- end, { desc = "Clear Copilot suggestion or fallback" })
		end,
	},
	{
		"zbirenbaum/copilot.lua",
		requires = {
			"williamboman/mason.nvim",
			"copilotlsp-nvim/copilot-lsp", -- (optional) for NES functionality
		},
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			local cp = require("copilot")

			local sug = require("copilot.suggestion")
			vim.keymap.set({ "i", "n" }, "<C-s>", function()
				local bufnr = vim.api.nvim_get_current_buf()
				local state = vim.b[bufnr].nes_state
				if sug.is_visible() then
					sug.accept()
				elseif state then
					-- Try to jump to the start of the suggestion edit.
					-- If already at the start, then apply the pending suggestion and jump to the end of the edit.
					local _ = require("copilot-lsp.nes").walk_cursor_start_edit()
						or (
							require("copilot-lsp.nes").apply_pending_nes()
							and require("copilot-lsp.nes").walk_cursor_end_edit()
						)
					return nil
				else
					return nil
				end
			end, { expr = true, silent = true, noremap = true })
			vim.keymap.set({ "i", "n" }, "<Esc>", function()
				if require("copilot-lsp.nes").clear() then
					return "<Esc>"
				end
				if sug.is_visible() then
					sug.dismiss()
					return "<Esc>"
				else
					return "<Esc>"
				end
			end, { expr = true, silent = true, noremap = true })

			cp.setup({
				suggestion = {
					auto_trigger = true,
					trigger_on_accept = true,
					debounce = 100,
					keymap = {
						-- accept = "<C-s>",
						accept_word = false, -- Use <Tab> to accept the whole suggestion
						accept_line = false, -- Use <Tab> to accept the whole line
						next = "<c-j>",
						prev = "<c-k>",
						-- dismiss = "<Esc>",
					},
				},
				-- nes = {
				-- 	enabled = true,
				-- 	keymap = {
				-- 		accept_and_goto = "<M-i>",
				-- 		accept = false,
				-- 		-- dismiss = "<M-Esc>",
				-- 	},
				-- },
				panel = {
					enabled = false, -- Disable the Copilot panel
				},
			})
		end,
	},
	-- {
	-- 	"folke/sidekick.nvim",
	-- 	config = function()
	-- 		require("sidekick").setup({})
	-- 		print("sidekick is loaded")
	-- 	end,
	-- 	opts = {},
	-- 	keys = {
	-- 		{
	-- 			"<M-Enter>",
	-- 			function()
	-- 				-- if there is a next edit, jump to it, otherwise apply it if any
	-- 				if not require("sidekick").nes_jump_or_apply() then
	-- 					return "<M-Enter>" -- fallback to normal tab
	-- 				end
	-- 			end,
	-- 			expr = true,
	-- 			mode = { "i", "n" },
	-- 			desc = "Goto/Apply Next Edit Suggestion",
	-- 		},
	-- 	},
	-- }
}
