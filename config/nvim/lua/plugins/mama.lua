return {
	dir = "/home/nasoooor/.config/nvim/lua/mama",
	enabled = false,
	name = "mama",
	config = function()
		local ext = require("mama")
		ext.setup({
			max_buffers = 5,
		})
		vim.keymap.set("n", "<leader>1", function()
			ext.goto_file(1)
		end)
		vim.keymap.set("n", "<leader>2", function()
			ext.goto_file(2)
		end)
		vim.keymap.set("n", "<leader>3", function()
			ext.goto_file(3)
		end)
		vim.keymap.set("n", "<leader>4", function()
			ext.goto_file(4)
		end)
		vim.keymap.set("n", "<leader>5", function()
			ext.goto_file(5)
		end)
		vim.keymap.set("n", "<leader>lm", function()
			ext.list()
		end, { desc = "Mama: List" })

		vim.keymap.set("n", "<leader>l", function()
			ext.harpoon_like()
		end, { desc = "Mama: List" })
	end,
}
