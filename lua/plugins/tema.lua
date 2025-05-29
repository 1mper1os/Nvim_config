local status_ok, onedark = pcall(require, "onedark")
if not status_ok then
  vim.notify("Error: No se pudo cargar el tema OneDark", vim.log.levels.ERROR)
  return
end

vim.g.onedark_config = {
  current_style = "deep",
  transparency_enabled = true,
  italic_comments = true,
}

local function get_terminal_capabilities()
  local term = vim.env.TERM or ""
  local colorterm = vim.env.COLORTERM or ""
  
  return {
    truecolor = colorterm == "truecolor" or term:match("256color"),
    italic_support = not (term:match("screen") and not term:match("screen%-256color")),
    undercurl_support = vim.fn.has("gui_running") == 1 or colorterm == "truecolor",
  }
end

local terminal_caps = get_terminal_capabilities()


onedark.setup({

  style = vim.g.onedark_config.current_style, 
  transparent = vim.g.onedark_config.transparency_enabled,
  
  term_colors = true,
  
  ending_tildes = true,
  
  cmp_itemkind_reverse = false,
  
  code_style = {
    comments = terminal_caps.italic_support and "italic" or "none",
    keywords = "bold",
    functions = "none",
    strings = "none",
    variables = "none",
    conditionals = "none",
    loops = "none",
    booleans = "bold",
    constants = "bold",
    types = "none",
    operators = "none",
  },
  
  lualine = {
    transparent = vim.g.onedark_config.transparency_enabled,
  },
  
  
  diagnostics = {
    darker = true,                  
    undercurl = terminal_caps.undercurl_support,
    background = true,                
  },

  
  
  highlights = {
    
    Normal = { bg = vim.g.onedark_config.transparency_enabled and "NONE" or nil },
    NormalFloat = { bg = vim.g.onedark_config.transparency_enabled and "NONE" or "$bg1" },
    FloatBorder = { fg = "$grey", bg = vim.g.onedark_config.transparency_enabled and "NONE" or "$bg1" },
    
    Cursor = { fg = "$bg0", bg = "$fg" },
    CursorLine = { bg = "$bg1" },
    CursorColumn = { bg = "$bg1" },
    ColorColumn = { bg = "$bg1" },
    Visual = { bg = "$bg3" },
    VisualNOS = { bg = "$bg3" },
    
    LineNr = { fg = "$grey" },
    CursorLineNr = { fg = "$yellow", fmt = "bold" },
    
    Folded = { fg = "$grey", bg = "$bg1", fmt = "italic" },
    FoldColumn = { fg = "$grey", bg = vim.g.onedark_config.transparency_enabled and "NONE" or "$bg0" },
    
    Search = { fg = "$bg0", bg = "$yellow" },
    IncSearch = { fg = "$bg0", bg = "$orange" },
    CurSearch = { fg = "$bg0", bg = "$red" },
    
    StatusLine = { fg = "$fg", bg = vim.g.onedark_config.transparency_enabled and "NONE" or "$bg2" },
    StatusLineNC = { fg = "$grey", bg = vim.g.onedark_config.transparency_enabled and "NONE" or "$bg1" },
    TabLine = { fg = "$fg", bg = "$bg1" },
    TabLineFill = { fg = "$grey", bg = "$bg1" },
    TabLineSel = { fg = "$bg0", bg = "$blue" },
    
    VertSplit = { fg = "$bg3" },
    WinSeparator = { fg = "$bg3" },
    SignColumn = { bg = vim.g.onedark_config.transparency_enabled and "NONE" or "$bg0" },
    
    Pmenu = { fg = "$fg", bg = "$bg1" },
    PmenuSel = { fg = "$bg0", bg = "$blue" },
    PmenuSbar = { bg = "$bg2" },
    PmenuThumb = { bg = "$grey" },
    
    ["@keyword"] = { fg = "$purple", fmt = "bold" },
    ["@keyword.return"] = { fg = "$red", fmt = "bold" },
    ["@keyword.function"] = { fg = "$purple", fmt = "bold" },
    ["@function.builtin"] = { fg = "$blue", fmt = "bold" },
    ["@variable.builtin"] = { fg = "$red", fmt = "bold" },
    ["@constant.builtin"] = { fg = "$orange", fmt = "bold" },
    ["@string.escape"] = { fg = "$cyan", fmt = "bold" },
    ["@character.special"] = { fg = "$cyan", fmt = "bold" },
    ["@comment.todo"] = { fg = "$yellow", bg = "$bg1", fmt = "bold" },
    ["@comment.warning"] = { fg = "$orange", bg = "$bg1", fmt = "bold" },
    ["@comment.note"] = { fg = "$blue", bg = "$bg1", fmt = "bold" },
    ["@comment.error"] = { fg = "$red", bg = "$bg1", fmt = "bold" },
    
    DiagnosticError = { fg = "$red" },
    DiagnosticWarn = { fg = "$yellow" },
    DiagnosticInfo = { fg = "$blue" },
    DiagnosticHint = { fg = "$cyan" },
    DiagnosticVirtualTextError = { fg = "$red", bg = "$bg1" },
    DiagnosticVirtualTextWarn = { fg = "$yellow", bg = "$bg1" },
    DiagnosticVirtualTextInfo = { fg = "$blue", bg = "$bg1" },
    DiagnosticVirtualTextHint = { fg = "$cyan", bg = "$bg1" },
    DiagnosticUnderlineError = { fmt = terminal_caps.undercurl_support and "undercurl" or "underline", sp = "$red" },
    DiagnosticUnderlineWarn = { fmt = terminal_caps.undercurl_support and "undercurl" or "underline", sp = "$yellow" },
    DiagnosticUnderlineInfo = { fmt = terminal_caps.undercurl_support and "undercurl" or "underline", sp = "$blue" },
    DiagnosticUnderlineHint = { fmt = terminal_caps.undercurl_support and "undercurl" or "underline", sp = "$cyan" },
    
    GitSignsAdd = { fg = "$green" },
    GitSignsChange = { fg = "$yellow" },
    GitSignsDelete = { fg = "$red" },
    GitSignsAddLn = { bg = "$bg1" },
    GitSignsChangeLn = { bg = "$bg1" },
    GitSignsDeleteLn = { bg = "$bg1" },
    
    TelescopeNormal = { bg = vim.g.onedark_config.transparency_enabled and "NONE" or "$bg1" },
    TelescopeBorder = { fg = "$grey", bg = vim.g.onedark_config.transparency_enabled and "NONE" or "$bg1" },
    TelescopePromptNormal = { bg = "$bg2" },
    TelescopePromptBorder = { fg = "$bg2", bg = "$bg2" },
    TelescopePromptTitle = { fg = "$bg0", bg = "$red" },
    TelescopePreviewTitle = { fg = "$bg0", bg = "$green" },
    TelescopeResultsTitle = { fg = "$bg0", bg = "$blue" },
    TelescopeSelection = { bg = "$bg2" },
    TelescopeSelectionCaret = { fg = "$red" },
    
    NvimTreeNormal = { bg = vim.g.onedark_config.transparency_enabled and "NONE" or "$bg1" },
    NvimTreeVertSplit = { fg = "$bg3", bg = vim.g.onedark_config.transparency_enabled and "NONE" or "$bg0" },
    NvimTreeFolderIcon = { fg = "$blue" },
    NvimTreeRootFolder = { fg = "$purple", fmt = "bold" },
    NvimTreeSymlink = { fg = "$cyan" },
    NvimTreeExecFile = { fg = "$green", fmt = "bold" },
    NvimTreeSpecialFile = { fg = "$yellow", fmt = "bold" },
    NvimTreeImageFile = { fg = "$purple" },
    NvimTreeMarkdownFile = { fg = "$blue" },
    
    WhichKey = { fg = "$purple", fmt = "bold" },
    WhichKeyGroup = { fg = "$blue" },
    WhichKeyDesc = { fg = "$fg" },
    WhichKeySeperator = { fg = "$grey" },
    WhichKeyFloat = { bg = vim.g.onedark_config.transparency_enabled and "NONE" or "$bg1" },
    
    BufferLineFill = { bg = vim.g.onedark_config.transparency_enabled and "NONE" or "$bg1" },
    BufferLineBackground = { fg = "$grey", bg = "$bg1" },
    BufferLineBufferSelected = { fg = "$fg", bg = "$bg0", fmt = "bold" },
    BufferLineBufferVisible = { fg = "$fg", bg = "$bg2" },
    
    IndentBlanklineChar = { fg = "$bg3" },
    IndentBlanklineContextChar = { fg = "$purple" },
    IndentBlanklineSpaceChar = { fg = "$bg3" },
    IndentBlanklineSpaceCharBlankline = { fg = "$bg3" },
  },
})

