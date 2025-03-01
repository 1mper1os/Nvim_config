local status_ok, conform = pcall(require, "conform")
if not status_ok then
	return
end

conform.setup({
	formatters_by_ft = {
		lua = { "stylua" },
		javascript = { "prettier" },
		typescript = { "prettier" },
		javascriptreact = { "prettier" },
		typescriptreact = { "prettier" },
		python = { "black", "isort" },
		html = { "prettier" },
		css = { "prettier" },
		json = { "prettier" },
		markdown = { "prettier" },
		yaml = { "prettier" },
	},

	formatters = {
		prettier = {
			prepend_args = { "--no-semi", "--single-quote" },
		},
		black = {
			prepend_args = { "--line-length=88" },
		},
	},

	format_on_save = {
		timeout_ms = 500,
		lsp_fallback = true,
	},

	keys = {
		{
			"<leader>cf",
			function()
				conform.format({ async = true, lsp_fallback = true })
			end,
			desc = "Formatear buffer",
		},
	},
})
