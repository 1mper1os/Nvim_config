
local renderer = {

  icons = {

    show = {
      file = true,
      folder = true,
      folder_arrow = true,
      git = true,
      modified = true,
      diagnostics = true,
      bookmarks = true,
    },
    

    webdev_colors = true,
    git_placement = "before",
    modified_placement = "after",
    diagnostics_placement = "signcolumn",
    bookmarks_placement = "signcolumn",
    

    glyphs = {
      default = "󰈚",
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
  

  indent_width = 2,
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
  

  highlight_git = true,
  highlight_diagnostics = true,
  highlight_opened_files = "all",
  highlight_modified = "all",
  highlight_bookmarks = "all",
  

  group_empty = true,
  

  root_folder_label = function(path)
  
    local project_name = vim.fn.fnamemodify(path, ":t")
    if project_name == "" then
      return "/"
    end
    return "󱉭 " .. project_name
  end,

  special_files = {
    "Cargo.toml",
    "Makefile",
    "README.md",
    "readme.md",
    "CMakeLists.txt",
    "package.json",
    "tsconfig.json",
    "tailwind.config.js",
    "vite.config.js",
    "webpack.config.js",
    "docker-compose.yml",
    "Dockerfile",
    ".gitignore",
    ".env",
    ".env.local",
    "pom.xml",
    "build.gradle",
    "requirements.txt",
    "setup.py",
    "go.mod",
    "composer.json",
    "pubspec.yaml",
  },
  

  symlink_destination = true,
  

  add_trailing = true,
  

  filter = {
    enable = true,
    dotfiles = false,
    git_clean = false,
    no_buffer = false,
    custom = {
      "^\\.git$",
      "node_modules",
      "\\.cache",
      "__pycache__",
      "\\.pyc$",
      "\\.pyo$",
      "\\.DS_Store$",
      "thumbs\\.db$",
      "\\.tmp$",
      "\\.swp$",
      "\\.swo$",
      "~$",
    },
    exclude = {
      ".env",
      ".env.local",
      ".gitignore",
      "README.md",
      "package.json",
      "tsconfig.json",
    },
  },
}


local function setup_highlights()
  
  local highlights = {
    NvimTreeFolderIcon = { fg = "#7AA2F7" },
    NvimTreeFolderName = { fg = "#7AA2F7", bold = true },
    NvimTreeOpenedFolderName = { fg = "#7AA2F7", bold = true, italic = true },
    NvimTreeEmptyFolderName = { fg = "#7AA2F7" },
    NvimTreeIndentMarker = { fg = "#3B4261" },
    NvimTreeRootFolder = { fg = "#BB9AF7", bold = true },
    NvimTreeSymlink = { fg = "#73DACA" },
    NvimTreeSpecialFile = { fg = "#F7768E", underline = true },
    NvimTreeImageFile = { fg = "#AD8EE6" },
    NvimTreeMarkdownFile = { fg = "#41A6B5" },

    NvimTreeGitDirty = { fg = "#E0AF68" },
    NvimTreeGitStaged = { fg = "#9ECE6A" },
    NvimTreeGitMerge = { fg = "#F7768E" },
    NvimTreeGitRenamed = { fg = "#73DACA" },
    NvimTreeGitNew = { fg = "#9ECE6A" },
    NvimTreeGitDeleted = { fg = "#F7768E" },
    NvimTreeGitIgnored = { fg = "#565F89" },

    NvimTreeExecFile = { fg = "#9ECE6A", bold = true },
    NvimTreeOpenedFile = { fg = "#C0CAF5", italic = true },
    NvimTreeModifiedFile = { fg = "#E0AF68" },
  }

  for group, settings in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, settings)
  end
end

local function setup_autocommands()
  local augroup = vim.api.nvim_create_augroup("NvimTreeRenderer", { clear = true })

  vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
    group = augroup,
    callback = function()
      local nvim_tree_api = require("nvim-tree.api")
      if nvim_tree_api.tree.is_visible() then
        nvim_tree_api.tree.reload()
      end
    end,
  })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "NvimTree",
    group = augroup,
    callback = function()
      setup_highlights()
      
      vim.opt_local.wrap = false
      vim.opt_local.spell = false
      vim.opt_local.signcolumn = "yes"
    end,
  })
end

local function get_project_stats()
  local handle = io.popen("find . -type f -name '*.lua' -o -name '*.js' -o -name '*.ts' -o -name '*.py' -o -name '*.go' -o -name '*.rs' | wc -l")
  if handle then
    local result = handle:read("*a")
    handle:close()
    return " [" .. string.gsub(result, "\n", "") .. " archivos]"
  end
  return ""
end

renderer.root_folder_label = function(path)
  local project_name = vim.fn.fnamemodify(path, ":t")
  if project_name == "" then
    return "/"
  end

  local project_icon = "󱉭"
  if vim.fn.filereadable(path .. "/package.json") == 1 then
    project_icon = ""
  elseif vim.fn.filereadable(path .. "/Cargo.toml") == 1 then
    project_icon = ""
  elseif vim.fn.filereadable(path .. "/go.mod") == 1 then
    project_icon = ""
  elseif vim.fn.filereadable(path .. "/requirements.txt") == 1 or vim.fn.filereadable(path .. "/setup.py") == 1 then
    project_icon = ""
  elseif vim.fn.filereadable(path .. "/pom.xml") == 1 or vim.fn.filereadable(path .. "/build.gradle") == 1 then
    project_icon = ""
  end
  
  return project_icon .. " " .. project_name .. get_project_stats()
end

local function setup_dynamic_filters()
  local git_ignored = {}

  local gitignore_path = vim.fn.getcwd() .. "/.gitignore"
  if vim.fn.filereadable(gitignore_path) == 1 then
    for line in io.lines(gitignore_path) do
      if line ~= "" and not line:match("^#") then
        table.insert(git_ignored, line)
      end
    end

    for _, pattern in ipairs(git_ignored) do
      table.insert(renderer.filter.custom, pattern)
    end
  end
end

local function init()
  setup_autocommands()
  setup_dynamic_filters()
end

init()

return renderer