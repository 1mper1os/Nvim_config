local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then
  return
end

toggleterm.setup({
  size = 20, 
  open_mapping = [[<C-\>]], 
  hide_numbers = true,
  shade_filetypes = {}, 
  shade_terminals = false, 
  start_in_insert = true, 
  insert_mappings = true, 
  persist_size = true,
  direction = "float", 
  close_on_exit = true, 
  shell = vim.o.shell,
  float_opts = {
    border = "none", 
    winblend = 0, 
    highlights = {
      background = "Normal",
    },
  },
})

local Terminal = require("toggleterm.terminal").Terminal

local lazygit = Terminal:new({
  cmd = "lazygit",
  hidden = true, 
  direction = "float", 
  float_opts = {
    border = "none", 
    winblend = 0, 
  },
})

function _lazygit_toggle()
  lazygit:toggle()
end

vim.keymap.set("n", "<leader>tg", "<cmd>ToggleTerm<CR>", { desc = "Toggle Terminal" }) 
vim.keymap.set("n", "<leader>tl", "<cmd>lua _lazygit_toggle()<CR>", { desc = "Toggle LazyGit" }) 
