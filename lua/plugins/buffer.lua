local status_ok, bufferline = pcall(require, "bufferline")
if not status_ok then
  vim.notify("bufferline not found", vim.log.levels.ERROR)
  return
end

-- Verificar si la API está disponible
local bufferline_api_ok, _ = pcall(require, "bufferline.api")
if not bufferline_api_ok then
  vim.notify("bufferline API not available - some features may not work", vim.log.levels.WARN)
end

local function diagnostics_indicator(count, level, diagnostics_dict, context)
  local icons = {
    error = " ",
    warning = " ",
    hint = " ",
    info = " ",
  }
  
  local result = ""
  for type, icon in pairs(icons) do
    local n = diagnostics_dict[type]
    if n and n > 0 then
      result = result .. " " .. icon .. n
    end
  end
  return result ~= "" and result or ""
end

local function filter_buffers(buf_number, buf_numbers)
  local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf_number), ":t")
  local filetype = vim.api.nvim_buf_get_option(buf_number, "filetype")
  
  local excluded_filetypes = {
    "alpha",
    "dashboard",
    "neo-tree",
    "Trouble",
    "lazy",
    "mason",
    "notify",
    "toggleterm",
    "lazyterm",
    "TelescopePrompt",
    "TelescopeResults",
    "help",
    "startify",
    "NvimTree",
  }
  
  return not vim.tbl_contains(excluded_filetypes, filetype)
end

