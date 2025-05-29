local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
  vim.notify("nvim-tree plugin not found", vim.log.levels.ERROR)
  return
end

nvim_tree.setup({

  disable_netrw = true,
  hijack_netrw = true,
  hijack_cursor = true,
  hijack_directories = {
    enable = true,
    auto_open = true,
  },
  update_focused_file = {
    enable = true,
    update_root = true,
    ignore_list = {},
  },
  reload_on_bufenter = true,
  respect_buf_cwd = true,

  diagnostics = {
    enable = true,
    show_on_dirs = true,
    show_on_open_dirs = true,
    debounce_delay = 50,
    severity = {
      min = vim.diagnostic.severity.HINT,
      max = vim.diagnostic.severity.ERROR,
    },
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
  },

  renderer = {
    add_trailing = false,
    group_empty = true,
    highlight_git = true,
    full_name = false,
    highlight_opened_files = "icon",
    highlight_modified = "name",
    root_folder_label = ":~:s?$?/..?",

    indent_markers = {
      enable = true,
      inline_arrows = true,
      icons = {
        corner = "└",
        edge = "│",
        item = "│",
        bottom = "─",
        none = " ",
      },
    },

    icons = {
      webdev_colors = true,
      git_placement = "before",
      modified_placement = "after",
      padding = " ",
      symlink_arrow = " ➛ ",
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
        modified = true,
        diagnostics = true,
        bookmarks = true,
      },
      glyphs = {
        default = "",
        symlink = "",
        bookmark = "󰆤",
        modified = "●",
        folder = {
          arrow_closed = "",
          arrow_open = "",
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
          symlink_open = "",
        },
        git = {
          unstaged = "✗",
          staged = "✓",
          unmerged = "",
          renamed = "➜",
          untracked = "★",
          deleted = "",
          ignored = "◌",
        },
      },
    },

    special_files = { 
      "Cargo.toml", 
      "Makefile", 
      "README.md", 
      "readme.md",
      "package.json",
      "yarn.lock",
      "package-lock.json",
    },
  },

  filters = {
    dotfiles = false,
    git_clean = false,
    no_buffer = false,
    custom = { "^.git$", "node_modules", ".cache" },
    exclude = { ".gitignore", ".env.example" },
  },

  view = {
    centralize_selection = false,
    cursorline = true,
    debounce_delay = 15,
    width = {
      min = 30,
      max = 60,
    },
    side = "left",
    preserve_window_proportions = true,
    number = false,
    relativenumber = false,
    signcolumn = "yes",

    float = {
      enable = false,
      quit_on_focus_loss = true,
      open_win_config = {
        relative = "editor",
        border = "rounded",
        width = 60,
        height = 30,
        row = 1,
        col = 1,
      },
    },
  },

  actions = {
    use_system_clipboard = true,
    change_dir = {
      enable = true,
      global = false,
      restrict_above_cwd = false,
    },
    expand_all = {
      max_folder_discovery = 300,
      exclude = { ".git", "target", "build" },
    },
    file_popup = {
      open_win_config = {
        col = 1,
        row = 1,
        relative = "cursor",
        border = "shadow",
        style = "minimal",
      },
    },
    open_file = {
      quit_on_open = false,
      resize_window = true,
      window_picker = {
        enable = true,
        picker = "default",
        chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
        exclude = {
          filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
          buftype = { "nofile", "terminal", "help" },
        },
      },
    },
    remove_file = {
      close_window = true,
    },
  },

  notify = {
    threshold = vim.log.levels.INFO,
  },

  log = {
    enable = false,
    truncate = false,
    types = {
      all = false,
      config = false,
      copy_paste = false,
      dev = false,
      diagnostics = false,
      git = false,
      profile = false,
      watcher = false,
    },
  },

  filesystem_watchers = {
    enable = true,
    debounce_delay = 50,
    ignore_dirs = {
      "node_modules",
      ".git",
      ".cache",
    },
  },

  git = {
    enable = true,
    ignore = true,
    show_on_dirs = true,
    show_on_open_dirs = true,
    timeout = 400,
  },

  modified = {
    enable = true,
    show_on_dirs = true,
    show_on_open_dirs = true,
  },

  tab = {
    sync = {
      open = false,
      close = false,
      ignore = {},
    },
  },

  trash = {
    cmd = "gio trash",
  },

  live_filter = {
    prefix = "[FILTER]: ",
    always_show_folders = true,
  },
})

local function nvim_tree_on_attach(bufnr)
  local api = require("nvim-tree.api")
  
  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  api.config.mappings.default_on_attach(bufnr)

  vim.keymap.set('n', '<C-t>', api.tree.change_root_to_parent,        opts('Up'))
  vim.keymap.set('n', '?',     api.tree.toggle_help,                  opts('Help'))
  vim.keymap.set('n', 'l',     api.node.open.edit,                    opts('Open'))
  vim.keymap.set('n', 'h',     api.node.navigate.parent_close,        opts('Close Directory'))
  vim.keymap.set('n', 'v',     api.node.open.vertical,                opts('Open: Vertical Split'))
  vim.keymap.set('n', 's',     api.node.open.horizontal,              opts('Open: Horizontal Split'))
  vim.keymap.set('n', '<C-v>', api.node.open.vertical,                opts('Open: Vertical Split'))
  vim.keymap.set('n', '<C-x>', api.node.open.horizontal,              opts('Open: Horizontal Split'))
end

nvim_tree.setup({
  on_attach = nvim_tree_on_attach,
})

local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", 
  vim.tbl_extend("force", opts, { desc = "Toggle NvimTree" }))
vim.keymap.set("n", "<leader>ef", "<cmd>NvimTreeFocus<CR>", 
  vim.tbl_extend("force", opts, { desc = "Focus NvimTree" }))
vim.keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", 
  vim.tbl_extend("force", opts, { desc = "Refresh NvimTree" }))
vim.keymap.set("n", "<leader>ec", "<cmd>NvimTreeClose<CR>", 
  vim.tbl_extend("force", opts, { desc = "Close NvimTree" }))
vim.keymap.set("n", "<leader>es", "<cmd>NvimTreeResize 50<CR>", 
  vim.tbl_extend("force", opts, { desc = "Resize NvimTree" }))

vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("NvimTreeClose", {clear = true}),
  pattern = "NvimTree_*",
  callback = function()
    local layout = vim.api.nvim_call_function("winlayout", {})
    if layout[1] == "leaf" and vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(layout[2]), "filetype") == "NvimTree" and layout[3] == nil then
      vim.cmd("confirm quit")
    end
  end
})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function(data)
 
    local directory = vim.fn.isdirectory(data.file) == 1

    if not directory then
      return
    end

    vim.cmd.cd(data.file)

    require("nvim-tree.api").tree.open()
  end,
})