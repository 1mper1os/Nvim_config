local status_ok, twilight = pcall(require, "twilight")
if not status_ok then
	return
end

twilight.setup({
	dimming = {
		alpha = 0.25,
		color = { "Normal", "#000000" },
		inactive = false,
	},

	context = 10,

	treesitter = true,
	expand = {
		open_folds = true,
		open_folds_on_enter = true,
	},

	on_open = function()
		vim.cmd("set laststatus=0")
	end,

	on_close = function()
		vim.cmd("set laststatus=2")
	end,
})
