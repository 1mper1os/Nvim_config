local M = {}

M.setup = function()

  local ok, oil = pcall(require, "oil")
  if not ok then
    vim.notify("Oil.nvim not found", vim.log.levels.ERROR)
    return
  end

  oil.setup({

    default_file_explorer = true, 
    delete_to_trash = true, 
    skip_confirm_for_simple_edits = true,
    prompt_save_on_select_new_entry = true,

    use_default_keymaps = false, 
    cleanup_delay_ms = 2000,
    lsp_file_methods = {
      timeout_ms = 1000,
      autosave_changes = false,
    },

    watch_for_changes = true,

    columns = {
      "icon",
      {
        "permissions",
        highlight = "Comment",
      },
      {
        "size",
        highlight = "Special",
      },
      {
        "mtime",
        format = "%Y-%m-%d %H:%M",
        highlight = "Number",
      },
    },

    buf_options = {
      buflisted = false,
      bufhidden = "hide",
    },

    win_options = {
      wrap = false,
      signcolumn = "no",
      cursorcolumn = false,
      foldcolumn = "0",
      spell = false,
      list = false,
      conceallevel = 3,
      concealcursor = "nvic",
    },
    

    constrain_cursor = "editable",
    experimental_watch_for_changes = true,

    keymaps = {

      ["g?"] = "actions.show_help",
      ["<CR>"] = "actions.select",
      ["<C-s>"] = { "actions.select", opts = { vertical = true }, desc = "Open in vertical split" },
      ["<C-h>"] = { "actions.select", opts = { horizontal = true }, desc = "Open in horizontal split" },
      ["<C-t>"] = { "actions.select", opts = { tab = true }, desc = "Open in new tab" },
      ["<C-p>"] = "actions.preview",
      ["<C-c>"] = "actions.close",
      ["<C-l>"] = "actions.refresh",
      ["<C-r>"] = "actions.refresh",

      ["q"] = "actions.close",
      ["<esc>"] = "actions.close",
      ["-"] = "actions.parent",
      ["_"] = "actions.open_cwd",
      ["`"] = "actions.cd",
      ["~"] = { "actions.cd", opts = { scope = "tab" }, desc = "cd to the current oil directory" },
      ["gs"] = "actions.change_sort",
      ["gx"] = "actions.open_external",
      ["g."] = "actions.toggle_hidden",
      ["g\\"] = "actions.toggle_trash",

      ["<C-n>"] = "actions.create",
      ["<C-d>"] = "actions.delete",
      ["<C-m>"] = "actions.move",
      ["<C-y>"] = "actions.copy",

      ["<Tab>"] = "actions.select_entry",
      ["<S-Tab>"] = "actions.select_all",
      ["<C-a>"] = "actions.select_all",
    },

    view_options = {
      show_hidden = false,
      is_hidden_file = function(name, bufnr)
        local m = name:match("^%.")
        return m ~= nil
      end,
      is_always_hidden = function(name, bufnr)
        local always_hidden = {
          ".DS_Store",
          ".git",
          "node_modules",
          ".next",
          ".nuxt",
          "dist",
          "build",
          ".cache",
          "__pycache__",
          ".pytest_cache",
          ".mypy_cache",
          "*.pyc",
          "*.pyo",
          "*.swp",
          "*.swo",
          "*~",
          ".vscode",
          ".idea",
        }
        
        for _, pattern in ipairs(always_hidden) do
          if name:match(pattern:gsub("*", ".*")) then
            return true
          end
        end
        return false
      end,
      natural_order = true,
      case_insensitive = false,
      sort = {
        { "type", "asc" },
        { "name", "asc" },
      },
    },

    float = {
      padding = 4,
      max_width = 120,
      max_height = 60,
      border = "rounded",
      win_options = {
        winblend = 0,
        winhl = "Normal:NormalFloat,FloatBorder:FloatBorder",
      },
      preview_split = "auto",
      override = function(conf)
        return conf
      end,
    },

    preview = {
      max_width = 0.9,
      min_width = { 40, 0.4 },
      width = nil,
      max_height = 0.9,
      min_height = { 5, 0.1 },
      height = nil,
      border = "rounded",
      win_options = {
        winblend = 0,
      },
      update_on_cursor_moved = true,
    },

    progress = {
      max_width = 0.9,
      min_width = { 40, 0.4 },
      width = nil,
      max_height = { 10, 0.9 },
      min_height = { 5, 0.1 },
      height = nil,
      border = "rounded",
      minimized_border = "none",
      win_options = {
        winblend = 0,
      },
    },

    ssh = {
      border = "rounded",
    },
  })

  local function setup_keymaps()
    local opts = { noremap = true, silent = true }

    vim.keymap.set("n", "<leader>e", function()
      oil.open()
    end, vim.tbl_extend("force", opts, { desc = "Open parent directory in Oil" }))
    
    vim.keymap.set("n", "<leader>E", function()
      oil.open(vim.fn.getcwd())
    end, vim.tbl_extend("force", opts, { desc = "Open cwd in Oil" }))

    vim.keymap.set("n", "<leader>fe", function()
      oil.open_float()
    end, vim.tbl_extend("force", opts, { desc = "Open Oil in floating window" }))
    
    vim.keymap.set("n", "<leader>fE", function()
      oil.open_float(vim.fn.getcwd())
    end, vim.tbl_extend("force", opts, { desc = "Open cwd in Oil floating window" }))
 
    vim.keymap.set("n", "<leader>th", function()
      oil.toggle_hidden()
    end, vim.tbl_extend("force", opts, { desc = "Toggle hidden files in Oil" }))

    vim.keymap.set("n", "<leader>eo", function()
      oil.open(vim.fn.expand("%:p:h"))
    end, vim.tbl_extend("force", opts, { desc = "Open Oil with current file" }))
  end

  local function setup_autocommands()
    local oil_group = vim.api.nvim_create_augroup("OilConfig", { clear = true })

    vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained" }, {
      group = oil_group,
      pattern = "oil://*",
      callback = function()
        oil.refresh()
      end,
      desc = "Auto-refresh Oil buffer on focus",
    })

    vim.api.nvim_create_autocmd("FileType", {
      group = oil_group,
      pattern = "oil",
      callback = function()
        vim.opt_local.colorcolumn = ""
        vim.opt_local.signcolumn = "no"
        vim.opt_local.statuscolumn = ""
      end,
      desc = "Clean up Oil buffer appearance",
    })
    

    vim.api.nvim_create_autocmd("User", {
      group = oil_group,
      pattern = "OilEnter",
      callback = function(params)

        if vim.bo[params.data.buf].filetype == "oil" then
   
        end
      end,
      desc = "Custom Oil enter logic",
    })
  end

  setup_keymaps()
  setup_autocommands()

  vim.api.nvim_create_user_command("Oil", function(opts)
    if opts.args and opts.args ~= "" then
      oil.open(opts.args)
    else
      oil.open()
    end
  end, {
    nargs = "?",
    complete = "dir",
    desc = "Open Oil file manager",
  })
  
  vim.api.nvim_create_user_command("OilFloat", function(opts)
    if opts.args and opts.args ~= "" then
      oil.open_float(opts.args)
    else
      oil.open_float()
    end
  end, {
    nargs = "?",
    complete = "dir",
    desc = "Open Oil in floating window",
  })
end

return M