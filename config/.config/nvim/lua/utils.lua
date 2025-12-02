local M = {}

local opts = function(desc)
	return { desc = desc, noremap = true, silent = true }
end

M.NXset = function(lhs, rhs, desc)
	vim.keymap.set({ "n", "x" }, lhs, rhs, opts(desc))
end

M.NXVset = function(lhs, rhs, desc)
	vim.keymap.set({ "n", "x", "v" }, lhs, rhs, opts(desc))
end

M.Nset = function(lhs, rhs, desc)
	vim.keymap.set("n", lhs, rhs, opts(desc))
end

M.Xset = function(lhs, rhs, desc)
	vim.keymap.set("x", lhs, rhs, opts(desc))
end

M.Vset = function(lhs, rhs, desc)
	vim.keymap.set("v", lhs, rhs, opts(desc))
end

M.Iset = function(lhs, rhs, desc)
	vim.keymap.set("i", lhs, rhs, opts(desc))
end

return M
