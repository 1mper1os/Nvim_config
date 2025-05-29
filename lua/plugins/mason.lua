-- Antes de cargar Mason, establece las variables de entorno
vim.g.mason_home = vim.fn.stdpath("data") .. "/mason"
vim.env.PATH = vim.env.PATH .. ":" .. vim.g.mason_home .. "/bin"

local status_ok, mason = pcall(require, "mason")
if not status_ok then
  vim.notify("mason.nvim not found", vim.log.levels.ERROR)
  return
end

local status_ok_lspconfig, mason_lspconfig = pcall(require, "mason-lspconfig")
if not status_ok_lspconfig then
  vim.notify("mason-lspconfig.nvim not found", vim.log.levels.ERROR)
  return
end

local status_ok_tool_installer, mason_tool_installer = pcall(require, "mason-tool-installer")
if not status_ok_tool_installer then
  vim.notify("mason-tool-installer.nvim not found", vim.log.levels.WARN)
end

-- Configuración principal de Mason
mason.setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
    border = "rounded",
    width = 0.8,
    height = 0.8,
    keymaps = {
      toggle_package_expand = "<CR>",
      install_package = "i",
      update_package = "u",
      check_package_version = "c",
      update_all_packages = "U",
      check_outdated_packages = "C",
      uninstall_package = "X",
      cancel_installation = "<C-c>",
      apply_language_filter = "<C-f>",
    },
  },
  pip = {
    upgrade_pip = true,
    install_args = { "--user" }, -- Parámetro útil para pip
  },
  github = {
    download_url_template = "https://github.com/%s/releases/download/%s/%s ",
  },
  max_concurrent_installers = 4,
  log_level = vim.log.levels.INFO,
})

-- Configuración de mason-lspconfig
mason_lspconfig.setup({
  ensure_installed = {
    -- Lenguajes principales
    "lua_ls",
    "pyright",
    "rust_analyzer",
    "gopls",
    "bashls",
    "clangd",
    "jdtls", -- Java

    -- Web development
    "html",
    "cssls",
    "jsonls",
    "yamlls",
    "emmet_ls",
    "tailwindcss",

    -- JavaScript/TypeScript
    "tsserver",
    "eslint",

    -- Vue
    "volar",

    -- Bases de datos
    "sqlls",

    -- Docker
    "dockerls",
    "docker_compose_language_service",

    -- Otros
    "marksman", -- Markdown
    "prismals", -- Prisma
    "graphql",
    "texlab", -- LaTeX
  },
  automatic_installation = true,
})

-- Configuración de mason-tool-installer (si está disponible)
if status_ok_tool_installer then
  mason_tool_installer.setup({
    ensure_installed = {
      -- Formateadores
      "prettier",
      "stylua",
      "black",
      "isort",
      "shfmt",
      "rustfmt",

      -- Linters
      "eslint_d",
      "shellcheck",
      "stylelint",
      "markdownlint",
      "flake8",

      -- Servidores de lenguaje
      "typescript-language-server",
      "vue-language-server",
      "css-lsp",
      "json-lsp",
      "yaml-language-server",
      "dockerfile-language-server",

      
      "debugpy", -- Debugger para Python
    },
    auto_update = true,
    run_on_start = true,
    start_delay = 3000,
    debounce_hours = 12,
  })
end

-- Configuración de autocmds para tipos de archivo
local filetype_augroup = vim.api.nvim_create_augroup("MasonFiletype", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = filetype_augroup,
  pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
  callback = function()
    vim.opt_local.syntax = "javascript.jsx"
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = filetype_augroup,
  pattern = { "vue" },
  callback = function()
    vim.opt_local.syntax = "vue"
    vim.opt_local.filetype = "vue"
  end,
})

-- Configuración avanzada de tipos de archivo
vim.filetype.add({
  extension = {
    ts = "typescript",
    tsx = "typescriptreact",
    jsx = "javascriptreact",
    vue = "vue",
    mjs = "javascript",
    cjs = "javascript",
    json = "json",
    jsonc = "jsonc",
    prisma = "prisma",
    graphql = "graphql",
    svelte = "svelte",
  },
  filename = {
    ["vite.config.js"] = "javascript",
    ["vite.config.ts"] = "typescript",
    ["vite.config.mjs"] = "javascript",
    ["vue.config.js"] = "javascript",
    ["nuxt.config.js"] = "javascript",
    ["nuxt.config.ts"] = "typescript",
    [".eslintrc.js"] = "javascript",
    [".eslintrc.cjs"] = "javascript",
    ["tailwind.config.js"] = "javascript",
    ["tailwind.config.ts"] = "typescript",
    ["postcss.config.js"] = "javascript",
    ["rollup.config.js"] = "javascript",
    ["webpack.config.js"] = "javascript",
    ["babel.config.js"] = "javascript",
    ["jest.config.js"] = "javascript",
    ["vitest.config.js"] = "javascript",
    ["vitest.config.ts"] = "typescript",
    [".prettierrc.js"] = "javascript",
    [".stylelintrc.js"] = "javascript",
  },
  pattern = {
    [".*%.config%.js"] = "javascript",
    [".*%.config%.ts"] = "typescript",
    [".*%.config%.mjs"] = "javascript",
    [".*%.story%.js"] = "javascript",
    [".*%.story%.ts"] = "typescript",
    [".*%.test%.js"] = "javascript",
    [".*%.test%.ts"] = "typescript",
    [".*%.spec%.js"] = "javascript",
    [".*%.spec%.ts"] = "typescript",
  },
})

-- Notificación de finalización
vim.notify("Mason configuration loaded successfully", vim.log.levels.INFO)