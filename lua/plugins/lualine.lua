
local M = {}

local function safe_require(module)
  local ok, result = pcall(require, module)
  if not ok then
    vim.notify("Error al cargar " .. module .. ": " .. result, vim.log.levels.WARN)
    return nil
  end
  return result
end

local lualine = safe_require("lualine")
if not lualine then
  return M
end

local icons = safe_require("nvim-web-devicons")
local icons_enabled = icons ~= nil

local colors = {
  bg = "#202328",
  fg = "#bbc2cf",
  yellow = "#ECBE7B",
  cyan = "#008080",
  darkblue = "#081633",
  green = "#98be65",
  orange = "#FF8800",
  violet = "#a9a1e1",
  magenta = "#c678dd",
  blue = "#51afef",
  red = "#ec5f67",
  grey = "#5c6370",
}

local function mode_color()
  local mode_colors = {
    n = colors.red,
    i = colors.green,
    v = colors.blue,
    V = colors.blue,
    c = colors.magenta,
    no = colors.red,
    s = colors.orange,
    S = colors.orange,
    ic = colors.yellow,
    R = colors.violet,
    Rv = colors.violet,
    cv = colors.red,
    ce = colors.red,
    r = colors.cyan,
    rm = colors.cyan,
    ["r?"] = colors.cyan,
    ["!"] = colors.red,
    t = colors.red,
  }
  return { fg = mode_colors[vim.fn.mode()] }
end

local function diagnostics_component()
  return {
    "diagnostics",
    sources = { "nvim_diagnostic", "nvim_lsp" },
    sections = { "error", "warn", "info", "hint" },
    diagnostics_color = {
      error = { fg = colors.red },
      warn = { fg = colors.yellow },
      info = { fg = colors.cyan },
      hint = { fg = colors.blue },
    },
    symbols = { error = " ", warn = " ", info = " ", hint = "󰌶 " },
    colored = true,
    update_in_insert = false,
    always_visible = false,
  }
end

local function git_branch()
  return {
    "branch",
    icon = "",
    color = { fg = colors.violet, gui = "bold" },
  }
end

local function git_diff()
  return {
    "diff",
    symbols = { added = " ", modified = " ", removed = " " },
    diff_color = {
      added = { fg = colors.green },
      modified = { fg = colors.orange },
      removed = { fg = colors.red },
    },
    cond = function()
      local width = vim.fn.winwidth(0)
      return width > 80
    end,
  }
end

local function filename_component()
  return {
    "filename",
    path = 1, 
    shorting_target = 40,
    symbols = {
      modified = " ●",
      readonly = " ",
      unnamed = "󰡯 [Sin nombre]",
      newfile = " [Nuevo]",
    },
    color = function()
      return vim.bo.modified and { fg = colors.orange } or { fg = colors.fg }
    end,
  }
end

local function lsp_component()
  return {
    function()
      local msg = "No LSP"
      local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
      local clients = vim.lsp.get_active_clients()
      
      if next(clients) == nil then
        return msg
      end
      
      local client_names = {}
      for _, client in ipairs(clients) do
        local filetypes = client.config.filetypes
        if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
          table.insert(client_names, client.name)
        end
      end
      
      if next(client_names) == nil then
        return msg
      end
      
      return "󰒋 " .. table.concat(client_names, ", ")
    end,
    color = { fg = colors.cyan },
    cond = function()
      local width = vim.fn.winwidth(0)
      return width > 100
    end,
  }
end

local function buffer_info()
  return {
    function()
      local current = vim.fn.bufnr("%")
      local total = vim.fn.len(vim.fn.filter(vim.fn.range(1, vim.fn.bufnr("$")), 'buflisted(v:val)'))
      return "󰓩 " .. current .. "/" .. total
    end,
    color = { fg = colors.blue },
    cond = function()
      local width = vim.fn.winwidth(0)
      return width > 90
    end,
  }
end

local function progress_component()
  return {
    "progress",
    fmt = function()
      return "%P/%L"
    end,
    color = { fg = colors.grey },
  }
end

local function location_component()
  return {
    "location",
    fmt = function(str)
      return " " .. str
    end,
    color = { fg = colors.blue },
  }
end

local function filesize_component()
  return {
    "filesize",
    cond = function()
      local width = vim.fn.winwidth(0)
      return width > 120
    end,
    color = { fg = colors.grey },
  }
end

local function clock_component()
  return {
    function()
      return " " .. os.date("%H:%M")
    end,
    cond = function()
      local width = vim.fn.winwidth(0)
      return width > 140
    end,
    color = { fg = colors.violet },
  }
end

