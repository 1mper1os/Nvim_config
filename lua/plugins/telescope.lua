local M = {}

local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
  vim.notify("Telescope no está instalado", vim.log.levels.ERROR)
  return M
end

local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

telescope.setup({
  defaults = {
    prompt_prefix = "🔍 ",
    selection_caret = "➤ ",
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "ascending",
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.55,
        results_width = 0.8,
      },
      vertical = {
        mirror = false,
      },
      width = 0.87,
      height = 0.80,
      preview_cutoff = 120,
    },
    path_display = { "truncate" },
    file_ignore_patterns = {
      "^.git/",
      "^node_modules/",
      "%.lock$",
      "^__pycache__/",
      "%.pyc$",
      "^target/",
      "^build/",
      "^dist/",
      "%.min%.js$",
      "%.min%.css$",
      "^vendor/",
      "%.DS_Store$",
    },
    mappings = {
      i = {
        ["<C-n>"] = actions.cycle_history_next,
        ["<C-p>"] = actions.cycle_history_prev,

        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,

        ["<C-c>"] = actions.close,
        ["<Esc>"] = actions.close,

        ["<CR>"] = actions.select_default,
        ["<C-s>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-t>"] = actions.select_tab,

        ["<C-u>"] = actions.preview_scrolling_up,
        ["<C-d>"] = actions.preview_scrolling_down,

        ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
        ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
      },
      n = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["j"] = actions.move_selection_next,
        ["k"] = actions.move_selection_previous,
        ["H"] = actions.move_to_top,
        ["M"] = actions.move_to_middle,
        ["L"] = actions.move_to_bottom,

        ["<CR>"] = actions.select_default,
        ["<C-s>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-t>"] = actions.select_tab,

        ["<Esc>"] = actions.close,
        ["q"] = actions.close,

        ["<C-u>"] = actions.preview_scrolling_up,
        ["<C-d>"] = actions.preview_scrolling_down,

        ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
        ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
      },
    },
    winblend = 0,
    border = {},
    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    color_devicons = true,
    use_less = true,
    set_env = { ["COLORTERM"] = "truecolor" },
    file_previewer = require("telescope.previewers").vim_buffer_cat.new,
    grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
    qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
  },
  pickers = {
    find_files = {
      theme = "dropdown",
      previewer = false,
      hidden = false,
      find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
    },
    live_grep = {
      additional_args = function(opts)
        return {"--hidden"}
      end
    },
    buffers = {
      theme = "dropdown",
      previewer = false,
      initial_mode = "normal",
      mappings = {
        i = {
          ["<C-d>"] = actions.delete_buffer,
        },
        n = {
          ["dd"] = actions.delete_buffer,
        },
      },
    },
    oldfiles = {
      theme = "dropdown",
      previewer = false,
    },
    help_tags = {
      theme = "ivy",
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

-- Cargar extensiones
local extensions = { "fzf" }

for _, ext in ipairs(extensions) do
  local loaded_ok, _ = pcall(telescope.load_extension, ext)
  if not loaded_ok then
    vim.notify(string.format("No se pudo cargar la extensión de Telescope: %s", ext), vim.log.levels.WARN)
  end
end

-- Función auxiliar para mapear teclas
local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

local builtin = require("telescope.builtin")

-- Mapeos principales
map("n", "<leader>ff", builtin.find_files, { desc = "🔍 Buscar archivos" })
map("n", "<leader>fF", function()
  builtin.find_files({ hidden = true })
end, { desc = "🔍 Buscar archivos (incluir ocultos)" })

map("n", "<leader>fg", builtin.live_grep, { desc = "🔍 Buscar texto en archivos" })
map("n", "<leader>fw", builtin.grep_string, { desc = "🔍 Buscar palabra bajo el cursor" })
map("n", "<leader>fW", function()
  builtin.grep_string({ search = vim.fn.expand("<cWORD>") })
end, { desc = "🔍 Buscar WORD bajo el cursor" })

map("n", "<leader>fb", builtin.buffers, { desc = "📋 Buscar buffers abiertos" })
map("n", "<leader>fo", builtin.oldfiles, { desc = "📁 Buscar archivos recientes" })

map("n", "<leader>fh", builtin.help_tags, { desc = "❓ Buscar ayuda de Vim/Neovim" })
map("n", "<leader>fm", builtin.man_pages, { desc = "📖 Buscar páginas del manual" })

map("n", "<leader>fc", builtin.commands, { desc = "⚡ Buscar comandos de Neovim" })
map("n", "<leader>fk", builtin.keymaps, { desc = "⌨️  Buscar mapeos de teclado" })
map("n", "<leader>fr", builtin.registers, { desc = "📝 Buscar registros" })

map("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "🔤 Buscar símbolos en el documento" })
map("n", "<leader>fS", builtin.lsp_workspace_symbols, { desc = "🔤 Buscar símbolos en el workspace" })
map("n", "<leader>fd", builtin.diagnostics, { desc = "🩺 Buscar diagnósticos" })

map("n", "<leader>gf", builtin.git_files, { desc = "🔍 Buscar archivos de Git" })
map("n", "<leader>gc", builtin.git_commits, { desc = "📝 Buscar commits de Git" })
map("n", "<leader>gb", builtin.git_branches, { desc = "🌿 Buscar ramas de Git" })
map("n", "<leader>gs", builtin.git_status, { desc = "📊 Estado de Git" })

map("n", "<leader>ft", builtin.colorscheme, { desc = "🎨 Cambiar colorscheme" })
map("n", "<leader>fH", builtin.highlights, { desc = "🎨 Buscar grupos de highlight" })

map("n", "<leader>f/", function()
  builtin.current_buffer_fuzzy_find({ skip_empty_lines = true })
end, { desc = "🔍 Buscar en buffer actual" })

map("n", "<leader>f?", builtin.search_history, { desc = "🔍 Historial de búsquedas" })
map("n", "<leader>f:", builtin.command_history, { desc = "⚡ Historial de comandos" })

map("n", "<leader>fn", function()
  builtin.find_files({
    prompt_title = "Config Neovim",
    cwd = vim.fn.stdpath("config"),
  })
end, { desc = "⚙️  Buscar en config de Neovim" })

vim.notify("Telescope configurado correctamente", vim.log.levels.INFO)

return M