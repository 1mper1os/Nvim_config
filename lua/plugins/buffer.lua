local status_ok, bufferline = pcall(require, "bufferline")
if not status_ok then
  return
end

bufferline.setup({
  options = {
    numbers = "none", 

    close_command = "bdelete! %d",
    right_mouse_command = "bdelete! %d",

    diagnostics = "nvim_lsp", 
    diagnostics_update_in_insert = false, 

    diagnostics_indicator = function(count, level, diagnostics_dict, context)
      return "(" .. count .. ")"
    end,

    separator_style = {
      left = "", 
      right = "",
    },

    indicator = {
      icon = "",
      style = "icon", 
    },

    show_buffer_icons = true, 
    show_buffer_close_icons = true, 
    show_close_icon = true, 
    show_tab_indicators = true,

    enforce_regular_tabs = false,
    always_show_bufferline = true,
    sort_by = "insert_after_current", 
  },

  highlights = {
    fill = {
      fg = { attribute = "fg", highlight = "Normal" },
      bg = { attribute = "bg", highlight = "StatusLine" },
    },
    background = {
      fg = { attribute = "fg", highlight = "Normal" },
      bg = { attribute = "bg", highlight = "StatusLine" },
    },
    buffer_selected = {
      fg = { attribute = "fg", highlight = "Normal" },
      bg = { attribute = "bg", highlight = "Normal" },
      bold = true,
    },
    separator = {
      fg = { attribute = "bg", highlight = "StatusLine" },
      bg = { attribute = "bg", highlight = "StatusLine" },
    },
    separator_selected = {
      fg = { attribute = "bg", highlight = "Normal" },
      bg = { attribute = "bg", highlight = "Normal" },
    },
  },
})
