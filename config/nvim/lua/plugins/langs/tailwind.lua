vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = { "*.html", "*.jsx", "*.tsx", "*.css", "*.scss" },
	callback = function()
		-- Check if current file's directory contains 'penny'
		local file_path = vim.api.nvim_buf_get_name(0)
		local dir = vim.fn.fnamemodify(file_path, ":h")
		if string.find(dir, "penny") then
			return
		end
		local buf_clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
		for _, client in ipairs(buf_clients) do
			if client.name == "tailwindcss" then
				vim.cmd("TailwindSort")
				return
			end
		end
	end,
	desc = "Automatically sort Tailwind classes on save, if Tailwind LSP is active and dir does not contain 'penny'",
})

return {
	"luckasRanarison/tailwind-tools.nvim",
	event = "VeryLazy",
	name = "tailwind-tools",
	build = ":UpdateRemotePlugins",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-telescope/telescope.nvim", -- optional
		"neovim/nvim-lspconfig", -- optional
	},
	opts = {}, -- your configuration
	config = function()
		local tailwind = require("tailwind-tools")
		tailwind.setup()
	end,
}
