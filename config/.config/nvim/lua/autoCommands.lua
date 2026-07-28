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
		if not is_binary then
			return
		end

		if vim.fn.exists(":NoMatchParen") ~= 0 then
			vim.cmd("NoMatchParen")
		end

		-- vim.opt_local.foldmethod = "manual"
		-- vim.opt_local.statuscolumn = ""
		-- vim.opt_local.conceallevel = 0

		-- vim.b[ev.buf].completion = false
		-- vim.b[ev.buf].minianimate_disable = true
		-- vim.b[ev.buf].minihipatterns_disable = true

		vim.notify("File is too big, disabling some features for better performance.")
	end,
})

-- for some reason it treesitter doesn't work in golang
vim.api.nvim_create_autocmd("FileType", {
	pattern = "go",
	callback = function(ev)
		vim.treesitter.start(ev.buf, "go")
	end,
})
