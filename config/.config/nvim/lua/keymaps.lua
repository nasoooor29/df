-- TIP: Disable arrow keys in normal mode
-- require("multiCursor")

vim.keymap.del("n", "grr")
vim.keymap.del("n", "gra")
vim.keymap.del("n", "gri")
vim.keymap.del("n", "grn")

local opts = { noremap = false, silent = true }

-- vim.keymap.set({ "n" }, "<laader>e", "<cmd>e<CR>", {
-- 	noremap = true,
-- 	silent = true,
-- }) -- vim
vim.keymap.set("n", "<ESC>", "<cmd>noh<CR>", opts)
-- vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>', opts)
-- vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>', opts)
-- vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>', opts)
-- vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>', opts)
vim.keymap.set("n", "[[", "gg", opts)
vim.keymap.set("n", "]]", "GG", opts)
vim.keymap.set("i", "<C-h>", "<esc>ha", opts)
vim.keymap.set("i", "<C-j>", "<esc>ja", opts)
vim.keymap.set("i", "<C-k>", "<esc>ka", opts)
vim.keymap.set("i", "<C-l>", "<esc>la", opts)
vim.keymap.set("i", "<C-b>", "<Esc>ba", opts)

-- move to buffers
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", opts)
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", opts)
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", opts)
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", opts)

-- -- cursor middle
-- vim.keymap.set("n", "k", "kzz", opts)
-- vim.keymap.set("n", "j", "jzz", opts)

-- file save and quitting mappings
vim.keymap.set({ "n", "v" }, "<laader>ww", "<cmd>wa<CR>", opts) -- vim
vim.keymap.set({ "n", "v" }, "<leader>wa", "<cmd>wa<CR>", opts) -- vim
vim.keymap.set({ "n", "v" }, "<leader>w", "<cmd>w<CR>", opts) -- vim
vim.keymap.set({ "n", "v" }, "<leader>wq", "<cmd>wq<CR>", opts) -- vim
vim.keymap.set({ "n", "v" }, "<leader>wqa", "<cmd>wqa<CR>", opts) -- vim
vim.keymap.set({ "n", "v" }, "<leader>qa", "<cmd>qa!<CR>", opts) -- vim
vim.keymap.set({ "n", "v" }, "<leader>q", "<cmd>bd<CR>", opts) -- vim
vim.keymap.set({ "n", "v" }, "<leader>qq", "<cmd>bd!<CR>", opts) -- vim
-- vim.keymap.set({ "n", "v" }, "<leader>qa", "<cmd>%bd|e#<CR>", opts)
vim.keymap.set({ "n", "v" }, "<leader>qa", "<cmd>%bdelete|edit#|bdelete#<CR>", opts)

-- copy paste from sys clipboard
vim.keymap.set("n", "<leader>p", '"+p', opts)
vim.keymap.set("n", "<leader>P", '"+P', opts)
vim.keymap.set({ "n", "x" }, "<leader>y", '"+y', opts)
vim.keymap.set({ "n", "x" }, "<leader>d", '"+d', opts)

-- these shortcuts is to make it look abit fimiliar to vscode
vim.keymap.set("n", "<Tab>", ">>", opts)
vim.keymap.set("n", "<S-Tab>", "<<", opts)
vim.keymap.set("v", "<Tab>", ">gv", opts)
vim.keymap.set("v", "<S-Tab>", "<gv", opts)

vim.keymap.set("n", "<A-S-j>", "yyp", opts)
vim.keymap.set("n", "<A-S-k>", "yyP", opts)
vim.keymap.set("n", "<leader>nn", "<cmd>enew<CR>", opts)

-- TODO: Fix from tmux
vim.keymap.set("i", "<C-Backspace>", "<esc>bciw", opts)
vim.keymap.set("i", "<C-Enter>", "<esc>o", opts)

-- Keymaps for resizing using Control + Shift + hjkl
vim.keymap.set("n", "<leader>rh", "<cmd>vertical resize -5<CR>", opts)
vim.keymap.set("n", "<leader>rl", "<cmd>vertical resize +5<CR>", opts)
vim.keymap.set("n", "<leader>rj", "<cmd>resize -5<CR>", opts)
vim.keymap.set("n", "<leader>rk", "<cmd>resize +5<CR>", opts)

-- keymaps for quickfix
vim.keymap.set("n", "<leader>qn", "<cmd>cnext<CR>", opts)
vim.keymap.set("n", "<leader>qp", "<cmd>cprevious<CR>", opts)
-- vim.keymap.set("n", "<leader>qw", function()
-- 	require("telescope.builtin").grep_string({ search = vim.fn.expand("<cword>"), use_regex = false })
-- end, { noremap = true, silent = true })

-- vim.keymap.set("n", "<leader>ref", "<cmd>.luafile %<CR>", opts)
vim.keymap.set("n", "<leader>rel", "<cmd>.lua<CR>", opts)
vim.keymap.set("v", "<leader>eb", ":s/\\%V", opts)

vim.keymap.set("n", "<leader>ref", function()
	vim.cmd("luafile " .. vim.api.nvim_buf_get_name(0))
end, opts)

vim.g.VM_maps = {
	["Find Under"] = "<C-d>",
	["Select All"] = "<leader>ra",
	["Add Cursor Down"] = "<C-A-j>",
	["Add Cursor Up"] = "<C-A-k>",
}

vim.keymap.set("n", "<leader>cp", function()
	-- Copy absolute path to system clipboard
	vim.fn.setreg("+", vim.fn.expand("%:p"))
	vim.notify("Copied: " .. vim.fn.expand("%:p"))
end, { noremap = true, silent = true })
