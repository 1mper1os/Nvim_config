local status_ok, twilight = pcall(require, "twilight")
if not status_ok then
  vim.notify("Error: No se pudo cargar el plugin Twilight", vim.log.levels.WARN)
  return
end

twilight.setup({

  dimming = {
    alpha = 0.25,                    
    color = { "Normal", "#000000" }, 
    term_bg = "#000000",             
    inactive = false,                
  },

  context = 10,

  treesitter = true,

  expand = {
    "function",           
    "method",            
    "table",            
    "if_statement",     
    "for_statement",    
    "while_statement",   
    "repeat_statement",  
  },

  exclude = {
    "alpha",           
    "dashboard",       
    "neo-tree",        
    "nvim-tree",      
    "toggleterm",     
    "trouble",         
    "help",           
    "man",            
    "gitcommit",      
    "TelescopePrompt", 
    "TelescopeResults",
  },

  on_open = function()
  
    vim.cmd("set laststatus=0")
    vim.notify("Modo Twilight activado - Enfoque mejorado", vim.log.levels.INFO)
  end,

  on_close = function()

    vim.cmd("set laststatus=2")
    
    vim.notify("Modo Twilight desactivado", vim.log.levels.INFO)
  end,
})

vim.keymap.set("n", "<leader>tw", "<cmd>Twilight<cr>", { 
  desc = "Toggle Twilight mode",
  silent = true 
})

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
   
    vim.cmd("hi TwilightDim guifg=#545c7e")
  end,
})