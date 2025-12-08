return {
	enabled = false,
	"nanotee/sqls.nvim",
	config = function()
		require('lspconfig').sqls.setup {
			settings = {
				connections = {
					driver = "postgresql",
					dataSourceName = "host=10.0.128.155:5432 port=5432 user=postgres password=1jz.CC-29 dbname=postgres sslmode=disable",
				},
			},
			on_attach = function(client, bufnr)
				require('sqls').on_attach(client, bufnr)
			end
		}
	end
}
