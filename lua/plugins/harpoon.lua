local status_ok, harpoon = pcall(require, "harpoon")
if not status_ok then
  return
end

harpoon.setup({
  global_settings = {
    save_on_toggle = true, 
    enter_on_sendcmd = false,
  },
})

local keymap = vim.keymap.set
keymap("n", "<leader>ha", function() harpoon:list():append() end, { desc = "Añadir archivo a Harpoon" })
keymap("n", "<leader>ht", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Mostrar menú de Harpoon" })
keymap("n", "<leader>hn", function() harpoon:list():next() end, { desc = "Ir al siguiente marcador de Harpoon" })
keymap("n", "<leader>hp", function() harpoon:list():prev() end, { desc = "Ir al marcador anterior de Harpoon" })

for i = 1, 9 do
  keymap("n", "<leader>h" .. i, function() harpoon:list():select(i) end, { desc = "Ir al marcador " .. i })
end

require("harpoon-lualine").setup({
  label = "Harpoon", 
  icon = "⚓",     
})
