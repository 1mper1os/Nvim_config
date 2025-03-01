local status_ok, tailwindcss_colorizer_cmp = pcall(require, "tailwindcss-colorizer-cmp")
if not status_ok then
  return
end

tailwindcss_colorizer_cmp.setup({
  color_square_width = 2, 

  enabled = true,

  custom_colors = {}, 
})
