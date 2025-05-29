
local M = {}

local function safe_require(module)
  local ok, result = pcall(require, module)
  if not ok then
    vim.notify("Markdown Preview no está disponible: " .. result, vim.log.levels.WARN)
    return nil
  end
  return result
end

local markdown_preview = safe_require("mkdp")
if not markdown_preview then
  return M
end


local function setup_markdown_preview()

  vim.g.mkdp_auto_start = 0               
  vim.g.mkdp_auto_close = 1                  
  vim.g.mkdp_refresh_slow = 0                  
  vim.g.mkdp_command_for_global = 0            
  vim.g.mkdp_open_to_the_world = 0              
  vim.g.mkdp_open_ip = "127.0.0.1"             
  vim.g.mkdp_browser = ""                      
  vim.g.mkdp_echo_preview_url = 1               
  vim.g.mkdp_port = "8080"                      

  vim.g.mkdp_browserfunc = ""                   
  vim.g.mkdp_preview_options = {
    mkit = {},
    katex = {},
    uml = {},
    maid = {},
    disable_sync_scroll = 0,               
    sync_scroll_type = "middle",              
    hide_yaml_meta = 1,                        
    sequence_diagrams = {},
    flowchart_diagrams = {},
    content_editable = false,              
    disable_filename = 0,                       
    toc = {}                                    
  }
  

  vim.g.mkdp_markdown_css = ""                  
  vim.g.mkdp_highlight_css = ""                 
  vim.g.mkdp_page_title = "「${name}」"       
  vim.g.mkdp_theme = "dark"                   

  vim.g.mkdp_filetypes = { "markdown", "md", "mdx", "rmd" }

  vim.g.mkdp_combine_preview = 0
  vim.g.mkdp_combine_preview_auto_refresh = 1
end

local function is_markdown_file()
  local filetype = vim.bo.filetype
  local markdown_types = { "markdown", "md", "mdx", "rmd" }
  
  for _, ft in ipairs(markdown_types) do
    if filetype == ft then
      return true
    end
  end
  
  local filename = vim.fn.expand("%:t")
  return filename:match("%.md$") or filename:match("%.markdown$") or filename:match("%.mdx$")
end

M.start_preview = function()
  if not is_markdown_file() then
    vim.notify("No es un archivo Markdown", vim.log.levels.WARN)
    return
  end

  if vim.bo.modified then
    vim.cmd("write")
  end
  
  vim.cmd("MarkdownPreview")
  vim.notify("Vista previa de Markdown iniciada", vim.log.levels.INFO)
end

M.stop_preview = function()
  vim.cmd("MarkdownPreviewStop")
  vim.notify("Vista previa de Markdown detenida", vim.log.levels.INFO)
end

M.toggle_preview = function()
  if not is_markdown_file() then
    vim.notify("No es un archivo Markdown", vim.log.levels.WARN)
    return
  end

  local preview_active = vim.fn.exists("*mkdp#util#open_preview_page") == 1
  
  if preview_active then
    M.stop_preview()
  else
    M.start_preview()
  end
end

-- Función para abrir con navegador específico
M.open_with_browser = function(browser)
  local old_browser = vim.g.mkdp_browser
  vim.g.mkdp_browser = browser or ""
  
  M.start_preview()

  vim.defer_fn(function()
    vim.g.mkdp_browser = old_browser
  end, 1000)
end

M.export_html = function()
  if not is_markdown_file() then
    vim.notify("No es un archivo Markdown", vim.log.levels.WARN)
    return
  end
  
  local current_file = vim.fn.expand("%:p")
  local html_file = vim.fn.expand("%:r") .. ".html"

  if vim.fn.executable("pandoc") == 1 then
    local cmd = string.format("pandoc '%s' -o '%s' --standalone --css=github-markdown.css", current_file, html_file)
    vim.fn.system(cmd)
    vim.notify("Exportado a: " .. html_file, vim.log.levels.INFO)
  else
    vim.notify("Pandoc no está disponible para exportar", vim.log.levels.WARN)
  end
