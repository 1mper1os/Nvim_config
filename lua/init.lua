local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- configuracion para iconos
	{
		"nvim-tree/nvim-web-devicons",
	},

	-- configuracion para tema
	{
		"navarasu/onedark.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("plugins.tema")
		end,
	},

	-- confiracion de mason
	{
		"williamboman/mason.nvim",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		config = function()
			require("plugins.mason")
		end,
	},

	-- confiracoin de telescope

	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("plugins.telescope")
		end,
	},

	-- configuracion de cmp
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"saadparwaiz1/cmp_luasnip",
			"L3MON4D3/LuaSnip",
			"rafamadriz/friendly-snippets",
		},
		config = function()
			require("plugins.cmp")
		end,
	},

	-- configuracion de harpoon-lualine
	{
		"letieu/harpoon-lualine",
		dependencies = {
			{
				"ThePrimeagen/harpoon",
				branch = "harpoon2",
			},
		},
		config = function()
			require("plugins.harpoon")
		end,
	},

	-- configuracion de toogle-term
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			require("plugins.toggle")
		end,
	},

	-- configuracion de nvim-autopairs
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("plugins.auto")
		end,
	},

	-- configuracion de Comment
	{
		"numToStr/Comment.nvim",
		event = "VeryLazy",
		config = function()
			require("plugins.comment")
		end,
	},

	-- configuracion de blankline
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {},
		config = function()
			require("plugins.blankline")
		end,
	},
	-- configuracion de lualine
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("plugins.lualine")
		end,
	},
	-- configuracion de bufferline
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
    "echasnovski/mini.bufremove",
		config = function()
			require("plugins.buffer")
		end,
	},
	{
		"roobert/tailwindcss-colorizer-cmp.nvim",
		config = function()
			require("plugins.tail")
		end,
	},
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		opts = {},
		config = function()
			require("plugins.typs")
		end,
	},
	{
		"stevearc/conform.nvim",
		opts = {},
		config = function()
			require("plugins.conform")
		end,
	},
	{
		"iamcco/markdown-preview.nvim",
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
		ft = { "markdown" },
		config = function()
			require("plugins.markdown")
		end,
	},
	{
		"ray-x/go.nvim",
		dependencies = {
			"ray-x/guihua.lua",
			"neovim/nvim-lspconfig",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("plugins.go")
		end,
		event = { "CmdlineEnter" },
		ft = { "go", "gomod" },
		build = ':lua require("go.install").update_all_sync()',
	},
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {},
		config = function()
			require("plugins.flash")
		end,
	},
	{
		"kylechui/nvim-surround",
		version = "*",
		event = "VeryLazy",
		config = function()
			require("plugins.surround")
		end,
	},
	{
		"folke/trouble.nvim",
		opts = {},
		config = function()
			require("plugins.trouble")
		end,
	},
	{
		"folke/zen-mode.nvim",
		opts = {},
		config = function()
			require("plugins.zen")
		end,
	},
	{
		"kevinhwang91/nvim-ufo",
		dependencies = { "kevinhwang91/promise-async" },
		config = function()
			require("plugins.ufo")
		end,
	},
	{
		"folke/twilight.nvim",
		opts = {},
		config = function()
			require("plugins.twilight")
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("plugins.treesitter")
		end,
	},
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("plugins.tree")
		end,
	},
	{
		"rmagatti/goto-preview",
		config = function()
			require("plugins.goto-p")
		end,
	},
	{
		"stevearc/oil.nvim",
		lazy = true,
		config = function()
			require("plugins.oil").setup()
		end,
		keys = {
			{ "<leader>e", desc = "Explorer (Oil)" },
		},
	},
})
