
local status_ok, goto_preview = pcall(require, "goto-preview")
if not status_ok then
  vim.notify("Failed to load goto-preview.nvim", vim.log.levels.ERROR)
  return
end

goto_preview.setup({

  width = 120, 
  height = 20, 
  border = "rounded", 

  default_mappings = false, 
  dismiss_on_move = false, 
  focus_on_open = true, 
  opacity = 10, 
  resizing_mappings = true, 

  preview_window_title = { enable = true, position = "center" }, 
  references = {
    telescope = require("telescope.themes").get_dropdown({ winblend = 10 }),
  },

  stack_floating_preview_windows = true,

  post_open_hook = function(buffer, win)
    
    vim.api.nvim_buf_set_option(buffer, "filetype", vim.api.nvim_buf_get_option(buffer, "filetype"))
    vim.api.nvim_win_set_option(win, "number", true)
    vim.api.nvim_win_set_option(win, "relativenumber", true)
    vim.api.nvim_win_set_option(win, "cursorline", true)
    vim.api.nvim_win_set_option(win, "wrap", false)

    vim.api.nvim_win_set_option(win, "winhl", "Normal:PreviewNormal,FloatBorder:PreviewBorder")

    if vim.g.goto_preview_notify then
      vim.notify("Preview opened", vim.log.levels.INFO)
    end
  end,
  
  post_close_hook = function()
    if vim.g.goto_preview_notify then
      vim.notify("Preview closed", vim.log.levels.INFO)
    end
  end,

  same_file_float_preview = false, 
  zindex = 1, 
})

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap("n", "gpd", function()
  goto_preview.goto_preview_definition({
    width = 120,
    height = 20,
    border = "rounded",
  })
end, vim.tbl_extend("force", opts, { desc = "Preview Definition" }))

keymap("n", "gpt", function()
  goto_preview.goto_preview_type_definition({
    width = 120,
    height = 15,
    border = "rounded",
  })
end, vim.tbl_extend("force", opts, { desc = "Preview Type Definition" }))

keymap("n", "gpi", function()
  goto_preview.goto_preview_implementation({
    width = 120,
    height = 20,
    border = "rounded",
  })
end, vim.tbl_extend("force", opts, { desc = "Preview Implementation" }))

keymap("n", "gpr", function()
  goto_preview.goto_preview_references({
    width = 120,
    height = 25, 
    border = "rounded",
  })
end, vim.tbl_extend("force", opts, { desc = "Preview References" }))

keymap("n", "gpD", function()
  goto_preview.goto_preview_declaration({
    width = 120,
    height = 15,
    border = "rounded",
  })
end, vim.tbl_extend("force", opts, { desc = "Preview Declaration" }))

keymap("n", "gP", goto_preview.close_all_win, vim.tbl_extend("force", opts, { desc = "Close All Previews" }))


keymap("n", "gpn", function()
  goto_preview.goto_preview_definition({ focus_on_open = false })
end, vim.tbl_extend("force", opts, { desc = "Preview Definition (no focus)" }))

keymap("n", "gps", function()

  local wins = vim.api.nvim_list_wins()
  for _, win in ipairs(wins) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative ~= "" then 
      vim.api.nvim_win_set_config(win, {
        relative = config.relative,
        width = config.width == 120 and 80 or 120,
        height = config.height == 20 and 15 or 20,
        row = config.row,
        col = config.col,
        border = config.border,
      })
      break
    end
  end
end, vim.tbl_extend("force", opts, { desc = "Toggle Preview Size" }))

keymap("n", "<leader>pd", function()
  goto_preview.goto_preview_definition({
    width = 150,
    height = 30,
    border = "double",
    opacity = 5,
  })
end, vim.tbl_extend("force", opts, { desc = "Large Preview Definition" }))

keymap("n", "<leader>pr", function()
  goto_preview.goto_preview_references({
    width = vim.o.columns - 10,
    height = vim.o.lines - 10,
    border = "shadow",
  })
end, vim.tbl_extend("force", opts, { desc = "Fullscreen Preview References" }))

