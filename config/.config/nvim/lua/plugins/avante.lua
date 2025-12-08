local function fetch_key()
	return vim.env.GITHUB_TOKEN
end
return {
	"nvim-tree/nvim-web-devicons",
	"stevearc/dressing.nvim",
	"nvim-lua/plenary.nvim",
	"MunifTanjim/nui.nvim",
	"giuxtaposition/blink-cmp-copilot",

	-- mcp hub
	{
		"ravitemer/mcphub.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		build = "npm install -g mcp-hub@latest", -- Installs `mcp-hub` node binary globally
		config = function()
			require("mcphub").setup()
		end,
	},

	-- render markdown
	{
		-- NOTE: for configuration options refer to this link:
		-- https://github.com/MeanderingProgrammer/render-markdown.nvim/wiki
		"MeanderingProgrammer/render-markdown.nvim",
		opts = { file_types = { "markdown", "Avante", "codecompanion" } },
		ft = { "markdown", "Avante", "codecompanion" },
	},

	-- copilot
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		build = ":Copilot auth",
		event = "InsertEnter",
		config = function()
			vim.keymap.set("n", "<c-S>", function()
				require("copilot.suggestion").toggle_auto_trigger()
			end, { noremap = true, silent = true, desc = "Toggle Copilot suggestion auto-trigger" })

			require("copilot").setup({
				suggestion = {
					auto_trigger = true,
					debounce = 100,
					keymap = {
						accept = "<c-s>",
						accept_word = false, -- Use <Tab> to accept the whole suggestion
						accept_line = false, -- Use <Tab> to accept the whole line
						next = "<c-j>",
						prev = "<c-k>",
						dismiss = "<c-e>",
					},
				},
				panel = {
					enabled = false, -- Disable the Copilot panel
				},
				filetypes = {
					enabled = {
						["*"] = true, -- Enable Copilot for all file types
					},
					disabled = {
						-- ["markdown"] = true, -- Disable Copilot for markdown files
					},
				},
			})
		end,
	},
}
