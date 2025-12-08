return {
	"folke/noice.nvim",
	event = "VeryLazy",
	opts = {
		-- add any options here
	},
	dependencies = {
		-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
		"MunifTanjim/nui.nvim",
		-- OPTIONAL:
		--   `nvim-notify` is only needed, if you want to use the notification view.
		--   If not available, we use `mini` as the fallback
		"rcarriga/nvim-notify",
	},
	-- enabled = false,
	config = function()
		-- require("nui").setup()
		--
		require("notify").setup({

			background_colour = "#000000",
		})
		require("noice").setup({
			messages = {
				enabled = true, -- enables the Noice messages UI
				view = "mini",
				view_error = "mini",
				view_info = "mini",
				view_warn = "mini", -- view for warnings
				view_history = "mini",
				view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
			},
			-- you can enable a preset for easier configuration
			presets = {
				bottom_search = true, -- use a classic bottom cmdline for search
				command_palette = true, -- position the cmdline and popupmenu together
				-- long_message_to_split = true, -- long messages will be sent to a split
				inc_rename = false, -- enables an input dialog for inc-rename.nvim
			},
		})
		vim.keymap.set("n", "<leader>cm", "<cmd>messages clear<CR>", {
			desc = "clear messages",
		})
	end,
}
