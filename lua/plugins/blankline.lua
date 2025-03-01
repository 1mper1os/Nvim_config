local status_ok, ibl = pcall(require, "ibl")
if not status_ok then
  return
end

ibl.setup({
  enabled = true,

  indent = {
    char = "│", 
    tab_char = "│", 
    highlight = { "IndentBlanklineIndent1", "IndentBlanklineIndent2" },
  },

  exclude = {
    filetypes = {
      "help",
      "dashboard",
      "lazy",
      "mason",
      "notify",
      "toggleterm",
      "TelescopePrompt",
      "alpha",
    },
  },

  scope = {
    enabled = true,
    char = "│", 
    show_start = true, 
    show_end = false, 
    highlight = { "Function", "Conditional", "Repeat", "Statement" }, 
  },

  debounce = 100, 
})
