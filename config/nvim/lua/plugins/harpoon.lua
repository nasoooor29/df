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

			harpoon:setup()
			vim.keymap.set("n", "<leader>m", function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end, { desc = "harpoon: show menu" })

			for i = 1, 9 do
				vim.keymap.set("n", "<leader>" .. i, function()
					harpoon:list():select(i)
				end, { desc = "harpoon: select " .. i })
			end
			vim.keymap.set("n", "[h", function()
				harpoon:list():prev()
			end, { desc = "harpoon: go to prev" })
			vim.keymap.set("n", "]h", function()
				harpoon:list():next()
			end, { desc = "harpoon: go to next" })
			vim.keymap.set("n", "<leader>-", function()
				harpoon:list():remove()
			end, { desc = "harpoon: remove from list" })
			vim.keymap.set("n", "<leader>=", function()
				harpoon:list():add()
			end, { desc = "harpoon: add to list" })

			-- Add custom commands
			-- vim.api.nvim_create_user_command("HarpoonClear", function()
			-- 	harpoon:list():clear()
			-- end, { desc = "harpoon: clear list" })
			--
			-- vim.api.nvim_create_user_command("HarpoonAdd", function(opts)
			-- 	harpoon:list():add({ value = opts.args, context = nil })
			-- 	require("harpoon")
			-- 		:list()
			-- 		:add({ value = "/home/nasoooor/dotfiles/.config/nvim/lua/plugins/avante.lua", context = { col = 1, row = 1 } })
			-- end, { desc = "harpoon: add to list", nargs = 1 })
		end,
	},
}
