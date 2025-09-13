return {
	"folke/flash.nvim",
	event = "VeryLazy",
	---@type Flash.Config
	opts = {},
	-- stylua: ignore
	keys = {
		{ "s", mode = { "n", "x", "o" }, function() require("flash").jump() end,       desc = "flash: flash" },
		{ "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "flash: Flash Treesitter" },
	},
}
