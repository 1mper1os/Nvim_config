local status_ok, mason = pcall(require, "mason")
if not status_ok then return end

local status_ok_lspconfig, mason_lspconfig = pcall(require, "mason-lspconfig")
if not status_ok_lspconfig then return end

local status_ok_tool_installer, mason_tool_installer = pcall(require, "mason-tool-installer")
if not status_ok_tool_installer then return end

mason.setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
    border = "none", 
    keymaps = {
      toggle_package_expand = "<CR>",
      install_package = "i",
      update_package = "u",
      check_package_version = "c",
      uninstall_package = "X",
    },
  },
  max_concurrent_installers = 5,  
})

mason_lspconfig.setup({
  ensure_installed = {
    "lua_ls",
    "pyright",
    "rust_analyzer",
    "gopls",
    "bashls",
    "html",
    "cssls",
    "jsonls",
    "yamlls",
    "clangd",
    "dockerls",
  },
  automatic_installation = false, 
})

mason_tool_installer.setup({
  ensure_installed = {
    "prettier",
    "stylua",
    "black",
    "isort",
    "eslint_d",
    "shfmt",
    "shellcheck",
  },
  auto_update = false,  
  run_on_start = false, 
})

vim.g.mason_home = vim.fn.stdpath("data") .. "/mason"  
vim.env.PATH = vim.env.PATH .. ":" .. vim.g.mason_home .. "/bin"  
