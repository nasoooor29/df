vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.have_nerd_font = true
vim.o.relativenumber = true
vim.o.number = true
vim.opt.mouse = "a"

vim.opt.showmode = false
vim.opt.breakindent = true

vim.opt.undofile = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = "yes"

vim.opt.updatetime = 250

vim.opt.timeoutlen = 300

vim.opt.splitright = true
vim.opt.splitbelow = true

-- vim.opt.list = true

-- vim.opt.listchars = { tab = "│ ", trail = "│", nbsp = "│" }
-- vim.opt.listchars = { tab = "│ " }

vim.opt.swapfile = false

vim.opt.inccommand = "split"

vim.opt.cursorline = true

vim.opt.scrolloff = 10
vim.o.tabstop = 4 -- A TAB character looks like 4 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
-- vim.o.softtabstop = 4 -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 4 -- Number of spaces inserted when indenting

vim.filetype.add({
	pattern = {
		[".*/playbooks/.*%.yml"] = "yaml.ansible",
		[".*/playbooks/.*%.yaml"] = "yaml.ansible",
		[".*/roles/.*/tasks/.*%.yml"] = "yaml.ansible",
		[".*/roles/.*/tasks/.*%.yaml"] = "yaml.ansible",
		[".*/roles/.*/handlers/.*%.yml"] = "yaml.ansible",
		[".*/roles/.*/handlers/.*%.yaml"] = "yaml.ansible",
		[".*%.tmux%.conf"] = "tmux",
		[".*.kbd"] = "lisp",
	},
})

vim.diagnostic.config({
	virtual_text = true,
})
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldcolumn = "0"
vim.opt.foldlevel = 99
-- vim.opt.foldlevelstart = 4
vim.opt.foldnestmax = 20
vim.opt.foldtext = ""
vim.opt.winborder = "rounded"
-- vim.opt.foldmethod = "lsp"
-- vim.opt.foldtext = ""
--
vim.opt.guifont = "FiraCode Nerd Font Mono,Noto Sans Mono Arabic:h14"