vim.api.nvim_create_user_command("PreviewConfig", function()
  local config_options = {
    "Toggle notifications",
    "Change border style",
    "Adjust window size",
    "Toggle focus on open",
    "Reset to defaults"
  }
  
  vim.ui.select(config_options, {
    prompt = "Preview Configuration:",
  }, function(choice)
    if choice == "Toggle notifications" then
      vim.g.goto_preview_notify = not vim.g.goto_preview_notify
      vim.notify("Notifications " .. (vim.g.goto_preview_notify and "enabled" or "disabled"), vim.log.levels.INFO)
    elseif choice == "Change border style" then
      local borders = { "single", "double", "rounded", "solid", "shadow" }
      vim.ui.select(borders, { prompt = "Select border:" }, function(border)
        if border then
          goto_preview.setup({ border = border })
          vim.notify("Border changed to " .. border, vim.log.levels.INFO)
        end
      end)
    elseif choice == "Toggle focus on open" then
      local current_config = goto_preview.get_config and goto_preview.get_config() or {}
      goto_preview.setup({ focus_on_open = not current_config.focus_on_open })
      vim.notify("Focus on open toggled", vim.log.levels.INFO)
    elseif choice == "Reset to defaults" then
      goto_preview.setup({})
      vim.notify("Preview reset to defaults", vim.log.levels.INFO)
    end
  end)
end, { desc = "Interactive Preview configuration" })

vim.api.nvim_create_user_command("PreviewTelescope", function(args)
  local telescope_ok, telescope = pcall(require, "telescope.builtin")
  if not telescope_ok then
    vim.notify("Telescope not available", vim.log.levels.ERROR)
    return
  end
  
  local action = args.args or "references"
  if action == "references" then
    telescope.lsp_references({
      layout_config = { preview_width = 0.7 },
      show_line = false,
    })
  elseif action == "definitions" then
    telescope.lsp_definitions({
      layout_config = { preview_width = 0.7 },
    })
  elseif action == "implementations" then
    telescope.lsp_implementations({
      layout_config = { preview_width = 0.7 },
    })
  end
end, {
  nargs = "?",
  complete = function()
    return { "references", "definitions", "implementations" }
  end,
  desc = "Preview with Telescope integration",
})

vim.api.nvim_create_autocmd("BufLeave", {
  callback = function()
    if vim.g.goto_preview_auto_close then
      goto_preview.close_all_win()
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "lua", "python", "javascript", "typescript", "go", "rust" },
  callback = function()
    
    local ft = vim.bo.filetype
    local config = {
      lua = { width = 100, height = 20 },
      python = { width = 120, height = 25 },
      javascript = { width = 130, height = 20 },
      typescript = { width = 130, height = 20 },
      go = { width = 120, height = 18 },
      rust = { width = 140, height = 25 },
    }
    
    if config[ft] then
      
      vim.b.goto_preview_config = config[ft]
    end
  end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()

    vim.api.nvim_set_hl(0, "PreviewNormal", { bg = "#1e222a", fg = "#abb2bf" })
    vim.api.nvim_set_hl(0, "PreviewBorder", { fg = "#61afef", bg = "#1e222a" })
    vim.api.nvim_set_hl(0, "PreviewTitle", { fg = "#e06c75", bg = "#1e222a", bold = true })
  end,
})

local function smart_preview()
  local word = vim.fn.expand("<cword>")
  if word == "" then
    vim.notify("No word under cursor", vim.log.levels.WARN)
    return
  end

  local clients = vim.lsp.get_active_clients({ bufnr = 0 })
  if #clients == 0 then
    vim.notify("No LSP client attached", vim.log.levels.WARN)
    return
  end

  goto_preview.goto_preview_definition({
    width = 120,
    height = 20,
    border = "rounded",
  })
end

keymap("n", "gp", smart_preview, vim.tbl_extend("force", opts, { desc = "Smart Preview" }))

local function preview_split()
  goto_preview.close_all_win()
  vim.cmd("split")
  vim.lsp.buf.definition()
end

keymap("n", "gps", preview_split, vim.tbl_extend("force", opts, { desc = "Preview in Split" }))


local which_key_status_ok, which_key = pcall(require, "which-key")
if which_key_status_ok then
  which_key.register({
    ["gp"] = {
      name = "Goto Preview",
      d = "Definition",
      t = "Type Definition",
      i = "Implementation",
      r = "References",
      D = "Declaration",
      n = "Definition (no focus)",
      s = "Toggle Size",
    },
    ["<leader>p"] = {
      name = "Preview",
      d = "Large Definition",
      r = "Fullscreen References",
    },
  })
end

vim.g.goto_preview_notify = false 
vim.g.goto_preview_auto_close = false 

vim.schedule(function()
  vim.cmd("doautocmd ColorScheme")
end)

vim.notify("goto-preview.nvim loaded successfully", vim.log.levels.INFO)