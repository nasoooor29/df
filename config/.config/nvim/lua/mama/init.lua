local M = {}

local config = {
	max_files = 5,
}
local myVars = {
	bufName = "FiveFiles",
	floatBufNum = -1,
}

M.tracked_files = {}

-- Returns true if the buffer has a real, readable file
local function is_real_file(path)
	if path == "" then
		return false
	end
	if vim.fn.filereadable(path) ~= 1 then
		return false
	end
	if path:match("^oil://") then
		return false
	end
	if vim.fn.isdirectory(path) == 1 then
		return false
	end
	return true
end

-- Track or reorder a file
function M.track_buffer(bufnr)
	if not vim.api.nvim_buf_is_valid(bufnr) or not vim.api.nvim_buf_is_loaded(bufnr) then
		return
	end

	local path = vim.api.nvim_buf_get_name(bufnr)
	if not is_real_file(path) then
		return
	end
	-- Skip if already tracked
	for _, existing in ipairs(M.tracked_files) do
		if existing == path then
			return
		end
	end

	-- Remove existing if present
	for i, existing in ipairs(M.tracked_files) do
		if existing == path then
			table.remove(M.tracked_files, i)
			break
		end
	end

	-- Insert at the end (most recently used)
	if #M.tracked_files <= 1 then
		table.insert(M.tracked_files, path)
	else
		table.insert(M.tracked_files, 1, path) -- Keep the most recent at the front
	end
	-- Limit size
	while #M.tracked_files > config.max_files do
		table.remove(M.tracked_files)
	end
end

-- Jump to a tracked file by index
function M.goto_file(index)
	local path = M.tracked_files[index]
	if not is_real_file(path) then
		print("No valid file at slot " .. index)
		return
	end
	-- if the float is open, close it
	if myVars.floatBufNum ~= -1 and vim.api.nvim_buf_is_valid(myVars.floatBufNum) then
		-- get buf lines
		local lines = vim.api.nvim_buf_get_lines(myVars.floatBufNum, 0, -1, false)
		-- validate the lines, real files
		for i, line in ipairs(lines) do
			if not is_real_file(line) then
				print("Invalid file at slot " .. i)
				return
			end
		end
		M.tracked_files = lines
		path = lines[index] or path

		vim.api.nvim_buf_delete(myVars.floatBufNum, { force = true })
		myVars.floatBufNum = -1
	end

	vim.cmd.edit(path)
end

-- Setup autocommand
function M.setup(opts)
	config = vim.tbl_deep_extend("force", config, opts or {})
	M.tracked_files = {}

	vim.api.nvim_create_autocmd("BufEnter", {
		group = vim.api.nvim_create_augroup(myVars.bufName, { clear = true }),
		callback = function(args)
			M.track_buffer(args.buf)
		end,
	})
end

-- List and open tracked files
function M.list()
	if #M.tracked_files == 0 then
		print("FiveFiles: No tracked files")
		return
	end

	local choices = {}
	local path_to_index = {}

	-- -- Filter again just in case
	-- local valid_files = {}
	-- for _, path in ipairs(M.tracked_files) do
	-- 	if is_real_file(path) then
	-- 		table.insert(valid_files, path)
	-- 	end
	-- end
	-- M.tracked_files = valid_files

	for i, path in ipairs(M.tracked_files) do
		local name = vim.fn.fnamemodify(path, ":~:.")
		local entry = i .. ". " .. name
		table.insert(choices, entry)
		path_to_index[entry] = path
	end

	vim.ui.select(choices, {
		prompt = myVars.bufName .. " - Select a file",
	}, function(choice)
		if choice then
			local path = path_to_index[choice]
			if is_real_file(path) then
				vim.cmd.edit(path)
			else
				print("Selected file is not readable")
			end
		end
	end)
end

function M.harpoon_like()
	-- create a new floating buffer
	local bufnr = vim.api.nvim_create_buf(false, true)
	local width = math.floor(vim.o.columns * 0.5)
	local height = math.floor(vim.o.lines * 0.3)
	local opts = {
		style = "minimal",
		width = width,
		height = height,
		row = math.floor((vim.o.lines - height) / 2),
		col = math.floor((vim.o.columns - width) / 2),
		relative = "editor", -- Required for floating windows
	}
	vim.api.nvim_buf_set_name(bufnr, myVars.bufName)
	vim.api.nvim_open_win(bufnr, true, opts)
	-- set the buffer options
	vim.api.nvim_buf_set_option(bufnr, "filetype", "mama")
	vim.api.nvim_buf_set_option(bufnr, "bufhidden", "wipe")
	vim.api.nvim_buf_set_option(bufnr, "modifiable", true)
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, M.tracked_files)
	vim.api.nvim_win_set_config(0, { border = "rounded" })
	-- set the buffer variable
	myVars.floatBufNum = bufnr
	-- on saving the

	-- set the buffer keymaps
	vim.api.nvim_buf_set_keymap(
		bufnr,
		"n",
		"<CR>",
		"<Cmd>lua require'mama'.goto_file(vim.fn.line('.'))<CR>",
		{ noremap = true, silent = true }
	)

	-- vim.api.nvim_buf_set_keymap(bufnr, "n", "q", "<Cmd>close<CR>", { noremap = true, silent = true })
	-- vim.api.nvim_buf_set_keymap(bufnr, "n", "<esc>", "<Cmd>close<CR>", { noremap = true, silent = true })
end

return M
