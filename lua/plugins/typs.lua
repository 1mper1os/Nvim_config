local status_ok, tss = pcall(require, "typescript-tools")
if not status_ok then
  vim.notify("Error: No se pudo cargar TypeScript Tools", vim.log.levels.WARN)
  return
end

local signs = {
  { name = "DiagnosticSignError", text = "" },
  { name = "DiagnosticSignWarn", text = "" },
  { name = "DiagnosticSignHint", text = "󰌶" },
  { name = "DiagnosticSignInfo", text = "" },
}

for _, sign in ipairs(signs) do
  vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end

tss.setup({
 
  on_attach = function(client, bufnr)

    local opts = { buffer = bufnr, silent = true }
    local keymap = vim.keymap.set

    keymap("n", "<leader>rf", "<cmd>TSToolsOrganizeImports<CR>", 
           vim.tbl_extend("force", opts, { desc = "Organizar imports" }))
    keymap("n", "<leader>ra", "<cmd>TSToolsAddMissingImports<CR>", 
           vim.tbl_extend("force", opts, { desc = "Añadir imports faltantes" }))
    keymap("n", "<leader>ru", "<cmd>TSToolsRemoveUnused<CR>", 
           vim.tbl_extend("force", opts, { desc = "Eliminar imports no usados" }))
    keymap("n", "<leader>ri", "<cmd>TSToolsRemoveUnusedImports<CR>", 
           vim.tbl_extend("force", opts, { desc = "Eliminar solo imports no usados" }))

    keymap("n", "<leader>rd", "<cmd>TSToolsGoToSourceDefinition<CR>", 
           vim.tbl_extend("force", opts, { desc = "Ir a la definición de origen" }))
    keymap("n", "gd", "<cmd>TSToolsGoToSourceDefinition<CR>", 
           vim.tbl_extend("force", opts, { desc = "Ir a definición (TS)" }))

    keymap("n", "<leader>rr", "<cmd>TSToolsRenameFile<CR>", 
           vim.tbl_extend("force", opts, { desc = "Renombrar archivo" }))
    keymap("n", "<leader>rf", "<cmd>TSToolsFileReferences<CR>", 
           vim.tbl_extend("force", opts, { desc = "Referencias del archivo" }))

    keymap("n", "<leader>re", "<cmd>TSToolsFixAll<CR>", 
           vim.tbl_extend("force", opts, { desc = "Arreglar todos los errores" }))

    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false

    if client.server_capabilities.inlayHintProvider then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end

    if client.server_capabilities.documentHighlightProvider then
      local group = vim.api.nvim_create_augroup("TSToolsDocumentHighlight", { clear = false })
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = bufnr,
        group = group,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = bufnr,
        group = group,
        callback = vim.lsp.buf.clear_references,
      })
    end

    vim.notify("TypeScript Tools configurado correctamente", vim.log.levels.INFO)
  end,

  settings = {

    expose_as_code_action = {
      "organize_imports",
      "add_missing_imports",
      "remove_unused",
      "remove_unused_imports",
      "fix_all",
      "go_to_source_definition",
      "rename_file",
    },

    tsserver_file_preferences = {

      includeInlayParameterNameHints = "all",
      includeInlayParameterNameHintsWhenArgumentMatchesName = true,
      includeInlayVariableTypeHints = true,
      includeInlayVariableTypeHintsWhenTypeMatchesName = false,
      includeInlayFunctionLikeReturnTypeHints = true,
      includeInlayFunctionParameterTypeHints = true,
      includeInlayPropertyDeclarationTypeHints = true,
      includeInlayEnumMemberValueHints = true,

      includePackageJsonAutoImports = "auto",
      providePrefixAndSuffixTextForRename = true,
      allowRenameOfImportPath = true,

      includeCompletionsForModuleExports = true,
      includeCompletionsForImportStatements = true,
      includeCompletionsWithSnippetText = true,
      includeAutomaticOptionalChainCompletions = true,

      useLabelDetailsInCompletionEntries = true,
    },

    tsserver_format_options = {
      allowIncompleteCompletions = true,
      allowRenameOfImportPath = true,
     
      indentSize = 2,
      tabSize = 2,
      convertTabsToSpaces = true,
 
      insertSpaceAfterCommaDelimiter = true,
      insertSpaceAfterSemicolonInForStatements = true,
      insertSpaceBeforeAndAfterBinaryOperators = true,
      insertSpaceAfterConstructor = false,
      insertSpaceAfterKeywordsInControlFlowStatements = true,
      insertSpaceAfterFunctionKeywordForAnonymousFunctions = false,
      insertSpaceAfterOpeningAndBeforeClosingNonemptyParenthesis = false,
      insertSpaceAfterOpeningAndBeforeClosingNonemptyBrackets = false,
      insertSpaceAfterOpeningAndBeforeClosingTemplateStringBraces = false,
      insertSpaceAfterOpeningAndBeforeClosingJsxExpressionBraces = false,
      insertSpaceAfterTypeAssertion = false,
      insertSpaceBeforeFunctionParenthesis = false,
      placeOpenBraceOnNewLineForFunctions = false,
      placeOpenBraceOnNewLineForControlBlocks = false,
    },

    tsserver_path = nil, 
    tsserver_plugins = {
    
      "@styled/typescript-styled-plugin",
    },

    tsserver_logs = "off", 
  },

  disable_commands = false,
  debug = false,

  handlers = {

    ["textDocument/publishDiagnostics"] = vim.lsp.with(
      vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = {
          prefix = "●",
          spacing = 2,
        },
        signs = true,
        underline = true,
        update_in_insert = false,
      }
    ),
  },
})

local format_group = vim.api.nvim_create_augroup("TSToolsFormat", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
  group = format_group,
  pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
  callback = function()
 
    vim.cmd("TSToolsOrganizeImports")

  end,
})

vim.keymap.set("n", "<leader>th", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
  local status = vim.lsp.inlay_hint.is_enabled() and "habilitados" or "deshabilitados"
  vim.notify("Inlay hints " .. status, vim.log.levels.INFO)
end, { desc = "Toggle inlay hints" })

vim.api.nvim_create_user_command("TSRestart", function()
  vim.cmd("TSToolsRestartTsServer")
  vim.notify("TypeScript Server reiniciado", vim.log.levels.INFO)
end, { desc = "Reiniciar TypeScript Server" })