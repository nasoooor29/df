-- vim.keymap.set("n", "<leader>fe", function()
-- 	local f = require("fyler")
-- 	f.show()
-- end, { desc = "Open parent directory" })
-- return {
-- 	{
-- 		"A7Lavinraj/fyler.nvim",
-- 		dependencies = { "echasnovski/mini.icons" },
-- 		opts = {},
-- 	},
-- }
return {
	"stevearc/oil.nvim",
	---@module 'oil'
	---@type oil.SetupOpts
	opts = {

		view_options = {
			show_hidden = true,
		},

		float = {
			max_width = 40,
			win_options = {
				winblend = 0,
			},

			override = function(defaults)
				-- align to the left
				defaults["col"] = 2

				-- align to the right right
				defaults["col"] = vim.o.columns - defaults["width"] - 2

				return defaults
			end,
		},
		keymaps = {
			["gd"] = {
				desc = "Toggle file detail view",
				callback = function()
					detail = not detail
					if detail then
						require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
					else
						require("oil").set_columns({ "icon" })
					end
				end,
			},
		},
	},
	dependencies = { { "echasnovski/mini.icons", opts = {} } },
	-- enabled = false,
	config = function(_, opts)
		require("oil").setup(opts)
		vim.keymap.set("n", "<leader>fe", function()
			require("oil").toggle_float()
		end, { desc = "Open parent directory" })
	end,
}
