
local status_ok, go = pcall(require, "go")
if not status_ok then
  vim.notify("Failed to load go.nvim", vim.log.levels.ERROR)
  return
end

go.setup({

  goimport = "gopls", 
  gofmt = "golines", 
  

  max_line_len = 120, 
  tag_transform = "camelcase", 
  tag_options = "json=omitempty", 
  

  test_dir = "", 
  test_runner = "go", 
  test_efm = true, 
  test_timeout = "30s", 
  test_env = {}, 
  test_template = "", 
  test_template_dir = "", 
  

  comment_placeholder = "   ",       
  icons = { breakpoint = "🧘", currentpos = "▶️" }, 
  

  lsp_cfg = true, 
  lsp_gofumpt = true, 
  lsp_on_attach = function(client, bufnr)
    
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
    
    buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
    
    local opts = { noremap = true, silent = true }
    buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
    buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
    buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    buf_set_keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
    buf_set_keymap("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
    buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
    
    if client.server_capabilities.documentFormattingProvider then
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("GoFormat", {}),
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ async = false })
        end,
      })
    end
  end,
  lsp_keymaps = true, 
  lsp_codelens = true, 
  lsp_diag_hdlr = true, 
  lsp_diag_underline = true,
  lsp_diag_virtual_text = { space = 0, prefix = "" },
  lsp_diag_signs = true,
  lsp_diag_update_in_insert = false,
  lsp_document_formatting = true,
  lsp_inlay_hints = {
    enable = true,
    style = "eol", 
    only_current_line = false,
    only_current_line_autocmd = "CursorHold",
  },
  

  dap_debug = true,
  dap_debug_keymap = true, 
  dap_debug_gui = true, 
  dap_debug_vt = true, 
  dap_port = 38697, 
  dap_timeout = 15, 
  dap_retries = 20, 
  

  build_tags = "", 
  build_mode = "", 

  textobjects = true, 
  test_runner = "go", 
  

  verbose = false, 
  log_path = vim.fn.expand("$HOME") .. "/tmp/gonvim.log",
  lsp_document_formatting = true,
  trouble = true, 
  run_in_floaterm = false, 
  floaterm = {
    posititon = "right", 
    width = 0.45, 
    height = 0.98, 
  },
  
  luasnip = true, 
  iferr_vertical_shift = 4, 
})


local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap("n", "<leader>gt", "<cmd>GoTest<CR>", vim.tbl_extend("force", opts, { desc = "Go: Run tests" }))
keymap("n", "<leader>gT", "<cmd>GoTestFunc<CR>", vim.tbl_extend("force", opts, { desc = "Go: Test function" }))
keymap("n", "<leader>gtf", "<cmd>GoTestFile<CR>", vim.tbl_extend("force", opts, { desc = "Go: Test file" }))
keymap("n", "<leader>gta", "<cmd>GoAddTest<CR>", vim.tbl_extend("force", opts, { desc = "Go: Add test" }))
keymap("n", "<leader>gts", "<cmd>GoAddExpTest<CR>", vim.tbl_extend("force", opts, { desc = "Go: Add exported test" }))
keymap("n", "<leader>gtA", "<cmd>GoAddAllTest<CR>", vim.tbl_extend("force", opts, { desc = "Go: Add all tests" }))

keymap("n", "<leader>gf", "<cmd>GoFmt<CR>", vim.tbl_extend("force", opts, { desc = "Go: Format code" }))
keymap("n", "<leader>gi", "<cmd>GoImport<CR>", vim.tbl_extend("force", opts, { desc = "Go: Auto import" }))
keymap("n", "<leader>gI", "<cmd>GoImports<CR>", vim.tbl_extend("force", opts, { desc = "Go: Fix imports" }))

keymap("n", "<leader>gb", "<cmd>GoBuild<CR>", vim.tbl_extend("force", opts, { desc = "Go: Build" }))
keymap("n", "<leader>gr", "<cmd>GoRun<CR>", vim.tbl_extend("force", opts, { desc = "Go: Run" }))
keymap("n", "<leader>gR", "<cmd>GoRun %<CR>", vim.tbl_extend("force", opts, { desc = "Go: Run current file" }))

keymap("n", "<leader>gd", "<cmd>GoDebug<CR>", vim.tbl_extend("force", opts, { desc = "Go: Start debug" }))
keymap("n", "<leader>gD", "<cmd>GoDebug -t<CR>", vim.tbl_extend("force", opts, { desc = "Go: Debug test" }))
keymap("n", "<leader>gds", "<cmd>GoDbgStop<CR>", vim.tbl_extend("force", opts, { desc = "Go: Stop debugger" }))

keymap("n", "<leader>gc", "<cmd>GoCoverage<CR>", vim.tbl_extend("force", opts, { desc = "Go: Show coverage" }))
keymap("n", "<leader>gcr", "<cmd>GoCoverage -r<CR>", vim.tbl_extend("force", opts, { desc = "Go: Coverage report" }))
keymap("n", "<leader>gct", "<cmd>GoCoverage -t<CR>", vim.tbl_extend("force", opts, { desc = "Go: Coverage toggle" }))

