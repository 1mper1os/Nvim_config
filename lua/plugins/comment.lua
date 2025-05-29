
local status_ok, comment = pcall(require, "Comment")
if not status_ok then
  vim.notify("Failed to load Comment.nvim", vim.log.levels.ERROR)
  return
end


local ts_context_status_ok, ts_context = pcall(require, "ts_context_commentstring.integrations.comment_nvim")

comment.setup({

  padding = true,
  
 
  sticky = true,
  

  ignore = "^$", 
  

  mappings = {
    basic = true,    
    extra = true,    
    extended = false, 
  },
  

  toggler = {
    line = "gcc",  
    block = "gbc", 
  },
  

  opleader = {
    line = "gc",   
    block = "gb",  
  },
  

  pre_hook = ts_context_status_ok and ts_context.create_pre_hook() or nil,
  

  post_hook = function(ctx)
   
    if ctx.range.srow == ctx.range.erow then
     
      vim.api.nvim_win_set_cursor(0, { ctx.range.srow, 0 })
    end
  end,
})


local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }


keymap("i", "<C-_>", "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>", opts)


keymap("v", "<leader>/", "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", opts)


keymap("n", "<leader>cp", function()
  require("Comment.api").toggle.linewise("ip")
end, vim.tbl_extend("force", opts, { desc = "Comment paragraph" }))


vim.api.nvim_create_autocmd("FileType", {
  pattern = { "lua" },
  callback = function()
   
    vim.bo.commentstring = "-- %s"
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
  callback = function()
    
    vim.bo.commentstring = "// %s"
  end,
})

vim.notify("Comment.nvim loaded successfully", vim.log.levels.INFO)