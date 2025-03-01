local status_ok, cmp = pcall(require, "cmp")
if not status_ok then
  return
end

local luasnip_status_ok, luasnip = pcall(require, "luasnip")
if not luasnip_status_ok then
  return
end

require("luasnip.loaders.from_vscode").lazy_load()

local kind_icons = {
  Text = "",
  Method = "ƒ",
  Function = "",
  Constructor = "",
  Field = "",
  Variable = "",
  Class = " UClass",
  Interface = "ﰮ",
  Module = "",
  Property = "",
  Unit = "",
  Value = "",
  Enum = "了",
  Keyword = "⌘",
  Snippet = "﬌",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "פּ",
  Event = "",
  Operator = "±",
  TypeParameter = "𝙏",
}

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body) 
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4), 
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),      
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item() 
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump() 
      else
        fallback() 
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item() 
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback() 
      end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },       
    { name = "luasnip" },        
    { name = "buffer" },         
    { name = "path" },           
  }),
  formatting = {
    fields = { "abbr", "kind", "menu" }, 
    format = function(entry, vim_item)
      vim_item.kind = string.format("%s", kind_icons[vim_item.kind] or "") 
      vim_item.menu = ({
        nvim_lsp = "[LSP]",
        luasnip = "[Snippet]",
        buffer = "[Buffer]",
        path = "[Path]",
        ["tailwindcss-colorizer-cmp"] = "[Tailwind]",
      })[entry.source.name]
      return vim_item
    end,
  },
  experimental = {
    ghost_text = true, 
  },
})

cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
    { name = "cmdline" }, 
  }),
})

