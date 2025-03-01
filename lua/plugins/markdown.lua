local status_ok, markdown_preview = pcall(require, "mkdp")
if not status_ok then
	return
end

vim.g.mkdp_auto_start = 0
vim.g.mkdp_auto_close = 1
vim.g.mkdp_refresh_slow = 0
vim.g.mkdp_command_for_global = 0
vim.g.mkdp_open_to_the_world = 0
vim.g.mkdp_open_ip = ""
vim.g.mkdp_browser = ""
vim.g.mkdp_echo_preview_url = 1
vim.g.mkdp_port = ""

vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreview<CR>", { desc = "Abrir vista previa de Markdown" })
vim.keymap.set("n", "<leader>ms", "<cmd>MarkdownPreviewStop<CR>", { desc = "Detener vista previa de Markdown" })
vim.keymap.set("n", "<leader>mt", "<cmd>MarkdownPreviewToggle<CR>", { desc = "Alternar vista previa de Markdown" })
