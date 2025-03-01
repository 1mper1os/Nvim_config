local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
	return
end

nvim_tree.setup({
	disable_netrw = true,
	hijack_netrw = true,
	hijack_cursor = true,
	update_cwd = true,

	diagnostics = {
		enable = true,
		show_on_dirs = true,
		icons = {
			hint = "",
			info = "",
			warning = "",
			error = "",
		},
	},

	renderer = {
		add_trailing = false,
		group_empty = true,
		highlight_git = true,
		root_folder_label = ":~:s?$?/..?",
		indent_markers = {
			enable = true,
			icons = {
				corner = "└ ",
				edge = "│ ",
				item = "│ ",
			},
		},
		icons = {
			webdev_colors = true,
			git_placement = "before",
			padding = " ",
			symlink_arrow = " ➛ ",
			show = {
				file = true,
				folder = true,
				folder_arrow = true,
				git = true,
			},
		},
	},

	filters = {
		dotfiles = false,
		custom = {},
	},

	view = {
		width = 30,
		side = "left",
		preserve_window_proportions = true,
		number = false,
		relativenumber = false,
		signcolumn = "yes",
	},

	actions = {
		open_file = {
			quit_on_open = true,
			resize_window = true,
		},
	},
})
vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle NvimTree" })
