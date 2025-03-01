local onedark = require("onedark")

onedark.setup({
  style = "deep", -- Opciones: "dark", "darker", "cool", "deep", "warm", "warmer"
  transparent = true,
  term_colors = true, 
  code_style = {
    comments = "italic",
    keywords = "bold", 
    functions = "none",
    strings = "none",
    variables = "none", 
  },
  lualine = {
    transparent = true,
  },
  diagnostics = {
    darker = true, 
    undercurl = true,
    background = true,
  },
})

onedark.load()
