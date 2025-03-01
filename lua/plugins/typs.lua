local status_ok, tss = pcall(require, "typescript-tools")
if not status_ok then
  return
end

tss.setup({
  on_attach = function(client, bufnr)
    local keymap = vim.keymap.set
    keymap("n", "<leader>rf", "<cmd>TSToolsOrganizeImports<CR>", { desc = "Organizar imports" })
    keymap("n", "<leader>rr", "<cmd>TSToolsRenameFile<CR>", { desc = "Renombrar archivo" })
    keymap("n", "<leader>ra", "<cmd>TSToolsAddMissingImports<CR>", { desc = "Añadir imports faltantes" })
    keymap("n", "<leader>ru", "<cmd>TSToolsRemoveUnused<CR>", { desc = "Eliminar imports no usados" })
    keymap("n", "<leader>rd", "<cmd>TSToolsGoToSourceDefinition<CR>", { desc = "Ir a la definición de origen" })
  end,

  settings = {
    expose_as_code_action = {
      "organize_imports",
      "rename_file",
      "add_missing_imports",
      "remove_unused",
      "go_to_source_definition",
    },

    tsserver_file_preferences = {
      includeInlayParameterNameHints = "all", 
      includeInlayVariableTypeHints = true, 
      includeInlayFunctionLikeReturnTypeHints = true, 
      includeInlayEnumMemberValueHints = true, 
    },

    tsserver_format_options = {
      allowIncompleteCompletions = true, 
      allowRenameOfImportPath = true, 
    },
  },

  disable_commands = false,
})
