local status_ok, ibl = pcall(require, "ibl")
if not status_ok then
  vim.notify("indent-blankline not found", vim.log.levels.ERROR)
  return
end


local highlight = {
  "RainbowRed",
  "RainbowYellow", 
  "RainbowBlue",
  "RainbowOrange",
  "RainbowGreen",
  "RainbowViolet",
  "RainbowCyan",
}


local hooks = require("ibl.hooks")
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
  vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
  vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
  vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
  vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
  vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
  vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
  vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
end)


ibl.setup({
  enabled = true,
  

  indent = {
    char = "│", 
    tab_char = "│",
    highlight = highlight,
    smart_indent_cap = true,
    priority = 200,
  },
  

  whitespace = {
    highlight = highlight,
    remove_blankline_trail = false,
  },
  

  scope = {
    enabled = true,
    char = "║", 
    show_start = true,
    show_end = true,
    show_exact_scope = false,
    injected_languages = true,
    highlight = highlight,
    priority = 500,
    include = {
      node_type = {
        ["*"] = {
          "class",
          "return_statement",
          "function",
          "method",
          "^if",
          "^while",
          "jsx_element",
          "jsx_self_closing_element",
          "try_statement",
          "catch_clause",
          "import_statement",
          "operation_type",
        },
      },
    },
    exclude = {
      language = {},
      node_type = {
        ["*"] = {
          "source_file",
          "program",
        },
        lua = {
          "chunk",
        },
        python = {
          "module",
        },
      },
    },
  },
  

  exclude = {
    filetypes = {
      "help",
      "alpha",
      "dashboard",
      "neo-tree",
      "Trouble",
      "trouble",
      "lazy",
      "mason",
      "notify",
      "toggleterm",
      "lazyterm",
      "TelescopePrompt",
      "TelescopeResults",
      "lspinfo",
      "packer",
      "checkhealth",
      "man",
      "gitcommit",
      "TelescopePrompt",
      "TelescopeResults",
      "nvcheatsheet",
      "terminal",
      "",
    },
    buftypes = {
      "terminal",
      "nofile",
      "quickfix",
      "prompt",
    },
  },
  

  debounce = 100,
  viewport_buffer = {
    min = 30,
    max = 500,
  },
})

hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)


local augroup = vim.api.nvim_create_augroup("IndentBlankline", { clear = true })


vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup,
  callback = function()
    local line_count = vim.api.nvim_buf_line_count(0)
    if line_count > 10000 then
      vim.b.indent_blankline_enabled = false
      vim.notify("Indent-blankline disabled for large file (" .. line_count .. " lines)", vim.log.levels.INFO)
    end
  end,
})


vim.api.nvim_create_autocmd("InsertEnter", {
  group = augroup,
  callback = function()
    local ft = vim.bo.filetype
    if not vim.tbl_contains({
      "lua", "python", "javascript", "typescript", "jsx", "tsx", 
      "json", "yaml", "html", "css", "scss", "vue", "rust", "go"
    }, ft) then
      vim.b.indent_blankline_enabled = false
    end
  end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
  group = augroup,
  callback = function()
    if vim.b.indent_blankline_enabled == false then
      vim.b.indent_blankline_enabled = true
    end
  end,
})


vim.keymap.set("n", "<leader>ti", function()
  local enabled = not require("ibl.config").get_config(0).enabled
  require("ibl").setup_buffer(0, { enabled = enabled })
  vim.notify("Indent-blankline " .. (enabled and "enabled" or "disabled"), vim.log.levels.INFO)
end, { desc = "Toggle indent-blankline" })


vim.api.nvim_create_user_command("IBLToggle", function()
  vim.cmd("IBLToggle")
end, { desc = "Toggle indent-blankline" })

vim.api.nvim_create_user_command("IBLToggleScope", function()
  vim.cmd("IBLToggleScope")
end, { desc = "Toggle indent-blankline scope" })


vim.notify("indent-blankline configured successfully", vim.log.levels.INFO)