onedark.load()

local function toggle_transparency()
  vim.g.onedark_config.transparency_enabled = not vim.g.onedark_config.transparency_enabled
  onedark.setup({ transparent = vim.g.onedark_config.transparency_enabled })
  onedark.load()
  local status = vim.g.onedark_config.transparency_enabled and "habilitada" or "deshabilitada"
  vim.notify("Transparencia " .. status, vim.log.levels.INFO)
end

local function change_style(style)
  local valid_styles = { "dark", "darker", "cool", "deep", "warm", "warmer" }
  if vim.tbl_contains(valid_styles, style) then
    vim.g.onedark_config.current_style = style
    onedark.setup({ style = style })
    onedark.load()
    vim.notify("Estilo cambiado a: " .. style, vim.log.levels.INFO)
  else
    vim.notify("Estilo inválido. Opciones: " .. table.concat(valid_styles, ", "), vim.log.levels.WARN)
  end
end

local function toggle_italic_comments()
  vim.g.onedark_config.italic_comments = not vim.g.onedark_config.italic_comments
  local comment_style = vim.g.onedark_config.italic_comments and terminal_caps.italic_support and "italic" or "none"
  onedark.setup({
    code_style = { comments = comment_style }
  })
  onedark.load()
  local status = vim.g.onedark_config.italic_comments and "habilitada" or "deshabilitada"
  vim.notify("Cursiva en comentarios " .. status, vim.log.levels.INFO)
