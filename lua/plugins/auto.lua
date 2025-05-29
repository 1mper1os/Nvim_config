local status_ok, autopairs = pcall(require, "nvim-autopairs")
if not status_ok then
  vim.notify("nvim-autopairs not found", vim.log.levels.ERROR)
  return
end


autopairs.setup({

  check_ts = true,
  

  ts_config = {
    lua = { "string", "source" },
    javascript = { "string", "template_string" },
    typescript = { "string", "template_string" },
    jsx = { "string", "template_string" },
    tsx = { "string", "template_string" },
    python = { "string" },
    rust = { "string" },
    go = { "string" },
  },
  

  disable_filetype = { 
    "TelescopePrompt", 
    "vim", 
    "help", 
    "alpha", 
    "dashboard",
    "neo-tree-popup",
    "Trouble",
  },
  

  disable_in_macro = true,
  disable_in_visualblock = false,
  disable_in_replace_mode = true,
  

  ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
  

  fast_wrap = {
    map = "<M-e>",
    chars = { "{", "[", "(", '"', "'" },
    pattern = [=[[%'%"%>%]%)%}%,%s]]=],
    offset = 0,
    end_key = "$",
    keys = "qwertyuiopzxcvbnmasdfghjkl",
    check_comma = true,
    highlight = "PmenuSel",
    highlight_grey = "Comment",
    indent_at_same_level = false,
    cursor_pos_before = true,
  },
  

  enable_check_bracket_line = true,
  

  enable_bracket_in_quote = true,

  enable_abbr = false,

  break_undo = true,

  map_bs = true,
  map_c_h = false,
  map_c_w = false,
})

local Rule = require("nvim-autopairs.rule")
local cond = require("nvim-autopairs.conds")

autopairs.add_rules({
  Rule(" ", " ")
    :with_pair(function(opts)
      local pair = opts.line:sub(opts.col - 1, opts.col)
      return vim.tbl_contains({ "()", "[]", "{}" }, pair)
    end),
    

  Rule("%(.*%)%s*%=>$", " {  }", { "typescript", "typescriptreact", "javascript", "javascriptreact" })
    :use_regex(true)
    :set_end_pair_length(2),
    
  Rule("`", "`", { "typescript", "typescriptreact", "javascript", "javascriptreact" })
    :with_cr(cond.none()),
})


local cmp_status_ok, cmp = pcall(require, "cmp")
if cmp_status_ok then
  local cmp_autopairs = require("nvim-autopairs.completion.cmp")
  

  cmp.event:on(
    "confirm_done",
    cmp_autopairs.on_confirm_done({
      filetypes = {

        ["*"] = {
          ["("] = {
            kind = {
              cmp.lsp.CompletionItemKind.Function,
              cmp.lsp.CompletionItemKind.Method,
            },
            handler = function(char, item, bufnr, rules, commit_character)

              if commit_character == "(" then
                return false
              end
            end,
          },
        },
        lua = {
          ["("] = {
            kind = {
              cmp.lsp.CompletionItemKind.Function,
              cmp.lsp.CompletionItemKind.Method,
            },
          },
        },
      },
    })
  )
else
  vim.notify("nvim-cmp not found, autopairs completion integration disabled", vim.log.levels.WARN)
end


vim.keymap.set("i", "<C-h>", function()
  if autopairs.autopairs_bs() then
    return "<BS>"
  else
    return "<C-h>"
  end
end, { expr = true, desc = "Autopairs backspace" })


vim.notify("nvim-autopairs configured successfully", vim.log.levels.INFO)