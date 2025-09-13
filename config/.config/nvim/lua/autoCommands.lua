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
