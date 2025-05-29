local status_ok, treesitter_configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
  vim.notify("nvim-treesitter not found", vim.log.levels.ERROR)
  return
end

-- Lista de parsers a instalar
local ensure_installed_parsers = {
  "bash",
  "c",
  "cpp",
  "css",
  "go",
  "html",
  "javascript",
  "json",
  "lua",
  "python",
  "rust",
  "tsx",
  "typescript",
  "yaml",
  "dockerfile",
  "gitignore",
  "graphql",
  "java",
  "php",
  "scss",
  "sql",
  "vue",
  "xml",
  "markdown",
  "markdown_inline",
  "toml",
  "vim",
  "vimdoc",
  "regex",
  "comment",
  "diff",
  "gitcommit",
  "query",
}

-- Filetypes que deben ser ignorados por Treesitter
local ignored_filetypes = {
  "NvimTree",
  "qf",
  "help",
  "man",
  "git",
  "fugitive",
  "TelescopePrompt",
  "packer",
  "neo-tree",
  "alpha",
  "dashboard",
  "toggleterm",
}

treesitter_configs.setup({
  ensure_installed = ensure_installed_parsers,
  sync_install = false,
  auto_install = true,
  ignore_install = { "phpdoc" },
  
  highlight = {
    enable = true,
    disable = function(lang, buf)
      local max_filesize = 100 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
      
      -- Deshabilitar para filetypes ignorados
      local filetype = vim.api.nvim_buf_get_option(buf, "filetype")
      if vim.tbl_contains(ignored_filetypes, filetype) then
        return true
      end
    end,
    additional_vim_regex_highlighting = false,
  },
  
  indent = {
    enable = true,
    disable = { "yaml", "python" },
  },
  
  autotag = {
    enable = true,
    enable_rename = true,
    enable_close = true,
    enable_close_on_slash = true,
    filetypes = {
      'html', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact',
      'svelte', 'vue', 'tsx', 'jsx', 'rescript', 'xml', 'php', 'markdown',
      'astro', 'glimmer', 'handlebars', 'hbs'
    },
  },
  
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<C-space>",
      node_incremental = "<C-space>",
      scope_incremental = "<C-s>",
      node_decremental = "<M-space>",
    },
  },
  
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["ai"] = "@conditional.outer",
        ["ii"] = "@conditional.inner",
        ["al"] = "@loop.outer",
        ["il"] = "@loop.inner",
        ["ap"] = "@parameter.outer",
        ["ip"] = "@parameter.inner",
        ["aC"] = "@comment.outer",
        ["iC"] = "@comment.inner",
        ["ab"] = "@block.outer",
        ["ib"] = "@block.inner",
        ["a="] = "@assignment.outer",
        ["i="] = "@assignment.inner",
        ["l="] = "@assignment.lhs",
        ["r="] = "@assignment.rhs",
        ["aa"] = "@call.outer",
        ["ia"] = "@call.inner",
      },
      selection_modes = {
        ['@parameter.outer'] = 'v',
        ['@function.outer'] = 'V',
        ['@class.outer'] = '<c-v>',
      },
      include_surrounding_whitespace = true,
    },
 
    swap = {
      enable = true,
      swap_next = {
        ["<leader>a"] = "@parameter.inner",
        ["<leader>f"] = "@function.outer",
        ["<leader>e"] = "@element",
      },
      swap_previous = {
        ["<leader>A"] = "@parameter.inner",
        ["<leader>F"] = "@function.outer",
        ["<leader>E"] = "@element",
      },
    },

    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer",
        ["]o"] = "@loop.*",
        ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
        ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
        ["[o"] = "@loop.*",
        ["[s"] = { query = "@scope", query_group = "locals", desc = "Previous scope" },
        ["[z"] = { query = "@fold", query_group = "folds", desc = "Previous fold" },
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
      goto_next = {
        ["]d"] = "@conditional.outer",
      },
      goto_previous = {
        ["[d"] = "@conditional.outer",
      },
    },

    lsp_interop = {
      enable = true,
      border = 'none',
      floating_preview_opts = {},
      peek_definition_code = {
        ["<leader>df"] = "@function.outer",
        ["<leader>dF"] = "@class.outer",
      },
    },
  },

  context = {
    enable = true,
    max_lines = 0,
    min_window_height = 0,
    line_numbers = true,
    multiline_threshold = 20,
    trim_scope = 'outer',
    mode = 'cursor',
    separator = nil,
    zindex = 20,
    on_attach = function(buf)
      local filetype = vim.bo[buf].filetype
      return not vim.tbl_contains({'markdown'}, filetype) and 
             not vim.tbl_contains(ignored_filetypes, filetype)
    end,
  },
 
  playground = {
    enable = true,
    disable = {},
    updatetime = 25,
    persist_queries = false,
    keybindings = {
      toggle_query_editor = 'o',
      toggle_hl_groups = 'i',
      toggle_injected_languages = 't',
      toggle_anonymous_nodes = 'a',
      toggle_language_display = 'I',
      focus_language = 'f',
      unfocus_language = 'F',
      update = 'R',
      goto_node = '<cr>',
      show_help = '?',
    },
  },
 
  query_linter = {
    enable = true,
    use_virtual_text = true,
    lint_events = {"BufWrite", "CursorHold"},
  },
})

