
local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then
  vim.notify("ToggleTerm plugin not found", vim.log.levels.ERROR)
  return
end

toggleterm.setup({
  size = function(term)
    if term.direction == "horizontal" then
      return 15
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.4
    end
    return 20
  end,
  open_mapping = [[<C-\>]],
  hide_numbers = true,
  shade_filetypes = {},
  shade_terminals = true,
  shading_factor = 2,
  start_in_insert = true,
  insert_mappings = true,
  terminal_mappings = true,
  persist_size = true,
  persist_mode = true,
  direction = "float",
  close_on_exit = true,
  shell = vim.o.shell,
  auto_scroll = true,
  float_opts = {
    border = "curved",
    width = math.floor(vim.o.columns * 0.8),
    height = math.floor(vim.o.lines * 0.8),
    winblend = 10,
    highlights = {
      border = "Normal",
      background = "Normal",
    },
  },
  winbar = {
    enabled = false,
    name_formatter = function(term)
      return term.name
    end
  },
})

local Terminal = require("toggleterm.terminal").Terminal

local lazygit = Terminal:new({
  cmd = "lazygit",
  dir = "git_dir",
  direction = "float",
  hidden = true,
  float_opts = {
    border = "curved",
    width = math.floor(vim.o.columns * 0.9),
    height = math.floor(vim.o.lines * 0.9),
    winblend = 5,
  },
  on_open = function(term)
    vim.cmd("startinsert!")
    vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", {noremap = true, silent = true})
  end,
  on_close = function(term)
    vim.cmd("startinsert!")
  end,
})

local node = Terminal:new({
  cmd = "node",
  hidden = true,
  direction = "float",
  float_opts = {
    border = "curved",
    width = math.floor(vim.o.columns * 0.7),
    height = math.floor(vim.o.lines * 0.7),
  },
})

local python = Terminal:new({
  cmd = "python3",
  hidden = true,
  direction = "float",
  float_opts = {
    border = "curved",
    width = math.floor(vim.o.columns * 0.7),
    height = math.floor(vim.o.lines * 0.7),
  },
})

local htop = Terminal:new({
  cmd = "htop",
  hidden = true,
  direction = "float",
  float_opts = {
    border = "curved",
    width = math.floor(vim.o.columns * 0.9),
    height = math.floor(vim.o.lines * 0.9),
  },
})

function _G.lazygit_toggle()
  lazygit:toggle()
end

function _G.node_toggle()
  node:toggle()
end

function _G.python_toggle()
  python:toggle()
end

function _G.htop_toggle()
  htop:toggle()
end


function _G.set_terminal_horizontal()
  vim.cmd("ToggleTerm size=15 direction=horizontal")
end


function _G.set_terminal_vertical()
  vim.cmd("ToggleTerm size=" .. math.floor(vim.o.columns * 0.4) .. " direction=vertical")
end


local opts = { noremap = true, silent = true }


vim.keymap.set("n", "<leader>tf", "<cmd>ToggleTerm direction=float<CR>", 
  vim.tbl_extend("force", opts, { desc = "Toggle Float Terminal" }))
vim.keymap.set("n", "<leader>th", "<cmd>lua _G.set_terminal_horizontal()<CR>", 
  vim.tbl_extend("force", opts, { desc = "Toggle Horizontal Terminal" }))
vim.keymap.set("n", "<leader>tv", "<cmd>lua _G.set_terminal_vertical()<CR>", 
  vim.tbl_extend("force", opts, { desc = "Toggle Vertical Terminal" }))


vim.keymap.set("n", "<leader>tg", "<cmd>lua _G.lazygit_toggle()<CR>", 
  vim.tbl_extend("force", opts, { desc = "Toggle LazyGit" }))
vim.keymap.set("n", "<leader>tn", "<cmd>lua _G.node_toggle()<CR>", 
  vim.tbl_extend("force", opts, { desc = "Toggle Node Terminal" }))
vim.keymap.set("n", "<leader>tp", "<cmd>lua _G.python_toggle()<CR>", 
  vim.tbl_extend("force", opts, { desc = "Toggle Python Terminal" }))
vim.keymap.set("n", "<leader>tt", "<cmd>lua _G.htop_toggle()<CR>", 
  vim.tbl_extend("force", opts, { desc = "Toggle Htop" }))


function _G.set_terminal_keymaps()
  local term_opts = { buffer = 0 }
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], term_opts)
  vim.keymap.set('t', 'jk', [[<C-\><C-n>]], term_opts)
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], term_opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], term_opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], term_opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], term_opts)
  vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], term_opts)
end


vim.cmd('autocmd! TermOpen term://* lua _G.set_terminal_keymaps()')

vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "term://*",
  callback = function()
    local opts = { buffer = 0 }

    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
  
    vim.cmd("startinsert")
  end,
})