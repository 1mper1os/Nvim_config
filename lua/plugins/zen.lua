local status_ok, zen_mode = pcall(require, "zen-mode")
if not status_ok then
	return
end

zen_mode.setup({
	window = {
		backdrop = 0.45,
		width = 120,
		height = 1,
		options = {
			number = false,
			relativenumber = false,
			cursorline = true,
			signcolumn = "no",
		},
	},

	plugins = {
		gitsigns = true,
		tmux = false,
		twilight = true,
	},

	on_open = function(win)
		vim.cmd("set laststatus=0")
	end,

	on_close = function()
		vim.cmd("set laststatus=2")
	end,
})
vim.keymap.set("n", "<leader>z", "<cmd>ZenMode<CR>", { desc = "Toggle Zen Mode" })
