local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
  return
end

local actions = require("telescope.actions")

telescope.setup({
  defaults = {
    prompt_prefix = " ", 
    selection_caret = " ",
    path_display = { "smart" }, 
    file_ignore_patterns = { 
      ".git/",
      "node_modules/",
      "%.lock",
      "__pycache__/",
    },
    mappings = {
      i = {
        ["<C-n>"] = actions.cycle_history_next, 
        ["<C-p>"] = actions.cycle_history_prev,
        ["<C-j>"] = actions.move_selection_next, 
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-c>"] = actions.close, 
        ["<CR>"] = actions.select_default, 
        ["<C-x>"] = actions.select_horizontal, 
        ["<C-v>"] = actions.select_vertical, 
        ["<C-t>"] = actions.select_tab,
      },
      n = {
        ["<C-n>"] = actions.cycle_history_next,
        ["<C-p>"] = actions.cycle_history_prev,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-c>"] = actions.close,
        ["<CR>"] = actions.select_default,
        ["<C-x>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-t>"] = actions.select_tab,
      },
    },
  },
  extensions = {
    fzf = {
      fuzzy = true, 
      override_generic_sorter = true,
      override_file_sorter = true, 
      case_mode = "smart_case", 
    },
  },
})

local status_fzf_ok, fzf = pcall(require, "telescope._extensions.fzf")
if status_fzf_ok then
  telescope.load_extension("fzf")
end

local telescope_builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>ff", telescope_builtin.find_files, { desc = "Buscar archivos" })
vim.keymap.set("n", "<leader>fg", telescope_builtin.live_grep, { desc = "Buscar texto en archivos" })
vim.keymap.set("n", "<leader>fb", telescope_builtin.buffers, { desc = "Buscar buffers abiertos" })
vim.keymap.set("n", "<leader>fh", telescope_builtin.help_tags, { desc = "Buscar ayuda de Vim/Neovim" })
vim.keymap.set("n", "<leader>fo", telescope_builtin.oldfiles, { desc = "Buscar archivos recientes" })
vim.keymap.set("n", "<leader>fw", telescope_builtin.grep_string, { desc = "Buscar palabra bajo el cursor" })
vim.keymap.set("n", "<leader>fc", telescope_builtin.commands, { desc = "Buscar comandos de Neovim" })
vim.keymap.set("n", "<leader>fk", telescope_builtin.keymaps, { desc = "Buscar mapeos de teclado" })
vim.keymap.set("n", "<leader>fs", telescope_builtin.lsp_document_symbols, { desc = "Buscar símbolos en el documento" })
vim.keymap.set("n", "<leader>fS", telescope_builtin.lsp_workspace_symbols, { desc = "Buscar símbolos en el workspace" })
