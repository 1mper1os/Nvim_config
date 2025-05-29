local status_ok, ufo = pcall(require, "ufo")
if not status_ok then
  vim.notify("Error: No se pudo cargar UFO (Ultra Fold)", vim.log.levels.WARN)
  return
end

local ts_status_ok, _ = pcall(require, "nvim-treesitter")
if not ts_status_ok then
  vim.notify("Advertencia: nvim-treesitter no encontrado. UFO funcionará con limitaciones.", vim.log.levels.WARN)
end

vim.o.foldcolumn = '1'
vim.o.foldlevel = 99   
vim.o.foldlevelstart = 99
vim.o.foldenable = true

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true
}

local function custom_fold_text_handler(virtText, lnum, endLnum, width, truncate)
  local newVirtText = {}
  local suffix = ("  %d lines"):format(endLnum - lnum)
  local sufWidth = vim.fn.strdisplaywidth(suffix)
  local targetWidth = width - sufWidth
  local curWidth = 0
  
  for _, chunk in ipairs(virtText) do
    local chunkText = chunk[1]
    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
    if targetWidth > curWidth + chunkWidth then
      table.insert(newVirtText, chunk)
    else
      chunkText = truncate(chunkText, targetWidth - curWidth)
      local hlGroup = chunk[2]
      table.insert(newVirtText, {chunkText, hlGroup})
      chunkWidth = vim.fn.strdisplaywidth(chunkText)
      if curWidth + chunkWidth < targetWidth then
        suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
      end
      break
    end
    curWidth = curWidth + chunkWidth
  end
  
  table.insert(newVirtText, {suffix, 'MoreMsg'})
  return newVirtText
end

local function provider_selector(bufnr, filetype, buftype)
  
  local providers_by_ft = {
    
    lua = {'treesitter', 'indent'},
    python = {'treesitter', 'indent'},
    javascript = {'lsp', 'treesitter', 'indent'},
    typescript = {'lsp', 'treesitter', 'indent'},
    javascriptreact = {'lsp', 'treesitter', 'indent'},
    typescriptreact = {'lsp', 'treesitter', 'indent'},
    rust = {'lsp', 'treesitter', 'indent'},
    go = {'lsp', 'treesitter', 'indent'},
    java = {'lsp', 'treesitter', 'indent'},
    c = {'lsp', 'treesitter', 'indent'},
    cpp = {'lsp', 'treesitter', 'indent'},
    json = {'treesitter', 'indent'},
    yaml = {'treesitter', 'indent'},
    html = {'treesitter', 'indent'},
    css = {'treesitter', 'indent'},
    scss = {'treesitter', 'indent'},
    vue = {'lsp', 'treesitter', 'indent'},
    
    vim = {'treesitter', 'indent'},
    bash = {'treesitter', 'indent'},
    zsh = {'treesitter', 'indent'},
    
    markdown = {'treesitter', 'indent'},
    tex = {'indent'},
    
    help = {'indent'},
    man = {'indent'},
  }
  
  if providers_by_ft[filetype] then
    return providers_by_ft[filetype]
  end
  
  if buftype ~= '' then
    return {'indent'}
  end
  
  return {'treesitter', 'indent'}
end

ufo.setup({
  
  provider_selector = provider_selector,
  
  fold_virt_text_handler = custom_fold_text_handler,
  
  open_fold_hl_timeout = 400,
  
  close_fold_kinds_for_ft = {
    
    ['*'] = {'imports', 'comment'},
    
    javascript = {'imports', 'comment', 'region'},
    typescript = {'imports', 'comment', 'region'},
    javascriptreact = {'imports', 'comment', 'region'},
    typescriptreact = {'imports', 'comment', 'region'},
    vue = {'imports', 'comment', 'region'},
    
    lua = {'comment'},
    python = {'imports', 'comment'},
    go = {'imports', 'comment'},
    rust = {'comment'},
    
    markdown = {'region'},
    tex = {'comment'},
  },
  
  preview = {
    win_config = {
      border = 'rounded',
      winhighlight = 'Normal:Folded',
      winblend = 0,
      maxheight = 20,
      maxwidth = 80,
    },
    mappings = {
      scrollU = '<C-u>',
      scrollD = '<C-d>',
      scrollE = '<C-e>',
      scrollY = '<C-y>',
      close = 'q',
      switch = '<Tab>',
      trace = '<CR>',
    },
  },
  
  enable_get_fold_virt_text = true,
})

