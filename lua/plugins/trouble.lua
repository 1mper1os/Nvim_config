local status_ok, trouble = pcall(require, "trouble")
if not status_ok then
  vim.notify("Trouble plugin not found", vim.log.levels.ERROR)
  return
end

trouble.setup({
  position = "bottom",
  height = 10,
  width = 50,
  icons = true,

  -- 🔧 Aquí está la corrección principal
  mode = { "workspace_diagnostics", "lsp_references", "loclist" },

  severity = nil,
  fold_open = "",
  fold_closed = "",
  group = true,
  padding = true,
  cycle_results = true,
  action_keys = {
    close = "q",
    cancel = "<esc>",
    refresh = "r",
    jump = { "<cr>", "<tab>", "<2-leftmouse>" },
    open_split = { "<c-x>" },
    open_vsplit = { "<c-v>" },
    open_tab = { "<c-t>" },
    jump_close = { "o" },
    toggle_mode = "m",
    switch_severity = "s",
    toggle_preview = "P",
    hover = "K",
    preview = "p",
    open_code_href = "c",
    close_folds = { "zM", "zm" },
    open_folds = { "zR", "zr" },
    toggle_fold = { "zA", "za" },
    previous = "k",
    next = "j",
    help = "?",
  },
  multiline = true,
  indent_lines = true,
  win_config = { border = "single" },
  auto_open = false,
  auto_close = true,
  auto_preview = true,
  auto_fold = false,
  auto_jump = { "lsp_definitions" },
  signs = {
    error = "",
    warning = "",
    hint = "",
    information = "",
    other = "",
  },
  use_diagnostic_signs = false,
  include_declaration = {
    "lsp_references",
    "lsp_implementations",
    "lsp_definitions",
  },
  modes = {
    lsp_references = {
      mode = "lsp_references",
      auto_open = false,
      auto_close = true,
      auto_preview = true,
      auto_fold = false,
      auto_jump = false,
      restore = true,
      focus = false,
    },
    lsp_definitions = {
      mode = "lsp_definitions",
      auto_open = false,
      auto_close = true,
      auto_preview = true,
      auto_fold = false,
      auto_jump = { "lsp_definitions" },
      restore = true,
      focus = false,
    },
    lsp_implementations = {
      mode = "lsp_implementations",
      auto_open = false,
      auto_close = true,
      auto_preview = true,
      auto_fold = false,
      auto_jump = { "lsp_implementations" },
      restore = true,
      focus = false,
    },
    lsp_type_definitions = {
      mode = "lsp_type_definitions",
      auto_open = false,
      auto_close = true,
      auto_preview = true,
      auto_fold = false,
      auto_jump = { "lsp_type_definitions" },
      restore = true,
      focus = false,
    },
    workspace_diagnostics = {
      mode = "diagnostics",
      source = "workspace",
    },
    document_diagnostics = {
      mode = "diagnostics",
      source = "document",
    },
    quickfix = {
      mode = "quickfix",
    },
    loclist = {
      mode = "loclist",
    },
  },
})

-- Funciones de toggle y mapeos (están bien, no necesitan cambios)
local function toggle_trouble_mode(mode)
  local current_mode = trouble.get_mode()
  if current_mode == mode then
    trouble.close()
  else
    trouble.open(mode)
  end
end

function _G.trouble_workspace_diagnostics()
  toggle_trouble_mode("workspace_diagnostics")
end

function _G.trouble_document_diagnostics()
  toggle_trouble_mode("document_diagnostics")
end

function _G.trouble_lsp_references()
  toggle_trouble_mode("lsp_references")
end

function _G.trouble_lsp_definitions()
  toggle_trouble_mode("lsp_definitions")
end

function _G.trouble_lsp_implementations()
  toggle_trouble_mode("lsp_implementations")
end

function _G.trouble_lsp_type_definitions()
  toggle_trouble_mode("lsp_type_definitions")
end

function _G.trouble_quickfix()
  toggle_trouble_mode("quickfix")
end

function _G.trouble_loclist()
  toggle_trouble_mode("loclist")
end

function _G.show_diagnostic_stats()
  local diagnostics = vim.diagnostic.get()
  local stats = { error = 0, warn = 0, info = 0, hint = 0 }

  for _, diagnostic in ipairs(diagnostics) do
    if diagnostic.severity == vim.diagnostic.severity.ERROR then
      stats.error = stats.error + 1
    elseif diagnostic.severity == vim.diagnostic.severity.WARN then
      stats.warn = stats.warn + 1
    elseif diagnostic.severity == vim.diagnostic.severity.INFO then
      stats.info = stats.info + 1
    elseif diagnostic.severity == vim.diagnostic.severity.HINT then
      stats.hint = stats.hint + 1
    end
  end

  local total = stats.error + stats.warn + stats.info + stats.hint
  vim.notify(string.format("Diagnostics: %d total (E:%d W:%d I:%d H:%d)",
    total, stats.error, stats.warn, stats.info, stats.hint), vim.log.levels.INFO)
end

local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<leader>xx", "<cmd>lua _G.trouble_workspace_diagnostics()<CR>",
  vim.tbl_extend("force", opts, { desc = "Workspace Diagnostics (Trouble)" }))
