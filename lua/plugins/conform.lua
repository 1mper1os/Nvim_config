
local status_ok, conform = pcall(require, "conform")
if not status_ok then
  vim.notify("Failed to load conform.nvim", vim.log.levels.ERROR)
  return
end

conform.setup({
  
  formatters_by_ft = {
    
    lua = { "stylua" },
    python = { "black", "isort" },
    rust = { "rustfmt" },
    go = { "gofmt", "goimports" },
    c = { "clang_format" },
    cpp = { "clang_format" },
    java = { "google-java-format" },
    
    
    javascript = { "prettier", "eslint_d" },
    typescript = { "prettier", "eslint_d" },
    javascriptreact = { "prettier", "eslint_d" },
    typescriptreact = { "prettier", "eslint_d" },
    vue = { "prettier" },
    svelte = { "prettier" },
    
    
    html = { "prettier" },
    css = { "prettier" },
    scss = { "prettier" },
    less = { "prettier" },
    json = { "prettier" },
    jsonc = { "prettier" },
    yaml = { "prettier" },
    toml = { "taplo" },
    xml = { "xmlformat" },
    
    
    markdown = { "prettier", "markdownlint" },
    
    
    dockerfile = { "dockerfilelint" },
    
    
    sh = { "shfmt" },
    bash = { "shfmt" },
    zsh = { "shfmt" },
    
    
    sql = { "sqlfmt" },
    graphql = { "prettier" },
  },

  
  formatters = {
    
    prettier = {
      prepend_args = { 
        "--no-semi", 
        "--single-quote", 
        "--jsx-single-quote",
        "--trailing-comma", "es5",
        "--print-width", "100",
        "--tab-width", "2",
      },
    },
    
    
    black = {
      prepend_args = { 
        "--line-length=88", 
        "--skip-string-normalization" 
      },
    },
    
    
    stylua = {
      prepend_args = { 
        "--indent-type", "Spaces", 
        "--indent-width", "2",
        "--column-width", "100",
      },
    },
    
    
    eslint_d = {
      args = { "--fix-to-stdout", "--stdin", "--stdin-filename", "$FILENAME" },
    },
    
    
    shfmt = {
      prepend_args = { "-i", "2", "-ci" },
    },
    
   
    clang_format = {
      prepend_args = { "--style=Google" },
    },
  },

 
  format_on_save = function(bufnr)
    
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end
    
   
    local filetype = vim.bo[bufnr].filetype
    local ignore_filetypes = { "sql", "java" }
    if vim.tbl_contains(ignore_filetypes, filetype) then
      return
    end
    
    return {
      timeout_ms = 1000,
      lsp_fallback = true,
      quiet = false,
    }
  end,

  format_after_save = {
    lsp_fallback = true,
  },


  notify_on_error = true,
  notify_no_formatters = true,
})


local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }


keymap({ "n", "v" }, "<leader>cf", function()
  conform.format({
    async = true,
    lsp_fallback = true,
    range = nil,
  })
end, vim.tbl_extend("force", opts, { desc = "Format buffer" }))


keymap("v", "<leader>cF", function()
  conform.format({
    async = true,
    lsp_fallback = true,
    range = {
      start = vim.api.nvim_buf_get_mark(0, "<"),
      ["end"] = vim.api.nvim_buf_get_mark(0, ">"),
    },
  })
end, vim.tbl_extend("force", opts, { desc = "Format selection" }))


keymap("n", "<leader>tf", function()
  if vim.g.disable_autoformat then
    vim.g.disable_autoformat = false
    vim.notify("Autoformat enabled globally", vim.log.levels.INFO)
  else
    vim.g.disable_autoformat = true
    vim.notify("Autoformat disabled globally", vim.log.levels.WARN)
  end
end, vim.tbl_extend("force", opts, { desc = "Toggle autoformat globally" }))

keymap("n", "<leader>tF", function()
  if vim.b.disable_autoformat then
    vim.b.disable_autoformat = false
    vim.notify("Autoformat enabled for this buffer", vim.log.levels.INFO)
  else
    vim.b.disable_autoformat = true
    vim.notify("Autoformat disabled for this buffer", vim.log.levels.WARN)
  end
end, vim.tbl_extend("force", opts, { desc = "Toggle autoformat for buffer" }))


vim.api.nvim_create_user_command("FormatWith", function(args)
  local formatter = args.args
  if formatter == "" then
    vim.notify("Please specify a formatter", vim.log.levels.ERROR)
    return
  end
  
  conform.format({
    formatters = { formatter },
    async = true,
  })
end, {
  nargs = 1,
  complete = function()
    return conform.list_all_formatters()
  end,
  desc = "Format with specific formatter",
})

vim.api.nvim_create_user_command("ListFormatters", function()
  local formatters = conform.list_formatters()
  if #formatters == 0 then
    vim.notify("No formatters available for this filetype", vim.log.levels.WARN)
    return
  end
  
  local available = {}
  for _, formatter in ipairs(formatters) do
    table.insert(available, formatter.name .. (formatter.available and " ✓" or " ✗"))
  end
  
  vim.notify("Available formatters:\n" .. table.concat(available, "\n"), vim.log.levels.INFO)
end, { desc = "List available formatters" })


vim.api.nvim_create_autocmd("User", {
  pattern = "FormatterPre",
  callback = function(args)
    if args.data and args.data.formatter then
      vim.notify("Formatting with: " .. args.data.formatter, vim.log.levels.INFO)
    end
  end,
})


vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  callback = function()
    local conform_config = vim.fn.findfile(".conform.lua", ".;")
    if conform_config ~= "" then
      local ok, project_config = pcall(dofile, conform_config)
      if ok and type(project_config) == "table" then
        conform.setup(vim.tbl_deep_extend("force", conform.get_config(), project_config))
        vim.notify("Loaded project-specific conform config", vim.log.levels.INFO)
      end
    end
  end,
})

vim.notify("conform.nvim loaded successfully", vim.log.levels.INFO)