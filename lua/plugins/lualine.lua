local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
  return
end

local status_icons_ok, icons = pcall(require, "nvim-web-devicons")
if not status_icons_ok then
  print("nvim-web-devicons no está instalado. Los íconos no estarán disponibles.")
end

lualine.setup({
  options = {
    icons_enabled = true, 
    theme = "auto",     
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },  
    disabled_filetypes = {},
    always_divide_middle = true, 
    globalstatus = false, 
  },
  sections = {
    lualine_a = { "mode" }, 
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = { 
      {
        "filename",
        path = 1, 
        symbols = {
          modified = "[+]",
          readonly = "[-]", 
          unnamed = "[No Name]", 
        },
      },
      "harpoon-lualine",
    },
    lualine_x = { "encoding", "fileformat", "filetype" }, 
    lualine_y = { "progress" }, 
    lualine_z = { "location" },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { "filename" },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {}, 
  extensions = {
    "nvim-tree", 
    "toggleterm", 
    "quickfix", 
  },
})
