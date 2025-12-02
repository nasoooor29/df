vim.api.nvim_create_autocmd("BufReadPre", {
	callback = function(args)
		-- local max_filesize = 1 * 1024 * 1024 -- 1 MB
		local max_filesize = 512 * 1024 -- 512 KB
		local ok, stats = pcall(vim.loop.fs_stat, args.file)
		if not ok or not stats then
			return
		end

		local is_big = stats.size > max_filesize
		local output = vim.fn.system({ "file", "--mime", args.file })
		local is_binary = output:match("charset=binary") ~= nil
		if not is_big then
			return
		end

		if is_big or is_binary then
			local reason = is_big and "large file" or "binary file"
			local choice = vim.fn.confirm(
				"Open " .. reason .. "? (" .. args.file .. ")",
				"&Yes\n&No",
				2 -- default to "No"
			)

			if choice ~= 1 then
				vim.cmd("bdelete " .. args.buf)
			end
		end
	end,
})

-- create an augroup to keep things clean
local group = vim.api.nvim_create_augroup("CursorCentering", {})

-- Disable k/j centering for filetype = fyler
vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = "fyler",
	callback = function(ev)
		-- remove the maps in this buffer
		vim.keymap.del("n", "k", { buffer = ev.buf })
		vim.keymap.del("n", "j", { buffer = ev.buf })
	end,
})

-- Enable k/j centering for all other filetypes
vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = "*",
	callback = function(ev)
		local ft = vim.bo[ev.buf].filetype
		if ft ~= "fyler" then
			vim.keymap.set("n", "k", "kzz", { buffer = ev.buf })
			vim.keymap.set("n", "j", "jzz", { buffer = ev.buf })
		end
	end,
})
