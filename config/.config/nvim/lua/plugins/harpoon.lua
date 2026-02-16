return {
	{
		"ton/vim-bufsurf",
	},
	{

		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local harpoon = require("harpoon")
			local key = require("utils").new("Harpoon")

			harpoon:setup()
			key.Nset("<leader>m", function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end, "harpoon: show menu")

			for i = 1, 9 do
				key.Nset("<leader>" .. i, function()
					harpoon:list():select(i)
				end, "harpoon: select " .. i)
			end
			key.Nset("[h", function()
				harpoon:list():prev()
			end, "harpoon: go to prev")
			key.Nset("]h", function()
				harpoon:list():next()
			end, "harpoon: go to next")
			key.Nset("<leader>-", function()
				harpoon:list():remove()
			end, "harpoon: remove from list")
			key.Nset("<leader>=", function()
				harpoon:list():add()
			end, "harpoon: add to list")

			-- Add custom commands
			-- vim.api.nvim_create_user_command("HarpoonClear", function()
			-- 	harpoon:list():clear()
			-- end, "harpoon: clear list")
			--
			-- vim.api.nvim_create_user_command("HarpoonAdd", function(opts)
			-- 	harpoon:list():add({ value = opts.args, context = nil })
			-- 	require("harpoon")
			-- 		:list()
			-- 		:add({ value = "/home/nasoooor/dotfiles/.config/nvim/lua/plugins/avante.lua", context = { col = 1, row = 1 } })
			-- end, "harpoon: add to list", nargs = 1)
		end,
	},
}