local function harpoon_component()
  local harpoon_ok = pcall(require, "harpoon")
  if not harpoon_ok then
    return ""
  end
  
  return {
    function()
      local harpoon = require("harpoon")
      local current_file = vim.fn.expand("%:p:.")
      local harpoon_files = harpoon:list().items
      
      for i, file in ipairs(harpoon_files) do
        if file.value == current_file then
          return "⚓ " .. i
        end
      end
      return ""
    end,
    color = { fg = colors.orange },
    cond = function()
      local width = vim.fn.winwidth(0)
      return width > 80
    end,
  }
end

local config = {
  options = {
    icons_enabled = icons_enabled,
    theme = {
      normal = {
        a = { fg = colors.bg, bg = colors.green, gui = "bold" },
        b = { fg = colors.fg, bg = colors.grey },
        c = { fg = colors.fg, bg = colors.bg },
      },
      insert = { a = { fg = colors.bg, bg = colors.blue, gui = "bold" } },
      visual = { a = { fg = colors.bg, bg = colors.magenta, gui = "bold" } },
      replace = { a = { fg = colors.bg, bg = colors.red, gui = "bold" } },
      inactive = {
        a = { fg = colors.grey, bg = colors.bg },
        b = { fg = colors.grey, bg = colors.bg },
        c = { fg = colors.grey, bg = colors.bg },
      },
    },
    component_separators = { left = "│", right = "│" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = {
      statusline = { "alpha", "dashboard", "NvimTree", "Outline" },
      winbar = { "alpha", "dashboard", "NvimTree", "Outline" },
    },
    ignore_focus = { "NvimTree", "alpha", "dashboard" },
    always_divide_middle = true,
    globalstatus = true, 
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    },
  },
  
  sections = {
    lualine_a = {
      {
        "mode",
        fmt = function(str)
          local mode_map = {
            ["NORMAL"] = "N",
            ["INSERT"] = "I",
            ["VISUAL"] = "V",
            ["V-LINE"] = "VL",
            ["V-BLOCK"] = "VB",
            ["COMMAND"] = "C",
            ["TERMINAL"] = "T",
          }
          return " " .. (mode_map[str] or str)
        end,
        color = mode_color,
      },
    },
    
    lualine_b = {
      git_branch(),
      git_diff(),
      diagnostics_component(),
    },
    
    lualine_c = {
      filename_component(),
      harpoon_component(),
      {
        "searchcount",
        maxcount = 999,
        timeout = 500,
        color = { fg = colors.cyan },
      },
    },
    
    lualine_x = {
      lsp_component(),
      buffer_info(),
      {
        "encoding",
        fmt = string.upper,
        cond = function()
          local width = vim.fn.winwidth(0)
          return width > 100
        end,
        color = { fg = colors.grey },
      },
      {
        "fileformat",
        symbols = {
          unix = "LF",
          dos = "CRLF",
          mac = "CR",
        },
        color = { fg = colors.grey },
        cond = function()
          local width = vim.fn.winwidth(0)
          return width > 120
        end,
      },
      {
        "filetype",
        colored = true,
        icon_only = false,
        icon = { align = "right" },
      },
    },
    
    lualine_y = {
      filesize_component(),
      progress_component(),
    },
    
    lualine_z = {
      location_component(),
      clock_component(),
    },
  },
  
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {
      {
        "filename",
        path = 1,
        color = { fg = colors.grey },
      },
    },
    lualine_x = {
      {
        "location",
        color = { fg = colors.grey },
      },
    },
    lualine_y = {},
    lualine_z = {},
  },
  

  
 
  
  extensions = {
    "nvim-tree",
    "nvim-dap-ui",
    "toggleterm",
    "quickfix",
    "mason",
    "lazy",
    "trouble",
    "symbols-outline",
    "aerial",
  },
}


M.refresh = function()
  lualine.refresh()
end

M.toggle_clock = function()

  config.sections.lualine_z[2].cond = function()
    return not config.sections.lualine_z[2].cond()
  end
  lualine.setup(config)
end

local function setup_autocommands()
  local augroup = vim.api.nvim_create_augroup("LualineConfig", { clear = true })

  vim.api.nvim_create_autocmd("LspAttach", {
    group = augroup,
    callback = function()
      M.refresh()
    end,
  })

  vim.api.nvim_create_autocmd("DiagnosticChanged", {
    group = augroup,
    callback = function()
      M.refresh()
    end,
  })

  vim.api.nvim_create_autocmd("User", {
    pattern = "GitSignsUpdate",
    group = augroup,
    callback = function()
      M.refresh()
    end,
  })
end

local function init()
  lualine.setup(config)
  setup_autocommands()

  vim.api.nvim_create_user_command('LualineToggleClock', M.toggle_clock, {
    desc = 'Toggle del reloj en lualine'
  })
end

init()

return M