keymap("n", "<leader>gsj", "<cmd>GoAddTag json<CR>", vim.tbl_extend("force", opts, { desc = "Go: Add json tags" }))
keymap("n", "<leader>gsy", "<cmd>GoAddTag yaml<CR>", vim.tbl_extend("force", opts, { desc = "Go: Add yaml tags" }))
keymap("n", "<leader>gsr", "<cmd>GoRmTag<CR>", vim.tbl_extend("force", opts, { desc = "Go: Remove tags" }))
keymap("n", "<leader>gse", "<cmd>GoIfErr<CR>", vim.tbl_extend("force", opts, { desc = "Go: Add if err" }))
keymap("n", "<leader>gsf", "<cmd>GoFillStruct<CR>", vim.tbl_extend("force", opts, { desc = "Go: Fill struct" }))
keymap("n", "<leader>gss", "<cmd>GoFillSwitch<CR>", vim.tbl_extend("force", opts, { desc = "Go: Fill switch" }))
keymap("n", "<leader>gsi", "<cmd>GoImpl<CR>", vim.tbl_extend("force", opts, { desc = "Go: Generate interface implementation" }))

keymap("n", "<leader>gen", "<cmd>GoGenReturn<CR>", vim.tbl_extend("force", opts, { desc = "Go: Generate return" }))
keymap("n", "<leader>gec", "<cmd>GoChDecl<CR>", vim.tbl_extend("force", opts, { desc = "Go: Change declaration" }))

keymap("n", "<leader>goa", "<cmd>GoAlt<CR>", vim.tbl_extend("force", opts, { desc = "Go: Alternate file" }))
keymap("n", "<leader>goA", "<cmd>GoAltV<CR>", vim.tbl_extend("force", opts, { desc = "Go: Alternate file (vertical)" }))

keymap("n", "<leader>gle", "<cmd>GoLint<CR>", vim.tbl_extend("force", opts, { desc = "Go: Run linter" }))
keymap("n", "<leader>glv", "<cmd>GoVet<CR>", vim.tbl_extend("force", opts, { desc = "Go: Run go vet" }))


keymap("n", "<leader>gmt", "<cmd>GoModTidy<CR>", vim.tbl_extend("force", opts, { desc = "Go: Mod tidy" }))
keymap("n", "<leader>gmv", "<cmd>GoModVendor<CR>", vim.tbl_extend("force", opts, { desc = "Go: Mod vendor" }))


vim.api.nvim_create_user_command("GoTestSpecific", function(args)
  local test_name = args.args
  if test_name == "" then
    vim.notify("Please specify a test name", vim.log.levels.ERROR)
    return
  end
  vim.cmd("GoTest -run " .. test_name)
end, {
  nargs = 1,
  desc = "Run specific Go test by name",
})

vim.api.nvim_create_user_command("GoBenchmark", function(args)
  local bench_pattern = args.args or "."
  vim.cmd("GoTest -bench=" .. bench_pattern .. " -run=^$")
end, {
  nargs = "?",
  desc = "Run Go benchmarks",
})


vim.api.nvim_create_user_command("GoGenMock", function(args)
  local interface_name = args.args
  if interface_name == "" then
    vim.notify("Please specify an interface name", vim.log.levels.ERROR)
    return
  end
  vim.cmd("!mockgen -source=% -destination=mocks/" .. interface_name:lower() .. "_mock.go")
end, {
  nargs = 1,
  desc = "Generate mock for interface",
})


vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    local params = vim.lsp.util.make_range_params()
    params.context = { only = { "source.organizeImports" } }
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end
    vim.lsp.buf.format({ async = false })
  end,
})


vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    
    
    vim.cmd([[match ExtraWhitespace /\s\+$/]])
    vim.api.nvim_set_hl(0, "ExtraWhitespace", { bg = "#ff5555" })
  end,
})


vim.api.nvim_create_autocmd("User", {
  pattern = "GoTestPre",
  callback = function()
    vim.cmd("wall") 
  end,
})


local which_key_status_ok, which_key = pcall(require, "which-key")
if which_key_status_ok then
  which_key.register({
    ["<leader>g"] = {
      name = "Go",
      t = {
        name = "Test",
        t = "Run tests",
        f = "Test file",
        a = "Add test",
        s = "Add exported test",
        A = "Add all tests",
      },
      s = {
        name = "Struct/Code Gen",
        j = "Add json tags",
        y = "Add yaml tags",
        r = "Remove tags",
        e = "Add if err",
        f = "Fill struct",
        s = "Fill switch",
        i = "Generate impl",
      },
      o = {
        name = "Navigate",
        a = "Alternate file",
        A = "Alternate file (vertical)",
      },
      l = {
        name = "Lint",
        e = "Run linter",
        v = "Run go vet",
      },
      m = {
        name = "Module",
        t = "Mod tidy",
        v = "Mod vendor",
      },
      c = "Coverage",
      d = "Debug",
      f = "Format",
      i = "Import",
      b = "Build",
      r = "Run",
    },
  })
end

vim.notify("go.nvim loaded successfully", vim.log.levels.INFO)