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
			require("mcphub").setup({
				-- workspace = {
				--
				-- 	look_for = { ".mcphub/servers.json", ".vscode/mcp.json", ".cursor/mcp.json", "opencode.json" }, -- Files to look for when detecting project boundaries (VS Code format supported)
				-- },
			})
		end,
	},

	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"ravitemer/mcphub.nvim",

			"ravitemer/codecompanion-history.nvim",
			{
				"echasnovski/mini.diff",
				config = function()
					local diff = require("mini.diff")
					diff.setup({
						-- Disabled by default
						source = diff.gen_source.none(),
					})
				end,
			},

			{
				"HakonHarnes/img-clip.nvim",
				opts = {
					filetypes = {
						codecompanion = {
							prompt_for_file_name = false,
							template = "[Image]($FILE_PATH)",
							use_absolute_path = true,
						},
					},
				},
			},
		},
		config = function()
			vim.keymap.set(
				{ "n", "v" },
				"<leader>ac",
				"<cmd>CodeCompanionActions<cr>",
				{ noremap = true, silent = true, desc = "Code Companion: Actions" }
			)
			vim.keymap.set(
				"v",
				"ga",
				"<cmd>CodeCompanionChat Add<cr>",
				{ noremap = true, silent = true, desc = "Code Companion: Chat Add Selection" }
			)

			vim.keymap.set("n", "<leader>af", function()
				require("codecompanion").prompt("fix_err")
			end, { noremap = true, silent = true, desc = "Code Companion: Fix Errors" })

			vim.keymap.set("n", "<leader>aa", function()
				require("codecompanion").prompt("general")
			end, { noremap = true, silent = true, desc = "Code Companion: General Prompt" })
			vim.keymap.set("n", "<leader>ag", function()
				require("codecompanion").prompt("git_commit")
			end, { noremap = true, silent = true, desc = "Code Companion: Git Commit Message" })
			vim.keymap.set("n", "<leader>ags", function()
				require("codecompanion").prompt("git_commit_staged")
			end, { noremap = true, silent = true, desc = "Code Companion: Git Commit Message Staged" })
			vim.keymap.set(
				"n",
				"<leader>cc",
				"<cmd>CodeCompanionChat Toggle<cr>",
				{ noremap = true, silent = true, desc = "Code Companion: Toggle Chat" }
			)

			vim.keymap.set(
				{ "v", "n" },
				"<leader>ae",
				":CodeCompanion<CR>",
				{ silent = true, desc = "Code Companion: Inline" }
			)

			-- Expand 'cc' into 'CodeCompanion' in the command line
			vim.cmd([[cab cc CodeCompanion]])
			require("codecompanion").setup({
				ignore_warnings = true,

				display = {
					diff = {
						enabled = true,
						provider = "mini_diff",
					},
					chat = {
						icons = {
							chat_context = "📎️", -- You can also apply an icon to the fold
						},
						-- start_in_insert_mode = true, -- Open the chat buffer in insert mode
						fold_context = true,
						child_window = {
							layout = "float",
							width = vim.o.columns - 5,
							height = vim.o.lines - 2,
							row = "center",
							col = "center",
							relative = "editor",
							opts = {
								wrap = false,
								number = false,
								relativenumber = false,
							},
						},
					},
				},

				-- NOTE: after the breaking chnage
				-- Prompt library items can now be specified in markdown as external files
				prompt_library = {
					["Fix Errors"] = {
						strategy = "chat",
						description = "Auto Prompt to fix errors in code",
						opts = {
							auto_submit = true,
							short_name = "fix_err",
						},
						prompts = {
							{
								role = "user",
								content = [[fix the error in the selected code]],
							},
						},
					},

					["Git Commiter"] = {
						strategy = "chat",
						description = "Auto Detect git commit message",
						opts = {
							auto_submit = true,
							short_name = "git_commit",
						},
						prompts = {
							{
								role = "user",
								content = [[use the @{get_changed_files} tool and give me git msg and commit the changes using the @{cmd_runner} tool.]],
							},
						},
					},
					["Git Commiter Staged"] = {
						strategy = "chat",
						description = "Auto Detect git commit message for staged files",
						opts = {
							auto_submit = true,
							short_name = "git_commit_staged",
						},
						prompts = {
							{
								role = "user",
								content = [[use the @{get_changed_files} or @{cmd_runner} and give me git msg and commit the changes using the @{cmd_runner} tool.]],
							},
						},
					},
					["General"] = {
						strategy = "chat",
						description = "Prompt to auto attach the buffer and other things",
						opts = {
							auto_submit = false,
							short_name = "general",
						},
						prompts = {
							{
								role = "user",
								content = "#{buffer} #{lsp} @{full_stack_dev} @{memory} @{mcp}\n ",
							},
						},
					},
				},

				-- NOTE: after the breaking chnage
				-- Memory has now been renamed to Rules
				-- https://codecompanion.olimorris.dev/configuration/memory
				-- it's just the instruction files like .rules, AGENT.md, github/copilot-instructions.md, etc
				memory = {
					opts = {
						chat = {
							enabled = true,
						},
					},
				},

				strategies = {
					chat = {

						adapter = {
							name = "copilot",
							model = "claude-haiku-4.5",
						},
						tools = {
							opts = {
								auto_submit_errors = true, -- Send any errors to the LLM automatically?
								auto_submit_success = true, -- Send any successful output to the LLM automatically?
							},
						},
					},
				},

				extensions = {
					mcphub = {
						callback = "mcphub.extensions.codecompanion",
						opts = {
							show_result_in_chat = true, -- Show mcp tool results in chat
							make_vars = true, -- Convert resources to #variables

							-- NOTE: after the breaking chnage
							-- slash commands going to be deprecated in future, use "rule files" instead
							make_slash_commands = true, -- Add prompts as /slash commands
						},
					},
					history = {
						opts = {
							auto_save = true,
							picker = "telescope", --- ("telescope", "snacks", "fzf-lua", or "default")
							---Automatically generate titles for new chats
							auto_generate_title = true,
						},
					},
				},
			})
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
