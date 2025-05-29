
local status_ok, tailwindcss_colorizer_cmp = pcall(require, "tailwindcss-colorizer-cmp")
if not status_ok then
  vim.notify("tailwindcss-colorizer-cmp not found", vim.log.levels.WARN)
  return
end

local cmp_ok, cmp = pcall(require, "cmp")
if not cmp_ok then
  vim.notify("nvim-cmp not found - tailwindcss-colorizer may not work properly", vim.log.levels.WARN)
end

tailwindcss_colorizer_cmp.setup({
 
  color_square_width = 2,
  color_square_border = "single", 
  
 
  enabled = true,
  

  custom_colors = {
  
    brand = {
      primary = "#3B82F6",    
      secondary = "#6366F1",   
      accent = "#F59E0B",      
      success = "#10B981",     
      warning = "#F59E0B",     
      error = "#EF4444",       
      info = "#06B6D4",        
    },
    
    gray = {
      ["50"] = "#F9FAFB",
      ["100"] = "#F3F4F6",
      ["150"] = "#E8EAED",  
      ["200"] = "#E5E7EB",
      ["250"] = "#D6D9DC",  
      ["300"] = "#D1D5DB",
      ["350"] = "#B8BCC3", 
      ["400"] = "#9CA3AF",
      ["450"] = "#7C848D",  
      ["500"] = "#6B7280",
      ["550"] = "#5A616B",  
      ["600"] = "#4B5563",
      ["650"] = "#3E4651",  
      ["700"] = "#374151",
      ["750"] = "#2F3944",  
      ["800"] = "#1F2937",
      ["850"] = "#1A202C",  
      ["900"] = "#111827",
      ["950"] = "#0B0F19",  
    },

    social = {
      facebook = "#1877F2",
      twitter = "#1DA1F2",
      instagram = "#E4405F",
      linkedin = "#0A66C2",
      youtube = "#FF0000",
      github = "#181717",
      discord = "#5865F2",
      spotify = "#1DB954",
    },

    semantic = {

      light = {
        background = "#FFFFFF",
        surface = "#F8FAFC",
        border = "#E2E8F0",
        text = "#1E293B",
        textMuted = "#64748B",
      },

      dark = {
        background = "#0F172A",
        surface = "#1E293B",
        border = "#334155",
        text = "#F1F5F9",
        textMuted = "#94A3B8",
      },
    },

    frameworks = {
      react = "#61DAFB",
      vue = "#4FC08D",
      angular = "#DD0031",
      svelte = "#FF3E00",
      next = "#000000",
      nuxt = "#00DC82",
      gatsby = "#663399",
      vite = "#646CFF",
    },
  },

  filetypes = {
    "html",
    "css",
    "scss",
    "sass",
    "less",
    "stylus",
    "javascript",
    "typescript",
    "javascriptreact",
    "typescriptreact",
    "vue",
    "svelte",
    "astro",
    "markdown",
    "mdx",
    "php",
    "blade",
    "twig",
    "erb",
    "slim",
    "haml",
    "liquid",
    "jsx",
    "tsx",
    "json",
    "jsonc",
    "yaml",
    "yml",
    "toml",
    "lua",
    "vim",
  },

  color_name_settings = {
    
    enabled = true,
 
    show_name = true,
   
    priority = "name",
  },

  integration = {
  
    colorizer_lua = true,
   
    vim_colorizer = false,
  },
  
 
  performance = {
    
    cache_enabled = true,
    
    debounce_time = 100,
    
    max_file_size = 1024,
  },

  appearance = {
   
    square_style = "rounded",
 
    transparency = 0,
   
    padding = 1,

    border_style = "none",
  },
})

local function setup_autocommands()
  local tailwind_group = vim.api.nvim_create_augroup("TailwindColorizer", { clear = true })

  vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    group = tailwind_group,
    pattern = {
      "*.html", "*.css", "*.scss", "*.sass", "*.less",
      "*.js", "*.jsx", "*.ts", "*.tsx", "*.vue", "*.svelte",
      "*.astro", "*.php", "*.blade.php", "*.twig",
      "tailwind.config.*", "*.config.js", "*.config.ts"
    },
    callback = function()
   
      if pcall(require, "tailwindcss-colorizer-cmp") then
        vim.b.tailwind_colorizer_enabled = true
      end
    end,
    desc = "Enable Tailwind colorizer for web files",
  })

  vim.api.nvim_create_autocmd("BufReadPre", {
    group = tailwind_group,
    callback = function()
      local file_size = vim.fn.getfsize(vim.fn.expand("%"))
      if file_size > 1024 * 1024 then 
        vim.b.tailwind_colorizer_enabled = false
      end
    end,
    desc = "Disable Tailwind colorizer for large files",
  })

  vim.api.nvim_create_autocmd({"BufWritePost"}, {
    group = tailwind_group,
    pattern = "tailwind.config.*",
    callback = function()
   
      if pcall(require, "tailwindcss-colorizer-cmp") then
        vim.schedule(function()
          vim.notify("Tailwind config updated - reloading colorizer", vim.log.levels.INFO)
          
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_loaded(buf) then
              local filetype = vim.api.nvim_get_option_value("filetype", { buf = buf })
              if vim.tbl_contains({
                "html", "css", "javascript", "typescript", 
                "javascriptreact", "typescriptreact", "vue", "svelte"
              }, filetype) then
                
                vim.api.nvim_buf_call(buf, function()
                  vim.cmd("doautocmd ColorScheme")
                end)
              end
            end
          end
        end)
      end
    end,
    desc = "Reload colorizer when Tailwind config changes",
  })
