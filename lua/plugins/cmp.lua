local status_ok, cmp = pcall(require, "cmp")
if not status_ok then
  vim.notify("nvim-cmp not found", vim.log.levels.ERROR)
  return
end

local luasnip_status_ok, luasnip = pcall(require, "luasnip")
if not luasnip_status_ok then
  vim.notify("luasnip not found", vim.log.levels.ERROR)
  return
end


require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })
require("luasnip.loaders.from_snipmate").lazy_load()
require("luasnip.loaders.from_lua").lazy_load()

luasnip.config.setup({
  history = true,
  updateevents = "TextChanged,TextChangedI",
  delete_check_events = "TextChanged",
  ext_opts = {
    [require("luasnip.util.types").choiceNode] = {
      active = {
        virt_text = { { "●", "DiagnosticWarn" } },
      },
    },
  },
  enable_autosnippets = true,
  store_selection_keys = "<Tab>",
})


local kind_icons = {
  Text = " ",
  Method = " ",
  Function = " ",
  Constructor = " ",
  Field = " ",
  Variable = " ",
  Class = " ",
  Interface = " ",
  Module = " ",
  Property = " ",
  Unit = " ",
  Value = " ",
  Enum = " ",
  Keyword = " ",
  Snippet = " ",
  Color = " ",
  File = " ",
  Reference = " ",
  Folder = " ",
  EnumMember = " ",
  Constant = " ",
  Struct = " ",
  Event = " ",
  Operator = " ",
  TypeParameter = " ",
  Copilot = " ",
  TabNine = " ",
  Array = " ",
  Object = " ",
  Key = " ",
  Null = " ",
  EnumMember = " ",
  Struct = " ",
  Event = " ",
  Operator = " ",
  TypeParameter = " ",
}


local sources = {

  { 
    name = "nvim_lsp", 
    priority = 1000,
    entry_filter = function(entry, ctx)
      
      local kind = entry:get_kind()
      local line = ctx.cursor_line
      local col = ctx.cursor.col
      
      
      if kind == 1 and line:match("[%w_]") then
        return false
      end
      
      return true
    end,
  },
  { 
    name = "luasnip", 
    priority = 900,
    option = {
      show_autosnippets = true,
      use_show_condition = false,
    },
  },
  
  
  { 
    name = "nvim_lsp_signature_help", 
    priority = 800,
  },
  { 
    name = "nvim_lua", 
    priority = 700,
    ft = { "lua" },
  },
  
  
  { 
    name = "path", 
    priority = 500,
    option = {
      trailing_slash = true,
      label_trailing_slash = true,
    },
  },
  { 
    name = "buffer", 
    priority = 400,
    option = {
      get_bufnrs = function()
        
        local bufs = {}
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          bufs[vim.api.nvim_win_get_buf(win)] = true
        end
        return vim.tbl_keys(bufs)
      end,
    },
  },
  
  
  { name = "calc", priority = 200 },
  { name = "emoji", priority = 150 },
  { name = "treesitter", priority = 100 },
}


cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  
  
  window = {
    completion = {
      border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
      scrollbar = "║",
      winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel,Search:None",
      col_offset = -3,
      side_padding = 0,
    },
    documentation = {
      border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
      winhighlight = "Normal:CmpDoc",
      max_width = 80,
      max_height = 20,
    },
  },
  
  
  mapping = cmp.mapping.preset.insert({
   
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-u>"] = cmp.mapping.scroll_docs(-8),
    ["<C-d>"] = cmp.mapping.scroll_docs(8),
    
    
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
    ["<C-e>"] = cmp.mapping.abort(),
    
   
    ["<CR>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        if luasnip.expandable() then
          luasnip.expand()
        else
          cmp.confirm({ select = true })
        end
      else
        fallback()
      end
    end),
    
    
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
      elseif luasnip.locally_jumpable(1) then
        luasnip.jump(1)
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),
    
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
    
    
    ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
  }),
  
 
  sources = cmp.config.sources(sources),
  
  
  formatting = {
    fields = { "kind", "abbr", "menu" },
    format = function(entry, vim_item)
      local kind = vim_item.kind
      local icon = kind_icons[kind] or ""
      
      
      vim_item.kind = string.format(" %s ", icon)
      vim_item.kind_hl_group = "CmpItemKind" .. kind
      
      
      local max_width = 50
      if string.len(vim_item.abbr) > max_width then
        vim_item.abbr = string.sub(vim_item.abbr, 1, max_width - 3) .. "..."
      end
      
      
      local source_names = {
        nvim_lsp = "[LSP]",
        nvim_lsp_signature_help = "[Sig]",
        nvim_lua = "[Lua]",
        luasnip = "[Snip]",
        buffer = "[Buf]",
        path = "[Path]",
        calc = "[Calc]",
        emoji = "[Emoji]",
        treesitter = "[TS]",
        copilot = "[Copilot]",
        cmp_tabnine = "[TN]",
        ["tailwindcss-colorizer-cmp"] = "[TW]",
      }
      
      vim_item.menu = source_names[entry.source.name] or string.format("[%s]", entry.source.name)
      
    
      if entry.source.name == "nvim_lsp" then
        local lsp_name = entry.source.source.client.name
        vim_item.menu = string.format("%s %s", vim_item.menu, lsp_name)
      end
      
      return vim_item
    end,
  },
  
  
  completion = {
    completeopt = "menu,menuone,noinsert",
    keyword_length = 1,
    keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\)]],
  },
  

  experimental = {
    ghost_text = {
      hl_group = "CmpGhostText",
    },
    native_menu = false,
  },
  
  
  performance = {
    debounce = 60,
    throttle = 30,
    fetching_timeout = 500,
    confirm_resolve_timeout = 80,
    async_budget = 1,
    max_view_entries = 200,
  },
  
  
  sorting = {
    priority_weight = 2,
    comparators = {
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.score,
      cmp.config.compare.recently_used,
      cmp.config.compare.locality,
      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },
})