end

M.insert_toc = function()
  if not is_markdown_file() then
    vim.notify("No es un archivo Markdown", vim.log.levels.WARN)
    return
  end
  
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local toc = {"<!-- TOC -->", ""}
  local current_level = 0
  
  for i, line in ipairs(lines) do
    local level, title = line:match("^(#+)%s*(.+)")
    if level and title then
      local indent = string.rep("  ", #level - 1)
      table.insert(toc, indent .. "- [" .. title .. "](#" .. title:lower():gsub("%s+", "-"):gsub("[^%w%-]", "") .. ")")
    end
  end
  
  table.insert(toc, "")
  table.insert(toc, "<!-- /TOC -->")

  vim.api.nvim_buf_set_lines(0, 0, 0, false, toc)
  vim.notify("Tabla de contenidos insertada", vim.log.levels.INFO)
end

M.create_template = function(template_type)
  if not is_markdown_file() then
    vim.notify("No es un archivo Markdown", vim.log.levels.WARN)
    return
  end
  
  local templates = {
    basic = {
      "# Título del Documento",
      "",
      "## Introducción",
      "",
      "Descripción del documento...",
      "",
      "## Contenido Principal",
      "",
      "### Sección 1",
      "",
      "Contenido de la sección...",
      "",
      "### Sección 2",
      "",
      "Más contenido...",
      "",
      "## Conclusión",
      "",
      "Resumen y conclusiones...",
    },
    readme = {
      "# Nombre del Proyecto",
      "",
      "[![GitHub license](https://img.shields.io/github/license/usuario/proyecto)](https://github.com/usuario/proyecto/blob/main/LICENSE)",
      "[![GitHub stars](https://img.shields.io/github/stars/usuario/proyecto)](https://github.com/usuario/proyecto/stargazers)",
      "",
      "## Descripción",
      "",
      "Breve descripción del proyecto...",
      "",
      "## Instalación",
      "",
      "```bash",
      "# Comandos de instalación",
      "```",
      "",
      "## Uso",
      "",
      "```bash",
      "# Ejemplos de uso",
      "```",
      "",
      "## Contribuir",
      "",
      "Las contribuciones son bienvenidas...",
      "",
      "## Licencia",
      "",
      "Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para más detalles.",
    },
    blog = {
      "---",
      "title: \"Título del Post\"",
      "date: " .. os.date("%Y-%m-%d"),
      "author: \"Tu Nombre\"",
      "tags: [\"tag1\", \"tag2\"]",
      "---",
      "",
      "# Título del Post",
      "",
      "## Introducción",
      "",
      "Introducción al tema...",
      "",
      "## Desarrollo",
      "",
      "Contenido principal del post...",
      "",
      "## Conclusión",
      "",
      "Reflexiones finales...",
    }
  }
  
  local template = templates[template_type] or templates.basic
  vim.api.nvim_buf_set_lines(0, 0, -1, false, template)
  vim.notify("Plantilla '" .. template_type .. "' insertada", vim.log.levels.INFO)
end

local function setup_keymaps()
  local keymap = vim.keymap.set
  local opts = { noremap = true, silent = true }

  keymap("n", "<leader>mp", M.start_preview, 
    vim.tbl_extend("force", opts, { desc = "Iniciar vista previa de Markdown" }))
  keymap("n", "<leader>ms", M.stop_preview, 
    vim.tbl_extend("force", opts, { desc = "Detener vista previa de Markdown" }))
  keymap("n", "<leader>mt", M.toggle_preview, 
    vim.tbl_extend("force", opts, { desc = "Alternar vista previa de Markdown" }))

  keymap("n", "<leader>me", M.export_html, 
    vim.tbl_extend("force", opts, { desc = "Exportar Markdown a HTML" }))
  keymap("n", "<leader>mc", M.insert_toc, 
    vim.tbl_extend("force", opts, { desc = "Insertar tabla de contenidos" }))

  keymap("n", "<leader>mtb", function() M.create_template("basic") end,
    vim.tbl_extend("force", opts, { desc = "Crear plantilla básica" }))
  keymap("n", "<leader>mtr", function() M.create_template("readme") end,
    vim.tbl_extend("force", opts, { desc = "Crear plantilla README" }))
  keymap("n", "<leader>mtl", function() M.create_template("blog") end,
    vim.tbl_extend("force", opts, { desc = "Crear plantilla de blog" }))

  keymap("n", "<leader>mpc", function() M.open_with_browser("google-chrome") end,
    vim.tbl_extend("force", opts, { desc = "Abrir con Chrome" }))
  keymap("n", "<leader>mpf", function() M.open_with_browser("firefox") end,
    vim.tbl_extend("force", opts, { desc = "Abrir con Firefox" }))

  keymap("i", "<C-k>", "```<CR>```<Up><End>", 
    vim.tbl_extend("force", opts, { desc = "Insertar bloque de código" }))
  keymap("i", "<C-b>", "****<Left><Left>", 
    vim.tbl_extend("force", opts, { desc = "Insertar texto en negrita" }))
  keymap("i", "<C-i>", "**<Left>", 
    vim.tbl_extend("force", opts, { desc = "Insertar texto en cursiva" }))
  keymap("i", "<C-l>", "[]()", 
    vim.tbl_extend("force", opts, { desc = "Insertar enlace" }))
end

local function setup_autocommands()
  local augroup = vim.api.nvim_create_augroup("MarkdownPreview", { clear = true })

  vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
    pattern = "*.md,*.markdown,*.mdx",
    group = augroup,
    callback = function()

      vim.defer_fn(function()
        if vim.bo.modified and is_markdown_file() then
          vim.cmd("silent! write")
        end
      end, 2000)
    end,
  })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    group = augroup,
    callback = function()
      vim.opt_local.wrap = true
      vim.opt_local.linebreak = true
      vim.opt_local.spell = true
      vim.opt_local.conceallevel = 2
      vim.opt_local.concealcursor = "n"
    end,
  })
  
  -- Cerrar preview automáticamente al salir de Neovim
  vim.api.nvim_create_autocmd("VimLeave", {
    group = augroup,
    callback = function()
      if vim.fn.exists("*mkdp#util#stop_preview") == 1 then
        vim.fn["mkdp#util#stop_preview"]()
      end
    end,
  })
