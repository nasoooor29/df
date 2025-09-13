local function ra_flycheck()
	local clients = vim.lsp.get_clients({
		name = "rust_analyzer",
	})
	for _, client in ipairs(clients) do
		local params = vim.lsp.util.make_text_document_params()
		client.notify("rust-analyzer/runFlycheck", params)
	end
end

vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
	pattern = "*.rs",
	callback = function()
		vim.cmd("w")
		ra_flycheck()
	end,
})
return {}
