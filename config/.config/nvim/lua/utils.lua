-- utils/keymaker.lua
local KeyMaker = {}

function KeyMaker.new(prefix)
	prefix = prefix or ""

	-- best-effort auto description
	local function resolve_desc(rhs, desc)
		-- 1️⃣ user always wins
		if desc ~= nil then
			return desc
		end

		-- 2️⃣ fallback to function name
		if type(rhs) ~= "function" then
			return desc
		end
		local info = debug.getinfo(rhs, "n")
		if info then
			return info and info.name
		end

		local mt = getmetatable(rhs)
		if mt and mt.__call then
			local call_info = debug.getinfo(mt.__call, "n")
			if call_info then
				return call_info.name
			end
		end

		return nil
	end

	local function opts(rhs, desc)
		local final_desc = resolve_desc(rhs, desc)
		if final_desc then
			final_desc = string.format("[%s]: %s", prefix, final_desc)
		end
		return {
			desc = final_desc,
			noremap = true,
			silent = true,
		}
	end

	local M = {}

	M.NXset = function(lhs, rhs, desc)
		vim.keymap.set({ "n", "x" }, lhs, rhs, opts(rhs, desc))
	end

	M.NXVset = function(lhs, rhs, desc)
		vim.keymap.set({ "n", "x", "v" }, lhs, rhs, opts(rhs, desc))
	end

	M.Nset = function(lhs, rhs, desc)
		vim.keymap.set("n", lhs, rhs, opts(rhs, desc))
	end

	M.Xset = function(lhs, rhs, desc)
		vim.keymap.set("x", lhs, rhs, opts(rhs, desc))
	end

	M.Vset = function(lhs, rhs, desc)
		vim.keymap.set("v", lhs, rhs, opts(rhs, desc))
	end

	M.Iset = function(lhs, rhs, desc)
		vim.keymap.set("i", lhs, rhs, opts(rhs, desc))
	end

	return M
end

return KeyMaker
