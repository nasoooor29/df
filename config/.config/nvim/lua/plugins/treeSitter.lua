return {

	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	branch = "main",
	config = function()
		require("nvim-treesitter").setup({
			ensure_installed = {
				"bash",
				"c",
				"cpp",
				"css",
				"go",
				"html",
				"javascript",
				"lua",
				"python",
				"ruby",
				"rust",
				"sql",
				"typescript",
				"yaml",
				"vim",
				"vimdoc",
				"query",
				"markdown",
				"markdown_inline",
			},
			auto_install = true,
			sync_install = false,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
			-- init selection incremental selection
			-- incremental_selection = {
			-- 	enable = true,
			-- 	keymaps = {
			-- 		init_selection = "<C-space>",
			-- 		node_incremental = "<C-space>",
			-- 		scope_incremental = false,
			-- 		node_decremental = "<bs>",
			-- 		-- node_decremental = "<C-s-space>",
			-- 	},
			-- },
		})

		vim.keymap.set("n", "<C-space>", function()
			-- press v to enter visual mode
			vim.cmd("normal! v")
			if vim.treesitter.get_parser(nil, nil, { error = false }) then
				require("vim.treesitter._select").select_parent(vim.v.count1)
			else
				vim.lsp.buf.selection_range(vim.v.count1)
			end
		end, { desc = "Select parent (outer) node" })

		vim.keymap.set({ "x", "o" }, "<C-space>", function()
			if vim.treesitter.get_parser(nil, nil, { error = false }) then
				require("vim.treesitter._select").select_parent(vim.v.count1)
			else
				vim.lsp.buf.selection_range(vim.v.count1)
			end
		end, { desc = "Select parent (outer) node" })

		vim.keymap.set({ "x", "o" }, "in", function()
			if vim.treesitter.get_parser(nil, nil, { error = false }) then
				require("vim.treesitter._select").select_child(vim.v.count1)
			else
				vim.lsp.buf.selection_range(-vim.v.count1)
			end
		end, { desc = "Select child (inner) node" })
	end,
}