vim.keymap.set("n", "<leader>xX", "<cmd>lua _G.trouble_document_diagnostics()<CR>",
  vim.tbl_extend("force", opts, { desc = "Document Diagnostics (Trouble)" }))
vim.keymap.set("n", "<leader>xr", "<cmd>lua _G.trouble_lsp_references()<CR>",
  vim.tbl_extend("force", opts, { desc = "LSP References (Trouble)" }))
vim.keymap.set("n", "<leader>xd", "<cmd>lua _G.trouble_lsp_definitions()<CR>",
  vim.tbl_extend("force", opts, { desc = "LSP Definitions (Trouble)" }))
vim.keymap.set("n", "<leader>xi", "<cmd>lua _G.trouble_lsp_implementations()<CR>",
  vim.tbl_extend("force", opts, { desc = "LSP Implementations (Trouble)" }))
vim.keymap.set("n", "<leader>xt", "<cmd>lua _G.trouble_lsp_type_definitions()<CR>",
  vim.tbl_extend("force", opts, { desc = "LSP Type Definitions (Trouble)" }))
vim.keymap.set("n", "<leader>xq", "<cmd>lua _G.trouble_quickfix()<CR>",
  vim.tbl_extend("force", opts, { desc = "Quickfix (Trouble)" }))
vim.keymap.set("n", "<leader>xl", "<cmd>lua _G.trouble_loclist()<CR>",
  vim.tbl_extend("force", opts, { desc = "Location List (Trouble)" }))
vim.keymap.set("n", "[x", function()
  if trouble.is_open() then
    trouble.previous({ skip_groups = true, jump = true })
  else
    vim.diagnostic.goto_prev()
  end
end, vim.tbl_extend("force", opts, { desc = "Previous Diagnostic" }))
vim.keymap.set("n", "]x", function()
  if trouble.is_open() then
    trouble.next({ skip_groups = true, jump = true })
  else
    vim.diagnostic.goto_next()
  end
end, vim.tbl_extend("force", opts, { desc = "Next Diagnostic" }))

vim.keymap.set("n", "<leader>xe", function()
  trouble.open("workspace_diagnostics", { severity = vim.diagnostic.severity.ERROR })
end, vim.tbl_extend("force", opts, { desc = "Errors Only (Trouble)" }))

vim.keymap.set("n", "<leader>xw", function()
  trouble.open("workspace_diagnostics", {
    severity = { min = vim.diagnostic.severity.WARN, max = vim.diagnostic.severity.ERROR }
  })
end, vim.tbl_extend("force", opts, { desc = "Errors & Warnings (Trouble)" }))

vim.keymap.set("n", "<leader>xs", "<cmd>lua _G.show_diagnostic_stats()<CR>",
  vim.tbl_extend("force", opts, { desc = "Show Diagnostic Stats" }))
vim.keymap.set("n", "<leader>xc", "<cmd>TroubleClose<CR>",
  vim.tbl_extend("force", opts, { desc = "Close Trouble" }))
vim.keymap.set("n", "<leader>xR", "<cmd>TroubleRefresh<CR>",
  vim.tbl_extend("force", opts, { desc = "Refresh Trouble" }))

local trouble_group = vim.api.nvim_create_augroup("TroubleConfig", { clear = true })

vim.api.nvim_create_autocmd("DiagnosticChanged", {
  group = trouble_group,
  callback = function()
    local diagnostics = vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    if #diagnostics > 5 and not trouble.is_open() then
      vim.notify("Many errors detected, opening Trouble", vim.log.levels.INFO)
      vim.defer_fn(function()
        trouble.open("document_diagnostics")
      end, 1000)
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = trouble_group,
  pattern = "trouble",
  callback = function()
    vim.api.nvim_set_hl(0, "TroubleError", { fg = "#f38ba8", bold = true })
    vim.api.nvim_set_hl(0, "TroubleWarning", { fg = "#fab387", bold = true })
    vim.api.nvim_set_hl(0, "TroubleInformation", { fg = "#89dceb" })
    vim.api.nvim_set_hl(0, "TroubleHint", { fg = "#a6e3a1" })
  end,
})

local function trouble_symbols()
  if trouble.is_open() then
    local items = trouble.get_items()
    if items and #items > 0 then
      return string.format("T:%d", #items)
    end
  end
  return ""
end

_G.trouble_symbols = trouble_symbols

vim.api.nvim_create_user_command("TroubleWorkspace", function()
  trouble.open("workspace_diagnostics")
end, { desc = "Open workspace diagnostics in Trouble" })

vim.api.nvim_create_user_command("TroubleDocument", function()
  trouble.open("document_diagnostics")
end, { desc = "Open document diagnostics in Trouble" })

vim.api.nvim_create_user_command("TroubleErrors", function()
  trouble.open("workspace_diagnostics", { severity = vim.diagnostic.severity.ERROR })
end, { desc = "Open only errors in Trouble" })

vim.api.nvim_create_user_command("TroubleStats", function()
  _G.show_diagnostic_stats()
end, { desc = "Show diagnostic statistics" })