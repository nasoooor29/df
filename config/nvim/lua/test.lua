-- Function to capture selected text and mamait
local function send_keys(keys, mode)
	local feedkeys = vim.api.nvim_replace_termcodes(keys, true, false, true)
	vim.api.nvim_feedkeys(feedkeys, mode, true)
end
local function mama_visual_selection()
	-- Get the current visual selection
	local start_pos = vim.fn.getpos("'<")
	local end_pos = vim.fn.getpos("'>")
	local lines = vim.fn.getline(start_pos[2], end_pos[2])
	print("finished")
	print(start_pos)
	print(end_pos)
	print(lines)

	-- Adjust the range for partial line selections
	lines[1] = string.sub(lines[1], start_pos[3], -1)
	lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])

	-- Join the selected lines into a single string
	local selected_text = table.concat(lines, "\n")
	print("mamadada: " .. selected_text)

	-- Print the selected text

	-- Example usage: Simulate pressing `iHello<Esc>`
	send_keys("<ESC>o" .. selected_text .. "<Esc>", "n")
end

-- Set up a keymap in visual mode
vim.keymap.set("v", "<leader>k", mama_visual_selection, { noremap = true, silent = true })
