local function fetch_key()
	return vim.env.GITHUB_TOKEN
end
return {
	"nvim-tree/nvim-web-devicons",
	"stevearc/dressing.nvim",
	"nvim-lua/plenary.nvim",
	"MunifTanjim/nui.nvim",
	"giuxtaposition/blink-cmp-copilot",
	{
		"Kurama622/llm.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
		cmd = { "LLMSessionToggle", "LLMSelectedTextHandler", "LLMAppHandler" },
		config = function()
			require("llm").setup({
				-- [[ Github Models ]]
				url = "https://models.inference.ai.azure.com/chat/completions",
				fetch_key = fetch_key,
				model = "gpt-4o-mini",
				api_type = "openai",

				prompt = "You are a helpful ai assistant for coding.",

				prefix = {
					user = { text = "😃 ", hl = "Title" },
					assistant = { text = "  ", hl = "Added" },
				},

				-- history_path = "/tmp/llm-history",
				save_session = true,
				max_history = 15,
				max_history_name_length = 20,

        -- stylua: ignore
        keys = {
          -- The keyboard mapping for the input window.
          ["Input:Submit"]      = { mode = "n", key = "<cr>" },
          ["Input:Cancel"]      = { mode = {"n", "i"}, key = "<C-c>" },
          ["Input:Resend"]      = { mode = {"n", "i"}, key = "<C-r>" },

          -- only works when "save_session = true"
          ["Input:HistoryNext"] = { mode = {"n", "i"}, key = "<C-j>" },
          ["Input:HistoryPrev"] = { mode = {"n", "i"}, key = "<C-k>" },

          -- The keyboard mapping for the output window in "split" style.
          ["Output:Ask"]        = { mode = "n", key = "i" },
          ["Output:Cancel"]     = { mode = "n", key = "<C-c>" },
          ["Output:Resend"]     = { mode = "n", key = "<C-r>" },

          -- The keyboard mapping for the output and input windows in "float" style.
          ["Session:Toggle"]    = { mode = "n", key = "<leader>ac" },
          ["Session:Close"]     = { mode = "n", key = {"<esc>", "Q"} },

          -- Scroll
          ["PageUp"]            = { mode = {"i","n"}, key = "<C-b>" },
          ["PageDown"]          = { mode = {"i","n"}, key = "<C-f>" },
          ["HalfPageUp"]        = { mode = {"i","n"}, key = "<C-u>" },
          ["HalfPageDown"]      = { mode = {"i","n"}, key = "<C-d>" },
          ["JumpToTop"]         = { mode = "n", key = "gg" },
          ["JumpToBottom"]      = { mode = "n", key = "G" },
        },

				app_handler = {
					-- Your AI tools Configuration
					-- TOOL_NAME = { ... }
					Ask = {
						handler = "disposable_ask_handler",
						opts = {
							position = {
								row = 2,
								col = 0,
							},
							title = " Ask ",
							inline_assistant = true,

							-- Whether to use the current buffer as context without selecting any text (the tool is called in normal mode)
							enable_buffer_context = true,
							diagnostic = { vim.diagnostic.severity.ERROR, vim.diagnostic.severity.WARN },

							-- display diff
							display = {
								mapping = {
									mode = "n",
									keys = { "d" },
								},
								action = nil,
							},
							-- accept diff
							accept = {
								mapping = {
									mode = "n",
									keys = { "Y", "y" },
								},
								action = nil,
							},
							-- reject diff
							reject = {
								mapping = {
									mode = "n",
									keys = { "N", "n" },
								},
								action = nil,
							},
							-- close diff
							close = {
								mapping = {
									mode = "n",
									keys = { "<esc>" },
								},
								action = nil,
							},
						},
					},
					AttachToChat = {
						handler = "attach_to_chat_handler",
						opts = {
							is_codeblock = true,
							inline_assistant = true,
							diagnostic = { vim.diagnostic.severity.ERROR, vim.diagnostic.severity.WARN },
							-- display diff
							display = {
								mapping = {
									mode = "n",
									keys = { "d" },
								},
								action = nil,
							},
							-- accept diff
							accept = {
								mapping = {
									mode = "n",
									keys = { "Y", "y" },
								},
								action = nil,
							},
							-- reject diff
							reject = {
								mapping = {
									mode = "n",
									keys = { "N", "n" },
								},
								action = nil,
							},
							-- close diff
							close = {
								mapping = {
									mode = "n",
									keys = { "<esc>" },
								},
								action = nil,
							},
						},
					},
					CommitMsg = {
						handler = "flexi_handler",
						prompt = function()
							-- Source: https://andrewian.dev/blog/ai-git-commits
							return string.format(
								[[You are an expert at following the Conventional Commit specification. Given the git diff listed below, please generate a commit message for me:

1. First line: conventional commit format (type: concise description) (remember to use semantic types like feat, fix, docs, style, refactor, perf, test, chore, etc.)
2. Optional bullet points if more context helps:
   - Keep the second line blank
   - Keep them short and direct
   - Focus on what changed
   - Always be terse
   - Don't overly explain
   - Drop any fluffy or formal language

Return ONLY the commit message - no introduction, no explanation, no quotes around it.

Examples:
feat: add user auth system

- Add JWT tokens for API auth
- Handle token refresh for long sessions

fix: resolve memory leak in worker pool

- Clean up idle connections
- Add timeout for stale workers

Simple change example:
fix: typo in README.md

Very important: Do not respond with any of the examples. Your message must be based off the diff that is about to be provided, with a little bit of styling informed by the recent commits you're about to see.

Based on this format, generate appropriate commit messages. Respond with message only. DO NOT format the message in Markdown code blocks, DO NOT use backticks:

```diff
%s
```
]],
								vim.fn.system("git diff --no-ext-diff --staged")
							)
						end,

						opts = {
							enter_flexible_window = true,
							apply_visual_selection = false,
							win_opts = {
								relative = "editor",
								position = "50%",
							},
							accept = {
								mapping = {
									mode = "n",
									keys = "<cr>",
								},
								action = function()
									local contents = vim.api.nvim_buf_get_lines(0, 0, -1, true)

									local cmd = string.format('!git commit -m "%s"', table.concat(contents, '" -m "'))
									cmd = (cmd:gsub(".", {
										["#"] = "\\#",
									}))

									vim.api.nvim_command(cmd)
									-- just for lazygit
									vim.schedule(function()
										vim.api.nvim_command("LazyGit")
									end)
								end,
							},
						},
					},
				},
			})
		end,
		keys = {
			{ "<leader>aa", mode = "n", "<cmd>LLMAppHandler AttachToChat<cr>" },
			{ "<leader>ae", mode = "v", "<cmd>LLMAppHandler Ask<cr>" },
			{ "<leader>ava", mode = "n", "<cmd>LLMAppHandler AttachToChat<cr>" },
			{ "<leader>agm", mode = "n", "<cmd>LLMAppHandler CommitMsg<cr>" },
			-- { "<leader>ae", mode = "v", '<cmd>LLMSelectedTextHandler "wtf explain the following code"<cr>' },
		},
	},

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

	-- -- avante
	-- {
	-- 	"yetone/avante.nvim",
	-- 	event = "VeryLazy",
	-- 	lazy = false,
	-- 	veersion = false,
	-- 	build = "make",
	-- 	opts = {
	-- 		system_prompt = function()
	-- 			local hub = require("mcphub").get_hub_instance()
	-- 			local pp = hub and hub:get_active_servers_prompt() or ""
	-- 			return pp
	-- 		end,
	-- 		-- Using function prevents requiring mcphub before it's loaded
	-- 		custom_tools = function()
	-- 			return {
	-- 				require("mcphub.extensions.avante").mcp_tool(),
	-- 			}
	-- 		end,
	-- 		edit = {
	-- 			border = "rounded",
	-- 			start_insert = true, -- Start insert mode when opening the edit window
	-- 		},
	--
	-- 		provider = "copilot",
	-- 		hints = {
	-- 			enabled = true,
	-- 		},
	-- 		windows = {
	-- 			width = 40,
	-- 			sidebar_header = {
	-- 				enabled = false, -- true, false to enable/disable the header
	-- 			},
	-- 			input = {
	-- 				prefix = "> ",
	-- 				height = 4, -- Height of the input window in vertical layout
	-- 			},
	-- 			-- ask = {
	-- 			-- 	floating = true, -- Open the 'AvanteAsk' prompt in a floating window
	-- 			-- },
	-- 		},
	-- 	},
	--
	-- 	keys = {
	-- 		{ "<leader>ava", ":AvanteClear<CR>:AvanteToggle<CR>", silent = true, desc = "avante: clear and toggle" },
	-- 	},
	-- },
}
