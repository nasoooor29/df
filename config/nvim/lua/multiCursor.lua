local opts = { noremap = true, silent = true }

function SendKeys(command, mode)
	if mode == nil then
		mode = "n"
	end
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(command, true, true, true), mode, false)
end

vim.keymap.set("n", "<leader>ra", function()
	local word = vim.fn.expand("<cword>")
	local replacement = vim.fn.input('Replace "' .. word .. '" with: ')
	if replacement ~= "" then
		SendKeys(":%s/\\<" .. word .. "\\>/" .. replacement .. "/gc")
	else
		print("No replacement provided. Aborting.")
	end
end, opts)

vim.keymap.set("n", "<leader>ri", function()
	local command = ":%s/\\<" .. vim.fn.expand("<cword>") .. "\\>//g"
	SendKeys(command)
	SendKeys("<Left><Left>")
end, opts)

word_to_edit = ""

vim.keymap.set("v", "co", function()
	SendKeys("y")
	word_to_edit = vim.fn.getreg('"')
	if word_to_edit == "" then
		print("No word/selection to apply the macro to!")
		return
	end
	SendKeys("qz")
end, opts)

vim.keymap.set("n", "co", function()
	word_to_edit = vim.fn.expand("<cword>")
	if word_to_edit == "" then
		print("No word to apply the macro to!")
		return
	end
	SendKeys("qz")
end, opts)

vim.keymap.set("n", "cp", function()
	if word_to_edit == "" then
		print("No word to apply the macro to!")
		return
	end
	SendKeys("/\v" .. word_to_edit .. "\n")
	SendKeys("n")
	SendKeys("@z")
end, opts)
