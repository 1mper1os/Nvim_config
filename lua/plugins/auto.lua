local status_ok, autopairs = pcall(require, "nvim-autopairs")
if not status_ok then
  return
end

autopairs.setup({
  check_ts = true,
  ts_config = {
    lua = { "string", "source" }, 
    javascript = { "string", "template_string" }, 
  },
  disable_filetype = { "TelescopePrompt", "vim" }, 
  fast_wrap = {
    map = "<M-e>", 
    chars = { "{", "[", "(", '"', "'" },
    pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
    offset = 0, 
    end_key = "$", 
    keys = "qwertyuiopzxcvbnmasdfghjkl", 
    check_comma = true, 
    highlight = "PmenuSel",
    highlight_grey = "LineNr", 
  },
  enable_check_bracket_line = true,
})

local cmp_status_ok, cmp = pcall(require, "cmp")
if cmp_status_ok then
  local cmp_autopairs = require("nvim-autopairs.completion.cmp")
  cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end
