local status_ok, go = pcall(require, "go")
if not status_ok then
	return
end

go.setup({
	goimport = "gopls",
	gofmt = "gofmt",
	max_line_len = 120,
	tag_transform = false,
	test_dir = "",
	comment_placeholder = "   ",
	lsp_cfg = true,
	lsp_gofumpt = true,
	lsp_on_attach = nil,
	dap_debug = true,
	dap_debug_keymap = true,
	dap_debug_gui = true,
	textobjects = true,
	verbose = false,
	trouble = false,
})

vim.keymap.set("n", "<leader>gt", "<cmd>GoTest<CR>", { desc = "Ejecutar pruebas de Go" })
vim.keymap.set("n", "<leader>gf", "<cmd>GoFmt<CR>", { desc = "Formatear código Go" })
vim.keymap.set("n", "<leader>gi", "<cmd>GoImport<CR>", { desc = "Importar paquetes Go" })
vim.keymap.set("n", "<leader>gd", "<cmd>GoDebug<CR>", { desc = "Iniciar depuración Go" })
vim.keymap.set("n", "<leader>gc", "<cmd>GoCoverage<CR>", { desc = "Ver cobertura de pruebas Go" })
