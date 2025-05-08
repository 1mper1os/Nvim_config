-- lua/plugins/oil-config.lua

local M = {}

M.setup = function()
	require("oil").setup({
		default_file_explorer = false,

		columns = {
			"icon",
			"permissions",
			"size",
			"mtime",
		},

		show_path = "relative", -- opciones: "none", "relative", "absolute"

		float = {
			padding = 2,
			max_width = 100,
			max_height = 50,
			border = "rounded",
			win_options = {
				winblend = 10,
			},
		},

		keymaps = {
			["g?"] = "actions.show_help",
			["<CR>"] = "actions.select",
			["<C-s>"] = "actions.select_vsplit",
			["<C-h>"] = "actions.select_split",
			["<C-t>"] = "actions.select_tab",
			["<C-p>"] = "actions.preview",
			["<C-c>"] = "actions.close",
			["<C-l>"] = "actions.refresh",
			["q"] = "actions.close",
			["<esc>"] = "actions.close",
		},

		skip_confirm_for_simple_edits = true,
		use_clock_cache = true,
		use_libuv_file_watcher = true,
	})

	vim.keymap.set("n", "<leader>e", function()
		require("oil").open()
	end, { desc = "Open parent directory in Oil" })
end

return M
