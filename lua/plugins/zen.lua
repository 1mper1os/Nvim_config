local status_ok, zen_mode = pcall(require, "zen-mode")
if not status_ok then
  vim.notify("Error: No se pudo cargar Zen Mode", vim.log.levels.WARN)
  return
end

local twilight_available = pcall(require, "twilight")
if not twilight_available then
  vim.notify("Info: Twilight no disponible. Zen Mode funcionará sin atenuación.", vim.log.levels.INFO)
end

local zen_state = {
  saved_options = {},
  was_transparent = false,
  original_colorscheme = nil,
}

local function save_current_options()
  zen_state.saved_options = {
    laststatus = vim.o.laststatus,
    showtabline = vim.o.showtabline,
    cmdheight = vim.o.cmdheight,
    showmode = vim.o.showmode,
    ruler = vim.o.ruler,
    showcmd = vim.o.showcmd,
    scrolloff = vim.o.scrolloff,
    sidescrolloff = vim.o.sidescrolloff,
    winbar = vim.o.winbar,
    foldcolumn = vim.wo.foldcolumn,
  }
  
  zen_state.original_colorscheme = vim.g.colors_name
end

local function restore_saved_options()
  for option, value in pairs(zen_state.saved_options) do
    if option == "foldcolumn" then
      vim.wo[option] = value
    else
      vim.o[option] = value
    end
  end
  
  if zen_state.original_colorscheme and zen_state.original_colorscheme ~= vim.g.colors_name then
    vim.cmd("colorscheme " .. zen_state.original_colorscheme)
  end
end

local function apply_zen_theme()
  
  vim.cmd([[
    highlight ZenBg guibg=#1a1a1a
    highlight ZenText guifg=#d4d4d4
    highlight ZenComment guifg=#6a6a6a
    highlight ZenCursor guibg=#ffffff
  ]])
end

zen_mode.setup({

  window = {
    backdrop = 0.55,             
    width = 120,              
    height = 0.85,           
    
   
    options = {

      number = false,             
      relativenumber = false,    
      cursorline = true,        
      cursorcolumn = false,      
      signcolumn = "no",         
      foldcolumn = "0",          

      list = false,             
      wrap = true,                
      linebreak = true,      
      colorcolumn = "",          

      scrolloff = 10,            
      sidescrolloff = 15,        
    },
  },
  
  plugins = {

    options = {
      enabled = true,
      ruler = false,          
      showcmd = false,            
      showmode = false,        
      laststatus = 0,            
      showtabline = 0,            
      cmdheight = 1,              
    },
  },
 
  on_open = function(win)
   
    save_current_options()
    
    vim.cmd("set laststatus=0")   
    vim.cmd("set showtabline=0")     
    vim.cmd("set cmdheight=1")      
    vim.cmd("set showmode")          
    vim.cmd("set noshowcmd")       
    vim.cmd("set noruler")           
    
    vim.wo.winbar = ""             
    vim.wo.foldcolumn = "0"          
    
    apply_zen_theme()
    
    vim.cmd("normal! zz")
    
    vim.cmd("autocmd! CursorHold")
    vim.cmd("autocmd! CursorHoldI")
    
    vim.notify("🧘 Zen Mode activado - Enfoque total", vim.log.levels.INFO)
    
  end,
  
  on_close = function()
    
    restore_saved_options()
    
    vim.cmd("doautocmd VimEnter")   
    
    vim.cmd("redraw!")
    
    vim.notify("📝 Zen Mode desactivado - Regreso al trabajo", vim.log.levels.INFO)
    
  end,
})

local keymap = vim.keymap.set
local opts = { silent = true, noremap = true }

keymap("n", "<leader>z", "<cmd>ZenMode<CR>", 
       vim.tbl_extend("force", opts, { desc = "Toggle Zen Mode" }))

keymap("n", "<leader>zf", function()
  zen_mode.toggle({
    window = { width = 80 }  
  })
end, vim.tbl_extend("force", opts, { desc = "Zen Mode Focus (estrecho)" }))

keymap("n", "<leader>zw", function()
  zen_mode.toggle({
    window = { width = 160 } 
  })
end, vim.tbl_extend("force", opts, { desc = "Zen Mode Wide (ancho)" }))

keymap("n", "<leader>zm", function()
  zen_mode.toggle({
    window = { 
      width = 100,
      height = 0.9,
      backdrop = 0.7
    }
  })
end, vim.tbl_extend("force", opts, { desc = "Zen Mode Minimal (minimalista)" }))

keymap("n", "<leader>zn", function()
  zen_mode.toggle({
    plugins = { twilight = { enabled = false } }
  })
end, vim.tbl_extend("force", opts, { desc = "Zen Mode sin atenuación" }))

local zen_group = vim.api.nvim_create_augroup("ZenModeEnhancements", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = zen_group,
  pattern = { "markdown", "text", "tex", "rst", "asciidoc" },
  callback = function()
    
  end,
})

vim.api.nvim_create_autocmd("User", {
  group = zen_group,
  pattern = "ZenMode",
  callback = function(event)
    if event.data.open then
      
      if vim.bo.filetype == "markdown" or vim.bo.filetype == "text" then
        vim.wo.spell = true
        vim.wo.spelllang = "es,en"
      end
      
      vim.wo.linebreak = true
      vim.wo.breakindent = true
      vim.wo.breakindentopt = "shift:2"
      
      vim.wo.scrolloff = 999 
    else
      
      vim.wo.spell = false
      vim.wo.scrolloff = 8
    end
  end,
})

vim.api.nvim_create_autocmd("CmdlineEnter", {
  group = zen_group,
  callback = function()

  end,
})

vim.api.nvim_create_user_command("ZenFocus", function(opts)
  local width = tonumber(opts.args) or 100
  zen_mode.toggle({
    window = { width = width }
  })
end, { 
  nargs = "?", 
  desc = "Zen Mode con ancho personalizado" 
})

vim.api.nvim_create_user_command("ZenPresent", function()
  zen_mode.toggle({
    window = { 
      width = 200, 
      height = 0.95,
      backdrop = 0.9
    },
    plugins = {
      twilight = { enabled = false }
    }
  })
end, { desc = "Zen Mode para presentaciones" })

vim.notify("Zen Mode configurado correctamente 🧘", vim.log.levels.INFO)