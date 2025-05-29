
local status_ok, flash = pcall(require, "flash")
if not status_ok then
  vim.notify("Failed to load flash.nvim", vim.log.levels.ERROR)
  return
end

flash.setup({
  
  modes = {
    
    search = {
      enabled = true,
      highlight = { 
        backdrop = true,
        matches = true,
        groups = {
          match = "FlashMatch",
          current = "FlashCurrent",
          backdrop = "FlashBackdrop",
          label = "FlashLabel"
        }
      },
      jump = { history = true, register = true, nohlsearch = true },
      search = {
        multi_window = true,
        forward = true,
        wrap = true,
        mode = "exact", 
      },
    },
    
  
    char = {
      enabled = true,
      config = function(opts)
        opts.autohide = vim.fn.mode(true):find("no") and vim.v.operator == "y"
        opts.jump_labels = vim.v.count == 0 and vim.fn.reg_executing() == ""
          and vim.fn.reg_recording() == ""
      end,
      keys = { "f", "F", "t", "T", ";", "," },
      char_actions = function(motion)
        return {
          [";"] = "next", 
          [","] = "prev", 
          [motion:lower()] = "next",
          [motion:upper()] = "prev",
        }
      end,
      search = { wrap = false },
      highlight = { backdrop = true },
      jump = { register = false },
    },
    
 
    treesitter = {
      enabled = true,
      labels = "abcdefghijklmnopqrstuvwxyz",
      jump = { pos = "range" },
      search = {
        multi_window = true,
        wrap = true,
        incremental = false,
      },
      label = { 
        before = true, 
        after = true, 
        style = "overlay" 
      },
    },
    
   
    jump = {
      enabled = true,
      autojump = false, 
      jumplist = true,
      pos = "start",
      history = true,
      register = true,
      nohlsearch = false,
      offset = nil,
    },
    
    
    remote = {
      remote_op = { restore = true, motion = true },
    },
  },


  highlight = {
    backdrop = true,
    matches = true,
    priority = 5000,
    groups = {
      match = "FlashMatch",
      current = "FlashCurrent",
      backdrop = "FlashBackdrop",
      label = "FlashLabel"
    },
  },

  labels = "asdfghjklqwertyuiopzxcvbnm",
  

  search = {
    multi_window = true,
    forward = true,
    wrap = true,
    mode = "exact",
    incremental = false,
    exclude = {
      "notify",
      "cmp_menu",
      "noice",
      "flash_prompt",
      function(win)
       
        return vim.api.nvim_win_get_config(win).relative ~= ""
      end,
    },
  },


  label = {
    uppercase = true,
    exclude = "",
    current = true,
    after = true,
    before = false,
    style = "overlay", 
    reuse = "lowercase",
    distance = true,
    min_pattern_length = 0,
    rainbow = {
      enabled = false,
      shade = 5,
    },
  },

  action = function(match, state)
    state:hide()
    flash.jump(match, state.opts)
  end,

  pattern = "",

  continue = false,

  prompt = {
    enabled = true,
    prefix = { { "⚡", "FlashPromptIcon" } },
    win_config = {
      relative = "editor",
      width = 1,
      height = 1,
      row = -1,
      col = 0,
      zindex = 1000,
    },
  },
})


local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }


keymap({ "n", "x", "o" }, "s", function()
  flash.jump()
end, vim.tbl_extend("force", opts, { desc = "Flash jump" }))


keymap({ "n", "x", "o" }, "S", function()
  flash.treesitter()
end, vim.tbl_extend("force", opts, { desc = "Flash treesitter" }))


keymap({ "o" }, "r", function()
  flash.remote()
end, vim.tbl_extend("force", opts, { desc = "Remote flash" }))


keymap({ "x", "o" }, "R", function()
  flash.treesitter_search()
end, vim.tbl_extend("force", opts, { desc = "Treesitter search" }))


keymap({ "c" }, "<c-s>", function()
  flash.toggle()
end, vim.tbl_extend("force", opts, { desc = "Toggle flash search" }))