bufferline.setup({
  options = {
    mode = "buffers",
    numbers = "ordinal",
    number_style = "superscript",
    
    close_command = function(n) 
      require("mini.bufremove").delete(n, false)
    end,
    right_mouse_command = function(n) 
      require("mini.bufremove").delete(n, false) 
    end,
    left_mouse_command = "buffer %d",
    middle_mouse_command = nil,
    
    diagnostics = "nvim_lsp",
    diagnostics_update_in_insert = false,
    diagnostics_indicator = diagnostics_indicator,
    
    custom_filter = filter_buffers,
    
    offsets = {
      {
        filetype = "neo-tree",
        text = "Neo-tree",
        text_align = "left",
        separator = true,
      },
      {
        filetype = "NvimTree",
        text = "File Explorer",
        text_align = "left",
        separator = true,
      },
      {
        filetype = "Outline",
        text = "Symbols Outline",
        text_align = "left",
        separator = true,
      },
    },
    
    separator_style = "thick",
    
    indicator = {
      icon = "▎",
      style = "icon",
    },
    
    show_buffer_icons = true,
    show_buffer_close_icons = true,
    show_close_icon = true,
    show_tab_indicators = true,
    show_duplicate_prefix = true,
    duplicates_across_groups = true,
    
    persist_buffer_sort = true,
    move_wraps_at_ends = false,
    
    sort_by = "insert_after_current",

    groups = {
      options = {
        toggle_hidden_on_enter = true,
      },
      items = {
        {
          name = "Tests",
          highlight = { underline = true, sp = "blue" },
          priority = 2,
          icon = " ",
          matcher = function(buf)
            return buf.name:match('%_test') or buf.name:match('%_spec')
          end,
        },
        {
          name = "Config",
          highlight = { underline = true, sp = "green" },
          auto_close = false,
          matcher = function(buf)
            return buf.name:match('%.config') or buf.name:match('%.conf')
          end,
        },
        {
          name = "Docs",
          highlight = { underline = true, sp = "yellow" },
          auto_close = false,
          matcher = function(buf)
            return buf.name:match('%.md') or buf.name:match('%.txt') or buf.name:match('README')
          end,
        },
      }
    },
    
    enforce_regular_tabs = false,
    always_show_bufferline = true,
    auto_toggle_bufferline = true,
    
    max_name_length = 30,
    max_prefix_length = 30,
    truncate_names = true,
    
    color_icons = true,
    get_element_icon = function(element)
      local icon, hl = require("nvim-web-devicons").get_icon_by_filetype(element.filetype, { default = false })
      return icon, hl
    end,
  },
  
  highlights = {
    fill = {
      bg = { attribute = "bg", highlight = "TabLine" },
    },
    background = {
      fg = { attribute = "fg", highlight = "TabLine" },
      bg = { attribute = "bg", highlight = "TabLine" },
    },
    tab = {
      fg = { attribute = "fg", highlight = "TabLine" },
      bg = { attribute = "bg", highlight = "TabLine" },
    },
    tab_selected = {
      fg = { attribute = "fg", highlight = "Normal" },
      bg = { attribute = "bg", highlight = "Normal" },
    },
    tab_separator = {
      fg = { attribute = "bg", highlight = "TabLine" },
      bg = { attribute = "bg", highlight = "TabLine" },
    },
    tab_separator_selected = {
      fg = { attribute = "bg", highlight = "Normal" },
      bg = { attribute = "bg", highlight = "Normal" },
      sp = { attribute = "fg", highlight = "Normal" },
      underline = true,
    },
    tab_close = {
      fg = { attribute = "fg", highlight = "TabLineSel" },
      bg = { attribute = "bg", highlight = "Normal" },
    },
    close_button = {
      fg = { attribute = "fg", highlight = "TabLine" },
      bg = { attribute = "bg", highlight = "TabLine" },
    },
    close_button_visible = {
      fg = { attribute = "fg", highlight = "TabLine" },
      bg = { attribute = "bg", highlight = "TabLine" },
    },
    close_button_selected = {
      fg = { attribute = "fg", highlight = "TabLineSel" },
      bg = { attribute = "bg", highlight = "Normal" },
    },
    buffer_visible = {
      fg = { attribute = "fg", highlight = "TabLine" },
      bg = { attribute = "bg", highlight = "TabLine" },
    },
    buffer_selected = {
      fg = { attribute = "fg", highlight = "Normal" },
      bg = { attribute = "bg", highlight = "Normal" },
      bold = true,
      italic = false,
    },
    numbers = {
      fg = { attribute = "fg", highlight = "TabLine" },
      bg = { attribute = "bg", highlight = "TabLine" },
    },
    numbers_visible = {
      fg = { attribute = "fg", highlight = "TabLine" },
      bg = { attribute = "bg", highlight = "TabLine" },
    },
    numbers_selected = {
      fg = { attribute = "fg", highlight = "Normal" },
      bg = { attribute = "bg", highlight = "Normal" },
      bold = true,
      italic = false,
    },
    diagnostic = {
      fg = { attribute = "fg", highlight = "TabLine" },
      bg = { attribute = "bg", highlight = "TabLine" },
    },
    diagnostic_visible = {
      fg = { attribute = "fg", highlight = "TabLine" },
      bg = { attribute = "bg", highlight = "TabLine" },
    },
    diagnostic_selected = {
      fg = { attribute = "fg", highlight = "DiagnosticError" },
      bg = { attribute = "bg", highlight = "Normal" },
      bold = true,
      italic = false,
    },
    hint = {
      fg = { attribute = "fg", highlight = "DiagnosticHint" },
      sp = { attribute = "fg", highlight = "DiagnosticHint" },
      bg = { attribute = "bg", highlight = "TabLine" },
    },
    hint_visible = {
      fg = { attribute = "fg", highlight = "DiagnosticHint" },
      bg = { attribute = "bg", highlight = "TabLine" },
    },
    hint_selected = {
      fg = { attribute = "fg", highlight = "DiagnosticHint" },
      bg = { attribute = "bg", highlight = "Normal" },
      sp = { attribute = "fg", highlight = "DiagnosticHint" },
      underline = true,
    },
    hint_diagnostic = {
      fg = { attribute = "fg", highlight = "DiagnosticHint" },
      sp = { attribute = "fg", highlight = "DiagnosticHint" },
      bg = { attribute = "bg", highlight = "TabLine" },
    },
    hint_diagnostic_visible = {
      fg = { attribute = "fg", highlight = "DiagnosticHint" },
      bg = { attribute = "bg", highlight = "TabLine" },
    },
    hint_diagnostic_selected = {
      fg = { attribute = "fg", highlight = "DiagnosticHint" },
      bg = { attribute = "bg", highlight = "Normal" },
      sp = { attribute = "fg", highlight = "DiagnosticHint" },
      underline = true,
    },
    info = {
      fg = { attribute = "fg", highlight = "DiagnosticInfo" },
      sp = { attribute = "fg", highlight = "DiagnosticInfo" },
      bg = { attribute = "bg", highlight = "TabLine" },
    },
    info_visible = {
      fg = { attribute = "fg", highlight = "DiagnosticInfo" },
      bg = { attribute = "bg", highlight = "TabLine" },
    },
    info_selected = {
      fg = { attribute = "fg", highlight = "DiagnosticInfo" },
      bg = { attribute = "bg", highlight = "Normal" },
      sp = { attribute = "fg", highlight = "DiagnosticInfo" },
      underline = true,
    },
    info_diagnostic = {
      fg = { attribute = "fg", highlight = "DiagnosticInfo" },
      sp = { attribute = "fg", highlight = "DiagnosticInfo" },
      bg = { attribute = "bg", highlight = "TabLine" },
    },
    info_diagnostic_visible = {
      fg = { attribute = "fg", highlight = "DiagnosticInfo" },
      bg = { attribute = "bg", highlight = "TabLine" },
    },
    info_diagnostic_selected = {
      fg = { attribute = "fg", highlight = "DiagnosticInfo" },
      bg = { attribute = "bg", highlight = "Normal" },
      sp = { attribute = "fg", highlight = "DiagnosticInfo" },
      underline = true,
    },
    warning = {
      fg = { attribute = "fg", highlight = "DiagnosticWarn" },
      sp = { attribute = "fg", highlight = "DiagnosticWarn" },
      bg = { attribute = "bg", highlight = "TabLine" },
    },
    warning_visible = {
      fg = { attribute = "fg", highlight = "DiagnosticWarn" },
      bg = { attribute = "bg", highlight = "TabLine" },
    },
    warning_selected = {
      fg = { attribute = "fg", highlight = "DiagnosticWarn" },
      bg = { attribute = "bg", highlight = "Normal" },
      sp = { attribute = "fg", highlight = "DiagnosticWarn" },
      underline = true,
    },
    warning_diagnostic = {
      fg = { attribute = "fg", highlight = "DiagnosticWarn" },
      sp = { attribute = "fg", highlight = "DiagnosticWarn" },
      bg = { attribute = "bg", highlight = "TabLine" },
    },
    warning_diagnostic_visible = {
      fg = { attribute = "fg", highlight = "DiagnosticWarn" },
      bg = { attribute = "bg", highlight = "TabLine" },
    },
    warning_diagnostic_selected = {
      fg = { attribute = "fg", highlight = "DiagnosticWarn" },
      bg = { attribute = "bg", highlight = "Normal" },
      sp = { attribute = "fg", highlight = "DiagnosticWarn" },
      underline = true,
    },
    error = {
      fg = { attribute = "fg", highlight = "DiagnosticError" },
      sp = { attribute = "fg", highlight = "DiagnosticError" },
      bg = { attribute = "bg", highlight = "TabLine" },
    },
    error_visible = {
      fg = { attribute = "fg", highlight = "DiagnosticError" },
      bg = { attribute = "bg", highlight = "TabLine" },
    },
    error_selected = {
      fg = { attribute = "fg", highlight = "DiagnosticError" },
      bg = { attribute = "bg", highlight = "Normal" },
      sp = { attribute = "fg", highlight = "DiagnosticError" },
      underline = true,
    },
    error_diagnostic = {
      fg = { attribute = "fg", highlight = "DiagnosticError" },
      sp = { attribute = "fg", highlight = "DiagnosticError" },
      bg = { attribute = "bg", highlight = "TabLine" },
    },
    error_diagnostic_visible = {
      fg = { attribute = "fg", highlight = "DiagnosticError" },
      bg = { attribute = "bg", highlight = "TabLine" },
    },
    error_diagnostic_selected = {
      fg = { attribute = "fg", highlight = "DiagnosticError" },
      bg = { attribute = "bg", highlight = "Normal" },
      sp = { attribute = "fg", highlight = "DiagnosticError" },
      underline = true,
    },
    modified = {
      fg = { attribute = "fg", highlight = "TabLine" },
      bg = { attribute = "bg", highlight = "TabLine" },
    },
    modified_visible = {
      fg = { attribute = "fg", highlight = "TabLine" },
      bg = { attribute = "bg", highlight = "TabLine" },
    },
    modified_selected = {
      fg = { attribute = "fg", highlight = "Normal" },
      bg = { attribute = "bg", highlight = "Normal" },
    },
    duplicate_selected = {
      fg = { attribute = "fg", highlight = "TabLine" },
      bg = { attribute = "bg", highlight = "Normal" },
      underline = true,
    },
    duplicate_visible = {
      fg = { attribute = "fg", highlight = "TabLine" },
      bg = { attribute = "bg", highlight = "TabLine" },
      underline = true,
    },
    duplicate = {
      fg = { attribute = "fg", highlight = "TabLine" },
      bg = { attribute = "bg", highlight = "TabLine" },
      underline = true,
    },
    separator = {
      fg = { attribute = "bg", highlight = "TabLine" },
      bg = { attribute = "bg", highlight = "TabLine" },
    },
    separator_selected = {
      fg = { attribute = "bg", highlight = "Normal" },
      bg = { attribute = "bg", highlight = "Normal" },
    },
    separator_visible = {
      fg = { attribute = "bg", highlight = "TabLine" },
      bg = { attribute = "bg", highlight = "TabLine" },
    },
    indicator_visible = {
      fg = { attribute = "fg", highlight = "TabLine" },
      bg = { attribute = "bg", highlight = "TabLine" },
    },
    indicator_selected = {
      fg = { attribute = "fg", highlight = "LspDiagnosticsDefaultHint" },
      bg = { attribute = "bg", highlight = "Normal" },
    },
  },
})

