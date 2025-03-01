local status_ok, flash = pcall(require, "flash")
if not status_ok then
	return
end

flash.setup({
	modes = {
		search = {
			enabled = true,
			highlight = { backdrop = true },
		},
		char = {
			enabled = true,
			keys = { "f", "F", "t", "T" },
		},
		treesitter = {
			enabled = true,
			labels = { "a", "s", "d", "f", "g", "h", "j", "k", "l" },
		},
		jump = {
			enabled = true,
			autojump = true,
		},
	},

	highlight = {
		backdrop = true,
		matches = true,
		current = true,
	},

	labels = "abcdefghijklmnopqrstuvwxyz",
})