end

local keymap = vim.keymap.set
local opts = { silent = true, noremap = true }

keymap("n", "<leader>tt", toggle_transparency, 
       vim.tbl_extend("force", opts, { desc = "Toggle transparencia del tema" }))

keymap("n", "<leader>ti", toggle_italic_comments, 
       vim.tbl_extend("force", opts, { desc = "Toggle cursiva en comentarios" }))

vim.api.nvim_create_user_command("OneDarkStyle", function(cmd_opts)
  change_style(cmd_opts.args)
end, {
  nargs = 1,
  complete = function()
    return { "dark", "darker", "cool", "deep", "warm", "warmer" }
  end,
  desc = "Cambiar estilo del tema OneDark"
})

vim.api.nvim_create_user_command("OneDarkReload", function()
  package.loaded["onedark"] = nil
  onedark = require("onedark")
  onedark.setup()
  onedark.load()
  vim.notify("Tema OneDark recargado", vim.log.levels.INFO)
end, { desc = "Recargar tema OneDark" })


local onedark_group = vim.api.nvim_create_augroup("OneDarkEnhancements", { clear = true })

vim.api.nvim_create_autocmd("ColorScheme", {
  group = onedark_group,
  pattern = "onedark",
  callback = function()

    if vim.g.onedark_config.transparency_enabled then
      vim.cmd([[
        hi Normal guibg=NONE ctermbg=NONE
        hi NormalFloat guibg=NONE ctermbg=NONE
        hi SignColumn guibg=NONE ctermbg=NONE
        hi StatusLine guibg=NONE ctermbg=NONE
        hi TabLine guibg=NONE ctermbg=NONE
        hi TabLineFill guibg=NONE ctermbg=NONE
        hi VertSplit guibg=NONE ctermbg=NONE
      ]])
    end
    
    vim.cmd([[
      hi Todo gui=bold guifg=#FFFF00 guibg=#FF0000
      hi MatchParen gui=bold guifg=#FFFFFF guibg=#005FFF
      hi Error gui=bold guifg=#FFFFFF guibg=#FF0000
      hi ErrorMsg gui=bold guifg=#FFFFFF guibg=#FF0000
    ]])
  end,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
  group = onedark_group,
  callback = function()
   
    local config_file = vim.fn.stdpath("config") .. "/lua/theme_state.lua"
    
  end,
})

vim.defer_fn(function()

  if pcall(require, "trouble") then
    vim.cmd([[
      hi TroubleNormal guibg=NONE
      hi TroubleText guifg=#abb2bf
      hi TroubleSource guifg=#56b6c2
      hi TroubleCode guifg=#be5046
    ]])
  end
  
  if pcall(require, "neo-tree") then
    vim.cmd([[
      hi NeoTreeNormal guibg=NONE
      hi NeoTreeNormalNC guibg=NONE
      hi NeoTreeVertSplit guibg=NONE
    ]])
  end
end, 100)

vim.notify("🎨 Tema OneDark configurado correctamente", vim.log.levels.INFO)