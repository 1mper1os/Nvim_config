
local M = {}

local function safe_require(module)
  local ok, result = pcall(require, module)
  if not ok then
    vim.notify("Error al cargar " .. module .. ": " .. result, vim.log.levels.ERROR)
    return nil
  end
  return result
end

local harpoon = safe_require("harpoon")
if not harpoon then
  return M
end

harpoon.setup({
  global_settings = {
    save_on_toggle = true,
    save_on_change = true,
    enter_on_sendcmd = false,
    tmux_autoclose_windows = false,
  },
  default = {

    get_root_dir = function()
      return vim.loop.cwd()
    end,

    create_list_item = function(config, name)
     
      local excluded_extensions = { ".git", ".DS_Store", "node_modules" }
      for _, ext in ipairs(excluded_extensions) do
        if string.find(name, ext) then
          return nil
        end
      end
      return {
        value = name,
        context = { row = 1, col = 0 }
      }
    end,
  },
})

local function setup_keymaps()
  local keymap = vim.keymap.set
  local opts = { noremap = true, silent = true }

  keymap("n", "<leader>ha", function() 
    harpoon:list():add()
    vim.notify("Archivo añadido a Harpoon", vim.log.levels.INFO)
  end, vim.tbl_extend("force", opts, { desc = "Añadir archivo a Harpoon" }))
  
  keymap("n", "<leader>ht", function() 
    harpoon.ui:toggle_quick_menu(harpoon:list()) 
  end, vim.tbl_extend("force", opts, { desc = "Mostrar menú de Harpoon" }))
  
  keymap("n", "<leader>hr", function() 
    harpoon:list():remove()
    vim.notify("Archivo removido de Harpoon", vim.log.levels.INFO)
  end, vim.tbl_extend("force", opts, { desc = "Remover archivo de Harpoon" }))
  
  keymap("n", "<leader>hc", function() 
    harpoon:list():clear()
    vim.notify("Lista de Harpoon limpiada", vim.log.levels.INFO)
  end, vim.tbl_extend("force", opts, { desc = "Limpiar lista de Harpoon" }))

  keymap("n", "<leader>hn", function() 
    harpoon:list():next({ ui_nav_wrap = true })
  end, vim.tbl_extend("force", opts, { desc = "Ir al siguiente marcador de Harpoon" }))
  
  keymap("n", "<leader>hp", function() 
    harpoon:list():prev({ ui_nav_wrap = true })
  end, vim.tbl_extend("force", opts, { desc = "Ir al marcador anterior de Harpoon" }))

  for i = 1, 9 do
    keymap("n", "<leader>h" .. i, function() 
      harpoon:list():select(i)
    end, vim.tbl_extend("force", opts, { desc = "Ir al marcador " .. i }))
  end

  keymap("n", "<C-h>", function() 
    harpoon.ui:toggle_quick_menu(harpoon:list()) 
  end, vim.tbl_extend("force", opts, { desc = "Toggle rápido de Harpoon" }))

  for i = 1, 4 do
    keymap("n", "<C-" .. i .. ">", function() 
      harpoon:list():select(i)
    end, vim.tbl_extend("force", opts, { desc = "Ir al marcador " .. i .. " (Ctrl)" }))
  end
end

local function setup_lualine_integration()
  local harpoon_lualine = safe_require("harpoon-lualine")
  if harpoon_lualine then
    harpoon_lualine.setup({
      label = "⚓ Harpoon",
      icon = "⚓",
      indicators = { "1", "2", "3", "4", "5", "6", "7", "8", "9" },
      active_indicators = { "●", "●", "●", "●", "●", "●", "●", "●", "●" },
      separator = " | ",
    })
  end
end

M.show_info = function()
  local list = harpoon:list()
  local items = list.items or {}
  
  if #items == 0 then
    vim.notify("No hay archivos en Harpoon", vim.log.levels.INFO)
    return
  end
  
  local info = "Archivos en Harpoon:\n"
  for i, item in ipairs(items) do
    info = info .. i .. ". " .. (item.value or "Sin nombre") .. "\n"
  end
  
  vim.notify(info, vim.log.levels.INFO)
end

M.export_list = function()
  local list = harpoon:list()
  local items = {}
  
  for _, item in ipairs(list.items or {}) do
    table.insert(items, item.value)
  end
  
  local json = vim.fn.json_encode(items)
  vim.fn.setreg('+', json)
  vim.notify("Lista de Harpoon copiada al portapapeles", vim.log.levels.INFO)
end

local function setup_autocommands()
  local augroup = vim.api.nvim_create_augroup("HarpoonConfig", { clear = true })

  vim.api.nvim_create_autocmd("User", {
    pattern = "HarpoonListChanged",
    group = augroup,
    callback = function()
      vim.notify("Lista de Harpoon actualizada", vim.log.levels.DEBUG)
    end,
  })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "harpoon",
    group = augroup,
    callback = function()
      vim.opt_local.cursorline = true
      vim.opt_local.number = true
      vim.opt_local.relativenumber = false
    end,
  })
end

local function init()
  setup_keymaps()
  setup_lualine_integration()
  setup_autocommands()
  

  vim.api.nvim_create_user_command('HarpoonInfo', M.show_info, { desc = 'Mostrar información de Harpoon' })
  vim.api.nvim_create_user_command('HarpoonExport', M.export_list, { desc = 'Exportar lista de Harpoon' })
end


init()

return M