end

local M = {}

M.toggle = function()
  local current_state = vim.b.tailwind_colorizer_enabled
  if current_state == nil then
    current_state = true 
  end
  
  vim.b.tailwind_colorizer_enabled = not current_state
  local state_text = vim.b.tailwind_colorizer_enabled and "enabled" or "disabled"
  vim.notify("Tailwind colorizer " .. state_text, vim.log.levels.INFO)

  vim.cmd("doautocmd ColorScheme")
end

M.get_color_under_cursor = function()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2]

  local pattern = "[%w%-]+%-[%w%-]*[0-9]+[%w%-]*"
  local start_pos = 1
  
  while true do
    local s, e = string.find(line, pattern, start_pos)
    if not s then break end
    
    if col >= s - 1 and col <= e then
      local class = string.sub(line, s, e)
      return class
    end
    
    start_pos = e + 1
  end
  
  return nil
end

-- Show color palette
M.show_palette = function()
  local colors = {
    "red", "orange", "amber", "yellow", "lime", "green",
    "emerald", "teal", "cyan", "sky", "blue", "indigo",
    "violet", "purple", "fuchsia", "pink", "rose"
  }
  
  local shades = {"50", "100", "200", "300", "400", "500", "600", "700", "800", "900"}
  
  local palette_lines = {"Tailwind Color Palette:", ""}
  
  for _, color in ipairs(colors) do
    local line = color .. ": "
    for _, shade in ipairs(shades) do
      line = line .. color .. "-" .. shade .. " "
    end
    table.insert(palette_lines, line)
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, palette_lines)
  vim.api.nvim_buf_set_option(buf, "modifiable", false)
  vim.api.nvim_buf_set_option(buf, "filetype", "tailwind-palette")

  vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = math.floor(vim.api.nvim_get_option("columns") * 0.8),
    height = math.floor(vim.api.nvim_get_option("lines") * 0.6),
    row = math.floor(vim.api.nvim_get_option("lines") * 0.1),
    col = math.floor(vim.api.nvim_get_option("columns") * 0.1),
    border = "rounded",
    title = " Tailwind Colors ",
    title_pos = "center",
  })
end

local function setup_keymaps()
  local opts = { noremap = true, silent = true }

  vim.keymap.set("n", "<leader>tc", M.toggle, 
    vim.tbl_extend("force", opts, { desc = "Toggle Tailwind colorizer" }))

  vim.keymap.set("n", "<leader>tp", M.show_palette,
    vim.tbl_extend("force", opts, { desc = "Show Tailwind color palette" }))

  vim.keymap.set("n", "<leader>tg", function()
    local color = M.get_color_under_cursor()
    if color then
      vim.notify("Tailwind class: " .. color, vim.log.levels.INFO)
    else
      vim.notify("No Tailwind color class found under cursor", vim.log.levels.WARN)
    end
  end, vim.tbl_extend("force", opts, { desc = "Get Tailwind color under cursor" }))
end

local function setup_commands()
  vim.api.nvim_create_user_command("TailwindColorizerToggle", M.toggle, {
    desc = "Toggle Tailwind CSS colorizer",
  })
  
  vim.api.nvim_create_user_command("TailwindPalette", M.show_palette, {
    desc = "Show Tailwind color palette",
  })
  
  vim.api.nvim_create_user_command("TailwindColorUnderCursor", function()
    local color = M.get_color_under_cursor()
    if color then
      print("Tailwind class: " .. color)
    else
      print("No Tailwind color class found under cursor")
    end
  end, {
    desc = "Get Tailwind color class under cursor",
  })
end


setup_autocommands()
setup_keymaps()
setup_commands()


if cmp_ok then
  
  local sources = cmp.get_config().sources or {}
  table.insert(sources, {
    name = "tailwindcss-colorizer-cmp",
    priority = 300,
    max_item_count = 20,
  })
end

return M