function has_words_before()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
    return false
  end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
end


cmp.setup.cmdline({ "/", "?" }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" },
  },
  completion = {
    completeopt = "menu,menuone,noselect",
  },
})


cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline({
    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" },
  }),
  completion = {
    completeopt = "menu,menuone,noselect",
  },
})


cmp.setup.filetype("gitcommit", {
  sources = cmp.config.sources({
    { name = "git" },
  }, {
    { name = "buffer" },
  }),
})

cmp.setup.filetype("markdown", {
  sources = cmp.config.sources({
    { name = "path" },
    { name = "buffer" },
    { name = "spell" },
  }),
})

local augroup = vim.api.nvim_create_augroup("CmpConfig", { clear = true })


vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "TelescopePrompt", "alpha", "dashboard" },
  callback = function()
    require("cmp").setup.buffer({ enabled = false })
  end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
  group = augroup,
  callback = function()

    vim.api.nvim_set_hl(0, "CmpPmenu", { bg = "NONE", fg = "#C5CDD9" })
    vim.api.nvim_set_hl(0, "CmpSel", { bg = "#282C34", fg = "NONE" })
    vim.api.nvim_set_hl(0, "CmpDoc", { bg = "NONE", fg = "#C5CDD9" })
    vim.api.nvim_set_hl(0, "CmpGhostText", { fg = "#565C64", italic = true })
    

    local kinds = {
      { "CmpItemKindText", "#9CDCFE" },
      { "CmpItemKindMethod", "#C586C0" },
      { "CmpItemKindFunction", "#C586C0" },
      { "CmpItemKindConstructor", "#C586C0" },
      { "CmpItemKindField", "#9CDCFE" },
      { "CmpItemKindVariable", "#9CDCFE" },
      { "CmpItemKindClass", "#FAD5A1" },
      { "CmpItemKindInterface", "#FAD5A1" },
      { "CmpItemKindModule", "#FAD5A1" },
      { "CmpItemKindProperty", "#9CDCFE" },
      { "CmpItemKindUnit", "#B5CEA8" },
      { "CmpItemKindValue", "#B5CEA8" },
      { "CmpItemKindEnum", "#FAD5A1" },
      { "CmpItemKindKeyword", "#569CD6" },
      { "CmpItemKindSnippet", "#DCB67A" },
      { "CmpItemKindColor", "#CE9178" },
      { "CmpItemKindFile", "#DADADA" },
      { "CmpItemKindReference", "#9CDCFE" },
      { "CmpItemKindFolder", "#DADADA" },
      { "CmpItemKindEnumMember", "#B5CEA8" },
      { "CmpItemKindConstant", "#B5CEA8" },
      { "CmpItemKindStruct", "#FAD5A1" },
      { "CmpItemKindEvent", "#FAD5A1" },
      { "CmpItemKindOperator", "#569CD6" },
      { "CmpItemKindTypeParameter", "#FAD5A1" },
    }
    
    for _, kind in ipairs(kinds) do
      vim.api.nvim_set_hl(0, kind[1], { fg = kind[2] })
    end
  end,
})

vim.keymap.set({ "i", "s" }, "<C-l>", function()
  if luasnip.choice_active() then
    luasnip.change_choice(1)
  end
end, { desc = "LuaSnip next choice" })

vim.keymap.set({ "i", "s" }, "<C-h>", function()
  if luasnip.choice_active() then
    luasnip.change_choice(-1)
  end
end, { desc = "LuaSnip previous choice" })

vim.notify("nvim-cmp configured successfully", vim.log.levels.INFO)