-- Configuración de folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false

-- Funciones y keymaps
local function toggle_fold()
  if vim.opt.foldmethod:get() == "expr" then
    vim.opt.foldenable = not vim.opt.foldenable:get()
  end
end

local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<leader>tf", toggle_fold, 
  vim.tbl_extend("force", opts, { desc = "Toggle Treesitter Folding" }))

vim.keymap.set("n", "<leader>tp", "<cmd>TSPlaygroundToggle<CR>", 
  vim.tbl_extend("force", opts, { desc = "Toggle Treesitter Playground" }))

vim.keymap.set("n", "<leader>th", "<cmd>TSHighlightCapturesUnderCursor<CR>", 
  vim.tbl_extend("force", opts, { desc = "Show Treesitter Highlights" }))

local function show_node_info()
  local ts_utils = require('nvim-treesitter.ts_utils')
  local node = ts_utils.get_node_at_cursor()
  if node then
    print("Node type: " .. node:type())
    print("Node text: " .. vim.inspect(ts_utils.get_node_text(node)))
  else
    print("No node found at cursor")
  end
end

vim.keymap.set("n", "<leader>tn", show_node_info, 
  vim.tbl_extend("force", opts, { desc = "Show Treesitter Node Info" }))

-- Autocomandos
local treesitter_group = vim.api.nvim_create_augroup("TreesitterConfig", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = treesitter_group,
  callback = function(args)
    local filetype = vim.bo[args.buf].filetype
    
    -- Ignorar filetypes específicos
    if vim.tbl_contains(ignored_filetypes, filetype) then
      return
    end
    
    local lang = vim.treesitter.language.get_lang(filetype)
    if lang and not vim.tbl_contains(ensure_installed_parsers, lang) then
      pcall(vim.cmd, "TSInstall " .. lang)
    end
  end,
})

vim.api.nvim_create_autocmd("VimEnter", {
  group = treesitter_group,
  callback = function()
    local last_update = vim.fn.getftime(vim.fn.stdpath("data") .. "/treesitter_last_update")
    local current_time = vim.fn.localtime()
    if current_time - last_update > 86400 then -- 1 día en segundos
      vim.defer_fn(function()
        pcall(vim.cmd, "TSUpdate")
        vim.fn.writefile({tostring(current_time)}, vim.fn.stdpath("data") .. "/treesitter_last_update")
      end, 1000)
    end
  end,
})

vim.api.nvim_create_autocmd("BufReadPre", {
  group = treesitter_group,
  callback = function(args)
    local buf = args.buf
    local filetype = vim.api.nvim_buf_get_option(buf, "filetype")
    
    -- Ignorar filetypes específicos
    if vim.tbl_contains(ignored_filetypes, filetype) then
      return
    end
    
    local byte_size = vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
    if byte_size > 1024 * 1024 then -- 1 MB
      vim.treesitter.stop(buf)
      vim.bo[buf].syntax = ""
      vim.notify("Large file detected, Treesitter disabled", vim.log.levels.WARN)
    end
  end,
})