local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

	{ -- Collection of various small independent plugins/modules
		"echasnovski/mini.nvim",
		version = false,
		config = function()
			require("mini.icons").setup()
		end,
	},

	"nvim-lua/plenary.nvim",
	"MunifTanjim/nui.nvim",

	{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
	{
		"A7Lavinraj/fyler.nvim",
		opts = { icon_provider = "nvim_web_devicons" },
		config = function()
			-- Toggle Fyler with optional settings

			local fyler = require("fyler")
			fyler.setup()
			vim.keymap.set("n", "<leader>fe", function()
				fyler.open()
				-- fyler.toggle({
				-- 	kind = "split_right_most" -- (Optional) Use custom window layout
				-- })
			end)
		end,
	},
	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		lazy = false,
		veersion = false,
		build = "make",
		opts = {
			-- system_prompt = function()
			-- 	local hub = require("mcphub").get_hub_instance()
			-- 	local pp = hub and hub:get_active_servers_prompt() or ""
			-- 	return pp
			-- end,
			-- Using function prevents requiring mcphub before it's loaded
			-- custom_tools = function()
			-- 	return {
			-- 		require("mcphub.extensions.avante").mcp_tool(),
			-- 	}
			-- end,
			edit = {
				border = "rounded",
				start_insert = true, -- Start insert mode when opening the edit window
			},

			provider = "copilot",
			hints = {
				enabled = true,
			},
			windows = {
				width = 40,
				sidebar_header = {
					enabled = false, -- true, false to enable/disable the header
				},
				input = {
					prefix = "> ",
					height = 4, -- Height of the input window in vertical layout
				},
				-- ask = {
				-- 	floating = true, -- Open the 'AvanteAsk' prompt in a floating window
				-- },
			},
		},

		keys = {
			{ "<leader>ava", ":AvanteClear<CR>:AvanteToggle<CR>", silent = true, desc = "avante: clear and toggle" },
		},
	},
})