-- Configuración de keymaps
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Navegación entre buffers
keymap("n", "<A-h>", "<Cmd>BufferPrevious<CR>", opts)
keymap("n", "<A-l>", "<Cmd>BufferNext<CR>", opts)

-- Movimiento de buffers
keymap("n", "<A-S-h>", "<Cmd>BufferMovePrevious<CR>", opts)
keymap("n", "<A-S-l>", "<Cmd>BufferMoveNext<CR>", opts)

-- Acceso rápido a buffers (1-9)
for i = 1, 9 do
  keymap("n", "<A-"..i..">", function() vim.cmd("BufferGoto "..i) end, opts)
end

-- Gestión de buffers
keymap("n", "<leader>bd", function()
  require("mini.bufremove").delete(vim.fn.bufnr(), false)
end, opts)

keymap("n", "<leader>bD", function()
  require("mini.bufremove").delete(vim.fn.bufnr(), true)
end, opts)

keymap("n", "<leader>bo", "<Cmd>BufferCloseAllButCurrent<CR>", opts)
keymap("n", "<leader>br", "<Cmd>BufferCloseBuffersRight<CR>", opts)
keymap("n", "<leader>bl", "<Cmd>BufferCloseBuffersLeft<CR>", opts)

-- Funciones especiales
keymap("n", "<leader>bp", "<Cmd>BufferPick<CR>", opts)
keymap("n", "<leader>bP", "<Cmd>BufferPickClose<CR>", opts)
keymap("n", "<leader>bs", "<Cmd>BufferOrderByExtension<CR>", opts)
keymap("n", "<leader>bS", "<Cmd>BufferOrderByDirectory<CR>", opts)

-- Grupos
keymap("n", "<leader>bgt", "<Cmd>BufferLineGroupToggle tests<CR>", opts)
keymap("n", "<leader>bgc", "<Cmd>BufferLineGroupToggle config<CR>", opts)
keymap("n", "<leader>bgd", "<Cmd>BufferLineGroupToggle docs<CR>", opts)

-- Configuración de autocomandos
local augroup = vim.api.nvim_create_augroup("BufferlineConfig", { clear = true })

vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
  group = augroup,
  callback = function()
    vim.schedule(function()
      if bufferline_api_ok then
        pcall(require("bufferline.api").set_offset, 0)
      end
    end)
  end,
})

vim.notify("bufferline configured successfully", vim.log.levels.INFO)