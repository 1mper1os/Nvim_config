local status_ok, comment = pcall(require, "Comment")
if not status_ok then
  return
end

comment.setup({
  padding = true,

  sticky = true,

  ignore = nil,

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
    line = "gcc",
    block = "gdd",
  },

  pre_hook = nil, 

  post_hook = nil,
})
