local servers = {
	cssls = {},
	css_variables = {},
	marksman = {},
	pyright = {},
	-- shfmt = {},
	gopls = {},
	-- goimports = {},
	ts_ls = {},
	-- sqlls = {},
	-- sqls = {},
	bashls = {},
	ansiblels = {},
	stylua = {},
	templ = {},
	-- ["ansible-lint"] = {},
	-- ["powershell-editor-services"] = {},

	["rust_analyzer"] = {
		assist = {
			importEnforceGranularity = true,
			importPrefix = "crate",
		},
		cargo = {
			allFeatures = true,
		},
		checkOnSave = {
			command = "clippy",
		},
		inlayHints = { locationLinks = false },
		diagnostics = {
			enable = true,
			experimental = {
				enable = true,
			},
		},
	},
	lua_ls = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.stdpath("config") .. "/lua"] = true,
				},
			},
		},
	},
	emmet_ls = {
		filetypes = { "html", "css", "javascriptreact", "typescriptreact", "php", "phtml" },
	},
	intelephense = {
		filetypes = { "php", "phtml" },
	},
	phpactor = {
		filetypes = { "php", "phtml" },
	},
}

return servers