keymap({ "n", "x", "o" }, "<leader>fw", function()
  flash.jump({
    pattern = vim.fn.expand("<cword>"),
  })
end, vim.tbl_extend("force", opts, { desc = "Flash word under cursor" }))


keymap({ "n", "x", "o" }, "<leader>fl", function()
  flash.jump({
    search = { mode = "search", max_length = 0 },
    label = { after = { 0, 0 } },
    pattern = "^"
  })
end, vim.tbl_extend("force", opts, { desc = "Flash line" }))


keymap("n", "<leader>fd", function()
  flash.jump({
    matcher = function(win)
      return vim.tbl_map(function(diag)
        return {
          pos = { diag.lnum + 1, diag.col },
          end_pos = { diag.end_lnum + 1, diag.end_col - 1 },
        }
      end, vim.diagnostic.get(vim.api.nvim_win_get_buf(win)))
    end,
    action = function(match)
      vim.api.nvim_win_set_cursor(match.win, match.pos)
      vim.diagnostic.open_float()
    end,
  })
end, vim.tbl_extend("force", opts, { desc = "Flash diagnostics" }))


vim.api.nvim_create_user_command("FlashConfig", function()
  local config_options = {
    "Toggle backdrop",
    "Toggle autojump",
    "Change labels",
    "Toggle treesitter",
    "Reset to defaults"
  }
  
  vim.ui.select(config_options, {
    prompt = "Flash Configuration:",
  }, function(choice)
    if choice == "Toggle backdrop" then
      flash.setup({ highlight = { backdrop = not flash.config.highlight.backdrop } })
      vim.notify("Backdrop toggled", vim.log.levels.INFO)
    elseif choice == "Toggle autojump" then
      flash.setup({ modes = { jump = { autojump = not flash.config.modes.jump.autojump } } })
      vim.notify("Autojump toggled", vim.log.levels.INFO)
    elseif choice == "Toggle treesitter" then
      flash.setup({ modes = { treesitter = { enabled = not flash.config.modes.treesitter.enabled } } })
      vim.notify("Treesitter toggled", vim.log.levels.INFO)
    elseif choice == "Reset to defaults" then
      flash.setup({}) 
      vim.notify("Flash reset to defaults", vim.log.levels.INFO)
    end
  end)
end, { desc = "Interactive Flash configuration" })


local telescope_status_ok, telescope = pcall(require, "telescope")
if telescope_status_ok then
  keymap("n", "<leader>fs", function()
    flash.jump({
      pattern = "^",
      label = { after = { 0, 0 } },
      search = {
        mode = "search",
        exclude = {
          function(win)
            return vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "TelescopePrompt"
          end,
        },
      },
      action = function(match)
        local picker = require("telescope.actions.state").get_current_picker()
        if picker then
          telescope.extensions.flash.flash(picker)
        else
          vim.api.nvim_win_set_cursor(match.win, match.pos)
        end
      end,
    })
  end, vim.tbl_extend("force", opts, { desc = "Flash telescope" }))
end


vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    
    vim.api.nvim_set_hl(0, "FlashBackdrop", { fg = "#545c7e" })
    vim.api.nvim_set_hl(0, "FlashMatch", { bg = "#ff007c", fg = "#c8d3f5", bold = true })
    vim.api.nvim_set_hl(0, "FlashCurrent", { bg = "#00dfff", fg = "#1b1d2b", bold = true })
    vim.api.nvim_set_hl(0, "FlashLabel", { bg = "#ff9e3b", fg = "#1b1d2b", bold = true })
    vim.api.nvim_set_hl(0, "FlashPromptIcon", { fg = "#00dfff" })
  end,
})

vim.schedule(function()
  vim.cmd("doautocmd ColorScheme")
end)

local which_key_status_ok, which_key = pcall(require, "which-key")
if which_key_status_ok then
  which_key.register({
    ["<leader>f"] = {
      name = "Flash",
      w = "Word under cursor",
      l = "Line",
      d = "Diagnostics",
      s = "Telescope flash",
    },
  })
end

vim.notify("flash.nvim loaded successfully", vim.log.levels.INFO)