local status_ok, mason = pcall(require, "mason")
if not status_ok then
	return
end

local status_ok_lspconfig, mason_lspconfig = pcall(require, "mason-lspconfig")
if not status_ok_lspconfig then
	return
end

local status_ok_tool_installer, mason_tool_installer = pcall(require, "mason-tool-installer")
if not status_ok_tool_installer then
	return
end

mason.setup({
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
		border = "rounded",
		keymaps = {
			toggle_package_expand = "<CR>",
			install_package = "i",
			update_package = "u",
			check_package_version = "c",
			uninstall_package = "X",
		},
	},
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
		"graphql",
		"jdtls",
		"kotlin_language_server",
		"marksman",
		"prismals",
		"sqlls",
		"tailwindcss",
		"terraformls",
		"vimls",
		"lemminx",
		"zls",
		"svelte",
		"emmet_ls",
		"eslint",
		"denols",
		"angularls",
		"vuels",
		"texlab",
		"ltex",
		"phpactor",
		"intelephense",
		"powershell_es",
		"perlnavigator",
		"elixirls",
		"glsl_analyzer",
		"unocss",
		"wgsl_analyzer",
	},
	automatic_installation = true, -- Instala automáticamente los servidores LSP listados
})

-- Configuración de Mason-Tool-Installer
mason_tool_installer.setup({
	ensure_installed = {
		"prettier",
		"stylua",
		"black",
		"isort",
		"eslint_d",
		"shfmt",
		"shellcheck",
		"yamlfmt",
	},
})
