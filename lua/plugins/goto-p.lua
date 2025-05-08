local goto_preview = require("goto-preview")

goto_preview.setup({
	default_mappings = true,
	width = 120,
	height = 15,
	border = "rounded",
	dismiss_on_move = false,
	focus_on_open = true,
	opacity = nil,
	resizing_mappings = false,
	post_open_hook = nil,
})

vim.keymap.set("n", "gpd", goto_preview.goto_preview_definition, { desc = "Preview Definition" })
vim.keymap.set("n", "gpt", goto_preview.goto_preview_type_definition, { desc = "Preview Type Definition" })
vim.keymap.set("n", "gpi", goto_preview.goto_preview_implementation, { desc = "Preview Implementation" })
vim.keymap.set("n", "gpr", goto_preview.goto_preview_references, { desc = "Preview References" })
vim.keymap.set("n", "gP", goto_preview.close_all_win, { desc = "Close All Previews" })