end

local function setup_user_commands()
  vim.api.nvim_create_user_command('MarkdownExport', M.export_html, {
    desc = 'Exportar Markdown a HTML'
  })
  
  vim.api.nvim_create_user_command('MarkdownTOC', M.insert_toc, {
    desc = 'Insertar tabla de contenidos'
  })
  
  vim.api.nvim_create_user_command('MarkdownTemplate', function(opts)
    M.create_template(opts.args)
  end, {
    nargs = 1,
    complete = function()
      return { "basic", "readme", "blog" }
    end,
    desc = 'Crear plantilla de Markdown'
  })
end

M.status = function()
  local info = {
    "=== Markdown Preview Status ===",
    "Plugin: " .. (markdown_preview and "✓ Cargado" or "✗ No disponible"),
    "Archivo actual: " .. (is_markdown_file() and "✓ Markdown" or "✗ No Markdown"),
    "Puerto: " .. (vim.g.mkdp_port or "Default"),
    "Tema: " .. (vim.g.mkdp_theme or "Default"),
    "Auto-close: " .. (vim.g.mkdp_auto_close == 1 and "✓" or "✗"),
  }
  
  vim.notify(table.concat(info, "\n"), vim.log.levels.INFO)
end

local function init()
  setup_markdown_preview()
  setup_keymaps()
  setup_autocommands()
  setup_user_commands()
  

  vim.api.nvim_create_user_command('MarkdownStatus', M.status, {
    desc = 'Mostrar estado de Markdown Preview'
  })
end


init()

return M