local keymap = vim.keymap.set
local opts = { silent = true, noremap = true }

keymap('n', 'zR', ufo.openAllFolds, vim.tbl_extend('force', opts, { desc = 'Abrir todos los pliegues' }))
keymap('n', 'zM', ufo.closeAllFolds, vim.tbl_extend('force', opts, { desc = 'Cerrar todos los pliegues' }))
keymap('n', 'zr', ufo.openFoldsExceptKinds, vim.tbl_extend('force', opts, { desc = 'Abrir pliegues excepto tipos específicos' }))
keymap('n', 'zm', ufo.closeFoldsWith, vim.tbl_extend('force', opts, { desc = 'Cerrar pliegues con criterio' }))

keymap('n', 'zp', function()
  ufo.peekFoldedLinesUnderCursor()
end, vim.tbl_extend('force', opts, { desc = 'Preview del pliegue bajo el cursor' }))

keymap('n', ']z', function()
  ufo.goNextClosedFold()
end, vim.tbl_extend('force', opts, { desc = 'Ir al siguiente pliegue cerrado' }))

keymap('n', '[z', function()
  ufo.goPreviousClosedFold()
end, vim.tbl_extend('force', opts, { desc = 'Ir al pliegue cerrado anterior' }))

keymap('n', '<leader>zf', function()
  ufo.enableFold()
  vim.notify('UFO habilitado', vim.log.levels.INFO)
end, vim.tbl_extend('force', opts, { desc = 'Habilitar UFO' }))

keymap('n', '<leader>zd', function()
  ufo.disableFold()
  vim.notify('UFO deshabilitado', vim.log.levels.INFO)
end, vim.tbl_extend('force', opts, { desc = 'Deshabilitar UFO' }))

keymap('n', '<leader>zc', function()
  local current = vim.wo.foldcolumn
  if current == '0' then
    vim.wo.foldcolumn = '1'
    vim.notify('Columna de plegado mostrada', vim.log.levels.INFO)
  else
    vim.wo.foldcolumn = '0'
    vim.notify('Columna de plegado oculta', vim.log.levels.INFO)
  end
end, vim.tbl_extend('force', opts, { desc = 'Toggle columna de plegado' }))


local fold_group = vim.api.nvim_create_augroup('UFOFoldPersistence', { clear = true })

vim.api.nvim_create_autocmd({ 'BufWinLeave' }, {
  group = fold_group,
  pattern = '*',
  callback = function()
    if vim.bo.filetype ~= '' and vim.bo.buftype == '' then
      vim.cmd('mkview')
    end
  end,
})

vim.api.nvim_create_autocmd({ 'BufWinEnter' }, {
  group = fold_group,
  pattern = '*',
  callback = function()
    if vim.bo.filetype ~= '' and vim.bo.buftype == '' then
      vim.cmd('silent! loadview')
    end
  end,
})

vim.api.nvim_create_autocmd('ColorScheme', {
  callback = function()
   
    vim.cmd([[
      hi default UfoFoldedFg guifg=#c8ccd4
      hi default UfoFoldedBg guibg=#2f334d
      hi default UfoPreviewSbar guibg=#3b4261
      hi default UfoPreviewThumb guibg=#6b7089
      hi default UfoPreviewWinBar guibg=#3b4261
      hi default UfoPreviewCursorLine guibg=#2a2e42
      hi default UfoFoldedEllipsis guifg=#989cae
    ]])
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'javascript', 'typescript', 'lua', 'python', 'go', 'rust', 'java', 'c', 'cpp' },
  callback = function()
    
    vim.wo.foldmethod = 'expr'
    vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
  end,
})

vim.api.nvim_create_user_command('UFOReload', function()
  package.loaded['ufo'] = nil
  require('ufo').setup()
  vim.notify('UFO recargado correctamente', vim.log.levels.INFO)
end, { desc = 'Recargar configuración de UFO' })

vim.notify('UFO configurado con éxito', vim.log.levels.INFO)